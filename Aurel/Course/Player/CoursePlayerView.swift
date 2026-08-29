import SwiftUI

// MARK: - Course player (CourseScreen.dc.html)
//
// The chapter player chrome (lines 83–92) plus the screen-type dispatch
// (isXxx routing, lines 1339–1346). Bound mode = driven from the shell.

struct CoursePlayerView: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.scenePhase) private var scenePhase
    @State private var model: PlayerModel?

    let startPos: Int
    var bound = true

    var body: some View {
        Group {
            if let model {
                PlayerChrome(model: model, bound: bound)
            } else {
                AUElegantBackground(subdued: true).ignoresSafeArea()
            }
        }
        .background(AUElegantBackground(subdued: true).ignoresSafeArea())
        .task(id: startPos) {
            guard model == nil || model?.p != startPos else { return }
            let m = PlayerModel(
                course: env.course,
                start: startPos,
                bound: bound,
                onScreen: { n in env.router.trackCourse(n) },
                onExit: { env.router.leaveCourse() },
                onFinish: { env.router.finishCourse() }
            )
            #if AUREL_VERIFICATION
                // Production-art QA can open one authored practice/quiz item
                // without answering every preceding item. This is routing
                // only: it never writes progress or changes learner behavior.
                let args = ProcessInfo.processInfo.arguments
                if let argument = args.firstIndex(of: "-AUREL_COURSE_ITEM"),
                    argument + 1 < args.count,
                    let item = m.items.firstIndex(where: { $0.id == args[argument + 1] })
                {
                    m.i = item
                }
            #endif
            m.speaker = env.speaker
            env.router.trackCourse(m.p)
            model = m
        }
        .onChange(of: scenePhase) { _, phase in
            guard phase != .active else { return }
            env.speaker.stop()
            model?.say.reset()
        }
    }
}

