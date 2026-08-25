import SwiftData
import XCTest

@testable import Aurel

@MainActor
final class PH02JourneyTests: XCTestCase {
    private let store = CourseDecodingTests.store

    private func makePersistentRouter() throws -> (AppRouter, ModelContext) {
        let container = try AppSchema.makeContainer(inMemory: true)
        let context = ModelContext(container)
        return (AppRouter(course: store, modelContext: context), context)
    }

    func testFreshLearnerLaunchesOnWelcomeEntryScreen() throws {
        let (router, context) = try makePersistentRouter()

        XCTAssertEqual(router.screen, .welcome)
        let profile = try XCTUnwrap(
            context.fetch(FetchDescriptor<LearnerProfile>()).first)
        XCTAssertNil(profile.onboardedAt)
    }

    func testAuthenticatedReturningLearnerLaunchesDirectlyOnHome() throws {
        let container = try AppSchema.makeContainer(inMemory: true)
        let context = ModelContext(container)
        let profile = LearnerProfile()
        profile.email = "learner@example.com"
        profile.onboardedAt = Date()
        context.insert(profile)
        try context.save()

        let router = AppRouter(
            course: store,
            modelContext: context,
            capabilities: AppCapabilities(
                accounts: true,
                commerce: false,
                notifications: false,
                weeklyEmail: false,
                widget: false,
                support: false
            )
        )

        XCTAssertEqual(router.screen, .home)
        XCTAssertTrue(router.hasAccount)
    }

    func testValueSamplePersistsWithoutCreatingLearningProgress() throws {
        let (router, context) = try makePersistentRouter()
        router.nav(.onboardingSample)
        router.chooseOnboardingSample(0)

        XCTAssertEqual(router.onboardingSampleOutcome, .recognized)
        XCTAssertEqual(router.lessonsDone, 0)
        XCTAssertFalse(router.dayLesson)
        XCTAssertFalse(router.dayRecall)
        XCTAssertTrue(router.lessonRecords().isEmpty)

        router.continueOnboardingSample()
        let relaunched = AppRouter(course: store, modelContext: context)
        XCTAssertEqual(relaunched.screen, .onboardingValue)
        XCTAssertEqual(relaunched.onboardingSampleOutcome, .recognized)
        XCTAssertEqual(relaunched.onboardingSampleSelection, 0)
        XCTAssertEqual(relaunched.lessonsDone, 0)
    }

    func testSkippedSampleAndBackRouteRestoreDeterministically() throws {
        let (router, context) = try makePersistentRouter()
        router.nav(.onboardingSample)
        router.skipOnboardingSample()

        var relaunched = AppRouter(course: store, modelContext: context)
        XCTAssertEqual(relaunched.screen, .onboardingValue)
        XCTAssertEqual(relaunched.onboardingSampleOutcome, .skipped)

        relaunched.nav(.onboardingSample)
        relaunched = AppRouter(course: store, modelContext: context)
        XCTAssertEqual(relaunched.screen, .onboardingSample)
        XCTAssertNil(relaunched.onboardingSampleSelection)
    }

    func testStartingFirstLessonIsTheOnboardingCompletionBoundary() throws {
        let (router, context) = try makePersistentRouter()
        router.nav(.onboardingSample)
        router.skipOnboardingSample()
        router.nav(.goal)
        router.toggleGoal("work")
        router.nav(.commit)
        router.setCommitMinutes(20)
        router.finishOnboarding()

        let profileBefore = try XCTUnwrap(
            context.fetch(FetchDescriptor<LearnerProfile>()).first)
        XCTAssertNil(profileBefore.onboardedAt)
        XCTAssertEqual(profileBefore.onboardingCheckpoint, "plan")

        router.startFirstLesson()
        XCTAssertEqual(router.screen, .course)
        XCTAssertNotNil(profileBefore.onboardedAt)

        let relaunched = AppRouter(course: store, modelContext: context)
        XCTAssertEqual(relaunched.screen, .home)
        XCTAssertEqual(relaunched.goals, ["work"])
        XCTAssertEqual(relaunched.commit, 20)
    }

