import SwiftUI

// MARK: - Language screens
//
// Review · GrammarModel · PronPerceive · PronProduce · Conversation —
// ported from CourseScreen.dc.html lines 554–798.

// MARK: Review (compact reminder)

struct ReviewScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 22, bottomPad: 26) {
            if case .review(let r) = m.cur?.screen.payload {
                HStack(spacing: 9) {
                    ForEach(m.rings(r.rings ?? 3, r.ringsFilled ?? 0).enumerated(), id: \.offset) {
                        _, ring in
                        Circle()
                            .strokeBorder(
                                ring.on ? Color.auAccent2Ramp(500) : Color.auText.opacity(0.2),
                                lineWidth: 2
                            )
                            .background(Circle().fill(ring.on ? Color.auOkBg : .clear))
                            .overlay {
                                if ring.on { AUIcon(kind: .check, size: 12, color: .auOkText) }
                            }
                            .frame(width: 24, height: 24)
                    }
                }
                .padding(.bottom, 18)

                Text(r.head ?? "")
                    .font(.caprasimo(size: 28))
                    .tracking(-0.56)
                    .auHeadLine(28, 1.2)
                    .padding(.bottom, 14)

                VStack(spacing: 9) {
                    ForEach(r.lines ?? [], id: \.self) { t in
                        HStack(spacing: 11) {
                            Circle()
                                .fill(Color.auOkBg)
                                .frame(width: 19, height: 19)
                                .overlay(AUIcon(kind: .check, size: 11, color: .auOkText))
                            Text(t)
                                .font(.figtree(.regular, size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(.bottom, 18)

                if let gallery = r.gallery {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3),
                        spacing: 8
                    ) {
                        ForEach(gallery, id: \.id) { g in
                            Text(g.w)
                                .font(.figtree(.semibold, size: 12.5))
                                .auLine(12.5, 1.3)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, minHeight: 56)
                                .padding(.horizontal, 7)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous).fill(
                                        Color.auFill)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14).strokeBorder(
                                        Color.auEdge, lineWidth: 1))
                        }
                    }
                    .padding(.bottom, 16)
                }

                if let auds = r.auds {
                    VStack(spacing: 6) {
                        ForEach(auds, id: \.self) { a in
                            HStack(spacing: 9) {
                                AUIcon(kind: .ear, size: 14, color: .auText.opacity(0.46))
                                Text(a)
                            }
                            .font(.figtree(.regular, size: 11.5))
                            .foregroundStyle(Color.auText.opacity(0.46))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.bottom, 14)
                }

                if let keep = r.keepCard {
                    Text(keep)
                        .font(.figtree(.regular, size: 13))
                        .auLine(13, 1.5)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous).fill(
                                Color.auTintBg)
                        )
                        .foregroundStyle(Color.auTintText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 14)
                }

                Spacer(minLength: 12)

                if let next = r.next {
                    Text(next)
                        .font(.figtree(.regular, size: 13.5))
                        .auLine(13.5, 1.5)
                        .foregroundStyle(Color.auText.opacity(0.66))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .strokeBorder(
                                    Color.auAccent.opacity(0.34),
                                    style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
                        )
                        .padding(.bottom, 14)
                }

                GoOnButton(label: "Go on") { m.goto(m.p + 1) }
            }
        }
    }
}

// MARK: Grammar model

struct GrammarScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 20, bottomPad: 26) {
            if case .grammarModel(let g) = m.cur?.screen.payload {
                Text("Notice first · the rule comes after")
                    .font(.figtree(.bold, size: 9.5))
                    .tracking(1.43)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.auAccentText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 12)

