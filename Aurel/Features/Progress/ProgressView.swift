import SwiftUI

// MARK: - Progress
//
// Ported from Aurel.dc.html lines 1275–1515 (+ skillRows, ladder, milestones —
// lines 2582–2791).

struct ProgressView: View {
    @Environment(AppEnvironment.self) private var env

    private struct Skill: Identifiable {
        // Craft overhaul G11: stable identity — a fresh UUID per body
        // evaluation killed SwiftUI diffing/animations (flicker).
        var id: String { label }
        let label: String
        let state: AppRouter.PracticeEvidenceLevel
        let items: Int
        let meta: String
        let weakest: Bool
    }

    /// §3.18(b): skills derive from real LessonRecord aggregates — each
    /// completed course lesson credits the skills its authored type tag
    /// carries (V vocabulary · G grammar · C conversation · R reading
    /// comprehension · M mixed reviews every skill it touches).
    private var skills: [Skill] {
        let r = env.router
        let done = r.lessonRecords().filter { !$0.wasReview }
        var counts: [String: Int] = [
            "Vocabulary": 0, "Grammar": 0, "Listening": 0, "Conversation": 0, "Speaking": 0,
        ]
        for record in done {
            let lesson =
                course.chapters.indices.contains(record.chapterIdx)
                    && course.chapters[record.chapterIdx].lessons.indices.contains(record.lessonIdx)
                ? course.chapters[record.chapterIdx].lessons[record.lessonIdx] : nil
            let tag = lesson?.type ?? ""
            for letter in tag {
                switch letter {
                case "V": counts["Vocabulary", default: 0] += 1
                case "G": counts["Grammar", default: 0] += 1
                case "C": counts["Conversation", default: 0] += 1
                case "R": counts["Listening", default: 0] += 1
                case "M":
                    counts["Vocabulary", default: 0] += 1
                    counts["Grammar", default: 0] += 1
                    counts["Listening", default: 0] += 1
                    counts["Conversation", default: 0] += 1
                default: break
                }
            }
            if lesson?.screens.contains(where: { screen in
                screen.kind == .pronProduce || screen.kind == .roleplay
            }) == true {
                counts["Speaking", default: 0] += 1
            }
        }

        let order = ["Vocabulary", "Grammar", "Listening", "Conversation", "Speaking"]
        let raw = order.map { ($0, counts[$0] ?? 0) }
        let sorted = raw.enumerated()
            .sorted { ($0.element.1, $0.offset) < ($1.element.1, $1.offset) }
            .map { $0.element }
        return sorted.enumerated().map { i, k in
            let level = AppRouter.practiceEvidenceLevel(for: k.1)
            return Skill(
                label: k.0,
                state: level,
                items: k.1,
                meta: i == 0
                    ? (k.1 == 0 ? "Not started — worth ten minutes" : "Weakest — worth ten minutes")
                    : (k.1 == 0
                        ? "Nothing recorded yet"
                        : "\(k.1) lesson\(k.1 == 1 ? "" : "s") · \(level.label.lowercased())"),
                weakest: i == 0
            )
        }
    }

    private var course: CourseStore { env.course }

    var body: some View {
        let r = env.router
        ZStack(alignment: .bottom) {
            Color.auBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .firstTextBaseline) {
                        // §3.18(a): the real start date, from the profile.
                        Text(sinceText)
                            .font(.figtree(.bold, size: 10.5))
                            .tracking(1.68)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auAccentText)
                        Spacer()
                        // §3.18(a): the real last-practised day, from DayLog.
                        Text(lastPractisedText)
                            .font(.figtree(.regular, size: 11.5))
                            .foregroundStyle(Color.auTextSecondary)
                    }
                    .padding(.bottom, 2)

                    Text("Progress")
                        .font(.caprasimo(size: 29))
                        .tracking(-0.58)
                        .padding(.bottom, 6)
                    Text(AppRouter.TopLevelSection.progress.purpose.auLocalized)
                        .font(.figtree(.regular, size: 13.5))
                        .auLine(13.5, 1.5)
                        .foregroundStyle(Color.auTextSecondary)
                        .padding(.bottom, 16)
                        .accessibilityIdentifier("au.progress.purpose")

