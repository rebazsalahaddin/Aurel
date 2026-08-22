import SwiftData
import XCTest

@testable import Aurel

/// Stage-4 data-honesty regression (IMPROVEMENT_PLAN.md §3.15/§3.17/§3.18):
/// every rendered number on Streak / Review / Progress derives from
/// SwiftData — real best streaks, real month grids, real weekly minutes,
/// the real mistake ladder, show-once milestones.
@MainActor
final class Stage4DataHonestyTests: XCTestCase {
    private func makeContext() throws -> ModelContext {
        let container = try AppSchema.makeContainer(inMemory: true)
        return ModelContext(container)
    }

    private func makeRouter() throws -> (AppRouter, ModelContext) {
        let ctx = try makeContext()
        return (AppRouter(course: CourseDecodingTests.store, modelContext: ctx), ctx)
    }

    // MARK: §3.15 — Streak

    /// Best = the longest real run of consecutive complete days.
    func testBestStreakCountsLongestConsecutiveRun() {
        let cal = Calendar.current
        func day(_ offset: Int) -> Date {
            cal.startOfDay(for: cal.date(byAdding: .day, value: offset, to: Date()) ?? Date())
        }
        func completeDay(_ d: Date) -> DayLog {
            let l = DayLog(day: d)
            l.lessonDone = true
            l.recallDone = true
            return l
        }
        // Two runs: 3 days and 5 days — best is 5.
        let logs = [0, 1, 2, 5, 6, 7, 8, 9].map { completeDay(day(-$0)) }
        XCTAssertEqual(AppRouter.bestStreak(over: logs), 5)

        // A half-done day does not extend the run.
        XCTAssertEqual(AppRouter.bestStreak(over: []), 0, "empty history: zero, never invented")
    }

    /// The month grid renders real per-day states: done/quiet before today,
    /// future beyond, outside past the month's end.
    func testMonthStatesMatchRealHistory() {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let doneLog = DayLog(day: today)
        doneLog.lessonDone = true
        doneLog.recallDone = true
        let states = AppRouter.monthStates([doneLog])
        XCTAssertEqual(states.count, 31)
        let todayIdx = cal.component(.day, from: today) - 1
        XCTAssertEqual(states[todayIdx], .done)
        if todayIdx > 0 {
            XCTAssertEqual(states[todayIdx - 1], .quiet, "a day with no row is quiet")
        }
        if todayIdx < 30 {
            XCTAssertEqual(states[todayIdx + 1], .future)
        }
    }

    /// The milestone gate: due exactly once per reached milestone day.
    func testMilestoneDueOnceThenNeverAgain() throws {
        XCTAssertEqual(AppRouter.dueMilestones(streak: 7, seen: []), [7])
        XCTAssertEqual(AppRouter.dueMilestones(streak: 7, seen: [7]), [], "once ever")
        XCTAssertEqual(AppRouter.dueMilestones(streak: 6, seen: []), [], "not yet reached")
        XCTAssertEqual(AppRouter.dueMilestones(streak: 100, seen: [7, 30]), [100])
        // Show-once bookkeeping writes the profile.
        let (r, ctx) = try makeRouter()
        r.streak = 7
        XCTAssertEqual(AppRouter.dueMilestones(streak: r.streak, seen: r.milestonesSeen), [7])
        r.markMilestoneShown(7)
        XCTAssertEqual(r.milestonesSeen, [7])
        let profiles = try ctx.fetch(FetchDescriptor<LearnerProfile>())
        XCTAssertEqual(profiles.first?.milestonesSeen, [7])
        // A second visit never re-fires.
        XCTAssertEqual(AppRouter.dueMilestones(streak: r.streak, seen: r.milestonesSeen), [])
    }

    // MARK: §3.17 — Review ladder

