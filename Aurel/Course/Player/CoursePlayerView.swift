import SwiftUI

// MARK: - Course player (CourseScreen.dc.html)
//
// The chapter player chrome (lines 83–92) plus the screen-type dispatch
// (isXxx routing, lines 1339–1346). Bound mode = driven from the shell.

struct CoursePlayerView: View {
    @Environment(AppEnvironment.self) private var env
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
            m.speaker = env.speaker
            model = m
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
                        Text("Ch \(cur.chapter.n) · L\(cur.lesson.n) \(cur.lesson.title)")
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
                                    .animation(AUMotion.animation(AUMotion.flow, reduceMotion: reduceMotion), value: model.p)
                            }
                        }
                        .frame(height: 3)
                    }

                    #if DEBUG
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
                // padding: 60px 20px 0
                .padding(.top, 60)
                .padding(.horizontal, 20)
            }

            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    screenBody
                        .frame(minHeight: geo.size.height)
                        .id(model.p)
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
        let screens = cur.lesson.screens
        let pos = screens.firstIndex(where: { $0.id == cur.screen.id }) ?? 0
        return CGFloat(pos + 1) / CGFloat(max(1, screens.count))
    }

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
    }
}

/// "Go on" primary with the arrow, the standard screen CTA. The player has
/// its own `.au-btn` (CourseScreen.dc.html): 16/20 padding, 20 pt radius,
/// Figtree 600 16, and a flat accent-600 fill rather than the shell gradient.
struct GoOnButton: View {
    let label: String
    var aid: String = "au.player.go-on"
    let action: () -> Void

    var body: some View {
        APillButton(title: label, icon: .arrow, player: true, aid: aid, action: action)
    }
}
