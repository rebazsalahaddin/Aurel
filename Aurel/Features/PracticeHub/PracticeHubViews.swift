import SwiftUI

// MARK: - Practice hub: Stories · Scene · Speak · Review · Hunt/Reader stubs
//
// Ported from Aurel.dc.html lines 993–1273 (+ STORY/HUNT_STUB constants,
// scene thread, sayItem chunk search).

// MARK: Stories hub (Practice tab)

struct StoriesView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        let r = env.router
        ZStack(alignment: .bottom) {
            Color.auBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Practice")
                        .font(.caprasimo(size: 34))
                        .tracking(-0.85)
                        .padding(.bottom, 24)

                    hubRow(
                        icon: .match, tint: Color.auAccent2Ramp(600),
                        iconFg: AUSceneArt.onAccent2,
                        title: "Scenes",
                        sub: r.sceneTurn > 0 ? "In progress — \(env.scene.title)" : env.scene.title,
                        radius: 28, filled: true
                    ) { r.nav(.scene) }
                    .padding(.bottom, 12)

                    hubRow(
                        icon: .mic, tint: Color.auAccentRamp(600),
                        iconFg: AUSceneArt.onAccent,
                        title: "Say it aloud",
                        sub: "Hear it, say it, compare — no score",
                        radius: 28, filled: true
                    ) { r.nav(.speak) }
                    .padding(.bottom, 12)

                    hubRow(
                        icon: .loop, tint: .clear, iconFg: .auAccent,
                        title: "Review mistakes",
                        sub: r.mistakes.isEmpty
                            ? "Empty — nothing has slipped yet" : "\(r.mistakes.count) waiting",
                        radius: 26, filled: false
                    ) { r.nav(.review) }
                    .padding(.bottom, 26)

                    // Find three words — the honest stub entry
                    Button {
                        r.nav(.hunt)
                    } label: {
                        HStack(spacing: 16) {
                            AUIcon(kind: .tap, size: 19, color: .auAccent)
                                .frame(width: 42, height: 42)
                                .background(Circle().fill(Color.auText.opacity(0.08)))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Find three words")
                                    .font(.figtree(.semibold, size: 15.5))
                                Text("Awaiting course content")
                                    .font(.figtree(.regular, size: 12.5))
                                    .foregroundStyle(Color.auText.opacity(0.50))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Text("New")
                                .font(.figtree(.bold, size: 9.5))
                                .tracking(1.14)
                                .textCase(.uppercase)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(Color.auText.opacity(0.08)))
                                .foregroundStyle(Color.auText.opacity(0.50))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 26, style: .continuous)
                                .strokeBorder(
                                    Color.auText.opacity(0.20),
                                    style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
                        )
                    }
                    .buttonStyle(.auTap)
                    .padding(.bottom, 26)

                    HStack(alignment: .firstTextBaseline) {
                        Text("Stories")
                            .font(.figtree(.bold, size: 10.5))
                            .tracking(1.47)
                        Spacer()
                        Text("Authored texts")
                            .font(.figtree(.regular, size: 11.5))
                            .foregroundStyle(Color.auText.opacity(0.45))
                    }
                    .padding(.bottom, 14)

                    // stories list (line 2480) — open the chapter player on the reading screen
                    ForEach(Array(storyRows.enumerated()), id: \.offset) { i, st in
                        storyRow(st) {
                            if let open = st.open { open() } else { r.nav(.reader) }
                        }
                        .auStagger(i)
                        .padding(.bottom, 12)
                    }

                    Text(
                        "Reading opens where the chapter authored it. A separate graded-reader bank is still to be written."
                    )
                    .font(.figtree(.regular, size: 12))
                    .lineSpacing(12 * 0.5)
                    .foregroundStyle(Color.auText.opacity(0.45))
                    .padding(.bottom, 44)
                }
                .padding(.horizontal, 24)
                .padding(.top, 70)
                .padding(.bottom, 130)
            }

            AUTabBar(current: .stories)
                .padding(.horizontal, 14)
                .padding(.bottom, 26)
        }
        .auScreenEntrance()
    }

    private struct StoryRow {
        let title: String
        let meta: String
        let band: String
        let mark: String
        let locked: Bool
        let open: (() -> Void)?
    }

    private var storyRows: [StoryRow] {
        let r = env.router
        func openReading(_ chIdx: Int, _ lesIdx: Int) -> (() -> Void)? {
            let course = env.course
            guard course.chapters.indices.contains(chIdx),
                course.chapters[chIdx].lessons.indices.contains(lesIdx)
            else { return nil }
            let lesson = course.chapters[chIdx].lessons[lesIdx]
            let at = lesson.screens.firstIndex { $0.kind == .reading } ?? 0
            let pos = course.coursePos(chapterIdx: chIdx, lessonIdx: lesIdx) + at
            return {
                r.chapterIdx = chIdx
                r.courseLesson = min(lesIdx, 3)
                r.coursePos = pos
                r.pending = nil
                r.reviewMode = false
                r.screen = .course
            }
        }
        return [
            StoryRow(
                title: "Name badges and the welcome card", meta: "Chapter 1 · Lesson 3 · S27–S28",
                band: "A1", mark: "I", locked: false, open: openReading(0, 2)),
            StoryRow(
                title: "The register form and a message card",
                meta: "Chapter 2 · Lesson 3 · S28–S29", band: "A1", mark: "II", locked: false,
                open: openReading(1, 2)),
            StoryRow(
                title: "Three profile cards and the class roll", meta: "Chapter 3 · Lesson 3 · S23",
                band: "A1", mark: "III", locked: false, open: openReading(2, 2)),
            StoryRow(
                title: "Graded readers",
                meta: "Awaiting content — ≥9 genres planned across 12 chapters", band: "soon",
                mark: "·", locked: true, open: nil),
        ]
    }

    private func storyRow(_ st: StoryRow, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Text(st.mark)
                    .font(.caprasimo(size: 26))
                    .frame(width: 74, height: 74)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(st.band == "A1" ? Color.auAccentRamp(200) : Color.auNeutral(300))
                    )
                    .foregroundStyle(
                        st.band == "A1" ? Color.auAccentRamp(800) : Color.auNeutral(800))
                VStack(alignment: .leading, spacing: 4) {
                    Text(st.title)
                        .font(.caprasimo(size: 17))
                        .lineSpacing(17 * 0.2)
                    Text(st.meta)
                        .font(.figtree(.regular, size: 12.5))
                        .foregroundStyle(Color.auText.opacity(0.52))
                    Text(st.band)
                        .font(.figtree(.regular, size: 10.5))
                        .tracking(0.42)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(st.band == "A1" ? Color.auOkBg : Color.auFlatBg))
                        .foregroundStyle(st.band == "A1" ? Color.auOkQuiet : Color.auFlatText)
                        .padding(.top, 9)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                if st.locked {
                    AUIcon(kind: .lock, size: 17, color: .auText.opacity(0.35))
                }
            }
            .padding(15)
            .background(RoundedRectangle(cornerRadius: 28, style: .continuous).fill(Color.auFill))
            .overlay(RoundedRectangle(cornerRadius: 28).strokeBorder(Color.auEdge, lineWidth: 1))
            .auLift()
            .opacity(st.locked ? 0.5 : 1)
        }
        .buttonStyle(.auTap)
    }

    private func hubRow(
        icon: AUIcon.Kind, tint: Color, iconFg: Color, title: String, sub: String, radius: CGFloat,
        filled: Bool, action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                AUIcon(kind: icon, size: 21, color: iconFg)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(tint))
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.caprasimo(size: 19))
                    Text(sub)
                        .font(.figtree(.regular, size: 12.5))
                        .foregroundStyle(Color.auText.opacity(0.52))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                AUIcon(kind: .arrow, size: 17, color: .auText.opacity(0.4))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 19)
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous).fill(Color.auFill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius).strokeBorder(Color.auEdge, lineWidth: 1)
            )
            .auLift()
        }
        .buttonStyle(.auTap)
    }
}