                    ACard(radius: 20, role: .insetInfo) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("How practice levels work")
                                .font(.figtree(.semibold, size: 13.5))
                            Text(AppRouter.PracticeEvidenceLevel.explanation.auLocalized)
                                .font(.figtree(.regular, size: 12.5))
                                .auLine(12.5, 1.5)
                                .foregroundStyle(Color.auTextSecondary)
                        }
                    }
                    .padding(.bottom, 10)
                    .accessibilityIdentifier("au.progress.level-explanation")

                    // skills
                    VStack(spacing: 2) {
                        ForEach(Array(skills.enumerated()), id: \.element.id) { idx, k in
                            Button {
                                // Craft overhaul G12: each skill routes to its
                                // own practice surface (Vocab/Grammar review,
                                // Listening/Conversation scene, Speaking speak).
                                switch k.label {
                                case "Speaking": r.nav(.speak)
                                case "Listening", "Conversation": r.nav(.scene)
                                default: r.nav(.review)
                                }
                            } label: {
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(alignment: .firstTextBaseline, spacing: 10) {
                                        Text(k.label.auLocalized)
                                            .font(.caprasimo(size: 16.5))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(k.state.label.auLocalized)
                                            .font(.figtree(.bold, size: 10))
                                            .tracking(1.2)
                                            .textCase(.uppercase)
                                            .padding(.horizontal, 9)
                                            .padding(.vertical, 3)
                                            .background(Capsule().fill(tagBg(k.state)))
                                            .foregroundStyle(tagFg(k.state))
                                        // Craft overhaul G12: the row reads as
                                        // navigable now (was no affordance).
                                        AUIcon(kind: .chevron, size: 13, color: .auTextTertiary)
                                    }
                                    .padding(.bottom, 9)
                                    GeometryReader { geo in
                                        ZStack(alignment: .leading) {
                                            Capsule().fill(Color.auText.opacity(0.10))
                                            Capsule()
                                                .fill(fillColor(k.state))
                                                .frame(width: geo.size.width * k.state.fill)
                                        }
                                    }
                                    .frame(height: 7)
                                    Text(k.meta.auLocalized)
                                        .font(.figtree(.regular, size: 11.5))
                                        .foregroundStyle(Color.auTextSecondary)
                                        .padding(.top, 8)
                                }
                                .padding(.vertical, 16)
                            }
                            .buttonStyle(.auTap)
                            .accessibilityLabel(
                                "\(k.label): \(k.state.label), \(k.items) lesson\(k.items == 1 ? "" : "s")"
                            )
                            // Craft overhaul G18: no stray hairline under the last row.
                            .overlay(alignment: .bottom) {
                                if idx < skills.count - 1 {
                                    Divider().overlay(Color.auDivider)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 18)

                    if let weakest = skills.first {
                        let next = r.progressNextAction(
                            skill: weakest.label, evidenceCount: weakest.items)
                        AUNextActionCard(
                            eyebrow: String(localized: "Next improvement"),
                            title: next.title,
                            reason: next.reason,
                            duration: next.duration,
                            outcome: next.outcome,
                            buttonTitle: next.buttonTitle,
                            aid: "au.progress.recommendation"
                        ) {
                            r.perform(next)
                        }
                        .padding(.bottom, 26)
                    }

                    // totals
                    HStack(spacing: 0) {
                        totalTile(value: "\(wordsTotal)", label: "Words retained")
                        Rectangle()
                            .fill(Color.auDivider)
                            .frame(width: 1)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 2)
                        totalTile(value: "\(minsTotal)", label: "Minutes total")
                    }
                    .padding(.bottom, 26)

                    // 8-week chart
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Time practised, last 8 weeks")
                            .font(.figtree(.regular, size: 11))
                            .tracking(1.32)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auTextTertiary)
                            .padding(.bottom, 20)

                        HStack(alignment: .bottom, spacing: 8) {
                            ForEach(Array(bars.enumerated()), id: \.offset) { i, h in
                                practiceBar(index: i, height: h, hasHistory: hasHistory)
                                    .modifier(GrowBar(delay: Double(i) * 0.06))
                            }
                        }
                        .frame(height: 96)
                        // §3.18(d): the chart carries one AX line.
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(chartAxSummary)

                        HStack {
                            // §3.18(c): the real month at the chart's left edge.
                            Text(chartStartMonth)
                                .font(.figtree(.regular, size: 10))
                                .foregroundStyle(Color.auTextTertiary)
                            Spacer()
                            Text("Today")
                                .font(.figtree(.regular, size: 10))
                                .foregroundStyle(Color.auTextTertiary)
                        }
                        .padding(.top, 9)

                        if !hasHistory {
                            Text("Eight weeks from now this will say something.")
                                .font(.figtree(.regular, size: 13.5))
                                .auLine(13.5, 1.55)
                                .foregroundStyle(Color.auTextTertiary)
                                .padding(.top, 16)
                        }
                    }
                    .padding(.vertical, 20)
                    .overlay(alignment: .top) { Divider().overlay(Color.auDivider) }
                    .padding(.bottom, 4)

                    // ladder
                    VStack(alignment: .leading, spacing: 0) {
                        Text("The ladder")
                            .font(.figtree(.bold, size: 10.5))
                            .tracking(1.26)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auTextSecondary)
                            .padding(.bottom, 6)

                        ForEach(
                            Array(
                                [
                                    ("A1", "Foundation · 12 chapters", "Here"),
                                    ("A2", "Elementary", "Not written yet"),
                                    ("B1", "Intermediate", "Not written yet"),
                                    ("B2", "Upper intermediate", "Not written yet"),
                                    ("C1", "Advanced", "Not written yet"),
                                ].enumerated()), id: \.offset
                        ) { i, l in
                            HStack(spacing: 14) {
                                Text(l.0)
                                    .font(.caprasimo(size: 18))
                                    .frame(width: 34, alignment: .leading)
                                    .foregroundStyle(
                                        l.2 == "Here" ? Color.auAccent : Color.auText.opacity(0.30))
                                Text(l.1)
                                    .font(.figtree(.semibold, size: 14.5))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                if l.2 == "Here" {
                                    Text(l.2)
                                        .font(.figtree(.regular, size: 11))
                                        .tracking(0.33)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 3)
                                        .background(Capsule().fill(Color.auAccent))
                                        .foregroundStyle(Color.auBackground)
                                } else {
                                    Text(l.2)
                                        .font(.figtree(.regular, size: 11.5))
                                        .opacity(0.4)
                                }
                            }
                            .padding(.vertical, 13)
                            .overlay(alignment: .bottom) {
                                if i < 4 { Divider().overlay(Color.auDivider) }
                            }
                        }
                    }
                    .padding(.vertical, 24)
                    .overlay(alignment: .top) { Divider().overlay(Color.auDivider) }
                }
                .padding(.horizontal, 24)
                .padding(.top, 70)
                .padding(.bottom, 130)
            }
        }
        .auScreenEntrance()
    }

    /// §3.18(a): "Since 22 August" — the profile's honest start date.
    private var sinceText: String {
        guard let start = env.router.profileStartDate() else { return "Day one" }
        let f = DateFormatter()
        f.dateFormat = "d MMMM"
        return "Since \(f.string(from: start))"
    }

    /// §3.18(a): "Last practised today / yesterday / on Friday" — the real
    /// last day either half of the arc was done.
    private var lastPractisedText: String {
        guard let last = env.router.lastPractisedDay() else { return "Nothing practised yet" }
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let days = cal.dateComponents([.day], from: last, to: today).day ?? 0
        if days <= 0 { return "Last practised today" }
        if days == 1 { return "Last practised yesterday" }
        if days < 7 {
            let f = DateFormatter()
            f.dateFormat = "EEEE"
            return "Last practised \(f.string(from: last))"
        }
        let f = DateFormatter()
        f.dateFormat = "d MMMM"
        return "Last practised \(f.string(from: last))"
    }

    /// §3.18: words the completed lessons actually carry — counted from the
    /// course's own vocabulary cards (real course data, real records), never
    /// a per-lesson estimate.
    private var wordsTotal: Int {
        let r = env.router
        let done = Set(
            r.lessonRecords().filter { !$0.wasReview }.map { "\($0.chapterIdx)-\($0.lessonIdx)" })
        guard !done.isEmpty else { return 0 }
        var words = 0
        for f in env.course.flat {
            guard done.contains("\(indexOf(ch: f.chapter.id))-\(f.lesson.n - 1)") else { continue }
            if case .cards(let sc) = f.screen.payload {
                words += sc.cards?.count ?? 0
            }
        }
        return words
    }

    /// The chapter's index for a chapter id ("A1-C03" → 2).
    private func indexOf(ch id: String) -> Int {
        env.course.chapters.firstIndex { $0.id == id } ?? 0
    }

    /// §3.18: real minutes over the whole history, from DayLog.
    private var minsTotal: Int {
        AppRouter.totalMinutes(env.router.dayLogs())
    }

    /// §3.18(c): minutes per week from real DayLog history — empty weeks
    /// render zero-height bars (no invented history).
    private var bars: [Int] {
        AppRouter.weeklyMinutes(env.router.dayLogs())
    }

    /// The month label at the chart's left edge — the real month 8 weeks back.
    private var chartStartMonth: String {
        guard let start = Calendar.current.date(byAdding: .weekOfYear, value: -7, to: Date()) else {
            return ""
        }
        let f = DateFormatter()
        f.dateFormat = "MMM"
        return f.string(from: start)
    }

    /// §3.18(d): the one-line AX summary of the chart.
    private var chartAxSummary: String {
        let weeks = bars
        let total = weeks.reduce(0, +)
        let busiest = weeks.max() ?? 0
        return
            "Time practised, last 8 weeks: \(total) minutes total. Busiest week \(busiest) minutes."
    }

    /// §3.18(c): whether any real minutes exist — empty history renders the
    /// quiet dashed scaffold, never invented bars.
    private var hasHistory: Bool {
        bars.contains { $0 > 0 }
    }

    /// Bar heights map real minutes onto the 96 pt track (10 min ≈ full).
    private func practiceBar(index: Int, height: Int, hasHistory: Bool) -> some View {
        let isToday = index == 7
        // Empty history: a quiet 6 pt dashed scaffold per week — zero bars.
        let h = hasHistory ? min(96, CGFloat(height) * 9.6) : 6
        let colors: [Color] = {
            if hasHistory {
                let color = isToday ? Color.auAccent : Color.auAccentRamp(300)
                return [color, color]
            }
            if isToday {
                return [Color.auAccent.mixed(with: 0.28, of: .white), Color.auAccent]
            }
            return [Color.auText.opacity(0.05), .clear]
        }()
        // Craft overhaul G19: a solid bar uses a flat Color; only genuinely
        // two-tone bars keep a gradient.
        let barFill: AnyShapeStyle = {
            if hasHistory, colors.count == 2, colors[0] == colors[1] {
                return AnyShapeStyle(colors[0])
            }
            return AnyShapeStyle(
                LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom))
        }()

        return RoundedRectangle(cornerRadius: 6, style: .continuous)
            // Craft overhaul G19: flat fill for solid bars (was a pointless
            // identical-color gradient wrapper).
            .fill(barFill)
            .overlay {
                if !hasHistory && !isToday {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .strokeBorder(
                            Color.auText.opacity(0.15),
                            style: StrokeStyle(lineWidth: 1, dash: [4, 3])
                        )
                }
            }
            // Craft overhaul G20: no glow on an empty scaffold bar — the
            // accent pool only appears once today has real minutes.
            .shadow(
                color: isToday && hasHistory ? Color.auAccent.opacity(0.28) : .clear, radius: 7,
                y: 6
            )
            .frame(height: h)
            .frame(maxHeight: 96, alignment: .bottom)
            .accessibilityHidden(true)  // the chart carries one AX line (§3.18d)
    }

    private func tagBg(_ s: AppRouter.PracticeEvidenceLevel) -> Color {
        if s.rawValue >= AppRouter.PracticeEvidenceLevel.repeated.rawValue { return .auOkBg }
        if s == .notStarted { return Color.auText.opacity(0.08) }
        return .auTintBg
    }

    private func tagFg(_ s: AppRouter.PracticeEvidenceLevel) -> Color {
        if s.rawValue >= AppRouter.PracticeEvidenceLevel.repeated.rawValue { return .auOkQuiet }
        if s == .notStarted { return Color.auText.opacity(0.52) }
        return .auTintText
    }

    private func fillColor(_ s: AppRouter.PracticeEvidenceLevel) -> Color {
        if s.rawValue >= AppRouter.PracticeEvidenceLevel.repeated.rawValue { return .auAccent2 }
        if s == .notStarted { return Color.auText.opacity(0.18) }
        return .auAccent
    }

    private func totalTile(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(value)
                .font(.figtree(.bold, size: 33))
                .monospacedDigit()
                .tracking(-0.99)
            Text(label.uppercased())
                .font(.figtree(.semibold, size: 10.5))
                .tracking(1.05)
                .foregroundStyle(Color.auTextSecondary)
                .padding(.top, 9)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// auGrowBar — bars rise from the bottom.
struct GrowBar: ViewModifier {
    let delay: Double
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var shown = false

    func body(content: Content) -> some View {
        if reduceMotion {
            content
        } else {
            content
                .scaleEffect(x: 1, y: shown ? 1 : 0, anchor: .bottom)
                .task {
                    try? await Task.sleep(for: .seconds(delay))
                    withAnimation(.timingCurve(0.16, 0.84, 0.3, 1, duration: 0.62)) { shown = true }
                }
        }
    }
}
