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
    /// real clarity check evaluates the transcript.
    func testRapidToggleSpeakRestartsTakeWindow() async throws {
        let r = AppRouter(course: CourseDecodingTests.store)
        let fake = FakeTakeRecorder()
        r.say.recorder = fake
        r.say.onDeviceRecognitionProbe = { true }
        r.say.micPermissionProbe = { .granted }
        r.say.transcriber = { _ in "hello world" }
        r.toggleSpeak(target: "hello world")  // take 1 starts
        r.toggleSpeak(target: "hello world")  // manual stop
        r.toggleSpeak(target: "hello world")  // take 2 starts — must get its own 2.6 s window
        XCTAssertTrue(r.speaking, "the restarted take must run")
        r.stopSpeak()
        try await Task.sleep(for: .milliseconds(50))
        XCTAssertEqual(r.speakTake, 2)
        XCTAssertEqual(r.speakVerdict, .clear)
        XCTAssertFalse(r.speaking)
    }

    /// The tab surfaces after the Phase-2 swap: Settings is the fourth tab;
    /// Profile stays a tab surface (reachable from the Home header button).
    func testTabSurfaceMembershipAfterSettingsSwap() {
        let tabs: [AppRouter.Screen] = [.home, .stories, .progress, .profile, .leaderboard, .settings]
        for screen in tabs {
            XCTAssertTrue(screen.showsTabs, "\(screen) must show the tab bar")
        }
        XCTAssertFalse(AppRouter.Screen.course.showsTabs)
        XCTAssertFalse(AppRouter.Screen.paywall.showsTabs)
        XCTAssertEqual(AppRouter.topLevelSection(for: .settings), .you)
    }

    /// Legacy verification routes remain nameable, but release capabilities
    /// cannot turn them into a simulated account or entitlement.
    func testSubscribeAccountRoutesCannotGrantReleaseEntitlement() {
        let r = AppRouter(course: CourseDecodingTests.store)
        XCTAssertEqual(AppRouter.Screen.named("subscribeAccount"), .subscribeAccount)
        XCTAssertEqual(AppRouter.Screen.subscribeAccount.rawName, "subscribeAccount")
        XCTAssertFalse(AppRouter.Screen.subscribeAccount.showsTabs)

        r.screen = .home
        r.startSubscribe()
        XCTAssertEqual(r.screen, .home)
        XCTAssertFalse(r.pro)
        XCTAssertEqual(r.loginErr, "Subscriptions aren't available in this build.")

        r.setEmail("learner@example.com")
        r.setPass("secret123")
        r.createAccountAndSubscribe()
        XCTAssertFalse(r.pro)
        XCTAssertEqual(r.screen, .home)
        XCTAssertEqual(r.loginErr, "Account subscriptions aren't available in this build.")
    }

    // MARK: S1-009 — day rollover, streak counting, grace

    private let dayCal: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "UTC")!
        return c
    }()

    private func day(_ y: Int, _ m: Int, _ d: Int) -> Date {
        dayCal.date(from: DateComponents(year: y, month: m, day: d))!
    }

    /// The full authored loop: both halves → the day counts; a single
    /// missed day burns a grace token; the flags reset for the new day.
    /// (AppRouter.init seeds `activeDay` with the real today — the test
    /// starts from a controlled day 1.)
    func testDayRolloverCountsCompleteDaysAndBridgesSingleMiss() {
        let r = AppRouter(course: CourseDecodingTests.store)

        // Day 1, banked chain 0 — both halves done: streak 1, day counted.
        r.activeDay = day(2026, 8, 19)
        r.dayStartStreak = 0
        r.streak = 0
        r.dayLesson = false
        r.dayRecall = false
        r.dayCounted = false
        r.dayLesson = true
        r.streak = max(r.streak, 1)  // the lesson half's authored display rule
        r.dayRecall = true
        r.dayHalfCompleted()
        XCTAssertEqual(r.streak, 1)
        XCTAssertTrue(r.dayCounted)

        // Day 2 arrives (gap 1) with day 1 counted: chain carries, banked = 1.
        r.rolloverDayIfNeeded(now: day(2026, 8, 20), calendar: dayCal)
        XCTAssertEqual(r.streak, 1, "the counted day's point stays banked")
        XCTAssertEqual(r.dayStartStreak, 1)
        XCTAssertFalse(r.dayLesson, "the new day's halves reset")
        XCTAssertFalse(r.dayRecall)
        XCTAssertFalse(r.dayCounted)

        // Day 3 arrives (gap 1) with day 2 missed: grace bridges the chain.
        r.rolloverDayIfNeeded(now: day(2026, 8, 21), calendar: dayCal)
        XCTAssertEqual(r.streak, 1, "an isolated miss burns a token, not the chain")
        XCTAssertEqual(r.graceUsed, 1)
        XCTAssertEqual(r.dayStartStreak, 1)

        // Day 3 completes both halves: the streak grows by exactly one.
        r.dayLesson = true
        r.streak = max(r.streak, 1)
        r.dayRecall = true
        r.dayHalfCompleted()
        XCTAssertEqual(r.streak, 2)
        // A second dayHalfCompleted call must not double-count.
        r.dayHalfCompleted()
        XCTAssertEqual(r.streak, 2)
    }

    /// A longer gap resets — grace is for isolated misses only.
    func testLongGapResetsStreak() {
        let r = AppRouter(course: CourseDecodingTests.store)
        r.activeDay = day(2026, 8, 10)
        r.dayStartStreak = 5
        r.streak = 6
        r.dayCounted = true
        r.rolloverDayIfNeeded(now: day(2026, 8, 20), calendar: dayCal)
        XCTAssertEqual(r.streak, 6, "a counted closing day banks its point")
        XCTAssertFalse(r.dayCounted)

        r.activeDay = day(2026, 8, 20)
        r.dayStartStreak = 6
        r.streak = 6
        r.dayCounted = false
        r.rolloverDayIfNeeded(now: day(2026, 8, 27), calendar: dayCal)  // gap 7
        XCTAssertEqual(r.streak, 0, "a week away resets the chain")
    }

    /// The second grace token bridges; the third miss resets.
    func testGraceTokensAreLimitedToTwoPerMonth() {
        var ruling = StreakEngine.rolloverRuling(
            closingDayCounted: false, gapDays: 1, graceMonth: 202608, graceUsed: 2,
            today: day(2026, 8, 15), calendar: dayCal)
        XCTAssertFalse(ruling.chainContinues, "the third miss in a month resets")

        ruling = StreakEngine.rolloverRuling(
            closingDayCounted: false, gapDays: 1, graceMonth: 202607, graceUsed: 2,
            today: day(2026, 8, 15), calendar: dayCal)
        XCTAssertTrue(ruling.chainContinues, "a new month refills the tokens")
        XCTAssertEqual(ruling.graceUsed, 1)

        ruling = StreakEngine.rolloverRuling(
            closingDayCounted: true, gapDays: 1, graceMonth: 202608, graceUsed: 0,
            today: day(2026, 8, 15), calendar: dayCal)
        XCTAssertTrue(ruling.chainContinues, "a complete day never spends grace")
        XCTAssertEqual(ruling.graceUsed, 0)
    }
}
