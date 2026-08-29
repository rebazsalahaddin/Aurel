import UIKit
import XCTest

@testable import Aurel

/// Player item-gate mechanics (S0-002 regression).
///
/// `itemCanGo` ports `v.canGo` (CourseScreen.dc.html:1489–1490) with the
/// order-item override at line 1590 (`if (itemOrder) { v.canGo =
/// v.tileCorrect }`) that the original port dropped — order-kind items inside
/// non-quiet practice screens then gated on `done`, which only `pick()` sets,
/// and the lesson could never be completed.
@MainActor
final class PlayerModelTests: XCTestCase {
    private func model(atScreen screenId: String) throws -> PlayerModel {
        let store = CourseDecodingTests.store
        let pos = try XCTUnwrap(
            store.flat.firstIndex { $0.screen.id == screenId },
            "\(screenId) not found in the course")
        return PlayerModel(course: store, start: pos)
    }

    func testLessonStartsOnListeningAndSkipsNonFunctionalOrientation() throws {
        let store = CourseDecodingTests.store
        let start = store.lessonStartPos(chapterIdx: 0, lessonIdx: 0)
        XCTAssertEqual(store.flat[start].screen.kind, .hook)

        let m = PlayerModel(course: store, start: start)
        m.goto(m.p + 1)
        XCTAssertEqual(m.cur?.screen.kind, .cards)

        m.goto(m.p - 1)
        XCTAssertEqual(m.cur?.screen.kind, .hook)
    }

    /// C1-L2 S14 — first order item (PR-G012, tiles ["I'm","Maya","."]):
    /// Go-on must be gated until the tiles are ordered correctly.
    func testOrderItemGatesGoOnUntilCorrect() throws {
        let m = try model(atScreen: "S14")
        let orderIdx = try XCTUnwrap(
            m.items.firstIndex { $0.kind == "order" }, "S14 must carry an order item")
        m.i = orderIdx
        let tiles = m.tileTask.tiles
        XCTAssertFalse(tiles.isEmpty, "order item must have tiles")

        // Fresh item: gated.
        XCTAssertFalse(m.itemCanGo, "fresh order item must gate Go-on")

        // Complete every tile but in the wrong order: still gated.
        for k in stride(from: tiles.count - 1, through: 0, by: -1) { m.toggleTile(k) }
        XCTAssertTrue(m.tileComplete)
        if tiles.reversed() != m.tileTask.key {
            XCTAssertFalse(m.tileCorrect)
            XCTAssertFalse(m.itemCanGo, "a wrong ordering must keep Go-on gated")
        }

        // Correct order (indexes of the key tiles): enabled.
        m.order = m.tileTask.key.compactMap { key in tiles.firstIndex(of: key) }
        XCTAssertTrue(m.tileCorrect, "key \(m.tileTask.key) over tiles \(tiles)")
        XCTAssertTrue(m.itemCanGo, "the correct ordering must enable Go-on (S0-002)")
    }

    /// Option items keep the authored gate: `done || quiet` — and the retry
    /// ladder still reveals after three wrong picks (repeats count; S14's
    /// items carry only two distinct distractors).
    func testOptionItemGateMatchesAuthoredRule() throws {
        let m = try model(atScreen: "S14")
        let idx = try XCTUnwrap(
            m.items.firstIndex { ($0.kind == nil || $0.kind != "order") && !$0.opts.isEmpty },
            "S14 must carry an option item")
        m.i = idx
        guard let item = m.item else {
            return XCTFail("item vanished")
        }
        let opts = item.opts
        XCTAssertFalse(m.isQuiet, "S14 is a practice screen — not quiet")
        XCTAssertFalse(m.itemCanGo, "fresh option item must gate Go-on")

        // Miss the same distractor three times: the ladder reveals.
        let key = item.key?.single
        guard let distractor = opts.first(where: { $0.text != key && $0.id != key }) else {
            return XCTFail("no distractor found")
        }
        for _ in 0..<3 { m.pick(distractor, item: item) }
        XCTAssertEqual(m.wrong, 3)
        XCTAssertTrue(m.done, "third miss reveals")
        XCTAssertTrue(m.itemCanGo, "revealed item must let the learner go on")
    }

