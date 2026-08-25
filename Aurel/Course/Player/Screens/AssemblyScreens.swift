import SwiftUI

// MARK: - Assembly + conversation practice screens
//
// Order · Tiles (incl. emailAssembly) · Substitution · MissionBrief ·
// Roleplay — ported from CourseScreen.dc.html lines 800–1003.

// MARK: Order (alphabetical demo + tasks)

struct OrderScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 22, bottomPad: 26) {
            if case .order(let o) = m.cur?.screen.payload {
                if let demoWords = o.demoWords {
                    CompactFlowChips(tiles: demoWords, style: .demo)
                        .padding(.bottom, 16)
                }

                tileTaskHeader

                Spacer(minLength: 12)

                HStack(spacing: 12) {
                    Button {
                        AUFeedback.press()
                        withAnimation(AUMotion.quick) {
                            m.order = []
                        }
                    } label: {
                        Text("Undo all")
                            .font(.figtree(.semibold, size: 16.5))
                            .frame(width: 96, height: 54)
                            .background(
                                RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous)
                                    .strokeBorder(Color.auDivider, lineWidth: 1))
                    }
                    .buttonStyle(.auTap)

                    GoOnButton(label: "Go on", disabled: !m.tileCorrect) { m.taskAdvance() }
                }
                .padding(.top, 16)
            }
        }
    }

    @ViewBuilder
    private var tileTaskHeader: some View {
        let task = m.tileTask

        HStack(spacing: 10) {
            AUIcon(kind: .tap, size: 19, color: .auTintText)
                .frame(width: 36, height: 36)
                .background(Circle().fill(Color.auTintBg))
            Text(task.instr.isEmpty ? "Put in order." : task.instr)
                .font(.figtree(.semibold, size: 17))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, 8)

        // the ordered list (order shows numbered rows)
        VStack(spacing: 9) {
            ForEach(Array(task.tiles.enumerated()), id: \.offset) { k, t in
                let at = m.order.firstIndex(of: k)
                Button {
                    m.toggleTile(k)
                } label: {
                    HStack(spacing: 12) {
                        Text(at != nil ? "\(at! + 1)" : "")
                            .font(.figtree(.bold, size: 12))
                            .frame(width: 26, height: 26)
                            .background(
                                Circle().strokeBorder(Color.primary.opacity(0.7), lineWidth: 1.5))
                        Text(t)
                            .font(.figtree(.regular, size: 15.5))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 15)
                    .frame(minHeight: 58)
                    .background(
                        RoundedRectangle(cornerRadius: 17, style: .continuous)
                            .fill(at != nil ? Color.auTintBg : Color.auFill)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 17, style: .continuous)
                            .strokeBorder(
                                at != nil ? Color.auAccent.opacity(0.34) : Color.auEdge,
                                lineWidth: 1.5)
                    )
                    .foregroundStyle(at != nil ? Color.auTintText : Color.auText)
                }
                .buttonStyle(.auTap)
                .accessibilityIdentifier("au.player.tile.\(k)")
                .accessibilityLabel(t)
                .accessibilityValue(
                    at.map { String(localized: "Position \($0 + 1)") }
                        ?? String(localized: "Not selected")
                )
                .accessibilityAddTraits(at != nil ? .isSelected : [])
            }
        }

        if m.tileComplete {
            Text(
                m.tileCorrect
                    ? (task.ok.isEmpty ? "Correct." : task.ok)
                    : (task.no.isEmpty ? "Not yet — tap a row again to take it back." : task.no)
            )
            .font(.figtree(.regular, size: 14))
            .auLine(14, 1.45)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            .padding(.vertical, 13)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous).fill(
                    m.tileCorrect ? Color.auOkBg : Color.auErrBg)
            )
            .foregroundStyle(m.tileCorrect ? Color.auOkText : Color.auErrText)
            .padding(.top, 14)
        }
    }
}

// MARK: Tiles (tile-writing, guided writing, email assembly)

struct TilesScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 22, bottomPad: 26) {
            let task = m.tileTask
            let isEmail = m.cur?.screen.kind == .emailAssembly

