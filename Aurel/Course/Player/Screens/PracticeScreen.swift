import SwiftUI

// MARK: - Practice screen
//
// practice · quiz · testlet · warmup · reading — one renderer (lines 294–552),
// with the authored retry ladder: neutral miss → hint 1 → hint 2 → reveal.

struct PracticeScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 18, bottomPad: 26) {
            // item progress rail
            let list = m.items
            HStack(spacing: 5) {
                ForEach(list.indices, id: \.self) { k in
                    Capsule()
                        .fill(
                            k < m.i
                                ? Color.auAccent
                                : (k == m.i
                                    ? Color.auAccent.opacity(0.55) : Color.auText.opacity(0.12))
                        )
                        .frame(height: 4)
                }
                Text("\(m.i + 1) / \(list.count)")
                    .font(.figtree(.semibold, size: 10))
                    .foregroundStyle(Color.auText.opacity(0.40))
                    .padding(.leading, 7)
            }
            .padding(.bottom, 16)
            .animation(.easeInOut(duration: 0.3), value: m.i)

            rungHeader
            groups
            teachBlock
            profiles
            badges
            cardBlock
            formBlock

            if let item = m.item {
                itemView(item)
            }

            Spacer(minLength: 12)

            unlockNote
            pauseCard

            if let item = m.item {
                let canGo = m.done || m.isQuiet
                APillButton(
                    title: m.i + 1 < list.count ? "Next" : "Go on", icon: .arrow, disabled: !canGo
                ) {
                    m.advance()
                }
                .opacity(canGo ? 1 : 0.45)
            }
        }
    }

    // MARK: rung (testlet) + groups

    @ViewBuilder
    private var rungHeader: some View {
        if case .testlet(let t) = m.cur?.screen.payload {
            if let rung = t.rung {
                HStack(spacing: 9) {
                    Text(rung)
                        .font(.figtree(.bold, size: 9.5))
                        .tracking(1.14)
                    if let support = t.support {
                        Text(support)
                            .font(.figtree(.regular, size: 11.5))
                            .lineSpacing(11.5 * 0.45)
                    }
                }
                .padding(.horizontal, 13)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color.auFlatBg)
                )
                .foregroundStyle(Color.auFlatText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 14)
            }
        }
    }

    @ViewBuilder
    private var groups: some View {
        if case .testlet(let t) = m.cur?.screen.payload, let groups = t.groups {
            VStack(spacing: 7) {
                ForEach(groups, id: \.n) { g in
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text(g.n)
                                .font(.figtree(.bold, size: 9.5))
                                .tracking(1.05)
                                .foregroundStyle(Color.auAccentText)
                            Text(g.stim)
                                .font(.figtree(.regular, size: 12))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(g.ids ?? "")
                                .font(.figtree(.semibold, size: 9))
                                .opacity(0.45)
                        }
                        Text(g.note ?? "")
                            .font(.figtree(.regular, size: 11))
                            .lineSpacing(11 * 0.45)
                            .foregroundStyle(Color.auText.opacity(0.48))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 13)
                    .padding(.vertical, 11)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(
                                Color.auAccent.opacity(0.30),
                                style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
                    )
                }
            }
            .padding(.bottom, 15)
        }
    }

    // MARK: teach block (folded grammar model)

    @ViewBuilder
    private var teachBlock: some View {
        if case .practice(let pr) = m.cur?.screen.payload, let teach = pr.teach {
            ACard(radius: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 9) {
                        Text("Notice first · the rule comes after")
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(1.4)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auAccentText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Button {
                            m.teachShut.toggle()
                        } label: {
                            Text(m.teachShut ? "Show the model" : "Hide the model")
                                .font(.figtree(.semibold, size: 10.5))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Capsule().strokeBorder(Color.auEdge, lineWidth: 1))
                                .foregroundStyle(Color.auText.opacity(0.60))
                        }
                        .buttonStyle(.auTap)
                    }

                    if !m.teachShut {
                        if let ill = teach.ill {
                            IllustrationPlaceholder(
                                ill: ill, height: 120, cornerRadius: 16, kickerSize: 8.5,
                                captionSize: 10.5
                            )
                            .padding(.bottom, 12)
                        }

                        ForEach(teach.notice ?? [], id: \.task) { n in
                            VStack(alignment: .leading, spacing: 7) {
                                HStack(spacing: 8) {
                                    AUIcon(kind: .ear, size: 15, color: .auText.opacity(0.7))
                                    Text(n.task ?? "")
                                        .font(.figtree(.semibold, size: 13))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(n.aud ?? "")
                                        .font(.figtree(.semibold, size: 9))
                                        .tracking(0.54)
                                        .opacity(0.45)
                                }
                                ForEach(n.chat ?? [], id: \.t) { c in
                                    HStack(alignment: .top, spacing: 8) {
                                        Text(c.sp)
                                            .font(.figtree(.bold, size: 8.5))
                                            .tracking(0.64)
                                            .frame(width: 36, alignment: .leading)
                                            .padding(.top, 3)
                                            .opacity(0.6)
                                        Text(c.t)
                                            .font(.figtree(.regular, size: 13))
                                            .lineSpacing(13 * 0.4)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.horizontal, 11)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(Color.auText.opacity(0.03))
                                    )
                                }
                            }
                            .padding(.bottom, 11)
                        }

                        if let tiles = teach.patternTiles, !tiles.isEmpty {
                            FlowTiles(tiles: tiles)
                                .padding(.bottom, 10)
                        }

                        ForEach(teach.records ?? [], id: \.id) { r in
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(r.id) · \(r.title)")
                                    .font(.figtree(.bold, size: 9))
                                    .tracking(1)
                                    .opacity(0.75)
                                Text(r.pattern)
                                    .font(.figtree(.semibold, size: 14))
                                    .lineSpacing(14 * 0.45)
                                ForEach(r.errs, id: \.self) { e in
                                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                                        Text(e.first ?? "")
                                            .strikethrough()
                                        Text(e.count > 1 ? e[1] : "")
                                    }
                                    .font(.figtree(.regular, size: 11.5))
                                    .opacity(0.9)
                                }
                            }
                            .padding(.horizontal, 13)
                            .padding(.vertical, 11)
                            .background(
                                RoundedRectangle(cornerRadius: 13, style: .continuous).fill(
                                    Color.auTintBg)
                            )
                            .foregroundStyle(Color.auTintText)
                            .padding(.bottom, 9)
                        }

                        if let explain = teach.explain {
                            Text(explain)
                                .font(.figtree(.regular, size: 12.5))
                                .lineSpacing(12.5 * 0.5)
                                .foregroundStyle(Color.auText.opacity(0.62))
                        }

                        ForEach([teach.notYet].compactMap { $0 }, id: \.self) { note in
                            Text(note)
                                .font(.figtree(.regular, size: 11))
                                .lineSpacing(11 * 0.5)
                                .foregroundStyle(Color.auText.opacity(0.44))
                                .padding(.top, 8)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 16)
        }
    }

    // MARK: reading profiles

    @ViewBuilder
    private var profiles: some View {
        if case .reading(let r) = m.cur?.screen.payload, let profiles = r.profiles {
            VStack(spacing: 9) {
                ForEach(profiles, id: \.n) { p in
                    ACard(radius: 17) {
                        VStack(alignment: .leading, spacing: 9) {
                            HStack(spacing: 10) {
                                Text(p.ill?.id ?? "")
                                    .font(.figtree(.bold, size: 7.5))
                                    .frame(width: 44, height: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(Color.auAccent.opacity(0.06))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .strokeBorder(
                                                Color.auAccent.opacity(0.34),
                                                style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
                                    )
                                    .foregroundStyle(Color.auTintText)
                                    .minimumScaleFactor(0.5)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(p.n)
                                        .font(.figtree(.bold, size: 10))
                                        .tracking(1.3)
                                        .foregroundStyle(Color.auAccentText)
                                    Text(p.ill?.alt ?? "")
                                        .font(.figtree(.regular, size: 10.5))
                                        .lineSpacing(10.5 * 0.4)
                                        .foregroundStyle(Color.auText.opacity(0.48))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            ForEach(p.rows, id: \.self) { row in
                                HStack(alignment: .firstTextBaseline, spacing: 10) {
                                    Text(row.first ?? "")
                                        .font(.figtree(.bold, size: 8.5))
                                        .tracking(1)
                                        .frame(width: 78, alignment: .leading)
                                        .foregroundStyle(Color.auText.opacity(0.42))
                                    Text(row.count > 1 ? row[1] : "")
                                        .font(.figtree(.regular, size: 13.5))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.vertical, 5)
                                .overlay(alignment: .top) { Divider().overlay(Color.auDivider) }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(.bottom, 14)
        }
    }

    // MARK: name badges

    @ViewBuilder
    private var badges: some View {
        if case .reading(let r) = m.cur?.screen.payload, r.kind == "badges", let badges = r.badges {
            HStack(spacing: 11) {
                ForEach(badges, id: \.first) { b in
                    ACard(radius: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(b.first)
                                .font(.caprasimo(size: 19))
                                .tracking(-0.19)
                            Text(b.last)
                                .font(.figtree(.regular, size: 14))
                                .foregroundStyle(Color.auText.opacity(0.62))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(.bottom, 16)
        }
    }

    // MARK: welcome card

    @ViewBuilder
    private var cardBlock: some View {
        if case .reading(let r) = m.cur?.screen.payload, r.kind == "card", let lines = r.card {
            ACard(radius: 18) {
                VStack(spacing: 0) {
                    ForEach(lines, id: \.self) { t in
                        Text(t)
                            .font(.caprasimo(size: 21))
                            .tracking(-0.25)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 16)
        }
    }

    // MARK: register form

    @ViewBuilder
    private var formBlock: some View {
        if case .reading(let r) = m.cur?.screen.payload, r.kind == "form", let form = r.form {
            ACard(radius: 18) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(form.title)
                        .font(.figtree(.bold, size: 9.5))
                        .tracking(1.3)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.auAccentText)
                    ForEach(form.rows, id: \.self) { row in
                        HStack(alignment: .firstTextBaseline, spacing: 12) {
                            Text(row.first ?? "")
                                .font(.figtree(.bold, size: 9.5))
                                .tracking(1)
                                .frame(width: 64, alignment: .leading)
                                .foregroundStyle(Color.auText.opacity(0.42))
                            Text(row.count > 1 ? row[1] : "")
                                .font(.figtree(.regular, size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.vertical, 9)
                        .overlay(alignment: .top) { Divider().overlay(Color.auDivider) }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 16)
        }
    }

    // MARK: The item renderer (lines 423–550)

    @ViewBuilder
    private func itemView(_ item: PlayerModel.PlayerItem) -> some View {
        // instruction row
        HStack(spacing: 10) {
            AUIcon(kind: AUIcon.Kind(rawIcon: item.icon) ?? .eye, size: 20, color: .auTintText)
                .frame(width: 38, height: 38)
                .background(Circle().fill(Color.auTintBg))
            Text(item.instr)
                .font(.figtree(.semibold, size: 17))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(item.id)
                .font(.figtree(.semibold, size: 9.5))
                .tracking(0.76)
                .foregroundStyle(Color.auText.opacity(0.34))
        }
        .padding(.bottom, 16)

        if let aud = item.aud {
            Button {
                m.plays += 1
                m.speak(m.speakTextForItem, slow: m.plays > 1)
            } label: {
                HStack(spacing: 13) {
                    AUIcon(kind: .ear, size: 26, color: .auPrimaryButtonText)
                    Text(m.plays == 0 ? "Listen" : (m.plays == 1 ? "Play again" : "Replay used"))
                        .font(.figtree(.semibold, size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(aud)
                        .font(.figtree(.semibold, size: 10))
                        .tracking(0.6)
                        .opacity(0.72)
                }
                .padding(.horizontal, 17)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous).fill(
                        Color.auAccentRamp(600))
                )
                .foregroundStyle(Color.auPrimaryButtonText)
            }
            .buttonStyle(.auTap)
            .padding(.bottom, 14)
        }

        if let ill = item.ill {
            IllustrationPlaceholder(ill: ill, height: 186, cornerRadius: 20, captionSize: 11.5)
                .padding(.bottom, 14)
        }

        if let digit = item.digit {
            Text(digit)
                .font(.caprasimo(size: 62))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 26)
                .background(
                    ACard(radius: 22, padded: false) { EmptyView() }
                )
                .padding(.bottom, 14)
        }

        if let scene = item.scene {
            HStack(alignment: .top, spacing: 10) {
                AUIcon(kind: .play, size: 16, color: .auFlatText.opacity(0.7))
                    .padding(.top, 2)
                Text(scene)
                    .font(.figtree(.regular, size: 13.5))
                    .lineSpacing(13.5 * 0.5)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 13)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.auFlatBg))
            .foregroundStyle(Color.auFlatText)
            .padding(.bottom, 14)
        }

        if let said = item.said {
            HStack(alignment: .top, spacing: 10) {
                Text(said.sp)
                    .font(.figtree(.bold, size: 11))
                    .frame(width: 38, height: 38)
                    .background(Circle().fill(Color.auFlatBg))
                    .foregroundStyle(Color.auFlatText)
                Text(said.t)
                    .font(.figtree(.regular, size: 15.5))
                    .lineSpacing(15.5 * 0.45)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 13)
                    .background(
                        UnevenCorners(bottomTrailing: 5)
                            .fill(Color.auFill)
                    )
                    .overlay(
                        UnevenCorners(bottomTrailing: 5)
                            .stroke(Color.auEdge, lineWidth: 1)
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 16)
        }

        if let prompt = item.prompt {
            Text(prompt)
                .font(.figtree(.regular, size: 16))
                .lineSpacing(16 * 0.45)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 15)
        }

        if item.kind == "speak" {
            speakCard(item)
        } else if item.kind == "order" {
            orderView(item)
        } else if !item.opts.isEmpty {
            optionsView(item, opts: item.opts)
        }

        // digit strip (testlet)
        digitStrip

        // feedback
        if m.sel != nil && !m.isQuiet {
            let ok = m.done && !m.revealed && m.isCorrect(item)
            HStack(alignment: .top, spacing: 10) {
                AUIcon(kind: .check, size: 18, color: ok ? .auOkText : .auErrText)
                    .padding(.top, 1)
                Text(ok ? (item.ok ?? "Correct.") : (item.no ?? "Try again."))
                    .font(.figtree(.regular, size: 14.5))
                    .lineSpacing(14.5 * 0.45)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 13)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous).fill(
                    ok ? Color.auOkBg : Color.auErrBg)
            )
            .foregroundStyle(ok ? Color.auOkText : Color.auErrText)
            .padding(.bottom, 11)
        }

        // hint ladder
        if m.wrong > 0, let hints = item.hints, !hints.isEmpty {
            let idx = min(m.wrong, hints.count) - 1
            HStack(alignment: .top, spacing: 10) {
                Text("Hint \(min(m.wrong, 2))")
                    .font(.figtree(.bold, size: 9.5))
                    .tracking(1)
                    .padding(.top, 3)
                    .foregroundStyle(Color.auAccentText)
                Text(hints[max(0, idx)])
                    .font(.figtree(.regular, size: 13.5))
                    .lineSpacing(13.5 * 0.5)
                    .foregroundStyle(Color.auText.opacity(0.66))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(
                        Color.auAccent.opacity(0.38),
                        style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
            )
            .padding(.bottom, 11)
        }

        if m.wrong > 0, let confusable = item.confusable {
            HStack(spacing: 7) {
                AUIcon(kind: .mouth, size: 14, color: .auTintText)
                Text("Feel it: \(confusable)")
            }
            .font(.figtree(.semibold, size: 12))
            .padding(.horizontal, 13)
            .padding(.vertical, 8)
            .background(Capsule().fill(Color.auTintBg))
            .foregroundStyle(Color.auTintText)
            .padding(.bottom, 11)
        }

        if case .practice(let pr) = m.cur?.screen.payload, pr.chartChip == true {
            Text("A–Z chart · always one tap away")
                .font(.figtree(.semibold, size: 12))
                .padding(.horizontal, 13)
                .padding(.vertical, 8)
                .background(Capsule().strokeBorder(Color.auEdge, lineWidth: 1))
                .foregroundStyle(Color.auText.opacity(0.58))
                .padding(.bottom, 11)
        }
    }

    private var digitStrip: some View {
        Group {
            switch m.cur?.screen.payload {
            case .testlet(let t):
                if let strip = t.digitStrip {
                    HStack(spacing: 5) {
                        ForEach(strip, id: \.self) { d in
                            Text(d)
                                .font(.caprasimo(size: 16))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(
                                        Color.auFill)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10).strokeBorder(
                                        Color.auEdge, lineWidth: 1))
                        }
                    }
                    .padding(.bottom, 12)
                }
            case .practice(let p):
                if let strip = p.digitStrip {
                    HStack(spacing: 5) {
                        ForEach(strip, id: \.self) { d in
                            Text(d)
                                .font(.caprasimo(size: 16))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(
                                        Color.auFill)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10).strokeBorder(
                                        Color.auEdge, lineWidth: 1))
                        }
                    }
                    .padding(.bottom, 12)
                }
            default:
                EmptyView()
            }
        }
    }

    @ViewBuilder
    private var unlockNote: some View {
        if case .testlet(let t) = m.cur?.screen.payload, let unlock = t.unlock {
            HStack(alignment: .top, spacing: 9) {
                AUIcon(kind: .lock, size: 14, color: .auText.opacity(0.44))
                    .padding(.top, 2)
                Text(unlock)
                    .font(.figtree(.regular, size: 11.5))
                    .lineSpacing(11.5 * 0.5)
                    .foregroundStyle(Color.auText.opacity(0.44))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 12)
        }
    }

    @ViewBuilder
    private var pauseCard: some View {
        if case .practice(let pr) = m.cur?.screen.payload, let pc = pr.pauseCard {
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(pc.head)
                        .font(.caprasimo(size: 17))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(pc.at ?? "")
                        .font(.figtree(.semibold, size: 9.5))
                        .tracking(0.8)
                        .opacity(0.7)
                }
                Text(pc.body)
                    .font(.figtree(.regular, size: 12.5))
                    .lineSpacing(12.5 * 0.5)
                HStack(spacing: 9) {
                    Button {
                        m.goto(m.p + 1)
                    } label: {
                        Text("Continue")
                            .font(.figtree(.semibold, size: 13))
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 46)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous).fill(
                                    Color.auAccentRamp(600))
                            )
                            .foregroundStyle(Color.auPrimaryButtonText)
                    }
                    .buttonStyle(.auTap)
                    Button {
                        m.onExit()
                    } label: {
                        Text("Break")
                            .font(.figtree(.semibold, size: 13))
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 46)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .strokeBorder(Color.auAccent.opacity(0.30), lineWidth: 1)
                            )
                            .foregroundStyle(Color.auTintText)
                    }
                    .buttonStyle(.auTap)
                }
                .padding(.top, 11)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color.auTintBg))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Color.auAccent.opacity(0.26), lineWidth: 1)
            )
            .foregroundStyle(Color.auTintText)
            .padding(.bottom, 12)
        }
    }

    // MARK: Speak (lines 460–471)

    @ViewBuilder
    private func speakCard(_ item: PlayerModel.PlayerItem) -> some View {
        VStack(spacing: 0) {
            Text(item.word ?? "")
                .font(.caprasimo(size: 32))
                .tracking(-0.48)
                .padding(.bottom, 18)

            WaveForm(heights: [10, 20, 28, 16, 24, 12, 22], color: Color.auText.opacity(0.26))
                .frame(height: 30)
                .padding(.bottom, 16)

            Button {
                m.rec = m.rec >= 2 ? 0 : m.rec + 1
            } label: {
                AUIcon(kind: .mic, size: 30, color: .auPrimaryButtonText)
                    .frame(width: 74, height: 74)
                    .background(Circle().fill(Color.auAccentRamp(600)))
            }
            .buttonStyle(.auTap)

            Text(
                "\(m.rec == 0 ? "Say it" : (m.rec == 1 ? "Listening…" : "Recorded — play both")) · ungraded"
            )
            .font(.figtree(.semibold, size: 12.5))
            .foregroundStyle(Color.auText.opacity(0.52))
            .padding(.top, 12)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.auFill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color.auEdge, lineWidth: 1)
        )
        .padding(.bottom, 14)

        // below the card
        HStack(spacing: 12) {
            Button {
                m.advance()
            } label: {
                Text("Skip — say it later")
                    .font(.figtree(.semibold, size: 16.5))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(
                        RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous)
                            .strokeBorder(Color.auDivider, lineWidth: 1))
            }
            .buttonStyle(.auTap)
            APillButton(title: "Go on") { m.advance() }
        }
    }

    // MARK: Order items (lines 472–482)

    private func orderView(_ item: PlayerModel.PlayerItem) -> some View {
        let task = m.tileTask

        return VStack(spacing: 0) {
            Text(m.tileLine.isEmpty ? " " : m.tileLine)
                .font(.caprasimo(size: 20))
                .tracking(-0.2)
                .lineSpacing(20 * 0.4)
                .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(
                            Color.auAccent.opacity(0.36),
                            style: StrokeStyle(lineWidth: 1.5, dash: [6, 5]))
                )
                .padding(.bottom, 14)

            FlowTiles(tiles: task.tiles, taken: Set(m.order), onTap: { m.toggleTile($0) })
                .padding(.bottom, 14)

            if m.tileComplete {
                Text(
                    m.tileCorrect
                        ? (task.ok.isEmpty ? "Correct." : task.ok)
                        : (task.no.isEmpty
                            ? "Not yet — tap a tile again to take it back." : task.no)
                )
                .font(.figtree(.regular, size: 14))
                .lineSpacing(14 * 0.45)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
                .padding(.vertical, 13)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(m.tileCorrect ? Color.auOkBg : Color.auErrBg)
                )
                .foregroundStyle(m.tileCorrect ? Color.auOkText : Color.auErrText)
                .padding(.bottom, 11)
            }
        }
    }

    // MARK: Options (lines 483–506)

    private func optionsView(_ item: PlayerModel.PlayerItem, opts: [PracticeOption]) -> some View {
        VStack(spacing: 10) {
            ForEach(Array(opts.enumerated()), id: \.offset) { _, o in
                let picked = m.sel == o.id
                let isKey = item.isKey(o)
                optionRow(o, picked: picked, isKey: isKey, item: item)
                    .accessibilityIdentifier("au.player.option.\(o.id)")
            }
        }
        .padding(.bottom, 14)
    }

    @ViewBuilder
    private func optionRow(
        _ o: PracticeOption, picked: Bool, isKey: Bool, item: PlayerModel.PlayerItem
    ) -> some View {
        let quiet = m.isQuiet
        // state colors (optionViews, lines 1223–1240)
        let bg: Color = {
            if quiet {
                return picked ? Color.auTintBg : Color.auFill
            }
            if m.done && isKey { return .auOkBg }
            if picked && !isKey { return .auErrBg }
            if m.done { return .clear }
            return .auFill
        }()
        let bd: Color = {
            if quiet { return picked ? Color.auAccent : Color.auEdge }
            if m.done && isKey { return .auAccent2 }
            if picked && !isKey { return .auErr }
            return .auEdge
        }()
        let fg: Color = {
            if quiet { return picked ? Color.auTintText : Color.auText }
            if m.done && isKey { return .auOkText }
            if picked && !isKey { return .auErrText }
            if m.done { return Color.auText.opacity(0.42) }
            return .auText
        }()

        Button {
            m.pick(o, item: item)
        } label: {
            HStack(spacing: 12) {
                if let ill = o.ill {
                    VStack(spacing: 4) {
                        Text(ill.id)
                            .font(.figtree(.bold, size: 8.5))
                            .tracking(0.54)
                            .minimumScaleFactor(0.5)
                        Text(ill.alt)
                            .font(.figtree(.regular, size: 12.5))
                            .lineSpacing(12.5 * 0.45)
                    }
                    .frame(width: 200, alignment: .leading)
                } else if let t = o.text {
                    Text(t)
                        .font(.figtree(.regular, size: 16))
                        .lineSpacing(16 * 0.4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                if m.done && isKey && !quiet {
                    AUIcon(kind: .check, size: 19, color: .auOkText)
                } else if picked && !isKey && !quiet && m.done {
                    AUIcon(kind: .loop, size: 17, color: .auErrText)
                }
            }
            .padding(.horizontal, 17)
            .padding(.vertical, 14)
            .frame(minHeight: 62, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 19, style: .continuous)
                    .fill(bg)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 19, style: .continuous)
                    .strokeBorder(bd, lineWidth: 1.5)
            )
            .foregroundStyle(fg)
        }
        .buttonStyle(.auTap)
        .disabled(m.done && !quiet)
    }
}

