import Foundation
import SwiftUI

// MARK: - Practice screen
//
// practice · quiz · testlet · warmup · reading — one renderer (lines 294–552),
// with the authored retry ladder: neutral miss → hint 1 → hint 2 → reveal.

struct PracticeScreenView: View {
    let m: PlayerModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ScreenColumn(topPad: 18, bottomPad: 26) {
            // item progress rail
            let list = m.items
            HStack(spacing: 9) {
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
                }
                .frame(maxWidth: .infinity)

                AUProgressCounter(current: m.i + 1, total: list.count)
            }
            .padding(.bottom, 16)
            .animation(
                AUMotion.animation(.easeInOut(duration: 0.3), reduceMotion: reduceMotion),
                value: m.i
            )
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Practice progress")
            .accessibilityValue("\(m.i + 1) of \(list.count)")

            rungHeader
            groups
            teachBlock
            if m.practiceTeachingComplete {
            profiles
            badges
            cardBlock
            formBlock

            if let item = m.item {
                itemView(item)
                    // The hint ladder reveals rung-by-rung as misses land
                    // (§3.9b) — one quick spring, reduced to a fade under
                    // Reduce Motion.
                    .animation(
                        AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion),
                        value: m.wrong
                    )
            }
            }

            Spacer(minLength: 12)

            unlockNote
            pauseCard
            // The Go-on/Next CTA now lives in the chrome's verdict dock
            // (§3.9a) with the verdict banner — removed from the column.
        }
        // Stage-2 feedback (§3.9e / §2.6): color, motion, and haptic fire in
        // the same frame at the verdict moment. Order items are detected via
        // the completed assembly; option items via the pick state.
        .onChange(of: m.wrong) { _, wrong in
            guard wrong > 0 else { return }
            AUFeedback.miss()
            AUSound.shared.miss()
            AUAX.verdict(correct: false)
        }
        .onChange(of: m.done) { _, done in
            guard done, m.sel != nil, !m.isQuiet, !m.revealed else { return }
            AUFeedback.correct()
            AUSound.shared.correct()
            AUAX.verdict(correct: true)
        }
        .onChange(of: m.tileComplete) { wasComplete, isComplete in
            guard !wasComplete, isComplete else { return }
            if m.tileCorrect {
                AUFeedback.correct()
                AUSound.shared.correct()
                AUAX.verdict(correct: true)
            } else {
                AUFeedback.miss()
                AUSound.shared.miss()
                AUAX.verdict(correct: false)
            }
        }
        .onAppear {
            m.say.refreshPermission()
        }
    }

    // MARK: rung (testlet) + groups

    @ViewBuilder
    private var rungHeader: some View {
        if case .testlet(let t) = m.cur?.screen.payload {
            if let rung = t.rung {
                HStack(spacing: 9) {
                    Text(learnerRungLabel(rung))
                        .font(.figtree(.bold, size: 9.5))
                        .tracking(1.14)
                    if t.support != nil {
                        Text(testletGuidance(for: rung))
                            .font(.figtree(.regular, size: 11.5))
                            .auLine(11.5, 1.45)
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
                            Text("Listen, then answer the questions in this set.")
                                .font(.figtree(.regular, size: 12))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Text("Each question focuses on a different detail.")
                            .font(.figtree(.regular, size: 11))
                            .auLine(11, 1.45)
                            .foregroundStyle(Color.auTextTertiary)
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
                        if m.learningComplete || teach.meaningPulses?.isEmpty != false {
                            Button {
                                m.teachShut.toggle()
                            } label: {
                                Text(m.teachShut ? "Show the model" : "Hide the model")
                                    .font(.figtree(.semibold, size: 10.5))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule().strokeBorder(Color.auEdge, lineWidth: 1)
                                    )
                                    .foregroundStyle(Color.auText.opacity(0.60))
                            }
                            .buttonStyle(.auTap)
                        }
                    }

                    if !m.teachShut {
                        if let pulses = teach.meaningPulses, !pulses.isEmpty {
                            MeaningPulseSequenceView(m: m, pulses: pulses)
                        } else {
                        if let ill = teach.ill {
                            IllustrationPlaceholder(
                                ill: ill, height: 120,
                                aspectRatio: m.cur?.chapter.n == 1 ? 16.0 / 9.0 : nil,
                                cornerRadius: 16, kickerSize: 8.5,
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
                                            .auLine(13, 1.4)
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
                            CompactFlowChips(tiles: tiles, style: .teach)
                                .padding(.bottom, 10)
                        }

                        ForEach(teach.records ?? [], id: \.id) { r in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(r.title)
                                    .font(.figtree(.bold, size: 9))
                                    .tracking(1)
                                    .opacity(0.75)
                                Text(r.pattern)
                                    .font(.figtree(.semibold, size: 14))
                                    .auLine(14, 1.45)
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
                                .auLine(12.5, 1.5)
                                .foregroundStyle(Color.auText.opacity(0.62))
                        }

                        ForEach([teach.notYet].compactMap { $0.learnerFacing }, id: \.self) {
                            note in
                            Text(note)
                                .font(.figtree(.regular, size: 11))
                                .auLine(11, 1.5)
                                .foregroundStyle(Color.auTextTertiary)
                                .padding(.top, 8)
                        }
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
                                AUIcon(kind: .speech, size: 18, color: .auAccentText)
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
                                        .auLine(10.5, 1.4)
                                        .foregroundStyle(Color.auTextTertiary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            ForEach(p.rows, id: \.self) { row in
                                HStack(alignment: .firstTextBaseline, spacing: 10) {
                                    Text(row.first ?? "")
                                        .font(.figtree(.bold, size: 8.5))
                                        .tracking(1)
                                        .frame(width: 78, alignment: .leading)
                                        .foregroundStyle(Color.auTextTertiary)
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
            if let artworkID = readingArtworkID {
                IllustrationPlaceholder(
                    ill: IllustrationRef(
                        id: artworkID,
                        alt: "Two name badges for Maya Haddad and Leo Novak"
                    ),
                    aspectRatio: 16.0 / 9.0,
                    cornerRadius: 18,
                    captionSize: 11.5
                )
                .overlay { ReadingBadgePairOverlay(badges: badges) }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(
                    "Name badges. "
                        + badges.map { "\($0.first) \($0.last)" }.joined(separator: ". "))
                .padding(.bottom, 16)
            } else {
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
    }

    // MARK: welcome card

    @ViewBuilder
    private var cardBlock: some View {
        if case .reading(let r) = m.cur?.screen.payload, r.kind == "card", let lines = r.card {
            if let artworkID = readingArtworkID {
                IllustrationPlaceholder(
                    ill: IllustrationRef(
                        id: artworkID,
                        alt: "A blank welcome card with two reading lines"
                    ),
                    aspectRatio: 16.0 / 9.0,
                    cornerRadius: 18,
                    captionSize: 11.5
                )
                .overlay { ReadingWelcomeCardOverlay(lines: lines, artworkID: artworkID) }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(lines.joined(separator: " "))
                .padding(.bottom, 16)
            } else {
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
    }

    private var readingArtworkID: String? {
        m.cur?.screen.debug.assetIDs.first {
            $0.contains("-ILL") && !$0.contains("–")
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
                                .foregroundStyle(Color.auTextTertiary)
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
        let conversation = item.prompt.flatMap {
            PracticeConversationPrompt(prompt: $0, itemID: item.id)
        }

        // instruction row
        HStack(spacing: 10) {
            AUIcon(
                kind: conversation == nil ? (AUIcon.Kind(rawIcon: item.icon) ?? .eye) : .speech,
                size: 20,
                color: .auTintText
            )
            .frame(width: 38, height: 38)
            .background(Circle().fill(Color.auTintBg))
            Text(conversation == nil ? item.instr : "Complete the conversation")
                .font(.figtree(.semibold, size: 17))
                .frame(maxWidth: .infinity, alignment: .leading)
            #if AUREL_VERIFICATION
                Color.clear
                    .frame(width: 1, height: 1)
                    .accessibilityElement()
                    .accessibilityLabel(item.id)
                    .accessibilityIdentifier("au.player.fixture.item.\(item.id)")
            #endif
        }
        .padding(.bottom, 16)

        // Speak items hear the model from the MODEL play control, not this pill.
        if item.aud != nil, item.kind != "speak" {
            Button {
                m.plays += 1
                m.speak(
                    m.speakTextForItem, audio: item.aud,
                    slow: m.plays > 1)
            } label: {
                HStack(spacing: 13) {
                    AUIcon(kind: .ear, size: 26, color: .auPrimaryButtonText)
                    Text(m.plays == 0 ? "Listen" : (m.plays == 1 ? "Play again" : "Replay used"))
                        .font(.figtree(.semibold, size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
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
            if ill.id == "A1-C01-ILL033" {
                let showsCredentialValues = item.id == "QZ-RD001"
                IllustrationPlaceholder(
                    ill: ill,
                    height: 186,
                    aspectRatio: m.cur?.chapter.n == 1 ? 16.0 / 9.0 : nil,
                    cornerRadius: 20,
                    captionSize: 11.5
                )
                .overlay { SamBadgeCredentialOverlay(showValues: showsCredentialValues) }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(
                    showsCredentialValues
                        ? "Sam Rivera badge"
                        : "Name badge fields. First name. Last name."
                )
                .accessibilityIdentifier(
                    showsCredentialValues
                        ? "au.player.badge.sam-rivera"
                        : "au.player.badge.fields"
                )
                .padding(.bottom, 14)
            } else if ill.id == "A1-C01-ILL030" {
                let lines = welcomeCardLines(for: item)
                IllustrationPlaceholder(
                    ill: ill,
                    height: 186,
                    aspectRatio: 16.0 / 9.0,
                    cornerRadius: 20,
                    captionSize: 11.5
                )
                .overlay { ReadingWelcomeCardOverlay(lines: lines, artworkID: ill.id) }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(lines.joined(separator: " "))
                .padding(.bottom, 14)
            } else {
                IllustrationPlaceholder(
                    ill: ill,
                    height: 186,
                    aspectRatio: m.cur?.chapter.n == 1 ? 16.0 / 9.0 : nil,
                    cornerRadius: 20,
                    captionSize: 11.5
                )
                .padding(.bottom, 14)
            }
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
                    .auLine(13.5, 1.5)
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
                KaraokeText(
                    text: said.t,
                    isSpoken: m.isSpeakingText(said.t, speaker: said.sp, audio: item.aud),
                    spokenRange: m.playback?.spokenRange
                )
                .font(.figtree(.regular, size: 15.5))
                .auLine(15.5, 1.45)
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

        if let conversation {
            conversationPrompt(conversation)
        } else if let prompt = item.prompt {
            Text(prompt)
                .font(.figtree(.regular, size: 16))
                .auLine(16, 1.45)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 15)
        }

        if item.kind == "speak" {
            speakCard(item)
        } else if item.kind == "order" {
            orderView(item)
        } else if item.kind == "pairs" {
            pairsView(item)
        } else if item.kind == "sort" {
            sortView(item)
        } else if !item.opts.isEmpty {
            optionsView(item, opts: item.opts)
        }

        // digit strip (testlet)
        digitStrip

        // The promised line-by-line reveal lands with the verdict (D-02).
        responseTranscript
            .animation(
                AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion),
                value: m.done
            )

        // The verdict banner now lives in the chrome's dock with the CTA
        // (§3.9a) — the column keeps only the scaffolded learning supports.

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
                    .auLine(13.5, 1.5)
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
            // §3.9b: each rung slides in under the quick spring — the
            // ladder is felt rung by rung; a plain fade under Reduce Motion.
            .transition(
                reduceMotion ? .opacity : .opacity.combined(with: .offset(y: 8)))
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
            // §3.9d: the chip enters with the ladder's same quick spring.
            .transition(
                reduceMotion ? .opacity : .opacity.combined(with: .offset(y: 8)))
        }

        if case .practice(let pr) = m.cur?.screen.payload, pr.chartChip == true {
            Text("A–Z chart · always one tap away")
                .font(.figtree(.semibold, size: 12))
                .padding(.horizontal, 13)
                .padding(.vertical, 8)
                .background(Capsule().strokeBorder(Color.auEdge, lineWidth: 1))
                .foregroundStyle(Color.auTextSecondary)
                .padding(.bottom, 11)
                // §3.9d: rides the screen-swap transaction on entrance.
                .transition(
                    reduceMotion ? .opacity : .opacity.combined(with: .offset(y: 8)))
        }
    }

    private func conversationPrompt(_ conversation: PracticeConversationPrompt) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                AUIcon(kind: .speech, size: 14, color: .auAccentText)
                Text("CONVERSATION")
                    .font(.figtree(.bold, size: 9.5))
                    .tracking(1.25)
                    .foregroundStyle(Color.auAccentText)
            }

            Text("Choose the option that completes the highlighted line.")
                .font(.figtree(.regular, size: 13))
                .auLine(13, 1.45)
                .foregroundStyle(Color.auTextSecondary)

            VStack(spacing: 10) {
                ForEach(conversation.turns) { turn in
                    HStack(alignment: .top, spacing: 10) {
                        Text(turn.displaySpeaker)
                            .font(.figtree(.bold, size: 10))
                            .tracking(0.45)
                            .foregroundStyle(
                                turn.isTarget ? Color.auAccentText : Color.auTextTertiary
                            )
                            .frame(width: 66, alignment: .leading)
                            .padding(.top, 12)

                        conversationLine(turn)
                            .font(.figtree(.regular, size: 15.5))
                            .auLine(15.5, 1.45)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(turn.isTarget ? Color.auTintBg : Color.auFill)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .strokeBorder(
                                        turn.isTarget ? Color.auAccent.opacity(0.65) : Color.auEdge,
                                        style: turn.isTarget
                                            ? StrokeStyle(lineWidth: 1.5, dash: [6, 4])
                                            : StrokeStyle(lineWidth: 1)
                                    )
                            )
                    }
                }
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.auFill.opacity(0.45))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.auEdge, lineWidth: 1)
        )
        .padding(.bottom, 15)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(conversation.accessibilityLabel)
    }

    private func conversationLine(_ turn: PracticeConversationPrompt.Turn) -> Text {
        guard !turn.line.isEmpty else {
            return Text("Choose the next line")
                .foregroundColor(.auAccentText)
                .fontWeight(.semibold)
        }

        let source = turn.line as NSString
        let matches = PracticeConversationPrompt.blankExpression.matches(
            in: turn.line,
            range: NSRange(location: 0, length: source.length)
        )
        guard !matches.isEmpty else { return Text(turn.line) }

        let targetPlaceholder = "[ Choose ]"
        var rendered = turn.line
        for (index, match) in matches.enumerated().reversed() {
            guard let range = Range(match.range, in: rendered) else { continue }
            rendered.replaceSubrange(
                range,
                with: index == turn.targetBlankIndex ? targetPlaceholder : "…"
            )
        }

        var attributed = AttributedString(rendered)
        if let range = attributed.range(of: targetPlaceholder) {
            attributed[range].foregroundColor = .auAccentText
            attributed[range].font = .figtree(.semibold, size: 15.5)
        }
        return Text(attributed)
    }

    private func pairsView(_ item: PlayerModel.PlayerItem) -> some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(spacing: 9) {
                ForEach(item.matches) { match in
                    let selected = m.matchSelection == match.id
                    let complete = m.matched.contains(match.id)
                    Button {
                        m.selectMatchCue(match.id)
                    } label: {
                        Text(match.cue)
                            .font(.figtree(.semibold, size: 14))
                            .frame(maxWidth: .infinity, minHeight: 52)
                            .padding(.horizontal, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(selected || complete ? Color.auTintBg : Color.auFill)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .strokeBorder(
                                        selected ? Color.auAccent : Color.auEdge, lineWidth: 1.5))
                    }
                    .buttonStyle(.auTap)
                    .disabled(complete)
                    .accessibilityIdentifier("au.player.match.cue.\(match.id)")
                    .accessibilityValue(complete ? "Matched" : (selected ? "Selected" : ""))
                    .accessibilityAddTraits(selected || complete ? .isSelected : [])
                }
            }

            VStack(spacing: 9) {
                ForEach(Array(item.matches.reversed())) { match in
                    let complete = m.matched.contains(match.id)
                    Button {
                        m.selectMatchAnswer(match.id)
                    } label: {
                        Text(match.answer)
                            .font(.figtree(.regular, size: 14))
                            .frame(maxWidth: .infinity, minHeight: 52)
                            .padding(.horizontal, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(complete ? Color.auOkBg : Color.auFill)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .strokeBorder(
                                        complete ? Color.auOkText.opacity(0.5) : Color.auEdge,
                                        lineWidth: 1.5))
                    }
                    .buttonStyle(.auTap)
                    .disabled(complete)
                    .accessibilityIdentifier("au.player.match.answer.\(match.id)")
                    .accessibilityValue(complete ? "Matched" : "")
                    .accessibilityAddTraits(complete ? .isSelected : [])
                }
            }
        }
        .padding(.bottom, 14)
    }

    private func sortView(_ item: PlayerModel.PlayerItem) -> some View {
        let answers = Array(Set(item.matches.map(\.answer))).sorted()
        return VStack(spacing: 10) {
            ForEach(item.matches) { match in
                VStack(alignment: .leading, spacing: 8) {
                    Text(match.cue)
                        .font(.figtree(.semibold, size: 14.5))
                    HStack(spacing: 7) {
                        ForEach(answers, id: \.self) { answer in
                            Button {
                                m.assignSortMatch(match.id, answer: answer)
                            } label: {
                                Text(answer)
                                    .font(.figtree(.semibold, size: 12.5))
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                                            .fill(
                                                m.matched.contains(match.id)
                                                    && answer == match.answer
                                                    ? Color.auOkBg : Color.auFill))
                            }
                            .buttonStyle(.auTap)
                            .disabled(m.matched.contains(match.id))
                            .accessibilityIdentifier(sortAnswerID(match: match, answer: answer))
                            .accessibilityValue(
                                m.matched.contains(match.id) && answer == match.answer
                                    ? "Matched" : "")
                        }
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(Color.auEdge, lineWidth: 1))
            }
        }
        .padding(.bottom, 14)
    }

    private func sortAnswerID(match: PlayerModel.PlayerItem.Match, answer: String) -> String {
        #if AUREL_VERIFICATION
            if answer == match.answer { return "au.player.sort.correct.\(match.id)" }
        #endif
        return "au.player.sort.answer.\(match.id).\(answer.auSlug)"
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
        if case .testlet(let t) = m.cur?.screen.payload, t.unlock != nil {
            HStack(alignment: .top, spacing: 9) {
                AUIcon(kind: .lock, size: 14, color: .auText.opacity(0.44))
                    .padding(.top, 2)
                Text(
                    String(
                        localized:
                            "Answer each question to reveal the line-by-line transcript — tap a line to hear it."
                    )
                )
                .font(.figtree(.regular, size: 11.5))
                .auLine(11.5, 1.5)
                .foregroundStyle(Color.auTextTertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 12)
        }
    }

    private func testletGuidance(for rung: String) -> String {
        let normalized = rung.uppercased()
        if normalized.contains("GIST") && !normalized.contains("DETAIL") {
            return String(localized: "Listen for the main idea.")
        }
        if normalized.contains("DETAIL") && !normalized.contains("RESPONSE") {
            return String(localized: "Listen for names, words, or numbers.")
        }
        if normalized.contains("RESPONSE") && !normalized.contains("GIST") {
            return String(localized: "Listen once, then choose your response.")
        }
        return String(localized: "Work from the main idea toward the details.")
    }

    /// Assessment rung tokens → learner-facing labels. Unknown tokens are
    /// dropped rather than shown raw — “SPEAKER/TRANSFER” is authoring
    /// vocabulary, not learner language (D-03).
    private func learnerRungLabel(_ rung: String) -> String {
        let tokens: [(token: String, label: String)] = [
            ("GIST", String(localized: "Main idea")),
            ("DETAIL", String(localized: "Details")),
            ("RESPONSE", String(localized: "Your reply")),
            ("SPEAKER", String(localized: "Who says it")),
            ("TRANSFER", String(localized: "New situations")),
        ]
        return
            tokens
            .filter { rung.range(of: $0.token, options: .caseInsensitive) != nil }
            .map(\.label)
            .joined(separator: " · ")
    }

    // MARK: Post-answer transcript (testlet audio items — the promised reveal, D-02)

    @ViewBuilder
    private var responseTranscript: some View {
        if case .testlet = m.cur?.screen.kind,
            m.done || m.revealed,
            let item = m.item,
            let aud = item.aud,
            let assetID = m.resolvedAudioID(aud),
            let asset = m.playback?.catalog.asset(assetID),
            !asset.lines.isEmpty
        {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    AUIcon(kind: .ear, size: 14, color: .auAccentText)
                    Text(String(localized: "What you heard — tap a line to play it"))
                        .font(.figtree(.bold, size: 9.5))
                        .tracking(1.25)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.auAccentText)
                }
                ForEach(Array(asset.lines.enumerated()), id: \.offset) { idx, line in
                    Button {
                        m.speak(line.text, audio: aud, lineIndex: idx)
                    } label: {
                        HStack(alignment: .top, spacing: 10) {
                            Text(line.speaker)
                                .font(.figtree(.bold, size: 10))
                                .tracking(0.45)
                                .foregroundStyle(Color.auTextTertiary)
                                .frame(width: 52, alignment: .leading)
                                .padding(.top, 12)
                            KaraokeText(
                                text: line.text,
                                isSpoken: m.isSpeakingText(
                                    line.text, speaker: line.speaker, audio: aud),
                                spokenRange: m.playback?.spokenRange
                            )
                            .font(.figtree(.regular, size: 15))
                            .auLine(15, 1.45)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(Color.auFill)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .stroke(Color.auEdge, lineWidth: 1)
                            )
                        }
                    }
                    .buttonStyle(.auTap)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(line.speaker). \(line.text)")
                    .accessibilityIdentifier("au.player.transcript.line.\(idx)")
                }
            }
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(
                        Color.auAccent.opacity(0.34),
                        style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
            )
            .padding(.bottom, 14)
            .transition(
                reduceMotion ? .opacity : .opacity.combined(with: .offset(y: 8)))
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
                    .auLine(12.5, 1.5)
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
                    .accessibilityIdentifier("au.player.pause-card.continue")
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
                    .accessibilityIdentifier("au.player.pause-card.break")
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
        let word = item.word ?? item.prompt ?? "hello"
        let isRecording = m.say.recording && m.say.activeTarget == word
        let isAssessing = m.say.assessing && m.say.activeTarget == word
        let rec = m.say.record(for: word)
        let isModelPlaying = m.isSpeakingText(word, audio: item.aud)
        let isLearnerPlaying = m.say.isPlayingLearnerTake

        VStack(spacing: 0) {
            KaraokeText(
                text: word,
                isSpoken: isModelPlaying,
                spokenRange: m.playback?.spokenRange
            )
            .font(.caprasimo(size: 34))
            .tracking(-0.48)
            .padding(.bottom, 16)

            VStack(spacing: 9) {
                // MODEL Row
                HStack(spacing: 12) {
                    Text("MODEL")
                        .font(.figtree(.bold, size: 9.5))
                        .tracking(1)
                        .frame(width: 48, alignment: .leading)
                        .foregroundStyle(Color.auTextSecondary)

                    WaveForm(
                        heights: [10, 20, 26, 14, 22, 12, 18, 24, 16, 20],
                        color: isModelPlaying ? .auAccent : Color.auText.opacity(0.28)
                    )
                    .frame(height: 26)

                    Button {
                        m.listenToSpeakModel()
                    } label: {
                        AUIcon(
                            kind: isModelPlaying ? .loop : .play,
                            size: 16,
                            color: .auAccent
                        )
                        .frame(width: 34, height: 34)
                        .background(Circle().fill(Color.auTintBg))
                    }
                    .buttonStyle(.auTap)
                    .accessibilityLabel("Play model pronunciation")
                    .accessibilityIdentifier("au.player.speak.model")
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(isModelPlaying ? Color.auTintBg.opacity(0.6) : Color.auFill.opacity(0.4))
                )

                // YOU Row
                HStack(spacing: 12) {
                    Text("YOU")
                        .font(.figtree(.bold, size: 9.5))
                        .tracking(1)
                        .frame(width: 48, alignment: .leading)
                        .foregroundStyle(Color.auTextSecondary)

                    if isRecording || rec.takes > 0 {
                        LiveWaveform(
                            samples: isRecording ? m.say.samples : [0.2, 0.45, 0.7, 0.4, 0.6, 0.35],
                            tint: isRecording ? .auErr : .auAccent2,
                            barCount: 16
                        )
                        .frame(height: 26)
                    } else {
                        WaveForm(
                            heights: [8, 14, 20, 12, 16, 10, 14, 18, 12, 16],
                            color: Color.auText.opacity(0.22)
                        )
                        .frame(height: 26)
                    }

                    if rec.takes > 0 && m.say.canPlayLearnerTake {
                        Button {
                            Task { await m.say.playLearnerTake() }
                        } label: {
                            AUIcon(
                                kind: isLearnerPlaying ? .loop : .play,
                                size: 16,
                                color: .auAccent2
                            )
                            .frame(width: 34, height: 34)
                            .background(Circle().fill(Color.auOkBg))
                        }
                        .buttonStyle(.auTap)
                        .accessibilityLabel("Play your recorded voice")
                        .accessibilityIdentifier("au.player.speak.learner")
                    } else {
                        AUIcon(kind: .play, size: 16, color: Color.auText.opacity(0.2))
                            .frame(width: 34, height: 34)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(isLearnerPlaying ? Color.auOkBg.opacity(0.6) : Color.auFill.opacity(0.4))
                )
            }
            .padding(.bottom, 16)

            Button {
                Task { await m.say.toggle(target: word) }
            } label: {
                ZStack {
                    if isRecording {
                        RecordingRing()
                            .frame(width: 86, height: 86)
                    }
                    AUIcon(
                        kind: isRecording ? .close : .mic,
                        size: 30,
                        color: .auPrimaryButtonText
                    )
                    .frame(width: 74, height: 74)
                    .background(
                        Circle().fill(
                            isRecording ? Color.auErr : Color.auAccentRamp(600)
                        )
                    )
                    .shadow(
                        color: isRecording ? Color.auErr.opacity(0.35) : Color.auAccent.opacity(0.25),
                        radius: 8, y: 3
                    )
                }
            }
            .buttonStyle(.auTap)
            .disabled(isAssessing)
            .accessibilityIdentifier("au.player.speak.mic")
            .accessibilityLabel(isRecording ? "Stop recording" : "Record voice")

            if m.say.micDenied {
                HStack(spacing: 8) {
                    AUIcon(kind: .lock, size: 14, color: .auErrText)
                    Text("Microphone is off. Enable in Settings or skip.")
                        .font(.figtree(.medium, size: 12.5))
                        .foregroundStyle(Color.auErrText)
                }
                .padding(.top, 12)
            } else if isRecording {
                Text("Listening… Say “\(word)”")
                    .font(.figtree(.semibold, size: 13))
                    .foregroundStyle(Color.auAccentText)
                    .padding(.top, 12)
            } else if isAssessing {
                Text("Checking your pronunciation…")
                    .font(.figtree(.medium, size: 13))
                    .foregroundStyle(Color.auTextSecondary)
                    .padding(.top, 12)
            } else if let verdict = rec.verdict {
                let isClear = verdict == .clear
                HStack(spacing: 8) {
                    AUIcon(
                        kind: isClear ? .check : .warning,
                        size: 15,
                        color: isClear ? .auOkText : .auTintText
                    )
                    Text(
                        isClear
                            ? "Clear — great pronunciation!"
                            : (verdict == .near
                                ? "\(rec.matchedWords) of \(rec.totalWords) words matched. Closer each time."
                                : "Try saying “\(word)” clearly.")
                    )
                    .font(.figtree(.medium, size: 13))
                    .foregroundStyle(isClear ? Color.auOkText : Color.auTintText)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(isClear ? Color.auOkBg : Color.auTintBg)
                )
                .padding(.top, 12)
            } else if rec.takes > 0 {
                Text("Recorded — play both to compare")
                    .font(.figtree(.semibold, size: 12.5))
                    .foregroundStyle(Color.auTextSecondary)
                    .padding(.top, 12)
            } else {
                Text("Tap mic to say it · ungraded")
                    .font(.figtree(.semibold, size: 12.5))
                    .foregroundStyle(Color.auTextSecondary)
                    .padding(.top, 12)
            }

            if rec.takes > 0 && m.say.canPlayLearnerTake {
                Button {
                    playBoth(word: word, audio: item.aud)
                } label: {
                    HStack(spacing: 7) {
                        AUIcon(kind: .play, size: 13, color: .auAccent)
                        Text("Play both (Model + You)")
                            .font(.figtree(.semibold, size: 13))
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .strokeBorder(Color.auAccent.opacity(0.4), lineWidth: 1)
                    )
                    .foregroundStyle(Color.auAccent)
                }
                .buttonStyle(.auTap)
                .padding(.top, 10)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.auFill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color.auEdge, lineWidth: 1)
        )
        .padding(.bottom, 14)
    }

    private func playBoth(word: String, audio: String?) {
        m.say.stopLearnerTake()
        m.speak(word, audio: audio)
        Task { @MainActor in
            for _ in 0..<10 {
                if m.playback?.isSpeaking == true { break }
                try? await Task.sleep(for: .milliseconds(50))
            }
            var waited = 0
            while m.playback?.isSpeaking == true && waited < 60 {
                try? await Task.sleep(for: .milliseconds(100))
                waited += 1
            }
            try? await Task.sleep(for: .milliseconds(300))
            await m.say.playLearnerTake()
        }
    }

    // MARK: Order items (lines 472–482)

    private func orderView(_ item: PlayerModel.PlayerItem) -> some View {
        let task = m.tileTask

        return VStack(spacing: 0) {
            if let target = task.target, !target.contains("___") && !target.isEmpty {
                Text(target)
                    .font(.figtree(.semibold, size: 15))
                    .auLine(15, 1.45)
                    .foregroundStyle(Color.auTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
            }

            if m.usesLineAssembly {
                OrderedLineAssemblyField(lines: m.orderedTileTexts)
                    .padding(.bottom, 14)
            } else {
                Text(m.displayTileLine(target: task.target))
                    .font(.caprasimo(size: 20))
                    .tracking(-0.2)
                    .auHeadLine(20, 1.4)
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
            }

            FlowTiles(
                tiles: task.tiles, taken: Set(m.order), order: m.order,
                onTap: { m.toggleTile($0) },
                aidPrefix: "au.player.tile"
            )
            .padding(.bottom, 14)

            // The completed-assembly verdict moved to the chrome's dock
            // (§3.9a); the hint block below stays at the point of need.

            // Hint after a wrong ordering (line 1590: `showHint = …
            // (tileComplete && !tileCorrect)` for order items). The prototype's
            // option-item index math (`hints[min(wrong, len) - 1]` with
            // `wrong = 0` → `-1`) selects nothing — an authored-hints artifact;
            // port the intent: the first authored hint, rung "Hint 1".
            if m.tileComplete && !m.tileCorrect, let hints = item.hints, !hints.isEmpty {
                HStack(alignment: .top, spacing: 10) {
                    Text("Hint 1")
                        .font(.figtree(.bold, size: 9.5))
                        .tracking(1)
                        .padding(.top, 3)
                        .foregroundStyle(Color.auAccentText)
                    Text(hints[0])
                        .font(.figtree(.regular, size: 13.5))
                        .auLine(13.5, 1.5)
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
                // §3.9c: the wrong-ordering hint slides in with the same
                // quick spring the option ladder uses (S2-011).
                .transition(
                    reduceMotion ? .opacity : .opacity.combined(with: .offset(y: 8)))
            }
        }
        // The assembly hint appears/leaves on the tileComplete flip, which
        // the wrong-keyed animation never sees — give it its own key.
        .animation(
            AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion),
            value: m.tileComplete
        )
    }

    // MARK: Options (lines 483–506)

    @ViewBuilder
    private func optionsView(_ item: PlayerModel.PlayerItem, opts: [PracticeOption]) -> some View {
        if item.big {
            HStack(spacing: 10) {
                ForEach(Array(opts.enumerated()), id: \.offset) { _, o in
                    let picked = m.sel == o.id
                    let isKey = item.isKey(o)
                    optionRow(o, picked: picked, isKey: isKey, item: item, big: true)
                        .frame(maxWidth: .infinity)
                        .accessibilityIdentifier("au.player.option.\(o.id)")
                }
            }
            .padding(.bottom, 14)
        } else {
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
    }

    @ViewBuilder
    private func optionRow(
        _ o: PracticeOption, picked: Bool, isKey: Bool, item: PlayerModel.PlayerItem,
        big: Bool = false
    ) -> some View {
        let quiet = m.isQuiet
        let radius: CGFloat = big ? 22 : 19
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
            Group {
                if big {
                    Text(o.text ?? o.ill?.alt ?? "")
                        .font(.caprasimo(size: 42))
                        .tracking(-0.63)
                        .frame(maxWidth: .infinity, minHeight: 104)
                } else if let ill = o.ill {
                    ZStack(alignment: .topTrailing) {
                        IllustrationChoiceFill(ill: ill, cornerRadius: radius)

                        if m.done && isKey && !quiet {
                            AUIcon(kind: .check, size: 18, color: .auOkText)
                                .frame(width: 32, height: 32)
                                .background(Circle().fill(Color.auOkBg))
                                .overlay(Circle().strokeBorder(Color.auAccent2, lineWidth: 1.5))
                                .shadow(color: Color.black.opacity(0.12), radius: 3, y: 1)
                                .padding(8)
                        } else if picked && !isKey && !quiet && m.done {
                            AUIcon(kind: .loop, size: 16, color: .auErrText)
                                .frame(width: 32, height: 32)
                                .background(Circle().fill(Color.auErrBg))
                                .overlay(Circle().strokeBorder(Color.auErr, lineWidth: 1.5))
                                .shadow(color: Color.black.opacity(0.12), radius: 3, y: 1)
                                .padding(8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                } else if let t = o.text {
                    HStack(spacing: 12) {
                        Text(t)
                            .font(.figtree(.regular, size: 16))
                            .auLine(16, 1.4)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        if m.done && isKey && !quiet {
                            AUIcon(kind: .check, size: 19, color: .auOkText)
                        } else if picked && !isKey && !quiet && m.done {
                            AUIcon(kind: .loop, size: 17, color: .auErrText)
                        }
                    }
                    .padding(.horizontal, 17)
                    .padding(.vertical, 14)
                    .frame(minHeight: 62, alignment: .leading)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(bg)
            )
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(bd, lineWidth: 1.5)
            )
            .foregroundStyle(fg)
        }
        .buttonStyle(.auTap)
        .disabled(m.done && !quiet)
        .accessibilityLabel(o.text ?? o.ill?.alt ?? String(localized: "Answer option"))
        .accessibilityValue(optionAccessibilityValue(picked: picked, correct: isKey, quiet: quiet))
        .accessibilityAddTraits(picked ? .isSelected : [])
    }

    private func optionAccessibilityValue(
        picked: Bool, correct: Bool, quiet: Bool
    ) -> String {
        guard picked || (m.done && correct && !quiet) else { return "" }
        if quiet { return String(localized: "Selected") }
        return correct ? String(localized: "Correct") : String(localized: "Try again")
    }
}

private struct ReadingBadgePairOverlay: View {
    let badges: [ReadingBadge]

    var body: some View {
        GeometryReader { proxy in
            ForEach(Array(badges.prefix(2).enumerated()), id: \.offset) { index, badge in
                let centerX = proxy.size.width * (index == 0 ? 0.28 : 0.72)

                Text(badge.first)
                    .font(.caprasimo(size: proxy.size.width * 0.040))
                    .tracking(-0.15)
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                    .foregroundStyle(Color.auText.opacity(0.88))
                    .frame(width: proxy.size.width * 0.21)
                    .position(x: centerX, y: proxy.size.height * 0.43)

                Text(badge.last)
                    .font(.figtree(.semibold, size: proxy.size.width * 0.027))
                    .tracking(0.55)
                    .lineLimit(1)
                    .minimumScaleFactor(0.70)
                    .foregroundStyle(Color.auText.opacity(0.78))
                    .frame(width: proxy.size.width * 0.27)
                    .position(x: centerX, y: proxy.size.height * 0.56)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

private struct ReadingWelcomeCardOverlay: View {
    let lines: [String]
    var artworkID: String = ""

    var body: some View {
        GeometryReader { proxy in
            if artworkID == "A1-C02-ILL029" {
                ForEach(Array(lines.prefix(5).enumerated()), id: \.offset) { index, line in
                    let ys: [CGFloat] = [0.28, 0.40, 0.52, 0.64, 0.76]
                    let scales: [CGFloat] = [0.026, 0.018, 0.016, 0.015, 0.022]
                    let widths: [CGFloat] = [0.42, 0.52, 0.54, 0.56, 0.42]
                    Text(line)
                        .font(
                            index == 0 || index + 1 == min(lines.count, 5)
                                ? .caprasimo(size: proxy.size.width * scales[index])
                                : .figtree(.semibold, size: proxy.size.width * scales[index])
                        )
                        .lineLimit(1)
                        .minimumScaleFactor(0.55)
                        .foregroundStyle(Color.auText.opacity(0.86))
                        .frame(width: proxy.size.width * widths[index])
                        .position(x: proxy.size.width * 0.50, y: proxy.size.height * ys[index])
                }
            } else {
                if let first = lines.first {
                    Text(first)
                        .font(.caprasimo(size: proxy.size.width * 0.048))
                        .tracking(-0.18)
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                        .foregroundStyle(Color.auText.opacity(0.88))
                        .frame(width: proxy.size.width * 0.34)
                        .position(x: proxy.size.width * 0.50, y: proxy.size.height * 0.39)
                }

                if lines.count > 1 {
                    Text(lines[1])
                        .font(.figtree(.semibold, size: proxy.size.width * 0.036))
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                        .foregroundStyle(Color.auText.opacity(0.82))
                        .frame(width: proxy.size.width * 0.43)
                        .position(x: proxy.size.width * 0.50, y: proxy.size.height * 0.62)
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

private func welcomeCardLines(for item: PlayerModel.PlayerItem) -> [String] {
    if let lines = quotedCardLines(from: item.prompt), !lines.isEmpty {
        if lines.count <= 2 { return Array(lines) }
        let name = lines.first { $0.localizedCaseInsensitiveContains("my name") } ?? lines[1]
        return [lines[0], name]
    }
    return ["Welcome!", "My name is Maya."]
}

private func quotedCardLines(from prompt: String?) -> [String]? {
    guard let prompt else { return nil }
    let pattern = #"Card:\s*[“"](.+?)[”"]"#
    guard let regex = try? NSRegularExpression(pattern: pattern),
          let match = regex.firstMatch(
            in: prompt, range: NSRange(prompt.startIndex..., in: prompt)),
          let range = Range(match.range(at: 1), in: prompt)
    else { return nil }
    return prompt[range]
        .split(separator: "/")
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }
}

private struct SamBadgeCredentialOverlay: View {
    let showValues: Bool

    var body: some View {
        GeometryReader { proxy in
            Text(showValues ? "SAM" : "FIRST NAME")
                .font(
                    showValues
                        ? .caprasimo(size: proxy.size.width * 0.040)
                        : .figtree(.bold, size: proxy.size.width * 0.018)
                )
                .tracking(showValues ? -0.12 : 0.15)
                .lineLimit(1)
                .minimumScaleFactor(0.55)
                .foregroundStyle(Color.auText.opacity(0.88))
                .frame(width: proxy.size.width * (showValues ? 0.17 : 0.25))
                .position(x: proxy.size.width * 0.50, y: proxy.size.height * 0.548)

            Text(showValues ? "RIVERA" : "LAST NAME")
                .font(.figtree(.semibold, size: proxy.size.width * 0.027))
                .tracking(showValues ? 0.52 : 0.20)
                .lineLimit(1)
                .minimumScaleFactor(0.55)
                .foregroundStyle(Color.auText.opacity(0.78))
                .frame(width: proxy.size.width * 0.27)
                .position(x: proxy.size.width * 0.50, y: proxy.size.height * 0.661)
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

// MARK: - Conversation prompt structure

/// Converts legacy, one-line dialogue prompts into learner-facing turns.
/// The course bank remains compatible while the renderer removes authoring
/// notes such as "blank two" and makes the actual completion point explicit.
struct PracticeConversationPrompt {
    struct Turn: Identifiable {
        let id: Int
        let speaker: String
        let line: String
        let targetBlankIndex: Int?

        var isTarget: Bool { targetBlankIndex != nil }

        var displaySpeaker: String {
            switch speaker.uppercased() {
            case "A": return String(localized: "Speaker A")
            case "B": return String(localized: "Speaker B")
            case "YOU": return String(localized: "You")
            default: return speaker.capitalized
            }
        }
    }

    let turns: [Turn]

    static let blankExpression = try! NSRegularExpression(pattern: #"_+"#)

    var accessibilityLabel: String {
        let transcript = turns.map { turn in
            let spokenLine: String
            if turn.line.isEmpty {
                spokenLine = String(localized: "blank")
            } else {
                spokenLine = turn.line.replacingOccurrences(
                    of: #"_+"#,
                    with: String(localized: "blank"),
                    options: .regularExpression
                )
            }
            return "\(turn.displaySpeaker): \(spokenLine)"
        }
        .joined(separator: ". ")
        return String(
            localized:
                "Conversation. Choose the option that completes the highlighted line. \(transcript)"
        )
    }

    init?(prompt: String, itemID: String) {
        let source = prompt as NSString
        let markerExpression = try! NSRegularExpression(
            pattern: #"(?:^|[\s…])([A-Za-z][A-Za-z]*):\s*"#
        )
        let matches = markerExpression.matches(
            in: prompt,
            range: NSRange(location: 0, length: source.length)
        )
        let markers: [(range: NSRange, speaker: String)] = matches.compactMap { match in
            guard match.numberOfRanges > 1 else { return nil }
            let speaker = source.substring(with: match.range(at: 1))
            guard Self.isSpeaker(speaker) else { return nil }
            return (match.range, speaker)
        }
        guard markers.count >= 2 else { return nil }

        let rawTurns: [(speaker: String, line: String, blankCount: Int)] = markers.enumerated().map
        {
            index, marker in
            let start = NSMaxRange(marker.range)
            let end = index + 1 < markers.count ? markers[index + 1].range.location : source.length
            let range = NSRange(location: start, length: max(0, end - start))
            let line = Self.cleanLine(source.substring(with: range))
            let lineSource = line as NSString
            let blanks = Self.blankExpression.numberOfMatches(
                in: line,
                range: NSRange(location: 0, length: lineSource.length)
            )
            return (marker.speaker, line, max(blanks, line.isEmpty ? 1 : 0))
        }

        let blankTotal = rawTurns.reduce(0) { $0 + $1.blankCount }
        guard blankTotal > 0 else { return nil }
        let authoredBlank = Self.authoredBlankNumber(from: itemID) ?? 1
        let target = blankTotal == 1 ? 0 : min(max(0, authoredBlank - 1), blankTotal - 1)

        var blankOffset = 0
        turns = rawTurns.enumerated().map { index, raw in
            let localTarget: Int?
            if target >= blankOffset && target < blankOffset + raw.blankCount {
                localTarget = target - blankOffset
            } else {
                localTarget = nil
            }
            blankOffset += raw.blankCount
            return Turn(
                id: index,
                speaker: raw.speaker,
                line: raw.line,
                targetBlankIndex: localTarget
            )
        }
    }

    private static func isSpeaker(_ candidate: String) -> Bool {
        let speakers: Set<String> = [
            "A", "B", "YOU", "GUIDE", "ALEX", "AMARA", "KENJI", "LEO", "MAYA", "NINA",
            "RAFAEL", "SAM", "PARTNER", "TEACHER",
        ]
        return speakers.contains(candidate.uppercased())
    }

    private static func authoredBlankNumber(from itemID: String) -> Int? {
        let lower = itemID.lowercased()
        let words = ["one": 1, "two": 2, "three": 3, "four": 4]
        for (word, value) in words where lower.contains("blank \(word)") { return value }

        let expression = try! NSRegularExpression(pattern: #"blank\s+(\d+)"#)
        let source = lower as NSString
        guard
            let match = expression.firstMatch(
                in: lower,
                range: NSRange(location: 0, length: source.length)
            ), match.numberOfRanges > 1
        else { return nil }
        return Int(source.substring(with: match.range(at: 1)))
    }

    private static func cleanLine(_ raw: String) -> String {
        var line = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        line = line.replacingOccurrences(
            of: #"\s*[—-]\s*blank\s+(?:one|two|three|four|\d+)\s*:?\s*$"#,
            with: "",
            options: [.regularExpression, .caseInsensitive]
        )
        line = line.trimmingCharacters(in: .whitespacesAndNewlines)
        while let first = line.first, first == "…" || first == "—" {
            line.removeFirst()
            line = line.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        let quotePairs: [(Character, Character)] = [("“", "”"), ("‘", "’"), ("\"", "\"")]
        if line.count >= 2, let first = line.first, let last = line.last,
            quotePairs.contains(where: { $0.0 == first && $0.1 == last })
        {
            line.removeFirst()
            line.removeLast()
        }
        return line.trimmingCharacters(in: .whitespacesAndNewlines)
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

enum CompactFlowChipStyle {
    case demo
    case pattern
    case teach
    case roleplay
}

/// Authored compact, non-interactive chips used for examples and pattern groups.
struct CompactFlowChips: View {
    let tiles: [String]
    let style: CompactFlowChipStyle

    var body: some View {
        FlowLayout(spacing: 7) {
            ForEach(tiles, id: \.self) { tile in
                Text(tile)
                    .font(font)
                    .padding(.horizontal, horizontalPadding)
                    .padding(.vertical, verticalPadding)
                    .foregroundStyle(foreground)
                    .background { chipBackground }
            }
        }
    }

    private var font: Font {
        switch style {
        case .demo: .figtree(.semibold, size: 11)
        case .pattern: .figtree(.semibold, size: 12.5)
        case .teach: .figtree(.semibold, size: 12)
        case .roleplay: .figtree(.semibold, size: 12.5)
        }
    }

    private var horizontalPadding: CGFloat {
        switch style {
        case .demo, .teach: 11
        case .pattern: 12
        case .roleplay: 13
        }
    }

    private var verticalPadding: CGFloat {
        switch style {
        case .demo: 6
        case .pattern: 8
        case .teach: 7
        case .roleplay: 9
        }
    }

    private var foreground: Color {
        switch style {
        case .demo: .auFlatText
        case .pattern, .teach: .auTintText
        case .roleplay: .auText
        }
    }

    @ViewBuilder
    private var chipBackground: some View {
        switch style {
        case .demo:
            Capsule().fill(Color.auFlatBg)
        case .pattern:
            RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.auTintBg)
        case .teach:
            RoundedRectangle(cornerRadius: 11, style: .continuous).fill(Color.auTintBg)
        case .roleplay:
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .fill(Color.auFill)
                .overlay(
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .strokeBorder(Color.auEdge, lineWidth: 1)
                )
        }
    }
}

/// Wrap layout of tile buttons (tap-to-order chips).
struct FlowTiles: View {
    let tiles: [String]
    var taken: Set<Int> = []
    var order: [Int] = []
    var onTap: ((Int) -> Void)? = nil
    /// UI-test identifier prefix — when set, tiles are `"<prefix>.<index>"`
    /// (mirrors the TilesScreenView rows, `au.player.tile.<k>`).
    var aidPrefix: String? = nil

    var body: some View {
        FlowLayout(spacing: 9) {
            ForEach(Array(tiles.enumerated()), id: \.offset) { k, t in
                let on = taken.contains(k)
                Button {
                    AUFeedback.tileSnap()
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
                                on ? Color.auAccent.opacity(0.38) : Color.auEdge, lineWidth: 1.5)
                        )
                        .foregroundStyle(on ? Color.auTintText : Color.auText)
                }
                .buttonStyle(.auTap)
                .accessibilityIdentifier(aidPrefix.map { "\($0).\(k)" } ?? "")
                .accessibilityLabel(t)
                .accessibilityValue(
                    order.firstIndex(of: k).map { String(localized: "Position \($0 + 1)") }
                        ?? String(localized: "Not selected")
                )
                .accessibilityAddTraits(on ? .isSelected : [])
            }
        }
    }
}

/// Keeps full-sentence ordering readable as a script instead of collapsing
/// the selected turns into one artificial-looking paragraph.
struct OrderedLineAssemblyField: View {
    let lines: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("CONVERSATION")
                .font(.figtree(.bold, size: 10))
                .tracking(1.25)
                .foregroundStyle(Color.auAccentText)

            if lines.isEmpty {
                HStack(spacing: 9) {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.system(size: 15, weight: .semibold))
                    Text("Build the conversation here.")
                        .font(.figtree(.medium, size: 14))
                }
                .foregroundStyle(Color.auTextSecondary)
                .frame(maxWidth: .infinity, minHeight: 54, alignment: .leading)
            } else {
                ForEach(Array(lines.enumerated()), id: \.offset) { index, line in
                    let turn = Self.turn(from: line, index: index)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(turn.label.uppercased())
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(0.8)
                            .foregroundStyle(Color.auAccentText)
                        Text(turn.text)
                            .font(.figtree(.semibold, size: 16))
                            .auLine(16, 1.35)
                            .foregroundStyle(Color.auText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 13)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .fill(Color.auFill)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .strokeBorder(Color.auEdge, lineWidth: 1)
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 82, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(
                    Color.auAccent.opacity(0.42),
                    style: StrokeStyle(lineWidth: 1.5, dash: [6, 5]))
        )
        .accessibilityElement(children: .contain)
    }

    private static func turn(from line: String, index: Int) -> (label: String, text: String) {
        let parts = line.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
        if parts.count == 2 {
            let proposedLabel = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let isSpeakerLabel =
                !proposedLabel.isEmpty
                && proposedLabel.count <= 18
                && proposedLabel.rangeOfCharacter(from: .letters) != nil
            if isSpeakerLabel {
                return (
                    proposedLabel.capitalized,
                    parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                )
            }
        }
        return ("Turn \(index + 1)", line)
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
