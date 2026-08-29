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

    func start() async throws {
        isRecording = true
    }

    func stop() -> URL? {
        guard isRecording else { return nil }
        isRecording = false
        if let url = urlToReturn {
            try? Data(repeating: 0x7F, count: 256).write(to: url)
        }
        return urlToReturn
    }

    func takeBytes() async -> Data? {
        guard let url = urlToReturn else { return nil }
        return try? Data(contentsOf: url)
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

    func testSayCoachPermissionDenied() async {
        let coach = SayCoach()
        coach.recognitionProbe = { true }
        coach.micPermissionProbe = { .denied }

        await coach.toggle(target: "Hello")
        XCTAssertTrue(coach.micDenied)
        XCTAssertFalse(coach.recording)
    }

    func testSayCoachPermissionGrantedStartsTake() async {
        let coach = SayCoach()
        let fake = FakeTakeRecorder()
        coach.recorder = fake
        coach.recognitionProbe = { true }
        coach.micPermissionProbe = { .granted }

        await coach.toggle(target: "Hello")
        XCTAssertFalse(coach.micDenied)
        XCTAssertTrue(coach.recording)
        XCTAssertEqual(coach.activeTarget, "Hello")

        await coach.toggle(target: "Hello")  // manual stop
        XCTAssertFalse(coach.recording)
    }

    func testSayCoachClarityVerdictRecorded() async throws {
        let coach = SayCoach()
        let fake = FakeTakeRecorder()
        coach.recorder = fake
        coach.recognitionProbe = { true }
        coach.micPermissionProbe = { .granted }
        coach.transcriber = { _ in .text("hello world") }

        await coach.toggle(target: "hello world")
        XCTAssertTrue(coach.recording)
        coach.finish()
        XCTAssertFalse(coach.recording)

        try await Task.sleep(for: .milliseconds(50))
        let rec = coach.record(for: "hello world")
        XCTAssertEqual(rec.takes, 1)
        XCTAssertEqual(rec.verdict, .clear)
        XCTAssertFalse(rec.unavailable)
    }

    func testSayCoachUnavailableWhenBothRecognitionTiersFail() async throws {
        let coach = SayCoach()
        let fake = FakeTakeRecorder()
        coach.recorder = fake
        coach.recognitionProbe = { true }
        coach.micPermissionProbe = { .granted }
        coach.transcriber = { _ in .unavailable }  // both tiers failed

        await coach.toggle(target: "hello world")
        coach.finish()

        try await Task.sleep(for: .milliseconds(50))
        let rec = coach.record(for: "hello world")
        XCTAssertEqual(rec.takes, 1)
        XCTAssertNil(rec.verdict)
        XCTAssertTrue(rec.unavailable)
        XCTAssertEqual(fake.discardedURLs.count, 1, "failed recognition still deletes the take")
    }

    func testEmptyTranscriptIsNothingHeardNotUnavailable() async throws {
        let coach = SayCoach()
        coach.recorder = FakeTakeRecorder()
        coach.recognitionProbe = { true }
        coach.micPermissionProbe = { .granted }
        // The recognizer ran and heard nothing — an honest tier, never the
        // no-verdict state.
        coach.transcriber = { _ in .text("") }

        await coach.toggle(target: "hello world")
        coach.finish()

        try await Task.sleep(for: .milliseconds(50))
        let rec = coach.record(for: "hello world")
        XCTAssertEqual(rec.verdict, .nothingHeard)
        XCTAssertFalse(rec.unavailable)
    }

    /// The Phase-5 fix itself: on hardware without an on-device model (the
    /// simulator among them) the take still records and scores — the server
    /// tier carries the check instead of the old silent no-op.
    func testTakeRecordsAndScoresWithoutOnDeviceSupport() async throws {
        let coach = SayCoach()
        let fake = FakeTakeRecorder()
        coach.recorder = fake
        // Authorized recognition, whatever tier it ends up on.
        coach.recognitionProbe = { true }
        coach.micPermissionProbe = { .granted }
        coach.transcriber = { _ in .text("hello world") }

        await coach.toggle(target: "hello world")
        XCTAssertTrue(coach.recording, "an authorized take records without on-device support")
        coach.finish()

        try await Task.sleep(for: .milliseconds(50))
        let rec = coach.record(for: "hello world")
        XCTAssertEqual(rec.takes, 1)
        XCTAssertEqual(rec.verdict, .clear)
        XCTAssertFalse(rec.unavailable)
    }

    func testUnauthorizedRecognitionRecordsNoTake() async throws {
        let coach = SayCoach()
        let fake = FakeTakeRecorder()
        coach.recorder = fake
        coach.recognitionProbe = { false }
        coach.recognitionRequest = { false }
        coach.micPermissionProbe = { .granted }

        await coach.toggle(target: "hello world")
        try await Task.sleep(for: .milliseconds(30))

        let rec = coach.record(for: "hello world")
        XCTAssertFalse(fake.isRecording)
        XCTAssertFalse(coach.recording)
        XCTAssertEqual(rec.takes, 0)
        XCTAssertTrue(rec.unavailable)
    }

    func testSpeechCaptureContractRequiresAuthorization() {
        // The speech permission gates the check; on-device support only
        // picks the tier (server fallback), it never blocks the take.
        XCTAssertFalse(SpeechToText.permitsCapture(authorized: false))
        XCTAssertTrue(SpeechToText.permitsCapture(authorized: true))
    }

    func testResumeOnceAllowsExactlyOneClaim() {
        let once = ResumeOnce()
        XCTAssertTrue(once.claim())
        XCTAssertFalse(once.claim())
        XCTAssertFalse(once.claim())
    }

    func testSayCoachResetCancelsRunningTake() async {
        let coach = SayCoach()
        let fake = FakeTakeRecorder()
        coach.recorder = fake
        coach.recognitionProbe = { true }
        coach.micPermissionProbe = { .granted }

        await coach.toggle(target: "test")
        XCTAssertTrue(coach.recording)
        coach.reset()
        XCTAssertFalse(coach.recording)
        XCTAssertFalse(coach.assessing)
        XCTAssertEqual(fake.discardedURLs.count, 1, "leaving deletes a running take")
    }

    // MARK: - Two-tier watchdog (the "comparison never appears" regression)

    /// Server-tier recognition is slow; a short watchdog cut it off and every
    /// take came back "unavailable" — the comparison never appeared.
    func testServerWatchdogOutlivesOnDeviceWatchdog() {
        XCTAssertEqual(SpeechToText.onDeviceWatchdog, .seconds(4))
        XCTAssertEqual(SpeechToText.serverWatchdog, .seconds(8))
        XCTAssertGreaterThan(SpeechToText.serverWatchdog, SpeechToText.onDeviceWatchdog)
    }

    /// A speech-authorization callback that never arrives (a known hang) must
    /// not wedge the flow: the timeout resolves it, the honest no-verdict
    /// state is recorded, and the button becomes usable again.
    func testRecognitionRequestTimeoutRecoversTheFlow() async throws {
        let coach = SayCoach()
        coach.recorder = FakeTakeRecorder()
        coach.recognitionProbe = { false }
        coach.recognitionRequest = {
            try? await Task.sleep(for: .seconds(5))  // the wedged callback
            return true
        }
        coach.recognitionRequestTimeout = .milliseconds(80)

        await coach.toggle(target: "hello world")
        try await Task.sleep(for: .milliseconds(250))

        XCTAssertFalse(coach.preparingRecognition, "a dropped auth callback must not wedge the flow")
        XCTAssertFalse(coach.recording)
        XCTAssertTrue(coach.record(for: "hello world").unavailable)
    }

    /// The same guarantee on the mic-permission path: no take, no invented
    /// denial — the flow simply stays usable when the callback never lands
    /// and the live permission is still undetermined.
    func testMicPermissionTimeoutRecoversWithoutInventedState() async throws {
        let coach = SayCoach()
        coach.recorder = FakeTakeRecorder()
        coach.recognitionProbe = { true }
        coach.micPermissionProbe = { .undetermined }
        coach.micPermissionRequest = {
            try? await Task.sleep(for: .seconds(5))  // the wedged callback
            return .granted
        }
        coach.micPermissionTimeout = .milliseconds(80)

        await coach.toggle(target: "hello world")
        try await Task.sleep(for: .milliseconds(250))

        XCTAssertFalse(coach.recording)
        XCTAssertFalse(coach.micDenied)
        XCTAssertFalse(coach.preparingRecognition)
    }

    func testFinishedTakeStaysPlayableAfterModelPlayback() async throws {
        let coach = SayCoach()
        let fake = FakeTakeRecorder()
        coach.recorder = fake
        coach.recognitionProbe = { true }
        coach.micPermissionProbe = { .granted }
        coach.transcriber = { _ in .text("hello world") }

        await coach.toggle(target: "hello world")
        coach.finish()
        try await Task.sleep(for: .milliseconds(80))

        XCTAssertTrue(coach.canPlayLearnerTake, "a finished take must keep playable audio")
        XCTAssertNotNil(coach.lastTakeData)
        XCTAssertFalse(coach.lastTakeData?.isEmpty ?? true)

        coach.interruptForModelPlayback()
        XCTAssertTrue(
            coach.canPlayLearnerTake,
            "hearing the model must not wipe the learner take")

        coach.reset()
        XCTAssertFalse(coach.canPlayLearnerTake)
        XCTAssertNil(coach.lastTakeData)
    }
}
