import SwiftUI

// MARK: - Motion tokens (IMPROVEMENT_PLAN.md §2.5)
//
// Five speeds, one choreography rule: at any action moment, color + motion
// + haptic fire in the same frame. Every token degrades to an opacity-only
// crossfade under accessibility Reduce Motion.

enum AUMotion {
    // Micro-interactions & button presses
    static let press: Animation = .spring(response: 0.18, dampingFraction: 0.70)
    static let snap: Animation = .spring(response: 0.22, dampingFraction: 0.76)

    // Toggle flips, instant feedback
    static let instant: Animation = .easeOut(duration: 0.15)

    // UI state transitions, option cards, hint rungs, tile insert/remove
    static let quick: Animation = .spring(response: 0.26, dampingFraction: 0.80)

    // Verdict dock slide, sheet presentation, tab indicator
    static let flow: Animation = .spring(response: 0.38, dampingFraction: 0.84)

    // Fluid hero expansion (path node to lesson player, welcome sun)
    static let hero: Animation = .spring(response: 0.46, dampingFraction: 0.84)

    // Dynamic tile snap & drag reordering
    static let tileSnap: Animation = .spring(response: 0.22, dampingFraction: 0.78)

    // 3D Flashcard flip physics
    static let cardFlip: Animation = .spring(response: 0.42, dampingFraction: 0.82)

    // Celebratory milestone drops, XP counter bursts
    static let celebration: Animation = .spring(response: 0.52, dampingFraction: 0.68)

    // Ambient loops
    static let breathe: Animation = .easeInOut(duration: 2.4).repeatForever(autoreverses: true)
    static let shimmer: Animation = .linear(duration: 1.8).repeatForever(autoreverses: false)

    // Player screen swaps and scene turns
    static let scene: Animation = .easeInOut(duration: 0.5)

    // Index delay for staggered choreography (60ms)
    static let staggerDelay: TimeInterval = 0.06

    // The screen-swap slide distance
    static let sceneSlide: CGFloat = 24

    /// `base` under normal motion; a short plain crossfade under Reduce Motion (§2.5 rule). Use with `.animation(_:value:)`.
    static func animation(_ base: Animation, reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeInOut(duration: 0.16) : base
    }

    /// The player screen-swap transition: directional slide + fade; opacity-only under Reduce Motion.
    static func screenSwap(reduceMotion: Bool, forward: Bool = true) -> AnyTransition {
        guard !reduceMotion else { return .opacity }
        return .asymmetric(
            insertion: .move(edge: forward ? .trailing : .leading)
                .combined(with: .opacity),
            removal: .move(edge: forward ? .leading : .trailing)
                .combined(with: .opacity)
        )
    }
}
