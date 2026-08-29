import AVFoundation
import Foundation
import Network
import Speech

// MARK: - Audio session gate (S0-003: never block the app on the audio server)

/// Every `AVAudioSession` mutation in the app funnels through this one serial
/// queue. `setCategory`/`setActive` are synchronous IPC to the audio server;
/// calling them on the main actor while a speech-recognition request talks to
/// the same server is what froze the app mid-take (the take flow flips the
/// session between play and record on every take). Serializing here also
/// orders those flips — a restore can never land after the next take's record
/// configuration.
enum AudioSessionGate {
    private static let queue = DispatchQueue(label: "aurel.audio-session", qos: .userInitiated)

    /// Record mode for a take. Async + throwing: `MicRecorder.start()` awaits
    /// it off the main actor and fails soft on error.
    static func activateForRecording() async throws {
        try await withCheckedThrowingContinuation { cont in
            queue.async {
                do {
                    let session = AVAudioSession.sharedInstance()
                    try session.setCategory(
                        .playAndRecord, mode: .default, options: [.defaultToSpeaker])
                    try session.setActive(true)
                    cont.resume()
                } catch {
                    cont.resume(throwing: error)
                }
            }
        }
    }

    /// Playback category + activation, awaited — the learner-take compare
    /// playback wants the session standing before its player starts.
    static func activateForPlayback() async {
        await withCheckedContinuation { (cont: CheckedContinuation<Void, Never>) in
            queue.async {
                let session = AVAudioSession.sharedInstance()
                try? session.setCategory(.playback, mode: .spokenAudio)
                try? session.setActive(true)
                cont.resume()
            }
        }
    }

    /// Playback category + activation, fire-and-forget: enqueued in order but
    /// never awaited (first model speech / TTS — the engine spins up while the
    /// session activates beside it).
    static func enqueuePlaybackActivation() {
        queue.async {
            let session = AVAudioSession.sharedInstance()
            try? session.setCategory(.playback, mode: .spokenAudio)
            try? session.setActive(true)
        }
    }

    /// Restore the standing playback category after a take. Fire-and-forget
    /// on purpose: enqueued at `stop()` time it stays ordered around the
    /// take's own mutations, without making stop asynchronous.
    static func enqueuePlaybackRestore() {
        queue.async {
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
        }
    }
}

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
    func pause()
    func resume()
    var isSpeaking: Bool { get }
    var isPaused: Bool { get }
}

extension AudioPlaying {
    /// Text-only conformers (the TTS Speaker) simply speak the text.
    func speak(audioID: String?, text: String, slow: Bool, lineIndex: Int? = nil) {
        speak(text, slow: slow)
    }

