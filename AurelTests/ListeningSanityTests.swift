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

    // MARK: - Card Listen takes (wrong-file / TTS / doubled-play)
    // Walks every shipped cards / letterCards / numbers screen.

    /// Every vocabulary, letter, and number card must resolve to a bundled
    /// take that actually says the card's word — never system TTS, never a
    /// neighboring number or family chant played in full.
    func testEveryCardListenResolvesToMatchingRecordedTake() throws {
        let catalog = AudioCatalog(bundle: .main)
        let store = CourseDecodingTests.store
        var failures: [String] = []
        var cardCount = 0

        for position in store.flat.indices {
            let screen = store.flat[position].screen
            guard screen.kind == .cards || screen.kind == .letterCards || screen.kind == .numbers
            else { continue }
            let model = PlayerModel(course: store, start: position)
            for (index, card) in model.cardList.enumerated() {
                cardCount += 1
                model.c = index
                let spoken = model.speakText(for: card)
                let location =
                    "\(store.flat[position].chapter.id)/\(screen.id)/\(card.id.isEmpty ? card.main : card.id)"
                guard let assetID = model.resolvedAudioID(card.aud),
                    let asset = catalog.asset(assetID)
                else {
                    failures.append("\(location): no catalog take for aud=\(card.aud ?? "nil")")
                    continue
                }
                guard
                    let take = VoicePlayback.selectTake(
                        lines: asset.lines, requestedText: spoken)
                else {
                    failures.append(
                        "\(location): “\(spoken)” falls back to TTS against \(asset.id) “\(asset.text)”"
                    )
                    continue
                }
                switch take {
                case .allLines:
                    let heard = VoicePlayback.heardWords(spoken)
                    let full = VoicePlayback.heardWords(asset.text)
                    if !full.contains(heard) {
                        failures.append(
                            "\(location): all-lines take \(asset.id) says “\(asset.text)”, not “\(spoken)”"
                        )
                    }
                case .line(let lineIndex, _):
                    let line = asset.lines[lineIndex]
                    let heard = VoicePlayback.heardWords(spoken)
                    let lineHeard = VoicePlayback.heardWords(line.text)
                    let tokens = VoicePlayback.commaTokens(
                        VoicePlayback.ellipsisSegments(line.text).first ?? line.text)
                    let ok =
                        lineHeard.contains(heard)
                        || tokens.contains(where: { VoicePlayback.heardWords($0) == heard })
                    if !ok {
                        failures.append(
                            "\(location): line \(lineIndex) of \(asset.id) says “\(line.text)”, not “\(spoken)”"
                        )
                    }
                }
            }
        }

        XCTAssertGreaterThan(cardCount, 80, "must walk every shipped vocabulary, letter, and number card")
        XCTAssertEqual(failures, [], failures.joined(separator: "\n"))
    }

    func testWordModelTakesClipToASingleUtterance() throws {
        let catalog = AudioCatalog(bundle: .main)
        let hello = try XCTUnwrap(catalog.asset("A1-C01-AUD002"))
        XCTAssertEqual(
            VoicePlayback.selectTake(lines: hello.lines, requestedText: "hello"),
            .line(index: 0, clip: .ellipsisSegment(index: 0, count: 2)))

        let hi = try XCTUnwrap(catalog.asset("A1-C01-AUD003"))
        XCTAssertEqual(
            VoicePlayback.selectTake(lines: hi.lines, requestedText: "hi"),
            .line(index: 0, clip: .ellipsisSegment(index: 0, count: 2)))

        let canada = try XCTUnwrap(catalog.asset("A1-C03-AUD008"))
        XCTAssertEqual(
            VoicePlayback.selectTake(lines: canada.lines, requestedText: "Canada"),
            .line(index: 0, clip: .ellipsisSegment(index: 0, count: 3)))

        let one = try XCTUnwrap(catalog.asset("A1-C02-AUD027"))
        XCTAssertEqual(
            VoicePlayback.selectTake(lines: one.lines, requestedText: "one"),
            .line(index: 0, clip: .commaToken(index: 1, count: 6)))

        let letterA = try XCTUnwrap(catalog.asset("A1-C02-AUD011"))
        XCTAssertEqual(
            VoicePlayback.selectTake(lines: letterA.lines, requestedText: "A"),
            .line(index: 0, clip: .ellipsisSegment(index: 0, count: 6)))

        let morning = try XCTUnwrap(catalog.asset("A1-C01-AUD004"))
        XCTAssertEqual(
            VoicePlayback.selectTake(lines: morning.lines, requestedText: "morning"),
            .line(index: 0, clip: .ellipsisSegment(index: 0, count: 2)))

        let evening = try XCTUnwrap(catalog.asset("A1-C01-AUD006"))
        XCTAssertEqual(
            VoicePlayback.selectTake(lines: evening.lines, requestedText: "evening"),
            .line(index: 0, clip: .ellipsisSegment(index: 0, count: 2)))
    }

    /// Image-choice Listen items (Listen. Match / Choose / Tap) must play the
    /// authored WAV, even when the cue is a picture-alt fragment like “morning”.
    func testImageChoiceListenUsesRecordedTakeNotTTS() throws {
        let catalog = AudioCatalog(bundle: .main)
        let store = CourseDecodingTests.store
        let playback = VoicePlayback(catalog: catalog)
        defer { playback.stop() }
        var failures: [String] = []
        var count = 0

        for position in store.flat.indices {
            let model = PlayerModel(course: store, start: position)
            for itemIndex in model.items.indices where model.items[itemIndex].kind == "image" {
                let item = model.items[itemIndex]
                guard item.aud != nil else { continue }
                count += 1
                model.i = itemIndex
                let location =
                    "\(store.flat[position].chapter.id)/\(store.flat[position].screen.id)/\(item.id)"
                guard let text = model.speakTextForItem,
                    !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                else {
                    failures.append("\(location): silent Listen cue")
                    continue
                }
                guard let assetID = model.resolvedAudioID(item.aud) else {
                    failures.append("\(location): no catalog take for aud=\(item.aud ?? "nil")")
                    continue
                }
                playback.speak(audioID: assetID, text: text, slow: false)
                if playback.spokenAssetID != assetID {
                    failures.append(
                        "\(location): cue “\(text)” fell back to TTS against \(assetID)")
                }
            }
        }

        XCTAssertGreaterThan(count, 5, "must walk image-choice Listen items")
        XCTAssertEqual(failures, [], failures.joined(separator: "\n"))
    }

    func testContactWordCardsPointAtPhoneEmailTakesNotNumbers() throws {
        let catalog = AudioCatalog(bundle: .main)
        let store = CourseDecodingTests.store
        let pos = try XCTUnwrap(
            store.flat.firstIndex {
                $0.chapter.id == "A1-C02" && $0.screen.id == "S16"
            })
        let model = PlayerModel(course: store, start: pos)
        let expected = [
            "phone", "phone number", "email", "email address", "address", "at", "dot",
            "What's your phone number?", "What's your email address?",
        ]
        XCTAssertEqual(model.cardList.map(\.main), expected)
        for card in model.cardList {
            let spoken = model.speakText(for: card)
            let asset = try XCTUnwrap(catalog.asset(model.resolvedAudioID(card.aud) ?? ""))
            let take = try XCTUnwrap(
                VoicePlayback.selectTake(lines: asset.lines, requestedText: spoken))
            guard case .line(let index, _) = take else {
                return XCTFail("\(card.main) should clip to its word-model line")
            }
            XCTAssertTrue(
                VoicePlayback.heardWords(asset.lines[index].text)
                    .contains(VoicePlayback.heardWords(spoken)),
                "\(card.main) resolved to “\(asset.text)”")
        }
    }

    // MARK: - Pronunciation MODEL + other recorded play controls

    /// Perceive MODEL used to call `speak` without the item's `aud`, so every
    /// card voiced system TTS. Every shipped perceive/produce MODEL must now
    /// resolve to its authored WAV.
    func testEveryPronunciationModelUsesRecordedTakeNotTTS() throws {
        let catalog = AudioCatalog(bundle: .main)
        let store = CourseDecodingTests.store
        let playback = VoicePlayback(catalog: catalog)
        defer { playback.stop() }
        var failures: [String] = []
        var count = 0

        for position in store.flat.indices {
            let model = PlayerModel(course: store, start: position)
            model.speaker = playback
            let chapter = store.flat[position].chapter.id
            let screen = store.flat[position].screen.id
            switch store.flat[position].screen.payload {
            case .pronPerceive(let payload):
                for item in payload.items ?? [] {
                    guard item.aud != nil else { continue }
                    count += 1
                    let location = "\(chapter)/\(screen)/\(item.id)"
                    model.listenToPerceiveModel(item)
                    guard let assetID = model.resolvedAudioID(item.aud) else {
                        failures.append("\(location): unresolved aud=\(item.aud ?? "nil")")
                        continue
                    }
                    if playback.spokenAssetID != assetID {
                        failures.append(
                            "\(location): cue “\(model.speakText(forPerceive: item))” "
                                + "fell back to TTS against \(assetID)")
                    }
                }
            case .pronProduce(let payload):
                for item in payload.items ?? [] {
                    guard item.aud != nil else { continue }
                    count += 1
                    let location = "\(chapter)/\(screen)/\(item.id)"
                    model.listenToProduceModel(item)
                    guard let assetID = model.resolvedAudioID(item.aud) else {
                        failures.append("\(location): unresolved aud=\(item.aud ?? "nil")")
                        continue
                    }
                    if playback.spokenAssetID != assetID {
                        failures.append(
                            "\(location): cue “\(model.speakText(forProduce: item))” "
                                + "fell back to TTS against \(assetID)")
                    }
                }
            default:
                break
            }
        }

        XCTAssertGreaterThan(count, 20, "must walk every shipped pronunciation MODEL card")
        XCTAssertEqual(failures, [], failures.joined(separator: "\n"))
    }

    /// C1-L3 “Pronunciation block — stress and intonation”: each MODEL play
    /// voices that card's take, not a neighbor and not system TTS.
    func testLesson3StressBlockPlaysAuthoredTakes() throws {
        let catalog = AudioCatalog(bundle: .main)
        let store = CourseDecodingTests.store
        let pos = try XCTUnwrap(
            store.flat.firstIndex {
                $0.chapter.id == "A1-C01" && $0.screen.id == "S23b"
            })
        let model = PlayerModel(course: store, start: pos)
        let playback = VoicePlayback(catalog: catalog)
        defer { playback.stop() }
        model.speaker = playback

        guard case .pronPerceive(let payload) = store.flat[pos].screen.payload else {
            return XCTFail("S23b must be a perceive screen")
        }
        let items = try XCTUnwrap(payload.items)
        XCTAssertEqual(items.map(\.id), ["PR-P005", "PR-P006", "PR-P009"])

        model.listenToPerceiveModel(items[0])
        XCTAssertEqual(model.speakText(forPerceive: items[0]), "What's your name?")
        XCTAssertEqual(playback.spokenAssetID, "A1-C01-AUD030")
        XCTAssertEqual(
            VoicePlayback.selectTake(
                lines: try XCTUnwrap(catalog.asset("A1-C01-AUD030")).lines,
                requestedText: model.speakText(forPerceive: items[0])),
            .line(index: 0, clip: .ellipsisSegment(index: 0, count: 2)))

        model.listenToPerceiveModel(items[1])
        XCTAssertEqual(playback.spokenAssetID, "A1-C01-AUD044")

        model.listenToPerceiveModel(items[2])
        XCTAssertEqual(model.speakText(forPerceive: items[2]), "Nice to meet you.")
        XCTAssertEqual(playback.spokenAssetID, "A1-C01-AUD031")
    }

    /// “Who says …?” must voice the quoted words, not the speaker-name answer.
    func testWhoSaysItemsPlayTheQuotedLineNotTheSpeakerName() throws {
        let catalog = AudioCatalog(bundle: .main)
        let store = CourseDecodingTests.store
        let cases: [(chapter: String, screen: String, id: String, cue: String, aud: String, line: Int)] =
            [
                ("A1-C01", "S33", "QZ-LS003", "Excuse me", "A1-C01-AUD043", 7),
                ("A1-C03", "S20", "PR-LS006", "two languages", "A1-C03-AUD051", 4),
                ("A1-C04", "S13", "LS005", "This is my friend Sam.", "A1-C04-AUD036", 11),
            ]
        for test in cases {
            let pos = try XCTUnwrap(
                store.flat.firstIndex {
                    $0.chapter.id == test.chapter && $0.screen.id == test.screen
                },
                "\(test.chapter) \(test.screen)")
            let model = PlayerModel(course: store, start: pos)
            model.i = try XCTUnwrap(
                model.items.firstIndex { $0.id == test.id }, test.id)
            XCTAssertEqual(model.speakTextForItem, test.cue, test.id)
            XCTAssertNotEqual(
                model.speakTextForItem,
                model.item?.opts.first { model.item?.isKey($0) == true }?.text,
                test.id)
            XCTAssertEqual(model.resolvedAudioID(model.item?.aud), test.aud, test.id)
            let asset = try XCTUnwrap(catalog.asset(test.aud), test.aud)
            let take = VoicePlayback.selectTake(
                lines: asset.lines, requestedText: test.cue)
            guard case .line(let index, _) = take else {
                return XCTFail("\(test.id) should clip to the quoted line")
            }
            XCTAssertEqual(index, test.line, test.id)
            XCTAssertTrue(
                VoicePlayback.heardWords(asset.lines[index].text)
                    .contains(VoicePlayback.heardWords(test.cue)),
                "\(test.id) line \(index) should say “\(test.cue)”")
        }
    }

    /// C1-L3 S25 reply items play the short question take, not a full meeting.
    func testLesson3BestNextLineItemsPlayTheHeardQuestion() throws {
        let catalog = AudioCatalog(bundle: .main)
        let store = CourseDecodingTests.store
        let pos = try XCTUnwrap(
            store.flat.firstIndex {
                $0.chapter.id == "A1-C01" && $0.screen.id == "S25"
            })
        let model = PlayerModel(course: store, start: pos)
        let playback = VoicePlayback(catalog: catalog)
        defer { playback.stop() }
        model.speaker = playback

        let cases: [(id: String, cue: String, aud: String, answer: String)] = [
            ("PR-CV007", "What's your name?", "A1-C01-AUD030", "My name is Sam."),
            ("PR-CV008", "How are you?", "A1-C01-AUD032", "I'm okay, thank you!"),
        ]
        for test in cases {
            let index = try XCTUnwrap(model.items.firstIndex { $0.id == test.id })
            model.i = index
            XCTAssertEqual(model.speakTextForItem, test.cue, test.id)
            XCTAssertNotEqual(model.speakTextForItem, test.answer, test.id)
            XCTAssertEqual(model.resolvedAudioID(model.item?.aud), test.aud, test.id)
            let asset = try XCTUnwrap(catalog.asset(test.aud))
            XCTAssertEqual(
                VoicePlayback.selectTake(lines: asset.lines, requestedText: test.cue),
                .line(index: 0, clip: .ellipsisSegment(index: 0, count: 2)),
                test.id)
            model.speak(model.speakTextForItem, audio: model.item?.aud)
            XCTAssertEqual(playback.spokenAssetID, test.aud, test.id)
        }
    }

    /// Intonation pairs that share a folded spelling (“You're Maya.” / “?”)
    /// must clip to different phrases of AUD041.
    func testIntonationPairsClipStatementVersusQuestion() throws {
        let catalog = AudioCatalog(bundle: .main)
        let asset = try XCTUnwrap(catalog.asset("A1-C01-AUD041"))
        XCTAssertEqual(
            VoicePlayback.selectTake(lines: asset.lines, requestedText: "You're Maya."),
            .line(index: 0, clip: .ellipsisSegment(index: 0, count: 6)))
        XCTAssertEqual(
            VoicePlayback.selectTake(lines: asset.lines, requestedText: "You're Maya?"),
            .line(index: 0, clip: .ellipsisSegment(index: 1, count: 6)))
        XCTAssertEqual(
            VoicePlayback.selectTake(lines: asset.lines, requestedText: "I'm Leo."),
            .line(index: 0, clip: .ellipsisSegment(index: 2, count: 6)))
        XCTAssertEqual(
            VoicePlayback.selectTake(lines: asset.lines, requestedText: "I'm Leo?"),
            .line(index: 0, clip: .ellipsisSegment(index: 3, count: 6)))

        let store = CourseDecodingTests.store
        let pos = try XCTUnwrap(
            store.flat.firstIndex {
                $0.chapter.id == "A1-C01" && $0.screen.id == "S16"
            })
        let model = PlayerModel(course: store, start: pos)
        guard case .pronPerceive(let payload) = store.flat[pos].screen.payload else {
            return XCTFail("C1 S16 must be a perceive screen")
        }
        let items = try XCTUnwrap(payload.items)
        XCTAssertEqual(model.speakText(forPerceive: items[0]), "You're Maya.")
        XCTAssertEqual(model.speakText(forPerceive: items[1]), "You're Maya?")
        XCTAssertEqual(model.speakText(forPerceive: items[6]), "I am")
        XCTAssertEqual(model.speakText(forPerceive: items[7]), "I'm")

        let contractions = try XCTUnwrap(catalog.asset("A1-C01-AUD042"))
        XCTAssertEqual(
            VoicePlayback.selectTake(
                lines: contractions.lines, requestedText: "I am"),
            .line(index: 0, clip: .ellipsisSegment(index: 0, count: 6)))
        XCTAssertEqual(
            VoicePlayback.selectTake(
                lines: contractions.lines, requestedText: "I'm"),
            .line(index: 0, clip: .ellipsisSegment(index: 1, count: 6)))
    }

    /// Produce MODEL cards that used to point at a neighboring take now clip
    /// to the line that actually says the prompt.
    func testProduceModelsClipToTheAuthoredLine() throws {
        let catalog = AudioCatalog(bundle: .main)
        let store = CourseDecodingTests.store

        let namePos = try XCTUnwrap(
            store.flat.firstIndex {
                $0.chapter.id == "A1-C01" && $0.screen.id == "S26b"
            })
        let nameModel = PlayerModel(course: store, start: namePos)
        guard case .pronProduce(let nameScreen) = store.flat[namePos].screen.payload,
            let nameItem = nameScreen.items?.first(where: { $0.id == "PR-P010" })
        else {
            return XCTFail("S26b PR-P010 missing")
        }
        XCTAssertEqual(nameModel.speakText(forProduce: nameItem), "My name is Alex. I'm Alex.")
        let nameAsset = try XCTUnwrap(catalog.asset(nameModel.resolvedAudioID(nameItem.aud) ?? ""))
        XCTAssertEqual(nameAsset.id, "A1-C01-AUD040")
        XCTAssertEqual(
            VoicePlayback.selectTake(
                lines: nameAsset.lines, requestedText: nameModel.speakText(forProduce: nameItem)),
            .line(index: 1, clip: .full))

        let spellPos = try XCTUnwrap(
            store.flat.firstIndex {
                $0.chapter.id == "A1-C02" && $0.screen.id == "S31b"
            })
        let spellModel = PlayerModel(course: store, start: spellPos)
        guard case .pronProduce(let spellScreen) = store.flat[spellPos].screen.payload,
            let spellItem = spellScreen.items?.first(where: { $0.id == "PR-P008" })
        else {
            return XCTFail("S31b PR-P008 missing")
        }
        XCTAssertEqual(spellModel.speakText(forProduce: spellItem), "H. A. D. D. A. D.")
        let spellAsset = try XCTUnwrap(
            catalog.asset(spellModel.resolvedAudioID(spellItem.aud) ?? ""))
        XCTAssertEqual(spellAsset.id, "A1-C02-AUD069")
        XCTAssertEqual(
            VoicePlayback.selectTake(
                lines: spellAsset.lines, requestedText: spellModel.speakText(forProduce: spellItem)),
            .line(index: 3, clip: .full))
    }

    /// Cards, practice Listen, hooks, conversations, and meaning pulses must
    /// play the bundled take — never system TTS — when an `aud` is authored.
    func testEveryDialogueAndCardPlayControlUsesRecordedTakeNotTTS() throws {
        let catalog = AudioCatalog(bundle: .main)
        let store = CourseDecodingTests.store
        let playback = VoicePlayback(catalog: catalog)
        defer { playback.stop() }
        var failures: [String] = []
        var count = 0

        for position in store.flat.indices {
            let model = PlayerModel(course: store, start: position)
            model.speaker = playback
            let locationBase =
                "\(store.flat[position].chapter.id)/\(store.flat[position].screen.id)"

            switch store.flat[position].screen.payload {
            case .hook(let hook):
                guard hook.aud != nil else { continue }
                count += 1
                let text = (hook.lines ?? []).map(\.t).joined(separator: ". ")
                assertRecorded(
                    model: model, playback: playback, text: text, audio: hook.aud,
                    location: "\(locationBase)/hook", failures: &failures)

            case .conversation(let conversation):
                let audio = conversation.aud ?? conversation.lineAud
                guard audio != nil else { continue }
                count += 1
                let text = (conversation.turns ?? []).map(\.t).joined(separator: " ")
                assertRecorded(
                    model: model, playback: playback, text: text, audio: audio,
                    location: "\(locationBase)/conversation", failures: &failures)

            case .cards(let cards):
                for pulse in cards.meaningPulses ?? [] where pulse.aud != nil {
                    count += 1
                    let text = (pulse.chat ?? []).map(\.t).joined(separator: " ")
                    assertRecorded(
                        model: model, playback: playback,
                        text: text.isEmpty ? pulse.prompt : text, audio: pulse.aud,
                        location: "\(locationBase)/\(pulse.id)", failures: &failures)
                }

            case .grammarModel(let grammar):
                for pulse in grammar.meaningPulses ?? [] where pulse.aud != nil {
                    count += 1
                    let text = (pulse.chat ?? []).map(\.t).joined(separator: " ")
                    assertRecorded(
                        model: model, playback: playback,
                        text: text.isEmpty ? pulse.prompt : text, audio: pulse.aud,
                        location: "\(locationBase)/\(pulse.id)", failures: &failures)
                }
                for (index, notice) in (grammar.notice ?? []).enumerated() where notice.aud != nil {
                    count += 1
                    let transcript = (notice.chat ?? []).map(\.t).joined(separator: " ")
                    assertRecorded(
                        model: model, playback: playback,
                        text: transcript.isEmpty ? notice.task : transcript, audio: notice.aud,
                        location: "\(locationBase)/notice-\(index)", failures: &failures)
                }

            case .practice(let practice):
                for pulse in practice.teach?.meaningPulses ?? [] where pulse.aud != nil {
                    count += 1
                    let text = (pulse.chat ?? []).map(\.t).joined(separator: " ")
                    assertRecorded(
                        model: model, playback: playback,
                        text: text.isEmpty ? pulse.prompt : text, audio: pulse.aud,
                        location: "\(locationBase)/\(pulse.id)", failures: &failures)
                }

            default:
                break
            }

            for itemIndex in model.items.indices where model.items[itemIndex].aud != nil {
                count += 1
                model.i = itemIndex
                let item = model.items[itemIndex]
                assertRecorded(
                    model: model, playback: playback, text: model.speakTextForItem,
                    audio: item.aud,
                    location: "\(locationBase)/\(item.id)", failures: &failures)
            }

            if store.flat[position].screen.kind == .cards
                || store.flat[position].screen.kind == .letterCards
                || store.flat[position].screen.kind == .numbers
            {
                for (index, card) in model.cardList.enumerated() where card.aud != nil {
                    count += 1
                    model.c = index
                    assertRecorded(
                        model: model, playback: playback, text: model.speakText(for: card),
                        audio: card.aud,
                        location: "\(locationBase)/\(card.id.isEmpty ? card.main : card.id)",
                        failures: &failures)
                }
            }
        }

        XCTAssertGreaterThan(count, 80, "must walk every shipped playable model surface")
        XCTAssertEqual(failures, [], failures.joined(separator: "\n"))
    }

    private func assertRecorded(
        model: PlayerModel, playback: VoicePlayback, text: String?, audio: String?,
        location: String, failures: inout [String]
    ) {
        guard let audio, !audio.isEmpty else { return }
        guard let text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            failures.append("\(location): silent cue")
            return
        }
        guard let assetID = model.resolvedAudioID(audio) else {
            failures.append("\(location): unresolved aud=\(audio)")
            return
        }
        playback.speak(audioID: assetID, text: text, slow: false)
        if playback.spokenAssetID != assetID {
            failures.append("\(location): cue “\(text)” fell back to TTS against \(assetID)")
        }
    }
}
