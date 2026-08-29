import SwiftUI

// MARK: - Assessment + chapter close screens
//
// Pending · QuizIntro · Results · Remediation · ReviewPlan · ChapterMap —
// ported from CourseScreen.dc.html lines 554–573, 1005–1135.

// MARK: Pending (awaiting course content — the honest stub)

struct PendingScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 24, bottomPad: 26) {
            if case .pending(let p) = m.cur?.screen.payload {
                HStack(spacing: 8) {
                    AUIcon(kind: .lock, size: 13, color: .auFlatText)
                    Text("Course content unavailable")
                }
                .font(.figtree(.bold, size: 9.5))
                .tracking(1.3)
                .textCase(.uppercase)
                .foregroundStyle(Color.auFlatText)
                .padding(.horizontal, 13)
                .padding(.vertical, 7)
                .background(Capsule().fill(Color.auFlatBg))
                .padding(.bottom, 18)

                Text(m.cur?.screen.learnerTitle ?? ScreenKind.pending.defaultDisplayTitle)
                    .font(.caprasimo(size: 27))
                    .tracking(-0.54)
                    .auHeadLine(27, 1.2)
                    .padding(.bottom, 12)

                Text(
                    p.awaiting.learnerFacing
                        ?? "This activity is not available in the current course."
                )
                .font(.figtree(.regular, size: 14))
                .auLine(14, 1.6)
                .foregroundStyle(Color.auText.opacity(0.62))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 20)

                PlaceholderFrame(height: 170, cornerRadius: 20, label: "Course illustration")
                    .padding(.bottom, 20)

                ACard(radius: 18, padded: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Choose another activity")
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(1.3)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auAccentText)
                            .padding(.bottom, 10)
                        Text("Continue to the next available part of the lesson.")
                            .font(.figtree(.regular, size: 12.8))
                            .auLine(12.8, 1.5)
                            .foregroundStyle(Color.auText.opacity(0.66))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 17)
                    .padding(.vertical, 15)
                }
                .padding(.bottom, 16)

                Spacer(minLength: 12)

                GoOnButton(label: "Go on") { m.goto(m.p + 1) }
            }
        }
    }
}

/// The dashed diagonal-stripe placeholder frame.
struct PlaceholderFrame: View {
    var height: CGFloat
    var cornerRadius: CGFloat
    var label: String
    var tint: Color = .auText

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color.auText.opacity(0.005))
            StripeOverlay()
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(tint.opacity(0.2), style: StrokeStyle(lineWidth: 1.5, dash: [6, 5]))
            Text(label)
                .font(.figtree(.semibold, size: 11.5))
                .tracking(0.58)
                .foregroundStyle(tint.opacity(0.38))
        }
        .frame(height: height)
    }

    private struct StripeOverlay: View {
        var body: some View {
            Canvas { context, size in
                var stripe = Path()
                let period: CGFloat = 18
                let dy = size.width
                var x0: CGFloat = -dy
                while x0 < size.width + dy {
                    stripe.move(to: CGPoint(x: x0, y: 0))
                    stripe.addLine(to: CGPoint(x: x0 + dy, y: dy))
                    stripe.addLine(to: CGPoint(x: x0 + dy + 9, y: dy))
                    stripe.addLine(to: CGPoint(x: x0 + 9, y: 0))
                    stripe.closeSubpath()
                    x0 += period
                }
                context.fill(stripe, with: .color(Color.auText.opacity(0.05)))
            }
        }
    }
}

// MARK: Quiz intro

struct QuizIntroScreenView: View {
    let m: PlayerModel