    func pause() {}
    func resume() {}
    var isPaused: Bool { false }
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
    /// Identity of the utterance being spoken — asynchronous delegate hops
    /// are validated against it, so a completion or range event from a
    /// superseded utterance (a replay begun before the hop ran) can never
    /// clear `speaking` or rewind the highlight mid-utterance.
    private var utteranceID: ObjectIdentifier?

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
            // Off the main thread (S0-003): session activation is synchronous
            // audio-server IPC. The synthesizer spins up while the session
            // activates beside it.
            AudioSessionGate.enqueuePlaybackActivation()
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
        utteranceID = ObjectIdentifier(u)
        speaking = true
        progress = 0
        spokenRange = nil
        spokenChars = 0
        totalChars = Double(max(1, text.count))
    }

    func stop() {
        // Drop the utterance's identity first: the didFinish callback that
        // `stopSpeaking` triggers must not clear the state of a newer take.
        utteranceID = nil
        synthesizer.stopSpeaking(at: .immediate)
        speaking = false
        progress = 0
        spokenRange = nil
        AUSound.shared.isDucked = false
    }

    func pause() {
        guard speaking, !synthesizer.isPaused else { return }
        synthesizer.pauseSpeaking(at: .immediate)
    }

    func resume() {
        guard speaking, synthesizer.isPaused else { return }
        synthesizer.continueSpeaking()
    }

    var isPaused: Bool { synthesizer.isPaused }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance
    ) {
        let finished = ObjectIdentifier(utterance)
        Task { @MainActor [weak self] in
            guard let self, self.utteranceID == finished else { return }
            self.utteranceID = nil
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
        let voiced = ObjectIdentifier(utterance)
        Task { @MainActor [weak self] in
            guard let self, self.utteranceID == voiced else { return }
            // Monotonic: out-of-order delegate callbacks must not rewind it.
            let newest = end >= self.spokenChars
            self.spokenChars = max(self.spokenChars, end)
            self.progress = min(1, self.spokenChars / max(total, self.totalChars, 1))
            if newest { self.spokenRange = characterRange }
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

// MARK: - Speech recognition (say-aloud clarity check)
//
// The tap path is always available and equal in weight. Recognition is
// two-tier: on-device whenever the device supports it (the take never
// leaves the device), Apple's speech service otherwise — the fallback
// that makes the check work on hardware without an on-device en-US model
// (the simulator among them). "Unavailable" means both tiers failed.

@MainActor
@Observable
final class SpeechToText {
    /// A finished take's transcription — the honest distinction the verdict
    /// UI renders: text (possibly empty — the recognizer ran and heard
    /// nothing) versus recognition that could not run at all.
    enum Transcription: Equatable, Sendable {
        case text(String)
        case unavailable
    }

    /// How long the on-device recognizer may process a take before failing
    /// soft — the local model resolves a 2.6 s take well inside this.
    static let onDeviceWatchdog: Duration = .seconds(4)
    /// How long the server-tier recognizer may process a take before failing
    /// soft. Server-tier requests can be slow (a 4 s watchdog once cut them
    /// off; 2 s guaranteed it — the "comparison never appears" regression).
    /// Partial text collected by then is still scored.
    static let serverWatchdog: Duration = .seconds(8)

    private(set) var authorized = false

    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))

    /// Whether the device has an en-US on-device model (the simulator and
    /// some hardware do not — those take the server tier).
    var supportsOnDeviceRecognition: Bool {
        recognizer?.supportsOnDeviceRecognition == true
    }

    /// Recognition may run at all — the speech permission is the gate;
    /// on-device support only picks the tier, never blocks the check. The
    /// live system status is consulted alongside the published flag: a
    /// dropped authorization callback (a known hang) must not wedge the
    /// take flow when the permission is in fact already granted.
    var canRecognize: Bool {
        Self.permitsCapture(
            authorized: authorized || SFSpeechRecognizer.authorizationStatus() == .authorized)
    }

    static func permitsCapture(authorized: Bool) -> Bool { authorized }

    @discardableResult
    func requestAuthorization() async -> Bool {
        // SFSpeechRecognizer.requestAuthorization must never be called from
        // the main thread: its completion handler is known to simply never
        // fire there, which wedged `preparingRecognition` forever. Hop off,
        // request, hop back to publish.
        let status: SFSpeechRecognizerAuthorizationStatus =
            await withCheckedContinuation { cont in
                Task.detached(priority: .userInitiated) {
                    SFSpeechRecognizer.requestAuthorization { cont.resume(returning: $0) }
                }
            }
        authorized = status == .authorized
        return canRecognize
    }

    /// §3.16(c): transcribe a finished take file — the clarity check runs
    /// after the take, never as live dictation. Tier 1 requires on-device
    /// recognition where supported (audio stays on the device); tier 2 is
    /// Apple's speech service. `.unavailable` only when both fail —
    /// unauthorized, an error on both tiers, or the watchdog.
    func transcribe(url: URL) async -> Transcription {
        guard let recognizer, canRecognize else { return .unavailable }
        if supportsOnDeviceRecognition,
            case .text(let text) = await attempt(
                url: url, recognizer: recognizer, requiresOnDevice: true,
                watchdog: Self.onDeviceWatchdog)
        {
            return .text(text)
        }
        return await attempt(
            url: url, recognizer: recognizer, requiresOnDevice: false,
            watchdog: Self.serverWatchdog)
    }

    private func attempt(
        url: URL, recognizer: SFSpeechRecognizer, requiresOnDevice: Bool, watchdog: Duration
    ) async -> Transcription {
        let request = SFSpeechURLRecognitionRequest(url: url)
        request.requiresOnDeviceRecognition = requiresOnDevice
        return await withCheckedContinuation { cont in
            let once = ResumeOnce()
            var latestText: String?
            let task = recognizer.recognitionTask(with: request) { result, error in
                if let result {
                    let formatted = result.bestTranscription.formattedString
                    if !formatted.isEmpty {
                        latestText = formatted
                    }
                    if result.isFinal {
                        if once.claim() {
                            cont.resume(returning: .text(formatted))
                        }
                        return
                    }
                }
                if error != nil {
                    if once.claim() {
                        if let text = latestText, !text.isEmpty {
                            cont.resume(returning: .text(text))
                        } else {
                            cont.resume(returning: .unavailable)
                        }
                    }
                }
            }
            Task { @MainActor in
                try? await Task.sleep(for: watchdog)
                guard once.claim() else { return }
                task.cancel()
                if let text = latestText, !text.isEmpty {
                    cont.resume(returning: .text(text))
                } else {
                    cont.resume(returning: .unavailable)
                }
            }
        }
    }
}

/// Single-use resume guard for a checked continuation with two racing
/// completion sources (the recognition callback vs the watchdog).
final class ResumeOnce: @unchecked Sendable {
    private let lock = NSLock()
    private var claimed = false

    /// True exactly once — the first caller finishes the continuation.
    func claim() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        if claimed { return false }
        claimed = true
        return true
    }
}

