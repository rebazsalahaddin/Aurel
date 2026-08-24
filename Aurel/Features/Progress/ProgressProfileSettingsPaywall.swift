import SwiftUI

// MARK: - Progress · Profile · Settings · Paywall
//
// Ported from Aurel.dc.html lines 1275–1515 (+ skillRows, ladder, milestones,
// plans, proFeatures — lines 2582–2791).

// MARK: Progress

struct ProgressView: View {
    @Environment(AppEnvironment.self) private var env

    private struct Skill: Identifiable {
        // Craft overhaul G11: stable identity — a fresh UUID per body
        // evaluation killed SwiftUI diffing/animations (flicker).
        var id: String { label }
        let label: String
        let state: Int
        let items: Int
        let meta: String
        let weakest: Bool
    }

    private let mastery = ["Not started", "Seen", "Practised", "Familiar", "Strong", "Mastered"]
    private let mfill: [Double] = [0.03, 0.1, 0.3, 0.52, 0.78, 1]

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
            let tag =
                course.chapters.indices.contains(record.chapterIdx)
                ? course.chapters[record.chapterIdx].lessons.indices.contains(record.lessonIdx)
                    ? course.chapters[record.chapterIdx].lessons[record.lessonIdx].type : ""
                : ""
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
        }
        // Craft overhaul G14: "Speaking" advances from real take history,
        // not a hardcoded 1 — the count of recorded takes this run.
        if r.speakTake > 0 { counts["Speaking"] = r.speakTake }

        let order = ["Vocabulary", "Grammar", "Listening", "Conversation", "Speaking"]
        let raw = order.map { ($0, counts[$0] ?? 0) }
        let sorted = raw.enumerated()
            .sorted { ($0.element.1, $0.offset) < ($1.element.1, $1.offset) }
            .map { $0.element }
        return sorted.enumerated().map { i, k in
            Skill(
                label: k.0,
                state: state(for: k.1),
                items: k.1,
                meta: i == 0
                    ? (k.1 == 0 ? "Not started — worth ten minutes" : "Weakest — worth ten minutes")
                    : (k.1 == 0
                        ? "Nothing recorded yet" : "\(k.1) lesson\(k.1 == 1 ? "" : "s") \(mastery[state(for: k.1)].lowercased())"),
                weakest: i == 0
            )
        }
    }

    /// The mastery tier for a completed-lesson count.
    private func state(for count: Int) -> Int {
        switch count {
        case 0: 0
        case 1: 1
        case 2: 2
        case 3: 3
        case 4...7: 4
        default: 5
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
                        .padding(.bottom, 22)

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
                                        Text(k.label)
                                            .font(.caprasimo(size: 16.5))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(mastery[k.state])
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
                                                .frame(width: geo.size.width * mfill[k.state])
                                        }
                                    }
                                    .frame(height: 7)
                                    Text(k.meta)
                                        .font(.figtree(.regular, size: 11.5))
                                        .foregroundStyle(Color.auTextSecondary)
                                        .padding(.top, 8)
                                }
                                .padding(.vertical, 16)
                            }
                            .buttonStyle(.auTap)
                            .accessibilityLabel("\(k.label): \(mastery[k.state]), \(k.items) lesson\(k.items == 1 ? "" : "s")")
                            // Craft overhaul G18: no stray hairline under the last row.
                            .overlay(alignment: .bottom) {
                                if idx < skills.count - 1 {
                                    Divider().overlay(Color.auDivider)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 18)

                    APillButton(title: weakestCta) {
                        if let w = skills.first, w.label == "Speaking" {
                            r.nav(.speak)
                        } else {
                            r.goCourse(min(pathAt, 3))
                        }
                    }
                    .padding(.bottom, 26)

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

    private var pathAt: Int {
        let r = env.router
        return r.basePos + (r.lessonsDone - r.baseLessons)
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

    private var weakestCta: String {
        let r = env.router
        if let w = skills.first { return "Practise \(w.label.lowercased()) — \(r.commit) minutes" }
        return "Start a lesson"
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
            return AnyShapeStyle(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom))
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

    private func tagBg(_ s: Int) -> Color {
        if s >= 4 { return .auOkBg }
        if s == 0 { return Color.auText.opacity(0.08) }
        return .auTintBg
    }

    private func tagFg(_ s: Int) -> Color {
        if s >= 4 { return .auOkQuiet }
        if s == 0 { return Color.auText.opacity(0.52) }
        return .auTintText
    }

    private func fillColor(_ s: Int) -> Color {
        if s >= 4 { return .auAccent2 }
        if s == 0 { return Color.auText.opacity(0.18) }
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

// MARK: Profile

struct ProfileView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        let r = env.router
        ZStack(alignment: .bottom) {
            Color.auBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 18) {
                        // Craft overhaul G6: real account state, not "Mira Aldrin".
                        Text(profileInitial)
                            .font(.caprasimo(size: 30))
                            .frame(width: 76, height: 76)
                            .background(Circle().fill(Color.auAccentRamp(700)))
                            .foregroundStyle(AUSceneArt.onAccent)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(profileName)
                                .font(.caprasimo(size: 26))
                                .tracking(-0.52)
                            // §3.19: the real join date, from the profile.
                            Text("A1 · Foundation — \(joinedText)")
                                .font(.figtree(.regular, size: 13))
                                .foregroundStyle(Color.auTextSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Button {
                            r.nav(.settings)
                        } label: {
                            AUIcon(kind: .pencil, size: 17)
                                .frame(width: 44, height: 44)
                                .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
                        }
                        .buttonStyle(.auTap)
                        .accessibilityLabel("Edit profile")
                    }
                    .padding(.bottom, 28)

                    // stats
                    HStack(spacing: 0) {
                        // An em dash stands in for a stat with nothing behind it.
                        profileStat(r.streak > 0 ? "\(r.streak)" : "—", "Streak")
                        Rectangle().fill(Color.auEdge).frame(width: 1)
                        profileStat(
                            // Craft overhaul G7: real store-derived count.
                            r.wordsLearned > 0 ? "\(r.wordsLearned)" : "—", "Words")
                        Rectangle().fill(Color.auEdge).frame(width: 1)
                        profileStat(r.lessonsDone > 0 ? "\(r.lessonsDone)" : "—", "Lessons")
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 26, style: .continuous).fill(Color.auFill)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 26).strokeBorder(Color.auEdge, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                    .auLift()
                    .padding(.bottom, 18)

                    if !r.pro {
                        Button {
                            r.nav(.paywall)
                        } label: {
                            HStack(spacing: 16) {
                                AUIcon(
                                    kind: .star, size: 20,
                                    color: AUSceneArt.deepGreen
                                )
                                .frame(width: 44, height: 44)
                                .background(Circle().fill(Color.auAccent2))
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Aurel Pro")
                                        .font(.caprasimo(size: 18))
                                    Text("Chapters 2–4 · no free trial")
                                        .font(.figtree(.regular, size: 12.5))
                                        .opacity(0.85)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                HStack(spacing: 3) {
                                    Text("Continue")
                                        .font(.figtree(.bold, size: 13))
                                    AUIcon(kind: .chevron, size: 14, color: .auOkText)
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 28, style: .continuous).fill(
                                    Color.auOkBg)
                            )
                            .foregroundStyle(Color.auOkText)
                        }
                        .buttonStyle(.auTap)
                        .padding(.bottom, 20)
                    } else {
                        HStack(spacing: 14) {
                            AUIcon(kind: .check, size: 19, color: .auOkText)
                            Text("Subscribed — Chapters 2–4")
                                .font(.figtree(.semibold, size: 14))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 26, style: .continuous).fill(
                                Color.auOkBg)
                        )
                        .foregroundStyle(Color.auOkText)
                        .padding(.bottom, 20)
                    }

                    Text("Milestones")
                        .font(.figtree(.bold, size: 10.5))
                        .tracking(1.47)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.auTextSecondary)
                        .padding(.bottom, 12)

                    if !milestones.isEmpty {
                        VStack(spacing: 0) {
                            ForEach(Array(milestones.enumerated()), id: \.offset) { i, m in
                                HStack(alignment: .top, spacing: 13) {
                                    Group {
                                        if m.done {
                                            AUIcon(
                                                kind: .check, size: 13,
                                                color: AUSceneArt.onAccent2
                                            )
                                            .frame(width: 21, height: 21)
                                            .background(Circle().fill(Color.auAccent2))
                                        } else {
                                            Circle()
                                                .strokeBorder(
                                                    Color.auText.opacity(0.24),
                                                    style: StrokeStyle(
                                                        lineWidth: 1.5, dash: [4, 3])
                                                )
                                                .frame(width: 21, height: 21)
                                        }
                                    }
                                    .padding(.top, 1)
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(m.label)
                                            .font(.figtree(.semibold, size: 14.5))
                                            .auLine(14.5, 1.35)
                                            .foregroundStyle(
                                                m.done ? Color.auText : Color.auText.opacity(0.52))
                                        Text(m.when)
                                            .font(.figtree(.regular, size: 12))
                                            .foregroundStyle(Color.auTextTertiary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, 19)
                                .padding(.vertical, 15)
                                .overlay(alignment: .bottom) {
                                    if i < milestones.count - 1 {
                                        Divider().overlay(Color.auDivider)
                                    }
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 22, style: .continuous).fill(
                                Color.auFill)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 22).strokeBorder(
                                Color.auEdge, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .auLift()
                        .padding(.bottom, 22)
                    } else {
                        Text(
                            "Nothing yet. The first one arrives when you finish a lesson — they are sentences, not badges."
                        )
                        .font(.figtree(.regular, size: 13))
                        .auLine(13, 1.55)
                        .foregroundStyle(Color.auTextSecondary)
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .strokeBorder(
                                    Color.auText.opacity(0.16),
                                    style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
                        )
                        .padding(.bottom, 22)
                    }

                    // rows
                    VStack(spacing: 0) {
                        profileRow(
                            "Cedar Group",
                            // Craft overhaul G8: no fabricated rank — the board
                            // shows state, not an invented position.
                            r.boardOut ? "Off" : "On the board"
                        ) { r.nav(.leaderboard) }
                        profileRow("Subscription", r.pro ? "Subscribed" : "Free") {
                            r.nav(.paywall)
                        }
                        profileRow("Settings", "") { r.nav(.settings) }
                        profileRow("Help and contact", "", divider: false) {}
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous).fill(Color.auFill)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22).strokeBorder(Color.auEdge, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .auLift()
                }
                .padding(.horizontal, 24)
                .padding(.top, 70)
                .padding(.bottom, 130)
            }
        }
        .auScreenEntrance()
    }

    /// §3.19: milestones render only from real events — completed chapter
    /// lessons, the first finished lesson, streak runs — derived from
    /// LessonRecord/DayLog. Nothing done, no rows (the honest empty state).
    private var milestones: [(label: String, when: String, done: Bool)] {
        let r = env.router
        var rows: [(String, String, Bool)] = []

        // A first lesson really finished.
        if r.lessonsDone > 0 {
            rows.append(("A start is a start.", "The first lesson", true))
        }

        // Completed chapters, from real lesson records.
        let records = r.lessonRecords().filter { !$0.wasReview }
        let chapterMilestones: [(Int, String, String)] = [
            (0, "Greeted someone and given your name.", "Chapter one"),
            (1, "Spelled a name and given a number.", "Chapter two"),
            (2, "Said where you are from and what you do.", "Chapter three"),
        ]
        for (idx, label, when) in chapterMilestones
        where records.contains(where: { $0.chapterIdx == idx }) {
            rows.append((label, when, true))
        }

        // The seven-day run, from real streak history.
        let best = max(AppRouter.bestStreak(over: r.dayLogs()), r.streak)
        if best >= 7 {
            rows.append(("Seven days, unbroken.", "Streak", true))
        }

        return rows.map { (label: $0.0, when: $0.1, done: $0.2) }
    }

    /// §3.19: "joined today" / "joined 22 August" — the real profile start.
    private var joinedText: String {
        guard let start = env.router.profileStartDate() else { return "joined today" }
        let cal = Calendar.current
        let days = cal.dateComponents(
            [.day], from: cal.startOfDay(for: start), to: cal.startOfDay(for: Date())
        ).day ?? 0
        if days <= 0 { return "joined today" }
        let f = DateFormatter()
        f.dateFormat = "d MMMM"
        return "joined \(f.string(from: start))"
    }

    /// Craft overhaul G6: the profile identity derives from the real account —
    /// the email's local part when signed in, "Guest" otherwise.
    private var profileName: String {
        let email = env.router.email
        guard !email.isEmpty, let local = email.split(separator: "@").first, !local.isEmpty else {
            return "Guest"
        }
        return local.prefix(1).uppercased() + local.dropFirst()
    }

    private var profileInitial: String {
        String(profileName.prefix(1)).uppercased()
    }

    private func profileStat(_ value: String, _ label: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(value)
                .font(.figtree(.bold, size: 25))
                .monospacedDigit()
                .tracking(-0.5)
            Text(label.uppercased())
                .font(.figtree(.semibold, size: 10))
                .tracking(0.9)
                .foregroundStyle(Color.auTextTertiary)
                .padding(.top, 7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 20)
        .padding(.horizontal, 12)
    }

    private func profileRow(
        _ label: String, _ value: String, divider: Bool = true, action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(label)
                    .font(.figtree(.semibold, size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(value)
                    .font(.figtree(.regular, size: 13))
                    .foregroundStyle(Color.auTextTertiary)
                AUIcon(kind: .chevron, size: 16, color: .auText.opacity(0.35))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 17)
            .overlay(alignment: .bottom) {
                if divider { Divider().overlay(Color.auDivider) }
            }
        }
        .buttonStyle(.auTap)
    }
}

