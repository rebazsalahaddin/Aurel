import SwiftUI

// MARK: - Quick practice + Result
//
// The lesson runner (Aurel.dc.html lines 640–839) and the result screen
// (lines 841–885), driven by AppRouter's ported advance()/check() logic.

// MARK: Lesson runner

struct LessonRunnerView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        let r = env.router
        let list = r.reviewMode
            ? r.queue.compactMap { bank.indices.contains($0) ? bank[$0] : nil }
            : bank

        ZStack(alignment: .bottom) {
            Color.auBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                header(list: list)
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        if list.indices.contains(r.qi) {
                            itemView(list[r.qi])
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 190)
                }
            }

            // verdict dock
            VStack(spacing: 0) {
                if r.checked || r.nudge, let q = list.indices.contains(r.qi) ? list[r.qi] : nil, q.type != .flash {
                    verdict(q: q)
                }
                primaryButton(list: list)
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
            .padding(.bottom, 30)
            .background(
                AUGradients.glass()
                    .clipShape(Rectangle())
                    .overlay(alignment: .top) { Divider().overlay(Color.auEdge) }
                    .ignoresSafeArea(edges: .bottom)
            )
        }
        .auScreenEntrance()
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
                    Capsule()
                        .fill(k < r.qi ? Color.auAccent : (k == r.qi ? Color.auAccent.opacity(0.55) : Color.auText.opacity(0.12)))
                        .frame(height: 4)
                }
            }

            Text("\(r.qi + 1) / \(list.count)")
                .font(.figtree(.regular, size: 11.5))
                .foregroundStyle(Color.auText.opacity(0.45))
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
        case .match, .pattern: choiceView(q)
        }
    }

    private func flashView(_ q: QuickItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Turn the card.")
                .font(.caprasimo(size: 25))
                .tracking(-0.38)
                .padding(.bottom, 22)

            ZStack {
                if r.flipped {
                    // back
                    VStack(alignment: .leading, spacing: 0) {
                        Text(q.back)
                            .font(.figtree(.semibold, size: 16))
                            .lineSpacing(16 * 0.5)
                        if !q.ex.isEmpty {
                            Text(q.ex)
                                .font(.figtree(.regular, size: 14))
                                .italic()
                                .lineSpacing(14 * 0.55)
                                .opacity(0.82)
                                .padding(.top, 18)
                                .overlay(alignment: .top) { Divider().overlay(Color(red: 0.969, green: 0.910, blue: 0.820).opacity(0.2)).padding(.top, -9) }
                        }
                        Spacer(minLength: 12)
                        Text("Tap to hide")
                            .font(.figtree(.regular, size: 11))
                            .tracking(1.1)
                            .textCase(.uppercase)
                            .opacity(0.7)
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
                } else {
                    // front
                    VStack(spacing: 0) {
                        if let ill = q.ill {
                            IllustrationPlaceholder(ill: ill, height: 96, cornerRadius: 20, kickerSize: 8, captionSize: 10)
                                .padding(.bottom, 10)
                        }
                        Text(q.front)
                            .font(.caprasimo(size: 28))
                            .tracking(-0.56)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 16)
                        Text("Tap to reveal")
                            .font(.figtree(.regular, size: 11.5))
                            .tracking(1.15)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auText.opacity(0.38))
                    }
                    .padding(26)
                    .frame(height: 320)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color.auFill)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .strokeBorder(Color.auEdge, lineWidth: 1)
                    )
                    .auLift()
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .onTapGesture { r.flip() }
            .padding(.bottom, 20)

            HStack(spacing: 9) {
                Button {
                    // word sheet in the prototype — opens the first word record
                } label: {
                    Text("Word detail")
                        .font(.figtree(.bold, size: 13))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 17, style: .continuous).strokeBorder(Color.auEdge, lineWidth: 1))
                        .foregroundStyle(Color.auText.opacity(0.62))
                }
                .buttonStyle(.auTap)

                APillButton(title: "I knew it", variant: .quiet, compact: true) { r.advance(list: bank) }
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
                    .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(Color.auEdge, lineWidth: 1))
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
                    env.speaker.speak(q.options.indices.contains(q.answer) ? q.options[q.answer] : q.prompt, slow: false)
                } label: {
                    AUIcon(kind: .ear, size: 24, color: .auBackground)
                        .frame(width: 58, height: 58)
                        .background(Circle().fill(Color.auAccent))
                }
                .buttonStyle(.auTap)
                .accessibilityLabel("Play audio")

                let waveHeights: [CGFloat] = (0..<18).map { i in
                    CGFloat(8 + Int(20 * abs(sin(Double(i) * 0.7))))
                }
                WaveForm(heights: waveHeights, color: .auAccent)
                    .frame(height: 38)

                Button {
                    env.speaker.speak(q.options.indices.contains(q.answer) ? q.options[q.answer] : q.prompt, slow: true)
                } label: {
                    Text("Slower")
                        .font(.figtree(.bold, size: 11))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 9)
                        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(Color.auEdge, lineWidth: 1))
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
                    .lineSpacing(13 * 0.5)
                    .foregroundStyle(Color.auText.opacity(0.58))
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
                .foregroundStyle(Color.auText.opacity(0.52))
                .padding(.bottom, 22)

            // tray
            FlowLayout(spacing: 9) {
                ForEach(Array(r.built.enumerated()), id: \.offset) { _, word in
                    Button {
                        if let idx = r.built.firstIndex(of: word) { r.unpickWord(idx) }
                    } label: {
                        Text(word)
                            .font(.caprasimo(size: 19))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 11)
                            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.auTintBg))
                            .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Color.auAccent.opacity(0.34), lineWidth: 1.5))
                            .foregroundStyle(Color.auTintText)
                    }
                    .buttonStyle(.auTap)
                }
            }
            .frame(minHeight: 74, alignment: .leading)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Color.auAccent.opacity(0.36), style: StrokeStyle(lineWidth: 1.5, dash: [6, 5]))
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
                    let taken = r.built.filter { $0 == word }.count >= q.words.filter { $0 == word }.count
                    Button {
                        r.pickWord(word)
                    } label: {
                        Text(word)
                            .font(.caprasimo(size: 19))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 11)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(taken ? Color.clear : Color.auFill)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .strokeBorder(taken ? Color.auText.opacity(0.12) : Color.auEdge, lineWidth: 1.5)
                            )
                            .foregroundStyle(taken ? Color.auText.opacity(0.25) : Color.auText)
                    }
                    .buttonStyle(.auTap)
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
            if on && !isKey { return .auErrBg }
            if on { return Color.auFill.mixed(with: 0.18, of: Color.auAccent) }
            return .auFill
        }()
        let bd: Color = {
            if r.checked && isKey { return .auAccent2 }
            if on && !isKey { return .auErr }
            if on { return .auAccent.opacity(0.58) }
            return .auEdge
        }()

        return Button {
            r.pickOption(i)
        } label: {
            HStack(spacing: 14) {
                Text(String.letter(i))
                    .font(.figtree(.bold, size: 12))
                    .frame(width: 28, height: 28)
                    .background(Circle().fill(on || (r.checked && isKey) ? Color.auAccent : Color.auText.opacity(0.09)))
                    .foregroundStyle(on || (r.checked && isKey) ? Color.auBackground : Color.auText)
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
            .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).strokeBorder(bd, lineWidth: 1))
        }
        .buttonStyle(.auTap)
        .disabled(r.checked)
    }

    // MARK: verdict + primary (lines 818–837)

    @ViewBuilder
    private func verdict(q: QuickItem) -> some View {
        let ok = r.checked && (r.sel == q.answer || (q.type == .order && r.built.joined(separator: " ") == q.answerText))
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                AUIcon(kind: ok ? .check : .close, size: 16, color: .white)
                    .frame(width: 26, height: 26)
                    .background(Circle().fill(ok ? Color.auAccent2 : Color.auErr))
                VStack(alignment: .leading, spacing: 2) {
                    Text(ok ? "That’s it." : (r.nudge ? "Not quite — one more go." : (q.type == .order ? "Not quite." : "Not quite — \(q.options.indices.contains(q.answer) ? q.options[q.answer] : "")")))
                        .font(.figtree(.bold, size: 14.5))
                    Text(r.nudge ? (q.hint.isEmpty ? "Look at the shape of the sentence." : q.hint) : (q.why.isEmpty ? "Four pairs matched." : q.why))
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
        let disabled = q.map { $0.type == .match && !r.checked || ($0.type != .flash && !r.checked && needsAnswer) } ?? false
        let label: String = {
            guard let q else { return "Go on" }
            if q.type == .flash { return r.flipped ? "Next" : "Turn the card" }
            return "Check"
        }()
        APillButton(title: label, icon: .arrow, disabled: disabled) {
            r.advance(list: list)
        }
    }
}