    /// Quiz screens stay quiet for option items, but order items follow the
    /// tile rule everywhere — line 1590's override is unconditional
    /// (`if (itemOrder) { v.canGo = v.tileCorrect }`).
    func testQuizOrderItemFollowsTileRule() throws {
        let m = try model(atScreen: "S33")  // C1-L4 quiz: QZ-CN002/QZ-WR001
        let orderIdx = try XCTUnwrap(
            m.items.firstIndex { $0.kind == "order" }, "S33 must carry an order item")
        m.i = orderIdx
        XCTAssertTrue(m.isQuiet, "quiz screens are quiet")
        XCTAssertFalse(m.itemCanGo, "fresh order item gates Go-on even in a quiz")

        let tiles = m.tileTask.tiles
        m.order = m.tileTask.key.compactMap { key in tiles.firstIndex(of: key) }
        XCTAssertTrue(m.tileCorrect)
        XCTAssertTrue(m.itemCanGo, "the correct ordering enables Go-on in a quiz too")
    }

    func testSpeakItemGatesGoOnUntilTheLearnerListens() throws {
        let m = try model(atScreen: "S05")
        let idx = try XCTUnwrap(
            m.items.firstIndex { $0.kind == "speak" }, "S05 must carry a speak item")
        m.i = idx
        XCTAssertEqual(m.item?.word, "hello")
        XCTAssertFalse(m.itemCanGo, "fresh speak item must gate Go-on")

        m.listenToSpeakModel()
        XCTAssertEqual(m.plays, 1)
        XCTAssertTrue(m.itemCanGo, "hearing the model must enable Go-on and skip")
    }

    func testEverySpeakItemUnlocksAfterListening() {
        let store = CourseDecodingTests.store
        var count = 0
        for (pos, f) in store.flat.enumerated() {
            let m = PlayerModel(course: store, start: pos)
            for (idx, it) in m.items.enumerated() where it.kind == "speak" {
                m.i = idx
                m.plays = 0
                XCTAssertFalse(
                    m.itemCanGo,
                    "\(f.screen.id) · \(it.id) must gate Go-on until the model is heard")
                m.listenToSpeakModel()
                XCTAssertTrue(
                    m.itemCanGo,
                    "\(f.screen.id) · \(it.id) must unlock after listening")
                count += 1
            }
        }
        XCTAssertGreaterThan(count, 0, "the course must include speak items")
    }

    /// Every order item inside a practice screen must have a correct ordering
    /// that enables Go-on — the property that makes every lesson completable.
    func testEveryPracticeOrderItemIsCompletable() throws {
        let store = CourseDecodingTests.store
        for f in store.flat {
            guard case .practice = f.screen.payload else { continue }
            let pos = try XCTUnwrap(
                store.flat.firstIndex { $0.screen.id == f.screen.id })
            let m = PlayerModel(course: store, start: pos)
            for (idx, it) in m.items.enumerated() where it.kind == "order" {
                m.i = idx
                let tiles = m.tileTask.tiles
                m.order = m.tileTask.key.compactMap { key in tiles.firstIndex(of: key) }
                XCTAssertTrue(
                    m.tileCorrect,
                    "\(f.screen.id) · \(it.id): key \(m.tileTask.key) "
                        + "unreachable over tiles \(tiles)")
                XCTAssertTrue(m.itemCanGo, "\(f.screen.id) · \(it.id) must be passable")
            }
        }
    }

