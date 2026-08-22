import SwiftUI

// MARK: - Streak · Leaderboard
//
// Ported from Aurel.dc.html lines 887–991 (+ BOARD_ALL, ordinal, myRank —
// lines 2146–2211, 2421–2464).

struct StreakView: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// §3.15(d): the calm milestone moment, shown once per milestone.
    @State private var milestone: Int? = nil
    /// §3.15(c): drives the today-cell ring pulse.
    @State private var todayRingOn = false

    var body: some View {
        let r = env.router
        let logs = r.dayLogs()
        let week = r.weekCompletedDays()
        let month = AppRouter.monthStates(logs)
        let best = max(AppRouter.bestStreak(over: logs), r.streak)

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button {
                        r.nav(.home)
                    } label: {
                        AUIcon(kind: .back, size: 17)
                            .frame(width: 44, height: 44)
                            .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
                    }
                    .buttonStyle(.auTap)
                    .accessibilityLabel("Back")
                    Spacer()
                    // §3.15(a): the real start date, from the profile.
                    Text(sinceText)
                        .font(.figtree(.regular, size: 11))
                        .tracking(1.54)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.auText.opacity(0.45))
                }
                .padding(.bottom, 32)

                // §3.15(d): the calm milestone moment — authored line, dawn
                // wash, warm bell; once per milestone, logged to the profile.
                if let milestone {
                    MilestoneMomentCard(day: milestone)
                        .padding(.bottom, 22)
                        .transition(
                            reduceMotion ? .opacity : .opacity.combined(with: .offset(y: 10)))
                        .onTapGesture { self.milestone = nil }
                }

                Text("\(max(r.streak, 0))")
                    .font(.caprasimo(size: 96))
                    .tracking(-3.84)
                    .foregroundStyle(Color.auAccent)

                Text(r.streak == 1 ? "consecutive day" : "consecutive days")
                    .font(.figtree(.regular, size: 13))
                    .tracking(1.82)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.auText.opacity(0.50))
                    .padding(.top, 8)

                HStack(spacing: 18) {
                    VStack(alignment: .leading, spacing: 4) {
                        // §3.15(b): Best from the real DayLog history — never
                        // a fixture number.
                        Text("\(best)")
                            .font(.figtree(.bold, size: 17))
                            .monospacedDigit()
                        Text("Best")
                            .font(.figtree(.regular, size: 10.5))
                            .tracking(1.05)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auText.opacity(0.45))
                    }
                    Rectangle().fill(Color.auDivider).frame(width: 1, height: 34)
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 5) {
                            // Rest days: the month's two grace tokens, the
                            // spent ones quiet (real `graceUsed`).
                            ForEach(0..<2, id: \.self) { i in
                                Circle()
                                    .fill(
                                        i < restDaysLeft ? Color.auAccent2 : Color.auText.opacity(0.12)
                                    )
                                    .frame(width: 11, height: 11)
                            }
                        }
                        .frame(height: 17)
                        Text("Rest days left")
                            .font(.figtree(.regular, size: 10.5))
                            .tracking(1.05)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auText.opacity(0.45))
                    }
                }
                .padding(.top, 18)

                Text(streakNote)
                    .font(.figtree(.regular, size: 14.5))
                    .auLine(14.5, 1.6)
                    .foregroundStyle(Color.auText.opacity(0.60))
                    .frame(maxWidth: 300, alignment: .leading)
                    .padding(.top, 18)
                    .padding(.bottom, 30)

                ACard(radius: 28, padded: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("This week")
                            .font(.figtree(.regular, size: 11))
                            .tracking(1.32)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auText.opacity(0.45))
                            .padding(.bottom, 16)
                        // §3.15(c): every cell from real DayLog history; today
                        // carries the ring pulse even while incomplete.
                        streakWeekDots(week)
                    }
                    .padding(22)
                }
                .padding(.bottom, 16)

                VStack(alignment: .leading, spacing: 0) {
                    Text(monthName)
                        .font(.figtree(.regular, size: 11))
                        .tracking(1.32)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.auText.opacity(0.45))
                        .padding(.bottom, 14)
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 7), count: 7),
                        spacing: 7
                    ) {
                        ForEach(0..<31, id: \.self) { i in
                            monthDot(i, state: month.indices.contains(i) ? month[i] : .outside)
                        }
                    }
                }
                .padding(22)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous).strokeBorder(
                        Color.auDivider, lineWidth: 1)
                )
                .padding(.bottom, 16)

                HStack(spacing: 14) {
                    AUIcon(kind: .clock, size: 20, color: .auOkText)
                        .frame(width: 20, height: 20)
                    Text("Two rest days a month are built in. Missing one won't undo anything.")
                        .font(.figtree(.regular, size: 13.5))
                        .auLine(13.5, 1.5)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 26, style: .continuous).fill(Color.auOkBg)
                )
                .foregroundStyle(Color.auOkText)
            }
            .padding(.horizontal, 24)
            .padding(.top, 70)
            .padding(.bottom, 40)
        }
        .background(Color.auBackground.ignoresSafeArea())
        .auScreenEntrance()
        // §3.15(d): the milestone moment fires once — the due check is pure,
        // the show-once bookkeeping lives in the profile.
        .task {
            let due = AppRouter.dueMilestones(streak: r.streak, seen: r.milestonesSeen)
            if let m = due.first {
                withAnimation(AUMotion.animation(AUMotion.flow, reduceMotion: reduceMotion)) {
                    milestone = m
                }
                r.markMilestoneShown(m)
                AUFeedback.milestone()
                AUSound.shared.milestone()
                AUAX.announce(milestoneLine(m))
            }
        }
    }

    // MARK: Real figures (§3.15)

    /// "Since 22 August" — the profile's honest start date.
    private var sinceText: String {
        guard let start = env.router.profileStartDate() else { return "Day one" }
        let f = DateFormatter()
        f.dateFormat = "d MMMM"
        return "Since \(f.string(from: start))"
    }

    /// The current month's real name.
    private var monthName: String {
        let f = DateFormatter()
        f.dateFormat = "MMMM"
        return f.string(from: Date())
    }

    /// Grace tokens left this month (two built in, S1-009).
    private var restDaysLeft: Int {
        let r = env.router
        let thisMonth = StreakEngine.monthStamp(Date())
        let used = r.graceMonth == thisMonth ? r.graceUsed : 0
        return max(0, StreakEngine.graceDaysPerMonth - used)
    }

    /// The authored milestone line (§3.15d) — calm, no confetti.
    private func milestoneLine(_ day: Int) -> String {
        switch day {
        case 7: "Seven quiet days."
        case 30: "Thirty quiet days."
        default: "A hundred quiet days."
        }
    }

    private func streakWeekDots(_ week: [Bool]) -> some View {
        let cal = Calendar.current
        let todayIdx = (cal.component(.weekday, from: Date()) + 5) % 7  // Mon = 0
        return HStack(spacing: 7) {
            ForEach(Array(["M", "T", "W", "T", "F", "S", "S"].enumerated()), id: \.offset) {
                i, label in
                let isToday = i == todayIdx
                VStack(spacing: 8) {
                    ZStack {
                        Capsule()
                            .fill(
                                week.indices.contains(i) && week[i]
                                    ? AnyShapeStyle(
                                        LinearGradient(
                                            colors: [
                                                Color.auAccent.mixed(with: 0.26, of: .white),
                                                Color.auAccent,
                                            ],
                                            startPoint: .top, endPoint: .bottom
                                        ))
                                    : AnyShapeStyle(Color.auText.opacity(0.10))
                            )
                            .frame(height: 34)
                            .shadow(
                                color: week.indices.contains(i) && week[i] ? Color.auGlow : .clear,
                                radius: 4, y: 3)
                        // §3.15(c): the today ring — accent hairline that
                        // quietly pulses while the day is still open.
                        if isToday {
                            Capsule()
                                .strokeBorder(
                                    Color.auAccent.opacity(todayRingOn ? 0.55 : 0.15),
                                    lineWidth: todayRingOn ? 2 : 1)
                                .frame(height: 34)
                                .onAppear {
                                    guard !reduceMotion else { return }
                                    withAnimation(
                                        .easeInOut(duration: 2.2).repeatForever(autoreverses: true)
                                    ) { todayRingOn = true }
                                }
                        }
                    }
                    Text(label)
                        .font(.figtree(.regular, size: 10.5))
                        .foregroundStyle(Color.auText.opacity(0.45))
                }
                .frame(maxWidth: .infinity)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("This week: \(week.filter { $0 }.count) of 7 days complete")
    }

    private func monthDot(_ i: Int, state: AppRouter.MonthDayState) -> some View {
        Group {
            switch state {
            case .outside:
                Color.clear
            case .future:
                Circle().fill(Color.auText.opacity(0.05))
            case .quiet:
                Circle().fill(Color.auText.opacity(0.08))
            case .done:
                Circle().fill(Color.auAccent)
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .modifier(PopIn(delay: Double(i) * 0.014))
    }

    private var streakNote: String {
        let s = env.router.streak
        if s == 0 { return "The count starts when you finish your first lesson." }
        if s == 1 { return "One day. The habit underneath is the point, not the number." }
        return "Six weeks of most days. Long enough that it carries itself now."
    }
}

// MARK: Milestone moment (§3.15d / F9)

/// The calm milestone card — an authored line over a dawn-glow wash. No
/// confetti, no fanfare: one line, a bell, and it never repeats.
struct MilestoneMomentCard: View {
    let day: Int

    private var line: String {
        switch day {
        case 7: "Seven quiet days."
        case 30: "Thirty quiet days."
        default: "A hundred quiet days."
        }
    }

    private var sub: String {
        switch day {
        case 7: "The habit underneath is holding."
        case 30: "A month of most days — it carries itself now."
        default: "A hundred days. Extraordinary, quietly."
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Milestone")
                .font(.figtree(.bold, size: 10.5))
                .tracking(1.47)
                .textCase(.uppercase)
                .foregroundStyle(Color.auAccentText)
            Text(line)
                .font(.caprasimo(size: 22))
                .auHeadLine(22, 1.25)
                .foregroundStyle(Color.auText)
            Text(sub)
                .font(.figtree(.regular, size: 13))
                .auLine(13, 1.5)
                .foregroundStyle(Color.auText.opacity(0.58))
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack(alignment: .topLeading) {
                // The dawn-glow wash — the same warm radial the home header
                // carries, kept soft.
                RadialGradient(
                    stops: [
                        .init(color: Color.auAccent.opacity(0.20), location: 0),
                        .init(color: .clear, location: 0.9),
                    ],
                    center: UnitPoint(x: 0.2, y: 0), startRadius: 0, endRadius: 320
                )
                RoundedRectangle(cornerRadius: 26, style: .continuous).fill(Color.auFill)
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .strokeBorder(Color.auAccent.opacity(0.24), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

// MARK: Leaderboard

struct BoardRow: Identifiable {
    let id = UUID()
    let rank: Int
    let name: String
    let sub: String
    let score: Int
    let me: Bool
    var gap: Int = 0
}

struct LeaderboardView: View {
    @Environment(AppEnvironment.self) private var env

    /// BOARD_ALL (line 2201) — verbatim.
    static let boardAll: [BoardRow] = [
        BoardRow(rank: 1, name: "Ines R.", sub: "Lisbon", score: 407, me: false),
        BoardRow(rank: 2, name: "tomas_k", sub: "41-day streak", score: 402, me: false),
        BoardRow(rank: 3, name: "Wen Liang", sub: "Chengdu", score: 351, me: false),
        BoardRow(rank: 4, name: "Bruno", sub: "Since May", score: 288, me: false),
        BoardRow(rank: 5, name: "A. Nakada", sub: "Sendai", score: 281, me: false),
        BoardRow(rank: 7, name: "Karel M.", sub: "Graz", score: 154, me: false),
        BoardRow(rank: 8, name: "sofia.b", sub: "Since Tuesday", score: 141, me: false),
        BoardRow(rank: 29, name: "j.mensah", sub: "Accra", score: 26, me: false),
        BoardRow(rank: 30, name: "Liu Yang", sub: "Joined Friday", score: 12, me: false),
    ]

    private var myRank: Int { env.router.streak > 1 ? 6 : 30 }
    private var wordsTotal: Int {
        let r = env.router
        return r.baseLessons > 0 ? 412 + (r.lessonsDone - r.baseLessons) * 12 : r.lessonsDone * 12
    }

    private var rows: [BoardRow] {
        let r = env.router
        let me = BoardRow(
            rank: myRank, name: "Mira Aldrin", sub: myRank > 6 ? "You · joined today" : "You",
            score: wordsTotal, me: true)
        let all = (Self.boardAll + [me]).sorted { $0.rank < $1.rank }
        if r.boardAll { return all }
        let near = all.filter { $0.me || $0.rank <= 3 || abs($0.rank - myRank) == 1 }
        return near.enumerated().map { i, row in
            let next = near.indices.contains(i + 1) ? near[i + 1] : nil
            var copy = row
            if let next, next.rank - row.rank - 1 > 0 {
                copy.gap = next.rank - row.rank - 1
            }
            return copy
        }
    }

    var body: some View {
        let r = env.router
        ZStack(alignment: .bottom) {
            Color.auBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Cedar Group")
                            .font(.caprasimo(size: 29))
                            .tracking(-0.58)
                        Spacer()
                    }
                    .padding(.bottom, 6)

                    Text("30 learners at A2 · resets Monday")
                        .font(.figtree(.regular, size: 12.5))
                        .foregroundStyle(Color.auText.opacity(0.55))
                        .padding(.bottom, 18)

                    // §3.23(a): the board is a labeled sample until a cohort
                    // backend exists — the promise stays honest.
                    HStack(spacing: 7) {
                        AUIcon(kind: .sparkle, size: 13, color: .auTintText)
                        Text("Sample group — cohorts arrive with online accounts")
                            .font(.figtree(.semibold, size: 11))
                            .auLine(11, 1.4)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.auTintBg))
                    .foregroundStyle(Color.auTintText)
                    .padding(.bottom, 18)

                    if !r.boardOut {
                        ACard(radius: 24) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(boardStory)
                                    .font(.caprasimo(size: 20))
                                    .auHeadLine(20, 1.28)
                                Text("Two days left this week")
                                    .font(.figtree(.regular, size: 12.5))
                                    .foregroundStyle(Color.auText.opacity(0.52))
                            }
                        }
                        .padding(.bottom, 20)

                        ForEach(rows) { row in
                            boardRow(row)
                            if row.gap > 0 {
                                HStack(spacing: 9) {
                                    Text("⋯")
                                        .frame(width: 24, alignment: .trailing)
                                    Text("\(row.gap) learner\(row.gap == 1 ? "" : "s") between")
                                        .font(.figtree(.regular, size: 11.5))
                                        .tracking(0.46)
                                }
                                .foregroundStyle(Color.auText.opacity(0.40))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 4)
                            }
                        }

                        Button {
                            r.boardAll.toggle()
                        } label: {
                            Text(r.boardAll ? "Show fewer" : "Show all 30")
                                .font(.figtree(.bold, size: 12.5))
                                .foregroundStyle(Color.auAccentText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                        .buttonStyle(.auTap)
                    } else {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("You've left the group")
                                .font(.caprasimo(size: 18))
                            Text(
                                "Nothing you do is compared to anyone. Turn it back on in Settings whenever you like."
                            )
                            .font(.figtree(.regular, size: 13))
                            .auLine(13, 1.5)
                            .foregroundStyle(Color.auText.opacity(0.52))
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .strokeBorder(
                                    Color.auText.opacity(0.18),
                                    style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
                        )
                    }

                    // footer
                    VStack(alignment: .leading, spacing: 0) {
                        Rectangle().fill(Color.auDivider).frame(height: 1)
                        Button {
                            r.boardRules.toggle()
                        } label: {
                            HStack(spacing: 8) {
                                Text("How this works")
                                    .font(.figtree(.semibold, size: 12.5))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                AUIcon(kind: .chevronDown, size: 14, color: .auText.opacity(0.55))
                                    .frame(width: 14, height: 14)
                                    .rotationEffect(.degrees(r.boardRules ? 180 : 0))
                            }
                            .foregroundStyle(Color.auText.opacity(0.55))
                            .padding(.top, 16)
                        }
                        .buttonStyle(.auTap)

                        if !r.invited {
                            Button {
                                r.invited = true
                            } label: {
                                Text("Invite someone into Cedar Group")
                                    .font(.figtree(.bold, size: 13))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 19, style: .continuous)
                                            .strokeBorder(
                                                Color.auText.opacity(0.20),
                                                style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
                                    )
                                    .foregroundStyle(Color.auText.opacity(0.62))
                            }
                            .buttonStyle(.auTap)
                            .padding(.top, 14)
                        } else {
                            HStack(alignment: .top, spacing: 11) {
                                AUIcon(kind: .check, size: 14, color: .auOkText)
                                    .padding(.top, 3)
                                Text(
                                    "Link copied. It holds one seat for seven days — they join at whatever level they place into."
                                )
                                .font(.figtree(.regular, size: 12.5))
                                .auLine(12.5, 1.5)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 19, style: .continuous).fill(
                                    Color.auOkBg)
                            )
                            .foregroundStyle(Color.auOkText)
                            .padding(.top, 14)
                        }

                        if r.boardRules {
                            Text(
                                "Words retained this week, nothing else. Groups are matched on how often you practise, not how well. Nobody is removed, nobody is demoted, and there are no prizes — it is here only if you find it useful."
                            )
                            .font(.figtree(.regular, size: 12.5))
                            .auLine(12.5, 1.6)
                            .foregroundStyle(Color.auText.opacity(0.48))
                            .padding(.top, 12)
                        }
                    }
                    .padding(.top, 22)
                    .padding(.bottom, 44)
                }
                .padding(.horizontal, 24)
                .padding(.top, 70)
                .padding(.bottom, 130)
            }

            AUTabBar(current: .leaderboard)
                .padding(.horizontal, 14)
                .padding(.bottom, 26)
        }
        .auScreenEntrance()
    }

    private var boardStory: String {
        let ord = ordinal(myRank)
        if myRank <= 3 { return "You're \(ord). Nobody is close." }
        return "You're \(ord). \(env.router.streak > 1 ? 12 : 18) words to \(ordinal(myRank - 1))."
    }

    private func ordinal(_ n: Int) -> String {
        let suffixes = ["th", "st", "nd", "rd"]
        if n % 100 >= 11 && n % 100 <= 13 { return "\(n)th" }
        return "\(n)\(suffixes.indices.contains(n % 10) && n % 10 < 4 ? suffixes[n % 10] : "th")"
    }

    private func boardRow(_ row: BoardRow) -> some View {
        HStack(spacing: 13) {
            Text("\(row.rank)")
                .font(.figtree(.semibold, size: 13))
                .monospacedDigit()
                .frame(width: 24, alignment: .trailing)
                .foregroundStyle(row.rank <= 3 ? Color.auAccentText : Color.auText.opacity(0.65))
            Text(String(row.name.prefix(1)).uppercased())
                .font(.caprasimo(size: 15))
                .frame(width: 36, height: 36)
                .background(Circle().fill(row.me ? Color.auAccent : Color.auText.opacity(0.09)))
                .foregroundStyle(row.me ? Color.auBackground : Color.auText)
            VStack(alignment: .leading, spacing: 1) {
                Text(row.name)
                    .font(.figtree(.semibold, size: 15))
                Text(row.sub)
                    .font(.figtree(.regular, size: 12))
                    .opacity(0.6)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(row.score)")
                .font(.figtree(.bold, size: 17))
                .monospacedDigit()
                .tracking(-0.34)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(
                        // §3.23(b): the my-row wash is a step stronger than the
                        // field — emphasis without shouting.
                        row.me
                            ? Color.auFill.mixed(with: 0.22, of: Color.auAccent) : Color.auFill)
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(
                        row.me ? Color.auAccent.opacity(0.38) : Color.auEdge, lineWidth: 1)
            }
        )
        .padding(.bottom, 5)
        // §3.23(b): VoiceOver hears which row is yours.
        .accessibilityValue(row.me ? "You" : "")
        .accessibilityLabel("\(ordinal(row.rank)), \(row.name), \(row.score) words")
    }
}
