import XCTest

/// Smoke suite — runs every gate iteration (~4–6 min).
///
/// Ordered on purpose: later tests build on the persisted state earlier ones
/// create (the suite assumes a fresh install, which `qa/run-ui-smoke.sh`
/// guarantees by uninstalling first). All queries are identifier-based; waits
/// poll with `waitForExistence`, never fixed sleeps (the app advances some
/// flows asynchronously at 0.42 s / 0.64 s).
final class SmokeSuite: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    // MARK: helpers

    @discardableResult
    private func wait(
        _ id: String, timeout: TimeInterval = 8, file: StaticString = #filePath, line: UInt = #line
    ) -> XCUIElement {
        let e = app.otherElements[id].firstMatch
        let any = app.descendants(matching: .any)[id].firstMatch
        let found = e.waitForExistence(timeout: timeout) || any.waitForExistence(timeout: 2)
        XCTAssertTrue(found, "Missing element \(id)", file: file, line: line)
        return any.firstMatch
    }

    @discardableResult
    private func tap(
        _ id: String, timeout: TimeInterval = 8, file: StaticString = #filePath, line: UInt = #line
    ) -> XCUIElement {
        let e = wait(id, timeout: timeout, file: file, line: line)
        XCTAssertTrue(e.isHittable || e.exists, "\(id) not tappable", file: file, line: line)
        e.tap()
        return e
    }

    private func expectScreen(_ rawName: String, file: StaticString = #filePath, line: UInt = #line)
    {
        XCTAssertTrue(
            app.descendants(matching: .any)["au.screen.\(rawName)"].firstMatch.waitForExistence(
                timeout: 8),
            "Expected screen au.screen.\(rawName)",
            file: file, line: line)
    }

    // MARK: 1 — cold launch through onboarding to Home

    func test1ColdLaunchOnboardingToHome() {
        app.launch()

        expectScreen("welcome")
        tap("au.btn.begin-the-path")

        expectScreen("goal")
        tap("au.goal.work")
        tap("au.goal.travel")
        tap("au.goal.exam")  // third pick swaps, never exceeds two
        tap("au.btn.continue")

        expectScreen("placement")
        tap("au.level.a1")
        tap("au.btn.continue")

        expectScreen("commit")
        tap("au.commit.10")
        tap("au.remind.0730")
        tap("au.btn.continue")

        expectScreen("plan")
        tap("au.btn.start-your-first-lesson")

        expectScreen("home")
        XCTAssertTrue(app.descendants(matching: .any)["au.tab.practice"].firstMatch.isHittable)
    }

    // MARK: 2 — force-quit mid-lesson, relaunch, resume the pending spot

    func test2ForceQuitRelaunchRestoresPendingSpot() {
        app.launch()
        expectScreen("home")

        tap("au.home.node.0")  // "Begin" on the open lesson node
        expectScreen("course")

        // Advance a couple of screens (promise → hook); the player tracks
        // position via onScreen, which leaveCourse persists as the spot.
        for _ in 0..<2 {
            let go = app.descendants(matching: .any)["au.player.go-on"].firstMatch
            if go.waitForExistence(timeout: 4) { go.tap() }
        }

        tap("au.player.close")
        expectScreen("home")
        XCTAssertTrue(
            app.descendants(matching: .any)["au.home.pending"].firstMatch.waitForExistence(
                timeout: 6),
            "Pending-resume card missing after leaving the lesson mid-way")

        app.terminate()
        app.launch()
        expectScreen("home")
        XCTAssertTrue(
            app.descendants(matching: .any)["au.home.pending"].firstMatch.waitForExistence(
                timeout: 6),
            "Pending spot did not survive a force-quit relaunch")

        tap("au.home.resume")
        expectScreen("course")
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
        expectScreen("speak")

        tap("au.link.type-it-instead")
        let field = app.textFields["au.speak.typed"].firstMatch
        XCTAssertTrue(field.waitForExistence(timeout: 6), "Type-instead field missing")
        field.tap()
        field.typeText("Hello, I'm Maya.")

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
        expectScreen("home")
        app.terminate()

        app.launchArguments = ["-AUREL_TEST_START", "settings"]
        app.launch()
        expectScreen("settings")
        app.terminate()

        app.launchArguments = []
        app.launch()
        expectScreen("home")  // NOT settings — the fast path must not persist
    }
}
