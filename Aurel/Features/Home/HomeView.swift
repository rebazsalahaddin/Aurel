import SwiftUI

// MARK: - Home (Aurel.dc.html lines 451–634)
//
// Header block with the warm wash, the pending-resume card, the day-arc card,
// the winding lesson path, and the next-chapter paywall card.

struct HomeView: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// §3.6(a): the path draw-in plays on the first reveal only.
    @State private var pathDrawn = false
    /// §3.6(c): home scroll offset, driving the day-arc sun's travel.
    @State private var scrollY: CGFloat = 0
    /// §3.6(d): the locked stop whose explainer is showing (first tap
    /// explains, second tap opens the paywall).
    @State private var lockedExplainer: Int? = nil

    /// Scroll-offset preference (§3.6(c)) — measured at the scroll content's
    /// top edge, reported as positive points scrolled.
    private struct HomeScrollKey: PreferenceKey {
        static let defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.auBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    header
                    pendingCard
                    dayArcCard
                    lessonPath
                }
                .padding(.bottom, 160)
                // Clearance for the floating glass tab (design bottom:26 + bar ~72)
                // plus enough room that the first locked stop is not buried.
                .background(
                    // §3.6(c): measure the content offset inside the scroll
                    // space so the sun can travel with the finger.
                    GeometryReader { geo in
                        Color.clear.preference(
                            key: HomeScrollKey.self,
                            value: -geo.frame(in: .named("home.scroll")).minY
                        )
                    }
                )
            }
            .coordinateSpace(name: "home.scroll")
            .onPreferenceChange(HomeScrollKey.self) { scrollY = max(0, $0) }
            .ignoresSafeArea(edges: .top)

            if !env.connectivity.isOnline {
                VStack(spacing: 0) {
                    OfflineBanner()
                        .padding(.horizontal, 14)
                    Spacer(minLength: 0)
                }
                .padding(.top, 104)
                .zIndex(5)
            }
        }
        .auScreenEntrance()
    }

    // MARK: Header (lines 459–480)

    private var header: some View {
        VStack(spacing: 0) {
            HStack {
                AULogoMark(size: 27, mono: true)
                Text("Aurel")
                    .font(.caprasimo(size: 18))
                    .tracking(0.27)
                Spacer()
                Button {
                    env.router.nav(.settings)
                } label: {
                    AUIcon(kind: .gear, size: 17)
                        .frame(width: 44, height: 44)
                        .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
                }
                .buttonStyle(.auTap)
                .accessibilityLabel("Settings")
                .accessibilityIdentifier("au.home.settings")
            }
            .padding(.top, 62)
            .padding(.bottom, 28)

            VStack(alignment: .leading, spacing: 0) {
                Text(ch.no.uppercased())
                    .font(.figtree(.bold, size: 11))
                    .tracking(1.76)
                    .foregroundStyle(Color.auAccentText)
                    .padding(.bottom, 6)
                Text(ch.name)
                    .font(.caprasimo(size: 31))
                    .tracking(-0.62)
                    .lineLimit(2)
                Text("\(ch.level) — \(inChapter) of \(ch.count) lessons")
                    .font(.figtree(.regular, size: 13))
                    .foregroundStyle(Color.auTextSecondary)
                    .padding(.top, 7)
                AUParagraph(
                    text:
                        "\(inChapter >= ch.count ? "Done: you can " : "By the end: you can ")\(ch.promise)",
                    size: 12.5, lineHeight: 1.45, color: Color.auAccentText
                )
                .frame(maxWidth: 288, alignment: .leading)
                .padding(.top, 9)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
        .background(
            ZStack {
                LinearGradient(
                    stops: [
                        .init(color: Color.auBackground, location: 0),
                        .init(
                            color: Color.auBackground.mixed(with: 0.07, of: Color.auAccent),
                            location: 0.30),
                        .init(
                            color: Color.auBackground.mixed(with: 0.16, of: Color.auAccent),
                            location: 0.60),
                        .init(
                            color: Color.auBackground.mixed(with: 0.10, of: Color.auAccent),
                            location: 0.84),
                        .init(color: Color.auBackground, location: 1),
                    ],
                    startPoint: .top, endPoint: .bottom
                )
                RadialGradient(
                    stops: [
                        .init(color: Color.auAccent.opacity(0.18), location: 0),
                        .init(color: .clear, location: 0.68),
                    ],
                    center: UnitPoint(x: 0.30, y: 0.84), startRadius: 0, endRadius: 500
                )
                GrainOverlay(opacity: 0.05)
            }
            .ignoresSafeArea()
        )
    }

    private var ch: AppRouter.ChapterHeader { env.router.chapterHeader }

    private var inChapter: Int {
        min(env.router.basePos + (env.router.lessonsDone - env.router.baseLessons), ch.count)
    }

    /// pathAt (line 2120)
    private var pathAt: Int {
        env.router.basePos + (env.router.lessonsDone - env.router.baseLessons)
    }

    // MARK: Pending resume card (lines 482–491)

    @ViewBuilder
    private var pendingCard: some View {
        if let pending = env.router.pending {
            ACard(radius: 24) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Pick up where you stopped?")
                        .font(.caprasimo(size: 16))
                        .padding(.bottom, 4)
                    Text("You left \(pending.title) at screen \(pending.at) of \(pending.of).")
                        .font(.figtree(.regular, size: 12.5))
                        .auLine(12.5, 1.45)
                        .foregroundStyle(Color.auTextSecondary)
                    HStack(spacing: 9) {
                        APillButton(title: "Resume", compact: true, aid: "au.home.resume") {
                            env.router.resumePending()
                        }
                        Button {
                            env.router.discardPending()
                        } label: {
                            Text("Start over")
                                .font(.figtree(.bold, size: 14))
                                .padding(.horizontal, 18)
                                .padding(.vertical, 13)
                                .background(
                                    RoundedRectangle(cornerRadius: 19, style: .continuous)
                                        .strokeBorder(Color.auEdge, lineWidth: 1)
                                )
                                .foregroundStyle(Color.auTextSecondary)
                        }
                        .buttonStyle(.auTap)
                        .accessibilityIdentifier("au.home.start-over")
                    }
                    .padding(.top, 14)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 14)
        }
    }

    // MARK: Day-arc card (lines 492–528 + 2315–2346)

    /// §3.6(c): the sun's scroll-linked travel — the first ~260 pt of scroll
    /// advance it up to 30% along its arc. Static under Reduce Motion.
    private var sunTravel: Double {
        guard !reduceMotion else { return 0 }
        return min(1, Double(scrollY) / 260) * 0.3
    }

    private var dayArcCard: some View {
        let r = env.router
        let dueNow = r.mistakes.count
        let arc = DayArcState(
            dayLesson: r.dayLesson,
            dayRecall: r.dayRecall,
            dueNow: dueNow,
            arcsCompleted: r.arcs
        )

        return VStack(spacing: 0) {
            ArcSkyView(
                state: arc,
                sunTravel: sunTravel,
                dawnDone: r.dayLesson,
                dawnMeta: dawnMeta,
                sundownDone: arc.arcT >= 1 && r.dayLesson,
                sundownMeta: sundownMeta
            )

            VStack(spacing: 0) {
                // Streak headline — the day's count set as display type,
                // a small ember/spark mark, and the authored explainer.
                Button {
                    r.nav(.streak)
                } label: {
                    HStack(alignment: .center, spacing: 12) {
                        // Ember mark — a lit flame once the streak has
                        // begun, a quiet spark on day one.
                        ZStack {
                            Circle()
                                .fill(Color.auAccent.opacity(r.streak > 0 ? 0.16 : 0.10))
                                .frame(width: 40, height: 40)
                            Circle()
                                .strokeBorder(Color.auAccent.opacity(0.22), lineWidth: 1)
                                .frame(width: 40, height: 40)
                            AUIcon(
                                kind: r.streak > 0 ? .flame : .sparkle,
                                size: 17,
                                color: r.streak > 0 ? .auAccent : .auAccentText
                            )
                        }
                        .accessibilityHidden(true)

                        VStack(alignment: .leading, spacing: 3) {
                            HStack(alignment: .firstTextBaseline, spacing: 6) {
                                Text(r.streak > 0 ? "\(r.streak)" : "Day one")
                                    .font(.caprasimo(size: 27))
                                    .monospacedDigit()
                                    .tracking(-0.54)
                                    .foregroundStyle(Color.auAccentText)
                                if r.streak > 0 {
                                    Text(r.streak == 1 ? "day" : "days")
                                        .font(.figtree(.semibold, size: 14))
                                        .foregroundStyle(Color.auText)
                                }
                            }
                            Text(
                                r.streak > 0
                                    ? "A day counts when both halves are done."
                                    : "A lesson, then the words due back — both halves make a day."
                            )
                            .font(.figtree(.regular, size: 11.5))
                            .auLine(11.5, 1.4)
                            .foregroundStyle(Color.auTextSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .buttonStyle(.auTap)
                .padding(.bottom, 13)

                // A quiet hairline separates "the day so far" from the act.
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.auDivider.opacity(0),
                                Color.auDivider,
                                Color.auDivider.opacity(0),
                            ],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .frame(height: 1)
                    .padding(.bottom, 13)

                if arc.arcT < 1 {
                    DayArcCTA(title: arcLabel, aid: "au.home.today") {
                        if !r.dayLesson {
                            r.goCourse(min(pathAt, 3))
                        } else {
                            r.reviewRun()
                        }
                    }
                } else {
                    HStack(spacing: 11) {
                        AUIcon(kind: .check, size: 17, color: .auOkText)
                        Text(
                            dueNow == 0 && r.dayLesson && !r.dayRecall
                                ? "Today is complete — nothing was due. Tomorrow, a new lesson."
                                : "Today is complete. Tomorrow, these come back one interval wider."
                        )
                        .font(.figtree(.regular, size: 13.5))
                        .auLine(13.5, 1.45)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.auOkBg)
                    )
                    .foregroundStyle(Color.auOkText)

                    Button {
                        r.goCourse(min(pathAt, 3))
                    } label: {
                        Text("One more, for the pleasure of it")
                            .font(.figtree(.bold, size: 13.5))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(
                                RoundedRectangle(cornerRadius: 19, style: .continuous)
                                    .strokeBorder(
                                        Color.auText.opacity(0.2),
                                        style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
                            )
                            .foregroundStyle(Color.auText.opacity(0.62))
                    }
                    .buttonStyle(.auTap)
                    .accessibilityIdentifier("au.home.one-more")
                    .padding(.top, 10)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 16)
        }
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground).opacity(0.16))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: Color.black.opacity(0.10), radius: 16, y: 6)
        .padding(.horizontal, 24)
        .padding(.top, 14)
    }

    /// act1Meta (line 2334)
    private var dawnMeta: String {
        let r = env.router
        if r.dayLesson { return "done" }
        let i = min(pathAt, ch.lessons.count - 1)
        let meta = ch.metas.indices.contains(i) ? ch.metas[i] : ""
        let time =
            meta.split(separator: "·").count > 1
            ? String(meta.split(separator: "·")[1]).trimmingCharacters(in: .whitespaces) : ""
        return "\(ch.lessons.indices.contains(i) ? ch.lessons[i] : "") · \(time)"
    }

    /// act2Meta (line 2335)
    private var sundownMeta: String {
        let r = env.router
        if !r.dayLesson { return "1 min" }
        if r.dayRecall { return "caught" }
        let due = r.mistakes.count
        return due == 0 ? "nothing due" : "\(due)\(due == 1 ? " word · 1 min" : " words · 1 min")"
    }

    /// arcLabel (line 2341)
    private var arcLabel: String {
        let r = env.router
        if !r.dayLesson {
            return pathAt == 0
                ? "Begin Lesson 1 · \(ch.lessons.first ?? "")"
                : "Continue · \(ch.lessons.indices.contains(min(pathAt, 3)) ? ch.lessons[min(pathAt, 3)] : "")"
        }
        let due = r.mistakes.count
        return due == 1 ? "Catch one word · 1 min" : "Catch \(due) words · 1 min"
    }

    // MARK: Lesson path (lines 530–632)

    /// Design canvas is 402×724 (svg 402×816; card tops at 570). Laid out
    /// in design points, then uniformly scaled to the live width so stops,
    /// labels, and the next-chapter card keep authored proportions.
    ///
    /// IMPORTANT: `402 / 724` is integer division (= 0) — always use
    /// CGFloat literals or the aspect-ratio collapses and the path clips
    /// under the tab bar.
    private var lessonPath: some View {
        // Offer the design aspect ratio to ScrollView first; GeometryReader
        // inside the overlay then gets a real non-zero size to scale into.
        // (Bare GeometryReader expands unboundedly / collapses in ScrollView.)
        Color.clear
            .aspectRatio(402.0 / 724.0, contentMode: .fit)
            .overlay {
                GeometryReader { geo in
                    let scale = max(geo.size.width, 1) / 402.0
                    let nodes = pathNodes
                    let cta = env.router.basePos == 0 && pathAt == 0 ? "Begin" : "Resume"

                    ZStack(alignment: .topLeading) {
                        // §3.6(a): the thread draws in over 1.2 s on first
                        // reveal (easeInOut), then stays drawn — the dotted
                        // track and the accent leg share the same trim so the
                        // draw reads as one gesture.
                        WindingPathShape()
                            .trim(from: 0, to: drawT)
                            .stroke(
                                Color.auDivider,
                                style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [3, 9])
                            )

                        WindingPathShape(firstLegOnly: true)
                            .trim(from: 0, to: drawT)
                            .stroke(
                                Color.auAccent,
                                style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                            )
                            .opacity(pathAt > 0 ? 1 : 0.55)

                        ForEach(Array(nodes.enumerated()), id: \.offset) { i, node in
                            LessonPathNode(
                                state: node.state,
                                index: i,
                                cta: cta,
                                label: node.label,
                                meta: node.meta,
                                action: node.action
                            )
                            .position(x: node.x, y: node.y)
                            // §3.6(a): sequential pop-in, 60 ms stagger —
                            // first reveal only (never on later visits).
                            .modifier(
                                NodePopIn(
                                    delay: 0.14 + Double(i) * AUMotion.staggerDelay,
                                    animate: animatePath))
                        }

                        // §3.6(d): the locked-stop explainer — first tap
                        // explains, second tap opens the paywall.
                        if let li = lockedExplainer,
                            nodes.indices.contains(li),
                            nodes[li].state == .locked
                        {
                            LockedStopCard(
                                prev:
                                    ch.lessons.indices.contains(max(0, li - 1))
                                    ? ch.lessons[max(0, li - 1)] : ""
                            )
                            .position(
                                x: min(max(nodes[li].x, 136), 402 - 136),
                                y: nodes[li].y + 68
                            )
                            .transition(
                                reduceMotion
                                    ? .opacity
                                    : .opacity.combined(with: .scale(scale: 0.94))
                            )
                        }

                        ForEach(Array(nodes.enumerated()), id: \.offset) { i, node in
                            VStack(
                                alignment: node.alignRight ? .trailing : .leading, spacing: 3
                            ) {
                                Text(node.label)
                                    .font(.caprasimo(size: i == 0 ? 16 : 15))
                                    .multilineTextAlignment(
                                        node.alignRight ? .trailing : .leading
                                    )
                                    .fixedSize(horizontal: false, vertical: true)
                                    // §3.6(e): AX sizes may shrink the label
                                    // slightly rather than collide with the
                                    // path or the neighbouring stop.
                                    .minimumScaleFactor(0.82)
                                Text(node.meta)
                                    .font(.figtree(.regular, size: 12))
                                    .foregroundStyle(Color.auTextSecondary)
                                    .multilineTextAlignment(
                                        node.alignRight ? .trailing : .leading
                                    )
                                    .fixedSize(horizontal: false, vertical: true)
                                    .minimumScaleFactor(0.82)
                            }
                            .frame(
                                width: node.labelWidth,
                                alignment: node.alignRight ? .trailing : .leading
                            )
                            .opacity(node.state == .locked ? 0.45 : 1)
                            .position(
                                x: node.alignRight
                                    ? node.labelX - node.labelWidth / 2
                                    : node.labelX + node.labelWidth / 2,
                                y: node.labelY
                            )
                            .allowsHitTesting(false)
                            // §3.6(f): the stop's button carries label +
                            // state + meta as one AX element — the drawn
                            // text stays visual only.
                            .accessibilityHidden(true)
                        }

                        Button {
                            env.router.nav(.paywall)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(ch.nextNo)
                                        .font(.caprasimo(size: 15))
                                    Text(ch.nextName)
                                        .font(.figtree(.regular, size: 12))
                                        .foregroundStyle(Color.auTextTertiary)
                                }
                                Spacer(minLength: 8)
                                Text(env.router.pro ? "Open" : "Opens with Pro")
                                    .font(.figtree(.bold, size: 11))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 3)
                                    .background(
                                        Capsule().fill(
                                            env.router.pro ? Color.auOkBg : Color.auFlatBg)
                                    )
                                    .foregroundStyle(
                                        env.router.pro ? Color.auOkQuiet : Color.auFlatText)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .fill(Color.auFill)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .strokeBorder(Color.auEdge, lineWidth: 1)
                            )
                            .auLift()
                        }
                        .buttonStyle(.auTap)
                        .accessibilityIdentifier("au.home.next-chapter")
                        .frame(width: 402 - 48)
                        .offset(x: 24, y: 570)
                    }
                    .frame(width: 402, height: 724, alignment: .topLeading)
                    .scaleEffect(x: scale, y: scale, anchor: .topLeading)
                    .frame(
                        width: geo.size.width, height: 724 * scale, alignment: .topLeading)
                    .onAppear { beginPathReveal() }
                    // §3.6(d): the explainer card enters/leaves on the quick
                    // spring (opacity-only under Reduce Motion).
                    .animation(
                        AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion),
                        value: lockedExplainer)
                }
            }
            .padding(.top, 16)
    }

    /// §3.6(a): the path's trim target — 1 when fully drawn. On revisits the
    /// router flag short-circuits to 1 so the thread never flashes hidden.
    private var drawT: CGFloat {
        env.router.homePathSeen ? 1 : (pathDrawn ? 1 : 0)
    }

    /// §3.6(a): the nodes pop in only on the path's first reveal. The flag
    /// flips after the reveal has fully played (not at its start), so the
    /// stagger is never cut short by the re-render.
    private var animatePath: Bool { !env.router.homePathSeen }

    /// Kick the one-time path reveal (§3.6(a)): a 1.2 s easeInOut draw-in of
    /// the thread plus the staggered node pop-ins. Under Reduce Motion the
    /// path simply appears.
    private func beginPathReveal() {
        guard !env.router.homePathSeen, !pathDrawn else { return }
        if reduceMotion {
            pathDrawn = true
            env.router.homePathSeen = true
            return
        }
        withAnimation(.easeInOut(duration: 1.2)) { pathDrawn = true }
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1.9))  // let the stagger finish
            env.router.homePathSeen = true
        }
    }

    private struct PathNode {
        let x: CGFloat, y: CGFloat
        /// Design-space X of the label's leading edge (left-aligned) or
        /// trailing edge (right-aligned via design `right:`).
        let labelX: CGFloat, labelY: CGFloat
        let labelWidth: CGFloat
        let alignRight: Bool
        let state: LessonPathNode.NodeState
        let label: String
        let meta: String
        let action: () -> Void
    }

    /// mkNode (lines 2122–2141) mapped onto the five authored stop positions.
    private var pathNodes: [PathNode] {
        let r = env.router
        func state(_ i: Int) -> LessonPathNode.NodeState {
            i < pathAt ? .done : (i == pathAt ? .open : .locked)
        }
        func meta(_ i: Int) -> String {
            let st = state(i)
            if st == .locked {
                let prev =
                    ch.lessons.indices.contains(max(0, i - 1))
                    ? ch.lessons[max(0, i - 1)] : ""
                return "Opens after \(prev)"
            }
            return (st == .done ? "Complete · " : "")
                + (ch.metas.indices.contains(i) ? ch.metas[i] : "")
        }
        func act(_ i: Int) -> () -> Void {
            guard state(i) == .locked else {
                return {
                    // Any open explainer steps aside when a playable stop is tapped.
                    lockedExplainer = nil
                    r.goCourse(i)
                }
            }
            // §3.6(d): the first tap explains ("Opens after … — Chapter One is
            // free, later chapters come with Aurel Pro"), the second opens
            // the paywall.
            return {
                if lockedExplainer == i {
                    r.nav(.paywall)
                } else {
                    lockedExplainer = i
                    AUFeedback.press()
                }
            }
        }

        // lesson titles: drop the trailing "Chapter complete" entry (index 4)
        let titles = Array(ch.lessons.prefix(4))
        // Right-aligned labels use design `right: Npx` → trailing edge at 402-N.
        return [
            PathNode(
                x: 132, y: 46, labelX: 196, labelY: 46, labelWidth: 150, alignRight: false,
                state: state(0), label: titles.indices.contains(0) ? titles[0] : "", meta: meta(0),
                action: act(0)),
            PathNode(
                x: 274, y: 152, labelX: 402 - 210, labelY: 152, labelWidth: 130, alignRight: true,
                state: state(1), label: titles.indices.contains(1) ? titles[1] : "", meta: meta(1),
                action: act(1)),
            PathNode(
                x: 124, y: 266, labelX: 188, labelY: 266, labelWidth: 150, alignRight: false,
                state: state(2), label: titles.indices.contains(2) ? titles[2] : "", meta: meta(2),
                action: act(2)),
            PathNode(
                x: 268, y: 374, labelX: 402 - 212, labelY: 374, labelWidth: 128, alignRight: true,
                state: state(3), label: titles.indices.contains(3) ? titles[3] : "", meta: meta(3),
                action: act(3)),
            PathNode(
                x: 136, y: 492, labelX: 200, labelY: 492, labelWidth: 146, alignRight: false,
                state: state(4), label: "Chapter complete", meta: meta(4), action: act(4)),
        ]
    }
}

