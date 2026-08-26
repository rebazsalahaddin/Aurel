import XCTest

@testable import Aurel

/// Grammar-pedagogy conformance (A1_GRAMMAR_PEDAGOGY_FRAMEWORK.md, rev.
/// 2026-08-26 + CONTROLLED_INSTRUCTION_LEXICON.md).
///
/// Pins two learner-facing guarantees of the revised grammar curriculum:
///
/// 1. **Terminology boundary** — learner-visible course copy may not depend
///    on grammar metalanguage (subject, verb, pronoun, possessive,
///    contraction, article, vowel, consonant, singular, plural, paradigm,
///    grammar rule, noun). Creator-only fields (ids, QA canon notes, dock /
///    frame notes, debug envelopes) are exempt per the lexicon.
/// 2. **Pulse gating** — a `grammarModel` screen that shows a full paradigm
///    table must first gate it behind `meaningPulses` (framework Part 4:
///    "the complete table appears only as a recap"; G007 teaches through
///    four gated pulses, never the table first).
final class GrammarConformanceTests: XCTestCase {

    // MARK: - Fixtures

    private lazy var shipped: [[String: Any]] = {
        guard
            let url = Bundle(for: GrammarConformanceTests.self).url(
                forResource: "a1-course", withExtension: "json")
                ?? Bundle.main.url(forResource: "a1-course", withExtension: "json")
        else {
            fatalError("a1-course.json is missing from the test and app bundles")
        }
        do {
            return try JSONSerialization.jsonObject(with: Data(contentsOf: url)) as! [[String: Any]]
        } catch {
            fatalError("a1-course.json failed to parse: \(error)")
        }
    }()

    /// Creator-only keys whose values never reach a learner surface: asset
    /// ids, speaker tags, debug/authoring envelope fields, and canon QA
    /// notes (the lexicon explicitly permits metalanguage there).
    private static let creatorKeys: Set<String> = [
        "id", "key", "sp", "aud", "auds", "lineAud", "preAud", "assets", "label",
        "step", "tip", "icon", "delivery", "ipa", "stress", "kind", "type",
        "a11y", "order", "n", "src", "secs", "note", "displayTitle", "bank",
        "frameNote", "dockNote", "sweep", "challengeNote", "pause", "outcome",
        "duration", "errId", "big", "ask", "clue", "map", "success",
        "doNotTeach",
    ]

    /// The lexicon's creator-only labels, plus "noun" (not demonstrated at
    /// A1; replaced by "name"/"thing" copy in the 2026-08 revision).
    private static let bannedPattern = try! NSRegularExpression(
        pattern:
            #"\b(subject|subjects|verb|verbs|pronoun|pronouns|possessive|possessives|contraction|contractions|article|articles|vowel|vowels|consonant|consonants|singular|plural|paradigm|paradigms|grammar rule|noun|nouns)\b"#,
        options: [.caseInsensitive])

    // MARK: - 1. Terminology boundary

    func testLearnerVisibleCopyAvoidsGrammarMetalanguage() {
        var violations: [String] = []
        for chapter in shipped {
            let chapterId = chapter["id"] as? String ?? "?"
            scan(chapter, path: chapterId, into: &violations)
        }
        XCTAssertTrue(
            violations.isEmpty,
            "learner-visible copy depends on grammar metalanguage: \(violations)")
    }

    private func scan(_ node: Any, path: String, into violations: inout [String]) {
        if let array = node as? [Any] {
            for (i, value) in array.enumerated() {
                scan(value, path: "\(path)[\(i)]", into: &violations)
            }
        } else if let dict = node as? [String: Any] {
            for (key, value) in dict {
                if Self.creatorKeys.contains(key) { continue }
                scan(value, path: "\(path).\(key)", into: &violations)
            }
        } else if let text = node as? String {
            let range = NSRange(text.startIndex..<text.endIndex, in: text)
            if let hit = Self.bannedPattern.firstMatch(in: text, options: [], range: range) {
                let word = (text as NSString).substring(with: hit.range)
                violations.append("\(path): “\(word)” in “\(text)”")
            }
        }
    }

    // MARK: - 2. Pulse gating before any full paradigm

    func testFullParadigmIsAlwaysGatedBehindMeaningPulses() {
        for chapter in shipped {
            let chapterId = chapter["id"] as? String ?? "?"
            for lesson in chapter["lessons"] as? [[String: Any]] ?? [] {
                let lessonId = lesson["id"] as? String ?? "?"
                for screen in lesson["screens"] as? [[String: Any]] ?? [] {
                    guard screen["type"] as? String == "grammarModel",
                        let paradigm = screen["paradigm"] as? [[Any]],
                        paradigm.count > 2
                    else { continue }
                    let pulses = (screen["meaningPulses"] as? [[String: Any]]) ?? []
                    let screenId = screen["id"] as? String ?? "?"
                    XCTAssertGreaterThanOrEqual(
                        pulses.count, 2,
                        "\(chapterId)/\(lessonId)/\(screenId): a full paradigm table (\(paradigm.count) rows) "
                            + "must be gated behind meaningPulses — the table is a recap, never the opening")
                }
            }
        }
    }

    // MARK: - 3. G007 stays pulsed (the framework's four gated pulses)

    func testG007TeachScreensCarryTheFourPulses() {
        let c3 = shipped.first { ($0["id"] as? String) == "A1-C03" }
        XCTAssertNotNil(c3, "A1-C03 missing from the bank")
        let lesson = (c3!["lessons"] as? [[String: Any]])?.first {
            ($0["id"] as? String) == "L02"
        }
        XCTAssertNotNil(lesson, "A1-C03/L02 missing")
        let screens = lesson!["screens"] as? [[String: Any]] ?? []
        let pulseCount = screens
            .filter { ($0["type"] as? String) == "grammarModel" }
            .reduce(0) { count, screen in
                count + ((screen["meaningPulses"] as? [[String: Any]])?.count ?? 0)
            }
        // Reference → affirmative grouping → negatives → confirmation:
        // at least one pulse per gate across the two teach screens.
        XCTAssertGreaterThanOrEqual(
            pulseCount, 7,
            "A1-C03/L02 grammarModel screens must carry the four gated G007 pulses")
    }
}