/// A non-Sendable value knowingly confined to the main actor: `withTimeout`
/// moves its body into a task that hops to the main actor before touching it,
/// so the closure never actually crosses isolation unsynchronized.
private struct MainActorBox<T>: @unchecked Sendable {
    let value: T
}

/// Race `body` against `timeout`: its value if it finished first, nil when
/// the timeout fired. Used only to recover wedged system callbacks — the
/// honest outcomes are unchanged; a timeout merely resolves what never
/// would have arrived. MainActor-confined: the body never leaves the
/// caller's isolation, only the box does.
@MainActor
private func withTimeout<T: Sendable>(
    _ body: @escaping () async -> T, timeout: Duration
) async -> T? {
    let boxed = MainActorBox(value: body)
    return await withCheckedContinuation { cont in
        let once = ResumeOnce()
        Task { @MainActor in
            let value = await boxed.value()
            if once.claim() { cont.resume(returning: value) }
        }
        Task { @MainActor in
            try? await Task.sleep(for: timeout)
            if once.claim() { cont.resume(returning: nil) }
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
    func start() async throws
    @discardableResult func stop() -> URL?
    func discardTake(_ url: URL?)
    /// Bytes of the take `stop()` just closed, once the file is fully written.
    func takeBytes() async -> Data?
}

extension TakeRecording {
    func takeBytes() async -> Data? { nil }
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
    /// Held for the recorder's weak `delegate` until the m4a is closed.
    private var finishWatcher: RecorderFinishWatcher?
    private var finalizedTakeData: Data?
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
    /// `stop()`. The session flips to record mode through the gate — off the
    /// main thread, because `setCategory`/`setActive` are synchronous
    /// audio-server IPC that once froze the app mid-take (S0-003). Throws
    /// only on failures — callers degrade.
    func start() async throws {
        abandonRecorder()
        try await AudioSessionGate.activateForRecording()
        try? FileManager.default.removeItem(at: fileURL)
        finalizedTakeData = nil
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue,
        ]
        let rec = try AVAudioRecorder(url: fileURL, settings: settings)
        rec.isMeteringEnabled = true
        let watcher = RecorderFinishWatcher()
        watcher.onFinish = { [weak self] success in
            self?.handleRecorderFinished(success: success)
        }
        rec.delegate = watcher
        finishWatcher = watcher
        guard rec.record() else {
            abandonRecorder()
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
    /// never captured). The recorder is kept alive until its finish
    /// callback closes the m4a — releasing it here left an unreadable file
    /// and a dead YOU play control.
    @discardableResult
    func stop() -> URL? {
        meterTask?.cancel()
        meterTask = nil
        let url = recorder?.url
        let wasRecording = recorder?.isRecording ?? false
        recorder?.stop()
        isRecording = false
        guard wasRecording else {
            abandonRecorder()
            AudioSessionGate.enqueuePlaybackRestore()
            return nil
        }
        return url
    }

    /// Wait until `AVAudioRecorder` has closed the take file, then return
    /// its bytes. Times out rather than wedging the take flow.
    func takeBytes() async -> Data? {
        if let data = finalizedTakeData, !data.isEmpty { return data }
        for _ in 0..<20 {
            if let data = finalizedTakeData, !data.isEmpty { return data }
            if recorder == nil { return readableTakeData() }
            try? await Task.sleep(for: .milliseconds(40))
        }
        return finalizedTakeData ?? readableTakeData()
    }

    /// The take file is handed to the recognizer, then deleted — nothing
    /// the learner says is ever kept. In-memory `lastTakeData` is what
    /// the YOU play control uses after this.
    func discardTake(_ url: URL?) {
        abandonRecorder()
        guard let url else { return }
        try? FileManager.default.removeItem(at: url)
    }

    private func handleRecorderFinished(success: Bool) {
        if success {
            finalizedTakeData = readableTakeData()
        } else if let data = readableTakeData(), !data.isEmpty {
            finalizedTakeData = data
        }
        recorder = nil
        finishWatcher = nil
    }

    private func readableTakeData() -> Data? {
        let url = recorder?.url ?? fileURL
        guard let data = try? Data(contentsOf: url), !data.isEmpty else { return nil }
        return data
    }

    private func abandonRecorder() {
        meterTask?.cancel()
        meterTask = nil
        recorder?.delegate = nil
        if recorder?.isRecording == true {
            recorder?.stop()
        }
        recorder = nil
        finishWatcher = nil
        isRecording = false
    }
}

/// `AVAudioRecorder.delegate` is weak — this object is retained by
/// `MicRecorder` until the take file is closed.
@MainActor
private final class RecorderFinishWatcher: NSObject, AVAudioRecorderDelegate {
    var onFinish: ((Bool) -> Void)?

    nonisolated func audioRecorderDidFinishRecording(
        _ recorder: AVAudioRecorder, successfully flag: Bool
    ) {
        Task { @MainActor [weak self] in
            self?.onFinish?(flag)
        }
    }
}

/// Keeps `AVAudioPlayer` alive for the learner-take compare play. The
/// player's delegate is weak, so this object is the retain root.
@MainActor
private final class LearnerTakePlayback: NSObject, AVAudioPlayerDelegate {
    var player: AVAudioPlayer?
    var onEnd: (() -> Void)?

    func stop() {
        player?.delegate = nil
        player?.stop()
        player = nil
    }

    nonisolated func audioPlayerDidFinishPlaying(
        _ player: AVAudioPlayer, successfully flag: Bool
    ) {
        Task { @MainActor [weak self] in
            self?.onEnd?()
        }
    }

    nonisolated func audioPlayerDecodeErrorDidOccur(
        _ player: AVAudioPlayer, error: Error?
    ) {
        Task { @MainActor [weak self] in
            self?.onEnd?()
        }
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
    /// Transcribe a finished take (`.unavailable` → the honest no-verdict
    /// state, never an invented tier).
    var transcriber: @Sendable (URL) async -> SpeechToText.Transcription
    /// A take may begin only when recognition is authorized — on-device
    /// support picks the tier at transcription time, it never blocks the
    /// take. Both seams are injectable for deterministic privacy tests.
    var recognitionProbe: () -> Bool
    var recognitionRequest: () async -> Bool
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
    /// System permission callbacks that never arrive (a known hang on both
    /// the speech and mic paths) must not wedge the take flow: each request
    /// races these bounds, and the honest outcomes are unchanged — a timeout
    /// only resolves what never would.
    var recognitionRequestTimeout: Duration = .seconds(12)
    var micPermissionTimeout: Duration = .seconds(12)
    /// Belt-and-braces bound on the whole post-take assessment: the
    /// "Checking your pronunciation…" state can never stick.
    var assessmentTimeout: Duration = .seconds(15)

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
    private(set) var lastTakeData: Data?
    private(set) var isPlayingLearnerTake = false
    private var learnerPlayback: LearnerTakePlayback?
    private var stopTask: Task<Void, Never>?
    private var recognitionPreparationGeneration = 0

    init() {
        let speech = self.speech
        transcriber = { url in await speech.transcribe(url: url) }
        recognitionProbe = { speech.canRecognize }
        recognitionRequest = { await speech.requestAuthorization() }
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

    /// The YOU play control is enabled only when the last take's audio is
    /// actually in memory — a counted take with no bytes stays disabled.
    var canPlayLearnerTake: Bool {
        guard let lastTakeData else { return false }
        return !lastTakeData.isEmpty
    }

    // MARK: Flow

    /// Toggle a take for `target` — start when idle, stop when running.
    func toggle(target: String) async {
        if recording {
            finish()
            return
        }
        await begin(target: target)
    }

    private func begin(target: String) async {
        guard !preparingRecognition else { return }
        guard recognitionProbe() else {
            preparingRecognition = true
            recognitionPreparationGeneration += 1
            let generation = recognitionPreparationGeneration
            let request = recognitionRequest
            let timeout = recognitionRequestTimeout
            Task { @MainActor in
                // A system authorization callback that never arrives (a
                // known hang) must not wedge the flow: race it, then fall
                // back to the live permission — no invented verdicts either
                // way.
                let available = await withTimeout(request, timeout: timeout)
                    ?? self.recognitionProbe()
                guard self.recognitionPreparationGeneration == generation else { return }
                self.preparingRecognition = false
                guard available else {
                    self.markRecognitionUnavailable(target: target)
                    return
                }
                await self.beginWithMicrophone(target: target)
            }
            return
        }
        await beginWithMicrophone(target: target)
    }

    private func beginWithMicrophone(target: String) async {
        stopLearnerTake()
        switch micPermissionProbe() {
        case .denied:
            micDenied = true
            return
        case .undetermined:
            let probe = micPermissionProbe
            let request = micPermissionRequest
            let timeout = micPermissionTimeout
            Task { @MainActor in
                switch await withTimeout(request, timeout: timeout) {
                case .some(.granted):
                    guard probe() != .denied else {
                        micDenied = true
                        return
                    }
                    await self.begin(target: target)
                case .some:
                    self.micDenied = true
                case nil:
                    // The permission callback never arrived (a known hang):
                    // recover from the live system state, honestly.
                    guard probe() == .granted else { return }
                    await self.begin(target: target)
                }
            }
            return
        case .granted:
            break
        }
        micDenied = false
        onCaptureWillBegin()
        // Claim the take synchronously, before the first suspension: a rapid
        // second toggle must see a running take and stop it, never race a
        // second start against the pending one.
        activeTarget = target
        recording = true
        do {
            try await recorder.start()
        } catch {
            // Fail soft: a wedged audio server can cost a take, never the app.
            recording = false
            return
        }
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
        let timeout = assessmentTimeout
        Task { @MainActor in
            self.lastTakeData = await Self.loadTakeData(url: url, recorder: self.recorder)
            AudioSessionGate.enqueuePlaybackRestore()
            // Belt-and-braces: a wedged transcriber must not leave the
            // "Checking…" state up forever.
            let outcome = await withTimeout({ await transcribe(url) }, timeout: timeout)
                ?? .unavailable
            recorder.discardTake(url)  // nothing the learner says is kept on disk
            var rec = records[target] ?? Record()
            switch outcome {
            case .text(let transcript):
                rec.verdict = SpeakVerdict.evaluate(target: target, transcript: transcript)
                let words = SpeakVerdict.wordsInOrder(target: target, transcript: transcript)
                rec.matchedWords = words.matched
                rec.totalWords = words.total
                rec.unavailable = false
            case .unavailable:
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

    /// Plays back the learner's last recorded take for comparison against the model audio.
    func playLearnerTake() async {
        guard canPlayLearnerTake, let data = lastTakeData else { return }
        stopLearnerTake()
        onCaptureWillBegin()
        // Session mode first, off the main thread (S0-003), then the player.
        await AudioSessionGate.activateForPlayback()
        do {
            let player: AVAudioPlayer
            if let hinted = try? AVAudioPlayer(
                data: data, fileTypeHint: AVFileType.m4a.rawValue)
            {
                player = hinted
            } else {
                player = try AVAudioPlayer(data: data)
            }
            player.volume = 1
            let playback = LearnerTakePlayback()
            playback.player = player
            playback.onEnd = { [weak self, weak playback] in
                guard let self, self.learnerPlayback === playback else { return }
                self.isPlayingLearnerTake = false
                self.learnerPlayback = nil
            }
            player.delegate = playback
            learnerPlayback = playback
            isPlayingLearnerTake = true
            player.prepareToPlay()
            guard player.play() else {
                isPlayingLearnerTake = false
                learnerPlayback = nil
                return
            }
        } catch {
            isPlayingLearnerTake = false
            learnerPlayback = nil
        }
    }

    /// Stops any ongoing playback of the learner's recorded take.
    func stopLearnerTake() {
        learnerPlayback?.stop()
        learnerPlayback = nil
        isPlayingLearnerTake = false
    }

    /// Stops learner playback and any in-progress capture so the model line
    /// can play. Keeps the last finished take — `reset()` is what forgets it.
    func interruptForModelPlayback() {
        stopLearnerTake()
        guard recording else { return }
        stopTask?.cancel()
        stopTask = nil
        recognitionPreparationGeneration += 1
        let url = recorder.stop()
        recording = false
        assessing = false
        recorder.discardTake(url)
        AudioSessionGate.enqueuePlaybackRestore()
    }

    /// Leaving the surface: any running take ends without a verdict, and
    /// nothing the learner said is kept.
    func reset() {
        stopTask?.cancel()
        stopTask = nil
        recognitionPreparationGeneration += 1
        stopLearnerTake()
        lastTakeData = nil
        if recording {
            let url = recorder.stop()
            recorder.discardTake(url)
        }
        recording = false
        assessing = false
        preparingRecognition = false
        AudioSessionGate.enqueuePlaybackRestore()
    }

    private static func loadTakeData(url: URL, recorder: any TakeRecording) async -> Data? {
        if let data = await recorder.takeBytes(), !data.isEmpty { return data }
        for _ in 0..<12 {
            if let data = try? Data(contentsOf: url), !data.isEmpty { return data }
            try? await Task.sleep(for: .milliseconds(40))
        }
        return try? Data(contentsOf: url)
    }

    /// §3.16(d): re-check the permission (on appear / returning from
    /// Settings) — the denial state leaves the moment access does.
    func refreshPermission() {
        if micDenied, micPermissionProbe() == .granted {
            micDenied = false
        }
    }
}