/// §3.6(a): a path node's entrance — the authored pop, gated to the path's
/// first reveal. `animate` flips false only after the reveal has fully
/// played, so the stagger is never cut short by the re-render.
private struct NodePopIn: ViewModifier {
    let delay: Double
    let animate: Bool

    func body(content: Content) -> some View {
        if animate {
            content.modifier(PopIn(delay: delay))
        } else {
            content
        }
    }
}

/// §3.6(d): the locked-stop explainer — two authored lines under the stop.
/// The first tap on a locked stop shows it; the second opens the paywall.
private struct LockedStopCard: View {
    let prev: String
    var onUnlock: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Opens after \(prev).")
                .font(.figtree(.semibold, size: 13))
                .foregroundStyle(Color.auText)
            Text("Chapter One is free — later chapters come with Aurel Pro.")
                .font(.figtree(.regular, size: 12))
                .auLine(12, 1.4)
                .foregroundStyle(Color.auText.opacity(0.62))

            if let onUnlock {
                Button(action: onUnlock) {
                    HStack(spacing: 4) {
                        Text("Unlock with Pro")
                            .font(.figtree(.bold, size: 12))
                        AUIcon(kind: .chevron, size: 12, color: .auAccentText)
                    }
                    .foregroundStyle(Color.auAccentText)
                    .padding(.top, 4)
                }
                .buttonStyle(.auTap)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .frame(width: 248, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.auFill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.auEdge, lineWidth: 1)
        )
        .auShadowSm()
        .accessibilityElement(children: .combine)
    }
}