                // notice steps — tap to step through
                VStack(spacing: 11) {
                    ForEach(Array((g.notice ?? []).enumerated()), id: \.offset) { k, n in
                        let active = k == m.notice
                        Button {
                            m.notice = min((g.notice ?? []).count - 1, k + 1)
                            m.revealed = k + 1 >= (g.notice ?? []).count - 1
                        } label: {
                            VStack(alignment: .leading, spacing: 9) {
                                HStack(spacing: 9) {
                                    AUIcon(kind: .ear, size: 17, color: .auText.opacity(0.7))
                                    Text(n.task ?? "")
                                        .font(.figtree(.semibold, size: 14))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(n.aud ?? "")
                                        .font(.figtree(.semibold, size: 9.5))
                                        .tracking(0.66)
                                        .opacity(0.5)
                                }
                                ForEach(n.chat ?? [], id: \.t) { c in
                                    HStack(alignment: .top, spacing: 9) {
                                        Text(c.sp)
                                            .font(.figtree(.bold, size: 9))
                                            .tracking(0.72)
                                            .frame(width: 38, alignment: .leading)
                                            .padding(.top, 3)
                                            .opacity(0.6)
                                        Text(c.t)
                                            .font(.figtree(.regular, size: 14))
                                            .auLine(14, 1.4)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 9)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .fill(Color.auText.opacity(0.03))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .strokeBorder(Color.auEdge, lineWidth: 1)
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(active ? Color.auTintBg : Color.auFill)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .strokeBorder(
                                        active ? Color.auAccent.opacity(0.34) : Color.auEdge,
                                        lineWidth: 1.5)
                            )
                        }
                        .buttonStyle(.auTap)
                    }
                }
                .padding(.bottom, 16)

                // records once revealed
                if m.revealed || m.notice >= max(0, (g.notice ?? []).count - 1) {
                    VStack(spacing: 10) {
                        ForEach(g.records ?? [], id: \.id) { r in
                            ACard(radius: 18) {
                                VStack(alignment: .leading, spacing: 9) {
                                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                                        Text(r.id)
                                            .font(.figtree(.bold, size: 9.5))
                                            .tracking(1)
                                            .foregroundStyle(Color.auAccentText)
                                        Text(r.title)
                                            .font(.caprasimo(size: 17))
                                            .tracking(-0.17)
                                    }
                                    Text(r.pattern)
                                        .font(.figtree(.semibold, size: 15))
                                        .auLine(15, 1.45)
                                        .padding(.horizontal, 13)
                                        .padding(.vertical, 11)
                                        .background(
                                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                                .fill(Color.auTintBg)
                                        )
                                        .foregroundStyle(Color.auTintText)
                                    ForEach(r.errs, id: \.self) { e in
                                        HStack(alignment: .firstTextBaseline, spacing: 9) {
                                            Text(e.first ?? "")
                                                .strikethrough()
                                                .foregroundStyle(Color.auErr.opacity(0.85))
                                            Text(e.count > 1 ? e[1] : "")
                                                .foregroundStyle(Color.auText.opacity(0.55))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .font(.figtree(.regular, size: 12))
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }

                if let paradigm = g.paradigm {
                    ACard(radius: 18) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("The pattern · tap a row to hear it")
                                .font(.figtree(.bold, size: 9))
                                .tracking(1.3)
                                .textCase(.uppercase)
                                .foregroundStyle(Color.auAccentText)
                                .padding(.bottom, 8)
                            ForEach(paradigm, id: \.cells) { row in
                                HStack(alignment: .firstTextBaseline, spacing: 8) {
                                    Text(row.cells.count > 0 ? row.cells[0] : "")
                                        .font(.figtree(.semibold, size: 11))
                                        .frame(width: 96, alignment: .leading)
                                        .foregroundStyle(Color.auText.opacity(0.52))
                                    Text(row.cells.count > 1 ? row.cells[1] : "")
                                        .font(.figtree(.regular, size: 12.5))
                                        .opacity(0.6)
                                        .frame(width: 52, alignment: .leading)
                                    Text(row.cells.count > 2 ? row.cells[2] : "")
                                        .font(.figtree(.semibold, size: 13.5))
                                        .foregroundStyle(Color.auAccentText)
                                        .frame(width: 46, alignment: .leading)
                                    Text(row.cells.count > 3 ? row.cells[3] : "")
                                        .font(.figtree(.regular, size: 11.5))
                                        .auLine(11.5, 1.35)
                                        .foregroundStyle(Color.auText.opacity(0.58))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.vertical, 7)
                                .overlay(alignment: .top) { Divider().overlay(Color.auDivider) }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.bottom, 12)
                }

                if let tiles = g.patternTiles, !tiles.isEmpty {
                    CompactFlowChips(tiles: tiles, style: .pattern)
                        .padding(.bottom, 12)
                }

                if let explain = g.explain {
                    Text(explain)
                        .font(.figtree(.regular, size: 13))
                        .auLine(13, 1.55)
                        .foregroundStyle(Color.auText.opacity(0.68))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .strokeBorder(
                                    Color.auAccent.opacity(0.32),
                                    style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                }

                if let more = g.more {
                    Text(more)
                        .font(.figtree(.regular, size: 12))
                        .auLine(12, 1.5)
                        .foregroundStyle(Color.auText.opacity(0.52))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                }

                if let notYet = g.notYet {
                    Text(notYet)
                        .font(.figtree(.regular, size: 11))
                        .auLine(11, 1.5)
                        .foregroundStyle(Color.auText.opacity(0.42))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer(minLength: 12)

                GoOnButton(label: "Practise it") { m.goto(m.p + 1) }
                    .padding(.top, 16)
            }
        }
    }
}

// MARK: Pronunciation — perceive

struct PronPerceiveScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 22, bottomPad: 26) {
            if case .pronPerceive(let p) = m.cur?.screen.payload {
                Text(m.cur?.screen.label ?? "")
                    .font(.caprasimo(size: 25))
                    .tracking(-0.45)
                    .padding(.bottom, 18)

                VStack(spacing: 14) {
                    ForEach(p.items ?? [], id: \.id) { it in
                        ACard(radius: 20, padded: false) {
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(spacing: 9) {
                                    AUIcon(kind: .ear, size: 18, color: .auText.opacity(0.7))
                                    Text(it.instr)
                                        .font(.figtree(.semibold, size: 14.5))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(it.id)
                                        .font(.figtree(.semibold, size: 9.5))
                                        .tracking(0.66)
                                        .opacity(0.45)
                                }
                                .padding(.bottom, 11)

                                if let prompt = it.prompt {
                                    Text(prompt)
                                        .font(.figtree(.regular, size: 14.5))
                                        .auLine(14.5, 1.45)
                                        .padding(.bottom, 12)
                                }

                                HStack(spacing: 9) {
                                    ForEach(it.opts ?? [], id: \.id) { o in
                                        Text(o.text ?? "")
                                            .font(.figtree(.semibold, size: 15))
                                            .frame(maxWidth: .infinity)
                                            .frame(minHeight: 58)
                                            .background(
                                                RoundedRectangle(
                                                    cornerRadius: 16, style: .continuous
                                                ).fill(Color.auFill)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16).strokeBorder(
                                                    Color.auEdge, lineWidth: 1))
                                    }
                                }

                                if let note = it.note {
                                    Text(note)
                                        .font(.figtree(.regular, size: 11.5))
                                        .auLine(11.5, 1.45)
                                        .foregroundStyle(Color.auFlatText)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .fill(Color.auFlatBg)
                                        )
                                        .padding(.top, 11)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 17)
                            .padding(.vertical, 16)
                        }
                    }
                }

                Spacer(minLength: 12)

                GoOnButton(label: "Go on") { m.goto(m.p + 1) }
                    .padding(.top, 18)
            }
        }
    }
}