// MARK: Settings

struct SettingsView: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var confirmDelete = false

    var body: some View {
        let r = env.router

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Button {
                    r.leaveSettings()
                } label: {
                    AUIcon(kind: .back, size: 17)
                        .frame(width: 44, height: 44)
                        .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
                }
                .buttonStyle(.auTap)
                .accessibilityLabel("Back")
                .accessibilityIdentifier("au.settings.back")
                .padding(.bottom, 26)

                Text("Settings")
                    .font(.caprasimo(size: 29))
                    .tracking(-0.58)
                    .padding(.bottom, 26)

                sectionLabel("Daily rhythm")
                VStack(spacing: 0) {
                    switchRow("Daily reminder", "One, at 19:30", on: r.sw.reminder) {
                        r.toggleSw(\.reminder)
                    }
                    switchRow("Sound", "Soft and sparse", on: r.sw.sound) { r.toggleSw(\.sound) }
                    switchRow("Haptics", "On answer and completion", on: r.sw.haptics) {
                        r.toggleSw(\.haptics)
                    }
                    switchRow(
                        "Weekly summary", "Sunday evening, by email", on: r.sw.weekly,
                        divider: false
                    ) {
                        r.toggleSw(\.weekly)
                    }
                }
                .settingsCard()
                .padding(.bottom, 22)

                sectionLabel("Notifications")
                VStack(spacing: 0) {
                    switchRow(
                        "Dawn", "Today's lesson is ready, at \(r.remindAt)", on: r.notif.dawn
                    ) {
                        r.toggleNotif(\.dawn)
                    }
                    switchRow(
                        "Sundown", "Only when something is actually due", on: r.notif.sundown
                    ) {
                        r.toggleNotif(\.sundown)
                    }
                    switchRow(
                        "Milestones", "When you pass something worth naming", on: r.notif.milestone
                    ) { r.toggleNotif(\.milestone) }
                    switchRow(
                        "Cedar Group", "Standings and results — off by default", on: r.notif.cohort,
                        divider: false
                    ) { r.toggleNotif(\.cohort) }
                }
                .settingsCard()
                .padding(.bottom, 22)

                sectionLabel("Home Screen")
                HStack(spacing: 18) {
                    // the widget preview
                    WidgetPreview(streak: "\(max(r.streak, 0))")
                    VStack(alignment: .leading, spacing: 4) {
                        Text("The arc, on your Home Screen")
                            .font(.figtree(.semibold, size: 14.5))
                        Text(
                            "Long-press your Home Screen, then add the small Aurel widget. The sun moves as the day is finished."
                        )
                        .font(.figtree(.regular, size: 12.5))
                        .auLine(12.5, 1.5)
                        .foregroundStyle(Color.auTextSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous).fill(Color.auFill)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22).strokeBorder(Color.auEdge, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .auLift()
                .padding(.bottom, 22)

                sectionLabel("Comparison")
                Button {
                    r.boardOut.toggle()
                } label: {
                    HStack(spacing: 14) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Cedar Group")
                                .font(.figtree(.semibold, size: 15))
                            Text("Off hides the group everywhere. Nothing is lost.")
                                .font(.figtree(.regular, size: 12.5))
                                .foregroundStyle(Color.auTextSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        AuthoredSwitch(isOn: !r.boardOut)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .buttonStyle(.auTap)
                .accessibilityLabel("Cedar Group")
                .accessibilityAddTraits(!r.boardOut ? .isSelected : [])
                .settingsCard()
                .padding(.bottom, 22)

                sectionLabel("Reading")
                VStack(alignment: .leading, spacing: 14) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Text size")
                            .font(.figtree(.semibold, size: 15))
                        Spacer()
                        Text(typeLabel)
                            .font(.figtree(.regular, size: 13))
                            .foregroundStyle(Color.auAccent)
                    }
                    GeometryReader { geo in
                        let step = min(max(r.typeStep, 0), 4)
                        let travel = max(0, geo.size.width - 20)
                        let progress = CGFloat(step) / 4

                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.auText.opacity(0.12))
                                .frame(height: 4)
                                .padding(.horizontal, 10)
                            Capsule()
                                .fill(Color.auAccent)
                                .frame(width: 10 + travel * progress, height: 4)
                                .padding(.leading, 10)
                            Circle()
                                .fill(Color.auAccent)
                                .frame(width: 20, height: 20)
                                .shadow(color: Color.auAccent.opacity(0.20), radius: 4, y: 2)
                                .offset(x: travel * progress)
                                // Craft overhaul R5: the knob springs between
                                // steps instead of hard-snapping.
                                .animation(
                                    AUMotion.animation(AUMotion.snap, reduceMotion: reduceMotion),
                                    value: step
                                )
                            HStack(spacing: 0) {
                                ForEach(0..<5, id: \.self) { target in
                                    Button {
                                        AUFeedback.selection()
                                        r.setTypeStep(target)
                                    } label: {
                                        Color.clear
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .contentShape(Rectangle())
                                    }
                                    // Craft overhaul G17: a real pressed state
                                    // + haptic (was .plain, no feedback).
                                    .buttonStyle(.auTap)
                                    .accessibilityLabel(typeLabel(for: target))
                                    .accessibilityIdentifier("au.settings.type.\(target)")
                                }
                            }
                        }
                    }
                    // Craft overhaul G17: taller lane so each step target
                    // clears 44pt (was 30).
                    .frame(height: 44)
                    Text("Pleased to meet you.")
                        .font(.figtree(.regular, size: typePreview))
                    Text(
                        "Every screen follows this, and every screen has been checked at the largest size."
                    )
                    .font(.figtree(.regular, size: 12))
                    .auLine(12, 1.5)
                    .foregroundStyle(Color.auTextTertiary)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 28, style: .continuous).fill(Color.auFill)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28).strokeBorder(Color.auEdge, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .auLift()
                .padding(.bottom, 22)

                sectionLabel("Account")
                VStack(spacing: 0) {
                    accountRow("Subscription", r.pro ? "Subscribed" : "Free") { r.nav(.paywall) }
                    // Craft overhaul G9/G6: was a dead row showing a fabricated
                    // email — now shows the real account email or "Not signed in".
                    accountRow("Email", r.email.isEmpty ? "Not signed in" : r.email) {}
                    accountRow("Sign out", "", tint: .auAccentText) { r.nav(.welcome) }
                    accountRow("Delete account", "Permanent", tint: .auErr, divider: false) {
                        // Craft overhaul G5: was an immediate destructive nav
                        // with no confirmation (HIG violation).
                        confirmDelete = true
                    }
                }
                .settingsCard()
            }
            .padding(.horizontal, 24)
            .padding(.top, 70)
            .padding(.bottom, 34)
        }
        .background(Color.auBackground.ignoresSafeArea())
        .confirmationDialog(
            "Delete account permanently?",
            isPresented: $confirmDelete,
            titleVisibility: .visible
        ) {
            Button("Delete account", role: .destructive) {
                r.nav(.welcome)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Your local progress, streaks, and settings on this device will be erased. This cannot be undone.")
        }
        .auScreenEntrance()
    }

    private var typeLabel: String {
        ["Smaller", "Small", "Default", "Large", "Largest"][min(max(env.router.typeStep, 0), 4)]
    }
    private var typePreview: CGFloat {
        [12.5, 13.5, 14.5, 17, 20][min(max(env.router.typeStep, 0), 4)]
    }

    private func typeLabel(for step: Int) -> String {
        ["Smaller", "Small", "Default", "Large", "Largest"][min(max(step, 0), 4)]
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.figtree(.bold, size: 10.5))
            .tracking(1.47)
            .textCase(.uppercase)
            .foregroundStyle(Color.auTextSecondary)
            .padding(.bottom, 12)
    }

    private func switchRow(
        _ label: String, _ sub: String, on: Bool, divider: Bool = true,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.figtree(.semibold, size: 15))
                    Text(sub)
                        .font(.figtree(.regular, size: 12.5))
                        .foregroundStyle(Color.auTextSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                AuthoredSwitch(isOn: on)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .overlay(alignment: .bottom) {
                if divider { Divider().overlay(Color.auDivider) }
            }
        }
        .buttonStyle(.auTap)
        .accessibilityLabel(label)
        .accessibilityAddTraits(on ? .isSelected : [])
    }

    private func accountRow(
        _ label: String, _ value: String, tint: Color = .auText, divider: Bool = true,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(label)
                    .font(.figtree(.semibold, size: 15))
                    .foregroundStyle(tint)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(value)
                    .font(.figtree(.regular, size: 13))
                    .foregroundStyle(Color.auTextTertiary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 17)
            .overlay(alignment: .bottom) {
                if divider { Divider().overlay(Color.auDivider) }
            }
        }
        .buttonStyle(.auTap)
    }
}

