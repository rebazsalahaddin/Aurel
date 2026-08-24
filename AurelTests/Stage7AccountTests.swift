import XCTest
@testable import Aurel

@MainActor
final class Stage7AccountTests: XCTestCase {

    func testLoginValidation() {
        let router = AppRouter(course: CourseDecodingTests.store)

        // Empty / invalid email
        router.setEmail("invalid")
        router.setPass("secret123")
        router.signIn()
        XCTAssertEqual(router.loginErr, "That email address looks incomplete.")
        XCTAssertNotEqual(router.screen, AppRouter.Screen.home)

        // Short password
        router.setEmail("user@example.com")
        router.setPass("123")
        router.signIn()
        XCTAssertEqual(router.loginErr, "Passwords are at least six characters.")
        XCTAssertNotEqual(router.screen, AppRouter.Screen.home)

        // Valid credentials
        router.setEmail("user@example.com")
        router.setPass("validpassword")
        router.signIn()
        XCTAssertEqual(router.loginErr, "")
        XCTAssertEqual(router.screen, AppRouter.Screen.home)
    }

    func testPaywallDefaultAnnualPlan() {
        let router = AppRouter(course: CourseDecodingTests.store)
        XCTAssertEqual(router.plan, "annual")
    }

    func testSettingsFeedbackGateSync() {
        let router = AppRouter(course: CourseDecodingTests.store)

        router.sw.haptics = true
        router.sw.sound = true
        router.syncFeedbackGates()
        XCTAssertTrue(AUFeedback.isEnabled)
        XCTAssertTrue(AUSound.shared.isEnabled)

        router.toggleSw(\AppRouter.SwitchPrefs.haptics)
        XCTAssertFalse(router.sw.haptics)
        XCTAssertFalse(AUFeedback.isEnabled)

        router.toggleSw(\AppRouter.SwitchPrefs.sound)
        XCTAssertFalse(router.sw.sound)
        XCTAssertFalse(AUSound.shared.isEnabled)
    }

    func testSubscribeFlowHonesty() {
        let router = AppRouter(course: CourseDecodingTests.store)

        // Without account, startSubscribe directs to account creation
        router.setEmail("")
        router.startSubscribe()
        XCTAssertEqual(router.screen, AppRouter.Screen.subscribeAccount)

        // With account, activates subscription
        router.setEmail("learner@example.com")
        router.startSubscribe()
        XCTAssertTrue(router.pro)
        XCTAssertEqual(router.screen, AppRouter.Screen.home)
    }
}
