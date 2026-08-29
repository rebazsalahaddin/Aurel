import AVFoundation
import Foundation
import Observation

// MARK: - Recorded course audio (audio-upgrade phase, Enhancement doc §2)
//
// The AudioPlaying seam's recorded-audio implementation: plays the bundled
// Gemini 3.1 Flash TTS takes line-by-line (one AVAudioPlayer per scripted line — a
// plain file player, never an engine graph, per AUSound's S0-003 rule), and
// falls back to the TTS `Speaker` whenever a reference has no catalog entry.
//
// Synchronization contract (one authoritative clock, one identity):
//   * The spoken position is whatever `AVAudioPlayer.currentTime` reports —
//     sampled by the 30 ms ticker, never an accumulated UI timer. Published
//     state is change-guarded so unchanged samples never invalidate views.
//   * `spokenAssetID` + `spokenLine` (the ABSOLUTE catalog line index)
//     identify the take being voiced. Karaoke rows match on that identity;
//     text equality is consulted only on the TTS fallback, where no catalog
//     asset exists, so duplicate or TTS-paced scripts stay deterministic.
//   * Every asynchronous completion (a finished line take) is validated
//     against the player it belongs to before it may advance the queue — a
//     stale completion from a superseded speak can never skip or
//     double-advance lines.
//
// Observable so progress-driven UI (the waveform tint today, karaoke text in
// Phase 4) re-renders reliably — the old plain-NSObject limitation.
//
// Launch safety: nothing audio-related happens until the first speak; the
// session category is configured lazily on first playback.

@MainActor
@Observable
final class VoicePlayback: NSObject, AudioPlaying {
    // AudioPlaying
    private(set) var speaking = false
    var isSpeaking: Bool { speaking }

    // Playback state for progress UI / karaoke (Phase 4).
    /// 0…1 across the whole spoken queue (recorded) or utterance (TTS).
    private(set) var progress: Double = 0
    /// ABSOLUTE index (within the asset's authored line list) of the line
    /// currently spoken, when playing recorded takes; -1 otherwise.
    private(set) var spokenLine: Int = -1
    /// 0…1 through the current line's audio.
    private(set) var lineProgress: Double = 0
    /// Estimated spoken character range within `spokenLineText` — karaoke
    /// highlighting for recorded takes (char-proportional within the line).
    private(set) var spokenRange: NSRange?
    /// The text of the line being spoken (nil outside recorded playback).
    private(set) var spokenLineText: String?
    /// The authored speaker of the line being spoken ("GUIDE", "ALEX", …);
    /// nil on the TTS fallback, which has no character identity. Karaoke
    /// rows match on it so two same-text speakers can't both light up.
    private(set) var spokenSpeaker: String?
    /// The asset whose takes are playing (nil on the TTS fallback path) —
    /// the identity karaoke rows match against. While it is set, text
    /// equality is never consulted, so equal texts on other rows (or other
    /// screens) can never light up.
    private(set) var spokenAssetID: String?

    let catalog: AudioCatalog
    private let tts: Speaker

    private var lines: [AudioCatalog.Line] = []
    /// Index of `lines[0]` within the asset's full authored line list, so
    /// line-scoped playback (a single conversation turn) still reports
    /// absolute `spokenLine` values.
    private var lineBase = 0
    private var lineIndex = 0
    private var charOffsets: [Int] = []  // UTF-16 prefix sums of line texts
    private var totalChars = 1
    private var player: AVAudioPlayer?
    /// Identity of `player` — the only value a nonisolated completion may
    /// carry across the MainActor hop (ObjectIdentifier is Sendable).
    private var playerID: ObjectIdentifier?
    /// Longest spoken prefix of the current line, in UTF-16 units — keeps the
    /// published range monotonic within a line.
    private var spokenPrefix = 0
    private var ticker: Task<Void, Never>?
    private var sessionConfigured = false
    /// Stop time for a clipped first-utterance play; nil plays the whole take.
    private var clipEnd: TimeInterval?

    init(catalog: AudioCatalog = AudioCatalog(), tts: Speaker = Speaker()) {
        self.catalog = catalog
        self.tts = tts
        super.init()
    }

    // MARK: AudioPlaying

    func speak(_ text: String, slow: Bool) {
        speak(audioID: nil, text: text, slow: slow)
    }

