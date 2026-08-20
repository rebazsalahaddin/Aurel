import XCTest

@testable import Aurel

/// The spaced-retrieval scheduler and the non-punitive streak rules.
final class ServicesTests: XCTestCase {
    // MARK: Review scheduler (1 → 3 → 7 → 14 → 30)

    func testIntervalLadder() {
        XCTAssertEqual(ReviewScheduler.nextInterval(after: 1), 3)
        XCTAssertEqual(ReviewScheduler.nextInterval(after: 3), 7)
        XCTAssertEqual(ReviewScheduler.nextInterval(after: 7), 14)
        XCTAssertEqual(ReviewScheduler.nextInterval(after: 14), 30)
        XCTAssertNil(ReviewScheduler.nextInterval(after: 30), "the 30-day catch graduates the item")
    }

    func testUnknownIntervalStartsAtOne() {
        XCTAssertEqual(ReviewScheduler.nextInterval(after: 0), 1)
    }

    func testDueLabels() {
        let cal = Calendar.current
        XCTAssertEqual(
            ReviewScheduler.dueLabel(for: cal.date(byAdding: .day, value: 0, to: Date())!),
            "Due today")
        XCTAssertEqual(
            ReviewScheduler.dueLabel(for: cal.date(byAdding: .day, value: 1, to: Date())!),
            "Due tomorrow")
        XCTAssertEqual(
            ReviewScheduler.dueLabel(for: cal.date(byAdding: .day, value: 4, to: Date())!),
            "Due in 4 days")
    }

    // MARK: Streak engine — a day counts only when both halves are done

    func testDayNeedsBothHalves() {
        XCTAssertFalse(StreakEngine.dayComplete(lesson: true, recall: false))
        XCTAssertFalse(StreakEngine.dayComplete(lesson: false, recall: true))
        XCTAssertTrue(StreakEngine.dayComplete(lesson: true, recall: true))
    }

    func testGraceTokens() {
        XCTAssertEqual(StreakEngine.graceRemaining(usedThisMonth: 0), 2)
        XCTAssertEqual(StreakEngine.graceRemaining(usedThisMonth: 1), 1)
        XCTAssertEqual(StreakEngine.graceRemaining(usedThisMonth: 2), 0)
        XCTAssertEqual(StreakEngine.graceRemaining(usedThisMonth: 3), 0, "never negative")
    }

    // MARK: Quick bank — the practice draw comes from authored content only

    func testQuickBankBuildsFromCourse() {
        let bank = QuickItem.bank(from: CourseDecodingTests.store)
        XCTAssertGreaterThanOrEqual(bank.count, 5, "flash + 2 choice + 2 listen + 1 order")
        XCTAssertTrue(bank.contains { $0.type == .flash })
        XCTAssertTrue(bank.contains { $0.type == .choice })
        XCTAssertTrue(bank.contains { $0.type == .order })
        // every item traces to a chapter source
        for item in bank {
            XCTAssertTrue(item.src.contains("A1-C"), "\(item.id) has no source")
        }
    }

    func testSceneScriptFromCourse() {
        let scene = SceneScript.newest(from: CourseDecodingTests.store)
        XCTAssertFalse(scene.title.isEmpty)
        XCTAssertFalse(scene.turns.isEmpty)
        XCTAssertGreaterThan(scene.turns[0].replies.count, 0)
    }

    // MARK: joinTiles — punctuation attaches, emails are tight

    @MainActor
    func testJoinTiles() {
        XCTAssertEqual(PlayerModel.joinTiles(["I'm", "Maya", "."], tight: false), "I'm Maya.")
        XCTAssertEqual(PlayerModel.joinTiles(["a", "b", ".", "com"], tight: true), "ab.com")
        XCTAssertEqual(PlayerModel.joinTiles(["Hello", "!"], tight: false), "Hello!")
    }
}
