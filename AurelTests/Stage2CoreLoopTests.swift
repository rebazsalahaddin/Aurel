import SwiftData
import XCTest

@testable import Aurel

/// Stage-2 core-loop regression (IMPROVEMENT_PLAN.md §3.13–3.14): the data
/// the Result screen renders must be real — DayLog-backed week dots,
/// session-timed minutes, no fixture numbers.
@MainActor
final class Stage2CoreLoopTests: XCTestCase {
    private func makeContext() throws -> ModelContext {
        let container = try AppSchema.makeContainer(inMemory: true)
        return ModelContext(container)
    }

    /// §3.14 — the day's halves land in one upserted DayLog row.
    func testUpsertDayLogRecordsHalvesAsTheyLand() throws {
        let ctx = try makeContext()
        let r = AppRouter(course: CourseDecodingTests.store, modelContext: ctx)

        r.dayLesson = true
        r.upsertDayLog()
        var logs = try ctx.fetch(FetchDescriptor<DayLog>())
        XCTAssertEqual(logs.count, 1, "one row per day")
        XCTAssertTrue(logs[0].lessonDone)
        XCTAssertFalse(logs[0].recallDone)

        r.dayRecall = true
        r.upsertDayLog(caughtDelta: 3)
        logs = try ctx.fetch(FetchDescriptor<DayLog>())
        XCTAssertEqual(logs.count, 1, "upsert, not append")
        XCTAssertTrue(logs[0].lessonDone)
        XCTAssertTrue(logs[0].recallDone)
        XCTAssertEqual(logs[0].caught, 3)
    }

    /// §3.14 — a week dot fills only when both halves landed that day, and
    /// days after today stay dark.
    func testWeekCompletedDaysCountsOnlyBothHalvesDays() throws {
        let ctx = try makeContext()
        let r = AppRouter(course: CourseDecodingTests.store, modelContext: ctx)

        // No history at all: every day false.
        XCTAssertEqual(r.weekCompletedDays(), Array(repeating: false, count: 7))

        // One full day — today.
        r.dayLesson = true
        r.dayRecall = true
        r.upsertDayLog()
        let week = r.weekCompletedDays()
        let cal = Calendar.current
        let weekday = (cal.component(.weekday, from: Date()) + 5) % 7  // Mon = 0
        XCTAssertTrue(week[weekday], "today's dot fills when both halves land")
        XCTAssertTrue(week[(weekday + 1)...].allSatisfy { !$0 }, "future days stay dark")
        // A lesson-only day does not count (both halves are the rule).
        let ctx2 = try makeContext()
        let r2 = AppRouter(course: CourseDecodingTests.store, modelContext: ctx2)
        r2.dayLesson = true
        r2.upsertDayLog()
        XCTAssertFalse(
            r2.weekCompletedDays()[weekday], "a half-day must not fill the dot")
    }

    /// §3.14 — the Minutes tile counts real elapsed time, rounded up, with
    /// an honest floor of one.
    func testSessionMinutesCountsRealElapsedRoundsUpMinimumOne() {
        let r = AppRouter(course: CourseDecodingTests.store)
        XCTAssertEqual(r.sessionMinutes, 1, "no clock started — honest floor")

        r.sessionStart = Date(timeIntervalSinceNow: -125)  // 2 m 05 s → 3
        XCTAssertEqual(r.sessionMinutes, 3)
        r.sessionStart = Date(timeIntervalSinceNow: -30)  // 30 s → 1
        XCTAssertEqual(r.sessionMinutes, 1)
    }

    /// §3.13/§3.14 — every quick-practice run starts its own clock.
    func testResetLessonStartsTheSessionClock() {
        let r = AppRouter(course: CourseDecodingTests.store)
        XCTAssertNil(r.sessionStart)
        r.resetLesson()
        XCTAssertNotNil(r.sessionStart, "every quick-practice run starts its own clock")
    }
}
