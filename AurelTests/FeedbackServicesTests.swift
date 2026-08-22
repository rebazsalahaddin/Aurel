import XCTest

@testable import Aurel

/// Stage-1 foundation (IMPROVEMENT_PLAN.md §2.5–2.9): the feedback services'
/// gates, the motion tokens, and the placeholder's honesty contract.
@MainActor
final class FeedbackServicesTests: XCTestCase {
    override func tearDown() async throws {
        // The async override can hop to the main actor to reset the gates
        // (the sync lifecycle methods are nonisolated under Swift 6).
        await MainActor.run {
            AUFeedback.isEnabled = true
            AUSound.shared.isEnabled = true
            AUSound.shared.isDucked = false
        }
    }

    /// §2.6 — the Haptics setting gates every pattern.
    func testHapticGateBlocksAndAllowsFiring() {
        AUFeedback.isEnabled = false
        let before = AUFeedback.fireCount
        AUFeedback.selection()
        AUFeedback.toggle()
        AUFeedback.press()
        AUFeedback.correct()
        AUFeedback.miss()
        AUFeedback.lessonComplete()
        AUFeedback.milestone()
        XCTAssertEqual(AUFeedback.fireCount, before, "gated haptics must not fire")

        AUFeedback.isEnabled = true
        AUFeedback.selection()
        XCTAssertEqual(AUFeedback.fireCount, before + 1, "ungated haptics must fire")
    }

    /// §2.6 — the Sound setting and the TTS duck gate every sound; the
    /// decision still counts when audio hardware is absent (the engine is
    /// never activated in tests, so nothing is scheduled).
    func testSoundGates() {
        let sound = AUSound.shared
        sound.isEnabled = false
        let before = sound.playCount
        sound.correct()
        sound.miss()
        sound.complete()
        sound.milestone()
        XCTAssertEqual(sound.playCount, before, "gated sounds must not play")

        sound.isEnabled = true
        sound.isDucked = true
        sound.correct()
        XCTAssertEqual(sound.playCount, before, "ducked sounds must not play")

        sound.isDucked = false
        sound.correct()
        XCTAssertEqual(sound.playCount, before + 1, "ungated sounds must play")
    }

    /// §2.5 — the motion tokens hold their authored values.
    func testMotionTokenValues() {
        XCTAssertEqual(AUMotion.staggerDelay, 0.06, accuracy: 0.0001)
        XCTAssertEqual(AUMotion.sceneSlide, 24, accuracy: 0.01)
    }

    /// §2.9 — the announcement vocabulary builds and posts without trapping
    /// (posting is a no-op when VoiceOver is off).
    func testAXAnnouncementVocabulary() {
        AUAX.announce("Correct")
        AUAX.screenChanged()
        AUAX.playerPosition(lesson: 1, screen: 5, total: 40)
        AUAX.onboardingStep(1, of: 2)
        AUAX.verdict(correct: true)
        AUAX.verdict(correct: false)
    }

    /// §2.8 — placeholder v2 keeps the honesty contract: the ILL id kicker,
    /// the alt caption, and the honest VoiceOver label stay in the source.
    /// (Same source-scan approach as ColorLiteralTripwireTests.)
    func testIllustrationPlaceholderHonestyContract() throws {
        let repoRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let file = repoRoot
            .appendingPathComponent("Aurel/DesignSystem/Components/Components.swift")
        let source = try String(contentsOf: file, encoding: .utf8)
        XCTAssertTrue(
            source.contains("Text(ill.id)"),
            "the authored ILL id kicker must stay in the placeholder")
        XCTAssertTrue(
            source.contains("Text(ill.alt)"),
            "the authored alt caption must stay in the placeholder")
        XCTAssertTrue(
            source.contains("accessibilityLabel(\"Illustration placeholder: \\(ill.alt)\")"),
            "the placeholder must keep announcing itself honestly to VoiceOver")
    }
}
