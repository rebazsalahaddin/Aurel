import XCTest

@testable import Aurel

/// Guards listen-then-answer integrity: Listen speaks a short stimulus that
/// matches the choices, never the keyed answer of a reply item, and never a
/// repeated full conversation.
@MainActor
final class ListeningSanityTests: XCTestCase {
    private var store: CourseStore { CourseDecodingTests.store }

    private func model(chapter: String, screen: String) throws -> PlayerModel {
        let pos = try XCTUnwrap(
            store.flat.firstIndex {
                $0.chapter.id == chapter && $0.screen.id == screen
            },
            "\(chapter)/\(screen) missing")
        return PlayerModel(course: store, start: pos)
    }

    func testSaidRoundTripOnReplyItems() throws {
        let m = try model(chapter: "A1-C01", screen: "S25")
        let item = try XCTUnwrap(m.items.first { $0.id == "PR-CV007" })
        m.i = try XCTUnwrap(m.items.firstIndex { $0.id == "PR-CV007" })
        XCTAssertEqual(item.said?.sp, "LEO")
        XCTAssertEqual(item.said?.t, "My name is Leo.")
        XCTAssertEqual(m.speakTextForItem, "My name is Leo.")
        XCTAssertNotEqual(m.speakTextForItem, "Nice to meet you, Leo!")
    }

    func testScreenshotReplyItemsUseShortRelevantCues() throws {
        let m = try model(chapter: "A1-C01", screen: "S25")

        m.i = try XCTUnwrap(m.items.firstIndex { $0.id == "PR-CV007" })
        XCTAssertEqual(m.items[m.i].aud, "AUD045")
        XCTAssertEqual(m.speakTextForItem, "My name is Leo.")

        m.i = try XCTUnwrap(m.items.firstIndex { $0.id == "PR-CV008" })
        XCTAssertEqual(m.items[m.i].aud, "AUD032")
        XCTAssertEqual(m.speakTextForItem, "How are you?")
        let reply = m.items[m.i].opts.first { m.items[m.i].isKey($0) }?.text
        XCTAssertEqual(reply, "I'm okay, thank you!")
    }

    func testQuizHowAreYouUsesSaidNotTheAnswer() throws {
        let m = try model(chapter: "A1-C01", screen: "S33")
        m.i = try XCTUnwrap(m.items.firstIndex { $0.id == "QZ-CN001" })
        XCTAssertEqual(m.speakTextForItem, "How are you?")
        XCTAssertNotEqual(m.speakTextForItem, "I'm fine, thank you! And you?")
    }

    func testGistItemPlaysTwoVoicesNotTheFullMeeting() throws {
        let m = try model(chapter: "A1-C01", screen: "S21")
        m.i = try XCTUnwrap(m.items.firstIndex { $0.id == "PR-LS001" })
        let cue = try XCTUnwrap(m.speakTextForItem)
        XCTAssertTrue(cue.localizedCaseInsensitiveContains("Nina"))
        XCTAssertTrue(cue.localizedCaseInsensitiveContains("Maya"))
        XCTAssertFalse(cue.localizedCaseInsensitiveContains("Excuse me"))
        XCTAssertLessThanOrEqual(wordCount(cue), 40)
    }

    func testQuotedPromptIsTheListenCue() throws {
        XCTAssertEqual(
            ListenCue.quoted(from: "You hear: “I'm Leo.”"),
            "I'm Leo.")
        XCTAssertEqual(
            ListenCue.quoted(from: "Who says ‘Excuse me’?"),
            "Excuse me")
    }

    func testWhoSaysPlaysTheTurnNotOnlyTheQuotedWords() throws {
        let m = try model(chapter: "A1-C01", screen: "S33")
        m.i = try XCTUnwrap(m.items.firstIndex { $0.id == "QZ-LS003" })
        let cue = try XCTUnwrap(m.speakTextForItem)
        XCTAssertTrue(cue.localizedCaseInsensitiveContains("Excuse me"))
        XCTAssertTrue(cue.localizedCaseInsensitiveContains("Maya"))
    }

    func testImageMatchListenSpeaksTheHeardWord() throws {
        let m = try model(chapter: "A1-C01", screen: "S05")
        m.i = try XCTUnwrap(m.items.firstIndex { $0.id == "PR-V006" })
        XCTAssertEqual(m.speakTextForItem, "good morning")
        XCTAssertFalse(m.items[m.i].bubbles)
    }

    func testEverySaidItemSpeaksTheSaidLine() throws {
        var count = 0
        for position in store.flat.indices {
            let m = PlayerModel(course: store, start: position)
            for index in m.items.indices where m.items[index].said != nil {
                count += 1
                m.i = index
                XCTAssertEqual(
                    m.speakTextForItem,
                    m.items[index].said?.t,
                    "\(store.flat[position].chapter.id)/"
                        + "\(store.flat[position].screen.id)/\(m.items[index].id)"
                )
            }
        }
        XCTAssertGreaterThan(count, 20)
    }

    func testListenThenAnswerCuesStayShort() throws {
        var failures: [String] = []
        var count = 0
        for position in store.flat.indices {
            let flat = store.flat[position]
            switch flat.screen.kind {
            case .practice, .quiz, .testlet, .warmup, .reading:
                break
            default:
                continue
            }
            let m = PlayerModel(course: store, start: position)
            for index in m.items.indices where m.items[index].aud != nil {
                let item = m.items[index]
                if ["order", "speak", "pair", "pairs", "sort"].contains(item.kind ?? "") {
                    continue
                }
                count += 1
                m.i = index
                guard let cue = m.speakTextForItem,
                    !cue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                else {
                    failures.append(
                        "\(flat.chapter.id)/\(flat.screen.id)/\(item.id): silent Listen")
                    continue
                }
                let words = wordCount(cue)
                let lines = item.playLines?.count ?? 1
                if words > 40 || lines > 4 {
                    failures.append(
                        "\(flat.chapter.id)/\(flat.screen.id)/\(item.id): "
                            + "\(words) words / \(lines) lines — “\(cue)”"
                    )
                }
            }
        }
        XCTAssertGreaterThan(count, 80)
        XCTAssertEqual(failures, [], failures.joined(separator: "\n"))
    }

