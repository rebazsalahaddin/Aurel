import AVFoundation
import Foundation
import Observation

// MARK: - Recorded course audio (audio-upgrade phase, Enhancement doc §2)
//
// The AudioPlaying seam's recorded-audio implementation: plays the bundled
// ElevenLabs takes line-by-line (one AVAudioPlayer per scripted line — a
// plain file player, never an engine graph, per AUSound's S0-003 rule), and
// falls back to the TTS `Speaker` whenever a reference has no catalog entry.
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
    /// Index of the line currently spoken, when playing recorded takes.
    private(set) var spokenLine: Int = -1
    /// 0…1 through the current line's audio.
    private(set) var lineProgress: Double = 0
    /// Estimated spoken character range within `spokenLineText` — karaoke
    /// highlighting for recorded takes (char-proportional within the line).
    private(set) var spokenRange: NSRange?
    /// The text of the line being spoken (nil outside recorded playback).
    private(set) var spokenLineText: String?

    private let catalog: AudioCatalog
    private let tts: Speaker

    private var lines: [AudioCatalog.Line] = []
    private var lineIndex = 0
    private var charOffsets: [Int] = []  // prefix sums of line text lengths
    private var totalChars = 1
    private var player: AVAudioPlayer?
    private var ticker: Task<Void, Never>?
    private var sessionConfigured = false

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

        var chosen = asset.lines
        if let at, chosen.indices.contains(at) {
            // Line-scoped playback (a single conversation turn).
            chosen = [chosen[at]]
        }
        begin(chosen)
    }

    func stop() {
        ticker?.cancel()
        ticker = nil
        player?.stop()
        player = nil
        tts.stop()
        speaking = false
        progress = 0
        lineProgress = 0
        spokenLine = -1
        spokenRange = nil
        spokenLineText = nil
        AUSound.shared.isDucked = false
    }

    // MARK: Recorded queue

    private func begin(_ lines: [AudioCatalog.Line]) {
        guard let url = catalog.url(for: lines[0]) else {
            // Missing file for a cataloged line — degrade to TTS.
            beginFallback(lines.map(\.text).joined(separator: " "), slow: true)
            return
        }
        configureSessionIfNeeded()

        self.lines = lines
        lineIndex = 0
        charOffsets = [0]
        for line in lines {
            charOffsets.append(charOffsets.last! + line.text.count + 1)
        }
        totalChars = max(1, charOffsets.last!)

        // Feedback sounds never talk over the voice (IMPROVEMENT_PLAN §2.6).
        AUSound.shared.isDucked = true
        playLine(at: 0, url: url)
    }

    private func configureSessionIfNeeded() {
        guard !sessionConfigured else { return }
        sessionConfigured = true
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .spokenAudio)
        try? session.setActive(true)
    }

    private func beginFallback(_ text: String, slow: Bool) {
        spokenLine = -1
        spokenLineText = nil
        spokenRange = nil
        tts.speak(text, slow: slow)
        speaking = tts.isSpeaking
        ticker?.cancel()
        ticker = Task { [weak self] in
            while !Task.isCancelled, let self, self.tts.isSpeaking {
                self.progress = self.tts.progress
                try? await Task.sleep(for: .milliseconds(30))
            }
            guard !Task.isCancelled, let self else { return }
            self.speaking = false
            self.progress = self.tts.progress
            self.ticker = nil
        }
    }

    private func playLine(at index: Int, url: URL) {
        do {
            let p = try AVAudioPlayer(contentsOf: url)
            p.delegate = self
            p.play()
            player = p
            lineIndex = index
            spokenLine = index
            spokenLineText = lines.indices.contains(index) ? lines[index].text : nil
            speaking = true
            startTicker()
        } catch {
            // A wedged audio server can cost a take, never the app (S0-003).
            advanceOrFinish()
        }
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

    private func tick() {
        guard let player, speaking else { return }
        let dur = max(0.01, player.duration)
        lineProgress = min(1, player.currentTime / dur)

        if let text = spokenLineText, !text.isEmpty {
            let len = Int((Double(text.count) * lineProgress).rounded())
            spokenRange = NSRange(location: 0, length: min(text.count, len))
        }
        let before = charOffsets.indices.contains(lineIndex) ? charOffsets[lineIndex] : 0
        let lineChars = Double(spokenLineText?.count ?? 1)
        let done = Double(before) + lineChars * lineProgress
        progress = min(1, done / Double(totalChars))
    }

    private func advanceOrFinish() {
        guard lines.indices.contains(lineIndex + 1),
            let url = catalog.url(for: lines[lineIndex + 1])
        else {
            finish()
            return
        }
        playLine(at: lineIndex + 1, url: url)
    }

    private func finish() {
        speaking = false
        progress = 1
        lineProgress = 1
        if let text = spokenLineText {
            spokenRange = NSRange(location: 0, length: text.count)
        }
        ticker?.cancel()
        ticker = nil
        player = nil
        AUSound.shared.isDucked = false
    }
}

extension VoicePlayback: AVAudioPlayerDelegate {
    nonisolated func audioPlayerDidFinishPlaying(
        _ player: AVAudioPlayer, successfully flag: Bool
    ) {
        Task { @MainActor in
            self.advanceOrFinish()
        }
    }
}
