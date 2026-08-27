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
                        ForEach(Array(auds.enumerated()), id: \.offset) { index, _ in
                            HStack(spacing: 9) {
                                AUIcon(kind: .ear, size: 14, color: .auText.opacity(0.46))
                                Text("Listening set \(index + 1)")
                            }
                            .font(.figtree(.regular, size: 11.5))
                            .foregroundStyle(Color.auTextTertiary)
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

/// Shared meaning-first sequence used by grammar screens, vocabulary bridges,
/// and review clinics. Each pulse is unscored and repeatable; its short pattern
/// stays hidden until the learner identifies the matching person or message.
struct MeaningPulseSequenceView: View {
    let m: PlayerModel
    let pulses: [MeaningPulse]
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        if !pulses.isEmpty {
            let index = min(m.learningStep, pulses.count - 1)
            let pulse = pulses[index]
            let selected = m.learningSelection
            let passed = selected.map { selection in
                selection == pulse.key
                    || pulse.opts.first(where: { $0.id == selection })?.text == pulse.key
            } ?? false

            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 8) {
                    ForEach(pulses.indices, id: \.self) { step in
                        Capsule()
                            .fill(
                                step < index || m.learningComplete
                                    ? Color.auAccent
                                    : (step == index
                                        ? Color.auAccent.opacity(0.55)
                                        : Color.auText.opacity(0.12))
                            )
                            .frame(height: 4)
                    }
                    Text("\(index + 1) / \(pulses.count)")
                        .font(.figtree(.semibold, size: 10.5))
                        .foregroundStyle(Color.auTextTertiary)
                }

                Text(pulse.title)
                    .font(.caprasimo(size: 22))
                    .tracking(-0.3)

                if let ill = pulse.ill {
                    IllustrationPlaceholder(
                        ill: ill, height: 150,
                        aspectRatio: m.cur?.chapter.n == 1 ? 16.0 / 9.0 : nil,
                        cornerRadius: 18, captionSize: 11
                    )
                }

                if let chat = pulse.chat, !chat.isEmpty {
                    ACard(radius: 17) {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(chat, id: \.t) { line in
                                HStack(alignment: .top, spacing: 9) {
                                    Text(line.sp)
                                        .font(.figtree(.bold, size: 9))
                                        .tracking(0.7)
                                        .frame(width: 42, alignment: .leading)
                                        .foregroundStyle(Color.auTextTertiary)
                                    KaraokeText(
                                        text: line.t,
                                        isSpoken: m.playback?.isSpoken(
                                            text: line.t, speaker: line.sp) ?? false,
                                        spokenRange: m.playback?.spokenRange
                                    )
                                    .font(.figtree(.regular, size: 14))
                                    .auLine(14, 1.45)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button {
                        m.speak(
                            chat.map(\.t).joined(separator: " "), audio: pulse.aud,
                            slow: m.plays > 0)
                        m.plays += 1
                    } label: {
                        HStack(spacing: 9) {
                            AUIcon(kind: .ear, size: 18, color: .auPrimaryButtonText)
                            Text(m.plays == 0 ? "Listen" : "Listen again")
                                .font(.figtree(.semibold, size: 13.5))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.auAccentRamp(600))
                        )
                        .foregroundStyle(Color.auPrimaryButtonText)
                    }
                    .buttonStyle(.auTap)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(pulse.instruction)
                        .font(.figtree(.bold, size: 10))
                        .tracking(1.1)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.auAccentText)
                    Text(pulse.prompt)
                        .font(.figtree(.semibold, size: 16))
                        .auLine(16, 1.45)
                    #if AUREL_VERIFICATION
                        Color.clear
                            .frame(width: 1, height: 1)
                            .accessibilityElement()
                            .accessibilityLabel(pulse.id)
                            .accessibilityIdentifier("au.player.fixture.item.\(pulse.id)")
                    #endif
                }

                VStack(spacing: 9) {
                    ForEach(pulse.opts) { option in
                        let isSelected = selected == option.id
                        let optionIsKey = PlayerModel.matchesKey(
                            option, key: pulse.key, opts: pulse.opts)
                        Button {
                            withAnimation(
                                AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion)
                            ) {
                                m.pickLearning(option, key: pulse.key, opts: pulse.opts)
                            }
                        } label: {
                            HStack(spacing: 11) {
                                if isSelected {
                                    AUIcon(
                                        kind: optionIsKey ? .check : .close, size: 16,
                                        color: optionIsKey ? .auOkText : .auErrText
                                    )
                                }
                                Text(option.text ?? option.ill?.alt ?? option.id)
                                    .font(.figtree(.semibold, size: 14))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal, 15)
                            .frame(minHeight: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(
                                        isSelected
                                            ? (optionIsKey ? Color.auOkBg : Color.auErrBg)
                                            : Color.auFill
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .strokeBorder(
                                        isSelected
                                            ? (optionIsKey ? Color.auOkText : Color.auErrText)
                                            : Color.auEdge,
                                        lineWidth: 1
                                    )
                            )
                            .foregroundStyle(
                                isSelected
                                    ? (optionIsKey ? Color.auOkText : Color.auErrText)
                                    : Color.auText
                            )
                        }
                        .buttonStyle(.auTap)
                        // Same a11y-id contract as practice options
                        // (au.player.option.<id>) so UI-test walkers — and any
                        // future driver — can address pulse choices.
                        .accessibilityIdentifier("au.player.option.\(option.id)")
                    }
                }

                if let selected {
                    let selectedIsKey = selected == pulse.key
                        || pulse.opts.first(where: { $0.id == selected })?.text == pulse.key
                    HStack(alignment: .top, spacing: 9) {
                        AUIcon(
                            kind: selectedIsKey ? .check : .loop, size: 17,
                            color: selectedIsKey ? .auOkText : .auErrText
                        )
                        Text(selectedIsKey ? pulse.ok : pulse.no)
                            .font(.figtree(.regular, size: 13))
                            .auLine(13, 1.45)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(selectedIsKey ? Color.auOkBg : Color.auErrBg)
                    )
                    .foregroundStyle(selectedIsKey ? Color.auOkText : Color.auErrText)
                    .accessibilityElement(children: .combine)
                }

                if passed {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(pulse.examples ?? [], id: \.self) { example in
                            Text(example)
                                .font(.figtree(.regular, size: 14))
                                .auLine(14, 1.45)
                        }
                        if let pattern = pulse.pattern {
                            Text(pattern)
                                .font(.figtree(.semibold, size: 15))
                                .auLine(15, 1.45)
                                .padding(.horizontal, 13)
                                .padding(.vertical, 11)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                                        .fill(Color.auTintBg)
                                )
                                .foregroundStyle(Color.auTintText)
                                .transition(.opacity.combined(with: .scale(scale: 0.98)))
                        }
                    }

                    APillButton(
                        title: index + 1 < pulses.count ? "Next example" : "Start practice",
                        icon: .arrow, player: true
                    ) {
                        withAnimation(
                            AUMotion.animation(AUMotion.flow, reduceMotion: reduceMotion)
                        ) {
                            m.advanceLearning(total: pulses.count)
                        }
                    }
                }
            }
            .accessibilityElement(children: .contain)
        }
    }
}

