import AVFoundation
import Foundation
import Network
import Speech

// MARK: - Audio playback
//
// Governance: recordings are "scripts only" — nothing may be fabricated.
// VoicePlayback is the release implementation; the on-device synthesizer is
// retained only as a launch-safe fallback for missing/unmapped content.
@MainActor
protocol AudioPlaying {
    func speak(_ text: String, slow: Bool)
    /// Recorded-audio path (audio-upgrade phase): implementations that own an audio
    /// catalog resolve `audioID` (the full "A1-C01-AUD043" asset id) to the
    /// bundled takes; everyone else falls back to the text.
    func speak(audioID: String?, text: String, slow: Bool, lineIndex: Int?)
    func stop()
    var isSpeaking: Bool { get }
}

extension AudioPlaying {
    /// Text-only conformers (the TTS Speaker) simply speak the text.
    func speak(audioID: String?, text: String, slow: Bool, lineIndex: Int? = nil) {
        speak(text, slow: slow)
    }
}

@MainActor
final class Speaker: NSObject, AudioPlaying, AVSpeechSynthesizerDelegate {
    private(set) var speaking = false
    var isSpeaking: Bool { speaking }

    /// §3.16(e): utterance progress 0…1 (character range / total) — the
    /// native-line waveform tints along it while TTS speaks. Real data from
    /// the synthesizer delegate, never an assumed duration.
    private(set) var progress: Double = 0
    /// The exact UTF-16 range the synthesizer is currently voicing (word
    /// boundaries straight from the engine) — karaoke highlighting on the
    /// TTS-fallback path keys off this instead of estimating.
    private(set) var spokenRange: NSRange?
    private var spokenChars: Double = 0
    private var totalChars: Double = 1

    private let synthesizer = AVSpeechSynthesizer()
    private var sessionConfigured = false

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String, slow: Bool) {
        stop()
        if !sessionConfigured {
            sessionConfigured = true
            let session = AVAudioSession.sharedInstance()
            try? session.setCategory(.playback, mode: .spokenAudio)
            try? session.setActive(true)
        }
        // Feedback sounds never talk over the voice (IMPROVEMENT_PLAN §2.6).
        AUSound.shared.isDucked = true
        // Learning takes ≈100–110 wpm; challenge ≈120–130 wpm
        // (AUDIO_STYLE_GUIDE.md) — AVSpeech rate 0.42 ≈ 108 wpm.
        let u = AVSpeechUtterance(string: text)
        u.rate = slow ? 0.36 : 0.42
        u.pitchMultiplier = 1.0
        u.postUtteranceDelay = 0.35  // thought-boundary pause feel
        if let voice = AVSpeechSynthesisVoice(language: "en-US") {
            u.voice = voice
        }
        synthesizer.speak(u)
        speaking = true
        progress = 0
        spokenRange = nil
        spokenChars = 0
        totalChars = Double(max(1, text.count))
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        speaking = false
        progress = 0
        spokenRange = nil
        AUSound.shared.isDucked = false
    }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            self.speaking = false
            AUSound.shared.isDucked = false
        }
    }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        willSpeakRangeOfSpeechString characterRange: NSRange,
        utterance: AVSpeechUtterance
    ) {
        let end = Double(characterRange.location + characterRange.length)
        let total = Double(max(1, utterance.speechString.count))
        Task { @MainActor in
            // Monotonic: out-of-order delegate callbacks must not rewind it.
            self.spokenChars = max(self.spokenChars, end)
            self.progress = min(1, self.spokenChars / max(total, self.totalChars, 1))
            self.spokenRange = characterRange
        }
    }
}

// MARK: - Connectivity (NWPathMonitor → offline banner)

@MainActor
@Observable
final class Connectivity {
    var isOnline = true

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "aurel.connectivity")

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let online = path.status == .satisfied
            DispatchQueue.main.async {
                self?.isOnline = online
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}

// MARK: - Review scheduler (spaced retrieval, master prompt §7.5)
//
// The scheduler is app logic; the course supplies retrieval opportunities.
// Intervals widen 1 → 3 → 7 → 14 → 30 days; an item leaves the queue after
// the 30-day success.

enum ReviewScheduler {
    static let intervals: [Int] = [1, 3, 7, 14, 30]

    /// The next interval after a successful catch, nil when mastered.
    static func nextInterval(after interval: Int) -> Int? {
        guard let idx = intervals.firstIndex(of: interval) else { return intervals.first }
        let next = idx + 1
        return next < intervals.count ? intervals[next] : nil
    }

