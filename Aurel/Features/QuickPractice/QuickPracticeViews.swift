import SwiftUI

// MARK: - Quick practice + Result
//
// The lesson runner (Aurel.dc.html lines 640–839) and the result screen
// (lines 841–885), driven by AppRouter's ported advance()/check() logic.

// MARK: Lesson runner

struct LessonRunnerView: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        let r = env.router
        let list =
            r.reviewMode
            ? r.queue.compactMap { bank.indices.contains($0) ? bank[$0] : nil }
            : bank

        ZStack(alignment: .bottom) {
            ZStack {
                Color.auBackground
                AUPaper()
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {
                header(list: list)
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        if list.indices.contains(r.qi) {
                            itemView(list[r.qi])
                                .id(r.qi)
                                .transition(AUMotion.screenSwap(reduceMotion: reduceMotion))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 190)
                }
                .animation(AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion), value: r.qi)
            }

            // verdict dock — the verdict slides in over the glass and the
            // dock stays resident between items (§3.13a): only the banner
            // content transitions, the container never re-pops.
            VStack(spacing: 0) {
                if r.checked || r.nudge, let q = list.indices.contains(r.qi) ? list[r.qi] : nil,
                    q.type != .flash
                {
                    verdict(q: q)
                        .transition(
                            reduceMotion
                                ? .opacity
                                : .opacity.combined(with: .offset(y: 10))
                        )
                }
                primaryButton(list: list)
            }
            .animation(
                AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion),
                value: r.checked
            )
            .animation(
                AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion),
                value: r.nudge
            )
            .padding(.horizontal, 24)
            .padding(.top, 18)
            .padding(.bottom, 30)
            .background {
                ZStack {
                    Rectangle().fill(.ultraThinMaterial.opacity(0.5))
                    AUGradients.glass()
                }
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 30, bottomLeadingRadius: 0, bottomTrailingRadius: 0,
                        topTrailingRadius: 30, style: .continuous
                    )
                )
                .overlay(alignment: .top) {
                    Rectangle().fill(Color.auEdge).frame(height: 1)
                }
                .auSoft()
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .auScreenEntrance()
        // Stage-2 feedback (§3.13 / §2.6): the verdict moment fires haptic,
        // sound, and the VoiceOver announcement together. Misses (both the
        // first-try nudge and the reveal) ride `wrongShake`; the correct
        // verdict rides `checked` — guarded so a revealed miss doesn't
        // double-fire (its miss feedback already came from wrongShake).
        .onChange(of: r.wrongShake) { _, _ in
            AUFeedback.miss()
            AUSound.shared.miss()
            AUAX.verdict(correct: false)
        }
        .onChange(of: r.checked) { _, checked in
            guard checked else { return }
            let q = list.indices.contains(r.qi) ? list[r.qi] : nil
            let ok =
                q.map {
                    r.sel == $0.answer
                        || ($0.type == .order && r.built.joined(separator: " ") == $0.answerText)
                } ?? false
            guard ok else { return }
            AUFeedback.correct()
            AUSound.shared.correct()
            AUAX.verdict(correct: true)
        }
    }

    private var bank: [QuickItem] { QuickItem.bank(from: env.course) }

    // MARK: header (lines 643–653)

    private func header(list: [QuickItem]) -> some View {
        HStack(spacing: 12) {
            Button {
                env.router.leaveLesson(listCount: list.count)
            } label: {
                AUIcon(kind: .close, size: 19, color: .auText.opacity(0.55))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.auTap)
            .accessibilityLabel("Close lesson")

            HStack(spacing: 5) {
                ForEach(list.indices, id: \.self) { k in
                    let complete = k < r.qi || (k == r.qi && r.checked)
                    ZStack {
                        Capsule().fill(
                            k == r.qi
                                ? Color.auAccent.opacity(0.40) : Color.auText.opacity(0.12)
                        )
                        if complete {
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.auAccent.mixed(with: 0.28, of: .white),
                                            Color.auAccent,
                                        ],
                                        startPoint: .top, endPoint: .bottom
                                    )
                                )
                                .shadow(color: Color.auGlow, radius: 4, y: 2)
                        }
                    }
                    .frame(height: 6)
                }
            }

            if r.reviewMode {
                // §3.13c: the mistake queue is a different run — say so.
                ATag(text: "Review — loose ends", variant: .tint)
                    .fixedSize()
            }
            Text("\(r.qi + 1) / \(list.count)")
                .font(.figtree(.regular, size: 11.5))
                .foregroundStyle(Color.auTextTertiary)
        }
        .padding(.horizontal, 22)
        .padding(.top, 70)
        .padding(.bottom, 18)
    }

    private var r: AppRouter { env.router }

    // MARK: item body (lines 655–814)

    @ViewBuilder
    private func itemView(_ q: QuickItem) -> some View {
        Text((r.reviewMode ? "Due back · " : "") + q.kicker)
            .font(.figtree(.bold, size: 10.5))
            .tracking(1.68)
            .textCase(.uppercase)
            .foregroundStyle(Color.auAccentText)
            .padding(.bottom, 12)

        switch q.type {
        case .flash: flashView(q)
        case .choice: choiceView(q)
        case .listen: listenView(q)
        case .order: orderView(q)
        case .match: matchView(q)
        case .pattern: patternView(q)
        }
    }

    private func flashView(_ q: QuickItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Turn the card.")
                .font(.caprasimo(size: 25))
                .tracking(-0.38)
                .padding(.bottom, 22)

            AUFlipCard(
                isFlipped: Binding(
                    get: { r.flipped },
                    set: { r.flipped = $0 }
                ),
                front: {
                    VStack(spacing: 0) {
                        if let ill = q.ill {
                            IllustrationPlaceholder(
                                ill: ill, height: 96, cornerRadius: 20, kickerSize: 8,
                                captionSize: 10
                            )
                            .padding(.bottom, 10)
                        }
                        Text(q.front)
                            .font(.caprasimo(size: 28))
                            .tracking(-0.56)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 16)
                        HStack(spacing: 6) {
                            AUIcon(kind: .loop, size: 13, color: .auAccentText)
                            Text("Tap to reveal")
                                .font(.figtree(.regular, size: 11.5))
                                .tracking(1.15)
                                .textCase(.uppercase)
                                .foregroundStyle(Color.auAccentText)
                        }
                    }
                    .padding(26)
                    .frame(height: 320)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous).fill(Color.auFill)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .strokeBorder(Color.auEdge, lineWidth: 1)
                    )
                    .auLift()
                },
                back: {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(q.back)
                            .font(.figtree(.semibold, size: 16))
                            .auLine(16, 1.5)
                        if !q.ex.isEmpty {
                            Text(q.ex)
                                .font(.figtree(.regular, size: 14))
                                .italic()
                                .auLine(14, 1.55)
                                .opacity(0.88)
                                .padding(.top, 18)
                                .overlay(alignment: .top) {
                                    Divider().overlay(
                                        AUSceneArt.duskHighlight.opacity(0.3)
                                    ).padding(.top, -9)
                                }
                        }
                        Spacer(minLength: 12)
                        HStack(spacing: 6) {
                            AUIcon(kind: .loop, size: 13, color: .white.opacity(0.8))
                            Text("Tap to turn back")
                                .font(.figtree(.regular, size: 11))
                                .tracking(1.1)
                                .textCase(.uppercase)
                                .opacity(0.8)
                        }
                    }
                    .padding(26)
                    .frame(height: 320, alignment: .topLeading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color.auAccentRamp(600))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                    )
                    .foregroundStyle(Color.auPrimaryButtonText)
                    .auSoft()
                }
            )
            .padding(.bottom, 24)

            HStack(spacing: 9) {
                Button {
                    // word sheet in the prototype — opens the first word record
                } label: {
                    Text("Word detail")
                        .font(.figtree(.bold, size: 13))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 17, style: .continuous).strokeBorder(
                                Color.auEdge, lineWidth: 1)
                        )
                        .foregroundStyle(Color.auText.opacity(0.62))
                }
                .buttonStyle(.auTap)

                APillButton(title: "I knew it", variant: .quiet, compact: true) {
                    r.advance(list: bank)
                }
                APillButton(title: "Didn't", compact: true) { r.advance(list: bank) }
            }
        }
    }

    private func choiceView(_ q: QuickItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(q.prompt.isEmpty ? "Choose." : q.prompt)
                .font(.caprasimo(size: 25))
                .tracking(-0.38)
                .padding(.bottom, 8)

            if !q.stem.isEmpty {
                Text(q.stem)
                    .font(.figtree(.semibold, size: 19))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color.auFill)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22).strokeBorder(Color.auEdge, lineWidth: 1)
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 22)
            } else {
                Spacer(minLength: 14)
            }

            VStack(spacing: 10) {
                ForEach(Array(q.options.enumerated()), id: \.offset) { i, label in
                    optionRow(q: q, i: i, label: label)
                }
            }
        }
    }

    private func listenView(_ q: QuickItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("What do you hear?")
                .font(.caprasimo(size: 25))
                .tracking(-0.38)
                .padding(.bottom, 22)

            HStack(spacing: 18) {
                Button {
                    env.speaker.speak(
                        q.audio.isEmpty
                            ? (q.options.indices.contains(q.answer)
                                ? q.options[q.answer] : q.prompt)
                            : q.audio,
                        slow: false)
                } label: {
                    AUIcon(kind: .ear, size: 24, color: .auBackground)
                        .frame(width: 58, height: 58)
                        .background(Circle().fill(Color.auAccent))
                }
                .buttonStyle(.auTap)
                .accessibilityLabel("Play audio")

                let waveHeights: [CGFloat] = (0..<18).map { i in
                    CGFloat(10 + (i * 7) % 22)
                }
                LessonWaveform(heights: waveHeights)
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)

                Button {
                    env.speaker.speak(
                        q.audio.isEmpty
                            ? (q.options.indices.contains(q.answer)
                                ? q.options[q.answer] : q.prompt)
                            : q.audio,
                        slow: true)
                } label: {
                    Text("Slower")
                        .font(.figtree(.bold, size: 11))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 9)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(
                                Color.auEdge, lineWidth: 1))
                }
                .buttonStyle(.auTap)
            }
            .padding(22)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.auFill)
            )
            .overlay(RoundedRectangle(cornerRadius: 28).strokeBorder(Color.auEdge, lineWidth: 1))
            .auLift()
            .padding(.bottom, 22)

            if r.checked {
                Text("Transcript — “\(q.audio)”")
                    .font(.figtree(.regular, size: 13))
                    .auLine(13, 1.5)
                    .foregroundStyle(Color.auTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
            }

            VStack(spacing: 10) {
                ForEach(Array(q.options.enumerated()), id: \.offset) { i, label in
                    optionRow(q: q, i: i, label: label)
                }
            }
        }
    }

    private func orderView(_ q: QuickItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Build the sentence.")
                .font(.caprasimo(size: 25))
                .tracking(-0.38)
                .padding(.bottom, 6)
            Text("\(q.prompt) Drag them, or tap.")
                .font(.figtree(.regular, size: 13.5))
                .foregroundStyle(Color.auTextSecondary)
                .padding(.bottom, 22)

            // tray
            FlowLayout(spacing: 9) {
                ForEach(Array(r.built.enumerated()), id: \.offset) { _, word in
                    Button {
                        if let idx = r.built.firstIndex(of: word) { r.unpickWord(idx) }
                    } label: {
                        Text(word)
                            .font(.figtree(.semibold, size: 15))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                LinearGradient(
                                    colors: [Color.auAccentRamp(600), Color.auAccentRamp(700)],
                                    startPoint: .top, endPoint: .bottom
                                ),
                                in: RoundedRectangle(cornerRadius: 15, style: .continuous)
                            )
                            .foregroundStyle(AUSceneArt.onAccent)
                    }
                    .buttonStyle(.auTap)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 118, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(
                        Color.auText.opacity(0.15),
                        style: StrokeStyle(lineWidth: 1.5, dash: [6, 5]))
            )
            .overlay(alignment: .topLeading) {
                if r.built.isEmpty {
                    Text("Drag or tap the words below.")
                        .font(.figtree(.regular, size: 13.5))
                        .foregroundStyle(Color.auText.opacity(0.38))
                        .padding(16)
                }
            }
            .padding(.bottom, 14)

            // bank
            FlowLayout(spacing: 9) {
                ForEach(Array(q.words.enumerated()), id: \.offset) { _, word in
                    let taken =
                        r.built.filter { $0 == word }.count >= q.words.filter { $0 == word }.count
                    Button {
                        r.pickWord(word)
                    } label: {
                        Text(word)
                            .font(.figtree(.semibold, size: 15))
                            .padding(.horizontal, 17)
                            .padding(.vertical, 11)
                            .background(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(taken ? Color.clear : Color.auFill)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .strokeBorder(
                                        taken ? Color.auText.opacity(0.12) : Color.auEdge,
                                        lineWidth: 1)
                            )
                            .foregroundStyle(taken ? Color.auText.opacity(0.25) : Color.auText)
                    }
                    .buttonStyle(.auTap)
                }
            }
        }
    }

    private func matchView(_ q: QuickItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Match the pairs.")
                .font(.caprasimo(size: 25))
                .tracking(-0.38)
                .padding(.bottom, 6)

            Text("Tap a phrase, then tap its meaning.")
                .font(.figtree(.regular, size: 13.5))
                .foregroundStyle(Color.auTextSecondary)
                .padding(.bottom, 22)

            HStack(alignment: .top, spacing: 12) {
                VStack(spacing: 10) {
                    ForEach(
                        Array(q.options.prefix(max(1, q.options.count / 2)).enumerated()),
                        id: \.offset
                    ) { i, label in
                        let on = r.sel == i
                        Button {
                            r.pickOption(i)
                        } label: {
                            HStack {
                                Text(label)
                                    .font(.figtree(.semibold, size: 14.5))
                                    .auLine(14.5, 1.35)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                if r.checked && on {
                                    AUIcon(kind: .check, size: 15, color: .auAccent2)
                                }
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(on ? Color.auAccent.opacity(0.12) : Color.auFill)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .strokeBorder(
                                        on ? Color.auAccent : Color.auEdge, lineWidth: on ? 1.5 : 1)
                            )
                            .auLift()
                        }
                        .buttonStyle(.auTap)
                    }
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 10) {
                    ForEach(
                        Array(
                            q.options.suffix(
                                from: min(q.options.count, max(1, q.options.count / 2))
                            ).enumerated()), id: \.offset
                    ) { j, label in
                        let i = max(1, q.options.count / 2) + j
                        let on = r.sel == i
                        Button {
                            r.pickOption(i)
                        } label: {
                            HStack {
                                Text(label)
                                    .font(.figtree(.semibold, size: 14.5))
                                    .auLine(14.5, 1.35)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                if r.checked && on {
                                    AUIcon(kind: .check, size: 15, color: .auAccent2)
                                }
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(on ? Color.auAccent.opacity(0.12) : Color.auFill)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .strokeBorder(
                                        on ? Color.auAccent : Color.auEdge, lineWidth: on ? 1.5 : 1)
                            )
                            .auLift()
                        }
                        .buttonStyle(.auTap)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func patternView(_ q: QuickItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(q.prompt.isEmpty ? "Notice the pattern." : q.prompt)
                .font(.caprasimo(size: 25))
                .tracking(-0.38)
                .padding(.bottom, 6)

            Text("All three are correct. No rule yet — just look.")
                .font(.figtree(.regular, size: 13.5))
                .foregroundStyle(Color.auTextSecondary)
                .padding(.bottom, 20)

            if !q.stem.isEmpty {
                let lines = q.stem.components(separatedBy: "\n").filter { !$0.isEmpty }
                VStack(spacing: 8) {
                    ForEach(Array(lines.prefix(3).enumerated()), id: \.offset) { i, line in
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text("\(i + 1)")
                                .font(.figtree(.bold, size: 11))
                                .monospacedDigit()
                                .foregroundStyle(Color.auText.opacity(0.38))
                                .frame(width: 20, alignment: .leading)
                            Text(line)
                                .font(.figtree(.semibold, size: 16))
                                .auLine(16, 1.35)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous).fill(
                                Color.auFill)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18).strokeBorder(
                                Color.auEdge, lineWidth: 1))
                    }
                }
                .padding(.bottom, 20)
            }

            if r.checked && (!q.why.isEmpty || !q.hint.isEmpty) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("THE RULE, ONCE")
                        .font(.figtree(.bold, size: 10.5))
                        .tracking(1.47)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.auAccentRamp(700))
                    Text(!q.why.isEmpty ? q.why : q.hint)
                        .font(.figtree(.regular, size: 13.5))
                        .auLine(13.5, 1.45)
                }
                .padding(EdgeInsets(top: 16, leading: 18, bottom: 16, trailing: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.auAccentRamp(100))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.auAccentRamp(200), lineWidth: 1)
                )
                .foregroundStyle(Color.auAccentRamp(800))
                .padding(.bottom, 20)
            }

            VStack(spacing: 10) {
                ForEach(Array(q.options.enumerated()), id: \.offset) { i, label in
                    optionRow(q: q, i: i, label: label)
                }
            }
        }
    }

    // MARK: option row (lines 2057–2106)

    private func optionRow(q: QuickItem, i: Int, label: String) -> some View {
        let on = r.sel == i
        let isKey = i == q.answer
        let bg: Color = {
            if r.checked && isKey { return .auOkBg }
            if r.checked && on && !isKey { return .auErrBg }
            if !r.checked && on { return Color.auFill.mixed(with: 0.18, of: Color.auAccent) }
            return .auFill
        }()
        let bd: Color = {
            if r.checked && isKey { return .auAccent2 }
            if r.checked && on && !isKey { return .auErr }
            if !r.checked && r.wrongSel == i { return .auErr }
            if !r.checked && on { return .auAccent.opacity(0.58) }
            return .auEdge
        }()

        return Button {
            r.pickOption(i)
        } label: {
            HStack(spacing: 14) {
                Text(String.letter(i))
                    .font(.figtree(.bold, size: 12))
                    .frame(width: 28, height: 28)
                    .background(
                        Circle().fill(
                            r.checked && isKey
                                ? Color.auAccent2
                                : (on ? Color.auAccent : Color.auText.opacity(0.09))
                        )
                    )
                    .foregroundStyle(
                        r.checked && isKey
                            ? AUSceneArt.onAccent2
                            : (on ? Color.auBackground : Color.auText)
                    )
                Text(label)
                    .font(.figtree(.semibold, size: 15.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
                if r.checked && isKey {
                    AUIcon(kind: .check, size: 17, color: .auOkText)
                } else if on && !isKey && r.checked {
                    AUIcon(kind: .close, size: 16, color: .auErrText)
                }
            }
            .padding(.horizontal, 17)
            .padding(.vertical, 16)
            .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(bg))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous).strokeBorder(
                    bd, lineWidth: 1))
        }
        .buttonStyle(.auTap)
        .disabled(r.checked || r.wrongSel == i)
        .opacity(!r.checked && r.wrongSel == i ? 0.5 : 1)
        .accessibilityIdentifier("au.lesson.option.\(String.letter(i))")
    }

    // MARK: verdict + primary (lines 818–837)

    @ViewBuilder
    private func verdict(q: QuickItem) -> some View {
        let ok =
            r.checked
            && (r.sel == q.answer
                || (q.type == .order && r.built.joined(separator: " ") == q.answerText))
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                AUIcon(kind: ok ? .check : .close, size: 16, color: .white)
                    .frame(width: 26, height: 26)
                    .background(Circle().fill(ok ? Color.auAccent2 : Color.auErr))
                VStack(alignment: .leading, spacing: 2) {
                    Text(
                        ok
                            ? "That’s it."
                            : (r.nudge
                                ? "Not quite — one more go."
                                : (q.type == .order
                                    ? "Not quite."
                                    : "Not quite — \(q.options.indices.contains(q.answer) ? q.options[q.answer] : "")"))
                    )
                    .font(.figtree(.bold, size: 14.5))
                    Text(
                        r.nudge
                            ? (q.hint.isEmpty ? "Look at the shape of the sentence." : q.hint)
                            : (q.why.isEmpty ? "Four pairs matched." : q.why)
                    )
                    .font(.figtree(.regular, size: 13))
                    .opacity(0.85)
                    if q.type == .order, r.checked, !ok, !r.built.isEmpty {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack(alignment: .firstTextBaseline, spacing: 9) {
                                Text("Yours")
                                    .font(.figtree(.bold, size: 9))
                                    .tracking(1.08)
                                    .frame(width: 44, alignment: .leading)
                                    .opacity(0.62)
                                Text(r.built.joined(separator: " "))
                                    .font(.figtree(.regular, size: 13))
                                    .strikethrough()
                                    .opacity(0.72)
                            }
                            HStack(alignment: .firstTextBaseline, spacing: 9) {
                                Text("Natural")
                                    .font(.figtree(.bold, size: 9))
                                    .tracking(1.08)
                                    .frame(width: 44, alignment: .leading)
                                    .opacity(0.62)
                                Text(q.answerText)
                                    .font(.figtree(.bold, size: 13))
                            }
                        }
                        .padding(.top, 11)
                    }
                }
            }
            .padding(15)
            .padding(.trailing, 2)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(ok ? Color.auOkBg : Color.auErrBg)
            )
            .foregroundStyle(ok ? Color.auOkText : Color.auErrText)
            .padding(.bottom, 12)
        }
    }

    @ViewBuilder
    private func primaryButton(list: [QuickItem]) -> some View {
        let q = list.indices.contains(r.qi) ? list[r.qi] : nil
        let needsAnswer = q.map { $0.type != .flash } ?? false
        let disabled =
            q.map {
                $0.type == .match && !r.checked || ($0.type != .flash && !r.checked && needsAnswer)
            } ?? false
        let label: String = {
            guard let q else { return "Go on" }
            if q.type == .flash { return r.flipped ? "Continue" : "Reveal the answer" }
            if r.checked { return r.qi == list.count - 1 ? "Finish lesson" : "Continue" }
            return "Check"
        }()
        // App-level `.au-btn.au-btn-primary`, not the chapter-player variant.
        APillButton(title: label, disabled: disabled) {
            r.advance(list: list)
        }
    }
}