    var body: some View {
        // `align-items:center; text-align:center` (the only centred player screen)
        ScreenColumn(topPad: 30, bottomPad: 30, hPad: 26, alignment: .center) {
            if case .quizIntro(let q) = m.cur?.screen.payload {
                VStack(spacing: 0) {
                    Spacer(minLength: 20)

                    AUIcon(kind: .check, size: 36, color: .auTintText)
                        .frame(width: 82, height: 82)
                        .background(Circle().fill(Color.auTintBg))

                    Text(q.head ?? "")
                        .font(.caprasimo(size: 32))
                        .tracking(-0.7)
                        .auHeadLine(32, 1.15)
                        .multilineTextAlignment(.center)
                        .padding(.top, 24)
                        .padding(.bottom, 16)

                    ForEach(q.meta ?? [], id: \.self) { t in
                        Text(t)
                            .font(.figtree(.regular, size: 15))
                            .foregroundStyle(Color.auText.opacity(0.60))
                            .padding(.bottom, 8)
                    }

                    if let promise = q.promise {
                        Text(promise)
                            .font(.figtree(.regular, size: 13.5))
                            .auLine(13.5, 1.55)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous).fill(
                                    Color.auOkBg)
                            )
                            .foregroundStyle(Color.auOkText)
                            .padding(.bottom, 28)
                    }

                    Spacer(minLength: 20)

                    GoOnButton(label: "Start") { m.goto(m.p + 1) }
                        .frame(maxWidth: 280)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

// MARK: Results

struct ResultsScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 24, bottomPad: 26) {
            if case .results(let r) = m.cur?.screen.payload {
                let hasLiveScore = m.quizTotal > 0
                let isPassed = hasLiveScore ? m.quizPassed : true
                let scoreText = hasLiveScore
                    ? "Score: \(m.quizCorrect) / \(m.quizTotal) (\(m.quizScorePercentage)%)"
                    : (r.score ?? "Pass: 86% overall")

                if let ill = r.ill {
                    IllustrationPlaceholder(
                        ill: ill,
                        height: 150,
                        aspectRatio: 16.0 / 9.0,
                        cornerRadius: 20,
                        captionSize: 11.5
                    )
                    .padding(.bottom, 18)
                }

                // rings (first 4 lit)
                HStack(alignment: .top, spacing: 10) {
                    ForEach(Array((r.rings ?? []).enumerated()), id: \.offset) { k, t in
                        let on = isPassed ? (k < 4) : (k < 2)
                        VStack(spacing: 7) {
                            Circle()
                                .strokeBorder(
                                    on ? Color.auAccent2Ramp(500) : Color.auText.opacity(0.2),
                                    lineWidth: 2.5
                                )
                                .background(Circle().fill(on ? Color.auOkBg : .clear))
                                .overlay {
                                    if on { AUIcon(kind: .check, size: 16, color: .auOkText) }
                                }
                                .frame(width: 38, height: 38)
                            Text(t)
                                .font(.figtree(.semibold, size: 9.5))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.auTextSecondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.bottom, 22)

                // Mastery score card
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        AUIcon(
                            kind: isPassed ? .check : .close,
                            size: 16,
                            color: isPassed ? .auOkText : .auErrText
                        )
                        Text(isPassed ? "Mastery Passed (≥75%)" : "Mastery Review Needed (<75%)")
                            .font(.figtree(.bold, size: 10))
                            .tracking(1.2)
                            .textCase(.uppercase)
                            .foregroundStyle(isPassed ? Color.auOkText : Color.auErrText)
                    }

                    Text(scoreText)
                        .font(.caprasimo(size: 24))
                        .foregroundStyle(isPassed ? Color.auOkText : Color.auErrText)

                    Text(
                        isPassed
                            ? "Great job! You achieved mastery and unlocked the next chapter."
                            : "You need at least 75% to pass mastery and unlock the next chapter. Please review and try again."
                    )
                    .font(.figtree(.regular, size: 13.5))
                    .auLine(13.5, 1.45)
                    .foregroundStyle(
                        isPassed ? Color.auOkText.opacity(0.85) : Color.auErrText.opacity(0.85)
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 19)
                .padding(.vertical, 17)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(isPassed ? Color.auOkBg : Color.auErrBg)
                )
                .padding(.bottom, 11)

                if let strong = r.strong, !strong.isEmpty {
                    VStack(alignment: .leading, spacing: 7) {
                        Text("Strong")
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(1.3)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auOkText.opacity(0.8))
                        Text(strong)
                            .font(.figtree(.regular, size: 15.5))
                            .auLine(15.5, 1.5)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 19)
                    .padding(.vertical, 17)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.auOkBg)
                    )
                    .foregroundStyle(Color.auOkText)
                    .padding(.bottom, 11)
                }

                ACard(radius: 20) {
                    VStack(alignment: .leading, spacing: 7) {
                        Text("Developing")
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(1.3)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auTextTertiary)
                        Text(r.developing ?? "")
                            .font(.figtree(.regular, size: 15.5))
                            .auLine(15.5, 1.5)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom, 11)

                ACard(radius: 20) {
                    VStack(alignment: .leading, spacing: 7) {
                        Text("Next")
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(1.3)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auAccentText)
                        Text(r.next ?? "")
                            .font(.figtree(.regular, size: 15.5))
                            .auLine(15.5, 1.5)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom, 14)

                Spacer(minLength: 12)

