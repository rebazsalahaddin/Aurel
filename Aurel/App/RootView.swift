import SwiftData
import SwiftUI

/// Root switch over the router's screen state machine — the port of the
/// prototype's `sc-if` screen blocks. Features land here as they are built.
struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var env: AppEnvironment?
    /// S1-003: shown once when the on-disk store was corrupt and got moved
    /// aside (local progress reset) — never blocks the flow.
    private let storeRecovered: Bool

    init(storeRecovered: Bool = false) {
        self.storeRecovered = storeRecovered
    }

    private var typeStep: Int { env?.router.typeStep ?? 2 }

    var body: some View {
        ZStack {
            if let env {
                if env.courseLoadFailed {
                    CourseRecoveryView(retry: retryEnvironment)
                } else {
                    // Course and account controls respect the real device safe
                    // area so navigation and bottom actions stay clear of system
                    // chrome. Other full-bleed learning surfaces keep their
                    // authored physical-stage geometry.
                    if env.router.screen == .course
                        || env.router.screen == .paywall
                        || env.router.screen == .subscribeAccount
                    {
                        ScreenHost()
                            .environment(env)
                    } else {
                        ScreenHost()
                            .environment(env)
                            .ignoresSafeArea()
                    }
                }
            } else {
                Color.auBackground.ignoresSafeArea()
            }
        }
        .tint(.auAccent)
        .preferredColorScheme(colorScheme)
        .animation(
            AUMotion.animation(.easeInOut(duration: 0.38), reduceMotion: reduceMotion),
            value: colorScheme
        )
        .task {
            if env == nil {
                env = AppEnvironment(modelContext: modelContext)
            }
            AUTypeScale.step = typeStep  // S1-001: the persisted text-size step
            // AUSound needs no activation: it plays through data-based
            // AVAudioPlayer, built lazily on first play (an engine graph
            // RPC-aborted here when the audio server was wedged — see
            // AUSound.swift).
        }
        // S1-001: the Settings text-size control drives the type scale live.
        .onChange(of: typeStep) { _, step in AUTypeScale.step = step }
        .onChange(of: dynamicTypeSize) { _, size in
            AUTypeScale.systemCategory = UIContentSizeCategory(size)
        }
        // S1-009: crossing midnight in the background must still roll the day
        // over when the app comes back — durable day flags never outlive
        // their day.
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                env?.router.rolloverDayIfNeeded()
            } else {
                // Phone calls, Siri, Control Centre, and backgrounding must
                // leave no model line or temporary learner take running.
                env?.speaker.stop()
                env?.router.say.reset()
            }
        }
        .overlay(alignment: .top) {
            if storeRecovered {
                StoreRecoveredBanner()
            }
        }
    }

    /// S1-004: retry loading the course (rebuild the environment).
    private func retryEnvironment() {
        env = AppEnvironment(modelContext: modelContext)
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

/// S1-004: the course bundle could not be decoded — an honest recovery
/// surface instead of a launch crash.
private struct CourseRecoveryView: View {
    let retry: () -> Void

    var body: some View {
        ZStack {
            Color.auBackground.ignoresSafeArea()
            VStack(spacing: 0) {
                AUIcon(kind: .loop, size: 44, color: .auAccentText)
                    .padding(.bottom, 18)
                Text("Aurel can't open its lessons right now.")
                    .font(.caprasimo(size: 25))
                    .tracking(-0.45)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                Text("Your saved progress is safe. Try again in a moment.")
                    .font(.figtree(.regular, size: 14.5))
                    .auLine(14.5, 1.45)
                    .foregroundStyle(Color.auText.opacity(0.62))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 26)
                APillButton(title: "Try again", icon: .arrow, aid: "au.btn.try-again") {
                    retry()
                }
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: 342)
        }
    }
}

/// S1-003: the store was moved aside and a fresh one created.
private struct StoreRecoveredBanner: View {
    @State private var visible = true

    var body: some View {
        if visible {
            HStack(spacing: 10) {
                AUIcon(kind: .sparkle, size: 16, color: .auTintText)
                Text("Your saved progress could not be read and was reset.")
                    .font(.figtree(.semibold, size: 13))
                    .auLine(13, 1.45)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    visible = false
                } label: {
                    AUIcon(kind: .close, size: 14, color: .auTintText)
                }
                .buttonStyle(.auTap)
                .accessibilityLabel("Dismiss")
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.auTintBg)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Color.auEdge, lineWidth: 1)
            )
            .padding(.horizontal, 16)
            .transition(
                .move(edge: .top).combined(with: .opacity)
            )
            .accessibilityIdentifier("au.banner.store-recovered")
        }
    }
}

private struct ScreenHost: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var isTabScreen: Bool {
        switch env.router.screen {
        case .home, .stories, .progress, .profile, .leaderboard:
            return true
        default:
            return false
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            screenBody
                .transition(transition(for: env.router.screen))

            if isTabScreen {
                AUTabBar(current: env.router.screen)
                    .padding(.horizontal, 14)
                    .padding(.bottom, 26)
                    .transition(
                        reduceMotion ? .opacity : .move(edge: .bottom).combined(with: .opacity)
                    )
                    .zIndex(10)
            }
        }
        .animation(
            AUMotion.animation(AUMotion.flow, reduceMotion: reduceMotion),
            value: env.router.screen
        )
    }

    private func transition(for screen: AppRouter.Screen) -> AnyTransition {
        guard !reduceMotion else { return .opacity }
        switch screen {
        case .course, .paywall, .subscribeAccount:
            return .asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity)
            )
        case .onboardingSample, .onboardingValue, .goal, .commit, .plan, .login:
            return .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            )
        case .result, .streak:
            return .asymmetric(
                insertion: .scale(scale: 0.94).combined(with: .opacity),
                removal: .opacity
            )
        case .scene, .speak, .review, .settings:
            return .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .trailing).combined(with: .opacity)
            )
        case .home, .stories, .progress, .profile, .leaderboard:
            return .asymmetric(
                insertion: .opacity.combined(with: .scale(scale: 0.98)),
                removal: .opacity
            )
        default:
            return .opacity
        }
    }

    @ViewBuilder
    private var screenBody: some View {
        switch env.router.screen {
        case .welcome: WelcomeView()
        case .onboardingSample: OnboardingSampleView()
        case .onboardingValue: OnboardingValueView()
        case .goal: GoalView()
        case .commit: CommitView()
        case .plan: PlanView()
        case .login: LoginView()
        case .home: HomeView()
        case .course: CoursePlayerView(startPos: env.router.coursePos, bound: true)
        case .lesson: LessonRunnerView()
        case .result: ResultView()
        case .streak: StreakView()
        case .leaderboard: LeaderboardView()
        case .stories: StoriesView()
        case .scene: SceneView()
        case .speak: SpeakView()
        case .review: ReviewView()
        case .progress: ProgressView()
        case .profile: ProfileView()
        case .settings: SettingsView()
        case .paywall: PaywallView()
        case .subscribeAccount: SubscribeAccountView()
        }
    }
}

#Preview {
    RootView()
        .modelContainer(try! AppSchema.makeContainer(inMemory: true))
}