struct GrammarScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 20, bottomPad: 26) {
            if case .grammarModel(let g) = m.cur?.screen.payload {
                if let pulses = g.meaningPulses, !pulses.isEmpty {
                    Text("Look and listen · then choose")
                        .font(.figtree(.bold, size: 9.5))
                        .tracking(1.43)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.auAccentText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 12)

                    MeaningPulseSequenceView(m: m, pulses: pulses)

                    if m.learningComplete {
                        grammarRecap(g)
                            .padding(.top, 16)
                        GoOnButton(label: "Practise it") { m.goto(m.p + 1) }
                            .padding(.top, 16)
                    }
                } else {
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
                            let transcript = (n.chat ?? []).map(\.t).joined(separator: " ")
                            m.speak(
                                transcript.isEmpty ? n.task : transcript,
                                audio: n.aud)
                        } label: {
                            VStack(alignment: .leading, spacing: 9) {
                                HStack(spacing: 9) {
                                    AUIcon(kind: .ear, size: 17, color: .auText.opacity(0.7))
                                    Text(n.task ?? "")
                                        .font(.figtree(.semibold, size: 14))
                                        .frame(maxWidth: .infinity, alignment: .leading)
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
                                                .foregroundStyle(Color.auTextSecondary)
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
                                Button {
                                    let spoken = row.cells.joined(separator: " ")
                                    m.speak(spoken)
                                } label: {
                                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                                        Text(row.cells.count > 0 ? row.cells[0] : "")
                                            .font(.figtree(.semibold, size: 11))
                                            .frame(width: 96, alignment: .leading)
                                            .foregroundStyle(Color.auTextSecondary)
                                        Text(row.cells.count > 1 ? row.cells[1] : "")
                                            .font(.figtree(.regular, size: 12.5))
                                            .opacity(0.65)
                                            .frame(width: 52, alignment: .leading)
                                        Text(row.cells.count > 2 ? row.cells[2] : "")
                                            .font(.figtree(.semibold, size: 13.5))
                                            .foregroundStyle(Color.auAccentText)
                                            .frame(width: 46, alignment: .leading)
                                        Text(row.cells.count > 3 ? row.cells[3] : "")
                                            .font(.figtree(.regular, size: 11.5))
                                            .auLine(11.5, 1.35)
                                            .foregroundStyle(Color.auTextSecondary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.vertical, 7)
                                    .overlay(alignment: .top) { Divider().overlay(Color.auDivider) }
                                }
                                .buttonStyle(.auTap)
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
                        .foregroundStyle(Color.auTextSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                }

                if let notYet = g.notYet {
                    Text(notYet)
                        .font(.figtree(.regular, size: 11))
                        .auLine(11, 1.5)
                        .foregroundStyle(Color.auTextTertiary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer(minLength: 12)

                GoOnButton(label: "Practise it") { m.goto(m.p + 1) }
                    .padding(.top, 16)
                }
            }
        }
    }

    @ViewBuilder
    private func grammarRecap(_ grammar: GrammarModelScreen) -> some View {
        ACard(radius: 18) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Your review")
                    .font(.figtree(.bold, size: 10))
                    .tracking(1.2)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.auAccentText)

                ForEach(grammar.records ?? [], id: \.id) { record in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(record.title)
                            .font(.figtree(.semibold, size: 14))
                        Text(record.pattern)
                            .font(.figtree(.regular, size: 13))
                            .auLine(13, 1.45)
                            .foregroundStyle(Color.auTextSecondary)
                    }
                }