// MARK: Scene player (lines 1101–1152)

struct SceneView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        let r = env.router
        let sc = env.scene

        VStack(spacing: 0) {
            // header
            HStack(alignment: .top, spacing: 12) {
                Button {
                    r.leaveScene()
                } label: {
                    AUIcon(kind: .close, size: 19, color: .auText.opacity(0.55))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.auTap)
                .accessibilityLabel("Leave the scene")

                VStack(alignment: .leading, spacing: 0) {
                    Text("Scene")
                        .font(.figtree(.bold, size: 10))
                        .tracking(1.6)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.auAccentText)
                        .padding(.bottom, 5)
                    Text(sc.title)
                        .font(.caprasimo(size: 19))
                        .lineSpacing(19 * 0.2)
                    Text(
                        r.sceneRoleB
                            ? "Two of you, one script. You take the learner turns; they read the partner."
                            : sc.role
                    )
                    .font(.figtree(.regular, size: 12.5))
                    .lineSpacing(12.5 * 0.45)
                    .foregroundStyle(Color.auText.opacity(0.52))
                    .padding(.top, 4)
                    HStack(spacing: 6) {
                        modeChip("On your own", on: !r.sceneRoleB) { r.setSolo() }
                        modeChip("Two phones", on: r.sceneRoleB) { r.setDuo() }
                    }
                    .padding(.top, 11)
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 70)
            .padding(.bottom, 18)
            .overlay(alignment: .bottom) { Divider().overlay(Color.auDivider) }

            // thread
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(0...min(r.sceneTurn, max(0, sc.turns.count - 1)), id: \.self) { i in
                        let turn = sc.turns[i]
                        VStack(alignment: .leading, spacing: 0) {
                            if r.sceneRoleB && i == r.sceneTurn {
                                Text("Their line — pass the phone, or read it aloud")
                                    .font(.figtree(.bold, size: 9.5))
                                    .tracking(1.33)
                                    .textCase(.uppercase)
                                    .foregroundStyle(Color.auText.opacity(0.42))
                                    .padding(.bottom, 5)
                            }
                            Text(turn.them)
                                .font(.figtree(.regular, size: 14.5))
                                .lineSpacing(14.5 * 0.45)
                                .padding(.horizontal, 17)
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    UnevenCorners(bottomTrailing: 7)
                                        .fill(
                                            r.sceneRoleB
                                                ? Color.auTintBg.opacity(0.5) : Color.auFill)
                                )
                                .overlay(
                                    UnevenCorners(bottomTrailing: 7)
                                        .stroke(
                                            r.sceneRoleB
                                                ? Color.auAccent.opacity(0.4) : Color.auEdge,
                                            lineWidth: r.sceneRoleB ? 1.5 : 1)
                                )

                            if let pickIdx = r.scenePicks.indices.contains(i)
                                ? r.scenePicks[i] : nil,
                                turn.replies.indices.contains(pickIdx)
                            {
                                let reply = turn.replies[pickIdx]
                                VStack(alignment: .trailing, spacing: 7) {
                                    Text(reply.t)
                                        .font(.figtree(.regular, size: 14.5))
                                        .lineSpacing(14.5 * 0.45)
                                        .padding(.horizontal, 17)
                                        .padding(.vertical, 14)
                                        .background(
                                            UnevenCorners(bottomTrailing: 22).fill(
                                                Color.auAccentRamp(600))
                                        )
                                        .foregroundStyle(AUSceneArt.onAccent)
                                    if !reply.reg.isEmpty {
                                        Text(reply.reg)
                                            .font(.figtree(.regular, size: 12.5))
                                            .lineSpacing(12.5 * 0.5)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 11)
                                            .background(
                                                RoundedRectangle(
                                                    cornerRadius: 16, style: .continuous
                                                ).fill(Color.auOkBg)
                                            )
                                            .foregroundStyle(Color.auOkText)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 8)
            }

            // replies
            VStack(alignment: .leading, spacing: 0) {
                if r.sceneTurn < sc.turns.count {
                    HStack {
                        Text("Your reply")
                            .font(.figtree(.bold, size: 10))
                            .tracking(1.4)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auText.opacity(0.48))
                        Spacer()
                        Button {
                        } label: {
                            Text("Hear that again")
                                .font(.figtree(.bold, size: 11.5))
                                .foregroundStyle(Color.auAccentText)
                        }
                        .buttonStyle(.auTap)
                    }
                    .padding(.bottom, 11)

                    VStack(spacing: 9) {
                        ForEach(Array((sc.turns[r.sceneTurn].replies).enumerated()), id: \.offset) {
                            i, reply in
                            Button {
                                r.pickSceneReply(i, turnCount: sc.turns.count)
                            } label: {
                                Text(reply.t)
                                    .font(.figtree(.semibold, size: 14.5))
                                    .lineSpacing(14.5 * 0.4)
                                    .padding(.horizontal, 17)
                                    .padding(.vertical, 15)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous).fill(
                                            Color.auFill)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20).strokeBorder(
                                            Color.auEdge, lineWidth: 1))
                            }
                            .buttonStyle(.auTap)
                        }
                    }
                } else {
                    HStack(alignment: .top, spacing: 11) {
                        AUIcon(kind: .check, size: 15, color: .auOkText)
                            .padding(.top, 3)
                        Text(sc.close)
                            .font(.figtree(.semibold, size: 13.5))
                            .lineSpacing(13.5 * 0.45)
                    }
                    .padding(.horizontal, 17)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous).fill(Color.auOkBg)
                    )
                    .foregroundStyle(Color.auOkText)
                    .padding(.bottom, 12)

                    APillButton(title: "Say it yourself") { r.nav(.speak) }
                        .padding(.bottom, 6)
                    ALinkButton(title: "Play the scene again") { r.replayScene() }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 14)
            .padding(.bottom, 26)
            .overlay(alignment: .top) { Divider().overlay(Color.auDivider) }
        }
        .background(Color.auBackground.ignoresSafeArea())
        .auScreenEntrance()
    }

    private func modeChip(_ label: String, on: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.figtree(.bold, size: 11.5))
                .padding(.horizontal, 13)
                .padding(.vertical, 7)
                .background(Capsule().fill(on ? Color.auAccent : Color.auText.opacity(0.08)))
                .foregroundStyle(on ? Color.auBackground : Color.auText.opacity(0.55))
        }
        .buttonStyle(.auTap)
    }
}