/// The day-arc's hero action — a modern, flat, elegant accent pill.
private struct DayArcCTA: View {
    let title: String
    var aid: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: {
            AUFeedback.press()
            action()
        }) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.figtree(.bold, size: 16))
                    .tracking(0.2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                AUIcon(kind: .chevron, size: 12, color: Color.auPrimaryButtonText.opacity(0.9))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .foregroundStyle(Color.auPrimaryButtonText)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(UIColor(hex: 0xb25f1f)))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Color(UIColor(hex: 0xf29858)).opacity(0.60), lineWidth: 1.2)
            )
            .shadow(color: Color(UIColor(hex: 0xb25f1f)).opacity(0.32), radius: 8, x: 0, y: 3)
        }
        .buttonStyle(.auTap)
        .accessibilityIdentifier(aid ?? "au.btn.\(title.auSlug)")
    }
}

/// The serpentine thread (line 532). First leg (line 533) is the accent
/// overlay once the path has begun.
struct WindingPathShape: Shape {
    var firstLegOnly = false
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 132, y: 46))
        if firstLegOnly {
            p.addCurve(
                to: CGPoint(x: 274, y: 152), control1: CGPoint(x: 132, y: 96),
                control2: CGPoint(x: 274, y: 100))
            return p
        }
        p.addCurve(
            to: CGPoint(x: 274, y: 152), control1: CGPoint(x: 132, y: 96),
            control2: CGPoint(x: 274, y: 100))
        p.addCurve(
            to: CGPoint(x: 124, y: 266), control1: CGPoint(x: 274, y: 208),
            control2: CGPoint(x: 124, y: 210))
        p.addCurve(
            to: CGPoint(x: 268, y: 374), control1: CGPoint(x: 124, y: 322),
            control2: CGPoint(x: 268, y: 318))
        p.addCurve(
            to: CGPoint(x: 136, y: 492), control1: CGPoint(x: 268, y: 436),
            control2: CGPoint(x: 136, y: 432))
        return p
    }
}
