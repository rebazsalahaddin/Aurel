import SwiftUI

// MARK: - Core lesson screens
//
// Promise · Hook · Orientation · Pause · Cards (+letterCards/numbers) ·
// Alphabet — ported from CourseScreen.dc.html lines 96–292.

// MARK: Promise (S01)

struct PromiseScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 0, bottomPad: 28, hPad: 0) {
            if case .promise(let p) = m.cur?.screen.payload {
                IllustrationPlaceholder(
                    ill: p.ill ?? IllustrationRef(id: "", alt: ""),
                    aspectRatio: 16.0 / 9.0,
                    kickerSize: 9,
                    captionSize: 12.5,
                    fullBleed: true
                )

                VStack(alignment: .leading, spacing: 0) {
                    Text(p.newTodayLabel?.uppercased() ?? "NEW WORDS TODAY")
                        .font(.figtree(.bold, size: 9.5))
                        .tracking(1.43)
                        .foregroundStyle(Color.auTextTertiary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 6)

                    Text(p.newToday ?? "")
                        .font(.caprasimo(size: 22))
                        .auHeadLine(22, 1.35)
                        .tracking(-0.22)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 22)

                    ForEach(Array((p.canDos ?? []).enumerated()), id: \.offset) { i, t in
                        HStack(spacing: 14) {
                            Circle()
                                .strokeBorder(Color.auAccent.opacity(0.45), lineWidth: 2)
                                .frame(width: 26, height: 26)
                            Text(t)
                                .font(.figtree(.regular, size: 16.5))
                                .auLine(16.5, 1.4)
                        }
                        .padding(.bottom, 14)
                        .auStagger(i)
                    }

                    Button {
                        AUFeedback.press()
                        m.goto(m.p + 1)
                    } label: {
                        HStack(spacing: 10) {
                            PingDot()
                            Text("Tap anywhere to go on")
                                .font(.figtree(.semibold, size: 13.5))
                                .lineLimit(1)
                                .minimumScaleFactor(0.9)
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.auAccentText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                    }
                    .buttonStyle(.auTap)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 2)
                    .accessibilityIdentifier("au.player.go-on")
                }
                .padding(.horizontal, 22)
                .padding(.top, 24)
                .frame(maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            AUFeedback.press()
            m.goto(m.p + 1)
        }
    }
}

// MARK: Hook