    /// Recorded-audio entry point: `audioID` is the FULL asset id
    /// ("A1-C01-AUD043" — chapter-scoped resolution happens in PlayerModel).
    /// A catalog hit plays the bundled line takes; a miss falls back to TTS
    /// with the passed text. `lineIndex` plays one scripted line only
    /// (a single conversation turn).
    func speak(audioID: String?, text: String, slow: Bool, lineIndex at: Int? = nil) {
        stop()
        guard let audioID,
            let asset = catalog.asset(audioID),
            !asset.lines.isEmpty
        else {
            beginFallback(text, slow: slow)
            return
        }

        if let at, asset.lines.indices.contains(at) {
            // Line-scoped playback (a single conversation turn).
            begin([asset.lines[at]], assetID: audioID, lineBase: at, clip: .full)
            return
        }

        if text.isEmpty {
            begin(asset.lines, assetID: audioID, lineBase: 0, clip: .full)
            return
        }

        guard let take = Self.selectTake(lines: asset.lines, requestedText: text) else {
            // The item authored this take. A cue that does not map to a clip
            // (picture-alt fragments, answer text vs a question take) must
            // still play the file — never a robotic system voice.
            begin(asset.lines, assetID: audioID, lineBase: 0, clip: .full)
            return
        }

        switch take {
        case .allLines:
            begin(asset.lines, assetID: audioID, lineBase: 0, clip: .full)
        case .line(let index, let clip):
            guard asset.lines.indices.contains(index) else {
                beginFallback(text, slow: slow)
                return
            }
            begin([asset.lines[index]], assetID: audioID, lineBase: index, clip: clip)
        }
    }

