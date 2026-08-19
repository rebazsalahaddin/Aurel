import SwiftUI

// MARK: - Progress · Profile · Settings · Paywall
//
// Ported from Aurel.dc.html lines 1275–1515 (+ skillRows, ladder, milestones,
// plans, proFeatures — lines 2582–2791).

// MARK: Progress

struct ProgressView: View {
    @Environment(AppEnvironment.self) private var env

    private struct Skill: Identifiable {
        let id = UUID()
        let label: String
        let state: Int
        let items: Int
        let meta: String
        let weakest: Bool
    }

    private let mastery = ["Not started", "Seen", "Practised", "Familiar", "Strong", "Mastered"]
    private let mfill: [Double] = [0.03, 0.1, 0.3, 0.52, 0.78, 1]

    private var skills: [Skill] {
        let r = env.router
        let raw: [(String, Int, Int)]
        if r.baseLessons > 0 {
            raw = [("Vocabulary", 142, 4), ("Grammar", 96, 3), ("Listening", 38, 2), ("Conversation", 24, 2), ("Speaking", 4, 1)]
        } else {
            raw = [
                ("Vocabulary", r.lessonsDone * 8, r.lessonsDone > 0 ? 2 : 1),
                ("Grammar", r.lessonsDone * 4, r.lessonsDone > 0 ? 2 : 1),
                ("Listening", r.lessonsDone * 3, r.lessonsDone > 0 ? 2 : 1),
                ("Conversation", 0, 0),
                ("Speaking", 0, 0),
            ]
        }
        let sorted = raw.sorted { ($0.2, $0.1) < ($1.2, $1.1) }
        return sorted.enumerated().map { i, k in
            Skill(
                label: k.0,
                state: k.2,
                items: k.1,
                meta: i == 0
                    ? (k.2 == 0 ? "Not started — worth ten minutes" : "Weakest — worth ten minutes")
                    : (k.1 == 0 ? "Nothing recorded yet" : "\(k.1) items \(mastery[k.2].lowercased())"),
                weakest: i == 0
            )
        }
    }

    var body: some View {
        let r = env.router
        ZStack(alignment: .bottom) {
            Color.auBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Since 15 August")
                            .font(.figtree(.bold, size: 10.5))
                            .tracking(1.68)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auAccentText)
                        Spacer()
                        Text(r.baseLessons > 0 ? "Last practised Thursday" : "Nothing practised yet")
                            .font(.figtree(.regular, size: 11.5))
                            .foregroundStyle(Color.auText.opacity(0.55))
                    }
                    .padding(.bottom, 2)

                    Text("Progress")
                        .font(.caprasimo(size: 29))
                        .tracking(-0.58)
                        .padding(.bottom, 22)

