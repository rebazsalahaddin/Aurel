import SwiftUI

// MARK: - Motion tokens (IMPROVEMENT_PLAN.md §2.5)
//
// Five speeds, one choreography rule: at any action moment, color + motion
// + haptic fire in the same frame. Every token degrades to an opacity-only
// crossfade under accessibility Reduce Motion.

enum AUMotion {
    /// Toggle flips and chip picks — felt more than seen.
    static let instant: Animation = .easeOut(duration: 0.15)

    /// Verdict cards, hint rungs, tile insert/remove.
    static let quick: Animation = .spring(response: 0.25, dampingFraction: 0.8)

    /// The verdict dock slide, plan-card selection.
    static let flow: Animation = .spring(response: 0.4, dampingFraction: 0.85)

    /// Player screen swaps and scene turns.
    static let scene: Animation = .easeInOut(duration: 0.5)

    /// Index delay for `auStagger` choreography (the authored 60 ms).
    static let staggerDelay: TimeInterval = 0.06

    /// The screen-swap slide distance.
    static let sceneSlide: CGFloat = 24

    /// `base` under normal motion; a short plain crossfade under Reduce
    /// Motion (§2.5 rule). Use with `.animation(_:value:)`.
    static func animation(_ base: Animation, reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeInOut(duration: 0.12) : base
    }

    /// The player screen-swap transition (§3.7): a 24 pt directional slide
    /// + fade; opacity-only under Reduce Motion.
    static func screenSwap(reduceMotion: Bool, forward: Bool = true) -> AnyTransition {
        guard !reduceMotion else { return .opacity }
        return .asymmetric(
            insertion: .move(edge: forward ? .trailing : .leading)
                .combined(with: .opacity),
            removal: .opacity
        )
    }
}