// MARK: Say-aloud (lines 1154–1238)

struct SpeakView: View {
    @Environment(AppEnvironment.self) private var env

    /// sayItem — the newest authored chunk frame with a sentence in it.
    private var sayItem: (line: String, ctx: String) {
        for f in env.course.flat.reversed() {
            if case .cards(let c) = f.screen.payload {
                for card in c.cards ?? [] {
                    if card.chunk ?? false, let frame = card.frame,
                        frame.contains(where: { ".!?".contains($0) })
                    {
                        let line =
                            frame.components(separatedBy: " · ").first?.components(
                                separatedBy: " / "
                            ).first ?? frame
                        let ctx =
                            "\(card.fn ?? "") — \(f.chapter.id)-\(f.lesson.id)-\(card.id). Model audio \(f.chapter.id)-\(card.aud ?? "") is a script; no recording exists yet."
                        return (line, ctx)
                    }
                }
            }
        }
        return ("—", "No chunk record is loaded yet.")
    }

    /// The your-take wave heights (line 2507–2516).
    private var speakWaveHeights: [CGFloat] {
        let r = env.router
        return (0..<26).map { i in
            if r.speaking { return CGFloat(7 + (i * 9) % 26) }
            if r.speakTake > 0 { return CGFloat(5 + Int(20 * abs(sin(Double(i) * 0.66 + 0.4)))) }
            return 3
        }
    }