    func testLesson3OrderItemsBecameConversationCompletions() throws {
        let m = try conversationModel(chapter: "A1-C01", screen: "S24")
        XCTAssertEqual(m.cur?.screen.kind, .practice)
        XCTAssertEqual(m.items.map(\.id), ["PR-CV003", "PR-CV004", "PR-CV015"])

        for item in m.items {
            let prompt = try XCTUnwrap(item.prompt, "\(item.id) needs a conversation prompt")
            let parsed = try XCTUnwrap(
                PracticeConversationPrompt(prompt: prompt, itemID: item.id),
                "\(item.id) must render as complete-the-conversation")
            XCTAssertEqual(parsed.turns.count, 2, "\(item.id) shows one spoken line and one blank")
            XCTAssertTrue(parsed.turns[1].isTarget, "\(item.id) highlights the learner line")
            XCTAssertFalse(item.follow.isEmpty, "\(item.id) must write the rest of the meeting")
            XCTAssertEqual(item.opts.count, 2, "\(item.id) offers two completions")
            XCTAssertNotNil(item.opts.first { item.isKey($0) }?.text)
        }

        let first = try XCTUnwrap(m.item)
        let key = try XCTUnwrap(first.opts.first { first.isKey($0) })
        XCTAssertFalse(m.itemCanGo)
        m.pick(key, item: first)
        XCTAssertTrue(m.done)
        XCTAssertTrue(m.itemCanGo)

        let parsed = try XCTUnwrap(
            PracticeConversationPrompt(prompt: first.prompt ?? "", itemID: first.id))
        let continued = parsed.displayTurns(filledLine: key.text, follow: first.follow)
        XCTAssertEqual(continued[1].line, key.text)
        XCTAssertFalse(continued.contains(where: \.isTarget))
        XCTAssertEqual(continued.count, 2 + first.follow.count)
    }

    func testConversationFollowUpIsWrittenAfterTheChosenLine() throws {
        let parsed = try XCTUnwrap(
            PracticeConversationPrompt(
                prompt: "NINA: “Hi! What's your name?” YOU: ____",
                itemID: "PR-CV003"
            )
        )
        let turns = parsed.displayTurns(
            filledLine: "My name is Maya.",
            follow: [
                ChatLine(sp: "NINA", t: "Nice to meet you, Maya!"),
                ChatLine(sp: "NINA", t: "How are you?"),
            ])

        XCTAssertEqual(
            turns.map(\.line),
            [
                "Hi! What's your name?",
                "My name is Maya.",
                "Nice to meet you, Maya!",
                "How are you?",
            ])
        XCTAssertEqual(turns.map(\.displaySpeaker), ["Nina", "You", "Nina", "Nina"])
        XCTAssertFalse(turns.contains(where: \.isTarget))
    }

    func testConversationCompletionPromptBecomesReadableTurns() throws {
        let parsed = try XCTUnwrap(
            PracticeConversationPrompt(
                prompt: "A: ‘Hello! How are you?’ B: ‘I'm good, thank you! ____?’ — blank two:",
                itemID: "PR-G030 · blank 2"
            )
        )

        XCTAssertEqual(parsed.turns.count, 2)
        XCTAssertEqual(parsed.turns[0].displaySpeaker, "Speaker A")
        XCTAssertEqual(parsed.turns[0].line, "Hello! How are you?")
        XCTAssertFalse(parsed.turns[0].isTarget)
        XCTAssertEqual(parsed.turns[1].displaySpeaker, "Speaker B")
        XCTAssertEqual(parsed.turns[1].line, "I'm good, thank you! ____?")
        XCTAssertEqual(parsed.turns[1].targetBlankIndex, 0)
        XCTAssertFalse(parsed.turns[1].line.localizedCaseInsensitiveContains("blank two"))
    }

    func testConversationPromptHighlightsTheAuthoredBlankWhenTwoRemain() throws {
        let parsed = try XCTUnwrap(
            PracticeConversationPrompt(
                prompt: "A: ‘Hello! How are you?’ B: ‘____, thank you! ____?’ — blank one:",
                itemID: "PR-G030 · blank 1"
            )
        )

        XCTAssertEqual(parsed.turns[1].targetBlankIndex, 0)
    }

