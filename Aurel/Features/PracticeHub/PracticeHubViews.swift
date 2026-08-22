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
                        icon: .speech, tint: Color.auAccent2Ramp(600),
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

                    // The quiet variant: 42 pt grey disc, Figtree 15.5/600 title,
                    // divider outline, no fill or lift.
                    quietRow(
                        icon: .reviewLoop,
                        title: "Review mistakes",
                        sub: r.mistakes.isEmpty
                            ? "Empty — nothing has slipped yet" : "\(r.mistakes.count) waiting",
                        dashed: false
                    ) { r.nav(.review) }
                    .padding(.bottom, 26)

                    HStack(alignment: .firstTextBaseline) {
                        Text("Stories")
                            .font(.figtree(.bold, size: 10.5))
                            .tracking(1.47)
                            .textCase(.uppercase)
                        Spacer()
                        Text("Authored texts")
                            .font(.figtree(.regular, size: 11.5))
                            .foregroundStyle(Color.auText.opacity(0.45))
                    }
                    .padding(.bottom, 14)

                    // stories list (line 2257) — open the chapter player on the reading screen
                    ForEach(Array(storyRows.enumerated()), id: \.offset) { i, st in
                        storyRow(st) {
                            st.open?()
                        }
                        .auStagger(i)
                        .padding(.bottom, 12)
                    }

                    Text(
                        "Every text opens in the chapter that authored it — nothing here is invented for the app layer."
                    )
                    .font(.figtree(.regular, size: 12))
                    .auLine(12, 1.5)
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
                title: "The day’s sign-in sheet",
                meta: "Chapter 4 · Lesson 2 · S14", band: "A1",
                mark: "IV", locked: false, open: openReading(3, 1)),
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
                            .fill(
                                (st.mark == "II" || st.mark == "IV")
                                    ? Color.auAccent2Ramp(200) : Color.auAccentRamp(200)
                            )
                    )
                    .foregroundStyle(
                        (st.mark == "II" || st.mark == "IV")
                            ? Color.auAccent2Ramp(800) : Color.auAccentRamp(800)
                    )
                VStack(alignment: .leading, spacing: 4) {
                    Text(st.title)
                        .font(.caprasimo(size: 17))
                        .auHeadLine(17, 1.2)
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

    /// The quiet hub entry (Review mistakes): a 42 pt grey disc, a Figtree
    /// 15.5/600 title, and a divider outline — no fill, no lift.
    private func quietRow(
        icon: AUIcon.Kind, title: String, sub: String, dashed: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                AUIcon(kind: icon, size: 19, color: .auAccent)
                    .frame(width: 42, height: 42)
                    .background(Circle().fill(Color.auText.opacity(0.08)))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.figtree(.semibold, size: 15.5))
                        .auLine(15.5, 1.55)
                    Text(sub)
                        .font(.figtree(.regular, size: 12.5))
                        .auLine(12.5, 1.55)
                        .foregroundStyle(Color.auText.opacity(0.50))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                AUIcon(kind: .chevron, size: 17, color: .auText.opacity(0.4))
            }
            .padding(.horizontal, 21)
            .padding(.vertical, 19)
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .strokeBorder(
                        Color.auDivider,
                        style: StrokeStyle(lineWidth: 1, dash: dashed ? [5, 4] : []))
            )
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
                        .auHeadLine(19, 1.2)
                    Text(sub)
                        .font(.figtree(.regular, size: 12.5))
                        .auLine(12.5, 1.55)
                        .foregroundStyle(Color.auText.opacity(0.52))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                AUIcon(kind: .chevron, size: 17, color: .auText.opacity(0.4))
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
                .padding(.leading, -10)  // margin-left:-10px

                VStack(alignment: .leading, spacing: 0) {
                    Text("Scene")
                        .font(.figtree(.bold, size: 10))
                        .tracking(1.6)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.auAccentText)
                        .padding(.bottom, 5)
                    Text(sc.title)
                        .font(.caprasimo(size: 19))
                        .auHeadLine(19, 1.2)
                    Text(
                        r.sceneRoleB
                            ? "Two of you, one script. You take the learner turns; they read the partner."
                            : sc.role
                    )
                    .font(.figtree(.regular, size: 12.5))
                    .auLine(12.5, 1.45)
                    .foregroundStyle(Color.auText.opacity(0.52))
                    .padding(.top, 4)
                    HStack(spacing: 6) {
                        modeChip("On your own", on: !r.sceneRoleB) { r.setSolo() }
                        modeChip("Two phones", on: r.sceneRoleB) { r.setDuo() }
                    }
                    .padding(.top, 11)
                }
                .padding(.top, 3)
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
                        let partnerShape = UnevenRoundedRectangle(
                            topLeadingRadius: 22, bottomLeadingRadius: 7,
                            bottomTrailingRadius: 22, topTrailingRadius: 22,
                            style: .continuous
                        )
                        let learnerShape = UnevenRoundedRectangle(
                            topLeadingRadius: 22, bottomLeadingRadius: 22,
                            bottomTrailingRadius: 7, topTrailingRadius: 22,
                            style: .continuous
                        )
                        VStack(alignment: .leading, spacing: 12) {
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
                                    .auLine(14.5, 1.45)
                                    .padding(.horizontal, 17)
                                    .padding(.vertical, 14)
                                    .frame(maxWidth: 311, alignment: .leading)
                                    .background(partnerShape.fill(Color.auFill))
                                    .overlay(
                                        partnerShape.stroke(
                                            r.sceneRoleB
                                                ? Color.auAccent.opacity(0.4) : Color.auEdge,
                                            style: StrokeStyle(
                                                lineWidth: 1,
                                                dash: r.sceneRoleB ? [5, 4] : []
                                            )
                                        )
                                    )
                                    .auLift()
                            }

                            if let pickIdx = r.scenePicks.indices.contains(i)
                                ? r.scenePicks[i] : nil,
                                turn.replies.indices.contains(pickIdx)
                            {
                                let reply = turn.replies[pickIdx]
                                VStack(alignment: .trailing, spacing: 7) {
                                    Text(reply.t)
                                        .font(.figtree(.regular, size: 14.5))
                                        .auLine(14.5, 1.45)
                                        .padding(.horizontal, 17)
                                        .padding(.vertical, 14)
                                        .frame(maxWidth: 311, alignment: .leading)
                                        .background(learnerShape.fill(Color.auAccentRamp(600)))
                                        .foregroundStyle(AUSceneArt.onAccent)
                                        .shadow(
                                            color: Color.auAccentRamp(800).opacity(0.22),
                                            radius: 3, y: 4
                                        )
                                    if !reply.reg.isEmpty {
                                        Text(reply.reg)
                                            .font(.figtree(.regular, size: 12.5))
                                            .auLine(12.5, 1.5)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 11)
                                            .frame(maxWidth: 318, alignment: .leading)
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
                                    .auLine(14.5, 1.4)
                                    .padding(.horizontal, 17)
                                    .padding(.vertical, 15)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous).fill(
                                            Color.auFill)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20).strokeBorder(
                                            Color.auEdge, lineWidth: 1)
                                    )
                                    .auLift()
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
                            .auLine(13.5, 1.45)
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
        let verdictOK = r.speakVerdict == "clear" || r.speakVerdict == "typed"
        let verdictLow = r.speakVerdict == "low"

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
                    .auHeadLine(25, 1.26)
                    .padding(.bottom, 8)

                Text(item.ctx)
                    .font(.figtree(.regular, size: 13))
                    .auLine(13, 1.5)
                    .foregroundStyle(Color.auText.opacity(0.52))
                    .padding(.bottom, 22)

                // native card
                ACard(radius: 24, padded: false) {
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
                            HubWaveform(
                                heights: nativeWaveHeights,
                                color: Color.auAccent.opacity(0.55),
                                animated: false
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 34)
                        }
                        Text("Native")
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(1.4)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auText.opacity(0.45))
                            .padding(.top, 11)
                    }
                    .padding(.horizontal, 17)
                    .padding(.vertical, 15)
                }
                .padding(.bottom, 10)

                // your take
                ACard(radius: 24, padded: false) {
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
                            HubWaveform(
                                heights: speakWaveHeights,
                                color: Color.auAccent2.opacity(
                                    r.speaking ? 0.85 : (r.speakTake > 0 ? 0.6 : 0.22)),
                                animated: r.speaking
                            )
                            .frame(maxWidth: .infinity)
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
                    .padding(.horizontal, 17)
                    .padding(.vertical, 15)
                }
                .padding(.bottom, 14)

                if r.speakScored {
                    HStack(alignment: .top, spacing: 12) {
                        AUIcon(kind: verdictOK ? .check : .warning, size: 15, color: .white)
                            .frame(width: 26, height: 26)
                            .background(
                                Circle().fill(
                                    verdictOK
                                        ? Color.auAccent2
                                        : (verdictLow ? Color.auText.opacity(0.38) : Color.auErr)
                                )
                            )
                        VStack(alignment: .leading, spacing: 3) {
                            Text(speakVerdictTitle)
                                .font(.figtree(.bold, size: 14.5))
                            Text(speakVerdictBody)
                                .font(.figtree(.regular, size: 13))
                                .auLine(13, 1.5)
                                .opacity(0.9)
                        }
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal, 17)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(
                                verdictOK
                                    ? Color.auOkBg
                                    : (verdictLow ? Color.auText.opacity(0.07) : Color.auErrBg)
                            )
                    )
                    .foregroundStyle(
                        verdictOK
                            ? Color.auOkText : (verdictLow ? Color.auText : Color.auErrText)
                    )
                    .padding(.bottom, 4)
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
                            Button {
                                r.typing = true
                            } label: {
                                Text("Type it instead")
                                    .font(.figtree(.semibold, size: 13))
                                    .foregroundStyle(Color.auAccentText)
                                    .padding(.horizontal, 2)
                                    .padding(.vertical, 6)
                            }
                            .buttonStyle(.auTap)
                            .accessibilityIdentifier("au.link.type-it-instead")
                            Button {
                                r.nav(.stories)
                            } label: {
                                Text("Skip for now")
                                    .font(.figtree(.semibold, size: 13))
                                    .foregroundStyle(Color.auText.opacity(0.52))
                                    .padding(.horizontal, 2)
                                    .padding(.vertical, 6)
                            }
                            .buttonStyle(.auTap)
                            .accessibilityIdentifier("au.link.skip-for-now")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 70)
            .padding(.bottom, 34)
            .frame(minHeight: 874, alignment: .top)
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
                .auLine(13.5, 1.55)
                .foregroundStyle(Color.auText.opacity(0.55))
                .padding(.bottom, 26)

                VStack(spacing: 12) {
                    // §3.17: due badges come from the ladder's real rows —
                    // actual next-due dates, never positional guesses.
                    let rows = r.mistakeRows()
                    ForEach(Array(r.mistakes.enumerated()), id: \.offset) { k, mi in
                        let it = bank.indices.contains(mi) ? bank[mi] : nil
                        reviewCard(
                            k: k, item: it,
                            due: AppRouter.dueLabel(for: rows[mi]),
                            urgent: AppRouter.isDue(rows[mi]))
                    }
                }

                if r.mistakes.isEmpty {
                    VStack(spacing: 8) {
                        Text("Nothing loose.")
                            .font(.caprasimo(size: 19))
                        Text("Finish a lesson and anything you miss will collect here.")
                            .font(.figtree(.regular, size: 13.5))
                            .auLine(13.5, 1.55)
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
            .frame(minHeight: 874, alignment: .top)
        }
        .background(Color.auBackground.ignoresSafeArea())
        .auScreenEntrance()
    }

    private func reviewCard(k: Int, item: QuickItem?, due: String, urgent: Bool) -> some View {
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

        return ACard(radius: 22, padded: false) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .firstTextBaseline) {
                    Text("\(kind)\(src.isEmpty ? "" : " · \(src)")")
                        .font(.figtree(.bold, size: 10.5))
                        .tracking(1.4)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.auAccentText)
                    Spacer()
                    // §3.17(b): the due badge — accent tint when the item is
                    // due, flat when its ladder date is still ahead.
                    Text(due)
                        .font(.figtree(.semibold, size: 11))
                        .padding(.horizontal, 9)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(urgent ? Color.auTintBg : Color.auFlatBg))
                        .foregroundStyle(urgent ? Color.auTintText : Color.auFlatText)
                }
                .padding(.bottom, 9)
                Text(label)
                    .font(.figtree(.semibold, size: 16))
                    .auLine(16, 1.35)
                Text(note)
                    .font(.figtree(.regular, size: 13))
                    .auLine(13, 1.5)
                    .foregroundStyle(Color.auText.opacity(0.55))
                    .padding(.top, 8)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
        }
        .accessibilityElement(children: .combine)
    }
}

private struct HubWaveform: View {
    let heights: [CGFloat]
    let color: Color
    let animated: Bool

    var body: some View {
        HStack(spacing: 3) {
            ForEach(Array(heights.enumerated()), id: \.offset) { i, height in
                HubWaveBar(height: height, color: color, animated: animated, index: i)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private struct HubWaveBar: View {
        let height: CGFloat
        let color: Color
        let animated: Bool
        let index: Int
        @Environment(\.accessibilityReduceMotion) private var reduceMotion
        @State private var compressed = false

        var body: some View {
            Capsule()
                .fill(color)
                .frame(height: height)
                .scaleEffect(
                    y: animated && !reduceMotion && compressed ? 0.35 : 1,
                    anchor: .center
                )
                .onAppear { updateAnimation() }
                .onChange(of: animated) { _, _ in updateAnimation() }
        }

        private func updateAnimation() {
            compressed = false
            guard animated, !reduceMotion else { return }
            withAnimation(
                .easeInOut(duration: 0.6 + Double(index % 6) * 0.11)
                    .repeatForever(autoreverses: true)
                    .delay(Double(index) * 0.04)
            ) {
                compressed = true
            }
        }
    }
}
