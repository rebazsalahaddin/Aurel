import SwiftUI
import XCTest

@testable import Aurel

/// S2-003 tripwire: feature/player code must not carry raw `Color(red:)`
/// literals — every color goes through the token system (`Color.au*`) or the
/// centralized scene-art palette (`AUSceneArt`), each with a design citation.
/// DesignSystem files may define tokens themselves, so they are exempt.
final class ColorLiteralTripwireTests: XCTestCase {
    func testFeatureAndCourseSourcesCarryNoColorLiterals() throws {
        let repoRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let dirs = ["Aurel/Features", "Aurel/Course"]
        var offenders: [String] = []
        for dir in dirs {
            let base = repoRoot.appendingPathComponent(dir, isDirectory: true)
            guard
                let files = try? FileManager.default.contentsOfDirectory(
                    at: base, includingPropertiesForKeys: nil
                ).filter({ $0.pathExtension == "swift" })
            else {
                continue
            }
            // Feature dirs nest one level deep.
            var swiftFiles = files.filter { !$0.hasDirectoryPath }
            for sub in files where sub.hasDirectoryPath {
                if let nested = try? FileManager.default.contentsOfDirectory(
                    at: sub, includingPropertiesForKeys: nil
                ).filter({ $0.pathExtension == "swift" }) {
                    swiftFiles += nested
                }
            }
            for file in swiftFiles {
                let source = try String(contentsOf: file, encoding: .utf8)
                if source.contains("Color(red:") || source.contains("Color(UIColor(hex:") {
                    offenders.append(
                        "\(dir)/\(file.lastPathComponent)")
                }
            }
        }
        XCTAssertTrue(
            offenders.isEmpty,
            "Raw color literals bypass the token system: \(offenders) — "
                + "use Color.au* or AUSceneArt (with a design citation)")
    }

    /// The scene-art palette stays centralized: no AUSceneArt definitions
    /// outside the DesignSystem.
    func testSceneArtStaysCentralized() throws {
        let repoRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let dirs = ["Aurel/Features", "Aurel/Course", "Aurel/App"]
        var offenders: [String] = []
        for dir in dirs {
            let base = repoRoot.appendingPathComponent(dir, isDirectory: true)
            guard
                let enumerator = FileManager.default.enumerator(
                    at: base, includingPropertiesForKeys: nil)
            else { continue }
            for case let url as URL in enumerator where url.pathExtension == "swift" {
                let source = try String(contentsOf: url, encoding: .utf8)
                if source.contains("enum AUSceneArt") {
                    offenders.append(url.lastPathComponent)
                }
            }
        }
        XCTAssertTrue(offenders.isEmpty, "AUSceneArt redefined outside DesignTokens: \(offenders)")
    }
}
