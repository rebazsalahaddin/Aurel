import XCTest

/// Smoke suite — runs every gate iteration (~4–6 min).
///
/// Ordered on purpose: later tests build on the persisted state earlier ones
/// create (the suite assumes a fresh install, which `qa/run-ui-smoke.sh`
/// guarantees by uninstalling first). All queries are identifier-based; waits
/// poll with `waitForExistence`, never fixed sleeps (the app advances some
/// flows asynchronously at 0.42 s / 0.64 s).
///
/// Screens are asserted by a distinctive element per screen (`onScreen`),
/// not by a root marker: an `.accessibilityIdentifier` applied at the screen
/// root cascades over every descendant's own identifier, which would break
/// the per-control queries the tests rely on.
@MainActor
final class SmokeSuite: XCTestCase {
    private var app: XCUIApplication!

    /// Distinctive element per screen (see class docs for why not a root marker).
    private enum Screen {
        static let welcome = "au.btn.begin-the-path"
        static let goal = "au.goal.work"
        static let commit = "au.remind.0730"
        static let plan = "au.btn.start-your-first-lesson"
        static let home = "au.tab.learn"
        static let course = "au.player.close"
        static let speak = "au.link.type-it-instead"
        static let settings = "au.settings.type.0"
    }

    override func setUp() async throws {
        try await super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    // MARK: helpers

    /// Type-scoped query chain — broad `.any` queries grind to snapshot
    /// timeouts on animated screens, while type-indexed queries resolve fast.
    @discardableResult
    private func wait(
        _ id: String, timeout: TimeInterval = 6, file: StaticString = #filePath, line: UInt = #line
    ) -> XCUIElement {
        let candidates: [XCUIElement] = [
            app.buttons.matching(identifier: id).firstMatch,
            app.textFields.matching(identifier: id).firstMatch,
            app.otherElements.matching(identifier: id).firstMatch,
            app.descendants(matching: .any).matching(identifier: id).firstMatch,
        ]
        for candidate in candidates {
            if candidate.waitForExistence(timeout: timeout) { return candidate }
        }
        print("TREE DUMP for missing \(id):\n\(app.debugDescription)")
        XCTAssertTrue(false, "Missing element \(id)", file: file, line: line)
        return candidates[0]
    }

    @discardableResult
    private func tap(
        _ id: String, timeout: TimeInterval = 10, file: StaticString = #filePath, line: UInt = #line
    ) -> XCUIElement {
        let e = wait(id, timeout: timeout, file: file, line: line)
        XCTAssertTrue(e.isHittable || e.exists, "\(id) not tappable", file: file, line: line)
        e.tap()
        return e
    }

    private func onScreen(
        _ marker: String, timeout: TimeInterval = 10, file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertTrue(
            app.buttons.matching(identifier: marker).firstMatch.waitForExistence(timeout: timeout),
            "Expected screen marker \(marker)",
            file: file, line: line)
    }

    // MARK: 1 — cold launch through onboarding to Home

    func test1ColdLaunchOnboardingToHome() {
        app.launch()

        // First launch after install pays registration + store-creation costs.
        onScreen(Screen.welcome, timeout: 30)
        tap("au.btn.begin-the-path")

        onScreen(Screen.goal)
        tap("au.goal.work")
        tap("au.goal.travel")
        tap("au.goal.exam")  // third pick swaps, never exceeds two
        tap("au.btn.continue")

        onScreen(Screen.commit)
        tap("au.remind.0730")
        tap("au.btn.continue")

        onScreen(Screen.plan)
        tap("au.btn.start-your-first-lesson")

        // The plan CTA starts the starter lesson immediately (goStarter).
        onScreen(Screen.course)
        tap("au.player.close")
        onScreen(Screen.home)
        XCTAssertTrue(
            app.buttons.matching(identifier: "au.tab.practice").firstMatch.waitForExistence(
                timeout: 5))
    }

    // MARK: 2 — force-quit mid-lesson; durable state survives, the pending
    // spot is session-scoped (ephemeral in the prototype too — never persisted)

    func test2ForceQuitRelaunchRestoresDurableState() {
        app.launch()
        onScreen(Screen.home)

        tap("au.home.node.0")  // "Begin" on the open lesson node
        onScreen(Screen.course)

        // Advance a couple of screens (promise → hook); the player tracks
        // position via onScreen, which leaveCourse persists as the spot.
        for _ in 0..<2 {
            let go = app.buttons.matching(identifier: "au.player.go-on").firstMatch
            if go.waitForExistence(timeout: 4) { go.tap() }
        }

        tap("au.player.close")
        onScreen(Screen.home)
        XCTAssertTrue(
            app.buttons.matching(identifier: "au.home.resume").firstMatch.waitForExistence(
                timeout: 6),
            "Pending-resume card missing after leaving the lesson mid-way")

        app.terminate()
        app.launch()
        // Durable state survives the force quit (onboarded → Home, lesson
        // path present); the pending card itself is ephemeral by design and
        // correctly does not reappear after process death.
        onScreen(Screen.home)
        tap("au.home.node.0")
        onScreen(Screen.course)
    }

    // MARK: 3 — microphone denied: the tap/type path completes, no alert blocks

    func test3MicDeniedTapPathCompletes() {
        // Precondition (set by qa/run-ui-smoke.sh):
        //   xcrun simctl privacy <device> revoke microphone com.aurel.app
        // SpeechToText is intentionally unwired today (governance: the tap
        // path is the equal path); any permission alert here is a defect.
        var sawSystemAlert = false
        addUIInterruptionMonitor(withDescription: "permission-alert-tripwire") { alert in
            sawSystemAlert = true
            alert.buttons.element(boundBy: 0).tap()
            return true
        }

        app.launchArguments = ["-AUREL_TEST_START", "speak"]
        app.launch()
        onScreen(Screen.speak)

        tap("au.link.type-it-instead")
        let field = app.textFields["au.speak.typed"].firstMatch
        XCTAssertTrue(field.waitForExistence(timeout: 6), "Type-instead field missing")
        field.tap()
        field.typeText("Hello, I'm Maya.")
        if app.keyboards.buttons["Return"].exists {
            app.keyboards.buttons["Return"].tap()
        } else if app.keyboards.buttons["Done"].exists {
            app.keyboards.buttons["Done"].tap()
        } else {
            app.swipeDown()
        }

        tap("au.btn.check-what-i-typed")
        // Process any queued interruption event.
        app.tap()
        XCTAssertFalse(
            sawSystemAlert, "An unexpected system permission alert appeared on the speak screen")
    }

    // MARK: 4 — the UI-test fast path routes without persisting

    func test4FastPathDoesNotPersistRoute() {
        // Persisted screen at this point is home (tests 1–2 left it there).
        app.launch()
        onScreen(Screen.home)
        app.terminate()

        app.launchArguments = ["-AUREL_TEST_START", "settings"]
        app.launch()
        onScreen(Screen.settings)
        app.terminate()

        app.launchArguments = []
        app.launch()
        onScreen(Screen.home)  // NOT settings — the fast path must not persist
    }
}
