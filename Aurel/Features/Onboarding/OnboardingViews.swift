import SwiftUI

// MARK: - Onboarding screens
//
// Goal (1 of 2) / Commit (2 of 2) / Plan, ported verbatim from
// Aurel V4.dc.html lines 205–302.

// MARK: Goal — "Why English?" (Step 1 of 2)

struct GoalView: View {
    @Environment(AppEnvironment.self) private var env

    private static let goals: [(id: String, d: String, title: String, sub: String)] = [
        (
            "work", "M2.5 7.5h19v12.5h-19zM8.5 7.5V6a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v1.5M2.5 12.5h19",
            "Work and interviews", "Meetings, email, negotiation"
        ),
        (
            "travel",
            AUIcon.circle(cx: 12, cy: 12, r: 9) + "M3 12h18M12 3a14 14 0 0 1 0 18 14 14 0 0 1 0-18",
            "Travel and living abroad", "Getting by, getting around"
        ),
        (
            "exam", "M12 4 2.5 9 12 14l9.5-5zM6.2 11.3V16c0 1.7 2.6 3 5.8 3s5.8-1.3 5.8-3v-4.7",
            "An exam", "IELTS, TOEFL, Cambridge"
        ),
        (
            "self",
            "M3 5.5h5a3 3 0 0 1 3 3V19a2.5 2.5 0 0 0-2.5-2.5H3zM21 5.5h-5a3 3 0 0 0-3 3V19a2.5 2.5 0 0 1 2.5-2.5H21",
            "Myself", "Books, film, conversation"
        ),
    ]

    var body: some View {
        OnboardingScaffold(
            step: 1, back: { env.router.nav(.welcome) },
            content: {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Why English?")
                        .font(.caprasimo(size: 31))
                        .tracking(-0.62)
                        .auHeadLine(31, 1.12)
                        .auStagger(0)
                    AUParagraph(
                        text: "Pick up to two — it changes what we put in front of you first.",
                        size: 14, lineHeight: 1.55, color: Color.auText.opacity(0.55)
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .auStagger(0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 26)

                VStack(spacing: 11) {
                    ForEach(Array(Self.goals.enumerated()), id: \.element.id) { i, goal in
                        let on = env.router.goals.contains(goal.id)
                        SelectableRow(selected: on, aid: "au.goal.\(goal.id)") {
                            SVGPathShape(d: goal.d)
                                .stroke(
                                    on ? Color.auBackground : Color.auAccent,
                                    style: StrokeStyle(
                                        // 2.75 viewBox units, drawn at 20 pt
                                        lineWidth: 2.75 * 20 / 24, lineCap: .round, lineJoin: .round
                                    )
                                )
                                .frame(width: 20, height: 20)
                                .frame(width: 42, height: 42)
                                .background(
                                    Circle().fill(on ? Color.auAccent : Color.auText.opacity(0.09)))
                        } content: {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(goal.title)
                                    .font(.caprasimo(size: 17))
                                    .auHeadLine(17, 1.2)
                                Text(goal.sub)
                                    .font(.figtree(.regular, size: 12.5))
                                    .auLine(12.5, 1.55)
                                    .foregroundStyle(Color.auText.opacity(0.52))
                            }
                        } action: {
                            env.router.toggleGoal(goal.id)
                        }
                        .auStagger(i + 1)
                    }
                }

                Spacer(minLength: 24)

                Text(env.router.goalHint)
                    .font(.figtree(.regular, size: 12.5))
                    .foregroundStyle(Color.auText.opacity(0.50))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 10)

                APillButton(title: "Continue", disabled: env.router.goals.isEmpty) {
                    env.router.nav(.commit)
                }
            })
    }
}

// MARK: Commit — "A focused lesson, with a pause halfway." (Step 2 of 2)

struct CommitView: View {
    @Environment(AppEnvironment.self) private var env

    private static let remindOpts: [(t: String, l: String)] = [
        ("07:30", "Morning"), ("12:30", "Midday"), ("19:30", "Evening"), ("", "No reminder"),
    ]

    var body: some View {
        OnboardingScaffold(
            step: 2, back: { env.router.nav(.goal) },
            content: {
                VStack(alignment: .leading, spacing: 10) {
                    AUHeading(
                        text: "A focused lesson,\nwith a pause halfway.",
                        size: 31, lineHeight: 1.12, tracking: -0.62)
                    AUParagraph(
                        text:
                            "A lesson runs about 20 minutes, with a natural place to stop around the middle. Pause and resume whenever you like — nothing is lost.",
                        size: 14, lineHeight: 1.55
                    )
                    .foregroundStyle(Color.auText.opacity(0.55))
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 26)

                Text("One reminder, if you like")
                    .font(.figtree(.bold, size: 10.5))
                    .tracking(1.47)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.auText.opacity(0.50))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 12)

                HStack(spacing: 9) {
                    ForEach(Array(Self.remindOpts.enumerated()), id: \.element.l) { i, opt in
                        let on = env.router.remindAt == opt.t
                        Button {
                            env.router.setRemindAt(opt.t)
                        } label: {
                            VStack(spacing: 2) {
                                Text(opt.t.isEmpty ? "—" : opt.t)
                                    .font(.figtree(.bold, size: 15))
                                    .monospacedDigit()
                                Text(opt.l)
                                    .font(.figtree(.regular, size: 11.5))
                                    .auLine(11.5, 1.55)
                                    .opacity(0.62)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 8)
                            .background(AUSelectSurface(selected: on, radius: 20))
                        }
                        .buttonStyle(.auTap)
                        .accessibilityAddTraits(on ? .isSelected : [])
                        .accessibilityIdentifier(
                            "au.remind.\(opt.t.isEmpty ? "none" : opt.t.replacingOccurrences(of: ":", with: ""))"
                        )
                        .auStagger(i)
                    }
                }

                Spacer(minLength: 24)

                APillButton(title: "Continue") {
                    env.router.finishOnboarding()
                }
            })
    }
}