    func testNonConversationMetadataPromptStaysPlainText() {
        XCTAssertNil(
            PracticeConversationPrompt(
                prompt: "Form — NAME: Sam Rivera · PHONE: 4-0-1, 7-3-2",
                itemID: "QZ-RD001"
            )
        )
    }

    func testIllustrationMatchUsesRealArtworkAndLearnerAudioCues() throws {
        let m = try model(atScreen: "S18")
        let matches = m.items.filter { $0.id.hasPrefix("PR-V036 · pair") }

        XCTAssertEqual(matches.count, 3)
        XCTAssertEqual(matches.compactMap(\.word), ["good", "okay", "great"])
        for (index, item) in matches.enumerated() {
            m.i = try XCTUnwrap(m.items.firstIndex { $0.id == item.id })
            XCTAssertEqual(m.speakTextForItem, ["good", "okay", "great"][index])
            XCTAssertEqual(item.opts.count, 3)
            for option in item.opts {
                let illustration = try XCTUnwrap(option.ill, "\(item.id) · \(option.id)")
                XCTAssertNotNil(
                    UIImage(named: illustration.id),
                    "\(item.id) must not expose missing art \(illustration.id)")
            }
        }
    }

    func testEveryVisibleListenButtonHasSomethingToPlay() {
        let store = CourseDecodingTests.store
        for position in store.flat.indices {
            let m = PlayerModel(course: store, start: position)
            for itemIndex in m.items.indices where m.items[itemIndex].aud != nil {
                m.i = itemIndex
                XCTAssertFalse(
                    m.speakTextForItem?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        ?? true,
                    "\(m.cur?.screen.id ?? "unknown") · \(m.items[itemIndex].id) has a silent Listen button"
                )
            }
        }
    }

    func testEveryIllustrationChoiceThatReachesThePlayerHasPackagedArt() throws {
        let store = CourseDecodingTests.store
        for position in store.flat.indices {
            let m = PlayerModel(course: store, start: position)
            for item in m.items {
                for option in item.opts {
                    guard let illustration = option.ill else { continue }
                    XCTAssertNotNil(
                        UIImage(named: illustration.id),
                        "\(m.cur?.screen.id ?? "unknown") · \(item.id) uses missing art")
                }
            }
        }
    }

    func testRemovingUnsupportedIllustrationsNeverLeavesAnExerciseScreenEmpty() {
        let store = CourseDecodingTests.store
        for position in store.flat.indices {
            let screen = store.flat[position].screen
            let authoredCount: Int
            switch screen.payload {
            case .practice(let value): authoredCount = value.items?.count ?? 0
            case .quiz(let value): authoredCount = value.items?.count ?? 0
            case .testlet(let value): authoredCount = value.items?.count ?? 0
            case .reading(let value): authoredCount = value.items?.count ?? 0
            default: continue
            }

            if authoredCount > 0 {
                XCTAssertFalse(
                    PlayerModel(course: store, start: position).items.isEmpty,
                    "\(screen.id) lost every exercise after invalid art was removed")
            }
        }
    }

    func testEveryOrderingTaskStartsMixed() throws {
        let store = CourseDecodingTests.store
        for position in store.flat.indices {
            let m = PlayerModel(course: store, start: position)

            for itemIndex in m.items.indices where m.items[itemIndex].kind == "order" {
                m.i = itemIndex
                assertStartsMixed(
                    m, context: "\(m.cur?.screen.id ?? "unknown") · \(m.items[itemIndex].id)")
            }

            for taskIndex in 0..<m.taskCount {
                m.tk = taskIndex
                assertStartsMixed(
                    m, context: "\(m.cur?.screen.id ?? "unknown") · task \(taskIndex + 1)")
            }

            if m.cur?.screen.kind == .emailAssembly {
                assertStartsMixed(m, context: "\(m.cur?.screen.id ?? "unknown") · email")
            }
        }
    }

