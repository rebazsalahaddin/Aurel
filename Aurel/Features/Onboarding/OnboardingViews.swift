import SwiftUI

// MARK: - Onboarding screens
//
// Goal / Placement / Commit / Plan / Assess (the placement stub), ported
// verbatim from Aurel.dc.html lines 181–410.

// MARK: Goal — "Why English?" (lines 181–227)

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
                        .auStagger(0)
                    Text("Pick up to two — it changes what we put in front of you first.")
                        .font(.figtree(.regular, size: 14))
                        .lineSpacing(14 * 0.55)
                        .foregroundStyle(Color.auText.opacity(0.55))
                        .auStagger(0)
                }
                .padding(.bottom, 26)

                VStack(spacing: 11) {
                    ForEach(Array(Self.goals.enumerated()), id: \.element.id) { i, goal in
                        let on = env.router.goals.contains(goal.id)
                        SelectableRow(selected: on, aid: "au.goal.\(goal.id)") {
                            SVGPathShape(d: goal.d)
                                .stroke(
                                    on ? Color.auBackground : Color.auAccent,
                                    style: StrokeStyle(
                                        lineWidth: 2.75, lineCap: .round, lineJoin: .round)
                                )
                                .frame(width: 20, height: 20)
                                .frame(width: 42, height: 42)
                                .background(
                                    Circle().fill(on ? Color.auAccent : Color.auText.opacity(0.09)))
                        } content: {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(goal.title)
                                    .font(.caprasimo(size: 17))
                                Text(goal.sub)
                                    .font(.figtree(.regular, size: 12.5))
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
                    env.router.nav(.placement)
                }
            })
    }
}

// MARK: Placement — "Where do you stand today?" (lines 229–255)

struct PlacementView: View {
    @Environment(AppEnvironment.self) private var env

    /// LEVELS (lines 1659–1664) — A1 authored; A2–B2 shown, never selectable.
    static let levels: [(id: String, band: String, title: String, sub: String, ready: Bool)] = [
        ("a1", "A1", "Foundation", "12 chapters · 42 lessons · authored", true),
        ("a2", "A2", "Everyday", "Awaiting the A2–C1 adaptation guide (F2)", false),
        ("b1", "B1", "Intermediate", "Awaiting the A2–C1 adaptation guide (F2)", false),
        ("b2", "B2", "Upper intermediate", "Awaiting the A2–C1 adaptation guide (F2)", false),
    ]

    var body: some View {
        OnboardingScaffold(
            step: 2, back: { env.router.nav(.goal) },
            content: {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Where do you\nstand today?")
                        .font(.caprasimo(size: 31))
                        .tracking(-0.62)
                        .lineSpacing(31 * 0.08)
                    Text(
                        "A1 is the level that exists today — 12 chapters, 42 lessons. The higher bands arrive with the adaptation guide."
                    )
                    .font(.figtree(.regular, size: 14))
                    .lineSpacing(14 * 0.55)
                    .foregroundStyle(Color.auText.opacity(0.55))
                }
                .padding(.bottom, 26)

                VStack(spacing: 9) {
                    ForEach(Array(Self.levels.enumerated()), id: \.element.id) { i, level in
                        Group {
                            if level.ready {
                                SelectableRow(
                                    selected: env.router.level == level.id,
                                    aid: "au.level.\(level.id)"
                                ) {
                                    Text(level.band)
                                        .font(.caprasimo(size: 22))
                                        .frame(width: 46)
                                        .foregroundStyle(
                                            env.router.level == level.id
                                                ? Color.auAccent : Color.auText.opacity(0.52))
                                } content: {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(level.title)
                                            .font(.figtree(.semibold, size: 15))
                                        Text(level.sub)
                                            .font(.figtree(.regular, size: 12.5))
                                            .foregroundStyle(Color.auText.opacity(0.52))
                                    }
                                } action: {
                                    env.router.setLevel(level.id)
                                }
                            } else {
                                // Shown, never selectable — dashed, muted.
                                HStack(spacing: 14) {
                                    Text(level.band)
                                        .font(.caprasimo(size: 22))
                                        .frame(width: 46)
                                        .foregroundStyle(Color.auText.opacity(0.52))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(level.title)
                                            .font(.figtree(.semibold, size: 15))
                                        Text(level.sub)
                                            .font(.figtree(.regular, size: 12.5))
                                            .foregroundStyle(Color.auText.opacity(0.52))
                                    }
                                }
                                .padding(.horizontal, 18)
                                .padding(.vertical, 15)
                                .opacity(0.42)
                                .background(
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .strokeBorder(
                                            Color.auText.opacity(0.2),
                                            style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
                                )
                            }
                        }
                        .auStagger(i)
                    }
                }

                Spacer(minLength: 24)

                APillButton(title: "Continue") {
                    env.router.nav(.commit)
                }
            })
    }
}

