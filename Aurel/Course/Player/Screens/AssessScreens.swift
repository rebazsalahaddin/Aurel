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
                    Text("Awaiting course content")
                }
                .font(.figtree(.bold, size: 9.5))
                .tracking(1.3)
                .textCase(.uppercase)
                .foregroundStyle(Color.auFlatText)
                .padding(.horizontal, 13)
                .padding(.vertical, 7)
                .background(Capsule().fill(Color.auFlatBg))
                .padding(.bottom, 18)

                Text(m.cur?.screen.label ?? "")
                    .font(.caprasimo(size: 27))
                    .tracking(-0.54)
                    .lineSpacing(27 * 0.2)
                    .padding(.bottom, 12)

                Text(p.awaiting ?? "")
                    .font(.figtree(.regular, size: 14))
                    .lineSpacing(14 * 0.6)
                    .foregroundStyle(Color.auText.opacity(0.62))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)

                PlaceholderFrame(height: 170, cornerRadius: 20, label: "screen placeholder")
                    .padding(.bottom, 20)

                ACard(radius: 18) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Specified, not yet authored")
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(1.3)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auAccentText)
                            .padding(.bottom, 10)
                        ForEach(p.planned ?? [], id: \.self) { t in
                            HStack(alignment: .top, spacing: 10) {
                                Circle()
                                    .fill(Color.auText.opacity(0.28))
                                    .frame(width: 5, height: 5)
                                    .padding(.top, 7)
                                Text(t)
                                    .font(.figtree(.regular, size: 12.8))
                                    .lineSpacing(12.8 * 0.5)
                                    .foregroundStyle(Color.auText.opacity(0.66))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom, 16)

                Spacer(minLength: 12)

                Text("Source: \(p.source ?? "")")
                    .font(.figtree(.regular, size: 11))
                    .lineSpacing(11 * 0.5)
                    .foregroundStyle(Color.auText.opacity(0.40))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 14)

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
        ScreenColumn(topPad: 30, bottomPad: 30) {
            if case .quizIntro(let q) = m.cur?.screen.payload {
                VStack(spacing: 0) {
                    Spacer(minLength: 40)

                    AUIcon(kind: .check, size: 36, color: .auTintText)
                        .frame(width: 82, height: 82)
                        .background(Circle().fill(Color.auTintBg))

                    Text(q.head ?? "")
                        .font(.caprasimo(size: 32))
                        .tracking(-0.7)
                        .lineSpacing(32 * 0.15)
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
                            .lineSpacing(13.5 * 0.55)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous).fill(
                                    Color.auOkBg)
                            )
                            .foregroundStyle(Color.auOkText)
                            .padding(.bottom, 28)
                    }

                    GoOnButton(label: "Start") { m.goto(m.p + 1) }
                        .frame(maxWidth: 280)

                    Spacer(minLength: 40)
                }
                .frame(maxWidth: .infinity)
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
                // rings (first 4 lit)
                HStack(alignment: .top, spacing: 10) {
                    ForEach(Array((r.rings ?? []).enumerated()), id: \.offset) { k, t in
                        let on = k < 4
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
                                .foregroundStyle(Color.auText.opacity(0.50))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.bottom, 22)

                ACard(radius: 20) {
                    VStack(alignment: .leading, spacing: 7) {
                        Text("Strong")
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(1.3)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auOkText.opacity(0.8))
                        Text(r.strong ?? "")
                            .font(.figtree(.regular, size: 15.5))
                            .lineSpacing(15.5 * 0.5)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.auOkBg)
                )
                .padding(.bottom, 11)

                ACard(radius: 20) {
                    VStack(alignment: .leading, spacing: 7) {
                        Text("Developing")
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(1.3)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auText.opacity(0.42))
                        Text(r.developing ?? "")
                            .font(.figtree(.regular, size: 15.5))
                            .lineSpacing(15.5 * 0.5)
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
                            .lineSpacing(15.5 * 0.5)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom, 14)

                Button {
                    m.showScore.toggle()
                } label: {
                    Text(m.showScore ? "Hide the number" : "Show the number")
                        .font(.figtree(.semibold, size: 12.5))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 9)
                        .background(Capsule().strokeBorder(Color.auDivider, lineWidth: 1))
                        .foregroundStyle(Color.auText.opacity(0.58))
                }
                .buttonStyle(.auTap)

                if m.showScore {
                    Text("\(r.score ?? "") — \(r.gate ?? "")")
                        .font(.figtree(.regular, size: 12.5))
                        .lineSpacing(12.5 * 0.55)
                        .foregroundStyle(Color.auText.opacity(0.55))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 11)
                }

                Spacer(minLength: 12)

                HStack(spacing: 12) {
                    APillButton(title: "Try again", variant: .quiet) { m.goto(m.p + 1) }
                    APillButton(title: "Go on") { m.goto(m.p + 1) }
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
                    .lineSpacing(13.5 * 0.55)
                    .foregroundStyle(Color.auText.opacity(0.55))
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
                                    .lineSpacing(12.5 * 0.45)
                                    .foregroundStyle(Color.auText.opacity(0.52))
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
                    APillButton(title: "Skip for now", variant: .quiet) { m.goto(m.p + 1) }
                    APillButton(title: "Start a pick") { m.goto(m.p + 1) }
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
                    .lineSpacing(13.5 * 0.55)
                    .foregroundStyle(Color.auText.opacity(0.55))
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
                                .lineSpacing(9.5 * 0.3)
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

                ACard(radius: 18) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Exported to the scheduler")
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(1.3)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auText.opacity(0.42))
                            .padding(.bottom, 10)
                        ForEach(r.exports ?? [], id: \.self) { e in
                            VStack(alignment: .leading, spacing: 3) {
                                Text(e.first ?? "")
                                    .font(.figtree(.semibold, size: 13))
                                if e.count > 1 {
                                    Text(e[1])
                                        .font(.figtree(.regular, size: 11.5))
                                        .lineSpacing(11.5 * 0.45)
                                        .foregroundStyle(Color.auText.opacity(0.50))
                                }
                            }
                            .padding(.vertical, 8)
                            .overlay(alignment: .top) { Divider().overlay(Color.auDivider) }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                        .foregroundStyle(Color.auText.opacity(0.45))
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
        ScreenColumn(topPad: 26, bottomPad: 26) {
            if case .chapterMap(let c) = m.cur?.screen.payload {
                AUIcon(kind: .check, size: 34, color: .auOkText)
                    .frame(width: 76, height: 76)
                    .background(Circle().fill(Color.auOkBg))
                    .padding(.bottom, 20)

                Text(c.head ?? "")
                    .font(.caprasimo(size: 31))
                    .tracking(-0.68)
                    .lineSpacing(31 * 0.15)
                    .padding(.bottom, 12)

                Text(c.body ?? "")
                    .font(.figtree(.regular, size: 15))
                    .lineSpacing(15 * 0.6)
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
                    ForEach(Array((c.chapters ?? []).enumerated()), id: \.offset) { k, entry in
                        let done = k < (m.cur?.chapterIdx ?? 0) + 1 && k <= (m.cur?.chapterIdx ?? 0)
                        let locked = k > (m.cur?.chapterIdx ?? 0)
                        HStack(spacing: 12) {
                            Circle()
                                .strokeBorder(
                                    done
                                        ? Color.auOkText
                                        : (locked ? Color.auText.opacity(0.38) : Color.auAccent),
                                    lineWidth: 1.5
                                )
                                .frame(width: 26, height: 26)
                                .overlay {
                                    if done {
                                        AUIcon(kind: .check, size: 13, color: .auOkText)
                                    } else if locked {
                                        AUIcon(kind: .lock, size: 12, color: .auText.opacity(0.38))
                                    }
                                }
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Chapter \(entry.n)")
                                    .font(.figtree(.bold, size: 9))
                                    .tracking(1.1)
                                    .opacity(0.7)
                                Text(entry.t)
                                    .font(.figtree(.regular, size: 14))
                                    .lineSpacing(14 * 0.35)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 13)
                        .background(
                            RoundedRectangle(cornerRadius: 17, style: .continuous)
                                .fill(done ? Color.auOkBg : .clear)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 17, style: .continuous)
                                .strokeBorder(done ? Color.auEdge : Color.auEdge, lineWidth: 1)
                        )
                        .foregroundStyle(done ? Color.auOkText : Color.auText)
                    }
                }

                Spacer(minLength: 12)

                Text("Next: \(c.next ?? "")")
                    .font(.figtree(.regular, size: 14))
                    .lineSpacing(14 * 0.5)
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
