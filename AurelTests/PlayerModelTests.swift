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

    private func assertStartsMixed(_ m: PlayerModel, context: String) {
        let task = m.tileTask
        guard task.tiles.count > 1, task.tiles.count == task.key.count else { return }
        XCTAssertFalse(
            PlayerModel.tilesAreInAnswerOrder(task.tiles, key: task.key),
            "\(context) opens in its answer order: \(task.tiles)")
    }
}