                HStack(spacing: 12) {
                    if !isPassed {
                        APillButton(title: "Try again", role: .primary, player: true) {
                            m.goto(max(0, m.p - 1))
                        }
                        APillButton(title: "Review", variant: .quiet, player: true) {
                            m.goto(m.p + 1)
                        }
                    } else {
                        APillButton(title: "Review", variant: .quiet, player: true) {
                            m.goto(m.p + 1)
                        }
                        APillButton(title: "Go on", role: .primary, player: true) {
                            m.goto(m.p + 1)
                        }
                    }
                }
                .padding(.top, 18)
            }
        }
    }
}

// MARK: Remediation

struct RemediationScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 24, bottomPad: 26) {
            if case .remediation(let r) = m.cur?.screen.payload {
                Text(r.head ?? "")
                    .font(.caprasimo(size: 27))
                    .tracking(-0.54)
                    .padding(.bottom, 7)

                Text(r.sub ?? "")
                    .font(.figtree(.regular, size: 13.5))
                    .auLine(13.5, 1.55)
                    .foregroundStyle(Color.auTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 18)

                VStack(spacing: 10) {
                    ForEach(r.clinics ?? [], id: \.id) { c in
                        HStack(spacing: 13) {
                            AUIcon(kind: .loop, size: 18, color: .auTintText)
                                .frame(width: 38, height: 38)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.auTintBg))
                            VStack(alignment: .leading, spacing: 3) {
                                Text(c.name)
                                    .font(.figtree(.semibold, size: 15))
                                Text(c.benefit)
                                    .font(.figtree(.regular, size: 12.5))
                                    .auLine(12.5, 1.45)
                                    .foregroundStyle(Color.auTextSecondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(c.n) items")
                                .font(.figtree(.semibold, size: 10.5))
                                .padding(.horizontal, 9)
                                .padding(.vertical, 5)
                                .background(Capsule().fill(Color.auFlatBg))
                                .foregroundStyle(Color.auFlatText)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 19, style: .continuous).fill(
                                Color.auFill)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 19).strokeBorder(
                                Color.auEdge, lineWidth: 1))
                    }
                }

                Spacer(minLength: 12)

                HStack(spacing: 12) {
                    APillButton(title: "Skip for now", variant: .quiet, player: true) {
                        m.goto(m.p + 1)
                    }
                    APillButton(title: "Start a pick", player: true) { m.goto(m.p + 1) }
                }
                .padding(.top, 18)
            }
        }
    }
}

// MARK: Review plan

struct ReviewPlanScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 24, bottomPad: 26) {
            if case .reviewPlan(let r) = m.cur?.screen.payload {
                Text(r.head ?? "")
                    .font(.caprasimo(size: 27))
                    .tracking(-0.54)
                    .padding(.bottom, 7)

                Text(r.sub ?? "")
                    .font(.figtree(.regular, size: 13.5))
                    .auLine(13.5, 1.55)
                    .foregroundStyle(Color.auTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 18)

                HStack(spacing: 6) {
                    ForEach(Array((r.week ?? []).enumerated()), id: \.offset) { _, d in
                        VStack(spacing: 6) {
                            Text(d.d)
                                .font(.figtree(.bold, size: 9.5))
                                .tracking(0.8)
                            Text(d.t)
                                .font(.figtree(.regular, size: 9.5))
                                .auLine(9.5, 1.3)
                                .opacity(0.85)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .padding(.horizontal, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(d.on ? Color.auTintBg : .clear)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(
                                    d.on ? Color.auAccent.opacity(0.30) : Color.auEdge, lineWidth: 1
                                )
                        )
                        .foregroundStyle(d.on ? Color.auTintText : Color.auText.opacity(0.38))
                    }
                }
                .padding(.bottom, 20)

                ACard(radius: 18, padded: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Exported to the scheduler")
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(1.3)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auTextTertiary)
                            .padding(.bottom, 10)
                        ForEach(r.exports ?? [], id: \.self) { e in
                            VStack(alignment: .leading, spacing: 3) {
                                Text(e.first ?? "")
                                    .font(.figtree(.semibold, size: 13))
                                if e.count > 1 {
                                    Text(e[1])
                                        .font(.figtree(.regular, size: 11.5))
                                        .auLine(11.5, 1.45)
                                        .foregroundStyle(Color.auTextSecondary)
                                }
                            }
                            .padding(.vertical, 8)
                            .overlay(alignment: .top) { Divider().overlay(Color.auDivider) }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 17)
                    .padding(.vertical, 15)
                }

                Spacer(minLength: 12)

                HStack(spacing: 11) {
                    Text("Reminders")
                        .font(.figtree(.regular, size: 13.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Capsule()
                        .fill(Color.auFlatBg)
                        .frame(width: 42, height: 24)
                        .overlay(alignment: .leading) {
                            Circle()
                                .fill(Color.auBackground)
                                .frame(width: 18, height: 18)
                                .padding(3)
                        }
                    Text("off")
                        .font(.figtree(.semibold, size: 11.5))
                        .foregroundStyle(Color.auTextTertiary)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 13)
                .overlay(
                    RoundedRectangle(cornerRadius: 16).strokeBorder(Color.auDivider, lineWidth: 1))

                GoOnButton(label: "Go on") { m.goto(m.p + 1) }
                    .padding(.top, 14)
            }
        }
    }
}