    func testAdjacentListenItemsDoNotReplayTheSameFullDialogue() throws {
        var failures: [String] = []
        for position in store.flat.indices {
            let flat = store.flat[position]
            guard flat.screen.kind == .practice || flat.screen.kind == .testlet
                || flat.screen.kind == .quiz
            else { continue }
            let m = PlayerModel(course: store, start: position)
            var previous: (aud: String, cue: String)?
            for index in m.items.indices where m.items[index].aud != nil {
                m.i = index
                let item = m.items[index]
                guard let cue = m.speakTextForItem, let aud = item.aud else { continue }
                let lines = store.listenStimulus.lines(chapterID: flat.chapter.id, aud: aud)
                if lines.count >= 5 {
                    let full = lines.map(\.text).joined(separator: " ")
                    if heard(cue) == heard(full) {
                        failures.append(
                            "\(flat.chapter.id)/\(flat.screen.id)/\(item.id) "
                                + "speaks the full \(aud) take"
                        )
                    }
                    if let previous, previous.aud == aud, heard(previous.cue) == heard(full),
                        heard(cue) == heard(full)
                    {
                        failures.append(
                            "\(flat.chapter.id)/\(flat.screen.id)/\(item.id) "
                                + "repeats full \(aud) after the previous item"
                        )
                    }
                }
                previous = (aud, cue)
            }
        }
        XCTAssertEqual(failures, [], failures.joined(separator: "\n"))
    }

    func testListenCueSharesAContentWordWithTheTask() throws {
        var failures: [String] = []
        var count = 0
        let stop: Set<String> = [
            "the", "a", "an", "to", "and", "or", "you", "your", "is", "are", "i", "m",
            "it", "of", "in", "on", "for", "this", "that", "what", "who", "how",
        ]
        for position in store.flat.indices {
            let flat = store.flat[position]
            switch flat.screen.kind {
            case .practice, .quiz, .testlet, .warmup:
                break
            default:
                continue
            }
            let m = PlayerModel(course: store, start: position)
            for index in m.items.indices where m.items[index].aud != nil {
                let item = m.items[index]
                guard item.opts.contains(where: { $0.text != nil }) else { continue }
                count += 1
                m.i = index
                if item.said != nil || item.playLines != nil { continue }
                guard let cue = m.speakTextForItem else { continue }
                var pool = heard(item.said?.t ?? "")
                pool += " " + heard(item.prompt ?? "")
                if let key = item.opts.first(where: { item.isKey($0) })?.text {
                    pool += " " + heard(key)
                }
                for option in item.opts {
                    pool += " " + heard(option.text ?? "")
                }
                let cueWords = Set(heard(cue).split(separator: " ").map(String.init))
                    .subtracting(stop)
                let poolWords = Set(pool.split(separator: " ").map(String.init)).subtracting(stop)
                if cueWords.isEmpty { continue }
                if cueWords.isDisjoint(with: poolWords) {
                    failures.append(
                        "\(flat.chapter.id)/\(flat.screen.id)/\(item.id): "
                            + "cue “\(cue)” vs task “\(pool)”"
                    )
                }
            }
        }
        XCTAssertGreaterThan(count, 50)
        XCTAssertEqual(failures, [], failures.joined(separator: "\n"))
    }

    func testConversationPlayStillHasTheFullMeeting() throws {
        let pos = try XCTUnwrap(
            store.flat.firstIndex {
                $0.chapter.id == "A1-C01" && $0.screen.id == "S20"
            })
        guard case .conversation(let conversation) = store.flat[pos].screen.payload else {
            return XCTFail("C1-L3 S20 must stay a conversation screen")
        }
        XCTAssertEqual(conversation.turns?.count, 8)
        XCTAssertEqual(conversation.aud, "AUD043")
    }

    func testIdentificationItemsStillSpeakTheHeardWord() throws {
        let m = try model(chapter: "A1-C01", screen: "S05")
        let hello = try XCTUnwrap(
            m.items.first { $0.aud != nil && $0.opts.contains { $0.text == "hello" } })
        m.i = try XCTUnwrap(m.items.firstIndex { $0.id == hello.id })
        XCTAssertEqual(m.speakTextForItem?.lowercased(), "hello")
    }

    func testC1WarmupFramesEachSpeakTheirOwnWord() throws {
        let pos = try XCTUnwrap(
            store.flat.firstIndex {
                $0.chapter.id == "A1-C01" && $0.lesson.id == "L02" && $0.screen.id == "S10"
            })
        let m = PlayerModel(course: store, start: pos)
        let expected = ["hello", "thank you", "good evening", "bye", "sorry", "see you"]
        XCTAssertEqual(m.items.count, expected.count)
        for (index, word) in expected.enumerated() {
            m.i = index
            XCTAssertEqual(m.speakTextForItem, word, "warmup frame \(index + 1)")
        }
    }

    private func wordCount(_ text: String) -> Int {
        heard(text).split(separator: " ").count
    }

    private func heard(_ text: String) -> String {
        let folded = text.lowercased().unicodeScalars.map { scalar -> Character in
            CharacterSet.alphanumerics.contains(scalar) ? Character(scalar) : " "
        }
        return String(folded)
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}
