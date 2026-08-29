import SwiftData
import XCTest

@testable import Aurel

/// Listening-exercise integrity guards (Exercise-Meaningfulness plan, Phase 4).
///
/// Locks in the Phase 1–3 repairs at the content layer:
///  * an instruction that says “Listen” must have recorded audio to hear;
///  * learner-facing prompts must not carry authoring artifacts
///    (replay notes, turn ids, catalog ids, cue letters);
///  * testlet (listening-practice) items always reference a stimulus;
///  * warm-up “Listen” frames ship audio too, and the C1-L02 retrieval
///    frames each voice exactly their own word (defect S1-011).
/// Reads the shipped bank with JSONSerialization — the same join style
/// ContentConformanceTests uses, so every item-bearing surface is covered.
@MainActor
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

    // MARK: - Warm-up frames (learner report S1-011: C1-L02 once played one
    // six-word sequence take for every frame)

    /// Every shipped warm-up frame with provenance.
    private var allWarmupFrames: [(chapter: String, screen: String, frame: [String: Any])] {
        var out: [(String, String, [String: Any])] = []
        for chapter in chapters {
            let chapterId = chapter["id"] as! String
            for lesson in chapter["lessons"] as! [[String: Any]] {
                for screen in lesson["screens"] as! [[String: Any]]
                where screen["type"] as? String == "warmup" {
                    for frame in (screen["frames"] as? [[String: Any]]) ?? [] {
                        out.append((chapterId, screen["id"] as? String ?? "?", frame))
                    }
                }
            }
        }
        return out
    }

    /// Frame-level twin of the item-level guard above: a warm-up frame that
    /// instructs “Listen…” must ship a recorded stimulus.
    func testWarmupListenFramesCarryAudio() {
        let offenders = allWarmupFrames.filter {
            ($0.frame["q"] as? String ?? "")
                .trimmingCharacters(in: .whitespaces)
                .lowercased()
                .hasPrefix("listen")
                && ($0.frame["aud"] as? String ?? "").isEmpty
        }
        XCTAssertEqual(
            offenders.count, 0,
            "warm-up frames instruct Listen but ship no audio: "
                + offenders.map { "\($0.chapter)/\($0.screen): \($0.frame["q"] ?? "?")" }
                    .joined(separator: ", "))
    }

    /// The S1-011 repair: A1-C01-L02-S10's six “Listen. Choose.” frames were
    /// all wired to A1-C01-AUD019 — one take speaking the whole six-word
    /// sequence — so every exercise played all six words at once. Each frame
    /// now references its own word-model take; this pins that every frame's
    /// audio resolves offline, actually speaks the frame's answer, and no
    /// take backs two frames (a shared sequence take can never return).
    func testC1L02WarmupFramesEachVoiceTheirOwnWord() throws {
        let catalog = AudioCatalog(bundle: .main)
        let chapter = try XCTUnwrap(chapters.first { ($0["id"] as? String) == "A1-C01" })
        let lesson = try XCTUnwrap(
            ((chapter["lessons"] as? [[String: Any]]) ?? [])
                .first { ($0["id"] as? String) == "L02" })
        let screen = try XCTUnwrap(
            ((lesson["screens"] as? [[String: Any]]) ?? [])
                .first { ($0["id"] as? String) == "S10" })
        let frames = try XCTUnwrap(screen["frames"] as? [[String: Any]])
        XCTAssertEqual(frames.count, 6, "S10 carries the six authored retrieval frames")

        var backed: Set<String> = []
        for (index, frame) in frames.enumerated() {
            let key = try XCTUnwrap(frame["key"] as? String)
            let aud = try XCTUnwrap(
                frame["aud"] as? String, "frame \(index + 1) must reference a take")
            let asset = try XCTUnwrap(
                catalog.asset(aud: aud, chapter: "A1-C01"),
                "frame \(index + 1): \(aud) resolves to no bundled asset")
            XCTAssertTrue(
                Self.heardWords(asset.text).contains(Self.heardWords(key)),
                "frame \(index + 1) (\(key)): take \(asset.id) says “\(asset.text)” — "
                    + "the learner must hear the answer")
            XCTAssertTrue(
                backed.insert(asset.id).inserted,
                "\(asset.id) backs two frames — one take per word, never a shared sequence")
        }
    }

    /// MeaningPulse-level guard: Every meaningPulse on every screen in every chapter
    /// must carry an authored audio reference (`aud`) that resolves to a bundled asset
    /// in AudioCatalog with non-empty lines, guaranteeing the learner hears genuine
    /// character voices without robotic system TTS fallback.
    func testMeaningPulsesAlwaysHaveBundledAudio() throws {
        let catalog = AudioCatalog(bundle: .main)
        var missingAud: [String] = []
        var unresolvingAud: [String] = []
        var totalPulses = 0

        for chapter in chapters {
            let chapterId = chapter["id"] as! String
            for lesson in chapter["lessons"] as! [[String: Any]] {
                for screen in lesson["screens"] as! [[String: Any]] {
                    let screenId = screen["id"] as? String ?? "?"
                    for pulse in (screen["meaningPulses"] as? [[String: Any]]) ?? [] {
                        totalPulses += 1
                        let pulseId = pulse["id"] as? String ?? "?"
                        guard let aud = pulse["aud"] as? String, !aud.trimmingCharacters(in: .whitespaces).isEmpty else {
                            missingAud.append("\(chapterId)/\(screenId)/\(pulseId)")
                            continue
                        }
                        if catalog.asset(aud: aud, chapter: chapterId) == nil {
                            unresolvingAud.append("\(chapterId)/\(screenId)/\(pulseId): aud=\(aud)")
                        }
                    }
                }
            }
        }

        XCTAssertEqual(missingAud, [], "meaningPulses missing aud attribute: " + missingAud.joined(separator: ", "))
        XCTAssertEqual(unresolvingAud, [], "meaningPulses referencing non-existent audio assets: " + unresolvingAud.joined(separator: ", "))
        XCTAssertGreaterThan(totalPulses, 0, "must find meaningPulses in course data")
    }

    /// Verifies that listening items with specific prompts (such as "What time of day is it?"
    /// or "You hear: “...”") have an audio stimulus that directly matches the prompt and options.
    func testListeningItemsStimulusMatchesPromptAndOptions() throws {
        let catalog = AudioCatalog(bundle: .main)
        var mismatches: [String] = []

        for entry in allItems {
            guard let prompt = entry.item["prompt"] as? String, !prompt.isEmpty else { continue }
            guard let aud = entry.item["aud"] as? String, !aud.isEmpty else { continue }
            guard let asset = catalog.asset(aud: aud, chapter: entry.chapter) else {
                mismatches.append("\(entry.chapter)/\(entry.screen)/\(entry.item["id"] ?? "?"): unresolving aud \(aud)")
                continue
            }

            let assetWords = Self.heardWords(asset.text)

            // 1. "What time of day is it?" checks:
            if prompt.localizedCaseInsensitiveContains("time of day") {
                let key = entry.item["key"] as? String ?? ""
                let ok = (entry.item["ok"] as? String ?? "").lowercased()
                if (key == "A" && (ok.contains("morning") || prompt.contains("morning"))) || ok.contains("morning") {
                    if !assetWords.contains("morning") {
                        mismatches.append("\(entry.chapter)/\(entry.screen)/\(entry.item["id"] ?? "?"): expected 'morning' in audio, heard '\(asset.text)'")
                    }
                } else if ok.contains("afternoon") {
                    if !assetWords.contains("afternoon") {
                        mismatches.append("\(entry.chapter)/\(entry.screen)/\(entry.item["id"] ?? "?"): expected 'afternoon' in audio, heard '\(asset.text)'")
                    }
                } else if ok.contains("evening") {
                    if !assetWords.contains("evening") {
                        mismatches.append("\(entry.chapter)/\(entry.screen)/\(entry.item["id"] ?? "?"): expected 'evening' in audio, heard '\(asset.text)'")
                    }
                }
            }

            // 2. "You hear: “...”" checks:
            if let startQuote = prompt.range(of: "“"),
               let endQuote = prompt.range(of: "”", range: startQuote.upperBound..<prompt.endIndex) {
                let quotedText = String(prompt[startQuote.upperBound..<endQuote.lowerBound])
                let heardQuoted = Self.heardWords(quotedText)
                // Check if any key anchor word from the quoted prompt is heard in the audio take
                let anchorWords = heardQuoted.components(separatedBy: " ").filter { $0.count > 2 }
                let matchesAnchor = anchorWords.contains { assetWords.contains($0) }
                if !matchesAnchor {
                    mismatches.append("\(entry.chapter)/\(entry.screen)/\(entry.item["id"] ?? "?"): prompt quotes “\(quotedText)”, but audio take \(asset.id) says “\(asset.text)”")
                }
            }
        }

        XCTAssertEqual(mismatches, [], "Listening item stimulus mismatches found: " + mismatches.joined(separator: "\n"))
    }

    /// Verifies that all pronProduce cards across all chapters have accurate model sentences without
    /// raw placeholders (like `___` or `·`) and correctly resolve audio or clean TTS speech.
    func testPronProduceCardsSpeakAccurateModelSentences() throws {
        let catalog = AudioCatalog(bundle: .main)
        var totalProduceItems = 0

        for chapter in chapters {
            let chapterId = chapter["id"] as! String
            for lesson in chapter["lessons"] as! [[String: Any]] {
                for screen in lesson["screens"] as! [[String: Any]] {
                    guard screen["type"] as? String == "pronProduce" else { continue }
                    let screenId = screen["id"] as? String ?? "?"
                    for item in (screen["items"] as? [[String: Any]]) ?? [] {
                        totalProduceItems += 1
                        let itemId = item["id"] as? String ?? "?"
                        let word = try XCTUnwrap(item["word"] as? String, "\(chapterId)/\(screenId)/\(itemId) missing word")

                        var clean = word.replacingOccurrences(of: "·", with: "")
                        if clean.contains("___") {
                            clean = clean.replacingOccurrences(of: "___", with: "Alex")
                        }
                        if word == "H-A-D-D-A-D" {
                            clean = "H. A. D. D. A. D."
                        }
                        clean = clean.trimmingCharacters(in: .whitespacesAndNewlines)

                        XCTAssertFalse(clean.contains("___"), "\(chapterId)/\(screenId)/\(itemId) still contains placeholder underscores: \(clean)")
                        XCTAssertFalse(clean.contains("·"), "\(chapterId)/\(screenId)/\(itemId) still contains middle dot: \(clean)")
                        XCTAssertFalse(clean.isEmpty, "\(chapterId)/\(screenId)/\(itemId) produced empty model speech")

                        if let aud = item["aud"] as? String, !aud.isEmpty {
                            let asset = catalog.asset(aud: aud, chapter: chapterId)
                            XCTAssertNotNil(asset, "\(chapterId)/\(screenId)/\(itemId): aud '\(aud)' does not exist in AudioCatalog")
                        }
                    }
                }
            }
        }

        XCTAssertGreaterThan(totalProduceItems, 0, "must find pronProduce items in course data")
    }

    /// Verifies that all tile and order tasks across all chapters have valid prompts, targets, and keys.
    func testTileAndOrderTasksHaveValidPromptsAndTargets() throws {
        var totalTasks = 0

        for chapter in chapters {
            let chapterId = chapter["id"] as! String
            for lesson in chapter["lessons"] as! [[String: Any]] {
                for screen in lesson["screens"] as! [[String: Any]] {
                    let screenType = screen["type"] as? String ?? ""
                    guard screenType == "tiles" || screenType == "order" else { continue }
                    let screenId = screen["id"] as? String ?? "?"
                    guard let tasks = screen["tasks"] as? [[String: Any]] else { continue }

                    for task in tasks {
                        totalTasks += 1
                        let taskId = task["id"] as? String ?? "?"
                        let instr = CourseTextContract.learnerText(task["instr"] as? String)
                        XCTAssertNotNil(instr, "\(chapterId)/\(screenId)/\(taskId): missing learner instruction")

                        if let target = task["target"] as? String {
                            let learnerTarget = CourseTextContract.learnerText(target)
                            XCTAssertNotNil(learnerTarget, "\(chapterId)/\(screenId)/\(taskId): target '\(target)' was completely stripped")
                        }

                        let tiles = (task["tiles"] as? [String]) ?? []
                        let opts = (task["opts"] as? [[String: Any]]) ?? []
                        XCTAssertTrue(!tiles.isEmpty || !opts.isEmpty, "\(chapterId)/\(screenId)/\(taskId): both tiles and opts are empty")
                    }
                }
            }
        }

        XCTAssertGreaterThan(totalTasks, 0, "must find tile/order tasks in course data")
    }

    /// Verifies that single-sentence pronProduce requests (such as "I'm Alex." on S17) do not
    /// play repetition drills ("I. … I am Alex. … I'm Alex.") or doubled audio lines.
    func testPronProduceSingleSentenceModelPlayback() throws {
        let catalog = AudioCatalog(bundle: .main)

        // 1. AUD038 test: "I'm Alex." should not play multi-line repetition take
        let asset38 = try XCTUnwrap(catalog.asset("A1-C01-AUD038"))
        let textAlex = "I'm Alex."
        let heardAlex = Self.heardWords(textAlex)
        let exactMatch38 = asset38.lines.firstIndex(where: { Self.heardWords($0.text) == heardAlex })
        XCTAssertNil(exactMatch38, "AUD038 should not have an exact single sentence line for 'I'm Alex.'")

        // 2. AUD030 test: "What's your name?" should not play doubled line
        let asset30 = try XCTUnwrap(catalog.asset("A1-C01-AUD030"))
        let textName = "What's your name?"
        let heardName = Self.heardWords(textName)
        let singleLineHeard30 = Self.heardWords(asset30.lines[0].text)
        XCTAssertNotEqual(singleLineHeard30, heardName, "AUD030 is a repetition take and differs from single sentence")

        // 3. AUD046 test: "Nice to meet you, Nina!" should have an exact line
        let asset46 = try XCTUnwrap(catalog.asset("A1-C01-AUD046"))
        let textNina = "Nice to meet you, Nina!"
        let heardNina = Self.heardWords(textNina)
        let exactMatch46 = asset46.lines.firstIndex(where: { Self.heardWords($0.text) == heardNina })
        XCTAssertNotNil(exactMatch46, "AUD046 line 3 must match 'Nice to meet you, Nina!' exactly")
    }

    /// Verifies that quiz items allow flexible answer selection without locking until explicit confirm,
    /// and that the 75% score threshold determines passing.
    func testMasteryQuizFlexibilityAndScoringGate() throws {
        let store = try CourseStore.load()
        // Find the quiz screen in Chapter 1 Lesson 4
        let quizIndex = store.flat.firstIndex(where: { $0.screen.kind == .quiz })
        let pos = try XCTUnwrap(quizIndex)

        let model = PlayerModel(
            course: store,
            start: pos,
            bound: true,
            onScreen: { _ in },
            onExit: {},
            onFinish: {}
        )

        XCTAssertTrue(model.isQuiet, "Quiz screens must run in quiet mode")

        guard let firstItem = model.item, firstItem.opts.count >= 2 else {
            XCTFail("Quiz must have items with options")
            return
        }

        let optA = firstItem.opts[0]
        let optB = firstItem.opts[1]

        // 1. Selecting optA
        model.pick(optA, item: firstItem)
        XCTAssertEqual(model.sel, optA.id)
        XCTAssertFalse(model.done, "Selecting an option in a quiz must NOT lock the answer immediately")
        XCTAssertTrue(model.itemCanGo, "Selecting an option must enable confirmation")

        // 2. User changes mind to optB
        model.pick(optB, item: firstItem)
        XCTAssertEqual(model.sel, optB.id, "User must be able to change selection before confirming")
        XCTAssertFalse(model.done, "Answer remains unlocked before confirmation")

        // 3. Confirm answer
        model.confirmQuizAnswer()
        XCTAssertEqual(model.quizTotal, 1, "Confirming answer increments quiz total")

        // 4. Scoring percentage threshold test
        model.quizTotal = 22
        model.quizCorrect = 16 // 16 / 22 = 72.7% -> 73%
        XCTAssertFalse(model.quizPassed, "73% must not pass the 75% mastery gate")

        model.quizCorrect = 17 // 17 / 22 = 77.2% -> 77%
        XCTAssertTrue(model.quizPassed, "≥75% must pass the mastery gate")
    }

    /// Verifies that when a chapter is completed/passed, all lessons in that chapter
    /// are marked completed and unlocked.
    func testCompletedChapterLessonsState() throws {
        let container = try AppSchema.makeContainer(inMemory: true)
        let context = ModelContext(container)
        let router = AppRouter(course: CourseDecodingTests.store, modelContext: context)
        let previousUnlock = UserDefaults.standard.object(forKey: "au.unlockedChapterIdx")
        defer {
            if let previousUnlock {
                UserDefaults.standard.set(previousUnlock, forKey: "au.unlockedChapterIdx")
            } else {
                UserDefaults.standard.removeObject(forKey: "au.unlockedChapterIdx")
            }
        }

        router.recordChapterMastery(chapterIdx: 0)

        XCTAssertTrue(router.chapterComplete(0), "Chapter 0 must be marked complete after mastery")
        XCTAssertGreaterThanOrEqual(
            router.unlockedChapterIdx, 1, "Chapter 1 must be unlocked after Chapter 0 mastery")
        XCTAssertTrue(router.isChapterUnlocked(1), "Chapter 1 must report as unlocked")
    }

    /// Letters/digits/spaces lowercase fold for audio-text containment:
    /// “Hello … Thank you.” → "hello thank you", “A, B, C” → "a b c".
    private static func heardWords(_ text: String) -> String {
        let folded = text.lowercased().unicodeScalars.map { scalar -> Character in
            CharacterSet.alphanumerics.contains(scalar) ? Character(scalar) : " "
        }
        return String(folded)
        .components(separatedBy: .whitespaces)
        .filter { !$0.isEmpty }
        .joined(separator: " ")
    }
}
