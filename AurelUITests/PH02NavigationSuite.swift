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
        // The reset keeps the suite hermetic: a previous Xcode run's
        // persisted chapter shell, lesson records, and pending card would
        // otherwise re-shape Home (return card, done stops) and shift every
        // asserted element.
        app.launchArguments = ["-AUREL_TEST_RESET", "-AUREL_TEST_START", "home"]
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
        // Park the shell on the last authored chapter: its successor is
        // planned but not bundled, so the next-chapter card keeps the access
        // route — a locked chapter is never a dead end. (On earlier chapters
        // the card opens the bundled successor directly on Home.)
        app.terminate()
        app.launchArguments = [
            "-AUREL_TEST_RESET", "-AUREL_TEST_START", "home",
            "-AUREL_CHAPTER_INDEX", "\(Self.lastAuthoredChapterIdx)",
        ]
        app.launch()
        XCTAssertTrue(
            app.buttons.matching(identifier: "au.tab.learn").firstMatch.waitForExistence(
                timeout: 10))

        let nextChapter = app.buttons.matching(identifier: "au.home.next-chapter").firstMatch
        XCTAssertTrue(nextChapter.waitForExistence(timeout: 8))
        XCTAssertTrue(nextChapter.isEnabled)
        // The card sits at the path's end; scroll it clear of the floating
        // tab bar before tapping, exactly what a user does.
        for _ in 0..<6 where !nextChapter.isHittable {
            app.swipeUp()
        }
        XCTAssertTrue(nextChapter.isHittable, "the next-chapter card never scrolled into view")
        nextChapter.tap()
        assertExists("au.capability.chapters-unavailable", type: .other)
    }

    /// The last bundled chapter hosts the plan-only successor, so it is the
    /// one surface where the next-chapter card keeps its access route.
    private static let lastAuthoredChapterIdx: Int = {
        guard
            let url = Bundle(for: PH02NavigationSuite.self).url(
                forResource: "a1-course", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let chapters = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
        else { return 0 }
        return max(0, chapters.count - 1)
    }()

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