    /// Due date display for the review list ("Due tomorrow" / "Due in N days").
    static func dueLabel(for date: Date, now: Date = Date()) -> String {
        let cal = Calendar.current
        let days =
            cal.dateComponents(
                [.day], from: cal.startOfDay(for: now), to: cal.startOfDay(for: date)
            ).day ?? 0
        if days <= 0 { return "Due today" }
        if days == 1 { return "Due tomorrow" }
        return "Due in \(days) days"
    }
}

// MARK: - Streak engine (non-punitive, two grace days a month)
//
// A day counts only when both halves are done (lesson + recall). Missing a
// day consumes a grace token before the streak resets — never destroyed
// instantly (governance: "no punitive streak destruction").

enum StreakEngine {
    static let graceDaysPerMonth = 2

    /// Whether the learner's day is complete.
    static func dayComplete(lesson: Bool, recall: Bool) -> Bool {
        lesson && recall
    }

    /// Grace tokens left this month.
    static func graceRemaining(usedThisMonth: Int) -> Int {
        max(0, graceDaysPerMonth - usedThisMonth)
    }

    /// The calendar-month stamp (YYYYMM) a date belongs to.
    static func monthStamp(_ date: Date, calendar: Calendar = .current) -> Int {
        calendar.component(.year, from: date) * 100 + calendar.component(.month, from: date)
    }

    /// The closing-day ruling when a new day begins (S1-009). A complete
    /// closing day carries the chain; a single missed or partial day may
    /// consume one of the month's two grace tokens instead of resetting
    /// (governance: no punitive streak destruction); a gap of more than one
    /// day resets — grace is for isolated misses. Token spend is tracked per
    /// calendar month of the new day.
    static func rolloverRuling(
        closingDayCounted: Bool,
        gapDays: Int,
        graceMonth: Int,
        graceUsed: Int,
        today: Date,
        calendar: Calendar = .current
    ) -> (chainContinues: Bool, graceMonth: Int, graceUsed: Int) {
        let month = monthStamp(today, calendar: calendar)
        var used = graceMonth == month ? graceUsed : 0
        if closingDayCounted { return (true, month, used) }
        if gapDays == 1 && used < graceDaysPerMonth {
            used += 1
            return (true, month, used)
        }
        return (false, month, used)
    }
}

// MARK: - Speech recognition (say-aloud; on-device, optional)
//
// The tap path is always available and equal in weight; recognition never
// blocks and never leaves the device.

@MainActor
@Observable
final class SpeechToText: NSObject, SFSpeechRecognizerDelegate {
    var transcript = ""
    var listening = false
    private(set) var authorized = false

    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?

    var supportsOnDeviceRecognition: Bool {
        recognizer?.supportsOnDeviceRecognition == true
    }

    var canRecognizeOnDevice: Bool {
        Self.permitsCapture(
            authorized: authorized,
            supportsOnDeviceRecognition: supportsOnDeviceRecognition
        )
    }

    static func permitsCapture(
        authorized: Bool,
        supportsOnDeviceRecognition: Bool
    ) -> Bool {
        authorized && supportsOnDeviceRecognition
    }

    @discardableResult
    func requestAuthorization() async -> Bool {
        let status: SFSpeechRecognizerAuthorizationStatus = await withCheckedContinuation { cont in
            SFSpeechRecognizer.requestAuthorization { cont.resume(returning: $0) }
        }
        authorized = status == .authorized
        return canRecognizeOnDevice
    }

    func start() async throws {
        guard let recognizer, canRecognizeOnDevice else { return }
        stop()

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .measurement)
        try session.setActive(true)

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.requiresOnDeviceRecognition = true
        self.request = request

        let input = audioEngine.inputNode
        let format = input.outputFormat(forBus: 0)
        input.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        listening = true

        task = recognizer.recognitionTask(with: request) { [weak self] result, _ in
            Task { @MainActor in
                if let result {
                    self?.transcript = result.bestTranscription.formattedString
                }
            }
        }
    }

    func stop() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        task?.cancel()
        request?.endAudio()
        request = nil
        listening = false
    }

    /// §3.16(c): transcribe a finished take file — the clarity check runs
    /// after the take, not as live dictation. On-device recognition is a
    /// hard precondition; nil when recognition is unavailable
    /// (unauthorized, unsupported locale, or recognizer failure — the caller
    /// renders an honest no-verdict state).
    func transcribe(url: URL) async -> String? {
        guard let recognizer, canRecognizeOnDevice else { return nil }
        let request = SFSpeechURLRecognitionRequest(url: url)
        request.requiresOnDeviceRecognition = true
        return await withCheckedContinuation { cont in
            var resumed = false
            let task = recognizer.recognitionTask(with: request) { result, error in
                guard !resumed else { return }
                if let result, result.isFinal {
                    resumed = true
                    cont.resume(returning: result.bestTranscription.formattedString)
                } else if error != nil {
                    resumed = true
                    cont.resume(returning: nil)
                }
                // Partial results keep waiting; a short take resolves fast.
            }
            // A wedged recognizer must not hang the take flow forever.
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(4))
                guard !resumed else { return }
                task.cancel()
                resumed = true
                cont.resume(returning: nil)
            }
        }
    }
}

