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
                Color.auBackground.ignoresSafeArea()
            }
        }
        .background(Color.auBackground.ignoresSafeArea())
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
                        if bound { model.onExit() } else { model.goto(model.p - 1) }
                    } label: {
                        AUIcon(kind: bound ? .close : .back, size: 15)
                            .frame(width: 34, height: 34)
                            .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
                    }
                    .buttonStyle(.auTap)
                    .accessibilityLabel(bound ? "Close the lesson" : "Previous screen")
                    .accessibilityIdentifier(bound ? "au.player.close" : "au.player.back")

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Ch \(cur.chapter.n) · L\(cur.lesson.n) \(cur.lesson.title)")
                            .font(.figtree(.bold, size: 9))
                            .tracking(1.5)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auAccentText)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.auText.opacity(0.10))
                                Capsule()
                                    .fill(Color.auAccent)
                                    .frame(width: geo.size.width * lessonPct)
                                    .animation(.easeInOut(duration: 0.5), value: model.p)
                            }
                        }
                        .frame(height: 3)
                    }

                    if !bound {
                        Text(cur.screen.id)
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(1)
                            .padding(.horizontal, 9)
                            .padding(.vertical, 5)
                            .background(Capsule().fill(Color.auFlatBg))
                            .foregroundStyle(Color.auFlatText)
                    }
                }
                // padding: 60px 20px 0
                .padding(.top, 60)
                .padding(.horizontal, 20)
            }

            ScrollView(showsIndicators: false) {
                screenBody
                    .id(model.p)
                    .transition(.opacity.combined(with: .offset(y: 11)))
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
        .animation(.easeInOut(duration: 0.3), value: model.p)
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
            case .unknown: Text("Loading course…").foregroundStyle(Color.auText)
            }
        } else {
            Text("Loading course…").foregroundStyle(Color.auText)
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
        // The authored player body is 790 points including its insets. Put the
        // flexible height inside the padding so nested Spacers receive it.
        .frame(
            maxWidth: .infinity,
            minHeight: max(0, 790 - topPad - bottomPad),
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