    /// The native wave heights (line 2503–2506).
    private var nativeWaveHeights: [CGFloat] {
        (0..<26).map { i in
            let scale: Double = i > 20 ? 0.4 : 1
            return CGFloat(6 + Int(22 * abs(sin(Double(i) * 0.72)) * scale))
        }
    }

    var body: some View {
        let r = env.router
        let item = sayItem

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button {
                        r.nav(.stories)
                    } label: {
                        AUIcon(kind: .back, size: 17)
                            .frame(width: 44, height: 44)
                            .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
                    }
                    .buttonStyle(.auTap)
                    .accessibilityLabel("Back")
                    Spacer()
                    HStack(spacing: 6) {
                        ForEach(1...3, id: \.self) { n in
                            Text("\(n)")
                                .font(.figtree(.bold, size: 11))
                                .monospacedDigit()
                                .frame(width: 22, height: 22)
                                .background(
                                    Circle().fill(
                                        n <= r.speakTake
                                            ? Color.auAccent : Color.auText.opacity(0.08))
                                )
                                .foregroundStyle(
                                    n <= r.speakTake
                                        ? Color.auBackground : Color.auText.opacity(0.40))
                        }
                    }
                }
                .padding(.bottom, 24)

                Text("Say this")
                    .font(.figtree(.bold, size: 10.5))
                    .tracking(1.68)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.auAccentText)
                    .padding(.bottom, 10)

                Text(item.line)
                    .font(.caprasimo(size: 25))
                    .tracking(-0.38)
                    .lineSpacing(25 * 0.26)
                    .padding(.bottom, 8)

                Text(item.ctx)
                    .font(.figtree(.regular, size: 13))
                    .lineSpacing(13 * 0.5)
                    .foregroundStyle(Color.auText.opacity(0.52))
                    .padding(.bottom, 22)

                // native card
                ACard(radius: 24) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 14) {
                            Button {
                                env.speaker.speak(item.line, slow: false)
                            } label: {
                                AUIcon(kind: .play, size: 18, color: .auPrimaryButtonText)
                                    .frame(width: 44, height: 44)
                                    .background(Circle().fill(Color.auAccentRamp(600)))
                            }
                            .buttonStyle(.auTap)
                            .accessibilityLabel("Hear the native line")
                            WaveForm(
                                heights: nativeWaveHeights, color: Color.auAccent.opacity(0.55)
                            )
                            .frame(height: 34)
                        }
                        Text("Native")
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(1.4)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auText.opacity(0.45))
                            .padding(.top, 11)
                    }
                }
                .padding(.bottom, 10)

                // your take
                ACard(radius: 24) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 14) {
                            AUIcon(
                                kind: .play, size: 18,
                                color: r.speakTake == 0
                                    ? .auText.opacity(0.32)
                                    : AUSceneArt.onAccent2
                            )
                            .frame(width: 44, height: 44)
                            .background(
                                Circle().fill(
                                    r.speakTake == 0
                                        ? Color.auText.opacity(0.08) : Color.auAccent2Ramp(600)))
                            WaveForm(
                                heights: speakWaveHeights,
                                color: Color.auAccent2.opacity(
                                    r.speaking ? 0.85 : (r.speakTake > 0 ? 0.6 : 0.22))
                            )
                            .frame(height: 34)
                        }
                        Text(
                            r.speakTake == 0
                                ? "You — nothing recorded yet" : "You — take \(r.speakTake)"
                        )
                        .font(.figtree(.bold, size: 9.5))
                        .tracking(1.4)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.auText.opacity(0.45))
                        .padding(.top, 11)
                    }
                }
                .padding(.bottom, 14)

                if r.speakScored {
                    HStack(alignment: .top, spacing: 12) {
                        AUIcon(
                            kind: (r.speakVerdict == "clear" || r.speakVerdict == "typed")
                                ? .check : .close, size: 15, color: .white
                        )
                        .frame(width: 26, height: 26)
                        .background(
                            Circle().fill(
                                (r.speakVerdict == "clear" || r.speakVerdict == "typed")
                                    ? Color.auAccent2 : Color.auErr))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(speakVerdictTitle)
                                .font(.figtree(.bold, size: 14.5))
                            Text(speakVerdictBody)
                                .font(.figtree(.regular, size: 13))
                                .lineSpacing(13 * 0.5)
                                .opacity(0.9)
                        }
                    }
                    .padding(15)
                    .padding(.trailing, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(
                                (r.speakVerdict == "clear" || r.speakVerdict == "typed")
                                    ? Color.auOkBg : Color.auErrBg)
                    )
                    .foregroundStyle(
                        (r.speakVerdict == "clear" || r.speakVerdict == "typed")
                            ? Color.auOkText : Color.auErrText
                    )
                    .padding(.bottom, 14)
                }

                Spacer(minLength: 14)

                if r.typing {
                    AUField(label: "Type the sentence instead") {
                        AUTextField(
                            text: Binding(get: { r.typed }, set: { r.typed = $0 }),
                            placeholder: "Hello, I’m Maya…", aid: "au.speak.typed")
                    }
                    .padding(.bottom, 12)
                    APillButton(title: "Check what I typed") {
                        r.speakScored = true
                        r.speakVerdict = "typed"
                        r.typing = false
                    }
                    .padding(.bottom, 6)
                    ALinkButton(title: "Use the microphone instead") {
                        r.typing = false
                    }
                } else {
                    VStack(spacing: 14) {
                        Button {
                            r.toggleSpeak()
                        } label: {
                            ZStack {
                                if r.speaking {
                                    PingRingStroke().frame(width: 84, height: 84)
                                    PingRingStroke()
                                        .frame(width: 84, height: 84)
                                }
                                AUIcon(kind: .mic, size: 30, color: .white)
                                    .frame(width: 78, height: 78)
                                    .background(Circle().fill(Color.auAccentRamp(600)))
                            }
                        }
                        .buttonStyle(.auTap)
                        .accessibilityLabel(r.speaking ? "Stop recording" : "Record your attempt")

                        Text(
                            r.speaking
                                ? "Listening — tap when you're done"
                                : (r.speakTake == 0 ? "Tap, then say it once" : "Tap to try again")
                        )
                        .font(.figtree(.regular, size: 12.5))
                        .foregroundStyle(Color.auText.opacity(0.50))

                        HStack(spacing: 20) {
                            ALinkButton(title: "Type it instead") { r.typing = true }
                            Button {
                                r.nav(.stories)
                            } label: {
                                Text("Skip for now")
                                    .font(.figtree(.semibold, size: 13))
                                    .foregroundStyle(Color.auText.opacity(0.52))
                            }
                            .buttonStyle(.auTap)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 70)
            .padding(.bottom, 34)
        }
        .background(Color.auBackground.ignoresSafeArea())
        .auScreenEntrance()
    }

    private var speakVerdictTitle: String {
        switch env.router.speakVerdict {
        case "clear": "Clear."
        case "near": "Nearly — one word to fix."
        case "low": "I couldn't hear that well enough to judge."
        case "typed": "Read and checked."
        default: "Clear."
        }
    }

    private var speakVerdictBody: String {
        switch env.router.speakVerdict {
        case "clear": "Rhythm and stress both landed. Nothing to fix — this is how it sounds."
        case "near":
            "“studio” came out with the stress on the second syllable. It sits on the first: STU-dio."
        case "low":
            "Somewhere quieter, or a little closer to the microphone — no score has been recorded."
        case "typed": "The sentence is right. Speaking stays optional; nothing here depends on it."
        default: ""
        }
    }
}

