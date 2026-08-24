import SwiftUI

// MARK: - Practice hub: Stories · Scene · Speak · Review · Hunt/Reader stubs
//
// Ported from Aurel.dc.html lines 993–1273 (+ STORY/HUNT_STUB constants,
// scene thread, sayItem chunk search).

// MARK: Stories hub (Practice tab)

struct StoriesView: View {
    @Environment(AppEnvironment.self) private var env
    /// Craft overhaul P7: the locked story whose explainer is showing.
    @State private var lockedNote: String? = nil

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
                            .foregroundStyle(Color.auTextTertiary)
                    }
                    .padding(.bottom, 14)

                    // stories list (line 2257) — open the chapter player on the reading screen
                    ForEach(Array(storyRows.enumerated()), id: \.offset) { i, st in
                        storyRow(st) {
                            // Craft overhaul P7: a locked row used to no-op.
                            // Now it explains itself with a calm note + haptic.
                            if st.locked {
                                AUFeedback.press()
                                withAnimation(AUMotion.quick) { lockedNote = st.title }
                            } else {
                                st.open?()
                            }
                        }
                        .auStagger(i)
                        .padding(.bottom, 12)
                    }

                    // Craft overhaul P7: the locked-story explainer.
                    if let lockedNote {
                        HStack(alignment: .top, spacing: 10) {
                            AUIcon(kind: .lock, size: 14, color: .auAccentText)
                                .padding(.top, 1)
                            Text("“\(lockedNote)” opens as its chapter is written — Chapter 1 comes first.")
                                .font(.figtree(.regular, size: 12.5))
                                .auLine(12.5, 1.5)
                                .foregroundStyle(Color.auTextSecondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 13)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.auTintBg)
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.bottom, 12)
                        .onTapGesture {
                            withAnimation(AUMotion.quick) { self.lockedNote = nil }
                        }
                    }

                    Text(
                        // Craft overhaul P6: dropped the meta/engineering footer
                        // ("nothing here is invented for the app layer") — this
                        // learner-facing line is all that remains.
                        "Every text opens in the chapter that authored it."
                    )
                    .font(.figtree(.regular, size: 12))
                    .auLine(12, 1.5)
                    .foregroundStyle(Color.auTextTertiary)
                    .padding(.bottom, 44)
                }
                .padding(.horizontal, 24)
                .padding(.top, 70)
                .padding(.bottom, 130)
            }
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
                        // Craft overhaul P15: nested radius = outer(28) − pad(15).
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
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
                        .foregroundStyle(Color.auTextSecondary)
                    Text(st.band)
                        .font(.figtree(.regular, size: 10.5))
                        .tracking(0.42)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 3)
                        // Craft overhaul P14: neutral level chip (was green
                        // success semantics for A1, grey for the rest).
                        .background(Capsule().fill(Color.auFlatBg))
                        .foregroundStyle(Color.auFlatText)
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
                        .foregroundStyle(Color.auTextSecondary)
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
                        .foregroundStyle(Color.auTextSecondary)
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
                    .foregroundStyle(Color.auTextSecondary)
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
                    // Craft overhaul C4: guard the empty-script case — the old
                    // `0...min(sceneTurn, max(0, count-1))` became `0...0` and
                    // indexed `turns[0]`, crashing when turns was empty.
                    if !sc.turns.isEmpty {
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
                                        .foregroundStyle(Color.auTextTertiary)
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
                            .foregroundStyle(Color.auTextTertiary)
                        Spacer()
                        Button {
                            // Craft overhaul C3: was an empty Button. Replays
                            // the partner's current line through the TTS speaker.
                            let i = min(r.sceneTurn, max(0, sc.turns.count - 1))
                            if sc.turns.indices.contains(i) {
                                AUFeedback.press()
                                env.speaker.speak(sc.turns[i].them, slow: false)
                            }
                        } label: {
                            Text("Hear that again")
                                .font(.figtree(.bold, size: 11.5))
                                .foregroundStyle(Color.auAccentText)
                        }
                        .buttonStyle(.auTap)
                        .auMinHitTarget()
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
                .foregroundStyle(on ? Color.auBackground : Color.auTextSecondary)
        }
        .buttonStyle(.auTap)
        // Craft overhaul P5: chip was ~30pt tall — expand the hit area.
        .auMinHitTarget()
    }
}

