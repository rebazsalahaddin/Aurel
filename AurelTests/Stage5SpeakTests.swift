import XCTest

@testable import Aurel

@MainActor
final class FakeTakeRecorder: TakeRecording {
    var level: Double = 0.5
    var samples: [Double] = [0.1, 0.3, 0.5]
    var isRecording = false
    var urlToReturn: URL? = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(
        "fake-take.m4a")
    var discardedURLs: [URL] = []

    func start() throws {
        isRecording = true
    }

    func stop() -> URL? {
        guard isRecording else { return nil }
        isRecording = false
        return urlToReturn
    }

    func discardTake(_ url: URL?) {
        if let url { discardedURLs.append(url) }
    }
}

/// Stage-5 Speak Honesty tests (IMPROVEMENT_PLAN.md §3.16 / §3.11c):
/// word-match clarity evaluation, SayCoach permissions, take coordination,
/// waveform metering, and non-accent scoring.
@MainActor
final class Stage5SpeakTests: XCTestCase {

    // MARK: - SpeakVerdict clarity evaluation

    func testSpeakVerdictWordNormalization() {
        let words = SpeakVerdict.words("Hello, World! It's a sunny day.")
        XCTAssertEqual(words, ["hello", "world", "it", "s", "a", "sunny", "day"])
    }

    func testSpeakVerdictLCS() {
        let target = ["i", "am", "maya", "from", "london"]
        let transcript = ["i", "am", "maya", "london"]
        XCTAssertEqual(SpeakVerdict.lcs(target, transcript), 4)
    }

    func testSpeakVerdictTiers() {
        let target = "I am Maya from London"

        // Clear: >= 75% match in order
        XCTAssertEqual(
            SpeakVerdict.evaluate(target: target, transcript: "I am Maya from London"), .clear)
        // 4/5 = 80%
        XCTAssertEqual(
            SpeakVerdict.evaluate(target: target, transcript: "I am Maya London"), .clear)

        // Near: >= 30% and < 75%
        // 3/5 = 60%
        XCTAssertEqual(SpeakVerdict.evaluate(target: target, transcript: "I am Maya"), .near)
        // 2/5 = 40%
        XCTAssertEqual(SpeakVerdict.evaluate(target: target, transcript: "Maya London"), .near)

        // Nothing heard / match < 30%
        XCTAssertEqual(
            SpeakVerdict.evaluate(target: target, transcript: "Bonjour Paris"), .nothingHeard)
        XCTAssertEqual(SpeakVerdict.evaluate(target: target, transcript: ""), .nothingHeard)
    }

    func testSpeakVerdictWordsInOrder() {
        let target = "The quick brown fox"
        let res = SpeakVerdict.wordsInOrder(target: target, transcript: "The brown fox")
        XCTAssertEqual(res.matched, 3)
        XCTAssertEqual(res.total, 4)
    }

    // MARK: - SayCoach Take Coordinator

    func testSayCoachPermissionDenied() {
        let coach = SayCoach()
        coach.onDeviceRecognitionProbe = { true }
        coach.micPermissionProbe = { .denied }

        coach.toggle(target: "Hello")
        XCTAssertTrue(coach.micDenied)
        XCTAssertFalse(coach.recording)
    }

    func testSayCoachPermissionGrantedStartsTake() {
        let coach = SayCoach()
        let fake = FakeTakeRecorder()
        coach.recorder = fake
        coach.onDeviceRecognitionProbe = { true }
        coach.micPermissionProbe = { .granted }

        coach.toggle(target: "Hello")
        XCTAssertFalse(coach.micDenied)
        XCTAssertTrue(coach.recording)
        XCTAssertEqual(coach.activeTarget, "Hello")

        coach.toggle(target: "Hello")  // manual stop
        XCTAssertFalse(coach.recording)
    }

    func testSayCoachClarityVerdictRecorded() async throws {
        let coach = SayCoach()
        let fake = FakeTakeRecorder()
        coach.recorder = fake
        coach.onDeviceRecognitionProbe = { true }
        coach.micPermissionProbe = { .granted }
        coach.transcriber = { _ in "hello world" }

        coach.toggle(target: "hello world")
        XCTAssertTrue(coach.recording)
        coach.finish()
        XCTAssertFalse(coach.recording)

        try await Task.sleep(for: .milliseconds(50))
        let rec = coach.record(for: "hello world")
        XCTAssertEqual(rec.takes, 1)
        XCTAssertEqual(rec.verdict, .clear)
        XCTAssertFalse(rec.unavailable)
    }

    func testSayCoachUnavailableWhenTranscriberReturnsNil() async throws {
        let coach = SayCoach()
        let fake = FakeTakeRecorder()
        coach.recorder = fake
        coach.onDeviceRecognitionProbe = { true }
        coach.micPermissionProbe = { .granted }
        coach.transcriber = { _ in nil }  // simulated recognition failure

        coach.toggle(target: "hello world")
        coach.finish()

        try await Task.sleep(for: .milliseconds(50))
        let rec = coach.record(for: "hello world")
        XCTAssertEqual(rec.takes, 1)
        XCTAssertNil(rec.verdict)
        XCTAssertTrue(rec.unavailable)
        XCTAssertEqual(fake.discardedURLs.count, 1, "failed recognition still deletes the take")
    }

    func testUnsupportedOnDeviceRecognitionRecordsNoTake() async throws {
        let coach = SayCoach()
        let fake = FakeTakeRecorder()
        coach.recorder = fake
        coach.onDeviceRecognitionProbe = { false }
        coach.onDeviceRecognitionRequest = { false }
        coach.micPermissionProbe = { .granted }

        coach.toggle(target: "hello world")
        try await Task.sleep(for: .milliseconds(30))

        let rec = coach.record(for: "hello world")
        XCTAssertFalse(fake.isRecording)
        XCTAssertFalse(coach.recording)
        XCTAssertEqual(rec.takes, 0)
        XCTAssertTrue(rec.unavailable)
    }

    func testSpeechCaptureContractRequiresAuthorizationAndOnDeviceSupport() {
        XCTAssertFalse(
            SpeechToText.permitsCapture(
                authorized: false, supportsOnDeviceRecognition: true))
        XCTAssertFalse(
            SpeechToText.permitsCapture(
                authorized: true, supportsOnDeviceRecognition: false))
        XCTAssertTrue(
            SpeechToText.permitsCapture(
                authorized: true, supportsOnDeviceRecognition: true))
    }

    func testSayCoachResetCancelsRunningTake() {
        let coach = SayCoach()
        let fake = FakeTakeRecorder()
        coach.recorder = fake
        coach.onDeviceRecognitionProbe = { true }
        coach.micPermissionProbe = { .granted }

        coach.toggle(target: "test")
        XCTAssertTrue(coach.recording)
        coach.reset()
        XCTAssertFalse(coach.recording)
        XCTAssertFalse(coach.assessing)
        XCTAssertEqual(fake.discardedURLs.count, 1, "leaving deletes a running take")
    }
}
