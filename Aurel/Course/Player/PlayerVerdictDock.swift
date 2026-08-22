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

    enum Verdict {
        case ok(String)
        case miss(String)
    }

    var body: some View {
        VStack(spacing: 12) {
            if let verdict {
                banner(verdict)
                    .transition(
                        reduceMotion
                            ? .opacity
                            : .opacity.combined(with: .offset(y: 10))
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
        .animation(
            AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion),
            value: verdictKey
        )
        // The CTA's step-aside/return (§2.7) rides its own key: the reveal
        // rung can land without the miss copy changing.
        .animation(
            AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion),
            value: hintLadderOpen
        )
    }

    // MARK: Verdict state

    /// What the dock banner shows right now. Option items: any pick; order
    /// items: the completed assembly. `nil` = no verdict (CTA only).
    private var verdict: Verdict? {
        guard let item = model.item else { return nil }
        if item.kind == "order" {
            guard model.tileComplete else { return nil }
            let task = model.tileTask
            return model.tileCorrect
                ? .ok(task.ok.isEmpty ? "Correct." : task.ok)
                : .miss(task.no.isEmpty ? "Not yet — tap a tile again to take it back." : task.no)
        }
        guard model.sel != nil, !model.isQuiet else { return nil }
        if model.done && !model.revealed && model.isCorrect(item) {
            return .ok(item.ok ?? "Correct.")
        }
        return .miss(item.no ?? "Try again.")
    }

    private var verdictKey: String {
        switch verdict {
        case .ok(let t): return "ok:\(t)"
        case .miss(let t): return "miss:\(t)"
        case nil: return "none"
        }
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

    private func banner(_ v: Verdict) -> some View {
        let ok: Bool
        let text: String
        switch v {
        case .ok(let t): ok = true; text = t
        case .miss(let t): ok = false; text = t
        }
        return HStack(alignment: .top, spacing: 10) {
            AUIcon(kind: ok ? .check : .close, size: 18, color: ok ? .auOkText : .auErrText)
                .padding(.top, 1)
            Text(text)
                .font(.figtree(.regular, size: 14.5))
                .auLine(14.5, 1.45)
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
    }

    // MARK: CTA

    private var cta: some View {
        APillButton(
            title: model.i + 1 < model.items.count ? "Next" : "Go on",
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
        switch cur.screen.kind {
        case .practice, .quiz, .testlet, .warmup, .reading:
            return item != nil
        default:
            return false
        }
    }
}
