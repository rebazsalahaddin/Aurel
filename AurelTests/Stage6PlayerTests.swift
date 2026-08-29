import SwiftUI
import XCTest

@testable import Aurel

@MainActor
final class Stage6PlayerTests: XCTestCase {

    func testPlayerPositionAndNavigation() throws {
        let store = CourseDecodingTests.store
        var finished = false
        var exited = false
        let model = PlayerModel(
            course: store,
            start: 0,
            bound: false,
            onExit: { exited = true },
            onFinish: { finished = true }
        )

        XCTAssertEqual(model.p, 0)
        XCTAssertNotNil(model.cur)

        model.goto(1)
        XCTAssertEqual(model.p, 1)

        // Out-of-bounds advance triggers onFinish callback
        model.goto(9999)
        XCTAssertTrue(finished)
        XCTAssertEqual(model.p, 1)

        // Out-of-bounds backtrack triggers onExit callback
        model.goto(-50)
        XCTAssertTrue(exited)
        XCTAssertEqual(model.p, 1)
    }

    func testPlayerLoadingStateView() {
        let loadingView = PlayerLoadingView()
        XCTAssertNotNil(loadingView)
    }

    func testSayCoachRecordResetOnScreenAdvance() async {
        let say = SayCoach()
        let recorder = FakeTakeRecorder()
        say.recorder = recorder
        say.recognitionProbe = { true }
        say.micPermissionProbe = { .granted }

        await say.toggle(target: "bonjour")
        XCTAssertTrue(say.recording)
        XCTAssertEqual(say.activeTarget, "bonjour")

        say.reset()
        XCTAssertFalse(say.recording)
    }

    func testSpeakLeavesLearnerTakePlayable() async throws {
        let store = CourseDecodingTests.store
        let model = PlayerModel(course: store, start: 0, bound: false)
        let fake = FakeTakeRecorder()
        model.say.recorder = fake
        model.say.recognitionProbe = { true }
        model.say.micPermissionProbe = { .granted }
        model.say.transcriber = { _ in .text("hello") }

        await model.say.toggle(target: "hello")
        model.say.finish()
        try await Task.sleep(for: .milliseconds(80))
        XCTAssertTrue(model.say.canPlayLearnerTake)

        model.speak("hello")
        XCTAssertTrue(
            model.say.canPlayLearnerTake,
            "playing the model line must not disable the YOU play control")
    }

    func testScreenColumnAuthoringHeight() {
        let col = ScreenColumn(topPad: 24, bottomPad: 28) {
            Text("Test")
        }
        XCTAssertEqual(col.topPad, 24)
        XCTAssertEqual(col.bottomPad, 28)
    }

    // MARK: Phase 6 — id-first key matching (single-letter option collision)

    /// The C2 letter items key by option id while another option's TEXT is
    /// that same letter (option A shows "B", the key is option B = "D").
    /// The old id-OR-text rule graded both; id-first grades exactly the
    /// authored one.
    func testKeyMatchingPrefersOptionIdOverEchoingText() {
        let opts = [
            PracticeOption(id: "A", text: "B", ill: nil),
            PracticeOption(id: "B", text: "D", ill: nil),
            PracticeOption(id: "C", text: "P", ill: nil),
        ]
        // Key "B" names option B ("D") — not option A, whose text is "B".
        XCTAssertTrue(PlayerModel.matchesKey(opts[1], key: "B", opts: opts))
        XCTAssertFalse(PlayerModel.matchesKey(opts[0], key: "B", opts: opts))
        XCTAssertFalse(PlayerModel.matchesKey(opts[2], key: "B", opts: opts))

        // Text keys (warm-up frames) still match when no option id applies.
        let frameOpts = [
            PracticeOption(id: "A", text: "five", ill: nil),
            PracticeOption(id: "B", text: "zero", ill: nil),
        ]
        XCTAssertTrue(PlayerModel.matchesKey(frameOpts[0], key: "five", opts: frameOpts))
        XCTAssertFalse(PlayerModel.matchesKey(frameOpts[1], key: "five", opts: frameOpts))

        // Empty keys never grade.
        XCTAssertFalse(PlayerModel.matchesKey(opts[0], key: "", opts: opts))
        XCTAssertFalse(PlayerModel.matchesKey(opts[0], key: nil, opts: opts))
    }
}