// MARK: - Microphone metering + take recording (IMPROVEMENT_PLAN.md §3.16)

/// The mic-permission tri-state (§3.16d) — a denial is a state to render,
/// never an error.
enum MicPermission { case granted, denied, undetermined }

/// The recorder seam the say-aloud flow talks to — `MicRecorder` in the app,
/// an honest fake in unit tests (the coordination is the test target, not
/// the audio server).
@MainActor
protocol TakeRecording: AnyObject {
    var level: Double { get }
    var samples: [Double] { get }
    var isRecording: Bool { get }
    func start() throws
    @discardableResult func stop() -> URL?
    func discardTake(_ url: URL?)
}

extension MicRecorder: TakeRecording {}

/// Real amplitude metering for the say-aloud take: `AVAudioRecorder` with
/// metering enabled, sampled onto the main actor while the take window
/// runs. The take file is a throwaway in the temp directory, handed to the
/// recognizer and deleted — nothing the learner says is ever kept
/// (governance). Every failure path fails soft: a wedged audio server can
/// cost a take, never the app (the Stage-2 S0-003 lesson).
@MainActor
@Observable
final class MicRecorder {
    /// The live average-power level, normalized 0…1 (−60 dBFS floor).
    private(set) var level: Double = 0
    /// The take's sampled amplitude history, most recent last — the bars
    /// LiveWaveform renders.
    private(set) var samples: [Double] = []
    private(set) var isRecording = false

    private var recorder: AVAudioRecorder?
    private var meterTask: Task<Void, Never>?
    private var fileURL: URL {
        URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("aurel-take.m4a")
    }

    /// The current mic permission (no prompt).
    static var micPermission: MicPermission {
        switch AVAudioApplication.shared.recordPermission {
        case .granted: return .granted
        case .denied: return .denied
        case .undetermined: return .undetermined
        @unknown default: return .undetermined
        }
    }

    /// Prompt for mic permission when undetermined.
    static func requestMicPermission() async -> MicPermission {
        if micPermission != .undetermined { return micPermission }
        let granted = await AVAudioApplication.requestRecordPermission()
        return granted ? .granted : .denied
    }

    /// Begin a take: records to the temp file and meters amplitude until
    /// `stop()`. Throws only on construction failures — callers degrade.
    func start() throws {
        stop()
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
        try session.setActive(true)
        try? FileManager.default.removeItem(at: fileURL)
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue,
        ]
        let rec = try AVAudioRecorder(url: fileURL, settings: settings)
        rec.isMeteringEnabled = true
        guard rec.record() else {
            throw NSError(
                domain: "aurel.mic", code: 1,
                userInfo: [NSLocalizedDescriptionKey: "recorder failed to start"])
        }
        recorder = rec
        isRecording = true
        level = 0
        samples = []
        meterTask = Task { @MainActor [weak self] in
            while self?.isRecording == true {
                guard let self else { return }
                self.recorder?.updateMeters()
                let power = self.recorder?.averagePower(forChannel: 0) ?? -120
                let norm = max(0, min(1, Double(power + 60) / 60))  // −60 dBFS floor
                self.level = norm
                self.samples.append(norm)
                try? await Task.sleep(for: .milliseconds(70))
            }
        }
    }

    /// End the take. Returns the take's file URL (nil when the recorder
    /// never captured), and discards the recorder. The session returns to
    /// the standing playback category so TTS and feedback sounds stay
    /// themselves after a take.
    @discardableResult
    func stop() -> URL? {
        meterTask?.cancel()
        meterTask = nil
        let url = recorder?.url
        let wasRecording = recorder?.isRecording ?? false
        recorder?.stop()
        recorder = nil
        isRecording = false
        // Restore the Speaker's standing session (playback / spoken audio).
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
        guard wasRecording else { return nil }
        return url
    }

    /// The take file is handed to the recognizer, then deleted — nothing
    /// the learner says is ever kept.
    func discardTake(_ url: URL?) {
        guard let url else { return }
        try? FileManager.default.removeItem(at: url)
    }
}