struct HookScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 22, bottomPad: 28) {
            if case .hook(let h) = m.cur?.screen.payload {
                if let lead = h.lead {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("This chapter")
                            .font(.figtree(.bold, size: 8.5))
                            .tracking(1.5)
                            .textCase(.uppercase)
                            .opacity(0.75)
                        Text(lead)
                            .font(.figtree(.regular, size: 13))
                            .auLine(13, 1.55)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 13)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.auTintBg)
                    )
                    .foregroundStyle(Color.auTintText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 14)
                }

                IllustrationPlaceholder(
                    ill: h.ill ?? IllustrationRef(id: "", alt: ""),
                    aspectRatio: 16.0 / 9.0,
                    captionSize: 12
                )
                .padding(.bottom, 18)

                HStack(spacing: 14) {
                    Button {
                        m.plays += 1
                        m.speak(
                            (h.lines ?? []).map(\.t).joined(separator: ". "),
                            audio: h.aud)
                    } label: {
                        AUIcon(kind: .ear, size: 30, color: .auPrimaryButtonText)
                            .frame(width: 66, height: 66)
                            .background(Circle().fill(Color.auAccentRamp(600)))
                            .overlay {
                                if m.plays == 0 { PingRingStroke().frame(width: 66, height: 66) }
                            }
                            .shadow(
                                color: Color(UIColor(hex: 0x643312)).opacity(0.6), radius: 8, y: -2)
                    }
                    .buttonStyle(.auTap)
                    .accessibilityLabel("Listen")

                    VStack(alignment: .leading, spacing: 3) {
                        Text("Listen.")
                            .font(.figtree(.semibold, size: 15))
                        Text("Listen and read along.")
                            .font(.figtree(.regular, size: 12))
                            .auLine(12, 1.45)
                            .foregroundStyle(Color.auTextSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Button {
                        m.plays += 1
                        m.speak(
                            (h.lines ?? []).map(\.t).joined(separator: ". "),
                            audio: h.aud, slow: true)
                    } label: {
                        AUIcon(kind: .loop, size: 17)
                            .frame(width: 40, height: 40)
                            .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
                    }
                    .buttonStyle(.auTap)
                    .accessibilityLabel("Play again")
                    .accessibilityIdentifier("au.player.replay")
                }
                .padding(.bottom, 18)

                VStack(spacing: 9) {
                    ForEach(Array((h.lines ?? []).enumerated()), id: \.offset) { i, l in
                        let learner = l.sp == "YOU"
                        HStack(alignment: .top, spacing: 10) {
                            Text(l.sp)
                                .font(.figtree(.bold, size: 9.5))
                                .tracking(1)
                                .frame(width: 42, alignment: .leading)
                                .padding(.top, 3)
                                .foregroundStyle(
                                    learner ? Color.auTintText : Color.auAccentText)
                            Text(l.t)
                                .font(.figtree(.regular, size: 15))
                                .auLine(15, 1.4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 13)
                        .padding(.vertical, 11)
                        .background(
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(learner ? Color.auTintBg : Color.auFill)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .strokeBorder(
                                    learner ? Color.auAccent.opacity(0.30) : Color.auEdge,
                                    lineWidth: 1)
                        )
                        .auStagger(i)
                    }
                }
                .padding(.bottom, 16)

                Spacer(minLength: 12)

                GoOnButton(label: "Start the lesson") { m.goto(m.p + 1) }
            }
        }
    }
}

// MARK: Orientation

struct OrientationScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 24) {
            if case .orientation(let o) = m.cur?.screen.payload {
                let demos = o.demos ?? []
                let demo =
                    demos.indices.contains(m.demo)
                    ? demos[m.demo] : DemoEntry(icon: "tap", word: "", demo: "")

                HStack(spacing: 6) {
                    ForEach(0..<max(1, demos.count), id: \.self) { k in
                        Capsule()
                            .fill(k <= m.demo ? Color.auAccent : Color.auText.opacity(0.12))
                            .frame(height: 4)
                    }
                }
                .padding(.bottom, 22)

                ACard(radius: 26, padded: false) {
                    VStack(spacing: 0) {
                        AUIcon(
                            kind: AUIcon.Kind(rawIcon: demo.icon) ?? .tap, size: 46,
                            color: .auTintText
                        )
                        .frame(width: 98, height: 98)
                        .background(Circle().fill(Color.auTintBg))
                        .overlay(PingRingStroke().frame(width: 98, height: 98))
                        .padding(.bottom, 22)

                        Text(demo.word)
                            .font(.caprasimo(size: 34))
                            .tracking(-0.51)
                            .padding(.bottom, 12)

                        Text(learnerGuidance(for: demo.icon))
                            .font(.figtree(.regular, size: 13.5))
                            .auLine(13.5, 1.55)
                            .foregroundStyle(Color.auTextSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    .padding(.top, 30)
                    .padding(.bottom, 26)
                }

                Button {
                    m.tried = true
                } label: {
                    Text(m.tried ? "Nice — that is it" : "Try it once")
                        .font(.figtree(.semibold, size: 15))
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 78)
                        .background(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(Color.auTintBg)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .strokeBorder(
                                    Color.auAccent.opacity(0.4),
                                    style: StrokeStyle(lineWidth: 1.5, dash: [6, 5]))
                        )
                        .foregroundStyle(Color.auTintText)
                }
                .buttonStyle(.auTap)
                .padding(.top, 22)

                Text("Watch, then try once. You cannot get this wrong.")
                    .font(.figtree(.regular, size: 11.5))
                    .auLine(11.5, 1.5)
                    .foregroundStyle(Color.auTextTertiary)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 14)

                Spacer(minLength: 12)

                GoOnButton(label: m.demo + 1 < demos.count ? "Next" : "Start the lesson") {
                    if m.demo + 1 < demos.count {
                        m.demo += 1
                        m.tried = false
                    } else {
                        m.goto(m.p + 1)
                    }
                }
            }
        }
    }

    private func learnerGuidance(for icon: String) -> String {
        switch icon {
        case "ear": String(localized: "Tap to hear the audio again.")
        case "eye": String(localized: "Look closely at the scene.")
        case "choose": String(localized: "Choose the answer that matches the scene.")
        case "mouth": String(localized: "Listen, match, and say it aloud.")
        default: String(localized: "Tap the control to try it.")
        }
    }
}

