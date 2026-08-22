import UIKit

// MARK: - Accessibility helpers (IMPROVEMENT_PLAN.md §2.9)
//
// The announcement vocabulary: steps, player positions, verdicts — the
// moments VoiceOver users would otherwise miss. Announcements are a no-op
// when VoiceOver is off, so call sites never need to check.

@MainActor
enum AUAX {
    /// Post a VoiceOver announcement.
    static func announce(_ message: String) {
        guard !message.isEmpty else { return }
        UIAccessibility.post(notification: .announcement, argument: message)
    }

    /// Announce that the whole screen changed after a navigation.
    static func screenChanged() {
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }

    /// "Lesson 3, screen 12 of 40" — the player chrome on advance (§3.7).
    static func playerPosition(lesson: Int, screen: Int, total: Int) {
        announce("Lesson \(lesson), screen \(screen) of \(total)")
    }

    /// "Step 1 of 2" — the onboarding step meter (§3.2).
    static func onboardingStep(_ step: Int, of total: Int) {
        announce("Step \(step) of \(total)")
    }

    /// Verdict announcements — calm, one word more than the visual (§3.9).
    static func verdict(correct: Bool) {
        announce(correct ? "Correct" : "Try again")
    }
}
