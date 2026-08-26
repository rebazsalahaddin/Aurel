import SwiftUI

// MARK: - Player verdict dock (IMPROVEMENT_PLAN.md §2.7 / §3.9)
//
// The unified verdict + CTA container: the answer lands as a glass dock at
// the player's bottom edge — color, motion, and haptic arrive together
// (P2: Duolingo/Quizlet exercise pattern, in Aurel's calm materials). The
// dock appears when an item-bearing practice screen is current and stays
// resident while the learner works its items.

struct PlayerVerdictDock: View {
    let model: PlayerModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 12) {
            if let feedback {
                banner(feedback)
                    .transition(
                        reduceMotion
                            ? .opacity
                            : .asymmetric(
                                insertion: .scale(scale: 0.96).combined(with: .offset(y: 12))
                                    .combined(with: .opacity),
                                removal: .opacity
                            )
                    )
            }
            if !hintLadderOpen {
                cta
                    .transition(
                        reduceMotion
                            ? .opacity
                            : .opacity.combined(with: .offset(y: 6))
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 16)
        .background {
            ZStack {
                Rectangle().fill(.ultraThinMaterial.opacity(0.6))
                AUGradients.glass()
            }
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 30, bottomLeadingRadius: 0, bottomTrailingRadius: 0,
                    topTrailingRadius: 30, style: .continuous
                )
            )
            .overlay(alignment: .top) {
                UnevenRoundedRectangle(
                    topLeadingRadius: 30, bottomLeadingRadius: 0, bottomTrailingRadius: 0,
                    topTrailingRadius: 30, style: .continuous
                )
                .strokeBorder(Color.auHi, lineWidth: 1)
                .mask(Rectangle().frame(height: 1.5).frame(maxHeight: .infinity, alignment: .top))
            }
            // Craft overhaul L8: theme-aware dock elevation (was hardcoded
            // black.opacity(0.12) — muddy in dark mode).
            .auElevDock()
            .ignoresSafeArea(edges: .bottom)
        }
        .animation(
            AUMotion.animation(AUMotion.flow, reduceMotion: reduceMotion),
            value: verdictKey
        )
        .animation(
            AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion),
            value: hintLadderOpen
        )
    }

    // MARK: Verdict state

    /// What the dock banner shows right now. Option items: any pick; order
    /// items: the completed assembly. `nil` = no verdict (CTA only).
    private var feedback: AULearningFeedback? {
        guard let item = model.item else { return nil }
        if item.kind == "order" {
            guard model.tileComplete else { return nil }
            let task = model.tileTask
            return .order(
                isCorrect: model.tileCorrect,
                isRevealed: false,
                instruction: task.instr,
                acceptedOrder: task.key.joined(separator: " "),
                authoredPositive: task.ok,
                authoredCorrection: task.no
            )
        }
        guard model.sel != nil, !model.isQuiet else { return nil }
        return .option(
            isCorrect: model.done && !model.revealed && model.isCorrect(item),
            isRevealed: model.revealed,
            instruction: item.instr,
            acceptedAnswer: acceptedAnswer(for: item),
            authoredPositive: item.ok,
            authoredCorrection: item.no
        )
    }

    private var verdictKey: String {
        feedback.map { "\($0.outcome):\($0.title):\($0.detail)" } ?? "none"
    }

    /// §2.7: "dock hides the CTA while the hint ladder is open." While a
    /// miss is live the learner's work is the retry, not the advance — the
    /// CTA steps aside until the item resolves (correct pick, or the third
    /// miss that reveals). Order items: a completed-but-wrong assembly.
    private var hintLadderOpen: Bool {
        guard let item = model.item else { return false }
        if item.kind == "order" {
            return model.tileComplete && !model.tileCorrect
        }
        return model.wrong > 0 && !model.done
    }

    private func banner(_ feedback: AULearningFeedback) -> some View {
        let ok = feedback.isCorrect
        return HStack(alignment: .top, spacing: 10) {
            AUIcon(kind: ok ? .check : .close, size: 18, color: ok ? .auOkText : .auErrText)
                .padding(.top, 1)
            VStack(alignment: .leading, spacing: 3) {
                Text(feedback.title)
                    .font(.figtree(.bold, size: 14.5))
                if !feedback.detail.isEmpty {
                    Text(feedback.detail)
                        .font(.figtree(.regular, size: 13))
                        .auLine(13, 1.45)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 13)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(ok ? Color.auOkBg : Color.auErrBg)
        )
        .foregroundStyle(ok ? Color.auOkText : Color.auErrText)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(feedback.accessibilityAnnouncement)
        .accessibilityIdentifier("au.player.feedback.\(feedback.outcome)")
    }

    private func acceptedAnswer(for item: PlayerModel.PlayerItem) -> String? {
        guard let option = item.opts.first(where: item.isKey) else { return nil }
        return option.text ?? option.ill?.alt
    }

    // MARK: CTA

    private var cta: some View {
        APillButton(
            // Craft overhaul L9: one verb for the advance control (was
            // "Next" mid-lesson / "Go on" at the end — same role, two names).
            title: "Go on",
            icon: .arrow,
            player: true,
            disabled: !model.itemCanGo,
            aid: "au.player.go-on"
        ) {
            model.advance()
        }
    }
}

// MARK: - Dock presence (PlayerModel)

extension PlayerModel {
    /// Whether the chrome should show the verdict dock: the item-bearing
    /// practice family only (practice · quiz · testlet · warmup · reading).
    var hasVerdictDock: Bool {
        guard let cur else { return false }
        guard practiceTeachingComplete else { return false }
        switch cur.screen.kind {
        case .practice, .quiz, .testlet, .warmup, .reading:
            return item != nil
        default:
            return false
        }
    }
}