// MARK: Commit — "How much of a morning can you spare?" (lines 257–293)

struct CommitView: View {
    @Environment(AppEnvironment.self) private var env

    private static let commitOpts: [(n: Int, title: String, sub: String)] = [
        (5, "Five minutes", "One lesson, most mornings"),
        (10, "Ten minutes", "A lesson, and the words due back"),
        (20, "Twenty minutes", "A full session, unhurried"),
    ]

    private static let remindOpts: [(t: String, l: String)] = [
        ("07:30", "Morning"), ("12:30", "Midday"), ("19:30", "Evening"),
    ]

    var body: some View {
        OnboardingScaffold(
            step: 3, back: { env.router.nav(.placement) },
            content: {
                VStack(alignment: .leading, spacing: 10) {
                    Text("How much of a\nmorning can you spare?")
                        .font(.caprasimo(size: 31))
                        .tracking(-0.62)
                        .lineSpacing(31 * 0.08)
                    Text("The day gets built around this. Change it whenever you like.")
                        .font(.figtree(.regular, size: 14))
                        .lineSpacing(14 * 0.55)
                        .foregroundStyle(Color.auText.opacity(0.55))
                }
                .padding(.bottom, 26)

                VStack(spacing: 11) {
                    ForEach(Array(Self.commitOpts.enumerated()), id: \.element.n) { i, opt in
                        let on = env.router.commit == opt.n
                        SelectableRow(selected: on, aid: "au.commit.\(opt.n)") {
                            Text("\(opt.n)")
                                .font(.figtree(.bold, size: 15))
                                .monospacedDigit()
                                .frame(width: 42, height: 42)
                                .background(
                                    Circle().fill(on ? Color.auAccent : Color.auText.opacity(0.09))
                                )
                                .foregroundStyle(on ? Color.auBackground : Color.auAccentText)
                        } content: {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(opt.title)
                                    .font(.caprasimo(size: 17))
                                Text(opt.sub)
                                    .font(.figtree(.regular, size: 12.5))
                                    .foregroundStyle(Color.auText.opacity(0.52))
                            }
                        } action: {
                            env.router.setCommitMinutes(opt.n)
                        }
                        .accessibilityLabel("\(opt.title) a day — \(opt.sub)")
                        .auStagger(i)
                    }
                }
                .padding(.bottom, 26)

                Text("One reminder, at")
                    .font(.figtree(.bold, size: 10.5))
                    .tracking(1.47)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.auText.opacity(0.50))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 12)

                HStack(spacing: 9) {
                    ForEach(Array(Self.remindOpts.enumerated()), id: \.element.t) { i, opt in
                        let on = env.router.remindAt == opt.t
                        Button {
                            env.router.setRemindAt(opt.t)
                        } label: {
                            VStack(spacing: 2) {
                                Text(opt.t)
                                    .font(.figtree(.bold, size: 15))
                                    .monospacedDigit()
                                Text(opt.l)
                                    .font(.figtree(.regular, size: 11.5))
                                    .opacity(0.62)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .fill(Color.auFill)
                                    if on {
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .strokeBorder(
                                                Color.auAccent.opacity(0.58), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .strokeBorder(Color.auEdge, lineWidth: 1)
                                    }
                                }
                            )
                        }
                        .buttonStyle(.auTap)
                        .accessibilityAddTraits(on ? .isSelected : [])
                        .accessibilityIdentifier(
                            "au.remind.\(opt.t.replacingOccurrences(of: ":", with: ""))"
                        )
                        .auStagger(i)
                    }
                }

                Spacer(minLength: 24)

                APillButton(title: "Continue") {
                    env.router.skipPlacement()
                    env.router.persist()
                }
                .padding(.bottom, 8)

                ALinkButton(title: "About the placement test") {
                    env.router.nav(.assess)
                }
            })
    }
}

// MARK: Assess — the placement stub (lines 295–311)

