import SwiftUI

// MARK: - Onboarding screens
//
// PH-02 adds a progress-free value sample before Goal (1 of 2) / Commit
// (2 of 2) / Plan. The sample demonstrates context-first learning without
// recording speech or touching durable course progress.

// MARK: Value sample — before setup

struct OnboardingSampleView: View {
    @Environment(AppEnvironment.self) private var env

    private let options = [
        String(localized: "Good morning. I’m Sam."),
        String(localized: "Good night. See you tomorrow."),
        String(localized: "I’m twenty-seven years old."),
    ]

    var body: some View {
        let r = env.router
        ValueFirstScaffold(
            title: String(localized: "A first minute"),
            back: { r.nav(.welcome) },
            skip: { r.skipOnboardingSample() }
        ) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Try Aurel before setup")
                    .font(.caprasimo(size: 29))
                    .tracking(-0.58)
                    .padding(.bottom, 8)
                Text(
                    "Use the situation to choose a natural reply. This sample never changes your lesson progress."
                )
                .font(.figtree(.regular, size: 14))
                .auLine(14, 1.55)
                .foregroundStyle(Color.auTextSecondary)
                .padding(.bottom, 22)

                ACard(radius: 24, role: .insetInfo) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Someone greets you at the door")
                            .font(.figtree(.bold, size: 10.5))
                            .tracking(1.26)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auAccentText)
                        Text("“Good morning! I’m Maya.”")
                            .font(.caprasimo(size: 22))
                            .auHeadLine(22, 1.3)
                        Text("What is the clearest reply?")
                            .font(.figtree(.medium, size: 13))
                            .foregroundStyle(Color.auTextSecondary)
                    }
                }
                .padding(.bottom, 14)

                VStack(spacing: 10) {
                    ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                        let selected = r.onboardingSampleSelection == index
                        Button {
                            r.chooseOnboardingSample(index)
                        } label: {
                            HStack(spacing: 12) {
                                Text(option)
                                    .font(.figtree(.semibold, size: 14.5))
                                    .auLine(14.5, 1.45)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                if selected {
                                    AUIcon(
                                        kind: index == 0 ? .check : .loop,
                                        size: 15,
                                        color: index == 0 ? .auOkText : .auAccentText)
                                }
                            }
                            .padding(.horizontal, 17)
                            .padding(.vertical, 15)
                            .frame(minHeight: 52)
                            .background(AUSelectSurface(selected: selected, radius: 20))
                        }
                        .buttonStyle(.auTap)
                        .accessibilityAddTraits(selected ? .isSelected : [])
                        .accessibilityIdentifier("au.onboarding.sample.option.\(index)")
                    }
                }

                if r.onboardingSampleSelection != nil {
                    AUBanner(
                        text: r.onboardingSampleOutcome == .recognized
                            ? "Exactly. The morning context makes the greeting fit."
                            : "That sentence can be correct elsewhere. Use the morning greeting as your clue.",
                        tone: .info
                    )
                    .padding(.top, 14)
                }

                Spacer(minLength: 24)

                if r.onboardingSampleOutcome == .recognized {
                    APillButton(
                        title: String(localized: "See what that showed"),
                        aid: "au.onboarding.sample.continue"
                    ) {
                        r.continueOnboardingSample()
                    }
                }
            }
        }
    }
}