// MARK: Pronunciation — produce

struct PronProduceScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 22, bottomPad: 26) {
            if case .pronProduce(let p) = m.cur?.screen.payload {
                Text("Say it. Then listen to both.")
                    .font(.caprasimo(size: 25))
                    .tracking(-0.45)
                    .padding(.bottom, 18)

                VStack(spacing: 14) {
                    ForEach(p.items ?? [], id: \.id) { it in
                        ACard(radius: 22, padded: false) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(it.word)
                                    .font(.caprasimo(size: 22))
                                    .tracking(-0.26)
                                    .padding(.bottom, 14)

                                HStack(spacing: 10) {
                                    Text("MODEL")
                                        .font(.figtree(.bold, size: 9))
                                        .tracking(1)
                                        .frame(width: 46, alignment: .leading)
                                        .foregroundStyle(Color.auText.opacity(0.42))
                                    WaveForm(
                                        heights: [10, 20, 26, 14, 22, 12, 18, 24], color: .auAccent
                                    )
                                    .frame(height: 26)
                                    AUIcon(kind: .play, size: 17, color: .auText.opacity(0.6))
                                }
                                .padding(.bottom, 9)

                                HStack(spacing: 10) {
                                    Text("YOU")
                                        .font(.figtree(.bold, size: 9))
                                        .tracking(1)
                                        .frame(width: 46, alignment: .leading)
                                        .foregroundStyle(Color.auText.opacity(0.42))
                                    WaveForm(
                                        heights: [8, 16, 22, 11, 18, 9, 15, 20],
                                        color: Color.auText.opacity(0.24)
                                    )
                                    .frame(height: 26)
                                    AUIcon(kind: .play, size: 17, color: .auText.opacity(0.35))
                                }
                                .padding(.bottom, 13)

                                HStack(spacing: 11) {
                                    Button {
                                        m.rec = m.rec >= 2 ? 0 : m.rec + 1
                                    } label: {
                                        HStack(spacing: 9) {
                                            AUIcon(
                                                kind: .mic, size: 20, color: .auPrimaryButtonText)
                                            Text(
                                                m.rec == 0
                                                    ? "Record"
                                                    : (m.rec == 1 ? "Listening…" : "Recorded"))
                                        }
                                        .font(.figtree(.semibold, size: 14.5))
                                        .frame(maxWidth: .infinity)
                                        .frame(minHeight: 56)
                                        .background(
                                            RoundedRectangle(cornerRadius: 17, style: .continuous)
                                                .fill(Color.auAccentRamp(600))
                                        )
                                        .foregroundStyle(Color.auPrimaryButtonText)
                                    }
                                    .buttonStyle(.auTap)

                                    Button {
                                        m.goto(m.p + 1)
                                    } label: {
                                        Text("Skip")
                                            .font(.figtree(.semibold, size: 14.5))
                                            .frame(maxWidth: .infinity)
                                            .frame(minHeight: 56)
                                            .background(
                                                RoundedRectangle(
                                                    cornerRadius: 17, style: .continuous
                                                ).fill(Color.auFill)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 17).strokeBorder(
                                                    Color.auEdge, lineWidth: 1))
                                    }
                                    .buttonStyle(.auTap)
                                }

                                if let note = it.note {
                                    Text(note)
                                        .font(.figtree(.regular, size: 12.5))
                                        .auLine(12.5, 1.45)
                                        .padding(.horizontal, 13)
                                        .padding(.vertical, 11)
                                        .background(
                                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                                .fill(Color.auTintBg)
                                        )
                                        .foregroundStyle(Color.auTintText)
                                        .padding(.top, 12)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(18)
                        }
                    }
                }