private struct AuthoredSwitch: View {
    let isOn: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Capsule()
            .fill(isOn ? Color.auAccent : Color.auText.opacity(0.16))
            .frame(width: 50, height: 30)
            .overlay(alignment: isOn ? .trailing : .leading) {
                Circle()
                    .fill(Color.auBackground)
                    .frame(width: 24, height: 24)
                    .shadow(color: Color.auText.opacity(0.16), radius: 2, y: 1)
                    .padding(3)
            }
            // Craft overhaul R4: the knob slides + the track cross-fades
            // (was an instant snap).
            .animation(
                AUMotion.animation(AUMotion.snap, reduceMotion: reduceMotion),
                value: isOn
            )
            .accessibilityHidden(true)
    }
}

extension View {
    fileprivate func settingsCard() -> some View {
        self
            .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(Color.auFill))
            .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(Color.auEdge, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .auLift()
    }
}

/// The home-screen widget preview (settings, lines 1428–1439).
struct WidgetPreview: View {
    let streak: String

    var body: some View {
        ZStack {
            AUGradients.sky
            GeometryReader { geo in
                let sx = geo.size.width / 96
                let sy = geo.size.height / 96
                // arc
                Path { p in
                    p.move(to: CGPoint(x: 12, y: 58))
                    p.addQuadCurve(to: CGPoint(x: 84, y: 58), control: CGPoint(x: 48, y: 8))
                }
                .stroke(
                    Color.auText.opacity(0.16),
                    style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [2, 6])
                )
                .scaleEffect(x: sx, y: sy, anchor: .topLeading)
                // dunes
                Path { p in
                    p.move(to: CGPoint(x: 0, y: 62))
                    p.addQuadCurve(to: CGPoint(x: 48, y: 60), control: CGPoint(x: 24, y: 54))
                    p.addQuadCurve(to: CGPoint(x: 96, y: 56), control: CGPoint(x: 72, y: 66))
                    p.addLine(to: CGPoint(x: 96, y: 96))
                    p.addLine(to: CGPoint(x: 0, y: 96))
                    p.closeSubpath()
                }
                .fill(Color.auDune)
                .scaleEffect(x: sx, y: sy, anchor: .topLeading)
                Path { p in
                    p.move(to: CGPoint(x: 0, y: 74))
                    p.addQuadCurve(to: CGPoint(x: 54, y: 72), control: CGPoint(x: 28, y: 66))
                    p.addQuadCurve(to: CGPoint(x: 96, y: 70), control: CGPoint(x: 78, y: 78))
                    p.addLine(to: CGPoint(x: 96, y: 96))
                    p.addLine(to: CGPoint(x: 0, y: 96))
                    p.closeSubpath()
                }
                .fill(Color.auDune2)
                .scaleEffect(x: sx, y: sy, anchor: .topLeading)
                // sun
                Circle()
                    .fill(
                        RadialGradient(
                            stops: [
                                .init(color: Color(UIColor(hex: 0xfff1d4)), location: 0),
                                .init(color: Color(UIColor(hex: 0xf7c489)), location: 0.42),
                                .init(color: Color(UIColor(hex: 0xe08f4c)), location: 0.72),
                                .init(color: .clear, location: 0.80),
                            ],
                            center: UnitPoint(x: 0.5, y: 0.42), startRadius: 0, endRadius: 9
                        )
                    )
                    .frame(width: 18, height: 18)
                    .position(x: 0.48 * geo.size.width, y: 0.12 * geo.size.height)
                // streak text
                VStack(alignment: .leading, spacing: 2) {
                    Text(streak)
                        .font(.figtree(.bold, size: 15))
                        .monospacedDigit()
                    Text("Half done")
                        .font(.figtree(.bold, size: 7))
                        .tracking(0.98)
                        .textCase(.uppercase)
                        .opacity(0.7)
                }
                .foregroundStyle(Color.auDuneText)
                .position(x: 30, y: geo.size.height - 22)
            }
        }
        .frame(width: 96, height: 96)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .auLift()
    }
}