                if let paradigm = grammar.paradigm {
                    ForEach(paradigm, id: \.cells) { row in
                        Button {
                            m.speak(row.cells.last)
                        } label: {
                            Text(row.cells.last ?? "")
                                .font(.figtree(.regular, size: 13))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 5)
                        }
                        .buttonStyle(.auTap)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: Pronunciation — perceive

struct PronPerceiveScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 22, bottomPad: 26) {
            if case .pronPerceive(let p) = m.cur?.screen.payload {
                Text(m.cur?.screen.learnerTitle ?? ScreenKind.pronPerceive.defaultDisplayTitle)
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
                                }
                                .padding(.bottom, 11)

                                if let prompt = it.prompt {
                                    Text(prompt)
                                        .font(.figtree(.regular, size: 14.5))
                                        .auLine(14.5, 1.45)
                                        .padding(.bottom, 12)
                                }

                                if let aud = it.aud {
                                    HStack(spacing: 10) {
                                        Text("MODEL")
                                            .font(.figtree(.bold, size: 9))
                                            .tracking(1)
                                            .frame(width: 46, alignment: .leading)
                                            .foregroundStyle(Color.auTextSecondary)
                                        WaveForm(heights: [10, 20, 26, 14, 22, 12, 18, 24], color: .auAccent)
                                            .frame(height: 26)
                                        Button {
                                            m.speak(Self.perceiveFallbackText(for: it), audio: aud)
                                        } label: {
                                            AUIcon(kind: .play, size: 17, color: .auAccent)
                                        }
                                        .buttonStyle(.auTap)
                                        .accessibilityLabel(Text("Play the model"))
                                    }
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

                                if let note = it.note.learnerFacing {
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

    /// The TTS fallback for a perceive item — the keyed option when the item
    /// carries a key ("the thing you hear"), else the prompt line. `speak`
    /// needs non-empty text even when the catalog asset exists.
    private static func perceiveFallbackText(for it: PronPerceiveItem) -> String {
        let opts = it.opts ?? []
        if let key = it.key?.single,
            let option = opts.first(where: { PlayerModel.matchesKey($0, key: key, opts: opts) }),
            let text = option.text, !text.isEmpty
        {
            return text
        }
        return it.prompt ?? " "
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
                        PronProduceItemCard(m: m, it: it)
                    }
                }

                Spacer(minLength: 12)

                Text("No accent scoring, ever. One actionable note per recording.")
                    .font(.figtree(.regular, size: 11.5))
                    .auLine(11.5, 1.5)
                    .foregroundStyle(Color.auTextSecondary)
                    .frame(maxWidth: .infinity)

                GoOnButton(label: "Go on") { m.goto(m.p + 1) }
                    .padding(.top, 12)
            }
        }
    }
}