                Spacer(minLength: 12)

                Text("No accent scoring, ever. One actionable note per recording.")
                    .font(.figtree(.regular, size: 11.5))
                    .auLine(11.5, 1.5)
                    .foregroundStyle(Color.auText.opacity(0.40))
                    .frame(maxWidth: .infinity)

                GoOnButton(label: "Go on") { m.goto(m.p + 1) }
                    .padding(.top, 12)
            }
        }
    }
}

// MARK: Conversation

struct ConversationScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 18, bottomPad: 26, hPad: 20) {
            if case .conversation(let c) = m.cur?.screen.payload {
                Text((c.pkg ?? "").uppercased())
                    .font(.figtree(.bold, size: 9.5))
                    .tracking(1.3)
                    .foregroundStyle(Color.auAccentText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 6)

                Text(c.scenario ?? "")
                    .font(.figtree(.regular, size: 12.5))
                    .auLine(12.5, 1.5)
                    .foregroundStyle(Color.auText.opacity(0.55))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 14)

                if let panels = c.panels {
                    HStack(spacing: 6) {
                        ForEach(panels, id: \.self) { p in
                            Text(p)
                                .font(.figtree(.bold, size: 8))
                                .tracking(0.5)
                                .frame(height: 52)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                                        .fill(Color.auTintBg.opacity(0.4))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                                        .strokeBorder(
                                            Color.auAccent.opacity(0.30),
                                            style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
                                )
                                .foregroundStyle(Color.auAccentText)
                                .minimumScaleFactor(0.5)
                        }
                    }
                    .padding(.bottom, 14)
                }