    func testSentenceOrderingUsesSeparateConversationTurns() throws {
        let m = try model(atScreen: "S14")
        m.i = try XCTUnwrap(m.items.firstIndex { $0.id == "PR-G027" })

        XCTAssertTrue(m.usesLineAssembly)
        XCTAssertFalse(PlayerModel.tilesAreInAnswerOrder(m.tileTask.tiles, key: m.tileTask.key))

        m.order = m.tileTask.key.compactMap { answer in m.tileTask.tiles.firstIndex(of: answer) }
        XCTAssertEqual(m.orderedTileTexts, m.tileTask.key)
        XCTAssertTrue(m.tileCorrect)
    }

    func testEveryGuidedRoleplayCompletesOneTileAtATimeAndCanAdvance() async throws {
        let store = CourseDecodingTests.store
        var roleplayCount = 0

        for position in store.flat.indices {
            guard case .roleplay = store.flat[position].screen.payload else { continue }
            roleplayCount += 1
            let m = PlayerModel(course: store, start: position)
            m.prepareRoleplay()

            let goal = m.roleplayRequiredGroups.count
            XCTAssertGreaterThan(goal, 0, "\(m.cur?.screen.id ?? "unknown") has no reply steps")
            XCTAssertFalse(m.roleplayFinished)
            XCTAssertEqual(m.roleplayProgressCount, 0)

            var taps = 0
            while let group = m.roleplayActiveGroup, taps < 12 {
                let reply = try XCTUnwrap(group.t.first, "\(group.g) has no tappable reply")
                let oldLineCount = m.roleplayLines.count
                let oldProgress = m.roleplayProgressCount
                m.chooseRoleplayReply(reply, group: group.g)

                XCTAssertEqual(m.roleplayProgressCount, oldProgress + 1)
                XCTAssertEqual(m.roleplayLines.suffix(1).first?.text, reply)

                try await Task.sleep(for: .milliseconds(700))
                XCTAssertEqual(
                    m.roleplayLines.count, oldLineCount + 2,
                    "one tile must add one learner line and one partner line")
                taps += 1
            }

            XCTAssertEqual(taps, goal)
            XCTAssertTrue(m.roleplayFinished)
            XCTAssertTrue(m.done)
            XCTAssertNil(m.roleplayActiveGroup)

            m.restartRoleplay()
            XCTAssertEqual(m.roleplayProgressCount, 0)
            XCTAssertFalse(m.roleplayFinished)
            XCTAssertFalse(m.done)

            let roleplayPosition = m.p
            m.goto(roleplayPosition + 1)
            XCTAssertNotEqual(m.p, roleplayPosition, "completed roleplay must have a next screen")
        }

        XCTAssertEqual(roleplayCount, 4)
    }

    func testWelcomeRoleplayDoesNotRepeatMayaNameQuestionOrStealTheClose() async throws {
        let m = try conversationModel(chapter: "A1-C01", screen: "S31")
        m.prepareRoleplay()

        XCTAssertEqual(m.roleplayLines.first?.speaker, "MAYA")
        XCTAssertEqual(m.roleplayLines.first?.text, "Hello! Welcome! What's your name?")
        XCTAssertEqual(m.roleplayLines.first?.learner, false)

        m.chooseRoleplayReply("Hello!", group: "greeting")
        try await Task.sleep(for: .milliseconds(700))

        let afterGreeting = m.roleplayLines.filter { !$0.learner }.map(\.text)
        XCTAssertEqual(afterGreeting.filter { $0.localizedCaseInsensitiveContains("What's your name?") }.count, 1)
        XCTAssertEqual(m.roleplayLines.last?.learner, false)
        XCTAssertNotEqual(m.roleplayLines.last?.text, "What's your name?")
        XCTAssertEqual(m.roleplayLines.filter(\.learner).last?.speaker, "YOU")
        XCTAssertNotEqual(m.roleplayLines.last?.speaker, "YOU")

        m.chooseRoleplayReply("My name is …", group: "name")
        try await Task.sleep(for: .milliseconds(700))
        XCTAssertTrue(
            m.roleplayLines.last?.text.localizedCaseInsensitiveContains("How are you") == true,
            "after a name, Maya should ask how you are — not repeat the name question")

        m.chooseRoleplayReply("I'm good, thank you!", group: "state")
        try await Task.sleep(for: .milliseconds(700))

        m.chooseRoleplayReply("Thank you! See you!", group: "close")
        try await Task.sleep(for: .milliseconds(700))

        XCTAssertTrue(m.roleplayFinished)
        let last = try XCTUnwrap(m.roleplayLines.last)
        XCTAssertFalse(last.learner)
        XCTAssertEqual(last.speaker, "MAYA")
        XCTAssertNotEqual(last.text, "Thank you! See you!")
        XCTAssertFalse(
            last.text.localizedCaseInsensitiveContains("What's your name?"),
            "the close must not fall back to a reused name prompt")

        for line in m.roleplayLines {
            if line.learner {
                XCTAssertEqual(line.speaker, "YOU")
            } else {
                XCTAssertNotEqual(line.speaker, "YOU")
            }
        }
    }

