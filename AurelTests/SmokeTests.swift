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
}