// MARK: Review (loose ends, lines 1240–1273)

struct ReviewView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        let r = env.router
        let bank = QuickItem.bank(from: env.course)

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Button {
                    r.nav(.stories)
                } label: {
                    AUIcon(kind: .back, size: 17)
                        .frame(width: 44, height: 44)
                        .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
                }
                .buttonStyle(.auTap)
                .accessibilityLabel("Back")
                .padding(.bottom, 26)

                Text("Loose ends")
                    .font(.caprasimo(size: 29))
                    .tracking(-0.58)
                    .padding(.bottom, 8)

                Text(
                    "Held back and re-shown on a widening interval. They leave this list once they stick."
                )
                .font(.figtree(.regular, size: 13.5))
                .lineSpacing(13.5 * 0.55)
                .foregroundStyle(Color.auText.opacity(0.55))
                .padding(.bottom, 26)

                VStack(spacing: 12) {
                    ForEach(Array(r.mistakes.enumerated()), id: \.offset) { k, mi in
                        let it = bank.indices.contains(mi) ? bank[mi] : nil
                        reviewCard(k: k, item: it)
                    }
                }

                if r.mistakes.isEmpty {
                    VStack(spacing: 8) {
                        Text("Nothing loose.")
                            .font(.caprasimo(size: 19))
                        Text("Finish a lesson and anything you miss will collect here.")
                            .font(.figtree(.regular, size: 13.5))
                            .lineSpacing(13.5 * 0.55)
                            .foregroundStyle(Color.auText.opacity(0.52))
                    }
                    .padding(.vertical, 34)
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .strokeBorder(
                                Color.auDivider, style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
                    )
                }

                Spacer(minLength: 20)

                if !r.mistakes.isEmpty {
                    APillButton(
                        title:
                            "Practise \(r.mistakes.count)\(r.mistakes.count == 1 ? " item" : " items")"
                    ) {
                        r.reviewRun()
                    }
                } else {
                    APillButton(title: "Try a minute of speaking instead", variant: .ghost) {
                        r.nav(.speak)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 70)
            .padding(.bottom, 34)
        }
        .background(Color.auBackground.ignoresSafeArea())
        .auScreenEntrance()
    }

    private func reviewCard(k: Int, item: QuickItem?) -> some View {
        let kind: String = {
            guard let item else { return "Practice" }
            switch item.type {
            case .flash, .choice: return "Vocabulary"
            case .listen: return "Listening"
            case .order: return "Word order"
            case .match: return "Pairs"
            case .pattern: return "Grammar"
            }
        }()
        let label =
            item.map { it in
                !it.front.isEmpty
                    ? it.front
                    : (!it.stem.isEmpty
                        ? it.stem
                        : (!it.audio.isEmpty
                            ? it.audio
                            : (it.options.indices.contains(it.answer) ? it.options[it.answer] : "")))
            } ?? "One item from the bank"
        let note =
            item.map {
                !$0.hint.isEmpty
                    ? $0.hint : (!$0.why.isEmpty ? $0.why : "Held back for another look.")
            } ?? "Held back for another look."
        let src = item?.src ?? ""
        let due = k == 0 ? "Due tomorrow" : (k == 1 ? "Due in 2 days" : "Due in 4 days")

        return ACard(radius: 22) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .firstTextBaseline) {
                    Text("\(kind)\(src.isEmpty ? "" : " · \(src)")")
                        .font(.figtree(.bold, size: 10.5))
                        .tracking(1.4)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.auAccentText)
                    Spacer()
                    Text(due)
                        .font(.figtree(.regular, size: 11.5))
                        .foregroundStyle(Color.auText.opacity(0.45))
                }
                .padding(.bottom, 9)
                Text(label)
                    .font(.figtree(.semibold, size: 16))
                    .lineSpacing(16 * 0.35)
                Text(note)
                    .font(.figtree(.regular, size: 13))
                    .lineSpacing(13 * 0.5)
                    .foregroundStyle(Color.auText.opacity(0.55))
                    .padding(.top, 8)
            }
        }
    }
}