// MARK: Pause

struct PauseScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 0, bottomPad: 30, hPad: 0) {
            if case .pause(let p) = m.cur?.screen.payload {
                IllustrationPlaceholder(
                    ill: p.ill ?? IllustrationRef(id: "", alt: ""),
                    height: 300,
                    aspectRatio: m.cur?.chapter.n == 1 ? 16.0 / 9.0 : nil,
                    captionSize: 12,
                    fullBleed: true
                )

                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 9) {
                        ForEach(
                            m.rings(p.rings ?? 3, p.ringsFilled ?? 0).enumerated(), id: \.offset
                        ) { _, r in
                            Circle()
                                .strokeBorder(
                                    r.on ? Color.auAccent2Ramp(500) : Color.auText.opacity(0.2),
                                    lineWidth: 2
                                )
                                .background(Circle().fill(r.on ? Color.auOkBg : .clear))
                                .overlay {
                                    if r.on { AUIcon(kind: .check, size: 11, color: .auOkText) }
                                }
                                .frame(width: 22, height: 22)
                        }
                    }
                    .padding(.bottom, 18)

                    Text(p.head ?? "")
                        .font(.caprasimo(size: 27))
                        .tracking(-0.49)
                        .auHeadLine(27, 1.2)
                        .padding(.bottom, 12)

                    Text(p.body ?? "")
                        .font(.figtree(.regular, size: 15))
                        .auLine(15, 1.6)
                        .foregroundStyle(Color.auText.opacity(0.62))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer(minLength: 16)

                    HStack(spacing: 12) {
                        APillButton(title: "Take a break", variant: .quiet, player: true) {
                            m.goto(m.p + 1)
                        }
                        APillButton(title: "Go on", player: true) { m.goto(m.p + 1) }
                    }

                    Text("Progress saved automatically.")
                        .font(.figtree(.regular, size: 11.5))
                        .foregroundStyle(Color.auTextTertiary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 13)
                }
                .padding(.horizontal, 22)
                .padding(.top, 24)
                .frame(maxHeight: .infinity, alignment: .topLeading)
            }
        }
    }
}

// MARK: Cards (cards · letterCards · numbers)

