import SwiftData
import XCTest

@testable import Aurel

@MainActor
final class Stage7AccountTests: XCTestCase {

    func testReleaseCapabilitiesAreConservative() {
        let capabilities = AppCapabilities.release
        XCTAssertFalse(capabilities.accounts)
        XCTAssertFalse(capabilities.commerce)
        XCTAssertFalse(capabilities.notifications)
        XCTAssertFalse(capabilities.weeklyEmail)
        XCTAssertFalse(capabilities.widget)
        XCTAssertFalse(capabilities.support)
    }

    func testReleaseLoginNeverSimulatesSuccess() {
        let router = AppRouter(course: CourseDecodingTests.store)
        router.setEmail("user@example.com")
        router.setPass("validpassword")
        router.signIn()
        XCTAssertEqual(router.loginErr, "Account sign-in isn't available in this build.")
        XCTAssertEqual(router.screen, AppRouter.Screen.welcome)
    }

    func testReleaseSanitizesLegacyPrototypeServiceStateWithoutErasingLearning() throws {
        let container = try AppSchema.makeContainer(inMemory: true)
        let context = ModelContext(container)
        let profile = LearnerProfile()
        profile.email = "legacy@example.com"
        profile.isPro = true
        profile.remindAt = "07:30"
        profile.swReminder = true
        profile.notifDawn = true
        profile.swWeekly = true
        profile.onboardedAt = Date()
        profile.streakDays = 9
        context.insert(profile)
        try context.save()

        let router = AppRouter(course: CourseDecodingTests.store, modelContext: context)
        XCTAssertEqual(router.email, "")
        XCTAssertFalse(router.pro)
        XCTAssertEqual(router.remindAt, "")
        XCTAssertFalse(router.sw.reminder)
        XCTAssertFalse(router.notif.dawn)
        XCTAssertFalse(router.sw.weekly)
        XCTAssertEqual(router.streak, 9)

        let stored = try XCTUnwrap(context.fetch(FetchDescriptor<LearnerProfile>()).first)
        XCTAssertEqual(stored.email, "")
        XCTAssertFalse(stored.isPro)
        XCTAssertEqual(stored.remindAt, "")
        XCTAssertFalse(stored.swReminder)
        XCTAssertFalse(stored.notifDawn)
        XCTAssertFalse(stored.swWeekly)
        XCTAssertEqual(stored.streakDays, 9)
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
        router.screen = .home
        router.startSubscribe()
        XCTAssertFalse(router.pro)
        XCTAssertEqual(router.screen, AppRouter.Screen.home)
        XCTAssertEqual(router.loginErr, "Subscriptions aren't available in this build.")
    }

    func testConfirmedLocalDeletionErasesSeededModelsAndRelaunchesAsGuest() throws {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent("aurel-delete-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        addTeardownBlock { try? FileManager.default.removeItem(at: directory) }
        let storeURL = directory.appendingPathComponent("aurel.store")

        do {
            let container = try AppSchema.makeContainer(at: storeURL)
            let context = ModelContext(container)
            let profile = LearnerProfile()
            profile.email = "legacy@example.com"
            profile.isPro = true
            profile.onboardedAt = Date()
            profile.streakDays = 19
            context.insert(profile)
            context.insert(DayLog(day: Date(), learner: profile))
            context.insert(LessonRecord(chapterIdx: 0, lessonIdx: 0, endPos: 4, learner: profile))
            context.insert(MistakeItem(bankIndex: 2, word: "hello", learner: profile))
            try context.save()

            let router = AppRouter(course: CourseDecodingTests.store, modelContext: context)
            XCTAssertTrue(router.deleteLocalData())
            XCTAssertEqual(router.screen, .welcome)
            XCTAssertEqual(router.streak, 0)
            XCTAssertTrue(try context.fetch(FetchDescriptor<LearnerProfile>()).isEmpty)
            XCTAssertTrue(try context.fetch(FetchDescriptor<DayLog>()).isEmpty)
            XCTAssertTrue(try context.fetch(FetchDescriptor<LessonRecord>()).isEmpty)
            XCTAssertTrue(try context.fetch(FetchDescriptor<MistakeItem>()).isEmpty)
        }

        let relaunchedContainer = try AppSchema.makeContainer(at: storeURL)
        let relaunchedContext = ModelContext(relaunchedContainer)
        let relaunched = AppRouter(
            course: CourseDecodingTests.store,
            modelContext: relaunchedContext
        )
        XCTAssertEqual(relaunched.screen, .welcome)
        XCTAssertEqual(relaunched.email, "")
        XCTAssertFalse(relaunched.pro)
        XCTAssertEqual(relaunched.streak, 0)
        let guest = try XCTUnwrap(
            relaunchedContext.fetch(FetchDescriptor<LearnerProfile>()).first)
        XCTAssertNil(guest.onboardedAt)
        XCTAssertEqual(guest.email, "")
        XCTAssertEqual(guest.streakDays, 0)
        XCTAssertTrue(try relaunchedContext.fetch(FetchDescriptor<DayLog>()).isEmpty)
        XCTAssertTrue(try relaunchedContext.fetch(FetchDescriptor<LessonRecord>()).isEmpty)
        XCTAssertTrue(try relaunchedContext.fetch(FetchDescriptor<MistakeItem>()).isEmpty)
    }

    func testCancelledLocalDeletionChangesNothing() throws {
        let container = try AppSchema.makeContainer(inMemory: true)
        let context = ModelContext(container)
        let profile = LearnerProfile()
        profile.onboardedAt = Date()
        profile.streakDays = 12
        context.insert(profile)
        context.insert(DayLog(day: Date(), learner: profile))
        try context.save()

        let router = AppRouter(course: CourseDecodingTests.store, modelContext: context)
        router.cancelLocalDataDeletion()

        XCTAssertEqual(router.streak, 12)
        XCTAssertEqual(try context.fetch(FetchDescriptor<LearnerProfile>()).count, 1)
        XCTAssertEqual(try context.fetch(FetchDescriptor<DayLog>()).count, 1)
    }

    func testSignOutClearsOnlyAccountFields() throws {
        let container = try AppSchema.makeContainer(inMemory: true)
        let context = ModelContext(container)
        let profile = LearnerProfile()
        profile.email = "learner@example.com"
        profile.isPro = true
        profile.onboardedAt = Date()
        profile.streakDays = 8
        context.insert(profile)
        context.insert(DayLog(day: Date(), learner: profile))
        try context.save()

        let router = AppRouter(
            course: CourseDecodingTests.store,
            modelContext: context,
            capabilities: AppCapabilities(
                accounts: true,
                commerce: true,
                notifications: true,
                weeklyEmail: true,
                widget: true,
                support: true
            )
        )
        router.pass = "session-only"
        router.signOut()

        XCTAssertEqual(router.email, "")
        XCTAssertEqual(router.pass, "")
        XCTAssertFalse(router.pro)
        XCTAssertEqual(router.streak, 8)
        XCTAssertEqual(try context.fetch(FetchDescriptor<DayLog>()).count, 1)
        XCTAssertEqual(try context.fetch(FetchDescriptor<LearnerProfile>()).first?.streakDays, 8)
    }
}
