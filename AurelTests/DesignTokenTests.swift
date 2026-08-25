import SwiftUI
import UIKit
import XCTest

@testable import Aurel

/// Design-token conformance harness.
///
/// Gates the app's tokens against `Aurel/Resources/Design/design-tokens.json`,
/// which `tools/export-design-tokens.mjs` evaluates out of the three CSS source
/// layers (base styles.css → Aurel.dc.html shell → CourseScreen.dc.html player).
/// The JSON lives in the app bundle (the test host), like the course JSON.
final class DesignTokenTests: @MainActor XCTestCase {

    // MARK: - Fixture

    private struct TokenDocument: Codable {
        let colors: [String: TokenValue]
        let typography: Typography
        let typeZoom: [Double]
    }

    private struct Typography: Codable {
        let body: Double
        let fontBody: String
        let fontHeading: String
        let h1: Double
        let h2: Double
        let h3: Double
        let h4: Double
        let h5: Double
        let h6: Double
    }

    private static let document: TokenDocument = {
        guard
            let url = Bundle(for: DesignTokenTests.self).url(
                forResource: "design-tokens", withExtension: "json")
                ?? Bundle.main.url(forResource: "design-tokens", withExtension: "json")
        else {
            fatalError("design-tokens.json is missing from the test and app bundles")
        }
        do {
            return try JSONDecoder().decode(TokenDocument.self, from: Data(contentsOf: url))
        } catch {
            fatalError("design-tokens.json failed to decode: \(error)")
        }
    }()

    // MARK: - 1. Coverage, both directions

    func testColorTokenCoverageIsBidirectional() {
        let jsonKeys = Set(Self.document.colors.keys).sorted()
        let registryKeys = Set(AUColorRegistry.colorTokens.keys).sorted()
        XCTAssertEqual(
            jsonKeys,
            registryKeys,
            "JSON color tokens missing from AUColorRegistry: \(Set(jsonKeys).subtracting(registryKeys)); "
                + "registry tokens with no CSS counterpart: \(Set(registryKeys).subtracting(jsonKeys))"
        )
        XCTAssertEqual(
            Set(AUColorRegistry.uiColorTokens.keys),
            Set(AUColorRegistry.colorTokens.keys),
            "colorTokens and uiColorTokens must stay in lockstep")
    }

    // MARK: - 2. Value equality per theme (the hard gate)

    func testColorTokenValuesMatchJSONPerTheme() throws {
        let channelTolerance = 1.0 / 255.0
        let alphaTolerance = 0.01
        for (name, entry) in Self.document.colors.sorted(by: { $0.key < $1.key }) {
            let token = try XCTUnwrap(
                AUColorRegistry.uiColorTokens[name], "\(name) is missing from AUColorRegistry")
            for dark in [false, true] {
                let theme = dark ? "dark" : "light"
                let got = AUColorRegistry.resolvedRGBA(token, dark: dark)
                let want = entry.resolved(dark: dark)
                XCTAssertEqual(
                    got.r, want.r, accuracy: channelTolerance, "\(name) [\(theme)] red channel")
                XCTAssertEqual(
                    got.g, want.g, accuracy: channelTolerance, "\(name) [\(theme)] green channel")
                XCTAssertEqual(
                    got.b, want.b, accuracy: channelTolerance, "\(name) [\(theme)] blue channel")
                XCTAssertEqual(
                    got.a, want.a, accuracy: alphaTolerance, "\(name) [\(theme)] alpha channel")
            }
        }
    }

    // MARK: - 3. Typography scale

    func testTypographyScaleMatchesStylesCSS() {
        // The styles.css-derived constants (body 15px/1.55; h1…h6 = 42/32/25/20/16/13).
        let typography = Self.document.typography
        XCTAssertEqual(typography.h1, 42)
        XCTAssertEqual(typography.h2, 32)
        XCTAssertEqual(typography.h3, 25)
        XCTAssertEqual(typography.h4, 20)
        XCTAssertEqual(typography.h5, 16)
        XCTAssertEqual(typography.h6, 13)
        XCTAssertEqual(typography.body, 15)
        XCTAssertEqual(typography.fontHeading, "Caprasimo")
        XCTAssertEqual(typography.fontBody, "Figtree")
    }