struct OnboardingValueView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        let skipped = env.router.onboardingSampleOutcome == .skipped
        ValueFirstScaffold(
            title: String(localized: "How Aurel works"),
            back: { env.router.nav(.onboardingSample) }
        ) {
            VStack(alignment: .leading, spacing: 0) {
                AUIcon(kind: skipped ? .arrow : .check, size: 28, color: .auAccentText)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color.auTintBg))
                    .padding(.bottom, 20)

                Text(
                    skipped
                        ? String(localized: "Voice is always optional.")
                        : String(localized: "Meaning first, then your voice.")
                )
                .font(.caprasimo(size: 29))
                .tracking(-0.58)
                .auHeadLine(29, 1.15)
                .padding(.bottom, 10)

                Text(
                    skipped
                        ? String(
                            localized:
                                "You can tap, type, or move on. Aurel never requires a recording to complete a lesson."
                        )
                        : String(
                            localized:
                                "You used context to recognize a natural reply. In lessons, you can say the line, type it, or keep moving."
                        )
                )
                .font(.figtree(.regular, size: 14))
                .auLine(14, 1.55)
                .foregroundStyle(Color.auTextSecondary)
                .padding(.bottom, 22)

                ACard(radius: 24, role: .insetInfo) {
                    VStack(alignment: .leading, spacing: 14) {
                        valueRow(
                            String(localized: "Time"),
                            String(localized: "About 20 minutes, with a natural pause near 10"))
                        valueRow(
                            String(localized: "First outcome"),
                            String(localized: "Greet someone and share your name"))
                        valueRow(
                            String(localized: "Access"),
                            String(localized: "Chapter One is free, with no account"))
                    }
                }
                .padding(.bottom, 16)

                HStack(alignment: .top, spacing: 10) {
                    AUIcon(kind: .speech, size: 15, color: .auAccentText)
                        .padding(.top, 2)
                    Text(
                        "Optional now: say “Good morning. I’m Sam.” Nothing is recorded in this sample."
                    )
                    .font(.figtree(.medium, size: 13))
                    .auLine(13, 1.5)
                    .foregroundStyle(Color.auTextSecondary)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.auFill)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.auEdge, lineWidth: 1)
                )
                .accessibilityIdentifier("au.onboarding.value.summary")

                Spacer(minLength: 24)

                APillButton(
                    title: String(localized: "Shape today’s lesson"),
                    aid: "au.onboarding.value.continue"
                ) {
                    env.router.nav(.goal)
                }
            }
        }
    }

    private func valueRow(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label.auLocalized)
                .font(.figtree(.bold, size: 10))
                .tracking(1.2)
                .textCase(.uppercase)
                .foregroundStyle(Color.auAccentText)
            Text(value.auLocalized)
                .font(.figtree(.medium, size: 13.5))
                .auLine(13.5, 1.45)
        }
    }
}

private struct ValueFirstScaffold<Content: View>: View {
    let title: String
    let back: () -> Void
    var skip: (() -> Void)? = nil
    @ViewBuilder let content: Content

    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 12) {
                        Button(action: back) {
                            AUIcon(kind: .back, size: 17)
                                .frame(width: 44, height: 44)
                                .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
                        }
                        .buttonStyle(.auTap)
                        .accessibilityLabel("Back")
                        Text(title.auLocalized)
                            .font(.figtree(.bold, size: 10.5))
                            .tracking(1.47)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auTextSecondary)
                        Spacer()
                        if let skip {
                            Button("Skip", action: skip)
                                .font(.figtree(.semibold, size: 13))
                                .foregroundStyle(Color.auTextSecondary)
                                .frame(minWidth: 44, minHeight: 44)
                                .accessibilityIdentifier("au.onboarding.sample.skip")
                        }
                    }
                    .padding(.bottom, 28)
                    content
                }
                .padding(.horizontal, 24)
                .padding(.top, 62)
                .padding(.bottom, 32)
                .frame(maxWidth: .infinity, minHeight: geo.size.height, alignment: .top)
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
            step: 1, back: { env.router.nav(.onboardingValue) },
            content: {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Why English?")
                                .font(.caprasimo(size: 31))
                                .tracking(-0.62)
                                .auHeadLine(31, 1.12)
                            AUParagraph(
                                text: String(
                                    localized:
                                        "Pick up to two. Your first choice changes the reason shown on today’s Learn card."
                                ),
                                size: 14, lineHeight: 1.55, color: Color.auText.opacity(0.55)
                            )
                        }
                        Spacer()
                        AUCounterBadge(current: env.router.goals.count, maxCount: 2)
                    }
                    .auStagger(0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 22)

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
                                    .foregroundStyle(Color.auTextSecondary)
                            }
                        } action: {
                            // The router owns the selection haptic (craft
                            // overhaul M5 — the view used to double-fire it).
                            if !on && env.router.goals.count >= 2 {
                                AUFeedback.warning()
                            }
                            env.router.toggleGoal(goal.id)
                        }
                        .auStagger(i + 1)
                    }
                }

                Spacer(minLength: 24)

                Text(env.router.goalHint)
                    .font(.figtree(.regular, size: 12.5))
                    .foregroundStyle(Color.auTextSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 10)

                APillButton(
                    title: continueTitle,
                    disabled: env.router.goals.isEmpty,
                    aid: "au.btn.continue"
                ) {
                    env.router.nav(.commit)
                }
            })
    }

    private var continueTitle: String {
        let count = env.router.goals.count
        if count == 0 { return "Select at least 1 goal" }
        if count == 1 { return "Continue with 1 goal" }
        return "Continue with 2 goals"
    }
}