// MARK: Say-aloud (lines 1154–1238)

struct SpeakView: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.scenePhase) private var scenePhase

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
                        // Craft overhaul P3: was engineering jargon
                        // ("Model audio … is a script; no recording exists yet")
                        // — now a learner-facing context line.
                        let ctx = card.fn ?? ""
                        return (line, ctx)
                    }
                }
            }
        }
        return ("—", "No chunk record is loaded yet.")
    }

    /// The your-take waveform is real metering now (§3.16a) — the samples
    /// come from `SayCoach`'s recorder; no `sin()` stand-ins remain.
    private var takeSamples: [Double] {
        env.router.say.samples
    }

    /// The native wave heights (line 2503–2506) — the decorative track for
    /// model audio that is still script-only; the progress tint (§3.16e)
    /// fills it while TTS speaks.
    private var nativeWaveHeights: [CGFloat] {
        (0..<26).map { i in
            let scale: Double = i > 20 ? 0.4 : 1
            return CGFloat(6 + Int(22 * abs(sin(Double(i) * 0.72)) * scale))
        }
    }

    /// §3.16c: the honest verdict state for the current target — a real
    /// tier, a real typed comparison, or the honest no-verdict note.
    private enum VerdictState: Equatable {
        case none
        case assessing
        case tier(SpeakVerdict.Tier, matched: Int, total: Int)
        case typed(SpeakVerdict.Tier, matched: Int, total: Int)
        case unavailable
    }

    private var verdictState: VerdictState {
        let r = env.router
        if r.speakTypedCheck, let t = r.speakTypedVerdict {
            return .typed(t, matched: r.speakTypedWords.matched, total: r.speakTypedWords.total)
        }
        if r.speakAssessing { return .assessing }
        if r.speakUnavailable { return .unavailable }
        if let t = r.speakVerdict {
            return .tier(
                t, matched: r.speakMatchedWords.matched, total: r.speakMatchedWords.total)
        }
        return .none
    }

    private static func isClear(_ v: VerdictState) -> Bool {
        if case .tier(.clear, _, _) = v { return true }
        if case .typed(.clear, _, _) = v { return true }
        return false
    }

    var body: some View {
        let r = env.router
        let item = sayItem
        let verdict = verdictState
        let verdictOK = Self.isClear(verdict)

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
                    .foregroundStyle(Color.auTextSecondary)
                    .padding(.bottom, 22)

                // native card — §3.16(e): the play control toggles, and the
                // track tints along the synthesizer's real utterance progress.
                ACard(radius: 24, padded: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 14) {
                            Button {
                                if env.speaker.isSpeaking {
                                    env.speaker.stop()
                                } else {
                                    env.speaker.speak(item.line, slow: false)
                                }
                            } label: {
                                AUIcon(
                                    kind: env.speaker.isSpeaking ? .close : .play, size: 18,
                                    color: .auPrimaryButtonText
                                )
                                .frame(width: 44, height: 44)
                                .background(Circle().fill(Color.auAccentRamp(600)))
                            }
                            .buttonStyle(.auTap)
                            .accessibilityLabel(
                                env.speaker.isSpeaking
                                    ? "Stop the native line" : "Hear the native line")
                            HubWaveform(
                                heights: nativeWaveHeights,
                                color: Color.auAccent.opacity(0.55),
                                animated: false,
                                progress: env.speaker.isSpeaking ? env.speaker.progress : nil
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 34)
                        }
                        Text("Native")
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(1.4)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auTextTertiary)
                            .padding(.top, 11)
                    }
                    .padding(.horizontal, 17)
                    .padding(.vertical, 15)
                }
                .padding(.bottom, 10)

                // your take — §3.16(a): the bars are the recorder's real
                // amplitude history, never a decorative wave.
                ACard(radius: 24, padded: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 14) {
                            // Craft overhaul P1: was a play icon in a filled
                            // circle that looked tappable but wasn't a Button.
                            // Now a neutral mic status glyph — a mic reads as
                            // "recording lives here", not "tap to play".
                            AUIcon(
                                kind: .mic, size: 18,
                                color: r.speakTake == 0
                                    ? .auText.opacity(0.32)
                                    : AUSceneArt.onAccent2
                            )
                            .frame(width: 44, height: 44)
                            .background(
                                Circle().fill(
                                    r.speakTake == 0
                                        ? Color.auText.opacity(0.08) : Color.auAccent2Ramp(600)))
                            .accessibilityHidden(true)
                            LiveWaveform(
                                samples: takeSamples,
                                tint: Color.auAccent2.opacity(
                                    r.speaking ? 0.85 : (r.speakTake > 0 ? 0.6 : 0.22))
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 34)
                        }
                        Text(takeLabel)
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(1.4)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auTextTertiary)
                            .padding(.top, 11)
                    }
                    .padding(.horizontal, 17)
                    .padding(.vertical, 15)
                }
                .padding(.bottom, 14)

                // §3.16(c): the honest verdict — a real tier, the real word
                // count, or the honest no-recognition note. "Near" and
                // "nothing heard" sit in the calm neutral tier, never error
                // red (governance).
                if verdict != .none {
                    HStack(alignment: .top, spacing: 12) {
                        AUIcon(kind: verdictOK ? .check : .mouth, size: 15, color: .white)
                            .frame(width: 26, height: 26)
                            .background(
                                Circle().fill(
                                    verdictOK
                                        ? Color.auAccent2 : Color.auText.opacity(0.38))
                            )
                        VStack(alignment: .leading, spacing: 3) {
                            Text(verdictTitle(verdict))
                                .font(.figtree(.bold, size: 14.5))
                            Text(verdictBody(verdict))
                                .font(.figtree(.regular, size: 13))
                                .auLine(13, 1.5)
                                .opacity(0.9)
                        }
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal, 17)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(verdictOK ? Color.auOkBg : Color.auText.opacity(0.07))
                    )
                    .foregroundStyle(verdictOK ? Color.auOkText : Color.auText)
                    .padding(.bottom, 4)
                    .accessibilityElement(children: .combine)
                    .accessibilityIdentifier("au.speak.verdict")
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
                        r.checkTyped(target: item.line)
                    }
                    .padding(.bottom, 6)
                    ALinkButton(title: "Use the microphone instead") {
                        r.typing = false
                    }
                } else {
                    VStack(spacing: 14) {
                        // §3.16(d): a denial is a state, never an error —
                        // the recovery card with the Settings deep link.
                        if r.speakMicDenied {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(alignment: .top, spacing: 12) {
                                    AUIcon(kind: .mic, size: 15, color: .white)
                                        .frame(width: 26, height: 26)
                                        .background(Circle().fill(Color.auText.opacity(0.38)))
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("The microphone is off.")
                                            .font(.figtree(.bold, size: 14.5))
                                        Text(
                                            "Aurel never keeps your voice. Turn the microphone on in Settings — or take the tap path below."
                                        )
                                        .font(.figtree(.regular, size: 13))
                                        .auLine(13, 1.5)
                                        .opacity(0.9)
                                    }
                                }
                                Button {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url)
                                    }
                                } label: {
                                    Text("Open Settings")
                                        .font(.figtree(.semibold, size: 13.5))
                                        .foregroundStyle(Color.auAccentText)
                                }
                                .buttonStyle(.auTap)
                                .accessibilityIdentifier("au.speak.open-settings")
                            }
                            .padding(.vertical, 15)
                            .padding(.horizontal, 17)
                            .background(
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .fill(Color.auText.opacity(0.07))
                            )
                            .foregroundStyle(Color.auText)
                            .accessibilityIdentifier("au.speak.mic-denied")
                        }
                        // §3.16(b): the mic button carries the expanding
                        // recording ring while the take window runs.
                        Button {
                            r.toggleSpeak(target: item.line)
                        } label: {
                            ZStack {
                                if r.speaking {
                                    RecordingRing().frame(width: 96, height: 96)
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
                        .foregroundStyle(Color.auTextSecondary)

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
                            // Craft overhaul P4: 26pt text link → 44pt hit area.
                            .auMinHitTarget()
                            .accessibilityIdentifier("au.link.type-it-instead")
                            Button {
                                r.nav(.stories)
                            } label: {
                                Text("Skip for now")
                                    .font(.figtree(.semibold, size: 13))
                                    .foregroundStyle(Color.auTextSecondary)
                                    .padding(.horizontal, 2)
                                    .padding(.vertical, 6)
                            }
                            .buttonStyle(.auTap)
                            .auMinHitTarget()
                            .accessibilityIdentifier("au.link.skip-for-now")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 70)
            .padding(.bottom, 34)
            // Craft overhaul P2: was a hardcoded 874pt canvas (forced scroll
            // on small devices, broke Dynamic Type) — now flexible.
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .background(Color.auBackground.ignoresSafeArea())
        .auScreenEntrance()
        // §3.16(d): returning from Settings re-checks the permission — the
        // denial card leaves the moment access does.
        .onAppear { env.router.say.refreshPermission() }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { env.router.say.refreshPermission() }
        }
        // Leaving mid-take ends the take without a verdict (nothing kept).
        .onDisappear {
            if env.router.say.recording { env.router.say.reset() }
        }
    }

    /// The take meter's honest label — "checking" while the transcript runs.
    private var takeLabel: String {
        let r = env.router
        if r.speakAssessing { return "You — checking take \(r.speakTake)" }
        return r.speakTake == 0 ? "You — nothing recorded yet" : "You — take \(r.speakTake)"
    }

    private func verdictTitle(_ v: VerdictState) -> String {
        switch v {
        case .none: return ""
        case .assessing: return "Checking the take…"
        case .tier(.clear, _, _): return "Clear."
        case .tier(.near, _, _): return "Closer each time."
        case .tier(.nothingHeard, _, _): return "Nothing came through."
        case .typed(.clear, _, _): return "Read and checked."
        case .typed(.near, _, _): return "Closer each time."
        case .typed(.nothingHeard, _, _): return "Nothing matched."
        case .unavailable: return "No clarity check here."
        }
    }

    private func verdictBody(_ v: VerdictState) -> String {
        switch v {
        case .none: return ""
        case .assessing: return "The check runs on this device — a moment."
        case .tier(.clear, _, let total):
            return "All \(total) words came through in order — this is how it sounds."
        case .tier(.near, let matched, let total):
            return "\(matched) of \(total) words came through in order. Try again — slower is fine."
        case .tier(.nothingHeard, _, _):
            return
                "Somewhere quieter, or a little closer to the microphone — no score has been recorded."
        case .typed(.clear, _, _):
            return "The sentence is right. Speaking stays optional; nothing here depends on it."
        case .typed(.near, let matched, let total):
            return "\(matched) of \(total) words are there. Try once more, or use the microphone."
        case .typed(.nothingHeard, _, _):
            return "None of the words match the line. Try again, or use the microphone."
        case .unavailable:
            return
                "Speech recognition isn't available on this device, so the take stands as a take — and nothing you said is kept."
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
                .foregroundStyle(Color.auTextSecondary)
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
                    AUEmptyStateView(
                        title: "Nothing loose.",
                        message: "All caught up! Finish a lesson and any words you miss will collect here for spaced review.",
                        icon: .check
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
                    .foregroundStyle(Color.auTextSecondary)
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
    /// 0…1 playback progress — bars up to it render at full color (§3.16e).
    var progress: Double? = nil

    var body: some View {
        HStack(spacing: 3) {
            ForEach(Array(heights.enumerated()), id: \.offset) { i, height in
                HubWaveBar(
                    height: height,
                    color: barColor(at: i),
                    animated: animated, index: i
                )
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func barColor(at index: Int) -> Color {
        guard let progress else { return color }
        let edge = progress * Double(heights.count)
        return Double(index) < edge ? color : color.opacity(0.22)
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