/// PLACEMENT is empty by governance ("stubs only in session F2"), so the
/// assess flow is this honest stub — exactly as authored.
struct AssessStubView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
            }
            .frame(height: 44)
            .overlay(alignment: .leading) {
                Button {
                    env.router.nav(.commit)
                } label: {
                    AUIcon(kind: .back, size: 17)
                        .frame(width: 44, height: 44)
                        .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
                }
                .buttonStyle(.auTap)
                .accessibilityLabel("Back")
            }
            .padding(.bottom, 60)

            Spacer(minLength: 0)

            HStack(spacing: 8) {
                AUIcon(kind: .lock, size: 12, color: .auText.opacity(0.52))
                Text("Awaiting course content")
            }
            .font(.figtree(.bold, size: 9.5))
            .tracking(1.33)
            .textCase(.uppercase)
            .foregroundStyle(Color.auText.opacity(0.52))
            .padding(.horizontal, 13)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color.auText.opacity(0.08)))
            .padding(.bottom, 22)

            // The screen placeholder card
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(
                    Color.auText.opacity(0.2), style: StrokeStyle(lineWidth: 1.5, dash: [6, 5])
                )
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.auText.opacity(0.005))
                )
                .overlay(
                    Text("screen placeholder")
                        .font(.figtree(.bold, size: 10.5))
                        .tracking(1.47)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.auText.opacity(0.36))
                )
                .frame(width: 300, height: 140)
                .padding(.bottom, 26)

            Text("Placement comes later")
                .font(.caprasimo(size: 27))
                .tracking(-0.4)
                .padding(.bottom, 10)

            Text(
                "The adaptive placement test is a deferred premium in the course plan — stubs only until session F2 writes it. Until then everyone starts where the course starts: A1, Chapter One."
            )
            .font(.figtree(.regular, size: 14))
            .lineSpacing(14 * 0.6)
            .foregroundStyle(Color.auText.opacity(0.58))
            .frame(maxWidth: 290)
            .multilineTextAlignment(.center)
            .padding(.bottom, 14)

            Text("Source: 00_governance/DECISIONS.md · 03_A1_foundation/STATE.md")
                .font(.figtree(.regular, size: 11))
                .lineSpacing(11 * 0.5)
                .foregroundStyle(Color.auText.opacity(0.40))
                .frame(maxWidth: 290)
                .multilineTextAlignment(.center)
                .padding(.bottom, 28)

            APillButton(title: "Start at A1, Chapter One", compact: false) {
                env.router.assessBegin()
            }
            .frame(width: 220)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 24)
        .padding(.top, 70)
        .padding(.bottom, 34)
    }
}

// MARK: Plan — "Your plan" over dusk (lines 377–410)

struct PlanView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        ZStack {
            PlanDusk()

            VStack(alignment: .leading, spacing: 0) {
                Spacer(minLength: 74)

                Text("Your plan")
                    .font(.figtree(.bold, size: 10.5))
                    .tracking(2.1)
                    .textCase(.uppercase)
                    .foregroundStyle(Color(UIColor(hex: 0xf0a877)))
                    .padding(.bottom, 12)

                Text(planHead)
                    .font(.caprasimo(size: 36))
                    .tracking(-0.9)
                    .lineSpacing(36 * 0.06)
                    .foregroundStyle(Color(red: 0.969, green: 0.937, blue: 0.886))
                    .padding(.bottom, 12)

                Text(
                    "Arc one first — meet and connect. Greetings, then spelling and contact details, then where people are from. The A1 order is fixed by the course dependency graph, so nothing gets moved; your reason for learning shapes which examples and review items come back first."
                )
                .font(.figtree(.regular, size: 14.5))
                .lineSpacing(14.5 * 0.6)
                .foregroundStyle(Color(red: 0.969, green: 0.937, blue: 0.886).opacity(0.78))
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
                                    Color(red: 0.969, green: 0.937, blue: 0.886).opacity(0.6)
                                )
                                .frame(width: 74, alignment: .leading)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(row.what)
                                    .font(.caprasimo(size: 16))
                                    .foregroundStyle(Color(red: 0.969, green: 0.937, blue: 0.886))
                                Text(row.meta)
                                    .font(.figtree(.regular, size: 12))
                                    .foregroundStyle(
                                        Color(red: 0.969, green: 0.937, blue: 0.886).opacity(0.62))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(Color(red: 0.969, green: 0.937, blue: 0.886).opacity(0.10))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .strokeBorder(
                                    Color(red: 0.969, green: 0.937, blue: 0.886).opacity(0.16),
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

                ALinkButton(title: "See the whole ladder") {
                    env.router.nav(.progress)
                }
                .foregroundStyle(Color(red: 0.969, green: 0.937, blue: 0.886).opacity(0.78))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 34)
        }
        .ignoresSafeArea()
    }

    private var planHead: String {
        let match = PlacementView.levels.first { $0.id == env.router.level }
        return "\(match?.band ?? "A1") · \(match?.title ?? "Foundation")."
    }

    private var planRows: [(when: String, what: String, meta: String)] {
        let ch = env.router.chapterHeader
        return [
            ("Today", ch.lessons.first ?? "", ch.metas.first ?? ""),
            (
                "This week", "\(env.router.commit) minutes a day",
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
        VStack(spacing: 0) {
            StepHeader(step: step, total: 4, back: back)
                .padding(.bottom, 34)
            content
        }
        .padding(.horizontal, 24)
        .padding(.top, 74)
        .padding(.bottom, 32)
        .frame(minHeight: 874, alignment: .top)
        .background(Color.auBackground.ignoresSafeArea())
        .auScreenEntrance()
    }
}
