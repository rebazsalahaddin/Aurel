import XCTest

@testable import Aurel

final class SmokeTests: XCTestCase {
    func testBundledFontsAreRegistered() {
        let families = UIFont.familyNames
        XCTAssertTrue(families.contains("Caprasimo"), "Caprasimo missing from \(families)")
        XCTAssertTrue(families.contains("Figtree"), "Figtree missing from \(families)")
    }

    func testFigtreeWeightResolution() {
        let regular = Figtree.uiFont(weight: .regular, size: 15)
        let semibold = Figtree.uiFont(weight: .semibold, size: 15)
        XCTAssertEqual(regular.fontName, "Figtree-Regular")
        XCTAssertEqual(semibold.fontName, "Figtree-SemiBold")
        XCTAssertNotEqual(regular, semibold, "weight resolution produced identical fonts")
    }

    /// S1-001: the type scale must actually scale — the authored five steps
    /// (Aurel.dc.html:2757–2761) and the system category, whichever is larger.
    func testTypeScaleStepsScale() {
        AUTypeScale.systemCategory = .large
        AUTypeScale.step = 2  // Default — identity at the default system size
        XCTAssertEqual(AUTypeScale.scaled(15), 15, accuracy: 0.01)

        AUTypeScale.step = 4  // Largest
        XCTAssertGreaterThan(AUTypeScale.scaled(15), 15 * 1.15)

        AUTypeScale.step = 0  // Smaller — never larger than Default
        XCTAssertLessThanOrEqual(AUTypeScale.scaled(15), AUTypeScale.scaled(15 * 1))
        AUTypeScale.step = 2
        let atDefault = AUTypeScale.scaled(15)
        AUTypeScale.step = 0
        XCTAssertLessThanOrEqual(AUTypeScale.scaled(15), atDefault)

        // A learner at an AX system size keeps it at every step.
        AUTypeScale.systemCategory = .accessibilityExtraExtraExtraLarge
        XCTAssertGreaterThan(AUTypeScale.scaled(15), 15 * 1.15)
        XCTAssertEqual(AUTypeScale.effectiveCategory, .accessibilityExtraExtraExtraLarge)

        // Restore the defaults other tests assume.
        AUTypeScale.systemCategory = .large
        AUTypeScale.step = 2
    }
}
