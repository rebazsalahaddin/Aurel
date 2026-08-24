import UIKit

// MARK: - Haptic feedback (IMPROVEMENT_PLAN.md §2.6)
//
// The authored haptic vocabulary: one quiet pattern per meaningful moment,
// paired with the matching AUSound where the plan calls for it. Gated by
// Settings → Haptics (`SwitchPrefs.haptics`), kept in sync by AppRouter at
// launch and on toggle — the same pattern as AUTypeScale.step.

@MainActor
enum AUFeedback {
    private static let selectionGenerator = UISelectionFeedbackGenerator()
    private static let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private static let softGenerator = UIImpactFeedbackGenerator(style: .soft)
    private static let notificationGenerator = UINotificationFeedbackGenerator()

    /// Test-visible: how many patterns have fired since launch.
    private(set) static var fireCount = 0

    /// The Settings gate — AppRouter writes this whenever `sw.haptics`
    /// changes (and once at launch from the persisted preference).
    static var isEnabled = true

    /// Row / chip / plan / goal selection (§2.6 selection row).
    static func selection() {
        guard isEnabled else { return }
        fireCount += 1
        selectionGenerator.selectionChanged()
    }

    /// Settings toggles and small switches (§2.6 toggle row).
    static func toggle() {
        guard isEnabled else { return }
        fireCount += 1
        lightGenerator.impactOccurred()
    }

    /// Press feedback for authored tap-anywhere advances, undo, and tile
    /// picks (§3.8 / §3.10).
    static func press() {
        guard isEnabled else { return }
        fireCount += 1
        lightGenerator.impactOccurred(intensity: 0.7)
    }

    /// Correct verdict (§2.6) — pairs with `AUSound.correct()`.
    static func correct() {
        guard isEnabled else { return }
        fireCount += 1
        notificationGenerator.notificationOccurred(.success)
    }

    /// Miss verdict (§2.6) — two soft taps 80 ms apart: felt, never harsh.
    static func miss() {
        guard isEnabled else { return }
        fireCount += 1
        softGenerator.impactOccurred()
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(80))
            softGenerator.impactOccurred()
        }
    }

    /// Lesson complete (§2.6) — success, then a single rigid tick.
    static func lessonComplete() {
        guard isEnabled else { return }
        fireCount += 1
        notificationGenerator.notificationOccurred(.success)
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(240))
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        }
    }

    /// Streak milestone (§2.6) — the same success note; the sound differs.
    static func milestone() {
        guard isEnabled else { return }
        fireCount += 1
        notificationGenerator.notificationOccurred(.success)
    }

    /// Tile snap and slot drag insertion.
    static func tileSnap() {
        guard isEnabled else { return }
        fireCount += 1
        lightGenerator.impactOccurred(intensity: 0.55)
    }

    /// 3D card rotation flip.
    static func cardFlip() {
        guard isEnabled else { return }
        fireCount += 1
        selectionGenerator.selectionChanged()
    }

    /// Boundary or warning haptic (e.g. goal limit reached).
    static func warning() {
        guard isEnabled else { return }
        fireCount += 1
        notificationGenerator.notificationOccurred(.warning)
    }
}
