import AVFoundation
import Combine
import Foundation
import Network
import Speech

// MARK: - Audio playback (the TTS stand-in)
//
// Governance: recordings are "scripts only" — nothing may be fabricated. The
// user-approved stand-in is on-device AVSpeechSynthesizer behind this
// protocol, so real recordings drop in later without touching call sites.
@MainActor
protocol AudioPlaying {
    func speak(_ text: String, slow: Bool)
    func stop()
    var isSpeaking: Bool { get }
}

@MainActor
final class Speaker: NSObject, AudioPlaying, AVSpeechSynthesizerDelegate {
    private(set) var speaking = false
    var isSpeaking: Bool { speaking }
    private let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
        synthesizer.delegate = self
    }

    func speak(_ text: String, slow: Bool) {
        stop()
        // Learning takes ≈100–110 wpm; challenge ≈120–130 wpm
        // (AUDIO_STYLE_GUIDE.md) — AVSpeech rate 0.42 ≈ 108 wpm.
        let u = AVSpeechUtterance(string: text)
        u.rate = slow ? 0.36 : 0.42
        u.pitchMultiplier = 1.0
        u.postUtteranceDelay = 0.35   // thought-boundary pause feel
        if let voice = AVSpeechSynthesisVoice(language: "en-US") {
            u.voice = voice
        }
        synthesizer.speak(u)
        speaking = true
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        speaking = false
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            self.speaking = false
        }
    }
}

// MARK: - Connectivity (NWPathMonitor → Combine → offline banner)

@MainActor
@Observable
final class Connectivity {
    var isOnline = true

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "aurel.connectivity")
    private var cancellables = Set<AnyCancellable>()

    var publisher: AnyPublisher<Bool, Never> {
        subject.eraseToAnyPublisher()
    }
    private let subject = CurrentValueSubject<Bool, Never>(true)

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let online = path.status == .satisfied
            DispatchQueue.main.async {
                self?.isOnline = online
                self?.subject.send(online)
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
        let days = cal.dateComponents([.day], from: cal.startOfDay(for: now), to: cal.startOfDay(for: date)).day ?? 0
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

    func requestAuthorization() async {
        let status: SFSpeechRecognizerAuthorizationStatus = await withCheckedContinuation { cont in
            SFSpeechRecognizer.requestAuthorization { cont.resume(returning: $0) }
        }
        authorized = status == .authorized
    }

    func start() async throws {
        guard let recognizer, authorized else { return }
        stop()

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .measurement)
        try session.setActive(true)

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        if recognizer.supportsOnDeviceRecognition {
            request.requiresOnDeviceRecognition = true
        }
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
}
