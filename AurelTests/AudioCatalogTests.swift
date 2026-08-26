import XCTest

@testable import Aurel

/// Phase 3 (audio-upgrade): the shipped audio catalog and the course bank's
/// playable audio references stay joined.
///
/// Chapter 1 is the recorded pilot; later chapters stay on the TTS fallback
/// until their batch ships, so each chapter's expectation is pinned here —
/// widening it IS the batch-shipping change and should fail loudly otherwise.
///
/// Playable references are the fields the speak funnel can receive: `aud`,
/// `lineAud`, `preAud`. `vo` (promise voice-over text) and `auds` (review
/// "listening set" labels, e.g. "AUD017 — Set A sequence") are not played and
/// are excluded.
final class AudioCatalogTests: XCTestCase {
    private let catalog = AudioCatalog(bundle: .main)

    /// The approved character→voice cast (user decision, 2026-08-26).
    private let approvedVoices: Set<String> = [
        "Sarah", "Lily", "Jessica", "George", "Matilda", "Brian", "River",
        "Will", "Monika Sogam",
    ]

    // MARK: Shipped-JSON walk (same loader contract as ContentConformanceTests)

    private func shippedChapters() throws -> [[String: Any]] {
        let url = Bundle(for: AudioCatalogTests.self).url(
            forResource: "a1-course", withExtension: "json"
        ) ?? Bundle.main.url(forResource: "a1-course", withExtension: "json")
        guard let url else { fatalError("a1-course.json is missing from the test and app bundles") }
        do {
            return try JSONSerialization.jsonObject(with: Data(contentsOf: url)) as! [[String: Any]]
        } catch {
            fatalError("a1-course.json failed to parse: \(error)")
        }
    }

    /// Collects the distinct playable audio references under one chapter.
    private func playableReferences(in node: Any) -> Set<String> {
        var out = Set<String>()
        if let dict = node as? [String: Any] {
            for (key, value) in dict {
                if key == "aud" || key == "lineAud" || key == "preAud",
                    let reference = value as? String, !reference.isEmpty
                {
                    out.insert(reference)
                } else {
                    out.formUnion(playableReferences(in: value))
                }
            }
        } else if let list = node as? [Any] {
            for element in list { out.formUnion(playableReferences(in: element)) }
        }
        return out
    }

    private func references(byChapter chapterID: String) throws -> Set<String> {
        guard let chapter = try shippedChapters().first(where: { ($0["id"] as? String) == chapterID })
        else { fatalError("chapter \(chapterID) missing from shipped JSON") }
        return playableReferences(in: chapter)
    }

    private func assertResolves(_ references: Set<String>, chapter: String, file: StaticString = #filePath, line: UInt = #line) {
        let missing = references.filter { catalog.asset(aud: $0, chapter: chapter) == nil }
            .sorted()
        XCTAssertTrue(
            missing.isEmpty, "Chapter \(chapter) references with no catalog asset: \(missing)",
            file: file, line: line)
    }

    // MARK: Bundle integrity

    func testCatalogBundlesEveryLineFile() {
        let assets = catalog.assets
        XCTAssertFalse(assets.isEmpty, "audio-catalog.json missing or empty from the app bundle")
        for asset in assets {
            XCTAssertFalse(
                asset.lines.isEmpty, "\(asset.id): cataloged with no playable lines")
            for line in asset.lines {
                XCTAssertNotNil(
                    catalog.url(for: line), "\(asset.id): line file \(line.file) not in bundle")
            }
        }
    }

    func testVoiceCastMatchesApprovedMapping() {
        for asset in catalog.assets {
            for line in asset.lines {
                XCTAssertTrue(
                    approvedVoices.contains(line.voice),
                    "\(asset.id)/\(line.file): voice \"\(line.voice)\" is outside the approved cast")
            }
        }
    }

    /// YOU is the learner and is never voiced (cast decision).
    func testLearnerLinesAreNeverVoiced() {
        for asset in catalog.assets {
            for line in asset.lines {
                XCTAssertNotEqual(
                    line.speaker.uppercased(), "YOU",
                    "\(asset.id)/\(line.file): learner line must not be voiced")
            }
        }
    }

    /// AUD044 is authored as a derivative of AUD043's twice-modeled lines; the
    /// alias must resolve with real lines, not dangle.
    func testDerivativeAliasResolves() {
        let alias = catalog.asset("A1-C01-AUD044")
        XCTAssertNotNil(alias)
        XCTAssertEqual(alias?.aliasOf, "A1-C01-AUD043")
        XCTAssertFalse(alias?.lines.isEmpty ?? true)
    }

    // MARK: Reference coverage (pinned per chapter)

    func testChapter1ReferencesResolve() throws {
        assertResolves(try references(byChapter: "A1-C01"), chapter: "A1-C01")
    }

    /// The pilot contract: C2–C4 play through the TTS fallback. When a batch
    /// ships, flip these to `assertResolves` — this test failing after adding
    /// assets is the reminder to update it.
    func testUnshippedChaptersStayOnTTSFallback() throws {
        let shipped: [String] = ["A1-C01"]
        for chapter in ["A1-C02", "A1-C03", "A1-C04"] {
            let references = try references(byChapter: chapter)
            let resolving = references.filter { catalog.asset(aud: $0, chapter: chapter) != nil }
            // Cross-chapter full-id references into shipped chapters are fine;
            // a chapter-scoped hit means the batch shipped without widening
            // testChapter1ReferencesResolve's siblings above.
            let chapterScoped = resolving.filter { !$0.contains("-AUD") }
            XCTAssertTrue(
                chapterScoped.isEmpty,
                "\(chapter) references resolve chapter-scoped (\(chapterScoped.sorted())) — "
                    + "update the pinned expectation if the batch really shipped (shipped: \(shipped))")
        }
    }

    // MARK: Chapter-scoped resolution

    func testChapterScopedResolution() {
        XCTAssertNotNil(catalog.asset(aud: "AUD043", chapter: "A1-C01"))
        XCTAssertNotNil(catalog.asset(aud: "A1-C01-AUD043", chapter: "A1-C99"))
        XCTAssertNil(catalog.asset(aud: "AUD043", chapter: "A1-C02"))
        XCTAssertNil(catalog.asset(aud: "  ", chapter: "A1-C01"))
        XCTAssertNil(catalog.asset(aud: "", chapter: "A1-C01"))
    }
}