// MARK: Commit — "A focused lesson, with a pause halfway." (Step 2 of 2)

struct CommitView: View {
    @Environment(AppEnvironment.self) private var env

    private static let paceOptions: [(minutes: Int, title: String, detail: String)] = [
        (
            10, String(localized: "Pause at 10"),
            String(localized: "Reach the natural halfway pause")
        ),
        (
            20, String(localized: "Finish in 20"),
            String(localized: "Complete the full lesson in one sitting")
        ),
    ]

    private static let remindOpts: [(t: String, l: String, icon: AUIcon.Kind)] = [
        ("07:30", "Dawn / Morning", .sparkle),
        ("12:30", "Midday", .clock),
        ("19:30", "Sundown", .star),
        ("", "No reminder", .close),
    ]

    var body: some View {
        OnboardingScaffold(
            step: 2, back: { env.router.nav(.goal) },
            content: {
                VStack(alignment: .leading, spacing: 10) {
                    AUHeading(
                        text: String(localized: "Choose today’s pace."),
                        size: 31, lineHeight: 1.12, tracking: -0.62)
                    AUParagraph(
                        text:
                            String(
                                localized:
                                    "A full lesson is about 20 minutes. Choose the duration Aurel should show on your Learn recommendation; your place is saved either way."
                            ),
                        size: 14, lineHeight: 1.55
                    )
                    .foregroundStyle(Color.auTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 18)

                VStack(spacing: 10) {
                    ForEach(Self.paceOptions, id: \.minutes) { option in
                        let selected = env.router.commit == option.minutes
                        Button {
                            env.router.setCommitMinutes(option.minutes)
                        } label: {
                            HStack(spacing: 14) {
                                AUIcon(
                                    kind: option.minutes == 10 ? .clock : .sparkle,
                                    size: 17,
                                    color: selected ? .auAccent : .auTextSecondary
                                )
                                .frame(width: 38, height: 38)
                                .background(Circle().fill(Color.auText.opacity(0.07)))
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(option.title)
                                        .font(.figtree(.semibold, size: 15))
                                    Text(option.detail)
                                        .font(.figtree(.regular, size: 12.5))
                                        .auLine(12.5, 1.45)
                                        .foregroundStyle(Color.auTextSecondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                if selected {
                                    AUIcon(kind: .check, size: 15, color: .auAccentText)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 13)
                            .background(AUSelectSurface(selected: selected, radius: 20))
                        }
                        .buttonStyle(.auTap)
                        .accessibilityAddTraits(selected ? .isSelected : [])
                        .accessibilityIdentifier("au.pace.\(option.minutes)")
                    }
                }
                .padding(.bottom, 22)

                if env.router.capabilities.notifications {
                    Text("Daily reminder rhythm")
                        .font(.figtree(.bold, size: 10.5))
                        .tracking(1.47)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.auTextSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 12)

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12),
                        ], spacing: 12
                    ) {
                        ForEach(Array(Self.remindOpts.enumerated()), id: \.element.l) { i, opt in
                            let on = env.router.remindAt == opt.t
                            Button {
                                AUFeedback.selection()
                                env.router.setRemindAt(opt.t)
                            } label: {
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        AUIcon(
                                            kind: opt.icon, size: 16,
                                            color: on ? .auAccent : .auText.opacity(0.4))
                                        Spacer()
                                        if on {
                                            Circle().fill(Color.auAccent).frame(width: 6, height: 6)
                                        }
                                    }
                                    Text(opt.t.isEmpty ? "Off" : opt.t)
                                        .font(.figtree(.bold, size: 16))
                                        .monospacedDigit()
                                        .foregroundStyle(Color.auText)
                                    Text(opt.l)
                                        .font(.figtree(.regular, size: 12))
                                        .auLine(12, 1.4)
                                        .foregroundStyle(Color.auTextSecondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 14)
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
                } else {
                    Text(
                        "No reminder is scheduled in this build; your chosen pace still appears on Learn."
                    )
                    .font(.figtree(.regular, size: 12.5))
                    .auLine(12.5, 1.5)
                    .foregroundStyle(Color.auTextSecondary)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.auFill)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .strokeBorder(Color.auEdge, lineWidth: 1))
                }

                Spacer(minLength: 24)

                Text(
                    env.router.capabilities.notifications
                        ? "One gentle reminder a day. Change or turn off anytime in Settings."
                        : "You can change sound, haptics, appearance, and reading size in Settings."
                )
                .font(.figtree(.regular, size: 12))
                .auLine(12, 1.45)
                .foregroundStyle(Color.auTextTertiary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 12)

                APillButton(
                    title: String(localized: "Save pace and see your plan"),
                    aid: "au.btn.continue"
                ) {
                    env.router.finishOnboarding()
                }
            })
    }
}

