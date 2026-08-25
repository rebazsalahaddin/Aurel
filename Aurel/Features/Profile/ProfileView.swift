import SwiftUI

// MARK: - Profile
//
// Ported from Aurel.dc.html lines 1275–1515 (profile section).

struct ProfileView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        let r = env.router
        ZStack(alignment: .bottom) {
            Color.auBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("You")
                        .font(.caprasimo(size: 29))
                        .tracking(-0.58)
                        .padding(.bottom, 6)
                    Text(AppRouter.TopLevelSection.you.purpose.auLocalized)
                        .font(.figtree(.regular, size: 13.5))
                        .auLine(13.5, 1.5)
                        .foregroundStyle(Color.auTextSecondary)
                        .padding(.bottom, 22)
                        .accessibilityIdentifier("au.profile.purpose")

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

                    if !r.capabilities.commerce {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .top, spacing: 14) {
                                AUIcon(kind: .lock, size: 18, color: .auAccentText)
                                    .frame(width: 40, height: 40)
                                    .background(Circle().fill(Color.auTintBg))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Chapter 1 is included")
                                        .font(.figtree(.semibold, size: 14.5))
                                    Text("Additional chapters aren't available in this build.")
                                        .font(.figtree(.regular, size: 12.5))
                                        .auLine(12.5, 1.45)
                                        .foregroundStyle(Color.auTextSecondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            Button {
                                r.nav(.stories)
                            } label: {
                                Text("Practise Chapter 1")
                                    .font(.figtree(.semibold, size: 13.5))
                                    .foregroundStyle(Color.auAccentText)
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: 17, style: .continuous)
                                            .fill(Color.auTintBg))
                            }
                            .buttonStyle(.auTap)
                            .accessibilityIdentifier("au.profile.practice-chapter-one")
                        }
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color.auFill)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .strokeBorder(Color.auEdge, lineWidth: 1)
                        )
                        .padding(.bottom, 20)
                    } else if !r.pro {
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
                        AUEmptyStateView(
                            title: String(localized: "No milestones yet"),
                            message: String(
                                localized:
                                    "The first arrives when you finish a lesson. Milestones are sentences about real work, not badges."
                            ),
                            icon: .sparkle,
                            actionTitle: String(localized: "Start the next lesson")
                        ) {
                            r.perform(r.learnNextAction)
                        }
                        .accessibilityIdentifier("au.profile.empty-milestones")
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
                        if r.capabilities.commerce {
                            profileRow("Subscription", r.pro ? "Subscribed" : "Free") {
                                r.nav(.paywall)
                            }
                        }
                        profileRow("Settings", "", divider: r.capabilities.support) {
                            r.nav(.settings)
                        }
                        if r.capabilities.support {
                            profileRow("Help and contact", "", divider: false) {}
                        }
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
        let days =
            cal.dateComponents(
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