// MARK: - Small helpers

extension PlayerModel {
    /// feedbackOk — the picked option was the key.
    func isCorrect(_ item: PlayerItem) -> Bool {
        guard let sel else { return false }
        return item.opts.first { $0.id == sel }.map { item.isKey($0) } ?? false
    }
}

/// Wrap layout of tile buttons (tap-to-order chips).
struct FlowTiles: View {
    let tiles: [String]
    var taken: Set<Int> = []
    var onTap: ((Int) -> Void)? = nil

    var body: some View {
        FlowLayout(spacing: 9) {
            ForEach(Array(tiles.enumerated()), id: \.offset) { k, t in
                let on = taken.contains(k)
                Button {
                    onTap?(k)
                } label: {
                    Text(t)
                        .font(.caprasimo(size: 19))
                        .padding(.horizontal, 17)
                        .padding(.vertical, 12)
                        .frame(minHeight: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 15, style: .continuous).fill(
                                on ? Color.auTintBg : Color.auFill)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 15, style: .continuous).strokeBorder(
                                on ? Color.auAccent.opacity(0.34) : Color.auEdge, lineWidth: 1.5)
                        )
                        .foregroundStyle(on ? Color.auTintText : Color.auText)
                }
                .buttonStyle(.auTap)
            }
        }
    }
}

/// A simple wrapping flow layout.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 360
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowH: CGFloat = 0
        for s in subviews {
            let sz = s.sizeThatFits(.unspecified)
            if x > 0 && x + sz.width > width {
                x = 0
                y += rowH + spacing
                rowH = 0
            }
            x += sz.width + spacing
            rowH = max(rowH, sz.height)
        }
        return CGSize(width: width, height: y + rowH)
    }

    func placeSubviews(
        in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()
    ) {
        var x = bounds.minX
        var y = bounds.minY
        var rowH: CGFloat = 0
        for s in subviews {
            let sz = s.sizeThatFits(.unspecified)
            if x > bounds.minX && x + sz.width > bounds.maxX {
                x = bounds.minX
                y += rowH + spacing
                rowH = 0
            }
            s.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(sz))
            x += sz.width + spacing
            rowH = max(rowH, sz.height)
        }
    }
}

/// Speech-bubble border with one small corner.
struct UnevenCorners: Shape {
    var bottomTrailing: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.addRoundedRect(
            in: rect,
            cornerRadii: RectangleCornerRadii(
                topLeading: 18, bottomLeading: 18, bottomTrailing: bottomTrailing, topTrailing: 18
            )
        )
        return p
    }
}