// MARK: Paywall

struct PaywallView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        let r = env.router
        ZStack {
            // dusk backdrop
            GeometryReader { geo in
                ZStack {
                    LinearGradient(
                        // Craft overhaul G24: dusk stops now come from
                        // AUSceneArt.paywallDuskDark (were 8 raw hexes).
                        stops: [
                            .init(color: AUSceneArt.paywallDuskDark[0], location: 0),
                            .init(color: AUSceneArt.paywallDuskDark[1], location: 0.24),
                            .init(color: AUSceneArt.paywallDuskDark[2], location: 0.46),
                            .init(color: AUSceneArt.paywallDuskDark[3], location: 0.62),
                            .init(color: AUSceneArt.paywallDuskDark[4], location: 0.72),
                            .init(color: AUSceneArt.paywallDuskDark[5], location: 0.80),
                            .init(color: AUSceneArt.paywallDuskDark[6], location: 0.88),
                            .init(color: AUSceneArt.paywallDuskDark[7], location: 1),
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                    AUStars()
                    RadialGradient(
                        stops: [
                            .init(
                                color: AUSceneArt.sunMid.opacity(0.56),
                                location: 0),
                            .init(
                                color: AUSceneArt.sunDeep.opacity(0.22),
                                location: 0.44),
                            .init(color: .clear, location: 0.74),
                        ],
                        center: UnitPoint(x: 0.66, y: 0.80), startRadius: 0,
                        endRadius: geo.size.width * 0.9
                    )
                    GeometryReader { duneGeo in
                        ZStack(alignment: .bottom) {
                            DuneLayer(
                                fill: Color(UIColor(hex: 0x33241a)), rim: .clear, rimWidth: 0,
                                path: "M0 62 Q86 30 168 54 Q244 76 312 44 Q360 26 402 52")
                            DuneLayer(
                                fill: Color(UIColor(hex: 0x1a1310)), rim: .clear, rimWidth: 0,
                                path: "M0 104 Q96 74 184 96 Q258 114 326 88 Q368 72 402 96")
                        }
                        .frame(height: max(1, duneGeo.size.height * 0.22))
                    }
                    GrainOverlay()
                    LinearGradient(
                        stops: [
                            .init(
                                color: AUSceneArt.onAccent2Deep.opacity(0.6),
                                location: 0),
                            .init(
                                color: AUSceneArt.onAccent2Deep.opacity(0.46),
                                location: 0.38),
                            .init(
                                color: AUSceneArt.onAccent2Deep.opacity(0.5),
                                location: 0.72),
                            .init(color: Color.auBackground, location: 1),
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                }
            }
            .frame(height: 430)
            .frame(maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)

            // Craft overhaul G1: the whole paywall column scrolls now — the
            // old fixed VStack clipped content on small devices / large type.
            ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    Button {
                        r.nav(.home)
                    } label: {
                        AUIcon(
                            kind: .close, size: 17,
                            color: AUSceneArt.duskCream
                        )
                        .frame(width: 44, height: 44)
                        .background(
                            Circle().fill(AUSceneArt.duskCream.opacity(0.2))
                        )
                    }
                    .buttonStyle(.auTap)
                    .accessibilityLabel("Close")
                }
                .padding(.top, 70)
                .padding(.bottom, 44)

                Text("Aurel Pro")
                    .font(.figtree(.bold, size: 10.5))
                    .tracking(2.1)
                    .textCase(.uppercase)
                    .foregroundStyle(AUSceneArt.sunMid)
                    .padding(.bottom, 10)

                Text("Continue with\nChapters 2–4.")
                    .font(.caprasimo(size: 36))
                    .tracking(-0.9)
                    .auHeadLine(36, 1.06)
                    .foregroundStyle(AUSceneArt.duskCream)
                    .padding(.bottom, 12)

                Text(
                    "Chapters 2 through 4, production-ready today, plus unlimited speaking and the review engine that decides when to bring a word back. A2 and beyond arrive as they’re written."
                )
                .font(.figtree(.regular, size: 14.5))
                .auLine(14.5, 1.6)
                .foregroundStyle(AUSceneArt.duskCream.opacity(0.75))
                .frame(maxWidth: 290, alignment: .leading)
                .padding(.bottom, 26)

                // plans
                VStack(spacing: 11) {
                    // Craft overhaul G2: honest price copy until StoreKit is
                    // wired — no fabricated amounts, no "App Store price" jargon.
                    planRow(
                        id: "annual", name: "Annual", sub: "Billed once a year",
                        price: "Yearly", badge: "Best value")
                    planRow(
                        id: "monthly", name: "Monthly", sub: "Cancel any time",
                        price: "Monthly", badge: "")
                }
                .padding(.bottom, 20)

                VStack(alignment: .leading, spacing: 10) {
                    ForEach(
                        [
                            "Chapters 2–4, production-ready today — Checkpoint Review 1 included",
                            "Unlimited speaking sessions, scored on clarity not accent",
                            "Spaced review that decides when a word returns",
                            "Every recording and illustration, once production replaces the placeholders",
                        ], id: \.self
                    ) { f in
                        HStack(alignment: .top, spacing: 11) {
                            AUIcon(kind: .check, size: 16, color: .auAccent2)
                                .padding(.top, 2)
                            Text(f)
                                .font(.figtree(.regular, size: 14))
                                .auLine(14, 1.45)
                        }
                    }
                }
                .padding(.bottom, 24)

                Spacer(minLength: 12)

                APillButton(title: r.hasAccount ? "Subscribe" : "Create account and subscribe") {
                    r.startSubscribe()
                }
                .padding(.bottom, 6)

                Button {
                    r.restorePurchase()
                } label: {
                    Text("Restore purchase")
                        .font(.figtree(.semibold, size: 13))
                        .foregroundStyle(Color.auAccentText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.auTap)
                .padding(.bottom, 10)

                Text(
                    "No free trial — Chapter 1 is the free experience. Price, billing period, and renewal terms are set by the App Store at checkout. Cancel any time in Settings."
                )
                .font(.figtree(.regular, size: 11.5))
                .auLine(11.5, 1.5)
                .foregroundStyle(Color.auTextTertiary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 14)

                // Craft overhaul G3: the legal row subscriptions require.
                HStack(spacing: 22) {
                    Link(destination: URL(string: "https://aurel.app/terms")!) {
                        Text("Terms of Use")
                    }
                    Link(destination: URL(string: "https://aurel.app/privacy")!) {
                        Text("Privacy Policy")
                    }
                }
                .font(.figtree(.semibold, size: 12))
                .foregroundStyle(Color.auAccentText)
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 34)
            }
        }
        .background(Color.auBackground.ignoresSafeArea())
        .auScreenEntrance()
    }

    private func planRow(id: String, name: String, sub: String, price: String, badge: String)
        -> some View
    {
        let on = env.router.plan == id
        return Button {
            AUFeedback.selection()
            env.router.plan = id
        } label: {
            HStack(spacing: 14) {
                Circle()
                    .strokeBorder(on ? Color.auAccent : Color.auText.opacity(0.28), lineWidth: 1.5)
                    .frame(width: 22, height: 22)
                    .overlay {
                        if on {
                            Circle().fill(Color.auAccent).frame(width: 11, height: 11)
                        }
                    }
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(name)
                            .font(.caprasimo(size: 18))
                        if !badge.isEmpty {
                            Text(badge)
                                .font(.figtree(.regular, size: 10))
                                .tracking(0.4)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(Color.auOkBg))
                                .foregroundStyle(Color.auOkQuiet)
                        }
                    }
                    Text(sub)
                        .font(.figtree(.regular, size: 12.5))
                        .foregroundStyle(Color.auTextSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Text(price)
                    .font(.figtree(.bold, size: 14.5))
                    .foregroundStyle(Color.auText.opacity(0.70))
            }
            .padding(.horizontal, 19)
            .padding(.vertical, 17)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.auFill)
                    if on {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.auAccent.opacity(0.18), Color.auAccent.opacity(0.08),
                                    ],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            )
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .strokeBorder(Color.auAccent.opacity(0.70), lineWidth: 1.5)
                    } else {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .strokeBorder(Color.auEdge, lineWidth: 1)
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .auShimmerBorder(radius: 24, isActive: on && id == "annual")
            .auLift()
            .accessibilityAddTraits(on ? .isSelected : [])
        }
        .buttonStyle(.auTap)
    }
}