            HStack(spacing: 10) {
                AUIcon(kind: .tap, size: 19, color: .auTintText)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Color.auTintBg))
                Text(task.instr.isEmpty ? "Put in order." : task.instr)
                    .font(.figtree(.semibold, size: 17))
                    .frame(maxWidth: .infinity, alignment: .leading)
                if m.taskCount > 1 {
                    AUProgressCounter(current: m.tk + 1, total: m.taskCount)
                }
            }
            .padding(.bottom, 14)

            if m.hasTaskNav {
                HStack(spacing: 5) {
                    ForEach(0..<m.taskCount, id: \.self) { k in
                        Capsule()
                            .fill(
                                k == m.tk
                                    ? Color.auAccent
                                    : (k < m.tk
                                        ? Color.auAccent.opacity(0.4) : Color.auText.opacity(0.14))
                            )
                            .frame(width: k == m.tk ? 22 : 7, height: 5)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 14)
            }

            // Keep complete dialogue lines separate; word-order tasks remain inline.
            if m.usesLineAssembly {
                OrderedLineAssemblyField(lines: m.orderedTileTexts)
                    .padding(.bottom, 16)
            } else {
                Text(m.tileLine.isEmpty ? " " : m.tileLine)
                    .font(.caprasimo(size: 21))
                    .tracking(-0.21)
                    .auHeadLine(21, 1.4)
                    .frame(maxWidth: .infinity, minHeight: 74, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .strokeBorder(
                                Color.auAccent.opacity(0.36),
                                style: StrokeStyle(lineWidth: 1.5, dash: [6, 5]))
                    )
                    .padding(.bottom, 16)
            }

            FlowTiles(
                tiles: task.tiles, taken: Set(m.order), order: m.order,
                onTap: { m.toggleTile($0) },
                aidPrefix: "au.player.tile"
            )

            if m.tileComplete {
                Text(
                    m.tileCorrect
                        ? (task.ok.isEmpty ? "Correct." : task.ok)
                        : (task.no.isEmpty
                            ? "Not yet — tap a tile again to take it back." : task.no)
                )
                .font(.figtree(.regular, size: 14))
                .auLine(14, 1.45)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
                .padding(.vertical, 13)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous).fill(
                        m.tileCorrect ? Color.auOkBg : Color.auErrBg)
                )
                .foregroundStyle(m.tileCorrect ? Color.auOkText : Color.auErrText)
                .padding(.top, 16)
            }

            if isEmail, case .emailAssembly(let e) = m.cur?.screen.payload, let written = e.written,
                m.tileCorrect
            {
                Text(written)
                    .font(.figtree(.semibold, size: 16))
                    .tracking(0.16)
                    .padding(.horizontal, 17)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        UnevenCorners(bottomTrailing: 5)
                            .fill(Color.auFill)
                    )
                    .overlay(
                        UnevenCorners(bottomTrailing: 5)
                            .stroke(Color.auEdge, lineWidth: 1)
                    )
                    .padding(.top, 12)
            }

            Spacer(minLength: 12)

            if isEmail, case .emailAssembly(let e) = m.cur?.screen.payload,
                let safety = e.safety.learnerFacing
            {
                Text(safety)
                    .font(.figtree(.regular, size: 11.5))
                    .auLine(11.5, 1.5)
                    .foregroundStyle(Color.auTextTertiary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack(spacing: 12) {
                Button {
                    m.order = []
                } label: {
                    Text("Undo all")
                        .font(.figtree(.semibold, size: 16.5))
                        .frame(width: 96, height: 54)
                        .background(
                            RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous)
                                .strokeBorder(Color.auDivider, lineWidth: 1))
                }
                .buttonStyle(.auTap)

                GoOnButton(label: m.taskGoLabel, disabled: !m.tileCorrect) { m.taskAdvance() }
            }
            .padding(.top, 14)
        }
    }
}

// MARK: Substitution

struct SubstitutionScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 22, bottomPad: 26) {
            if case .substitution(let s) = m.cur?.screen.payload {
                Text("Swap a part. Keep the shape.")
                    .font(.caprasimo(size: 25))
                    .tracking(-0.45)
                    .padding(.bottom, 6)

                Text("Every line plays before you read it. Tap in, tap out.")
                    .font(.figtree(.regular, size: 12.5))
                    .auLine(12.5, 1.5)
                    .foregroundStyle(Color.auTextSecondary)
                    .padding(.bottom, 16)

                VStack(spacing: 14) {
                    ForEach(Array((s.slots ?? []).enumerated()), id: \.offset) { _, sl in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(sl.slot.uppercased())
                                .font(.figtree(.bold, size: 9.5))
                                .tracking(1.3)
                                .foregroundStyle(Color.auTextTertiary)
                            FlowLayout(spacing: 7) {
                                ForEach(sl.opts, id: \.self) { opt in
                                    SubOptionChip(
                                        opt: opt,
                                        on: m.picked[sl.slot] == opt,
                                        aid: "au.player.chip.\(opt.auSlug)"
                                    ) {
                                        m.picked[sl.slot] = opt
                                    }
                                }
                            }
                        }
                    }
                }