    func testEveryGoalChangesTheVisibleRecommendationReason() {
        let router = AppRouter(course: store)
        let ids = ["work", "travel", "exam", "self"]
        let reasons = ids.map { id -> String in
            router.goals = [id]
            return router.learnNextAction.reason
        }

        XCTAssertEqual(Set(reasons).count, ids.count)
        XCTAssertTrue(reasons.allSatisfy { !$0.isEmpty })
    }

    func testPaceChangesRecommendationDuration() {
        let router = AppRouter(course: store)
        router.commit = 10
        XCTAssertEqual(router.learnNextAction.duration, "About 10 minutes to the natural pause")
        router.commit = 20
        XCTAssertEqual(router.learnNextAction.duration, "About 20 minutes for the full lesson")
    }

    func testLearnRecommendationCoversResumeReviewCompleteAndLockedStates() {
        let router = AppRouter(course: store)

        router.pending = .init(pos: 2, title: "A first greeting", at: 3, of: 8)
        XCTAssertEqual(router.learnNextAction.destination, .resumeCourse)

        router.pending = nil
        router.dayLesson = true
        router.dayRecall = false
        router.mistakes = [0, 2]
        XCTAssertEqual(router.learnNextAction.destination, .review)
        XCTAssertFalse(router.learnNextAction.reason.isEmpty)
        XCTAssertFalse(router.learnNextAction.outcome.isEmpty)

        router.dayRecall = true
        XCTAssertEqual(router.learnNextAction.destination, .practice)

        router.dayLesson = false
        router.dayRecall = false
        router.mistakes = []
        router.lessonsDone = router.chapterHeader.count
        XCTAssertEqual(router.learnNextAction.destination, .practice)
        XCTAssertEqual(router.learnNextAction.buttonTitle, "Choose practice")
    }

    func testPracticeEvidenceLevelsHaveStableDerivationsAndExplanation() {
        let counts = [0, 1, 2, 3, 4, 7, 8]
        let levels = counts.map(AppRouter.practiceEvidenceLevel(for:))
        XCTAssertEqual(
            levels,
            [.notStarted, .introduced, .practised, .building, .repeated, .repeated, .wellRehearsed])
        XCTAssertTrue(AppRouter.PracticeEvidenceLevel.explanation.contains("not a test score"))
        XCTAssertTrue(AppRouter.PracticeEvidenceLevel.allCases.allSatisfy { !$0.label.isEmpty })
    }

    func testProgressRecommendationAlwaysExplainsReasonDurationOutcomeAndRoute() {
        let router = AppRouter(course: store)
        for skill in ["Vocabulary", "Grammar", "Listening", "Conversation", "Speaking"] {
            let action = router.progressNextAction(skill: skill, evidenceCount: 0)
            XCTAssertFalse(action.reason.isEmpty, skill)
            XCTAssertFalse(action.duration.isEmpty, skill)
            XCTAssertFalse(action.outcome.isEmpty, skill)
            XCTAssertFalse(action.buttonTitle.isEmpty, skill)
        }
        XCTAssertEqual(
            router.progressNextAction(skill: "Speaking", evidenceCount: 0).destination,
            .speak)
        XCTAssertEqual(
            router.progressNextAction(skill: "Listening", evidenceCount: 0).destination,
            .scene)
    }

    func testFourTopLevelSectionsHaveDistinctJobsAndYouOwnsLeaderboard() {
        let purposes = AppRouter.TopLevelSection.allCases.map(\.purpose)
        XCTAssertEqual(Set(purposes).count, 4)
        XCTAssertEqual(AppRouter.topLevelSection(for: .home), .learn)
        XCTAssertEqual(AppRouter.topLevelSection(for: .stories), .practice)
        XCTAssertEqual(AppRouter.topLevelSection(for: .progress), .progress)
        XCTAssertEqual(AppRouter.topLevelSection(for: .profile), .you)
        XCTAssertEqual(AppRouter.topLevelSection(for: .leaderboard), .you)
    }

    func testTabSwitchesPreserveRouterOwnedPracticeState() {
        let router = AppRouter(course: store)
        router.screen = .stories
        router.sceneTurn = 2
        router.scenePicks = [1, 0]
        router.nav(.progress)
        router.nav(.stories)

        XCTAssertEqual(router.sceneTurn, 2)
        XCTAssertEqual(router.scenePicks, [1, 0])
    }
}