// MARK: Hunt + Reader stubs (lines 1049–1099)

/// The shared honest stub layout for hunt + reader.
struct AwaitingContentView: View {
    let title: String
    let awaiting: String
    let plannedTitle: String
    let planned: [String]
    let source: String

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Button {
                    env.router.nav(.stories)
                } label: {
                    AUIcon(kind: .back, size: 17)
                        .frame(width: 44, height: 44)
                        .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
                }
                .buttonStyle(.auTap)
                .accessibilityLabel("Back")
                .padding(.bottom, 26)

                HStack(spacing: 8) {
                    AUIcon(kind: .lock, size: 12, color: .auText.opacity(0.52))
                    Text("Awaiting course content")
                }
                .font(.figtree(.bold, size: 9.5))
                .tracking(1.33)
                .textCase(.uppercase)
                .foregroundStyle(Color.auText.opacity(0.52))
                .padding(.horizontal, 13)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color.auText.opacity(0.08)))
                .padding(.bottom, 16)

                Text(title)
                    .font(.caprasimo(size: 29))
                    .tracking(-0.64)
                    .lineSpacing(29 * 0.12)
                    .padding(.bottom, 12)

                Text(awaiting)
                    .font(.figtree(.regular, size: 14))
                    .lineSpacing(14 * 0.6)
                    .foregroundStyle(Color.auText.opacity(0.58))
                    .padding(.bottom, 20)

                PlaceholderFrame(height: 150, cornerRadius: 24, label: "screen placeholder")
                    .padding(.bottom, 20)

                ACard(radius: 22) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(plannedTitle)
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(1.4)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auAccentText)
                            .padding(.bottom, 10)
                        ForEach(planned, id: \.self) { t in
                            HStack(alignment: .top, spacing: 10) {
                                Circle()
                                    .fill(Color.auAccent2)
                                    .frame(width: 5, height: 5)
                                    .padding(.top, 8)
                                Text(t)
                                    .font(.figtree(.regular, size: 13))
                                    .lineSpacing(13 * 0.5)
                                    .foregroundStyle(Color.auText.opacity(0.64))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }

                Spacer(minLength: 20)

                Text("Source: \(source)")
                    .font(.figtree(.regular, size: 11))
                    .lineSpacing(11 * 0.5)
                    .foregroundStyle(Color.auText.opacity(0.40))
                    .padding(.bottom, 14)

                APillButton(title: "Back to practice") {
                    env.router.nav(.stories)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 70)
            .padding(.bottom, 32)
        }
        .background(Color.auBackground.ignoresSafeArea())
        .auScreenEntrance()
    }

    @Environment(AppEnvironment.self) private var env
}

