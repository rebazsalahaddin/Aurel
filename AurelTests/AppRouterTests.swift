import SwiftData
import XCTest

@testable import Aurel

/// Router course-entry math (S1-007 regression).
///
/// `goCourse` must honor the chapter's own lesson count: C3 has three
/// lessons, so its "Chapter complete" state passes i = 3 — the original
/// `i >= 4` hardwiring sent that to `coursePos(lessonIdx: 3)`, which falls
/// through to 0 and reopened Chapter 1 · Lesson 1 instead of the chapter map.
@MainActor
final class AppRouterTests: XCTestCase {
    func testChapterCompleteRoutesToChapterMapOnThreeLessonChapter() {
        let store = CourseDecodingTests.store
        let r = AppRouter(course: store)

        // C3 (three lessons) complete: pathAt = 3 → the chapter map.
        r.chapterIdx = 2
        r.goCourse(3)
        XCTAssertEqual(r.screen, .course)
        XCTAssertEqual(
            r.coursePos, store.chapterEndPos(2),
            "C3 completion must open the chapter map, not C1 · L1 · S01")
        XCTAssertNotEqual(r.coursePos, 0)

        // Four-lesson chapters keep the authored behavior exactly.
        r.chapterIdx = 0
        r.goCourse(3)
        XCTAssertEqual(r.coursePos, store.coursePos(chapterIdx: 0, lessonIdx: 3))
        r.goCourse(4)
        XCTAssertEqual(r.coursePos, store.chapterEndPos(0))

        // Chapter-complete stays reachable past completion on C3 as well.
        r.chapterIdx = 2
        r.goCourse(4)
        XCTAssertEqual(r.coursePos, store.chapterEndPos(2))
    }

    /// S2-001: the AUREL_SCREEN debug hook routes — and nothing else (the
    /// old branch called persist(), stamping onboardedAt on debug launches).
    func testScreenHookIsPureRouting() {
        XCTAssertNil(AppRouter.screenHook([:]))
        XCTAssertNil(AppRouter.screenHook(["AUREL_SCREEN": "bogus"]))
        XCTAssertEqual(AppRouter.screenHook(["AUREL_SCREEN": "home"]), .home)
        XCTAssertEqual(AppRouter.screenHook(["AUREL_SCREEN": "settings"]), .settings)
    }

    // MARK: S2-002 — rapid interactions supersede pending transitions

    /// Rapid scene picks advance exactly one turn (old code: both stacked
    /// tasks fired and the turn jumped by two).
    func testRapidScenePicksAdvanceOneTurn() async throws {
        let r = AppRouter(course: CourseDecodingTests.store)
        r.pickSceneReply(0, turnCount: 3)
        r.pickSceneReply(1, turnCount: 3)
        try await Task.sleep(for: .seconds(0.9))
        XCTAssertEqual(r.sceneTurn, 1, "rapid picks must advance exactly one turn")
    }

    /// Leaving the scene cancels the pending turn advance.
    func testLeaveSceneCancelsPendingTurn() async throws {
        let r = AppRouter(course: CourseDecodingTests.store)
        r.pickSceneReply(0, turnCount: 3)
        r.leaveScene()
        try await Task.sleep(for: .seconds(0.9))
        XCTAssertEqual(r.sceneTurn, 0, "leaving must not advance the turn afterwards")
    }

    /// Restarting a speak take supersedes the first auto-stop: the second
    /// take runs its full window, one take is counted per stop, and the
    /// verdict ladder ("near" → "clear") stays correct.
    func testRapidToggleSpeakRestartsTakeWindow() async throws {
        let r = AppRouter(course: CourseDecodingTests.store)
        r.toggleSpeak()  // take 1 starts
        r.toggleSpeak()  // manual stop (near)
        r.toggleSpeak()  // take 2 starts — must get its own 2.6 s window
        XCTAssertTrue(r.speaking, "the restarted take must run")
        try await Task.sleep(for: .seconds(2.8))
        XCTAssertEqual(r.speakTake, 2)
        XCTAssertEqual(r.speakVerdict, "clear")
        XCTAssertFalse(r.speaking)
    }

    /// A pending assess transition never fires after the learner navigates
    /// away (old code: the stale task stomped the manual step change).
    func testAssessBackCancelsPendingAdvance() async throws {
        let r = AppRouter(course: CourseDecodingTests.store)
        r.assessStep = 1
        r.assessPick(0)  // pending advance to step 2 in 420 ms
        r.assessBack()  // learner goes back to step 0
        XCTAssertEqual(r.assessStep, 0)
        try await Task.sleep(for: .seconds(0.6))
        XCTAssertEqual(r.assessStep, 0, "the superseded transition must not fire")
    }
}