// MARK: - Clarity verdict (§3.16c — clarity-only, never accent scoring)

/// The say-aloud verdict tiers, from a word-level comparison of the take's
/// transcript with the target line. "Near" is a neutral tier by governance
/// (rendered calm, never error red); the check is clarity — did the words
/// come through in order — and nothing about accent.
enum SpeakVerdict {
    enum Tier: Equatable { case clear, near, nothingHeard }

    /// Normalize a line to its words: lowercase, punctuation stripped.
    static func words(_ line: String) -> [String] {
        line.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
    }

    /// Longest common subsequence length over words — order-aware overlap.
    static func lcs(_ a: [String], _ b: [String]) -> Int {
        guard !a.isEmpty, !b.isEmpty else { return 0 }
        var dp = Array(repeating: Array(repeating: 0, count: b.count + 1), count: a.count + 1)
        for i in 1...a.count {
            for j in 1...b.count {
                dp[i][j] =
                    a[i - 1] == b[j - 1] ? dp[i - 1][j - 1] + 1 : max(dp[i - 1][j], dp[i][j - 1])
            }
        }
        return dp[a.count][b.count]
    }

    /// The tier for a transcript against its target: clear (≥ 75% of the
    /// target's words, in order), near (≥ 30%), or nothing heard.
    static func evaluate(target: String, transcript: String) -> Tier {
        let t = words(target)
        let h = words(transcript)
        guard !t.isEmpty else { return h.isEmpty ? .nothingHeard : .clear }
        guard !h.isEmpty else { return .nothingHeard }
        let match = Double(lcs(t, h)) / Double(t.count)
        if match >= 0.75 { return .clear }
        if match >= 0.3 { return .near }
        return .nothingHeard
    }

    /// How many of the target's words the transcript kept, in order — the
    /// honest number the "near" verdict cites.
    static func wordsInOrder(target: String, transcript: String) -> (matched: Int, total: Int) {
        let t = words(target)
        return (min(lcs(t, words(transcript)), t.count), t.count)
    }
}

// MARK: - Say coach (§3.16 — the take flow, shared by Speak + pronProduce)

/// The take coordinator: permission gates, the 2.6 s window, real metering,
/// and the after-take clarity check. One instance is shared by the say-aloud
/// screen and the player's pronProduce items (§3.11c) — per-target records
/// keyed by the line/word being said. Every seam is injectable so unit tests
/// exercise the coordination without an audio server; production wires the
/// real `MicRecorder` + `SpeechToText`.
@MainActor
@Observable
final class SayCoach {
    /// One target's honest take record.
    struct Record: Equatable {
        var takes = 0
        var verdict: SpeakVerdict.Tier?
        /// Recognition was unavailable for the last take — renders the
        /// no-verdict note, never an invented tier.
        var unavailable = false
        var matchedWords = 0
        var totalWords = 0
    }

    // MARK: Seams (production defaults; tests inject fakes)

    var recorder: any TakeRecording = MicRecorder()
    /// Transcribe a finished take (nil → the honest unavailable state).
    var transcriber: @Sendable (URL) async -> String?
    /// A take may begin only when recognition is authorized and guaranteed
    /// on-device. Both seams are injectable for deterministic privacy tests.
    var onDeviceRecognitionProbe: () -> Bool
    var onDeviceRecognitionRequest: () async -> Bool
    /// Stops any model playback before the audio session changes to record.
    /// The owning environment/player supplies this hook so playback and a
    /// learner take can never overlap.
    var onCaptureWillBegin: () -> Void = {}
    /// The current mic permission (no prompt).
    var micPermissionProbe: () -> MicPermission = { MicRecorder.micPermission }
    /// Prompt when undetermined (never at launch — the prompt belongs to
    /// the learner's own tap).
    var micPermissionRequest: () async -> MicPermission = {
        await MicRecorder.requestMicPermission()
    }

    private let speech = SpeechToText()

    // MARK: Live state

    private(set) var recording = false
    private(set) var assessing = false
    private(set) var preparingRecognition = false
    private(set) var micDenied = false
    /// Per-target records, keyed by the target text.
    private(set) var records: [String: Record] = [:]
    /// The target of the running / last take.
    private(set) var activeTarget = ""
    private var stopTask: Task<Void, Never>?
    private var recognitionPreparationGeneration = 0

    init() {
        let speech = self.speech
        transcriber = { url in await speech.transcribe(url: url) }
        onDeviceRecognitionProbe = { speech.canRecognizeOnDevice }
        onDeviceRecognitionRequest = { await speech.requestAuthorization() }
    }