private struct PronProduceItemCard: View {
    let m: PlayerModel
    let it: PronProduceItem

    private var isRecording: Bool {
        m.say.recording && m.say.activeTarget == it.word
    }

    private var rec: SayCoach.Record {
        m.say.record(for: it.word)
    }

    var body: some View {
        ACard(radius: 22, padded: false) {
            VStack(alignment: .leading, spacing: 0) {
                KaraokeText(
                    text: it.word,
                    isSpoken: m.playback?.isSpoken(text: it.word) ?? false,
                    spokenRange: m.playback?.spokenRange
                )
                .font(.caprasimo(size: 22))
                    .tracking(-0.26)
                    .padding(.bottom, 14)

                modelRow
                youRow

                if m.say.micDenied {
                    micDeniedNotice
                }

                actionButtons

                if let verdict = rec.verdict {
                    verdictBanner(verdict)
                } else if rec.unavailable {
                    unavailableNotice
                }

                if let note = it.note.learnerFacing {
                    noteCard(note)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18)
        }
    }

    private var modelRow: some View {
        HStack(spacing: 10) {
            Text("MODEL")
                .font(.figtree(.bold, size: 9))
                .tracking(1)
                .frame(width: 46, alignment: .leading)
                .foregroundStyle(Color.auTextSecondary)
            WaveForm(heights: [10, 20, 26, 14, 22, 12, 18, 24], color: .auAccent)
                .frame(height: 26)
            Button {
                m.speak(it.word, audio: it.aud)
            } label: {
                AUIcon(kind: .play, size: 17, color: .auAccent)
            }
            .buttonStyle(.auTap)
        }
        .padding(.bottom, 9)
    }

    private var youRow: some View {
        HStack(spacing: 10) {
            Text("YOU")
                .font(.figtree(.bold, size: 9))
                .tracking(1)
                .frame(width: 46, alignment: .leading)
                .foregroundStyle(Color.auTextSecondary)
            if isRecording || rec.takes > 0 {
                LiveWaveform(
                    samples: isRecording ? m.say.samples : [0.2, 0.4, 0.6, 0.5, 0.3],
                    tint: .auAccent2,
                    barCount: 16
                )
                .frame(height: 26)
            } else {
                WaveForm(
                    heights: [8, 16, 22, 11, 18, 9, 15, 20],
                    color: Color.auText.opacity(0.24)
                )
                .frame(height: 26)
            }
            AUIcon(kind: .play, size: 17, color: .auText.opacity(0.35))
        }
        .padding(.bottom, 13)
    }

    private var micDeniedNotice: some View {
        HStack(spacing: 10) {
            AUIcon(kind: .lock, size: 14, color: .auErrText)
            Text("Microphone is off. Enable in Settings or skip.")
                .font(.figtree(.regular, size: 12))
                .foregroundStyle(Color.auErrText)
        }
        .padding(.bottom, 10)
    }

    private var actionButtons: some View {
        HStack(spacing: 11) {
            Button {
                m.say.toggle(target: it.word)
            } label: {
                ZStack {
                    if isRecording {
                        RecordingRing().frame(width: 50, height: 50)
                    }
                    HStack(spacing: 9) {
                        AUIcon(kind: .mic, size: 20, color: .auPrimaryButtonText)
                        Text(isRecording ? "Listening…" : (rec.takes == 0 ? "Record" : "Try again"))
                    }
                    .font(.figtree(.semibold, size: 14.5))
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 17, style: .continuous)
                            .fill(isRecording ? Color.auAccent2Ramp(600) : Color.auAccentRamp(600))
                    )
                    .foregroundStyle(Color.auPrimaryButtonText)
                }
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
                        RoundedRectangle(cornerRadius: 17, style: .continuous).fill(Color.auFill)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 17).strokeBorder(Color.auEdge, lineWidth: 1)
                    )
            }
            .buttonStyle(.auTap)
        }
    }

    private func verdictBanner(_ verdict: SpeakVerdict.Tier) -> some View {
        let isClear = verdict == .clear
        return HStack(spacing: 8) {
            AUIcon(
                kind: isClear ? .check : .warning,
                size: 14,
                color: isClear ? .auOkText : .auTintText
            )
            Text(
                isClear
                    ? "Clear — this is how it sounds."
                    : (verdict == .near
                        ? "\(rec.matchedWords) of \(rec.totalWords) words matched. Closer each time."
                        : "Somewhere quieter — no score recorded.")
            )
            .font(.figtree(.regular, size: 12.5))
            .foregroundStyle(isClear ? Color.auOkText : Color.auTintText)
        }
        .padding(.horizontal, 13)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .fill(isClear ? Color.auOkBg : Color.auTintBg)
        )
        .padding(.top, 10)
    }

    private var unavailableNotice: some View {
        Text("No clarity check available — your take stands.")
            .font(.figtree(.regular, size: 12))
            .foregroundStyle(Color.auText.opacity(0.65))
            .padding(.top, 8)
    }

    private func noteCard(_ note: String) -> some View {
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

// MARK: Conversation

struct ConversationScreenView: View {
    let m: PlayerModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ScreenColumn(topPad: 18, bottomPad: 26, hPad: 20) {
            if case .conversation(let c) = m.cur?.screen.payload {
                Text(
                    m.cur?.screen.learnerTitle.uppercased()
                        ?? ScreenKind.conversation.defaultDisplayTitle.uppercased()
                )
                .font(.figtree(.bold, size: 9.5))
                .tracking(1.3)
                .foregroundStyle(Color.auAccentText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 6)

                Text(c.scenario ?? "")
                    .font(.figtree(.regular, size: 12.5))
                    .auLine(12.5, 1.5)
                    .foregroundStyle(Color.auTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 14)

                if let panels = c.panels {
                    HStack(spacing: 6) {
                        ForEach(Array(panels.enumerated()), id: \.offset) { index, _ in
                            Text("Scene \(index + 1)")
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
                        m.plays += 1
                        let turns = c.turns ?? []
                        if !turns.isEmpty {
                            m.turn = turns.count
                            m.speak(
                                turns.map(\.t).joined(separator: " "),
                                audio: c.aud ?? c.lineAud)
                        }
                    } label: {
                        AUIcon(kind: .play, size: 24, color: .auPrimaryButtonText)
                            .frame(width: 56, height: 56)
                            .background(Circle().fill(Color.auAccentRamp(600)))
                    }
                    .buttonStyle(.auTap)

                    VStack(alignment: .leading, spacing: 0) {
                        Text("Play the conversation")
                            .font(.figtree(.semibold, size: 13.5))
                        Text("Replay any single turn when you want another listen.")
                            .font(.figtree(.regular, size: 11.5))
                            .foregroundStyle(Color.auTextTertiary)
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
                            KaraokeText(
                                text: t.t,
                                isSpoken: m.playback?.isSpoken(text: t.t, speaker: t.sp) ?? false,
                                spokenRange: m.playback?.spokenRange
                            )
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
                                .strokeBorder(Color.auEdge, lineWidth: 1)
                        )
                        .opacity(on ? 1 : 0.32)
                        .animation(
                            AUMotion.animation(
                                .easeInOut(duration: 0.35), reduceMotion: reduceMotion),
                            value: m.turn)
                    }
                }

                if c.branch != nil {
                    ACard(radius: 16) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Listen for variations")
                                .font(.figtree(.bold, size: 9.5))
                                .tracking(1.3)
                                .textCase(.uppercase)
                                .foregroundStyle(Color.auTextTertiary)
                                .padding(.bottom, 8)
                            Text("The greeting, reply, or closing may change when you replay.")
                                .font(.figtree(.regular, size: 12))
                                .auLine(12, 1.45)
                                .foregroundStyle(Color.auText.opacity(0.62))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.top, 14)
                }

                if c.lock != nil {
                    HStack(spacing: 9) {
                        AUIcon(kind: .lock, size: 14, color: .auText.opacity(0.44))
                        Text("Keep listening to reveal each turn.")
                    }
                    .font(.figtree(.regular, size: 11.5))
                    .foregroundStyle(Color.auTextTertiary)
                    .padding(.top, 14)
                }

                Spacer(minLength: 12)

                GoOnButton(label: "Go on") { m.goto(m.p + 1) }
                    .padding(.top, 16)
            }
        }
    }
}
