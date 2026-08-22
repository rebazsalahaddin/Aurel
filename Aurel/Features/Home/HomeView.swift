import SwiftUI

// MARK: - Home (Aurel.dc.html lines 451–634)
//
// Header block with the warm wash, the pending-resume card, the day-arc card,
// the winding lesson path, and the next-chapter paywall card.

struct HomeView: View {
    @Environment(AppEnvironment.self) private var env

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
                // Clearance for the floating glass tab (design bottom:26 + bar ~72)
                // plus enough room that the first locked stop is not buried.
                .padding(.bottom, 160)
            }
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

            AUTabBar(current: .home)
                .padding(.horizontal, 14)
                .padding(.bottom, 26)  // design: bottom:26px above home indicator
                .zIndex(6)
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
                    .foregroundStyle(Color.auText.opacity(0.55))
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
                        .foregroundStyle(Color.auText.opacity(0.52))
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
                                .foregroundStyle(Color.auText.opacity(0.58))
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

    private var dayArcCard: some View {
        let r = env.router
        let dueNow = r.mistakes.count
        let arc = DayArcState(
            dayLesson: r.dayLesson,
            dayRecall: r.dayRecall,
            dueNow: dueNow,
            arcsCompleted: r.arcs
        )

        return ACard(radius: 28, padded: false) {
            VStack(spacing: 0) {
                ArcSkyView(
                    state: arc,
                    dawnDone: r.dayLesson,
                    dawnMeta: dawnMeta,
                    sundownDone: arc.arcT >= 1 && r.dayLesson,
                    sundownMeta: sundownMeta
                )

                VStack(spacing: 0) {
                    // Streak row
                    Button {
                        r.nav(.streak)
                    } label: {
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text(r.streak > 0 ? "\(r.streak)" : "Day one")
                                .font(.figtree(.bold, size: 19))
                                .monospacedDigit()
                                .tracking(-0.38)
                                .foregroundStyle(Color.auAccentText)
                            Text(
                                r.streak > 0
                                    ? (r.streak == 1
                                        ? "day. A day counts when both halves are done."
                                        : "days. A day counts when both halves are done.")
                                    : "A lesson, then the words due back — both halves make a day."
                            )
                            .font(.figtree(.regular, size: 11.5))
                            .auLine(11.5, 1.4)
                            .foregroundStyle(Color.auText.opacity(0.52))
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .buttonStyle(.auTap)
                    .padding(.bottom, 9)

                    if arc.arcT < 1 {
                        APillButton(title: arcLabel, aid: "au.home.today") {
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
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        }
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
                        WindingPathShape()
                            .stroke(
                                Color.auDivider,
                                style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [3, 9])
                            )

                        WindingPathShape(firstLegOnly: true)
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
                                Text(node.meta)
                                    .font(.figtree(.regular, size: 12))
                                    .foregroundStyle(Color.auText.opacity(0.52))
                                    .multilineTextAlignment(
                                        node.alignRight ? .trailing : .leading
                                    )
                                    .fixedSize(horizontal: false, vertical: true)
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
                                        .foregroundStyle(Color.auText.opacity(0.48))
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
                }
            }
            .padding(.top, 16)
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
            state(i) == .locked ? { r.nav(.paywall) } : { r.goCourse(i) }
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