    func testTypeScaleBucketsDesignSizes() {
        XCTAssertEqual(AUTypeScale.textStyle(forDesignSize: 42), .title1)
        XCTAssertEqual(AUTypeScale.textStyle(forDesignSize: 32), .title2)
        XCTAssertEqual(AUTypeScale.textStyle(forDesignSize: 25), .title3)
        XCTAssertEqual(AUTypeScale.textStyle(forDesignSize: 20), .callout)
        XCTAssertEqual(AUTypeScale.textStyle(forDesignSize: 16), .body)
        XCTAssertEqual(AUTypeScale.textStyle(forDesignSize: 15), .footnote)
        XCTAssertEqual(AUTypeScale.textStyle(forDesignSize: 13), .caption1)
    }

    func testFontResolversPreservePointSize() {
        for size in [13.0, 15.0, 16.0, 20.0, 25.0, 32.0, 42.0] {
            XCTAssertEqual(
                Figtree.uiFont(weight: .regular, size: size).pointSize,
                size,
                accuracy: 0.0001,
                "Figtree at \(size)pt")
            XCTAssertEqual(
                Figtree.uiFont(weight: .semibold, size: size).pointSize,
                size,
                accuracy: 0.0001,
                "Figtree semibold at \(size)pt")
            XCTAssertEqual(
                Caprasimo.uiFont(size: size).pointSize,
                size,
                accuracy: 0.0001,
                "Caprasimo at \(size)pt")
        }
    }

    // MARK: - 4. --au-type zoom steps

    func testTypeZoomStepsMatchPrototype() {
        XCTAssertEqual(Self.document.typeZoom, [0.88, 0.94, 1, 1.18, 1.4])
    }

    // MARK: - 5. WCAG 2.2 AA contrast (primary action is a hard gate)

    /// The full table remains evidence; the release-critical primary CTA pair
    /// must pass rather than merely print a diagnostic.
    @MainActor
    func testContrastDiagnosticsAndPrimaryActionGate() throws {
        typealias RGBA = (r: Double, g: Double, b: Double, a: Double)

        func linearize(_ c: Double) -> Double {
            c <= 0.04045 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4)
        }

        func luminance(_ c: RGBA) -> Double {
            0.2126 * linearize(c.r) + 0.7152 * linearize(c.g) + 0.0722 * linearize(c.b)
        }

        func contrastRatio(_ a: RGBA, _ b: RGBA) -> Double {
            let l1 = max(luminance(a), luminance(b))
            let l2 = min(luminance(a), luminance(b))
            return (l1 + 0.05) / (l2 + 0.05)
        }

        /// sRGB alpha compositing of `front` over `back` (gamma space).
        func flatten(_ front: RGBA, over back: RGBA) -> RGBA {
            let a = front.a + back.a * (1 - front.a)
            guard a > 0 else { return (0, 0, 0, 0) }
            return (
                (front.r * front.a + back.r * back.a * (1 - front.a)) / a,
                (front.g * front.a + back.g * back.a * (1 - front.a)) / a,
                (front.b * front.a + back.b * back.a * (1 - front.a)) / a,
                a
            )
        }

        func described(_ c: RGBA) -> String {
            String(
                format: "rgba(%.4f, %.4f, %.4f, %.4f)", c.r, c.g, c.b, c.a)
        }

        struct Pair {
            let name: String
            let foreground: String
            let foregroundLiteral: UIColor?
            let background: String
        }

        let whiteOnAccent700 =
            "white (#fff8f0) on --color-accent-700 (.au-btn-primary text)"
        let pairs: [Pair] = [
            Pair(
                name: "--color-text on --color-bg", foreground: "--color-text",
                foregroundLiteral: nil, background: "--color-bg"),
            Pair(
                name: "--color-text on --color-surface", foreground: "--color-text",
                foregroundLiteral: nil, background: "--color-surface"),
            Pair(
                name: "--au-ok-text on --au-ok-bg", foreground: "--au-ok-text",
                foregroundLiteral: nil, background: "--au-ok-bg"),
            Pair(
                name: "--au-err-text on --au-err-bg", foreground: "--au-err-text",
                foregroundLiteral: nil, background: "--au-err-bg"),
            Pair(
                name: "--au-tint-text on --au-tint-bg", foreground: "--au-tint-text",
                foregroundLiteral: nil, background: "--au-tint-bg"),
            Pair(
                name: "--au-flat-text on --au-flat-bg", foreground: "--au-flat-text",
                foregroundLiteral: nil, background: "--au-flat-bg"),
            Pair(
                name: "--au-accent-text on --color-surface", foreground: "--au-accent-text",
                foregroundLiteral: nil, background: "--color-surface"),
            Pair(
                name: "--au-sage-text on --color-surface", foreground: "--au-sage-text",
                foregroundLiteral: nil, background: "--color-surface"),
            Pair(
                name: "--au-dune-text on --au-dune", foreground: "--au-dune-text",
                foregroundLiteral: nil, background: "--au-dune"),
            Pair(
                name: whiteOnAccent700, foreground: "", foregroundLiteral: UIColor(hex: 0xfff8f0),
                background: "--color-accent-700"),
        ]

