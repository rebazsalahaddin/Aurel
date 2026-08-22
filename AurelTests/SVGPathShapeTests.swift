import SwiftUI
import XCTest

@testable import Aurel

/// SVGPathShape regression tests.
///
/// S0-001: a path containing a lowercase `s`/`t` command (e.g. the onboarding
/// exam-goal icon `s5.8-1.3 5.8-3`) sent the parser into an infinite loop —
/// the token index never advanced — hanging the main thread on layout and
/// with it every accessibility client (XCUITest, VoiceOver). The implicit
/// M-repetition pairs were also drawn as moves instead of lines.
/// These tests pin: every authored d-string parses and returns; the exam icon
/// draws a non-empty path; implicit M pairs produce line segments.
final class SVGPathShapeTests: XCTestCase {
    private let box = CGRect(x: 0, y: 0, width: 20, height: 20)

    /// Every icon the app can render must parse without hanging.
    @MainActor
    func testAllAuthoredIconPathsReturn() {
        let kinds: [AUIcon.Kind] = [
            .ear, .eye, .tap, .choose, .match, .mouth, .loop,
            .check, .arrow, .close, .back,
            .play, .mic, .link, .lock,
            .gear, .offline, .sparkle, .flame, .trophy,
            .pencil, .star, .chevron, .chevronDown,
            .speech, .reviewLoop, .camera, .alert, .clock, .warning,
        ]
        for kind in kinds {
            for sub in AUIcon.subpaths(kind) {
                assertReturns(sub.d, label: "\(kind)")
            }
        }
    }

    /// The four onboarding goal icons (GoalView.leading) — the exam icon is
    /// the one that used to hang.
    @MainActor
    func testGoalIconPathsReturn() {
        let goals = [
            "M2.5 7.5h19v12.5h-19zM8.5 7.5V6a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v1.5M2.5 12.5h19",
            AUIcon.circle(cx: 12, cy: 12, r: 9)
                + "M3 12h18M12 3a14 14 0 0 1 0 18 14 14 0 0 1 0-18",
            "M12 4 2.5 9 12 14l9.5-5zM6.2 11.3V16c0 1.7 2.6 3 5.8 3s5.8-1.3 5.8-3v-4.7",
            "M3 5.5h5a3 3 0 0 1 3 3V19a2.5 2.5 0 0 0-2.5-2.5H3zM21 5.5h-5a3 3 0 0 0-3 3V19a2.5 2.5 0 0 1 2.5-2.5H21",
        ]
        for (i, d) in goals.enumerated() {
            assertReturns(d, label: "goal icon \(i)")
        }
        // The exam icon (index 2) must actually draw.
        let exam = SVGPathShape(d: goals[2]).path(in: box)
        XCTAssertFalse(exam.isEmpty, "exam icon drew nothing")
        XCTAssertGreaterThan(exam.boundingRect.width, 0)
    }

    /// The minimal strings that used to spin forever.
    func testSmoothCurveCommandsReturn() {
        assertReturns("M1 2s3 4 5 6", label: "lowercase s")
        assertReturns("M1 2t3 4", label: "lowercase t")
        assertReturns("M1 2S3 4 5 6", label: "uppercase S")
        assertReturns("M1 2T3 4", label: "uppercase T")
    }

    /// Implicit M-repetition pairs are LINETOs per the SVG spec — the close
    /// icon's `M18 6 6 18` second pair must draw, not move.
    func testImplicitMPairsDrawLines() {
        let p = SVGPathShape(d: "M18 6 6 18").path(in: box)
        XCTAssertFalse(p.isEmpty, "M-with-implicit-pair drew nothing")
        XCTAssertEqual(p.boundingRect.width, box.width * (12.0 / 24.0), accuracy: 0.6)
    }

    /// Watchdog: path(in:) must return — a hang fails the expectation timeout.
    private func assertReturns(
        _ d: String, label: String, file: StaticString = #filePath, line: UInt = #line
    ) {
        let box = self.box
        let expectation = expectation(description: "\(label) returned")
        DispatchQueue.global().async {
            _ = SVGPathShape(d: d).path(in: box)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
}
