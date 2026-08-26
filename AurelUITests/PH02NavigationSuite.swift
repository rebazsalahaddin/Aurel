import XCTest

/// Focused PH-02 UI coverage only: the one Learn recommendation and the
/// distinct jobs exposed by the four retained tabs.
@MainActor
final class PH02NavigationSuite: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() async throws {
        try await super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-AUREL_TEST_START", "home"]
        app.launch()
    }

    func testFourTabJobsAndNextActionContractsAreVisible() {
        // The header button is the You/profile placeholder; Settings lives in
        // the tab bar (Enhancement doc Phase 1 swap).
        assertExists("au.home.profile", type: .button)
        assertExists("au.home.recommendation.title", type: .other)
        assertExists("au.home.today", type: .button)
        assertExists("au.home.lesson-details", type: .button)
        tap("au.home.lesson-details")
        assertExists("au.home.lesson-description", type: .other)

        tap("au.tab.practice")
        assertExists("au.practice.purpose", type: .other)

        tap("au.tab.progress")
        assertExists("au.progress.purpose", type: .other)
        assertExists("au.progress.level-explanation", type: .other)
        assertExists("au.progress.recommendation.title", type: .other)

        tap("au.tab.settings")
        assertExists("au.settings.purpose", type: .other)

        tap("au.tab.learn")
        tap("au.home.profile")
        assertExists("au.profile.purpose", type: .other)
        assertExists("au.profile.practice-chapter-one", type: .button)
    }

    func testRestartRequiresConfirmationAndCancelPreservesResume() {
        revealAndTap("au.home.node.0")
        assertExists("au.player.close", type: .button)
        tap("au.player.close")
        assertExists("au.home.resume", type: .button)

        tap("au.home.start-over")
        assertExists("au.home.restart.confirmation", type: .other)
        XCTAssertTrue(app.staticTexts["Restart lesson?"].exists)
        XCTAssertTrue(app.staticTexts["Today’s lesson progress will be cleared."].exists)
        tap("au.home.restart.cancel")

        assertExists("au.home.resume", type: .button)
    }

    func testLockedChapterOpensAccessRoute() {
        let nextChapter = app.buttons.matching(identifier: "au.home.next-chapter").firstMatch
        for _ in 0..<5 where !nextChapter.exists {
            app.swipeUp()
        }

        XCTAssertTrue(nextChapter.waitForExistence(timeout: 8))
        XCTAssertTrue(nextChapter.isEnabled)
        nextChapter.tap()
        assertExists("au.capability.chapters-unavailable", type: .other)
    }

    private func tap(_ id: String) {
        let element = app.buttons.matching(identifier: id).firstMatch
        XCTAssertTrue(element.waitForExistence(timeout: 8), "Missing button \(id)")
        element.tap()
    }

    /// Path stops can sit behind the floating tab bar when the content above
    /// is tall (pending lesson + day-complete state). Scroll the stop clear
    /// of the bar before tapping — exactly what a user does.
    private func revealAndTap(_ id: String) {
        let element = app.buttons.matching(identifier: id).firstMatch
        XCTAssertTrue(element.waitForExistence(timeout: 8), "Missing button \(id)")
        let bar = app.buttons.matching(identifier: "au.tab.practice").firstMatch
        if bar.exists, element.frame.maxY > bar.frame.minY - 8 {
            let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.82))
            let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.62))
            start.press(forDuration: 0.02, thenDragTo: end)
        }
        element.tap()
    }

    private func assertExists(_ id: String, type: XCUIElement.ElementType) {
        let query: XCUIElement
        switch type {
        case .button:
            query = app.buttons.matching(identifier: id).firstMatch
        default:
            query = app.descendants(matching: .any).matching(identifier: id).firstMatch
        }
        XCTAssertTrue(query.waitForExistence(timeout: 8), "Missing element \(id)")
    }
}