                // rebuilt line from picks
                let line = (s.slots ?? []).compactMap { m.picked[$0.slot] }.joined(separator: " ")
                if !line.isEmpty {
                    Text(line)
                        .font(.caprasimo(size: 18))
                        .tracking(-0.14)
                        .padding(.horizontal, 17)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            UnevenCorners(bottomTrailing: 5)
                                .fill(Color.auTintBg)
                        )
                        .foregroundStyle(Color.auTintText)
                        .padding(.top, 18)
                }

                Spacer(minLength: 12)

                if let note = s.note.learnerFacing {
                    Text(note)
                        .font(.figtree(.regular, size: 11.5))
                        .auLine(11.5, 1.5)
                        .foregroundStyle(Color.auTextTertiary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                GoOnButton(label: "Go on") { m.goto(m.p + 1) }
                    .padding(.top, 14)
            }
        }
    }
}

// MARK: Mission brief

struct MissionScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 0, bottomPad: 26, hPad: 0) {
            if case .missionBrief(let mb) = m.cur?.screen.payload {
                IllustrationPlaceholder(
                    ill: mb.ill ?? IllustrationRef(id: "", alt: ""),
                    height: 250,
                    aspectRatio: m.cur?.chapter.n == 1 ? 16.0 / 9.0 : nil,
                    captionSize: 11.5,
                    fullBleed: true
                )

                VStack(alignment: .leading, spacing: 0) {
                    Text(mb.head ?? "")
                        .font(.caprasimo(size: 26))
                        .tracking(-0.52)
                        .auHeadLine(26, 1.2)
                        .padding(.bottom, 10)

                    if let body = mb.body {
                        Text(body)
                            .font(.figtree(.regular, size: 14.5))
                            .auLine(14.5, 1.55)
                            .foregroundStyle(Color.auText.opacity(0.62))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 16)
                    }

                    VStack(spacing: 10) {
                        ForEach(Array((mb.checklist ?? []).enumerated()), id: \.offset) { k, t in
                            HStack(spacing: 12) {
                                Text("\(k + 1)")
                                    .font(.figtree(.bold, size: 11.5))
                                    .frame(width: 26, height: 26)
                                    .background(
                                        Circle().strokeBorder(
                                            Color.auText.opacity(0.2), lineWidth: 2))
                                Text(t)
                                    .font(.figtree(.regular, size: 14.5))
                                    .auLine(14.5, 1.4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .padding(.bottom, 16)

                    if let card = mb.card {
                        ACard(radius: 18, padded: false) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Your sample card")
                                    .font(.figtree(.bold, size: 9.5))
                                    .tracking(1.3)
                                    .textCase(.uppercase)
                                    .foregroundStyle(Color.auAccentText)
                                    .padding(.bottom, 9)
                                ForEach(
                                    [
                                        ("NAME", card.name), ("PHONE", card.phone),
                                        ("EMAIL", card.email),
                                    ], id: \.0
                                ) { k, v in
                                    HStack(spacing: 11) {
                                        Text(k)
                                            .font(.figtree(.regular, size: 13.5))
                                            .frame(width: 56, alignment: .leading)
                                            .foregroundStyle(Color.auTextTertiary)
                                        Text(v)
                                            .font(.figtree(.regular, size: 13.5))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.vertical, 5)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 17)
                            .padding(.vertical, 15)
                        }
                        .padding(.bottom, 16)
                    }

                    Spacer(minLength: 16)

                    if let privacy = mb.privacy {
                        Text(privacy)
                            .font(.figtree(.regular, size: 11.5))
                            .auLine(11.5, 1.5)
                            .foregroundStyle(Color.auTextTertiary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 14)
                    }

                    HStack(spacing: 12) {
                        APillButton(title: "Speak", icon: .mic, player: true) { m.goto(m.p + 1) }
                        APillButton(title: "Tap", icon: .tap, player: true) { m.goto(m.p + 1) }
                    }
                }
                .padding(.horizontal, 22)
                .padding(.top, 22)
                .frame(maxHeight: .infinity, alignment: .topLeading)
            }
        }
    }
}

// MARK: Roleplay