    func testYesAndNoCardsUseDistinctMeaningfulArtwork() {
        let store = CourseDecodingTests.store
        var artworkByWord: [String: Set<String>] = [:]

        for position in store.flat.indices {
            let m = PlayerModel(course: store, start: position)
            for card in m.cardList where card.main == "yes" || card.main == "no" {
                guard let illustration = card.ill else {
                    XCTFail("\(card.main) is missing its illustration")
                    continue
                }
                artworkByWord[card.main, default: []].insert(illustration.id)
                XCTAssertNotNil(UIImage(named: illustration.id))
            }
        }

        XCTAssertEqual(artworkByWord["yes"], Set(["A1-C01-ILL035"]))
        XCTAssertEqual(artworkByWord["no"], Set(["A1-C01-ILL036"]))
        XCTAssertTrue(artworkByWord["yes"]?.isDisjoint(with: artworkByWord["no"] ?? []) == true)
    }

    func testNextCardStaysGatedUntilTheLearnerListens() throws {
        // S04 is Lesson 1 Set A (hello … see you).
        let m = try model(atScreen: "S04")
        XCTAssertEqual(m.cur?.screen.kind, .cards)
        XCTAssertFalse(m.hasHeardCurrentCard)
        XCTAssertFalse(m.heardCardIndexes.contains(0))

        m.listenToCurrentCard()
        XCTAssertTrue(m.hasHeardCurrentCard)
        XCTAssertEqual(m.speakText(for: m.card), "hello")

        m.moveToCard(1)
        XCTAssertEqual(m.card.main, "hi")
        XCTAssertFalse(m.hasHeardCurrentCard)

        m.listenToCurrentCard()
        m.moveToCard(0)
        XCTAssertTrue(m.hasHeardCurrentCard, "a card already heard must stay unlocked")
    }

    func testLetterAndNumberCardsSpeakTheVisibleSymbol() throws {
        let store = CourseDecodingTests.store
        let letters = try XCTUnwrap(
            store.flat.firstIndex { $0.screen.kind == .letterCards })
        let letterModel = PlayerModel(course: store, start: letters)
        XCTAssertEqual(letterModel.speakText(for: letterModel.card), "A")
        XCTAssertEqual(letterModel.card.aud, "AUD011")

        letterModel.c = try XCTUnwrap(letterModel.cardList.firstIndex { $0.main.hasPrefix("B ") })
        XCTAssertEqual(letterModel.speakText(for: letterModel.card), "B")
        XCTAssertEqual(letterModel.card.aud, "A1-C02-AUD015")

        let numbers = try XCTUnwrap(
            store.flat.firstIndex { $0.screen.kind == .numbers })
        let numberModel = PlayerModel(course: store, start: numbers)
        XCTAssertEqual(numberModel.speakText(for: numberModel.card), "zero")
        numberModel.c = try XCTUnwrap(numberModel.cardList.firstIndex { $0.digit == "1" })
        XCTAssertEqual(numberModel.speakText(for: numberModel.card), "one")
    }