// MARK: Result (lines 841–885)

struct ResultView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        let r = env.router
        let scored = bank.filter { $0.type != .flash }.count

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Text(r.wasReview ? "Sundown · recall" : (r.starter ? "First lesson" : "Lesson complete"))
                    .font(.figtree(.bold, size: 11))
                    .tracking(1.76)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.auAccentText)
                    .padding(.bottom, 10)

                if !r.wasReview && r.lessonsDone > 0 {
                    HStack(alignment: .top, spacing: 10) {
                        AUIcon(kind: .check, size: 15, color: .auOkText)
                            .padding(.top, 3)
                        Text("You can greet someone, introduce yourself, and answer when they do the same.")
                            .font(.figtree(.semibold, size: 13.5))
                            .lineSpacing(13.5 * 0.45)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 13)
                    .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.auOkBg))
                    .foregroundStyle(Color.auOkText)
                    .padding(.bottom, 14)
                }

                Text(resultHead(scored: scored))
                    .font(.caprasimo(size: 38))
                    .tracking(-0.95)
                    .lineSpacing(38 * 0.05)
                    .padding(.bottom, 10)

                Text(resultBody(scored: scored))
                    .font(.figtree(.regular, size: 14.5))
                    .lineSpacing(14.5 * 0.55)
                    .foregroundStyle(Color.auText.opacity(0.55))
                    .frame(maxWidth: 290, alignment: .leading)
                    .padding(.bottom, 30)

                // score strip
                HStack(spacing: 0) {
                    statTile(value: r.wasReview ? "\(r.caught)/\(r.lastTotal)" : "\(r.correctCount)/\(max(1, scored))",
                             label: r.wasReview ? "Caught" : "Correct", tinted: true)
                    statTile(value: "\(r.wasReview ? r.caught : 12)", label: r.wasReview ? "Strengthened" : "Words", tinted: false)
                    statTile(value: r.wasReview ? "1" : "6", label: "Minutes", tinted: false)
                }
                .background(RoundedRectangle(cornerRadius: 26, style: .continuous).fill(Color.auFill))
                .overlay(RoundedRectangle(cornerRadius: 26).strokeBorder(Color.auEdge, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                .auLift()
                .padding(.bottom, 22)

                // streak card
                ACard(radius: 28) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(r.wasReview ? "Today, held" : (r.streak > 1 ? "Your streak" : "Your streak begins"))
                                .font(.caprasimo(size: 18))
                            Spacer()
                            Text("1")
                                .font(.figtree(.bold, size: 25))
                                .monospacedDigit()
                                .tracking(-0.5)
                                .foregroundStyle(Color.auAccentText)
                        }
                        .padding(.bottom, 14)
                        WeekDots(todayIndex: 0)
                    }
                }
                .padding(.bottom, 14)

                if !r.mistakes.isEmpty {
                    Button {
                        r.nav(.review)
                    } label: {
                        HStack(spacing: 14) {
                            AUIcon(kind: .loop, size: 18, color: .auTintText)
                                .frame(width: 40, height: 40)
                                .background(Circle().fill(Color.auTintBg))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(r.mistakes.count == 1 ? "1 item" : "\(r.mistakes.count) items") to revisit")
                                    .font(.figtree(.semibold, size: 15))
                                Text("Review before they settle wrong")
                                    .font(.figtree(.regular, size: 12.5))
                                    .foregroundStyle(Color.auText.opacity(0.50))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            AUIcon(kind: .arrow, size: 17, color: .auText.opacity(0.4))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                        .background(RoundedRectangle(cornerRadius: 26, style: .continuous).strokeBorder(Color.auDivider, lineWidth: 1))
                    }
                    .buttonStyle(.auTap)
                    .padding(.bottom, 14)
                }

                Spacer(minLength: 16)

                APillButton(title: r.starter ? "Open my path" : (r.wasReview ? "Back to the path — today is done" : "Back to the path")) {
                    r.nav(.home)
                }
                .padding(.bottom, 8)

                ALinkButton(title: "Practise this lesson again") {
                    r.restartLesson()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 74)
            .padding(.bottom, 40)
        }
        .background(Color.auBackground.ignoresSafeArea())
        .auScreenEntrance()
    }

    private var bank: [QuickItem] { QuickItem.bank(from: env.course) }

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
                .foregroundStyle(Color.auText.opacity(0.45))
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
                return "\(r.caught)\(r.caught == 1 ? " item goes back on a wider interval. Nothing is due until tomorrow." : " items go back on a wider interval. Nothing is due until tomorrow.")"
            }
            return "\(r.caught) caught. \(r.mistakes.count)\(r.mistakes.count == 1 ? " returns tomorrow, closer in." : " return tomorrow, closer in.")"
        }
        if r.correctCount >= scored {
            return "Greetings are settled. Introductions opens next."
        }
        return r.mistakes.count == 1
            ? "One item comes back tomorrow, then on a widening interval."
            : "\(r.mistakes.count) items come back tomorrow, then on a widening interval."
    }
}