                HStack(spacing: 11) {
                    Button {
                        m.turn = min((c.turns ?? []).count, m.turn + 1)
                        m.plays += 1
                        if (c.turns ?? []).indices.contains(m.turn - 1) {
                            m.speak(c.turns![m.turn - 1].t)
                        }
                    } label: {
                        AUIcon(kind: .play, size: 24, color: .auPrimaryButtonText)
                            .frame(width: 56, height: 56)
                            .background(Circle().fill(Color.auAccentRamp(600)))
                    }
                    .buttonStyle(.auTap)

                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(c.aud ?? "") · \(c.delivery ?? "")")
                            .font(.figtree(.semibold, size: 13.5))
                        Text("Line mode: \(c.lineAud ?? "") — replay any single turn")
                            .font(.figtree(.regular, size: 11.5))
                            .foregroundStyle(Color.auText.opacity(0.45))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Button {
                        m.turn = 1
                    } label: {
                        AUIcon(kind: .loop, size: 17)
                            .frame(width: 40, height: 40)
                            .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
                    }
                    .buttonStyle(.auTap)
                    .accessibilityLabel("Replay")
                }
                .padding(.bottom, 14)

                VStack(spacing: 8) {
                    ForEach(Array((c.turns ?? []).enumerated()), id: \.offset) { k, t in
                        let on = k < m.turn
                        HStack(alignment: .top, spacing: 9) {
                            Text(t.n)
                                .font(.figtree(.bold, size: 8.5))
                                .tracking(0.63)
                                .frame(width: 22, alignment: .leading)
                                .padding(.top, 4)
                                .foregroundStyle(Color.auText.opacity(0.34))
                            Text(t.sp)
                                .font(.figtree(.bold, size: 9.5))
                                .tracking(0.72)
                                .frame(width: 42, alignment: .leading)
                                .padding(.top, 3)
                                .foregroundStyle(Color.auAccentText)
                            Text(t.t)
                                .font(.figtree(.regular, size: 15))
                                .auLine(15, 1.4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 13)
                        .padding(.vertical, 11)
                        .background(
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(on ? Color.auFill : .clear)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .strokeBorder(
                                    k == m.turn - 1 ? Color.auAccent.opacity(0.40) : Color.auEdge,
                                    lineWidth: 1)
                        )
                        .opacity(on ? 1 : 0.32)
                        .animation(.easeInOut(duration: 0.35), value: m.turn)
                    }
                }

                if let branch = c.branch {
                    ACard(radius: 16) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("The read-back branches")
                                .font(.figtree(.bold, size: 9.5))
                                .tracking(1.3)
                                .textCase(.uppercase)
                                .foregroundStyle(Color.auText.opacity(0.42))
                                .padding(.bottom, 8)
                            ForEach(branch, id: \.self) { t in
                                HStack(alignment: .firstTextBaseline, spacing: 8) {
                                    Text("→")
                                        .foregroundStyle(Color.auAccent)
                                    Text(t)
                                }
                                .font(.figtree(.regular, size: 12))
                                .auLine(12, 1.45)
                                .foregroundStyle(Color.auText.opacity(0.62))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.top, 14)
                }

                if let lock = c.lock {
                    HStack(spacing: 9) {
                        AUIcon(kind: .lock, size: 14, color: .auText.opacity(0.44))
                        Text(lock)
                    }
                    .font(.figtree(.regular, size: 11.5))
                    .foregroundStyle(Color.auText.opacity(0.44))
                    .padding(.top, 14)
                }

                Spacer(minLength: 12)

                GoOnButton(label: "Go on") { m.goto(m.p + 1) }
                    .padding(.top, 16)
            }
        }
    }
}