    /// The record for the active target (empty when never attempted).
    var record: Record { records[activeTarget] ?? Record() }

    /// The record for a specific target word/line.
    func record(for target: String) -> Record {
        records[target] ?? Record()
    }

    /// The live metering the waveform renders.
    var samples: [Double] { recorder.samples }
    var level: Double { recorder.level }

    // MARK: Flow

    /// Toggle a take for `target` — start when idle, stop when running.
    func toggle(target: String) {
        if recording {
            finish()
            return
        }
        begin(target: target)
    }

    private func begin(target: String) {
        guard !preparingRecognition else { return }
        guard onDeviceRecognitionProbe() else {
            preparingRecognition = true
            recognitionPreparationGeneration += 1
            let generation = recognitionPreparationGeneration
            let request = onDeviceRecognitionRequest
            Task { @MainActor in
                let available = await request()
                guard self.recognitionPreparationGeneration == generation else { return }
                self.preparingRecognition = false
                guard available else {
                    self.markRecognitionUnavailable(target: target)
                    return
                }
                self.beginWithMicrophone(target: target)
            }
            return
        }
        beginWithMicrophone(target: target)
    }

    private func beginWithMicrophone(target: String) {
        switch micPermissionProbe() {
        case .denied:
            micDenied = true
            return
        case .undetermined:
            let probe = micPermissionProbe
            let request = micPermissionRequest
            Task { @MainActor in
                switch await request() {
                case .granted:
                    guard probe() != .denied else {
                        micDenied = true
                        return
                    }
                    self.begin(target: target)
                default:
                    self.micDenied = true
                }
            }
            return
        case .granted:
            break
        }
        micDenied = false
        onCaptureWillBegin()
        do {
            try recorder.start()
        } catch {
            // Fail soft: a wedged audio server can cost a take, never the app.
            return
        }
        activeTarget = target
        recording = true
        // The 2.6 s take window (line 1890): restarting supersedes the
        // pending auto-stop instead of stacking a second timer.
        stopTask?.cancel()
        stopTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(2.6))
            guard !Task.isCancelled else { return }
            self.finish()
        }
    }

    private func markRecognitionUnavailable(target: String) {
        activeTarget = target
        var rec = records[target] ?? Record()
        rec.verdict = nil
        rec.unavailable = true
        records[target] = rec
    }

    /// End the running take (manual tap or the auto-stop) and run the
    /// clarity check on what was said.
    func finish() {
        stopTask?.cancel()
        stopTask = nil
        recognitionPreparationGeneration += 1
        let url = recorder.stop()
        recording = false
        guard let url else { return }  // never captured — no take counted
        var rec = records[activeTarget] ?? Record()
        rec.takes += 1
        rec.verdict = nil
        rec.unavailable = false
        records[activeTarget] = rec

        let target = activeTarget
        assessing = true
        let transcribe = transcriber
        Task { @MainActor in
            let transcript = await transcribe(url)
            recorder.discardTake(url)  // nothing the learner says is kept
            var rec = records[target] ?? Record()
            if let transcript {
                rec.verdict = SpeakVerdict.evaluate(target: target, transcript: transcript)
                let words = SpeakVerdict.wordsInOrder(target: target, transcript: transcript)
                rec.matchedWords = words.matched
                rec.totalWords = words.total
                rec.unavailable = false
            } else {
                rec.verdict = nil
                rec.unavailable = true
            }
            records[target] = rec
            assessing = false
            // Paired feedback per §2.6 — calm by governance, never shaming.
            switch rec.verdict {
            case .clear:
                AUFeedback.correct()
                AUSound.shared.correct()
            case .near:
                AUFeedback.press()
            case .nothingHeard:
                AUFeedback.miss()
            case nil:
                break
            }
            switch rec.verdict {
            case .clear: AUAX.announce("Clear.")
            case .near: AUAX.announce("Closer each time.")
            case .nothingHeard: AUAX.announce("Nothing came through.")
            case nil: break
            }
        }
    }

    /// Leaving the surface: any running take ends without a verdict, and
    /// nothing the learner said is kept.
    func reset() {
        stopTask?.cancel()
        stopTask = nil
        recognitionPreparationGeneration += 1
        if recording {
            let url = recorder.stop()
            recorder.discardTake(url)
        }
        recording = false
        assessing = false
        preparingRecognition = false
    }

    /// §3.16(d): re-check the permission (on appear / returning from
    /// Settings) — the denial state leaves the moment access does.
    func refreshPermission() {
        if micDenied, micPermissionProbe() == .granted {
            micDenied = false
        }
    }
}