                    // skills
                    VStack(spacing: 2) {
                        ForEach(skills) { k in
                            Button {
                                if k.label == "Speaking" { r.nav(.speak) }
                                else if k.label == "Conversation" { r.nav(.scene) }
                                else { r.nav(.review) }
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
                                        .foregroundStyle(Color.auText.opacity(0.50))
                                        .padding(.top, 8)
                                }
                                .padding(.vertical, 16)
                            }
                            .buttonStyle(.auTap)
                            .accessibilityLabel("\(k.label): \(mastery[k.state]), \(k.items) items")
                            .overlay(alignment: .bottom) { Divider().overlay(Color.auDivider) }
                        }
                    }
                    .padding(.bottom, 18)

                    APillButton(title: weakestCta) {
                        if let w = skills.first, w.label == "Speaking" { r.nav(.speak) }
                        else { r.goCourse(min(pathAt, 3)) }
                    }
                    .padding(.bottom, 26)

                    // totals
                    HStack(spacing: 0) {
                        totalTile(value: "\(wordsTotal)", label: "Words retained")
                        Rectangle().fill(Color.auDivider).frame(width: 1).padding(.vertical, 2)
                        totalTile(value: "\(minsTotal)", label: "Minutes total")
                    }
                    .padding(.bottom, 26)

                    // 8-week chart
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Time practised, last 8 weeks")
                            .font(.figtree(.regular, size: 11))
                            .tracking(1.32)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auText.opacity(0.45))
                            .padding(.bottom, 20)

                        HStack(alignment: .bottom, spacing: 8) {
                            ForEach(Array(bars.enumerated()), id: \.offset) { i, h in
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(barColor(i, h))
                                    .frame(height: CGFloat(h))
                                    .frame(maxHeight: 96, alignment: .bottom)
                                    .modifier(GrowBar(delay: Double(i) * 0.06))
                            }
                        }
                        .frame(height: 96)

                        HStack {
                            Text("Jun")
                                .font(.figtree(.regular, size: 10))
                                .foregroundStyle(Color.auText.opacity(0.40))
                            Spacer()
                            Text("Today")
                                .font(.figtree(.regular, size: 10))
                                .foregroundStyle(Color.auText.opacity(0.40))
                        }
                        .padding(.top, 9)

                        if r.baseLessons == 0 {
                            Text("Eight weeks from now this will say something.")
                                .font(.figtree(.regular, size: 13.5))
                                .lineSpacing(13.5 * 0.55)
                                .foregroundStyle(Color.auText.opacity(0.48))
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
                            .foregroundStyle(Color.auText.opacity(0.50))
                            .padding(.bottom, 6)

                        ForEach(Array([
                            ("A1", "Foundation · 12 chapters", "Here"),
                            ("A2", "Elementary", "Not written yet"),
                            ("B1", "Intermediate", "Not written yet"),
                            ("B2", "Upper intermediate", "Not written yet"),
                            ("C1", "Advanced", "Not written yet"),
                        ].enumerated()), id: \.offset) { i, l in
                            HStack(spacing: 14) {
                                Text(l.0)
                                    .font(.caprasimo(size: 18))
                                    .frame(width: 34, alignment: .leading)
                                    .foregroundStyle(l.2 == "Here" ? Color.auAccent : Color.auText.opacity(0.30))
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
                            .overlay(alignment: .bottom) { if i < 4 { Divider().overlay(Color.auDivider) } }
                        }
                    }
                    .padding(.vertical, 24)
                    .overlay(alignment: .top) { Divider().overlay(Color.auDivider) }
                }
                .padding(.horizontal, 24)
                .padding(.top, 70)
                .padding(.bottom, 130)
            }

            AUTabBar(current: .progress)
                .padding(.horizontal, 14)
                .padding(.bottom, 4)
        }
        .auScreenEntrance()
    }

    private var pathAt: Int {
        let r = env.router
        return r.basePos + (r.lessonsDone - r.baseLessons)
    }

    private var wordsTotal: Int {
        let r = env.router
        return r.baseLessons > 0 ? 412 + (r.lessonsDone - r.baseLessons) * 12 : r.lessonsDone * 12
    }

    private var minsTotal: Int {
        let r = env.router
        return r.baseLessons > 0 ? 268 + (r.lessonsDone - r.baseLessons) * 6 : r.lessonsDone * 6
    }

    private var weakestCta: String {
        let r = env.router
        if let w = skills.first { return "Practise \(w.label.lowercased()) — \(r.commit) minutes" }
        return "Start a lesson"
    }

    private var bars: [Int] {
        let r = env.router
        return r.baseLessons > 0
            ? [34, 52, 41, 68, 57, 74, 62, 88]
            : [4, 4, 4, 4, 4, 4, 4, min(88, max(8, (r.lessonsDone - r.baseLessons) * 22))]
    }

    private func barColor(_ i: Int, _ h: Int) -> Color {
        let r = env.router
        if r.baseLessons > 0 { return i == 7 ? .auAccent : Color.auAccentRamp(300) }
        return i == 7 ? .auAccent : Color.auText.opacity(0.11)
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
                .foregroundStyle(Color.auText.opacity(0.50))
                .padding(.top, 9)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
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
                        Text("M")
                            .font(.caprasimo(size: 30))
                            .frame(width: 76, height: 76)
                            .background(Circle().fill(Color.auAccent))
                            .foregroundStyle(Color.auBackground)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Maya Aldrin")
                                .font(.caprasimo(size: 26))
                                .tracking(-0.52)
                            Text("A1 · Foundation — joined today")
                                .font(.figtree(.regular, size: 13))
                                .foregroundStyle(Color.auText.opacity(0.52))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Button {
                            r.nav(.settings)
                        } label: {
                            AUIcon(kind: .gear, size: 17)
                                .frame(width: 44, height: 44)
                                .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
                        }
                        .buttonStyle(.auTap)
                        .accessibilityLabel("Edit profile")
                    }
                    .padding(.bottom, 28)

                    // stats
                    HStack(spacing: 0) {
                        profileStat("\(max(r.streak, 0))", "Streak")
                        Rectangle().fill(Color.auEdge).frame(width: 1)
                        profileStat("\(r.lessonsDone * 12)", "Words")
                        Rectangle().fill(Color.auEdge).frame(width: 1)
                        profileStat("\(r.lessonsDone)", "Lessons")
                    }
                    .background(RoundedRectangle(cornerRadius: 26, style: .continuous).fill(Color.auFill))
                    .overlay(RoundedRectangle(cornerRadius: 26).strokeBorder(Color.auEdge, lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                    .padding(.bottom, 18)

                    if !r.pro {
                        Button {
                            r.nav(.paywall)
                        } label: {
                            HStack(spacing: 16) {
                                AUIcon(kind: .sparkle, size: 20, color: Color(red: 0.133, green: 0.153, blue: 0.102))
                                    .frame(width: 44, height: 44)
                                    .background(Circle().fill(Color.auAccent2))
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Aurel Pro")
                                        .font(.caprasimo(size: 18))
                                    Text("Seven days free, then unlimited")
                                        .font(.figtree(.regular, size: 12.5))
                                        .opacity(0.85)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                HStack(spacing: 3) {
                                    Text("Try free")
                                        .font(.figtree(.bold, size: 13))
                                    AUIcon(kind: .arrow, size: 14, color: .auOkText)
                                }
                            }
                            .padding(20)
                            .background(RoundedRectangle(cornerRadius: 28, style: .continuous).fill(Color.auOkBg))
                            .foregroundStyle(Color.auOkText)
                        }
                        .buttonStyle(.auTap)
                        .padding(.bottom, 20)
                    } else {
                        HStack(spacing: 14) {
                            AUIcon(kind: .check, size: 19, color: .auOkText)
                            Text("Pro — trial ends 22 August")
                                .font(.figtree(.semibold, size: 14))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                        .background(RoundedRectangle(cornerRadius: 26, style: .continuous).fill(Color.auOkBg))
                        .foregroundStyle(Color.auOkText)
                        .padding(.bottom, 20)
                    }

                    Text("Milestones")
                        .font(.figtree(.bold, size: 10.5))
                        .tracking(1.47)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.auText.opacity(0.50))
                        .padding(.bottom, 12)

                    if r.lessonsDone > 0 {
                        VStack(spacing: 0) {
                            ForEach(Array(milestones.enumerated()), id: \.offset) { i, m in
                                HStack(alignment: .top, spacing: 13) {
                                    Group {
                                        if m.done {
                                            AUIcon(kind: .check, size: 13, color: Color(red: 0.984, green: 0.980, blue: 0.961))
                                                .frame(width: 21, height: 21)
                                                .background(Circle().fill(Color.auAccent2))
                                        } else {
                                            Circle()
                                                .strokeBorder(Color.auText.opacity(0.24), style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
                                                .frame(width: 21, height: 21)
                                        }
                                    }
                                    .padding(.top, 1)
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(m.label)
                                            .font(.figtree(.semibold, size: 14.5))
                                            .lineSpacing(14.5 * 0.35)
                                            .foregroundStyle(m.done ? Color.auText : Color.auText.opacity(0.52))
                                        Text(m.when)
                                            .font(.figtree(.regular, size: 12))
                                            .foregroundStyle(Color.auText.opacity(0.48))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, 19)
                                .padding(.vertical, 15)
                                .overlay(alignment: .bottom) { if i < milestones.count - 1 { Divider().overlay(Color.auDivider) } }
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(Color.auFill))
                        .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(Color.auEdge, lineWidth: 1))
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .padding(.bottom, 22)
                    } else {
                        Text("Nothing yet. The first one arrives when you finish a lesson — they are sentences, not badges.")
                            .font(.figtree(.regular, size: 13))
                            .lineSpacing(13 * 0.55)
                            .foregroundStyle(Color.auText.opacity(0.50))
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .strokeBorder(Color.auText.opacity(0.16), style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
                            )
                            .padding(.bottom, 22)
                    }

                    // rows
                    VStack(spacing: 0) {
                        profileRow("Cedar Group", r.boardOut ? "Off" : "Rank \(r.streak > 1 ? 6 : 30) of 30") { r.nav(.leaderboard) }
                        profileRow("Subscription", r.pro ? "Pro trial" : "Free") { r.nav(.paywall) }
                        profileRow("Settings", "") { r.nav(.settings) }
                        profileRow("Help and contact", "") {}
                    }
                    .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(Color.auFill))
                    .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(Color.auEdge, lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                }
                .padding(.horizontal, 24)
                .padding(.top, 70)
                .padding(.bottom, 130)
            }

            AUTabBar(current: .profile)
                .padding(.horizontal, 14)
                .padding(.bottom, 4)
        }
        .auScreenEntrance()
    }

    private var milestones: [(label: String, when: String, done: Bool)] {
        let r = env.router
        let far = r.baseLessons > 0
        var rows: [(String, String, Bool)] = [
            ("Greeted someone and given your name.", "Chapter one", far),
            ("Spelled a name and given a number.", "Chapter two", far),
            ("Said where you are from and what you do.", "Chapter three", false),
            ("Seven days, unbroken.", far ? "Streak" : "Seven complete arcs", far && r.streak >= 7),
            ("Checkpoint Review 1 passed.", "Chapter four — not yet written", false),
        ]
        if !far { rows.insert(("A start is a start.", "Today", r.lessonsDone > 0), at: 0) }
        return rows.map { (label: $0.0, when: $0.1, done: $0.2) }
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
                .foregroundStyle(Color.auText.opacity(0.45))
                .padding(.top, 7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 20)
        .padding(.horizontal, 12)
    }

    private func profileRow(_ label: String, _ value: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(label)
                    .font(.figtree(.semibold, size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(value)
                    .font(.figtree(.regular, size: 13))
                    .foregroundStyle(Color.auText.opacity(0.45))
                AUIcon(kind: .arrow, size: 16, color: .auText.opacity(0.35))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 17)
            .overlay(alignment: .bottom) { Divider().overlay(Color.auDivider) }
        }
        .buttonStyle(.auTap)
    }
}