        struct ContrastReport: Codable {
            struct Result: Codable {
                let pair: String
                let theme: String
                let foregroundRGBA: String
                let backgroundRGBA: String
                let flattenedBackgroundRGBA: String
                let ratio: Double
                let passesThreshold: Bool
            }
            let standard: String
            let threshold: Double
            let results: [Result]
        }

        let threshold = 4.5
        let registry = AUColorRegistry.uiColorTokens
        let results: [ContrastReport.Result] = pairs.flatMap { pair in
            [false, true].map { dark -> ContrastReport.Result in
                let foregroundColor =
                    pair.foregroundLiteral ?? registry[pair.foreground] ?? .black
                let foreground = AUColorRegistry.resolvedRGBA(foregroundColor, dark: dark)
                guard let backgroundToken = registry[pair.background] else {
                    fatalError("\(pair.background) is missing from AUColorRegistry")
                }
                let background = AUColorRegistry.resolvedRGBA(backgroundToken, dark: dark)
                let base = AUColorRegistry.resolvedRGBA(
                    registry["--color-bg"] ?? Palette.bg, dark: dark)
                let flattenedBackground = flatten(background, over: base)
                let flattenedForeground = flatten(foreground, over: flattenedBackground)
                let ratio = contrastRatio(flattenedForeground, flattenedBackground)
                return ContrastReport.Result(
                    pair: pair.name,
                    theme: dark ? "dark" : "light",
                    foregroundRGBA: described(foreground),
                    backgroundRGBA: described(background),
                    flattenedBackgroundRGBA: described(flattenedBackground),
                    ratio: (ratio * 100).rounded() / 100,
                    passesThreshold: ratio >= threshold)
            }
        }

        for result in results where !result.passesThreshold {
            print(
                "CONTRAST \(result.pair) [\(result.theme)] = \(result.ratio):1 "
                    + "(threshold \(threshold):1) — recorded, not gating")
        }

        for result in results where result.pair == whiteOnAccent700 {
            XCTAssertTrue(
                result.passesThreshold,
                "Primary CTA contrast is \(result.ratio):1 in \(result.theme); requires \(threshold):1"
            )
        }

        let report = ContrastReport(
            standard: "WCAG 2.2 AA (relative luminance, 4.5:1)",
            threshold: threshold,
            results: results)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        let data = try encoder.encode(report)

        // qa/evidence/ under the repository root (tests compile with absolute paths).
        let repoRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let evidenceDirectory = repoRoot.appendingPathComponent("qa", isDirectory: true)
            .appendingPathComponent("evidence", isDirectory: true)
        let evidenceURL = evidenceDirectory.appendingPathComponent("token-contrast.json")
        let payload = data + Data("\n".utf8)

        XCTContext.runActivity(named: "WCAG 2.2 AA contrast diagnostics") { activity in
            do {
                try FileManager.default.createDirectory(
                    at: evidenceDirectory, withIntermediateDirectories: true)
                try payload.write(to: evidenceURL)
                let attachment = XCTAttachment(contentsOfFile: evidenceURL)
                attachment.lifetime = .keepAlways
                activity.add(attachment)
            } catch {
                // The evidence must survive even when the sandbox denies the
                // repository path (e.g. a device run): attach the bytes.
                let attachment = XCTAttachment(
                    uniformTypeIdentifier: "public.json",
                    name: "token-contrast.json",
                    payload: payload,
                    userInfo: nil)
                attachment.lifetime = .keepAlways
                activity.add(attachment)
                print("Could not write \(evidenceURL.path): \(error) — attached the report instead")
            }
        }
    }
}