struct HuntStubView: View {
    var body: some View {
        AwaitingContentView(
            title: "Find three words — awaiting content",
            awaiting:
                "A camera word-hunt is not part of the A1 course plan. Nothing in english_course specifies its word lists, so no words are invented for it here.",
            plannedTitle: "What it needs first",
            planned: [
                "Needs a lexical source: the ledger row set for a chapter (LEXICAL_LEDGER.csv)",
                "Needs an instruction-word check against CONTROLLED_INSTRUCTION_LEXICON.md",
                "Needs a privacy ruling — the course forbids collecting real personal data",
            ],
            source: "not specified in english_course"
        )
    }
}

struct ReaderStubView: View {
    var body: some View {
        AwaitingContentView(
            title: "Graded readers — awaiting content",
            awaiting:
                "No graded-reader text exists in the course source. The reading that IS authored sits in the chapter player: name badges and the welcome card (C1-L3), the register form and message card (C2-L3), the three profile cards and the class roll (C3-L3).",
            plannedTitle: "What it needs first",
            planned: [
                "≥9 reading genres across the 12 chapters (A1_COURSE_OVERVIEW.md, production ranges)",
                "Every text app-layer, Dynamic Type to XL, never rendered inside art",
                "Audio for each text once recordings exist — scripts only today",
            ],
            source: "03_A1_foundation/A1_COURSE_OVERVIEW.md · 04_A1_chapters/*/*_L03_LESSON.md"
        )
    }
}
