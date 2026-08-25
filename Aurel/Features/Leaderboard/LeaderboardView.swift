import SwiftUI

// MARK: - Leaderboard
//
// Ported from Aurel.dc.html lines 887–991 (+ BOARD_ALL, ordinal, myRank —
// lines 2146–2211, 2421–2464).

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
                        .foregroundStyle(Color.auTextSecondary)
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
                                    .foregroundStyle(Color.auTextSecondary)
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
                                .foregroundStyle(Color.auTextTertiary)
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
                            .foregroundStyle(Color.auTextSecondary)
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
                            .foregroundStyle(Color.auTextSecondary)
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
                            .foregroundStyle(Color.auTextTertiary)
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
        let isPodium = row.rank <= 3
        // Craft overhaul P8: brand-ramp rank colors (were off-palette
        // gold/silver/bronze hex with failing rank-text contrast).
        let podiumColor: Color = {
            switch row.rank {
            case 1: return .auRankGold
            case 2: return .auRankSilver
            case 3: return .auRankBronze
            default: return .clear
            }
        }()

        return HStack(spacing: 13) {
            ZStack {
                if isPodium {
                    Circle()
                        .fill(podiumColor.opacity(0.18))
                        .frame(width: 24, height: 24)
                    Text("\(row.rank)")
                        .font(.figtree(.bold, size: 12))
                        .foregroundStyle(podiumColor)
                } else {
                    Text("\(row.rank)")
                        .font(.figtree(.semibold, size: 13))
                        .monospacedDigit()
                        .foregroundStyle(Color.auText.opacity(0.65))
                }
            }
            .frame(width: 26, alignment: .trailing)

            Text(String(row.name.prefix(1)).uppercased())
                .font(.caprasimo(size: 15))
                .frame(width: 36, height: 36)
                .background(Circle().fill(row.me ? Color.auAccent : Color.auText.opacity(0.09)))
                .foregroundStyle(row.me ? Color.auBackground : Color.auText)
            VStack(alignment: .leading, spacing: 1) {
                HStack(spacing: 6) {
                    Text(row.name)
                        .font(.figtree(.semibold, size: 15))
                    if isPodium {
                        AUIcon(kind: .star, size: 11, color: podiumColor)
                    }
                }
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
                        row.me
                            ? Color.auAccent.opacity(0.45)
                            : (isPodium ? podiumColor.opacity(0.35) : Color.auEdge),
                        lineWidth: isPodium || row.me ? 1.5 : 1
                    )
            }
        )
        .padding(.bottom, 5)
        // §3.23(b): VoiceOver hears which row is yours.
        .accessibilityValue(row.me ? "You" : "")
        .accessibilityLabel("\(ordinal(row.rank)), \(row.name), \(row.score) words")
    }
}