// MARK: Settings

struct SettingsView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        let r = env.router

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Button {
                    r.nav(.profile)
                } label: {
                    AUIcon(kind: .back, size: 17)
                        .frame(width: 44, height: 44)
                        .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
                }
                .buttonStyle(.auTap)
                .accessibilityLabel("Back")
                .padding(.bottom, 26)

                Text("Settings")
                    .font(.caprasimo(size: 29))
                    .tracking(-0.58)
                    .padding(.bottom, 26)

                sectionLabel("Daily rhythm")
                VStack(spacing: 0) {
                    switchRow("Daily reminder", "One, at 19:30", on: r.sw.reminder) { r.toggleSw(\.reminder) }
                    switchRow("Sound", "Soft and sparse", on: r.sw.sound) { r.toggleSw(\.sound) }
                    switchRow("Haptics", "On answer and completion", on: r.sw.haptics) { r.toggleSw(\.haptics) }
                    switchRow("Weekly summary", "Sunday evening, by email", on: r.sw.weekly) { r.toggleSw(\.weekly) }
                }
                .settingsCard()
                .padding(.bottom, 22)

                sectionLabel("Notifications")
                VStack(spacing: 0) {
                    switchRow("Dawn nudge", "Before your lesson time", on: r.notif.dawn) { r.toggleNotif(\.dawn) }
                    switchRow("Sundown catch-up", "The words due back today", on: r.notif.sundown) { r.toggleNotif(\.sundown) }
                    switchRow("Milestones", "When you pass something worth naming", on: r.notif.milestone) { r.toggleNotif(\.milestone) }
                    switchRow("Cedar Group", "Standings and results — off by default", on: r.notif.cohort) { r.toggleNotif(\.cohort) }
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
                        Text("Long-press your Home Screen, then add the small Aurel widget. The sun moves as the day is finished.")
                            .font(.figtree(.regular, size: 12.5))
                            .lineSpacing(12.5 * 0.5)
                            .foregroundStyle(Color.auText.opacity(0.50))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(Color.auFill))
                .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(Color.auEdge, lineWidth: 1))
                .padding(.bottom, 22)

                sectionLabel("Comparison")
                HStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Cedar Group")
                            .font(.figtree(.semibold, size: 15))
                        Text("Off hides the group everywhere. Nothing is lost.")
                            .font(.figtree(.regular, size: 12.5))
                            .foregroundStyle(Color.auText.opacity(0.50))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Toggle("", isOn: Binding(
                        get: { !r.boardOut },
                        set: { r.boardOut = !$0 }
                    ))
                    .labelsHidden()
                    .tint(.auAccent)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
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
                    // segmented text-size control (5 steps)
                    HStack(spacing: 6) {
                        ForEach(0..<5, id: \.self) { step in
                            Button {
                                r.setTypeStep(step)
                            } label: {
                                Text("\(step + 1)")
                                    .font(.figtree(.semibold, size: 11))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule().fill(r.typeStep == step ? Color.auAccent : Color.auText.opacity(0.08))
                                    )
                                    .foregroundStyle(r.typeStep == step ? Color.auBackground : Color.auText.opacity(0.5))
                            }
                            .buttonStyle(.auTap)
                        }
                    }
                    Text("Pleased to meet you.")
                        .font(.figtree(.regular, size: typePreview))
                    Text("Every screen follows this, and every screen has been checked at the largest size.")
                        .font(.figtree(.regular, size: 12))
                        .lineSpacing(12 * 0.5)
                        .foregroundStyle(Color.auText.opacity(0.45))
                }
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 28, style: .continuous).fill(Color.auFill))
                .overlay(RoundedRectangle(cornerRadius: 28).strokeBorder(Color.auEdge, lineWidth: 1))
                .padding(.bottom, 22)

                sectionLabel("Account")
                VStack(spacing: 0) {
                    accountRow("Subscription", r.pro ? "Pro trial" : "Free") { r.nav(.paywall) }
                    accountRow("Email", "maya@aldrin.co") {}
                    accountRow("Sign out", "", tint: .auAccentText) { r.nav(.welcome) }
                    accountRow("Delete account", "Permanent", tint: .auErr) { r.nav(.welcome) }
                }
                .settingsCard()
            }
            .padding(.horizontal, 24)
            .padding(.top, 70)
            .padding(.bottom, 34)
        }
        .background(Color.auBackground.ignoresSafeArea())
        .auScreenEntrance()
    }

    private var typeLabel: String { ["Smaller", "Small", "Default", "Large", "Largest"][min(max(env.router.typeStep, 0), 4)] }
    private var typePreview: CGFloat { [12.5, 13.5, 14.5, 17, 20][min(max(env.router.typeStep, 0), 4)] }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.figtree(.bold, size: 10.5))
            .tracking(1.47)
            .textCase(.uppercase)
            .foregroundStyle(Color.auText.opacity(0.50))
            .padding(.bottom, 12)
    }

    private func switchRow(_ label: String, _ sub: String, on: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.figtree(.semibold, size: 15))
                    Text(sub)
                        .font(.figtree(.regular, size: 12.5))
                        .foregroundStyle(Color.auText.opacity(0.50))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Toggle("", isOn: .constant(on))
                    .labelsHidden()
                    .tint(.auAccent)
                    .allowsHitTesting(false)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .overlay(alignment: .bottom) { Divider().overlay(Color.auDivider) }
        }
        .buttonStyle(.auTap)
        .accessibilityLabel(label)
        .accessibilityAddTraits(on ? .isSelected : [])
    }

    private func accountRow(_ label: String, _ value: String, tint: Color = .auText, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(label)
                    .font(.figtree(.semibold, size: 15))
                    .foregroundStyle(tint)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(value)
                    .font(.figtree(.regular, size: 13))
                    .foregroundStyle(Color.auText.opacity(0.45))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 17)
            .overlay(alignment: .bottom) { Divider().overlay(Color.auDivider) }
        }
        .buttonStyle(.auTap)
    }
}

