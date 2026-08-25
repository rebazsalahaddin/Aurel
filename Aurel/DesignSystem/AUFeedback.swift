import UIKit

// MARK: - Learning feedback grammar (PH-03 / REC-012)

/// One feedback contract for the chapter player and quick practice. A
/// judgment always carries meaning plus the learner's next valid action;
/// views decide only how to lay it out.
struct AULearningFeedback: Equatable, Sendable {
    enum Outcome: Equatable, Sendable {
        case correct
        case retry
        case revealed
    }

    let outcome: Outcome
    let title: String
    let detail: String
    let actionLabel: String

    var isCorrect: Bool { outcome == .correct }

    var accessibilityAnnouncement: String {
        [title, detail, actionLabel].filter { !$0.isEmpty }.joined(separator: " ")
    }

    static func option(
        isCorrect: Bool,
        isRevealed: Bool,
        instruction: String,
        acceptedAnswer: String?,
        authoredPositive: String?,
        authoredCorrection: String?
    ) -> Self {
        let answer = acceptedAnswer.map { String(localized: "Accepted answer: \($0).") }
        if isCorrect {
            return Self(
                outcome: .correct,
                title: authoredPositive.nonEmpty ?? String(localized: "That’s it."),
                detail: joined(answer, instruction),
                actionLabel: String(localized: "Go on")
            )
        }
        if isRevealed {
            return Self(
                outcome: .revealed,
                title: String(localized: "Here’s the accepted answer."),
                detail: joined(answer, instruction),
                actionLabel: String(localized: "Go on")
            )
        }
        return Self(
            outcome: .retry,
            title: authoredCorrection.nonEmpty ?? String(localized: "Not quite — try again."),
            detail: instruction.nonEmpty ?? String(localized: "Choose once more."),
            actionLabel: String(localized: "Try again")
        )
    }

    static func order(
        isCorrect: Bool,
        isRevealed: Bool,
        instruction: String,
        acceptedOrder: String,
        authoredPositive: String?,
        authoredCorrection: String?
    ) -> Self {
        let answer =
            acceptedOrder.isEmpty
            ? nil
            : String(localized: "Accepted order: \(acceptedOrder).")
        if isCorrect {
            return Self(
                outcome: .correct,
                title: authoredPositive.nonEmpty ?? String(localized: "That’s it."),
                detail: joined(answer, instruction),
                actionLabel: String(localized: "Go on")
            )
        }
        if isRevealed {
            return Self(
                outcome: .revealed,
                title: String(localized: "Here’s the accepted order."),
                detail: joined(answer, instruction),
                actionLabel: String(localized: "Go on")
            )
        }
        return Self(
            outcome: .retry,
            title: authoredCorrection.nonEmpty
                ?? String(localized: "Not quite — rebuild the line."),
            detail: joined(
                instruction,
                String(localized: "Tap a tile to remove it, then try again.")),
            actionLabel: String(localized: "Try again")
        )
    }

    private static func joined(_ parts: String?...) -> String {
        var seen: Set<String> = []
        return parts.compactMap(\.nonEmpty).filter { seen.insert($0).inserted }
            .joined(separator: " ")
    }
}

extension Optional where Wrapped == String {
    fileprivate var nonEmpty: String? {
        guard let self else { return nil }
        let value = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? nil : value
    }
}

extension String {
    fileprivate var nonEmpty: String? {
        let value = trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? nil : value
    }
}

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