/// The close/back + crumb + lesson progress + sid chip header.
private struct PlayerChrome: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let model: PlayerModel
    let bound: Bool

    var body: some View {
        VStack(spacing: 0) {
            if let cur = model.cur {
                HStack(spacing: 10) {
                    Button {
                        if bound {
                            model.onExit()
                        } else {
                            model.goto(model.p - 1)
                        }
                    } label: {
                        AUIcon(kind: bound ? .close : .back, size: 15)
                            .frame(width: 34, height: 34)
                            .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
                    }
                    .buttonStyle(.auTap)
                    // Craft overhaul L1: 34pt visual, 44pt hit area.
                    .auMinHitTarget()
                    .accessibilityLabel(bound ? "Close the lesson" : "Previous screen")
                    .accessibilityIdentifier(bound ? "au.player.close" : "au.player.back")

                    VStack(alignment: .leading, spacing: 5) {
                        Text(
                            "Chapter \(cur.chapter.n) · Lesson \(cur.lesson.n) · \(cur.lesson.learnerTitle)"
                        )
                        // Craft overhaul L2: was 9pt fixed + truncated to
                        // one line — now a legible 11pt label, 2 lines.
                        .font(.figtree(.semibold, size: 11))
                        .tracking(0.6)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.auAccentText)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                // Craft overhaul L4: track visible on cream
                                // (was auText @ 0.10 — near-invisible).
                                Capsule().fill(Color.auText.opacity(0.22))
                                Capsule()
                                    .fill(Color.auAccent)
                                    .frame(width: geo.size.width * lessonPct)
                                    .animation(
                                        AUMotion.animation(
                                            AUMotion.flow, reduceMotion: reduceMotion),
                                        value: model.p)
                            }
                        }
                        .frame(height: 3)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Lesson progress")
                        .accessibilityValue(lessonProgressValue)
                    }

                    #if AUREL_VERIFICATION
                        if !bound {
                            Text(cur.screen.id)
                                .font(.figtree(.bold, size: 9.5))
                                .tracking(1)
                                .padding(.horizontal, 9)
                                .padding(.vertical, 5)
                                .background(Capsule().fill(Color.auFlatBg))
                                .foregroundStyle(Color.auFlatText)
                        }
                    #endif
                }
                // The course route now respects the device safe area, so this
                // is spacing below the status region rather than a hardcoded
                // physical-screen offset.
                .padding(.top, 12)
                .padding(.horizontal, 20)
            }

            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    screenBody
                        .environment(\.auLessonGlassEnabled, model.cur?.chapter.n == 1)
                        .frame(minHeight: geo.size.height)
                        .id(model.p)
                        .accessibilityIdentifier("au.player.kind.\(curKind)")
                        .transition(
                            // Craft overhaul L7: slide with the actual travel
                            // direction (was hardcoded forward: true).
                            AUMotion.screenSwap(
                                reduceMotion: reduceMotion, forward: model.lastDelta >= 0)
                        )
                }
            }

            // The practice family's docked verdict + CTA (§3.9): the answer
            // lands at the bottom edge and the CTA lives with it — the thumb
            // never travels. Other screen families keep their inline CTAs.
            if model.hasVerdictDock {
                PlayerVerdictDock(model: model)
                    .transition(
                        reduceMotion
                            ? .opacity
                            : .move(edge: .bottom).combined(with: .opacity)
                    )
            }
        }
        .animation(
            AUMotion.animation(AUMotion.scene, reduceMotion: reduceMotion),
            value: model.p
        )
        .animation(
            AUMotion.animation(AUMotion.flow, reduceMotion: reduceMotion),
            value: model.hasVerdictDock
        )
    }

    private var lessonPct: CGFloat {
        guard let cur = model.cur else { return 0 }
        let screens = cur.lesson.screens.filter { $0.kind.participatesInLessonFlow }
        let pos = screens.firstIndex(where: { $0.id == cur.screen.id }) ?? 0
        return CGFloat(pos + 1) / CGFloat(max(1, screens.count))
    }

    private var lessonProgressValue: String {
        guard let cur = model.cur else { return "" }
        let screens = cur.lesson.screens.filter { $0.kind.participatesInLessonFlow }
        let position = screens.firstIndex(where: { $0.id == cur.screen.id }) ?? 0
        return "\(position + 1) of \(max(1, screens.count))"
    }

    private var curKind: String { model.cur?.screen.kind.rawValue ?? "unknown" }

    @ViewBuilder
    private var screenBody: some View {
        if let cur = model.cur {
            switch cur.screen.kind {
            case .promise: PromiseScreenView(m: model)
            case .hook: HookScreenView(m: model)
            case .orientation: OrientationScreenView(m: model)
            case .pause: PauseScreenView(m: model)
            case .cards, .letterCards, .numbers: CardsScreenView(m: model)
            case .alphabet: AlphabetScreenView(m: model)
            case .practice, .quiz, .testlet, .warmup, .reading: PracticeScreenView(m: model)
            case .pending: PendingScreenView(m: model)
            case .review: ReviewScreenView(m: model)
            case .grammarModel: GrammarScreenView(m: model)
            case .pronPerceive: PronPerceiveScreenView(m: model)
            case .pronProduce: PronProduceScreenView(m: model)
            case .conversation: ConversationScreenView(m: model)
            case .order: OrderScreenView(m: model)
            case .tiles, .emailAssembly: TilesScreenView(m: model)
            case .substitution: SubstitutionScreenView(m: model)
            case .missionBrief: MissionScreenView(m: model)
            case .roleplay: RoleplayScreenView(m: model)
            case .quizIntro: QuizIntroScreenView(m: model)
            case .results: ResultsScreenView(m: model)
            case .remediation: RemediationScreenView(m: model)
            case .reviewPlan: ReviewPlanScreenView(m: model)
            case .chapterMap: ChapterMapScreenView(m: model)
            case .unknown: PlayerLoadingView()
            }
        } else {
            PlayerLoadingView()
        }
    }
}

// MARK: - Branded loading state (§2.7 / §3.7b)

struct PlayerLoadingView: View {
    @State private var pulse = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 16) {
            AULogoMark(size: 40)
            Text("Loading lesson…")
                .font(.figtree(.medium, size: 14))
                .foregroundStyle(Color.auText.opacity(0.70))
        }
        .frame(maxWidth: .infinity, minHeight: 320)
        .opacity(pulse ? 1.0 : 0.55)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}

// MARK: - Screen scaffold (the au-screen column)

struct ScreenColumn<Content: View>: View {
    var topPad: CGFloat = 24
    var bottomPad: CGFloat = 28
    var hPad: CGFloat = 22
    /// The authored `align-items` — a flex column stretches (and so reads as
    /// left-aligned) unless the screen sets `align-items:center`.
    var alignment: HorizontalAlignment = .leading
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: alignment, spacing: 0) {
            content
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: alignment == .center ? .top : .topLeading
        )
        .padding(.horizontal, hPad)
        .padding(.top, topPad)
        .padding(.bottom, bottomPad)
        .accessibilityElement(children: .contain)
    }
}

/// "Go on" primary with the arrow, the standard screen CTA. The player has
/// its own `.au-btn` (CourseScreen.dc.html): 16/20 padding, 20 pt radius,
/// Figtree 600 16, and a flat accent-600 fill rather than the shell gradient.
struct GoOnButton: View {
    let label: String
    var aid: String = "au.player.go-on"
    var disabled = false
    let action: () -> Void

    var body: some View {
        APillButton(
            title: label, icon: .arrow, player: true, disabled: disabled,
            aid: aid, action: action)
    }
}