private extension View {
    func settingsCard() -> some View {
        self
            .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(Color.auFill))
            .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(Color.auEdge, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

/// The home-screen widget preview (settings, lines 1428–1439).
struct WidgetPreview: View {
    let streak: String

    var body: some View {
        ZStack {
            AUGradients.sky
            GeometryReader { geo in
                let sx = geo.size.width / 96, sy = geo.size.height / 96
                // arc
                Path { p in
                    p.move(to: CGPoint(x: 12, y: 58))
                    p.addQuadCurve(to: CGPoint(x: 84, y: 58), control: CGPoint(x: 48, y: 8))
                }
                .stroke(Color.auText.opacity(0.16), style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [2, 6]))
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
                        stops: [
                            .init(color: Color(UIColor(hex: 0x16131a)), location: 0),
                            .init(color: Color(UIColor(hex: 0x20191f)), location: 0.24),
                            .init(color: Color(UIColor(hex: 0x2e2226)), location: 0.46),
                            .init(color: Color(UIColor(hex: 0x452a1f)), location: 0.62),
                            .init(color: Color(UIColor(hex: 0x7a431f)), location: 0.72),
                            .init(color: Color(UIColor(hex: 0xb0602e)), location: 0.80),
                            .init(color: Color(UIColor(hex: 0xc67139)), location: 0.88),
                            .init(color: Color(UIColor(hex: 0x7d431f)), location: 1),
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                    AUStars()
                    RadialGradient(
                        stops: [
                            .init(color: Color(red: 0.886, green: 0.573, blue: 0.337).opacity(0.56), location: 0),
                            .init(color: Color(red: 0.776, green: 0.443, blue: 0.224).opacity(0.22), location: 0.44),
                            .init(color: .clear, location: 0.74),
                        ],
                        center: UnitPoint(x: 0.66, y: 0.80), startRadius: 0, endRadius: geo.size.width * 0.9
                    )
                    GeometryReader { duneGeo in
                        ZStack(alignment: .bottom) {
                            DuneLayer(fill: Color(UIColor(hex: 0x33241a)), rim: .clear, rimWidth: 0, path: "M0 62 Q86 30 168 54 Q244 76 312 44 Q360 26 402 52")
                            DuneLayer(fill: Color(UIColor(hex: 0x1a1310)), rim: .clear, rimWidth: 0, path: "M0 104 Q96 74 184 96 Q258 114 326 88 Q368 72 402 96")
                        }
                        .frame(height: max(1, duneGeo.size.height * 0.22))
                    }
                    GrainOverlay()
                    LinearGradient(
                        stops: [
                            .init(color: Color(red: 0.071, green: 0.059, blue: 0.051).opacity(0.6), location: 0),
                            .init(color: Color(red: 0.071, green: 0.059, blue: 0.051).opacity(0.46), location: 0.38),
                            .init(color: Color(red: 0.071, green: 0.059, blue: 0.051).opacity(0.5), location: 0.72),
                            .init(color: Color.auBackground, location: 1),
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                }
            }
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    Button {
                        r.nav(.home)
                    } label: {
                        AUIcon(kind: .close, size: 17, color: Color(red: 0.969, green: 0.937, blue: 0.886))
                            .frame(width: 44, height: 44)
                            .background(Circle().fill(Color(red: 0.969, green: 0.937, blue: 0.886).opacity(0.2)))
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
                    .foregroundStyle(Color(UIColor(hex: 0xf0a877)))
                    .padding(.bottom, 10)

                Text("The whole\nladder, open.")
                    .font(.caprasimo(size: 36))
                    .tracking(-0.9)
                    .lineSpacing(36 * 0.06)
                    .foregroundStyle(Color(red: 0.969, green: 0.937, blue: 0.886))
                    .padding(.bottom, 12)

                Text("Twenty-four chapters, unlimited speaking, and the review engine that decides when to bring a word back.")
                    .font(.figtree(.regular, size: 14.5))
                    .lineSpacing(14.5 * 0.6)
                    .foregroundStyle(Color(red: 0.969, green: 0.937, blue: 0.886).opacity(0.75))
                    .frame(maxWidth: 290, alignment: .leading)
                    .padding(.bottom, 26)

                // plans
                VStack(spacing: 11) {
                    planRow(id: "annual", name: "Annual", sub: "£5.00 a month, billed yearly", price: "£59.99", badge: "Save 44%")
                    planRow(id: "monthly", name: "Monthly", sub: "Cancel any time", price: "£8.99", badge: "")
                }
                .padding(.bottom, 20)

                VStack(alignment: .leading, spacing: 10) {
                    ForEach([
                        "All twelve A1 chapters — 42 lessons · A2 upward arrives with the adaptation guide",
                        "Unlimited speaking sessions, scored on clarity not accent",
                        "Spaced review that decides when a word returns",
                        "Every recording and illustration, once production replaces the placeholders",
                    ], id: \.self) { f in
                        HStack(alignment: .top, spacing: 11) {
                            AUIcon(kind: .check, size: 16, color: .auAccent2)
                                .padding(.top, 2)
                            Text(f)
                                .font(.figtree(.regular, size: 14))
                                .lineSpacing(14 * 0.45)
                        }
                    }
                }
                .padding(.bottom, 24)

                Spacer(minLength: 12)

                APillButton(title: "Start seven free days") {
                    r.startTrial()
                }
                .padding(.bottom, 10)

                Text(r.plan == "annual"
                     ? "£59.99 a year after seven days. Cancel any time in Settings."
                     : "£8.99 a month after seven days. Cancel any time in Settings.")
                    .font(.figtree(.regular, size: 11.5))
                    .lineSpacing(11.5 * 0.5)
                    .foregroundStyle(Color.auText.opacity(0.45))
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 34)
        }
        .auScreenEntrance()
    }

    private func planRow(id: String, name: String, sub: String, price: String, badge: String) -> some View {
        let on = env.router.plan == id
        return Button {
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
                        .foregroundStyle(Color.auText.opacity(0.52))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Text(price)
                    .font(.figtree(.bold, size: 17))
                    .monospacedDigit()
                    .tracking(-0.34)
            }
            .padding(.horizontal, 19)
            .padding(.vertical, 17)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous).fill(Color.auFill)
                    if on {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .strokeBorder(Color.auAccent.opacity(0.70), lineWidth: 1)
                    } else {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .strokeBorder(Color.auEdge, lineWidth: 1)
                    }
                }
            )
        }
        .buttonStyle(.auTap)
        .accessibilityAddTraits(on ? .isSelected : [])
    }
}
