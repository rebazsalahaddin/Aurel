import SwiftData
import SwiftUI

/// Root switch over the router's screen state machine — the port of the
/// prototype's `sc-if` screen blocks. Features land here as they are built.
struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var env: AppEnvironment?

    var body: some View {
        ZStack {
            if let env {
                ScreenHost()
                    .environment(env)
            } else {
                Color.auBackground.ignoresSafeArea()
            }
        }
        .tint(.auAccent)
        .preferredColorScheme(colorScheme)
        .task {
            if env == nil {
                env = AppEnvironment(modelContext: modelContext)
            }
        }
    }

    private var colorScheme: ColorScheme? {
        guard let env else { return nil }
        switch env.router.themeMode {
        case 1: return .light
        case 2: return .dark
        default: return nil
        }
    }
}

private struct ScreenHost: View {
    @Environment(AppEnvironment.self) private var env

    @ViewBuilder
    var body: some View {
        screenBody
            .accessibilityIdentifier("au.screen.\(env.router.screen.rawName)")
    }

    @ViewBuilder
    private var screenBody: some View {
        switch env.router.screen {
        case .welcome: WelcomeView()
        case .goal: GoalView()
        case .placement: PlacementView()
        case .commit: CommitView()
        case .plan: PlanView()
        case .assess: AssessStubView()
        case .login: LoginView()
        case .home: HomeView()
        case .course: CoursePlayerView(startPos: env.router.coursePos, bound: true)
        case .lesson: LessonRunnerView()
        case .result: ResultView()
        case .streak: StreakView()
        case .leaderboard: LeaderboardView()
        case .stories: StoriesView()
        case .reader: ReaderStubView()
        case .hunt: HuntStubView()
        case .scene: SceneView()
        case .speak: SpeakView()
        case .review: ReviewView()
        case .progress: ProgressView()
        case .profile: ProfileView()
        case .settings: SettingsView()
        case .paywall: PaywallView()
        case .assessReview: UnbuiltScreen()
        }
    }
}

/// Honest placeholder for screens whose features land in later tasks.
struct UnbuiltScreen: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        VStack(spacing: AUSpace.s3) {
            Text(String(describing: env.router.screen).capitalized)
                .font(.caprasimo(size: 27))
                .foregroundStyle(Color.auText)
            Text("This screen is being ported next.")
                .font(.figtree(.regular, size: 13))
                .foregroundStyle(Color.auText.opacity(0.5))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.auBackground.ignoresSafeArea())
    }
}

#Preview {
    RootView()
        .modelContainer(try! AppSchema.makeContainer(inMemory: true))
}