// MARK: Subscribe Account (Screen 20)

struct SubscribeAccountView: View {
    @Environment(AppEnvironment.self) private var env

    private var formValid: Bool {
        env.router.email.range(of: #".+@.+\..+"#, options: .regularExpression) != nil
            && env.router.pass.count >= 6
    }

    var body: some View {
        let r = env.router
        ZStack {
            Color.auBackground.ignoresSafeArea()
            AUPaper().ignoresSafeArea()

            // Craft overhaul G4: the old fixed VStack let the keyboard cover
            // the password field and the CTA — now it scrolls.
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    AUHeader(kind: .back) { r.nav(.paywall) }
                        .padding(.horizontal, -24)
                        .padding(.bottom, 38)

                    AUHeading(text: "Create your account.", size: 33, lineHeight: 1.12, tracking: -0.66)
                        .padding(.bottom, 10)

                    AUParagraph(
                        text:
                            "Needed to subscribe, and to sync or restore your purchase. Your Chapter 1 progress carries over automatically.",
                        size: 14, lineHeight: 1.55, color: Color.auTextSecondary
                    )
                    .padding(.bottom, 30)

                    if !r.loginErr.isEmpty {
                        // Craft overhaul G21: authored entrance, not a hard cut.
                        AUBanner(text: r.loginErr, tone: .error)
                            .padding(.bottom, 16)
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email")
                                .font(.figtree(.semibold, size: 12))
                                .foregroundStyle(Color.auTextSecondary)
                            TextField(
                                "you@example.com",
                                text: Binding(
                                    get: { r.email },
                                    set: { r.setEmail($0) }
                                )
                            )
                            .font(.figtree(.medium, size: 15))
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .submitLabel(.next)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding(.horizontal, 18)
                            .frame(minHeight: 54)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(Color.auFill)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .strokeBorder(Color.auEdge, lineWidth: 1)
                            )
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password")
                                .font(.figtree(.semibold, size: 12))
                                .foregroundStyle(Color.auTextSecondary)
                            SecureField(
                                "••••••••",
                                text: Binding(
                                    get: { r.pass },
                                    set: { r.setPass($0) }
                                )
                            )
                            .font(.figtree(.medium, size: 15))
                            .textContentType(.newPassword)
                            .submitLabel(.go)
                            .onSubmit { if formValid { r.createAccountAndSubscribe() } }
                            .padding(.horizontal, 18)
                            .frame(minHeight: 54)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(Color.auFill)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .strokeBorder(Color.auEdge, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.bottom, 20)

                    Spacer(minLength: 24)

                    // Craft overhaul G22: disabled until the form is valid.
                    APillButton(title: "Create account and subscribe", disabled: !formValid) {
                        r.createAccountAndSubscribe()
                    }
                    .padding(.bottom, 12)

                    Text(
                        "Price, billing period, and renewal terms are set by the App Store at checkout. No free trial — Chapter 1 is the free experience."
                    )
                    .font(.figtree(.regular, size: 11.5))
                    .auLine(11.5, 1.5)
                    .foregroundStyle(Color.auTextTertiary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .auScreenEntrance()
    }
}
