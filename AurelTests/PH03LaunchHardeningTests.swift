import Foundation
import XCTest

@testable import Aurel

/// Focused PH-03 coverage only: the shared judgment grammar, interruption-
/// safe capture handoff, local-first release posture, privacy manifest, and
/// one bounded course-load check. This intentionally does not walk the app.
@MainActor
final class PH03LaunchHardeningTests: XCTestCase {
    func testFeedbackGrammarCarriesMeaningAndNextAction() {
        let retry = AULearningFeedback.option(
            isCorrect: false,
            isRevealed: false,
            instruction: "Choose the reply that matches the greeting.",
            acceptedAnswer: "Good morning",
            authoredPositive: nil,
            authoredCorrection: nil)
        XCTAssertEqual(retry.outcome, .retry)
        XCTAssertTrue(retry.detail.contains("matches the greeting"))
        XCTAssertEqual(retry.actionLabel, "Try again")
        XCTAssertFalse(retry.detail.contains("Good morning"), "a genuine retry must not reveal")

        let revealed = AULearningFeedback.option(
            isCorrect: false,
            isRevealed: true,
            instruction: "Choose the reply that matches the greeting.",
            acceptedAnswer: "Good morning",
            authoredPositive: nil,
            authoredCorrection: "Try again.")
        XCTAssertEqual(revealed.outcome, .revealed)
        XCTAssertTrue(revealed.detail.contains("Good morning"))
        XCTAssertFalse(revealed.detail.contains("Try again"))
        XCTAssertEqual(revealed.actionLabel, "Go on")

        let ordered = AULearningFeedback.order(
            isCorrect: true,
            isRevealed: false,
            instruction: "Build the natural sentence.",
            acceptedOrder: "Good morning Maya",
            authoredPositive: nil,
            authoredCorrection: nil)
        XCTAssertEqual(ordered.outcome, .correct)
        XCTAssertTrue(ordered.detail.contains("Good morning Maya"))
        XCTAssertTrue(ordered.accessibilityAnnouncement.contains("Go on"))
    }

    func testRecordingHandoffStopsPlaybackAndInterruptionDiscardsTake() {
        let recorder = PH03Recorder()
        var events: [String] = []
        recorder.onStart = { events.append("record") }

        let coach = SayCoach()
        coach.recorder = recorder
        coach.onDeviceRecognitionProbe = { true }
        coach.micPermissionProbe = { .granted }
        coach.onCaptureWillBegin = { events.append("stop playback") }

        coach.toggle(target: "Good morning")

        XCTAssertEqual(events, ["stop playback", "record"])
        XCTAssertTrue(coach.recording)

        coach.reset()

        XCTAssertFalse(coach.recording)
        XCTAssertEqual(recorder.stopCount, 1)
        XCTAssertEqual(recorder.discardCount, 1)
        XCTAssertEqual(coach.record(for: "Good morning").takes, 0)
    }

    func testReleasePostureAndPrivacyManifestAreExplicitlyLocalFirst() throws {
        XCTAssertEqual(
            AppCapabilities.release,
            AppCapabilities(
                accounts: false,
                commerce: false,
                notifications: false,
                weeklyEmail: false,
                widget: false,
                support: false))

        let root = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let manifestURL = root.appendingPathComponent("Aurel/Support/PrivacyInfo.xcprivacy")
        let data = try Data(contentsOf: manifestURL)
        let plist = try XCTUnwrap(
            PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any])
        XCTAssertEqual(plist["NSPrivacyTracking"] as? Bool, false)
        XCTAssertEqual((plist["NSPrivacyCollectedDataTypes"] as? [Any])?.count, 0)
        XCTAssertNil(
            plist["NSPrivacyAccessedAPITypes"],
            "Apple requires the accessed-API key to be omitted when no category applies")

        let project = try String(
            contentsOf: root.appendingPathComponent("project.yml"), encoding: .utf8)
        XCTAssertTrue(project.contains("ALWAYS_SEARCH_USER_PATHS: NO"))
    }

    func testBundledCourseLoadsWithinFocusedLaunchBudget() throws {
        let clock = ContinuousClock()
        let started = clock.now
        let store = try CourseStore.load()
        let elapsed = clock.now - started

        XCTAssertEqual(store.flat.count, 131)
        XCTAssertLessThan(elapsed, .seconds(2))
    }
}

@MainActor
private final class PH03Recorder: TakeRecording {
    var level: Double = 0
    var samples: [Double] = []
    var isRecording = false
    var onStart: () -> Void = {}
    private(set) var stopCount = 0
    private(set) var discardCount = 0

    func start() throws {
        onStart()
        isRecording = true
    }

    func stop() -> URL? {
        guard isRecording else { return nil }
        isRecording = false
        stopCount += 1
        return URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("ph03-interrupted-take.m4a")
    }

    func discardTake(_ url: URL?) {
        guard url != nil else { return }
        discardCount += 1
    }
}