// MARK: Plan — "Your plan" over dusk (lines 265–302)

struct PlanView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var showLadderSheet = false

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
                    text: env.router.goalFocus.planLine,
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
                                .frame(minWidth: 84, alignment: .leading)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(row.what.auLocalized)
                                    .font(.caprasimo(size: 16))
                                    .auHeadLine(16, 1.25)
                                    .foregroundStyle(AUSceneArt.duskCream)
                                Text(row.meta.auLocalized)
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
                    env.router.startFirstLesson()
                }
                .padding(.bottom, 6)

                Button {
                    showLadderSheet = true
                } label: {
                    Text("See the whole ladder")
                        .font(.figtree(.semibold, size: 14))
                        .foregroundStyle(AUSceneArt.duskCream.opacity(0.82))
                        .underline()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.auTap)
            }
            .padding(.top, 74)
            .padding(.horizontal, 24)
            .padding(.bottom, 34)
        }
        .sheet(isPresented: $showLadderSheet) {
            LadderSheet()
        }
        .ignoresSafeArea()
    }

    private var planHead: String {
        // Data-driven (craft overhaul M6): was hardcoded "A1 · Foundation."
        let ch = env.router.chapterHeader
        return "\(ch.level) · \(ch.name)."
    }

    private var planRows: [(when: String, what: String, meta: String)] {
        let ch = env.router.chapterHeader
        let pace =
            env.router.commit > 10
            ? String(localized: "About 20 minutes · complete the full lesson")
            : String(localized: "About 10 minutes · stop at the natural pause")
        return [
            (String(localized: "Today"), ch.lessons.first ?? "", pace),
            (
                String(localized: "Why this"), env.router.goalFocus.title,
                env.router.goalFocus.reason
            ),
            (
                String(localized: "Outcome"), String(localized: "A practical first meeting"),
                String(localized: "You’ll \(ch.promise)")
            ),
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