// MARK: Result (lines 841–885)

struct ResultView: View {
    @Environment(AppEnvironment.self) private var env
    // Craft overhaul §5.1 "The Dusk Settles": the miniature path draws in
    // and its sun-dot travels to the horizon once, before the stats land.
    @State private var duskPathT: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        let r = env.router
        let scored = bank.filter { $0.type != .flash }.count

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Text(
                    r.wasReview
                        ? "Sundown · recall" : (r.starter ? "First lesson" : "Lesson complete")
                )
                .font(.figtree(.bold, size: 11))
                .tracking(1.76)
                .textCase(.uppercase)
                .foregroundStyle(Color.auAccentText)
                .padding(.bottom, 10)

                if !r.wasReview && r.lessonsDone > 0 {
                    HStack(alignment: .top, spacing: 10) {
                        AUIcon(kind: .check, size: 15, color: .auOkText)
                            .padding(.top, 3)
                        Text(
                            "You can greet someone, introduce yourself, and answer when they do the same."
                        )
                        .font(.figtree(.semibold, size: 13.5))
                        .auLine(13.5, 1.45)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 13)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.auOkBg)
                    )
                    .foregroundStyle(Color.auOkText)
                    .padding(.bottom, 14)
                }

                Text(resultHead(scored: scored))
                    .font(.caprasimo(size: 38))
                    .tracking(-0.95)
                    .auHeadLine(38, 1.05)
                    .padding(.bottom, 10)

                Text(resultBody(scored: scored))
                    .font(.figtree(.regular, size: 14.5))
                    .auLine(14.5, 1.55)
                    .foregroundStyle(Color.auTextSecondary)
                    .frame(maxWidth: 290, alignment: .leading)
                    .padding(.bottom, 30)

                // §5.1 "The Dusk Settles" — the lesson-complete signature. A
                // miniature of the home lesson-path draws itself once and its
                // sun-dot travels to the horizon: the day closes. Opacity-only
                // under Reduce Motion. No confetti (governance).
                DuskSettlesMark(drawn: duskPathT)
                    .frame(height: 54)
                    .padding(.bottom, 22)
                    .onAppear {
                        guard !reduceMotion else { duskPathT = 1; return }
                        withAnimation(.easeInOut(duration: 0.9)) { duskPathT = 1 }
                    }

                // score strip — §3.14b: the tiles stagger in as part of the
                // completion ritual (60 ms apart, the authored stagger).
                HStack(spacing: 0) {
                    statTile(
                        value: r.wasReview
                            ? "\(r.caught)/\(r.lastTotal)" : "\(r.correctCount)/\(max(1, scored))",
                        label: r.wasReview ? "Caught" : "Correct", tinted: true)
                        .auStagger(0)
                    statTile(
                        value: "\(r.wasReview ? r.caught : scored)",
                        label: r.wasReview ? "Strengthened" : "Words", tinted: false)
                        .auStagger(1)
                    statTile(value: "\(r.sessionMinutes)", label: "Minutes", tinted: false)
                        .auStagger(2)
                }
                .background(
                    RoundedRectangle(cornerRadius: 26, style: .continuous).fill(Color.auFill)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 26).strokeBorder(Color.auEdge, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                .auLift()
                .padding(.bottom, 22)
                // §3.14 AX: one summary beats three loose numerals.
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(
                    r.wasReview
                        ? "Caught \(r.caught) of \(r.lastTotal). \(r.caught) strengthened. \(r.sessionMinutes) minutes."
                        : "Correct \(r.correctCount) of \(max(1, scored)). \(scored) words. \(r.sessionMinutes) minutes."
                )

                // streak card
                ACard(radius: 28) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(
                                r.wasReview
                                    ? "Today, held"
                                    : (r.streak > 1 ? "Your streak" : "Your streak begins")
                            )
                            .font(.caprasimo(size: 18))
                            Spacer()
                            Text("\(max(r.streak, 0))")
                                .font(.figtree(.bold, size: 25))
                                .monospacedDigit()
                                .tracking(-0.5)
                                .foregroundStyle(Color.auAccentText)
                        }
                        .padding(.bottom, 14)
                        resultWeekDots
                    }
                }
                .padding(.bottom, 14)

                if !r.mistakes.isEmpty {
                    Button {
                        r.nav(.review)
                    } label: {
                        HStack(spacing: 14) {
                            AUIcon(kind: .alert, size: 18, color: .auTintText)
                                .frame(width: 40, height: 40)
                                .background(Circle().fill(Color.auTintBg))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(
                                    "\(r.mistakes.count == 1 ? "1 item" : "\(r.mistakes.count) items") to revisit"
                                )
                                .font(.figtree(.semibold, size: 15))
                                Text("Review before they settle wrong")
                                    .font(.figtree(.regular, size: 12.5))
                                    .foregroundStyle(Color.auTextSecondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            AUIcon(kind: .chevron, size: 17, color: .auText.opacity(0.4))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 26, style: .continuous).strokeBorder(
                                Color.auDivider, lineWidth: 1))
                    }
                    .buttonStyle(.auTap)
                    .padding(.bottom, 14)
                }

                Spacer(minLength: 16)

                HStack(spacing: 12) {
                    ShareLink(
                        item: "I completed today's lesson on Aurel! Streak: \(max(r.streak, 1)) days unhurried English learning.",
                        preview: SharePreview("Aurel Daily Milestone", image: Image(systemName: "sun.max.fill"))
                    ) {
                        HStack(spacing: 8) {
                            AUIcon(kind: .star, size: 16, color: .auAccentText)
                            Text("Share milestone")
                                .font(.figtree(.semibold, size: 14))
                                .foregroundStyle(Color.auAccentText)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .strokeBorder(Color.auEdge, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.auTap)
                }
                .padding(.bottom, 10)

                APillButton(
                    title: r.starter
                        ? "Open my path"
                        : (r.wasReview ? "Back to the path — today is done" : "Back to the path")
                ) {
                    r.nav(.home)
                }
                .padding(.bottom, 8)

                ALinkButton(title: "Practise this lesson again") {
                    r.restartLesson()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 74)
            .padding(.bottom, 32)
            // §3.13d: the authored 874 pt canvas frame is gone — the column
            // flows to its content on every device height.
        }
        .background {
            // `.au-rays` + `.au-amb` (two drifting orbs) + `.au-contour`
            ZStack {
                Color.auBackground
                AURays()
                AmbientOrbs()
                AUContour()
            }
            .ignoresSafeArea()
        }
        // §5.3 "Dawn" — the first-lesson-ever signature. The Welcome dawn-sky
        // returns as a full-bleed wash behind the result card, once per user.
        .overlay {
            if r.starter && !dawnShown {
                AUGradients.sky
                    .opacity(dawnWash)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                    .onAppear {
                        guard !reduceMotion else { dawnWash = 0.18; dawnShown = true; return }
                        withAnimation(.easeInOut(duration: 0.5)) { dawnWash = 0.35 }
                        withAnimation(.easeInOut(duration: 0.5).delay(0.5)) { dawnWash = 0.18 }
                        dawnShown = true
                    }
            }
        }
        .auScreenEntrance()
        // §3.14 completion moment: the calm ritual fires exactly once per
        // result — success haptic, the three-note arpeggio, one summary
        // announcement. No confetti (governance).
        .onAppear {
            guard !ritualFired else { return }
            ritualFired = true
            AUFeedback.lessonComplete()
            AUSound.shared.complete()
            AUAX.announce(
                r.wasReview
                    ? "Review finished. \(r.caught) of \(r.lastTotal) caught."
                    : "Lesson finished. \(r.correctCount) of \(max(1, scored)) correct."
            )
        }
    }

    @State private var ritualFired = false
    // §5.3 state
    @State private var dawnShown = false
    @State private var dawnWash: CGFloat = 0
    private var bank: [QuickItem] { QuickItem.bank(from: env.course) }

    /// §5.1 "The Dusk Settles" — the lesson-complete signature mark. A
    /// miniature of the home lesson-path; `drawn` drives both the thread
    /// trim and the sun-dot's travel to the horizon in one gesture.
    private struct DuskSettlesMark: View {
        var drawn: CGFloat

        var body: some View {
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                let path = Self.thread(in: CGSize(width: w, height: h))
                ZStack(alignment: .topLeading) {
                    path
                        .trim(from: 0, to: drawn)
                        .stroke(
                            Color.auAccent,
                            style: StrokeStyle(lineWidth: 2, lineCap: .round)
                        )
                    // The sun-dot rides the thread to the horizon.
                    let pt = path.trimmedPath(from: 0, to: max(0.001, drawn)).currentPoint
                        ?? CGPoint(x: 0, y: h * 0.7)
                    Circle()
                        .fill(AUSceneArt.sunMid)
                        .frame(width: 10, height: 10)
                        .shadow(color: Color.auAccent.opacity(0.4), radius: 4)
                        .position(pt)
                        .opacity(drawn > 0 ? 1 : 0)
                }
            }
            .accessibilityHidden(true)
        }

        /// A gentle two-curve winding path echoing the home lesson path.
        private static func thread(in size: CGSize) -> Path {
            var p = Path()
            let w = size.width
            let h = size.height
            p.move(to: CGPoint(x: 0, y: h * 0.7))
            p.addQuadCurve(
                to: CGPoint(x: w * 0.5, y: h * 0.35),
                control: CGPoint(x: w * 0.25, y: h * 0.05))
            p.addQuadCurve(
                to: CGPoint(x: w, y: h * 0.55),
                control: CGPoint(x: w * 0.75, y: h * 0.65))
            return p
        }
    }

    private var resultWeekDots: some View {
        // §3.14: the strip is real history now — a dot fills when that
        // day's two halves both landed (`weekCompletedDays`), today
        // included; days after today stay quiet.
        let completed = env.router.weekCompletedDays()
        return HStack(spacing: 7) {
            ForEach(Array(["M", "T", "W", "T", "F", "S", "S"].enumerated()), id: \.offset) {
                i, label in
                VStack(spacing: 7) {
                    Capsule()
                        .fill(
                            completed[i]
                                ? AnyShapeStyle(
                                    LinearGradient(
                                        colors: [
                                            Color.auAccent.mixed(with: 0.26, of: .white),
                                            Color.auAccent,
                                        ],
                                        startPoint: .top, endPoint: .bottom
                                    )
                                )
                                : AnyShapeStyle(Color.auText.opacity(0.10))
                        )
                        .frame(height: 34)
                        .shadow(color: completed[i] ? Color.auGlow : .clear, radius: 4, y: 3)
                    Text(label)
                        .font(.figtree(.regular, size: 10))
                        .foregroundStyle(Color.auTextTertiary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("This week: \(completed.filter { $0 }.count) of 7 days complete")
    }

    private func statTile(value: String, label: String, tinted: Bool) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(value)
                .font(.figtree(.bold, size: 31))
                .monospacedDigit()
                .tracking(-0.93)
                .foregroundStyle(tinted ? Color.auAccentText : Color.auText)
            Text(label.uppercased())
                .font(.figtree(.semibold, size: 10.5))
                .tracking(1.05)
                .foregroundStyle(Color.auTextTertiary)
                .padding(.top, 7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 22)
        .padding(.horizontal, 14)
        .overlay(alignment: .leading) {
            if tinted == false { Rectangle().fill(Color.auEdge).frame(width: 1) }
        }
    }

    private func resultHead(scored: Int) -> String {
        let r = env.router
        if r.wasReview { return r.mistakes.isEmpty ? "All caught." : "Most of them caught." }
        return r.correctCount >= scored ? "Cleanly done." : "A start is a start."
    }

    private func resultBody(scored: Int) -> String {
        let r = env.router
        if r.wasReview {
            if r.mistakes.isEmpty {
                return
                    "\(r.caught)\(r.caught == 1 ? " item goes back on a wider interval. Nothing is due until tomorrow." : " items go back on a wider interval. Nothing is due until tomorrow.")"
            }
            return
                "\(r.caught) caught. \(r.mistakes.count)\(r.mistakes.count == 1 ? " returns tomorrow, closer in." : " return tomorrow, closer in.")"
        }
        if r.correctCount >= scored {
            return "Greetings are settled. Introductions opens next."
        }
        return r.mistakes.count == 1
            ? "One item comes back tomorrow, then on a widening interval."
            : "\(r.mistakes.count) items come back tomorrow, then on a widening interval."
    }
}

private struct LessonWaveform: View {
    let heights: [CGFloat]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(heights.enumerated()), id: \.offset) { i, height in
                LessonWaveBar(height: height, index: i)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private struct LessonWaveBar: View {
        let height: CGFloat
        let index: Int
        @Environment(\.accessibilityReduceMotion) private var reduceMotion
        @State private var compressed = false

        var body: some View {
            Capsule()
                .fill(Color.auAccent.opacity(0.4))
                .frame(height: height)
                .scaleEffect(y: reduceMotion ? 1 : (compressed ? 0.35 : 1), anchor: .center)
                .onAppear {
                    guard !reduceMotion else { return }
                    withAnimation(
                        .easeInOut(duration: 0.7 + Double(index % 5) * 0.14)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.05)
                    ) {
                        compressed = true
                    }
                }
        }
    }
}