    /// Letters/digits/spaces lowercase fold for audio-text containment:
    /// “Hello … Thank you.” → "hello thank you", “A, B, C” → "a b c".
    static func heardWords(_ text: String) -> String {
        let folded = text.lowercased().unicodeScalars.map { scalar -> Character in
            CharacterSet.alphanumerics.contains(scalar) ? Character(scalar) : " "
        }
        return String(folded)
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    /// Ellipsis-separated scripted phrases: “Hello. … Hello.” → ["Hello.", "Hello."].
    static func ellipsisSegments(_ text: String) -> [String] {
        text.components(separatedBy: "…")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    /// Comma-separated tokens from a count-along or alphabet chant.
    static func commaTokens(_ text: String) -> [String] {
        text.split(separator: ",").map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
                .trimmingCharacters(in: CharacterSet.punctuationCharacters)
        }
        .filter { !$0.isEmpty }
    }

    /// Learner-facing card copy with slash-alternates and ellipsis blanks removed.
    static func cleanCardWord(_ word: String) -> String {
        var text = word
        if let slash = text.firstIndex(of: "/") {
            text = String(text[..<slash])
        }
        text = text.replacingOccurrences(of: "…", with: "")
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Which catalog take (and which phrase inside it) should voice `requestedText`.
    /// `nil` means no clip mapped; `speak` still plays the full bundled take.
    static func selectTake(
        lines: [AudioCatalog.Line], requestedText: String
    ) -> TakeSelection? {
        guard !lines.isEmpty else { return nil }
        let heard = heardWords(requestedText)
        let fullHeard = heardWords(lines.map(\.text).joined(separator: " "))
        if heard.isEmpty || heard == fullHeard {
            return .allLines
        }

        if let index = lines.firstIndex(where: { heardWords($0.text) == heard }) {
            let segs = ellipsisSegments(lines[index].text)
            if segs.count >= 2, Set(segs.map(heardWords)).count == 1 {
                return .line(index: index, clip: .ellipsisSegment(index: 0, count: segs.count))
            }
            return .line(index: index, clip: .full)
        }

        for (index, line) in lines.enumerated() {
            let segs = ellipsisSegments(line.text)
            if let segment = ellipsisSegmentIndex(
                matching: heard, in: segs, requestedText: requestedText)
            {
                if segs.count == 1 {
                    return .line(index: index, clip: .full)
                }
                return .line(
                    index: index, clip: .ellipsisSegment(index: segment, count: segs.count))
            }
        }

        for (index, line) in lines.enumerated() {
            let segs = ellipsisSegments(line.text)
            guard let first = segs.first else { continue }
            let tokens = commaTokens(first)
            if tokens.count >= 3,
                let token = tokens.firstIndex(where: { heardWords($0) == heard })
            {
                return .line(
                    index: index, clip: .commaToken(index: token, count: tokens.count))
            }
        }

        let requestTokens = heard.split(separator: " ").map(String.init)
        for (index, line) in lines.enumerated() {
            let segs = ellipsisSegments(line.text)
            guard let first = segs.first else { continue }
            let firstHeard = heardWords(first)
            let firstTokens = firstHeard.split(separator: " ").map(String.init)
            let isPrefix =
                firstHeard.hasPrefix(heard + " ")
                || (firstTokens.starts(with: requestTokens) && firstTokens.count > requestTokens.count)
            guard isPrefix, !requestTokens.isEmpty else { continue }
            return .line(
                index: index,
                clip: segs.count > 1 ? .ellipsisSegment(index: 0, count: segs.count) : .full)
        }

        for (index, line) in lines.enumerated() {
            let segs = ellipsisSegments(line.text)
            if let segment = segs.firstIndex(where: {
                containsHeardRun(in: $0, heardNeedle: heard)
            }) {
                if segs.count == 1 {
                    return .line(index: index, clip: .full)
                }
                return .line(
                    index: index, clip: .ellipsisSegment(index: segment, count: segs.count))
            }
        }

        if fullHeard.contains(heard), heard.count >= fullHeard.count / 2 {
            return .allLines
        }
        return nil
    }

    /// When several ellipsis phrases fold to the same words, keep statement vs
    /// question distinct (“You're Maya.” vs “You're Maya?”).
    static func ellipsisSegmentIndex(
        matching heard: String, in segs: [String], requestedText: String
    ) -> Int? {
        let matches = segs.indices.filter { heardWords(segs[$0]) == heard }
        guard let first = matches.first else { return nil }
        if matches.count == 1 { return first }
        let wantQuestion = requestedText.trimmingCharacters(in: .whitespacesAndNewlines)
            .hasSuffix("?")
        return matches.first(where: {
            segs[$0].trimmingCharacters(in: .whitespacesAndNewlines).hasSuffix("?")
                == wantQuestion
        }) ?? first
    }

    /// True when `heardNeedle` (already `heardWords`-folded) is a consecutive
    /// token run inside `haystack` — so “morning” maps to “Good morning.”.
    static func containsHeardRun(in haystack: String, heardNeedle: String) -> Bool {
        let hay = heardWords(haystack).split(separator: " ").map(String.init)
        let need = heardNeedle.split(separator: " ").map(String.init)
        guard !need.isEmpty, hay.count >= need.count else { return false }
        for start in 0...(hay.count - need.count) {
            if hay[start..<(start + need.count)].elementsEqual(need) { return true }
        }
        return false
    }

    enum TakeSelection: Equatable {
        case allLines
        case line(index: Int, clip: Clip)

        enum Clip: Equatable {
            case full
            case ellipsisSegment(index: Int, count: Int)
            case commaToken(index: Int, count: Int)
        }
    }

    func stop() {
        ticker?.cancel()
        ticker = nil
        player?.stop()
        player = nil
        playerID = nil
        tts.stop()
        speaking = false
        progress = 0
        lineProgress = 0
        spokenLine = -1
        spokenPrefix = 0
        spokenRange = nil
        spokenLineText = nil
        spokenSpeaker = nil
        spokenAssetID = nil
        clipEnd = nil
        AUSound.shared.isDucked = false
    }

    /// Fallback-path matching (no catalog asset was resolved for the take):
    /// text equality, with the speaker narrowing same-text rows. The
    /// recorded path never matches on text — use `isSpoken(audioID:…)`.
    func isSpoken(text: String, speaker: String? = nil) -> Bool {
        guard speaking, spokenAssetID == nil, spokenLineText == text else { return false }
        guard let spokenSpeaker, let speaker, !speaker.isEmpty else { return true }
        return spokenSpeaker.caseInsensitiveCompare(speaker) == .orderedSame
    }

    /// Identity matching for one rendered line: true while the asset that
    /// voices `text` is the one playing AND its currently spoken catalog
    /// line is the one this text aligns to (see `KaraokeTimeline`). On the
    /// TTS fallback it degrades to text matching.
    ///
    /// Multi-row surfaces should prefer row-index matching
    /// (`PlayerModel.isSpeakingRow`) — this single-row form maps a text on
    /// its own and so cannot disambiguate duplicated lines.
    func isSpoken(audioID: String?, text: String, speaker: String? = nil) -> Bool {
        if speaking, let current = spokenAssetID {
            guard let audioID, !audioID.isEmpty, audioID == current else { return false }
            guard let queued = spokenRowIndex(for: text, speaker: speaker) else { return false }
            return lineBase + queued == spokenLine
        }
        return isSpoken(text: text, speaker: speaker)
    }

    /// The queue line that voices `text`, per the dialogue timeline resolver.
    private func spokenRowIndex(for text: String, speaker: String?) -> Int? {
        guard !lines.isEmpty else { return nil }
        let row = KaraokeTimeline.Row(speaker: speaker, text: text)
        return KaraokeTimeline.align(rows: [row], lines: lines)[0]
    }

    // MARK: Recorded queue

    private func begin(
        _ lines: [AudioCatalog.Line], assetID: String, lineBase: Int,
        clip: TakeSelection.Clip
    ) {
        guard let url = catalog.url(for: lines[0]) else {
            // Missing file for a cataloged line — degrade to TTS.
            beginFallback(lines.map(\.text).joined(separator: " "), slow: true)
            return
        }
        configureSessionIfNeeded()

        self.lines = lines
        self.lineBase = lineBase
        spokenAssetID = assetID
        lineIndex = 0
        charOffsets = [0]
        for line in lines {
            // UTF-16 throughout — `spokenRange` reports the same units.
            charOffsets.append(charOffsets.last! + (line.text as NSString).length + 1)
        }
        totalChars = max(1, charOffsets.last!)

        // Feedback sounds never talk over the voice (IMPROVEMENT_PLAN §2.6).
        AUSound.shared.isDucked = true
        playLine(at: 0, url: url, clip: clip)
    }

    private func configureSessionIfNeeded() {
        guard !sessionConfigured else { return }
        sessionConfigured = true
        // Off the main thread (S0-003): the player spins up while the
        // session activates beside it.
        AudioSessionGate.enqueuePlaybackActivation()
    }

    private func beginFallback(_ text: String, slow: Bool) {
        spokenLine = -1
        spokenSpeaker = nil
        spokenAssetID = nil
        // Single-line fallback speech can still karaoke: the synthesizer
        // reports exact word ranges, and rows match on this text.
        spokenLineText = text
        spokenRange = nil
        spokenPrefix = 0
        tts.speak(text, slow: slow)
        speaking = tts.isSpeaking
        ticker?.cancel()
        ticker = Task { [weak self] in
            while !Task.isCancelled, let self, self.tts.isSpeaking {
                self.progress = self.tts.progress
                self.spokenRange = self.tts.spokenRange
                try? await Task.sleep(for: .milliseconds(30))
            }
            guard !Task.isCancelled, let self else { return }
            self.speaking = false
            self.progress = self.tts.progress
            if let text = self.spokenLineText, !text.isEmpty {
                self.spokenRange = NSRange(location: 0, length: (text as NSString).length)
            }
            self.ticker = nil
        }
    }

    private func playLine(at index: Int, url: URL, clip: TakeSelection.Clip = .full) {
        do {
            let p = try AVAudioPlayer(contentsOf: url)
            p.delegate = self
            p.prepareToPlay()
            if let range = Self.playbackRange(url: url, clip: clip, duration: p.duration) {
                p.currentTime = range.lowerBound
                clipEnd = range.upperBound
            } else {
                clipEnd = nil
            }
            p.play()
            player = p
            playerID = ObjectIdentifier(p)
            lineIndex = index
            spokenLine = lineBase + index
            spokenLineText = lines.indices.contains(index) ? lines[index].text : nil
            spokenSpeaker = lines.indices.contains(index) ? lines[index].speaker : nil
            // Per-line karaoke state starts from a clean slate: the previous
            // line's (near-full) range must never paint the new line's first
            // frame, and the spoken prefix must not carry over.
            setLineProgress(0)
            spokenPrefix = 0
            setSpokenRange(nil)
            speaking = true
            startTicker()
        } catch {
            // A wedged audio server can cost a take, never the app (S0-003).
            advanceOrFinish()
        }
    }

    private static func playbackRange(
        url: URL, clip: TakeSelection.Clip, duration: TimeInterval
    ) -> Range<TimeInterval>? {
        switch clip {
        case .full:
            return nil
        case .ellipsisSegment(let index, let count):
            let ranges = AudioUtteranceLocator.ellipsisRanges(
                url: url, expectedSegments: count, duration: duration)
            guard ranges.indices.contains(index) else { return nil }
            return padded(ranges[index], duration: duration)
        case .commaToken(let index, let count):
            let islands = AudioUtteranceLocator.speechIslands(url: url)
            let group = islands.count >= count * 2 - 1 ? Array(islands.prefix(count)) : islands
            guard group.indices.contains(index) else { return nil }
            return padded(group[index], duration: duration)
        }
    }

    private static func padded(
        _ range: Range<TimeInterval>, duration: TimeInterval
    ) -> Range<TimeInterval> {
        let start = max(0, range.lowerBound - 0.04)
        let end = min(duration, range.upperBound + 0.14)
        guard end - start > 0.08 else { return range }
        return start..<end
    }

    private func startTicker() {
        ticker?.cancel()
        // The class is @MainActor and Task inherits the actor — tick() runs
        // on the main thread every 30 ms while a take plays.
        ticker = Task { [weak self] in
            while !Task.isCancelled {
                self?.tick()
                try? await Task.sleep(for: .milliseconds(30))
            }
        }
    }

    /// Samples the authoritative media clock and publishes karaoke state.
    /// Change-guarded: an unchanged sample never invalidates a view.
    private func tick() {
        guard let player, speaking else { return }
        if let clipEnd, player.currentTime >= clipEnd {
            playerID = nil
            player.stop()
            self.player = nil
            self.clipEnd = nil
            advanceOrFinish()
            return
        }
        let dur = max(0.01, player.duration)
        let ratio = min(1, max(0, player.currentTime / dur))
        setLineProgress(ratio)

        if let text = spokenLineText, !text.isEmpty {
            // UTF-16 units throughout — the synthesizer reports its exact
            // ranges in the same units, so the two paths stay interchangeable.
            let total = (text as NSString).length
            let len = Int((Double(total) * ratio).rounded())
            // Monotonic within the line — sampling jitter must not rewind it.
            spokenPrefix = min(total, max(spokenPrefix, len))
            setSpokenRange(
                spokenPrefix > 0 ? NSRange(location: 0, length: spokenPrefix) : nil)
        }
        let before = charOffsets.indices.contains(lineIndex) ? charOffsets[lineIndex] : 0
        let lineChars = Double((spokenLineText as NSString?)?.length ?? 1)
        let done = Double(before) + lineChars * ratio
        setProgress(min(1, done / Double(totalChars)))
    }

    private func advanceOrFinish() {
        guard speaking else { return }
        guard lines.indices.contains(lineIndex + 1),
            let url = catalog.url(for: lines[lineIndex + 1])
        else {
            finish()
            return
        }
        playLine(at: lineIndex + 1, url: url, clip: .full)
    }

    private func finish() {
        speaking = false
        setProgress(1)
        setLineProgress(1)
        if let text = spokenLineText {
            setSpokenRange(NSRange(location: 0, length: (text as NSString).length))
        }
        ticker?.cancel()
        ticker = nil
        player = nil
        playerID = nil
        AUSound.shared.isDucked = false
    }

    // MARK: Change-guarded publishing

    private func setLineProgress(_ value: Double) {
        guard abs(value - lineProgress) > 0.0005 else { return }
        lineProgress = value
    }

    private func setProgress(_ value: Double) {
        guard abs(value - progress) > 0.0005 else { return }
        progress = value
    }

    private func setSpokenRange(_ value: NSRange?) {
        guard value != spokenRange else { return }
        spokenRange = value
    }
}

extension VoicePlayback: AVAudioPlayerDelegate {
    nonisolated func audioPlayerDidFinishPlaying(
        _ player: AVAudioPlayer, successfully flag: Bool
    ) {
        // Only the take that is STILL the current player may advance the
        // queue. A completion from a superseded player (the learner replayed
        // or switched audio before this MainActor hop ran) is dropped here —
        // otherwise it would advance, and skip a line of, the wrong queue.
        let finished = ObjectIdentifier(player)
        Task { @MainActor [weak self] in
            guard let self, self.playerID == finished else { return }
            self.advanceOrFinish()
        }
    }
}

// MARK: - Phrase windows inside a word-model take

/// Finds the spoken islands and ellipsis pauses of a bundled WAV so a doubled
/// word model (“Hello. … Hello.”) can play the first phrase only.
@MainActor
enum AudioUtteranceLocator {
    private static var rmsCache: [String: (duration: TimeInterval, windows: [(TimeInterval, Float)])] =
        [:]

    static func speechIslands(url: URL) -> [Range<TimeInterval>] {
        guard let rms = rmsWindows(url: url) else { return [] }
        var islands: [Range<TimeInterval>] = []
        var inSpeech = false
        var start: TimeInterval = 0
        var lastVoice: TimeInterval = 0
        let thresh: Float = 0.025
        let minGap: TimeInterval = 0.35
        let minSpeech: TimeInterval = 0.12

        for (time, level) in rms.windows {
            if level >= thresh {
                if !inSpeech {
                    inSpeech = true
                    start = time
                }
                lastVoice = time
            } else if inSpeech, time - lastVoice >= minGap {
                if lastVoice - start >= minSpeech {
                    islands.append(start..<lastVoice)
                }
                inSpeech = false
            }
        }
        if inSpeech, lastVoice - start >= minSpeech {
            islands.append(start..<lastVoice)
        }
        return islands
    }

    static func ellipsisRanges(
        url: URL, expectedSegments: Int, duration: TimeInterval
    ) -> [Range<TimeInterval>] {
        guard expectedSegments > 1, duration > 0, let rms = rmsWindows(url: url) else {
            return duration > 0 ? [0..<duration] : []
        }

        var gaps: [Range<TimeInterval>] = []
        var gapStart: TimeInterval?
        for (time, level) in rms.windows {
            if level < 0.025 {
                if gapStart == nil { gapStart = time }
            } else if let start = gapStart {
                if time - start >= 0.35 { gaps.append(start..<time) }
                gapStart = nil
            }
        }

        let internalGaps = gaps.filter {
            $0.lowerBound > 0.15 && $0.upperBound < duration - 0.12
        }
        let picked = Array(
            internalGaps.sorted { ($0.upperBound - $0.lowerBound) > ($1.upperBound - $1.lowerBound) }
                .prefix(expectedSegments - 1)
        )
        .sorted { $0.lowerBound < $1.lowerBound }

        guard picked.count == expectedSegments - 1 else {
            let islands = speechIslands(url: url)
            if islands.count == expectedSegments { return islands }
            return duration > 0 ? [0..<duration] : []
        }

        var ranges: [Range<TimeInterval>] = []
        var cursor: TimeInterval = 0
        for gap in picked {
            ranges.append(cursor..<gap.lowerBound)
            cursor = gap.upperBound
        }
        ranges.append(cursor..<duration)
        return ranges
    }

    private static func rmsWindows(
        url: URL, windowMs: Double = 20
    ) -> (duration: TimeInterval, windows: [(TimeInterval, Float)])? {
        let key = url.path
        if let cached = rmsCache[key] { return cached }
        guard let file = try? AVAudioFile(forReading: url) else { return nil }
        let format = file.processingFormat
        let frames = AVAudioFrameCount(file.length)
        guard frames > 0,
            let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frames)
        else { return nil }
        do {
            try file.read(into: buffer)
        } catch {
            return nil
        }
        guard let samples = buffer.floatChannelData?[0] else { return nil }
        let count = Int(buffer.frameLength)
        let sampleRate = format.sampleRate
        let window = max(1, Int(sampleRate * windowMs / 1000.0))
        var windows: [(TimeInterval, Float)] = []
        var offset = 0
        while offset < count {
            let end = min(count, offset + window)
            var sum: Float = 0
            var i = offset
            while i < end {
                let s = samples[i]
                sum += s * s
                i += 1
            }
            let n = Float(end - offset)
            windows.append((TimeInterval(offset) / sampleRate, sqrt(sum / n)))
            offset = end
        }
        let duration = TimeInterval(count) / sampleRate
        let result = (duration, windows)
        rmsCache[key] = result
        return result
    }
}