// MARK: Chapter map

struct ChapterMapScreenView: View {
    let m: PlayerModel

    var body: some View {
        ZStack {
            ZStack {
                Color.auBackground
                AUPaper()
            }
            .ignoresSafeArea()

            ScreenColumn(topPad: 26, bottomPad: 26) {
                if case .chapterMap(let c) = m.cur?.screen.payload {
                    if let ill = c.ill {
                        IllustrationPlaceholder(
                            ill: ill,
                            height: 150,
                            aspectRatio: 16.0 / 9.0,
                            cornerRadius: 20,
                            captionSize: 11.5
                        )
                        .padding(.bottom, 20)
                    }

                    AUIcon(kind: .check, size: 34, color: .auOkText)
                        .frame(width: 76, height: 76)
                        .background(Circle().fill(Color.auOkBg))
                        .padding(.bottom, 20)

                    Text(c.head ?? "")
                        .font(.caprasimo(size: 31))
                        .tracking(-0.68)
                        .auHeadLine(31, 1.15)
                        .padding(.bottom, 12)

                    Text(c.body ?? "")
                        .font(.figtree(.regular, size: 15))
                        .auLine(15, 1.6)
                        .foregroundStyle(Color.auText.opacity(0.62))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 24)

                    Text("Arc 1 · \(c.arc ?? "")")
                        .font(.figtree(.bold, size: 9.5))
                        .tracking(1.4)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.auAccentText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 11)

                    VStack(spacing: 9) {
                        ForEach(Array((c.chapters ?? []).enumerated()), id: \.offset) { _, entry in
                            let state = entry.s.lowercased()
                            let done = state == "done"
                            let next = state == "next"
                            let locked = state == "locked"

                            HStack(spacing: 12) {
                                ZStack {
                                    if next {
                                        PingRingStroke().frame(width: 32, height: 32)
                                    }
                                    Circle()
                                        .fill(done ? Color.auOkText.opacity(0.10) : Color.clear)
                                        .overlay(
                                            Circle().strokeBorder(
                                                next
                                                    ? Color.auAccent
                                                    : (locked
                                                        ? Color.auText.opacity(0.28) : Color.clear),
                                                lineWidth: 1.5
                                            )
                                        )
                                        .frame(width: 26, height: 26)
                                        .overlay {
                                            if done {
                                                AUIcon(kind: .check, size: 13, color: .auOkText)
                                            } else if locked {
                                                AUIcon(
                                                    kind: .lock, size: 12,
                                                    color: .auText.opacity(0.38))
                                            }
                                        }
                                }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Chapter \(entry.n)")
                                        .font(.figtree(.bold, size: 9))
                                        .tracking(1.1)
                                        .opacity(0.7)
                                    Text(entry.t)
                                        .font(.figtree(.regular, size: 14))
                                        .auLine(14, 1.35)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 13)
                            .background(
                                RoundedRectangle(cornerRadius: 17, style: .continuous)
                                    .fill(
                                        done ? Color.auOkBg : (next ? Color.auTintBg : Color.clear))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 17, style: .continuous)
                                    .strokeBorder(locked ? Color.auEdge : Color.clear, lineWidth: 1)
                            )
                            .foregroundStyle(
                                done
                                    ? Color.auOkText
                                    : (next ? Color.auTintText : Color.auText.opacity(0.46))
                            )
                        }
                    }

                    Spacer(minLength: 12)

                    Text("Next: \(c.next ?? "")")
                        .font(.figtree(.regular, size: 14))
                        .auLine(14, 1.5)
                        .padding(.horizontal, 17)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .strokeBorder(
                                    Color.auAccent.opacity(0.34),
                                    style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
                        )
                        .padding(.top, 20)

                    GoOnButton(label: "Go on") { m.goto(m.p + 1) }
                        .padding(.top, 14)
                }
            }
        }
    }
}