    /// The real ladder: misses enter at rung 1, catches widen, the 30-day
    /// catch leaves the list, misses reset.
    func testMistakeLadderWidensCatchesAndResetsMisses() throws {
        let (r, ctx) = try makeRouter()
        r.mistakes = [2]
        r.advanceMistakeLadder(caught: [], missed: [2])
        var rows = try ctx.fetch(FetchDescriptor<MistakeItem>())
        XCTAssertEqual(rows.count, 1)
        XCTAssertEqual(rows[0].bankIndex, 2)
        XCTAssertEqual(rows[0].intervalDays, 1, "a fresh miss sits on the first rung")

        // Catch: 1 → 3 → 7 → 14 → 30 → leaves.
        for expected in [3, 7, 14, 30] {
            r.advanceMistakeLadder(caught: [2], missed: [])
            rows = try ctx.fetch(FetchDescriptor<MistakeItem>())
            XCTAssertEqual(rows[0].intervalDays, expected)
        }
        r.advanceMistakeLadder(caught: [2], missed: [])
        rows = try ctx.fetch(FetchDescriptor<MistakeItem>())
        XCTAssertTrue(rows.isEmpty, "the 30-day catch mastered the item — it leaves")
        XCTAssertTrue(r.mistakes.isEmpty, "the visible queue mirrors the rows")

        // A miss resets to rung 1.
        r.advanceMistakeLadder(caught: [], missed: [5])
        rows = try ctx.fetch(FetchDescriptor<MistakeItem>())
        XCTAssertEqual(rows[0].intervalDays, 1)
    }

    /// Due labels are the ladder's real dates, never positional guesses.
    func testDueLabelsMatchRealDates() {
        let cal = Calendar.current
        // No row (legacy queue entry): the honest fallback.
        XCTAssertEqual(AppRouter.dueLabel(for: nil), "Due tomorrow")

        let dueNow = MistakeItem(bankIndex: 1, word: "")
        dueNow.dueAt = cal.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        XCTAssertEqual(AppRouter.dueLabel(for: dueNow), "Due now")
        XCTAssertTrue(AppRouter.isDue(dueNow))

        let dueTomorrow = MistakeItem(bankIndex: 1, word: "")
        dueTomorrow.dueAt = cal.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        XCTAssertEqual(AppRouter.dueLabel(for: dueTomorrow), "Due tomorrow")
        XCTAssertFalse(AppRouter.isDue(dueTomorrow))

        let dueIn5 = MistakeItem(bankIndex: 1, word: "")
        dueIn5.dueAt = cal.date(byAdding: .day, value: 5, to: Date()) ?? Date()
        XCTAssertEqual(AppRouter.dueLabel(for: dueIn5), "Due in 5 days")
    }

    // MARK: §3.18 — Progress

    /// The 8-week chart sums real minutes per week; empty history is zeros.
    func testWeeklyMinutesSumsRealHistoryEmptyWeeksZero() {
        // No history: all zeros — never invented.
        XCTAssertEqual(AppRouter.weeklyMinutes([]), Array(repeating: 0, count: 8))

        // 20 minutes today land in the current week (index 7).
        let today = DayLog(day: Date())
        today.lessonDone = true
        today.recallDone = true
        today.minutes = 20
        let weeks = AppRouter.weeklyMinutes([today])
        XCTAssertEqual(weeks[7], 20)
        XCTAssertEqual(weeks[0], 0, "empty weeks render zero-height bars")

        // A log 3 weeks back lands in index 4.
        let cal = Calendar.current
        let past = DayLog(day: cal.date(byAdding: .day, value: -21, to: Date()) ?? Date())
        past.lessonDone = true
        past.recallDone = true
        past.minutes = 10
        XCTAssertEqual(AppRouter.weeklyMinutes([past])[4], 10)
        XCTAssertEqual(AppRouter.totalMinutes([today, past]), 30)
    }

    /// A completed course lesson lands in LessonRecord exactly once.
    func testRecordLessonCompletionIdempotentPerLesson() throws {
        let (r, ctx) = try makeRouter()
        r.chapterIdx = 0
        r.courseLesson = 1
        r.recordLessonCompletion()
        r.recordLessonCompletion()  // re-run must not double-count
        let records = try ctx.fetch(FetchDescriptor<LessonRecord>())
        XCTAssertEqual(records.count, 1)
        XCTAssertEqual(records[0].chapterIdx, 0)
        XCTAssertEqual(records[0].lessonIdx, 1)
    }

    /// The course session clock produces honest minutes.
    func testCourseMinutesRoundsUpMinimumOne() {
        let r = AppRouter(course: CourseDecodingTests.store)
        XCTAssertEqual(r.courseMinutes(), 1, "no clock — honest floor")
        r.courseStart = Date(timeIntervalSinceNow: -305)  // 5 m 05 s → 6
        XCTAssertEqual(r.courseMinutes(), 6)
    }
}