// MARK: Plan — "Your plan" over dusk (lines 265–302)

struct PlanView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        ZStack {
            PlanDusk()

            VStack(alignment: .leading, spacing: 0) {
                Text("Your plan")
                    .font(.figtree(.bold, size: 10.5))
                    .tracking(2.1)
                    .textCase(.uppercase)
                    .foregroundStyle(Color(UIColor(hex: 0xf0a877)))
                    .padding(.bottom, 12)

                AUHeading(
                    text: planHead, size: 36, lineHeight: 1.06, tracking: -0.9,
                    color: AUSceneArt.duskCream
                )
                .padding(.bottom, 12)

                AUParagraph(
                    text:
                        "Arc one first — meet and connect. Greetings, then spelling and contact details, then where people are from. The A1 order is fixed by the course dependency graph, so nothing gets moved; your reason for learning shapes which examples and review items come back first.",
                    size: 14.5, lineHeight: 1.6,
                    color: AUSceneArt.duskCream.opacity(0.78)
                )
                .frame(maxWidth: 300, alignment: .leading)
                .padding(.bottom, 30)

                VStack(spacing: 10) {
                    ForEach(Array(planRows.enumerated()), id: \.offset) { i, row in
                        HStack(alignment: .firstTextBaseline, spacing: 14) {
                            Text(row.when)
                                .font(.figtree(.bold, size: 10))
                                .tracking(1.4)
                                .textCase(.uppercase)
                                .foregroundStyle(
                                    AUSceneArt.duskCream.opacity(0.6)
                                )
                                .frame(width: 74, alignment: .leading)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(row.what)
                                    .font(.caprasimo(size: 16))
                                    .auHeadLine(16, 1.25)
                                    .foregroundStyle(AUSceneArt.duskCream)
                                Text(row.meta)
                                    .font(.figtree(.regular, size: 12))
                                    .auLine(12, 1.55)
                                    .foregroundStyle(
                                        AUSceneArt.duskCream.opacity(0.62))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 19)
                        .padding(.vertical, 17)
                        .background(.ultraThinMaterial.opacity(0.55), in: .rect(cornerRadius: 22))
                        .background(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(AUSceneArt.duskCream.opacity(0.10))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .strokeBorder(
                                    AUSceneArt.duskCream.opacity(0.16),
                                    lineWidth: 1)
                        )
                        .auStagger(i)
                    }
                }

                Spacer(minLength: 20)

                APillButton(title: "Start your first lesson") {
                    env.router.goStarter()
                }
                .padding(.bottom, 6)

                ALinkButton(
                    title: "See the whole ladder",
                    tint: AUSceneArt.duskCream.opacity(0.78)
                ) {
                    env.router.nav(.progress)
                }
            }
            .padding(.top, 74)
            .padding(.horizontal, 24)
            .padding(.bottom, 34)
        }
        .ignoresSafeArea()
    }

    private var planHead: String {
        "A1 · Foundation."
    }

    private var planRows: [(when: String, what: String, meta: String)] {
        let ch = env.router.chapterHeader
        return [
            ("Today", ch.lessons.first ?? "", ch.metas.first ?? ""),
            (
                "Each lesson", "≈20 minutes, pause halfway",
                "One lesson a session — the course production rule"
            ),
            (ch.no, ch.name, "\(ch.count) lessons · \(ch.level)"),
        ]
    }
}

// MARK: Shared onboarding scaffold

/// The .au-screen column with paper backdrop, back chevron and step meter.
struct OnboardingScaffold<Content: View>: View {
    let step: Int
    let back: () -> Void
    @ViewBuilder var content: Content

    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                // The design column is a `flex-direction:column` block: every
                // child spans the full 354 pt content width, left-aligned.
                VStack(alignment: .leading, spacing: 0) {
                    StepHeader(step: step, total: 2, back: back)
                        .padding(.bottom, 34)
                    content
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 74)
                .padding(.bottom, 32)
                .frame(minHeight: geo.size.height, alignment: .top)
            }
        }
        .background {
            ZStack {
                Color.auBackground
                AUPaper()
            }
            .ignoresSafeArea()
        }
        .auScreenEntrance()
    }
}