/// A substitution option chip.
struct SubOptionChip: View {
    let opt: String
    let on: Bool
    var aid: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(opt)
                .font(.figtree(.semibold, size: 13.5))
                .foregroundStyle(on ? Color.auTintText : Color.auText.opacity(0.70))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(chipBackground)
        }
        .buttonStyle(.auTap)
        .accessibilityIdentifier(aid ?? "au.player.chip.\(opt.auSlug)")
    }

    @ViewBuilder
    private var chipBackground: some View {
        if on {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.auTintBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(Color.auAccent.opacity(0.34), lineWidth: 1)
                )
        } else {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(Color.auEdge, lineWidth: 1)
        }
    }
}

struct RoleplayScreenView: View {
    let m: PlayerModel

    var body: some View {
        ScreenColumn(topPad: 18, bottomPad: 22, hPad: 20) {
            if case .roleplay(let rp) = m.cur?.screen.payload {
                let groups = m.roleplayRequiredGroups

                // partner header
                HStack(spacing: 10) {
                    Text(String((rp.partner ?? " ").prefix(1)))
                        .font(.caprasimo(size: 17))
                        .frame(width: 38, height: 38)
                        .background(Circle().fill(Color.auTintBg))
                        .foregroundStyle(Color.auTintText)
                    VStack(alignment: .leading, spacing: 0) {
                        Text(rp.partner ?? "")
                            .font(.figtree(.semibold, size: 14.5))
                        Text(
                            m.roleplayFinished
                                ? "Guided roleplay · complete"
                                : "Guided roleplay · step \(min(m.roleplayProgressCount + 1, max(1, groups.count))) of \(max(1, groups.count))"
                        )
                        .font(.figtree(.regular, size: 11))
                        .foregroundStyle(Color.auTextTertiary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Button {
                        m.restartRoleplay()
                    } label: {
                        AUIcon(kind: .loop, size: 16)
                            .frame(width: 38, height: 38)
                            .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
                    }
                    .buttonStyle(.auTap)
                    // Craft overhaul L14: 38pt visual, 44pt hit area.
                    .auMinHitTarget()
                    .accessibilityLabel("Restart roleplay")
                }
                .padding(.bottom, 14)

                // checklist chips
                HStack(spacing: 6) {
                    ForEach(Array(groups.enumerated()), id: \.offset) { _, group in
                        let on = m.roleplayUsedGroups.contains(group.g)
                        Capsule()
                            .strokeBorder(
                                on ? Color.auAccent2Ramp(500) : Color.auText.opacity(0.18),
                                lineWidth: 1.5
                            )
                            .background(Capsule().fill(on ? Color.auOkBg : .clear))
                            .frame(height: 9)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.bottom, 16)

                // transcript bubbles
                VStack(spacing: 10) {
                    ForEach(m.roleplayLines) { line in
                        VStack(alignment: line.learner ? .trailing : .leading, spacing: 4) {
                            Text(line.speaker)
                                .font(.figtree(.bold, size: 8.5))
                                .tracking(1)
                                .foregroundStyle(Color.auText.opacity(0.38))
                            Text(line.text)
                                .font(.figtree(.regular, size: 15))
                                .auLine(15, 1.45)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 13)
                                .frame(maxWidth: 276, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 19, style: .continuous)
                                        .fill(line.learner ? Color.auTintBg : Color.auFill)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 19, style: .continuous)
                                        .strokeBorder(Color.auEdge, lineWidth: 1)
                                )
                                .foregroundStyle(line.learner ? Color.auTintText : Color.auText)
                        }
                        .frame(
                            maxWidth: .infinity,
                            alignment: line.learner ? .trailing : .leading)
                    }
                }

                Spacer(minLength: 12)

                if !m.roleplayFinished, let group = m.roleplayActiveGroup {
                    // Show only the current guided step so every visible tile
                    // is a real, unambiguous action.
                    VStack(alignment: .leading, spacing: 9) {
                        Text("Your turn — choose one reply")
                            .font(.figtree(.bold, size: 9.5))
                            .tracking(1.3)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auTextTertiary)

                        Text(group.g)
                            .font(.figtree(.semibold, size: 10.5))
                            .tracking(0.8)
                            .foregroundStyle(Color.auAccentText)

                        FlowLayout(spacing: 9) {
                            ForEach(Array(group.t.enumerated()), id: \.offset) { index, reply in
                                Button {
                                    m.chooseRoleplayReply(reply, group: group.g)
                                } label: {
                                    Text(reply)
                                        .font(.figtree(.semibold, size: 14.5))
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 11)
                                        .foregroundStyle(Color.auText)
                                        .background(
                                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                .fill(Color.auFill)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                .strokeBorder(Color.auEdge, lineWidth: 1)
                                        )
                                }
                                .buttonStyle(.auTap)
                                .accessibilityIdentifier(
                                    "au.player.roleplay.tile.\(group.g.auSlug).\(index)")
                            }
                        }

                        roleplaySpeechStatus(target: group.t.first ?? "")
                    }
                    .padding(.top, 16)
                }

                if m.roleplayFinished, let fb = rp.feedback {
                    ACard(radius: 18) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("After the roleplay")
                                .font(.figtree(.bold, size: 9.5))
                                .tracking(1.3)
                                .textCase(.uppercase)
                                .foregroundStyle(Color.auSageText)
                                .padding(.bottom, 2)
                            ForEach(fb.strong ?? [], id: \.self) { t in
                                HStack(alignment: .firstTextBaseline, spacing: 9) {
                                    Text("+")
                                        .foregroundStyle(Color.auAccent2)
                                    Text(t)
                                }
                                .font(.figtree(.regular, size: 13.5))
                                .auLine(13.5, 1.45)
                            }
                            if let next = fb.next {
                                HStack(alignment: .firstTextBaseline, spacing: 9) {
                                    Text("→")
                                        .foregroundStyle(Color.auAccent)
                                    Text(next)
                                }
                                .font(.figtree(.regular, size: 13.5))
                                .auLine(13.5, 1.45)
                                .foregroundStyle(Color.auText.opacity(0.62))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.top, 12)
                }

                if m.roleplayFinished {
                    HStack(spacing: 12) {
                        Button {
                            m.restartRoleplay()
                        } label: {
                            Text("Practice again")
                                .font(.figtree(.semibold, size: 15.5))
                                .frame(width: 122, height: 54)
                                .background(
                                    RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous)
                                        .strokeBorder(Color.auDivider, lineWidth: 1))
                        }
                        .buttonStyle(.auTap)
                        .accessibilityIdentifier("au.player.roleplay.practice-again")

                        APillButton(title: "Go on", icon: .arrow, player: true) {
                            m.goto(m.p + 1)
                        }
                    }
                    .padding(.top, 14)
                } else {
                    HStack(spacing: 12) {
                        Button {
                            m.goto(m.p + 1)
                        } label: {
                            Text("Safe stop")
                                .font(.figtree(.semibold, size: 16.5))
                                .frame(width: 104, height: 54)
                                .background(
                                    RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous)
                                        .strokeBorder(Color.auDivider, lineWidth: 1))
                        }
                        .buttonStyle(.auTap)
                        .accessibilityIdentifier("au.player.roleplay.safe-stop")

                        let target = m.roleplaySuggestedReply ?? ""
                        let recording = m.say.recording && m.say.activeTarget == target
                        APillButton(
                            title: recording ? "Stop" : "Speak",
                            icon: .mic,
                            player: true,
                            disabled: target.isEmpty || m.say.assessing
                                || m.say.preparingRecognition
                        ) {
                            m.say.toggle(target: target)
                        }
                    }
                    .padding(.top, 14)
                }
            }
        }
        .onAppear {
            m.prepareRoleplay()
            m.say.refreshPermission()
        }
        .onDisappear { m.say.reset() }
    }

    @ViewBuilder
    private func roleplaySpeechStatus(target: String) -> some View {
        let record = m.say.record(for: target)
        if m.say.micDenied {
            Text("Microphone is off. Tap a reply to continue.")
                .font(.figtree(.regular, size: 11.5))
                .foregroundStyle(Color.auErrText)
        } else if m.say.recording && m.say.activeTarget == target {
            Text("Listening to one reply…")
                .font(.figtree(.regular, size: 11.5))
                .foregroundStyle(Color.auAccentText)
        } else if m.say.assessing && m.say.activeTarget == target {
            Text("Checking your take…")
                .font(.figtree(.regular, size: 11.5))
                .foregroundStyle(Color.auTextSecondary)
        } else if record.takes > 0 || record.unavailable {
            Text("Take recorded — tap the reply you used to continue.")
                .font(.figtree(.regular, size: 11.5))
                .foregroundStyle(Color.auTextSecondary)
        } else {
            Text("You can practice the first reply aloud, then tap your choice.")
                .font(.figtree(.regular, size: 11.5))
                .foregroundStyle(Color.auTextTertiary)
        }
    }
}