    func testConversationPlayRevealsTurnsWithTheSpokenLine() throws {
        let m = try conversationModel(chapter: "A1-C01", screen: "S20")
        guard case .conversation(let conversation) = m.cur?.screen.payload else {
            return XCTFail("C1 S20 must be a conversation")
        }
        let turnCount = try XCTUnwrap(conversation.turns?.count)
        XCTAssertGreaterThan(turnCount, 2)
        XCTAssertEqual(m.turn, 1)
        XCTAssertEqual(m.conversationRevealed, 1)

        m.startConversationPlayback(texts: (conversation.turns ?? []).map(\.t), audio: nil)
        XCTAssertEqual(m.turn, 1, "play must not jump to the last turn")
        XCTAssertEqual(m.conversationRevealed, 1)

        m.revealConversationTurn(spokenLine: 2, progress: 0, turnCount: turnCount)
        XCTAssertEqual(m.turn, 3)
        XCTAssertEqual(m.conversationRevealed, 3)

        m.revealConversationTurn(spokenLine: 0, progress: 0, turnCount: turnCount)
        XCTAssertEqual(m.turn, 1, "focus follows the spoken line")
        XCTAssertEqual(m.conversationRevealed, 3, "already-heard turns stay visible")

        m.resetConversationPlayback()
        XCTAssertEqual(m.turn, 1)
        XCTAssertEqual(m.conversationRevealed, 1)
    }

    func testConversationStoryboardFollowsEachAuthoredDialogue() {
        XCTAssertEqual(
            ConversationPlayback.activePanelIndex(turn: 1, panelCount: 5, turnCount: 8), 0)
        XCTAssertEqual(
            ConversationPlayback.activePanelIndex(turn: 2, panelCount: 5, turnCount: 8), 1)
        XCTAssertEqual(
            ConversationPlayback.activePanelIndex(turn: 4, panelCount: 5, turnCount: 8), 2)
        XCTAssertEqual(
            ConversationPlayback.activePanelIndex(turn: 8, panelCount: 5, turnCount: 8), 4)

        XCTAssertEqual(
            ConversationPlayback.activePanelIndex(turn: 1, panelCount: 5, turnCount: 10), 0)
        XCTAssertEqual(
            ConversationPlayback.activePanelIndex(turn: 3, panelCount: 5, turnCount: 10), 1)
        XCTAssertEqual(
            ConversationPlayback.activePanelIndex(turn: 10, panelCount: 5, turnCount: 10), 4)

        XCTAssertEqual(
            ConversationPlayback.activePanelIndex(turn: 1, panelCount: 2, turnCount: 10), 0)
        XCTAssertEqual(
            ConversationPlayback.activePanelIndex(turn: 6, panelCount: 2, turnCount: 10), 1)
    }

    func testConversationTogglePausesAndResumesRecordedTake() throws {
        let m = try conversationModel(chapter: "A1-C01", screen: "S20")
        guard case .conversation(let conversation) = m.cur?.screen.payload else {
            return XCTFail("C1 S20 must be a conversation")
        }
        let playback = VoicePlayback(catalog: AudioCatalog(bundle: .main))
        defer { playback.stop() }
        m.speaker = playback
        let texts = (conversation.turns ?? []).map(\.t)

        m.toggleConversationPlayback(texts: texts, audio: conversation.aud)
        XCTAssertTrue(m.isConversationPlaying)
        XCTAssertFalse(m.isConversationPaused)
        XCTAssertEqual(m.conversationRevealed, 1)
        XCTAssertEqual(m.turn, 1)

        m.toggleConversationPlayback(texts: texts, audio: conversation.aud)
        XCTAssertTrue(m.isConversationPaused)
        XCTAssertFalse(m.isConversationPlaying)
        XCTAssertEqual(playback.spokenLine, 0)

        m.toggleConversationPlayback(texts: texts, audio: conversation.aud)
        XCTAssertTrue(m.isConversationPlaying)
        XCTAssertFalse(m.isConversationPaused)
        XCTAssertEqual(playback.spokenLine, 0)
    }