struct CardsScreenView: View {
    let m: PlayerModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ScreenColumn(topPad: 20, bottomPad: 26) {
            let cards = m.cardList
            let card = m.card
            let chapterOne = m.cur?.chapter.n == 1
            let isTargetRecording = m.say.recording && m.say.activeTarget == card.main
            let rec = m.say.record(for: card.main)

            if case .cards(let content) = m.cur?.screen.payload,
                let pulses = content.meaningPulses, !pulses.isEmpty, !m.learningComplete
            {
                MeaningPulseSequenceView(m: m, pulses: pulses)
            } else {

            // chip + count row
            HStack(spacing: 9) {
                if case .cards(let c) = m.cur?.screen.payload, let chip = c.chip {
                    Text(chip)
                        .font(.figtree(.semibold, size: 11))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.auTintBg))
                        .foregroundStyle(Color.auTintText)
                } else if case .numbers(let n) = m.cur?.screen.payload, let chip = n.chip {
                    Text(chip)
                        .font(.figtree(.semibold, size: 11))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.auTintBg))
                        .foregroundStyle(Color.auTintText)
                } else if case .letterCards(let lc) = m.cur?.screen.payload, let chip = lc.chip {
                    Text(chip)
                        .font(.figtree(.semibold, size: 11))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.auTintBg))
                        .foregroundStyle(Color.auTintText)
                }
                Spacer()
                if !cards.isEmpty {
                    AUProgressCounter(current: m.c + 1, total: cards.count)
                }
            }
            .padding(.bottom, 14)

            // strength strip
            if case .cards(let c) = m.cur?.screen.payload, let strip = c.strengthStrip {
                HStack(spacing: 6) {
                    ForEach(strip, id: \.self) { t in
                        let on = t == card.main
                        Text(t)
                            .font(.figtree(.semibold, size: 11))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: 11).fill(
                                    on ? Color.auTintBg : .clear)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 11).strokeBorder(
                                    on ? Color.auAccent.opacity(0.34) : Color.auEdge, lineWidth: 1)
                            )
                            .foregroundStyle(on ? Color.auTintText : Color.auText.opacity(0.45))
                    }
                }
                .padding(.bottom, 14)
            } else if case .numbers(let n) = m.cur?.screen.payload, let strip = n.strip {
                HStack(spacing: 6) {
                    ForEach(strip, id: \.self) { t in
                        let on = t == card.digit
                        Text(t)
                            .font(.figtree(.semibold, size: 11))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: 11).fill(
                                    on ? Color.auTintBg : .clear)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 11).strokeBorder(
                                    on ? Color.auAccent.opacity(0.34) : Color.auEdge, lineWidth: 1)
                            )
                            .foregroundStyle(on ? Color.auTintText : Color.auText.opacity(0.45))
                    }
                }
                .padding(.bottom, 14)
            }

            if let ill = card.ill {
                IllustrationPlaceholder(
                    ill: ill,
                    height: 224,
                    aspectRatio: chapterOne ? 16.0 / 9.0 : nil,
                    cornerRadius: 24,
                    captionSize: 11.5
                )
                .padding(.bottom, 18)
            }

            // the card itself
            ACard(radius: 26, padded: false, glass: chapterOne) {
                VStack(spacing: 0) {
                    if card.chunk {
                        HStack(spacing: 6) {
                            AUIcon(kind: .link, size: 12, color: .auFlatText)
                            Text("say it as one thing")
                        }
                        .font(.figtree(.semibold, size: 10))
                        .tracking(0.8)
                        .textCase(.uppercase)
                        .padding(.horizontal, 11)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(Color.auFlatBg))
                        .foregroundStyle(Color.auFlatText)
                        .padding(.bottom, 10)
                    }

                    Text(card.main)
                        .font(.caprasimo(size: 34))
                        .tracking(-0.68)
                        .auHeadLine(34, 1.15)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 9)

                    if !card.ipa.isEmpty {
                        Text(card.ipa)
                            .font(.figtree(.regular, size: 13))
                            .tracking(0.26)
                            .foregroundStyle(Color.auAccentText)
                            .padding(.bottom, 10)
                    }

                    if !card.sub.isEmpty {
                        Text(card.moment.isEmpty ? card.sub : card.moment)
                            .font(.figtree(.regular, size: 12.3))
                            .auLine(12.3, 1.5)
                            .foregroundStyle(Color.auTextSecondary)
                            .multilineTextAlignment(.center)
                    }

                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 22)
                .padding(.vertical, 24)
            }
            .padding(.bottom, 16)

            // Listen + Say it
            HStack(spacing: 12) {
                Button {
                    m.plays += 1
                    m.speak(card.main, audio: card.aud, slow: m.plays > 1)
                } label: {
                    HStack(spacing: 9) {
                        AUIcon(kind: .ear, size: 24, color: .auPrimaryButtonText)
                        Text("Listen")
                    }
                    .font(.figtree(.semibold, size: 14.5))
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 62)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous).fill(
                            Color.auAccentRamp(600))
                    )
                    .foregroundStyle(Color.auPrimaryButtonText)
                }
                .buttonStyle(.auTap)

                Button {
                    m.say.toggle(target: card.main)
                } label: {
                    ZStack {
                        if isTargetRecording {
                            RecordingRing().frame(width: 54, height: 54)
                        }
                        HStack(spacing: 9) {
                            AUIcon(kind: .mouth, size: 22)
                            Text(
                                isTargetRecording
                                    ? "Listening…" : (rec.takes == 0 ? "Say it" : "Recorded"))
                        }
                        .font(.figtree(.semibold, size: 14.5))
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 62)
                        .background {
                            if isTargetRecording {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(Color.auAccent2Ramp(600))
                            } else if !chapterOne {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(Color.auFill)
                            }
                        }
                        .overlay {
                            if !chapterOne || isTargetRecording {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .strokeBorder(Color.auEdge, lineWidth: 1)
                            }
                        }
                        .auPracticeGlass(
                            in: RoundedRectangle(cornerRadius: 20, style: .continuous),
                            enabled: chapterOne && !isTargetRecording,
                            interactive: true
                        )
                    }
                }
                .buttonStyle(.auTap)
            }
            .padding(.bottom, 14)

            if m.rec > 0 {
                WaveForm(heights: [12, 22, 30, 18, 26, 14, 24, 10, 20], color: .auAccent)
                    .frame(height: 34)
                    .padding(.bottom, 10)
            }

            if case .cards(let c) = m.cur?.screen.payload, let spoken = c.spoken {
                ACard(radius: 16, glass: chapterOne) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(spoken.said)
                            .font(.figtree(.regular, size: 14))
                        Text(spoken.written)
                            .font(.figtree(.semibold, size: 13))
                            .foregroundStyle(Color.auAccentText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom, 12)
            }

            if case .cards(let c) = m.cur?.screen.payload, let flow = c.flowDots {
                HStack(spacing: 8) {
                    ForEach(Array(flow.enumerated()), id: \.offset) { k, t in
                        HStack(spacing: 8) {
                            Circle().fill(k <= m.c ? Color.auAccent : Color.auText.opacity(0.15))
                                .frame(width: 11, height: 11)
                            Text(t)
                                .font(.figtree(.semibold, size: 11))
                                .foregroundStyle(Color.auTextSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.bottom, 12)
            }

            Spacer(minLength: 12)

            // dots
            HStack(spacing: 5) {
                ForEach(cards.indices, id: \.self) { k in
                    Capsule()
                        .fill(
                            k == m.c
                                ? Color.auAccent
                                : (k < m.c
                                    ? Color.auAccent.opacity(0.4) : Color.auText.opacity(0.13))
                        )
                        .frame(width: k == m.c ? 18 : 5, height: 5)
                        .animation(
                            AUMotion.animation(
                                .easeOut(duration: 0.3), reduceMotion: reduceMotion),
                            value: m.c)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 14)

            HStack(spacing: 12) {
                Button {
                    m.c = max(0, m.c - 1)
                    m.rec = 0
                } label: {
                    Text("Back")
                        .font(.figtree(.semibold, size: 16.5))
                        .frame(width: 84, height: 54)
                        .background(
                            RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous)
                                .strokeBorder(Color.auDivider, lineWidth: 1))
                }
                .buttonStyle(.auTap)
                .disabled(m.c == 0)
                .opacity(m.c == 0 ? 0.45 : 1)

                APillButton(
                    title: m.c + 1 < cards.count ? "Next card" : "Go on", icon: .arrow, player: true
                ) {
                    if m.c + 1 < cards.count {
                        m.c += 1
                        m.rec = 0
                    } else {
                        m.goto(m.p + 1)
                    }
                }
            }
            }
        }
    }
}

