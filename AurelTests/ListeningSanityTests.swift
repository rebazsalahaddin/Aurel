import XCTest
@testable import Aurel

/// Listening-exercise integrity guards (Exercise-Meaningfulness plan, Phase 4).
///
/// Locks in the Phase 1–3 repairs at the content layer:
///  * an instruction that says “Listen” must have recorded audio to hear;
///  * learner-facing prompts must not carry authoring artifacts
///    (replay notes, turn ids, catalog ids, cue letters);
///  * testlet (listening-practice) items always reference a stimulus.
/// Reads the shipped bank with JSONSerialization — the same join style
/// ContentConformanceTests uses, so every item-bearing surface is covered.
final class ListeningSanityTests: XCTestCase {

    private lazy var chapters: [[String: Any]] = {
        guard
            let url = Bundle(for: ListeningSanityTests.self).url(
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

    /// Every shipped item on every item-bearing surface, with provenance.
    private var allItems: [(chapter: String, screen: String, item: [String: Any])] {
        var out: [(String, String, [String: Any])] = []
        for chapter in chapters {
            let chapterId = chapter["id"] as! String
            for lesson in chapter["lessons"] as! [[String: Any]] {
                for screen in lesson["screens"] as! [[String: Any]] {
                    for prop in ["items", "tasks"] {
                        for item in (screen[prop] as? [[String: Any]]) ?? []
                        where item["id"] != nil {
                            out.append((chapterId, screen["id"] as? String ?? "?", item))
                        }
                    }
                }
            }
        }
        return out
    }

    func testListenInstructionsAlwaysHaveAudio() {
        let offenders = allItems.filter {
            (($0.item["instr"] as? String ?? "")
                .trimmingCharacters(in: .whitespaces)
                .lowercased()
                .hasPrefix("listen"))
                && ($0.item["aud"] as? String ?? "").isEmpty
        }
        XCTAssertEqual(
            offenders.count, 0,
            "items instruct Listen but ship no audio: "
                + offenders.map { "\($0.chapter)/\($0.screen)/\($0.item["id"]!)" }.joined(separator: ", "))
    }

    func testTestletItemsAlwaysReferenceAudio() {
        let offenders: [String] = chapters.flatMap { chapter -> [String] in
            let chapterId = chapter["id"] as! String
            return (chapter["lessons"] as! [[String: Any]]).flatMap { lesson in
                (lesson["screens"] as! [[String: Any]]).flatMap { screen -> [String] in
                    guard screen["type"] as? String == "testlet" else { return [] }
                    return ((screen["items"] as? [[String: Any]]) ?? [])
                        .filter { ($0["aud"] as? String ?? "").isEmpty }
                        .map {
                            "\(chapterId)/\(screen["id"] as? String ?? "?")"
                                + "/\($0["id"] as? String ?? "?")"
                        }
                }
            }
        }
        XCTAssertEqual(offenders, [], "testlet items without a stimulus: " + offenders.joined(separator: ", "))
    }

    func testPromptsAreLearnerFacing() {
        // Authoring artifacts that must never reach the learner again (D-05).
        let pattern =
            "\\(replay|\\(entry \\d|\\(AUD\\d{3}|\\bT\\d{1,2}:|\\bC\\d:|Line model|line \\d, item|pair \\d|at turn \\d"
        let regex = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        let offenders = allItems.compactMap { entry -> String? in
            guard let prompt = entry.item["prompt"] as? String, !prompt.isEmpty else { return nil }
            let range = NSRange(prompt.startIndex..<prompt.endIndex, in: prompt)
            guard regex.firstMatch(in: prompt, options: [], range: range) != nil else { return nil }
            return "\(entry.chapter)/\(entry.screen)/\(entry.item["id"]!): \(prompt)"
        }
        XCTAssertEqual(offenders, [], "prompts carrying authoring artifacts: " + offenders.joined(separator: " | "))
    }
}