    func testLesson3BestNextLineSpeaksTheQuestionNotTheAnswer() throws {
        let m = try conversationModel(chapter: "A1-C01", screen: "S25")
        let greetingIdx = try XCTUnwrap(m.items.firstIndex { $0.id == "PR-CV001" })
        m.i = greetingIdx
        XCTAssertEqual(m.item?.said?.t, "Hello! What's your name?")
        XCTAssertEqual(m.speakTextForItem, "Hello! What's your name?")
        XCTAssertEqual(m.item?.prompt, "What do you say?")
        XCTAssertEqual(
            m.item?.opts.first { m.item?.isKey($0) == true }?.text, "My name is Alex.")

        let nameIdx = try XCTUnwrap(m.items.firstIndex { $0.id == "PR-CV007" })
        m.i = nameIdx
        XCTAssertEqual(m.item?.said?.t, "What's your name?")
        XCTAssertEqual(m.speakTextForItem, "What's your name?")
        XCTAssertEqual(m.item?.prompt, "What do you say?")
        XCTAssertEqual(
            m.item?.opts.first { m.item?.isKey($0) == true }?.text, "My name is Sam.")

        let feelingIdx = try XCTUnwrap(m.items.firstIndex { $0.id == "PR-CV008" })
        m.i = feelingIdx
        XCTAssertEqual(m.item?.said?.t, "How are you?")
        XCTAssertEqual(m.speakTextForItem, "How are you?")
        XCTAssertEqual(
            m.item?.opts.first { m.item?.isKey($0) == true }?.text, "I'm okay, thank you!")
    }

    func testQuotedYouHearPromptBecomesTheListenCue() {
        XCTAssertEqual(
            PlayerModel.quotedListenCue(from: "You hear: “Hello!”"),
            "Hello!")
        XCTAssertNil(PlayerModel.quotedListenCue(from: "What do you say?"))
    }

    func testWhoSaysPromptBecomesTheListenCue() {
        XCTAssertEqual(
            PlayerModel.whoSaysListenCue(from: "Who says ‘Excuse me’?"),
            "Excuse me")
        XCTAssertEqual(
            PlayerModel.whoSaysListenCue(from: "Who says Welcome!?"),
            "Welcome!")
        XCTAssertEqual(
            PlayerModel.whoSaysListenCue(from: "Who says 'two languages' in the talk?"),
            "two languages")
        XCTAssertEqual(
            PlayerModel.whoSaysListenCue(from: "Who says: \"This is my friend Sam.\"?"),
            "This is my friend Sam.")
        XCTAssertNil(PlayerModel.whoSaysListenCue(from: "How is Sam?"))
        XCTAssertNil(PlayerModel.whoSaysListenCue(from: "What do you say?"))
    }

    func testWhoSaysExcuseMeSpeaksThePhraseNotTheSpeaker() throws {
        let m = try conversationModel(chapter: "A1-C01", screen: "S33")
        m.i = try XCTUnwrap(m.items.firstIndex { $0.id == "QZ-LS003" })
        XCTAssertEqual(m.speakTextForItem, "Excuse me")
        XCTAssertNotEqual(m.speakTextForItem, "Maya")
        XCTAssertEqual(m.item?.opts.first { m.item?.isKey($0) == true }?.text, "Maya")
    }

    private func conversationModel(chapter: String, screen: String) throws -> PlayerModel {
        let store = CourseDecodingTests.store
        let pos = try XCTUnwrap(
            store.flat.firstIndex { $0.chapter.id == chapter && $0.screen.id == screen },
            "\(chapter) \(screen) not found")
        return PlayerModel(course: store, start: pos)
    }

    private func assertStartsMixed(_ m: PlayerModel, context: String) {
        let task = m.tileTask
        guard task.tiles.count > 1, task.tiles.count == task.key.count else { return }
        XCTAssertFalse(
            PlayerModel.tilesAreInAnswerOrder(task.tiles, key: task.key),
            "\(context) opens in its answer order: \(task.tiles)")
    }
}