// MARK: Alphabet

struct AlphabetScreenView: View {
    let m: PlayerModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ScreenColumn(topPad: 20, bottomPad: 26, hPad: 20) {
            if case .alphabet(let a) = m.cur?.screen.payload {
                Text(a.head ?? "")
                    .font(.caprasimo(size: 27))
                    .tracking(-0.49)
                    .padding(.bottom, 8)

                Text(a.rule ?? "")
                    .font(.figtree(.regular, size: 14))
                    .auLine(14, 1.55)
                    .foregroundStyle(Color.auText.opacity(0.60))
                    .padding(.bottom, 18)

                // the 26-cell chart, 5 wide
                let names = a.letterNames ?? [:]
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 7), count: 5),
                    spacing: 7
                ) {
                    ForEach(names.keys.sorted(), id: \.self) { letter in
                        let flipped = m.flip[letter] ?? false
                        Button {
                            AUFeedback.cardFlip()
                            withAnimation(reduceMotion ? nil : AUMotion.cardFlip) {
                                m.flip[letter, default: false].toggle()
                            }
                        } label: {
                            VStack(spacing: 2) {
                                Text(flipped ? letter.lowercased() : letter)
                                    .font(.caprasimo(size: 22))
                                    .rotation3DEffect(
                                        .degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                                Text(names[letter] ?? "")
                                    .font(.figtree(.regular, size: 8.5))
                                    .opacity(0.6)
                            }
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous).fill(
                                    flipped ? Color.auTintBg : Color.auFill)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(
                                    flipped ? Color.auAccent.opacity(0.35) : Color.auEdge,
                                    lineWidth: 1)
                            )
                            .foregroundStyle(flipped ? Color.auTintText : Color.auText)
                            .rotation3DEffect(
                                .degrees(flipped && !reduceMotion ? 180 : 0),
                                axis: (x: 0, y: 1, z: 0),
                                perspective: 0.8
                            )
                            .shadow(
                                color: Color.black.opacity(flipped ? 0.08 : 0.03), radius: 4, y: 2)
                        }
                        .buttonStyle(.auTap)
                    }
                }
                .padding(.bottom, 16)

                // families
                ACard(radius: 18, padded: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Four families")
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(1.24)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auTextTertiary)
                            .padding(.bottom, 9)

                        ForEach(a.families ?? [], id: \.n) { f in
                            HStack(spacing: 10) {
                                Text("Family \(f.n)")
                                    .font(.figtree(.semibold, size: 11))
                                    .frame(width: 62, alignment: .leading)
                                    .foregroundStyle(Color.auAccentText)
                                Text(f.letters.joined(separator: " · "))
                                    .font(.figtree(.regular, size: 12.5))
                                    .tracking(0.5)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                AUIcon(kind: .ear, size: 16, color: .auText.opacity(0.5))
                            }
                            .padding(.vertical, 7)
                            .overlay(alignment: .top) { Divider().overlay(Color.auDivider) }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                }
                .padding(.bottom, 14)

                if let note = a.note.learnerFacing {
                    Text(note)
                        .font(.figtree(.regular, size: 11.5))
                        .auLine(11.5, 1.5)
                        .foregroundStyle(Color.auTextTertiary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer(minLength: 12)

                GoOnButton(label: "Letter cards") { m.goto(m.p + 1) }
                    .padding(.top, 16)
            }
        }
    }
}

// MARK: Shared bits

/// The au-wave recording meter.
struct WaveForm: View {
    let heights: [CGFloat]
    var color: Color

    var body: some View {
        HStack(spacing: 4) {
            ForEach(heights, id: \.self) { h in
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: 3, height: h)
                    .modifier(WaveBar())
            }
        }
    }

    private struct WaveBar: ViewModifier {
        @Environment(\.accessibilityReduceMotion) private var reduceMotion
        @State private var low = false
        func body(content: Content) -> some View {
            if reduceMotion {
                content
            } else {
                content
                    .scaleEffect(low ? 0.35 : 1, anchor: .bottom)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                            low = true
                        }
                    }
            }
        }
    }
}

/// The expanding ring used on listen buttons (au-ping).
struct PingRingStroke: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var phase = false

    var body: some View {
        Circle()
            .stroke(Color.auAccent, lineWidth: 2)
            .scaleEffect(phase ? 1.5 : 1)
            .opacity(phase ? 0 : 0.5)
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.easeOut(duration: 2.2).repeatForever(autoreverses: false)) {
                    phase = true
                }
            }
    }
}
