import XCTest

@testable import Aurel

@MainActor
final class PH01FoundationTests: XCTestCase {
    private let store = CourseDecodingTests.store

    func testAuthoredInventoryHasOneFixtureForEveryKind() {
        let authored = Set(store.flat.map(\.screen.kind))
        let expected = Set(ScreenKind.authoredCases)
        XCTAssertEqual(authored, expected)
        XCTAssertEqual(expected.count, 29)
        XCTAssertEqual(store.rendererFixtures.count, 29)
        XCTAssertEqual(Set(store.rendererFixtures.map(\.kind)), expected)
        XCTAssertTrue(store.rendererFixtures.allSatisfy { $0.position >= 0 })
    }

    func testEveryRendererFamilyHasAuthoredCoverage() {
        let covered = Set(store.rendererFixtures.map(\.family))
        let expected = Set(RendererFamily.allCases).subtracting([.unknown])
        XCTAssertEqual(covered, expected)
    }

    func testLessonFixturesMatchTheCurrentCourse() {
        XCTAssertEqual(store.lessonFixtures.count, 14)
        XCTAssertEqual(store.lessonFixtures.map(\.screenCount).reduce(0, +), 131)
        // C1-L1 opens on S02 (hook): S01 promise is an authoring-only page and
        // `participatesInLessonFlow` deliberately skips it.
        XCTAssertEqual(store.lessonFixtures.first?.position, 1)
        XCTAssertEqual(store.lessonFixtures.last?.chapterID, "A1-C04")
    }

    func testLearnerTitlesNeverFallBackToAuthoringMetadata() {
        for entry in store.flat {
            XCTAssertTrue(
                CourseTextContract.isLearnerFacing(entry.screen.learnerTitle),
                "unsafe title at \(entry.chapter.id)/\(entry.lesson.id)/\(entry.screen.id)")
            XCTAssertFalse(entry.screen.learnerTitle.isEmpty)
            XCTAssertNotNil(entry.screen.displayTitle)
            XCTAssertNotNil(entry.screen.debug.legacyLabel)
        }
    }

    func testCurrentAndMigratedScreenSchemasDecodeTogether() throws {
        let legacy = Data(
            #"{"id":"S01","type":"promise","label":"Can-do promise","step":"STEP 1","tip":"implementation note","assets":["A1-C01-ILL001"]}"#
                .utf8)
        let migrated = Data(
            #"{"id":"S01","type":"promise","displayTitle":"What you will learn","outcome":"Greet someone confidently","duration":"About one minute","instruction":"Tap to continue","label":"internal legacy title"}"#
                .utf8)

        let oldScreen = try JSONDecoder().decode(CourseScreen.self, from: legacy)
        XCTAssertEqual(oldScreen.learnerTitle, ScreenKind.promise.defaultDisplayTitle)
        XCTAssertEqual(oldScreen.debug.legacyLabel, "Can-do promise")
        XCTAssertEqual(oldScreen.debug.assetIDs, ["A1-C01-ILL001"])

        let newScreen = try JSONDecoder().decode(CourseScreen.self, from: migrated)
        XCTAssertEqual(newScreen.learnerTitle, "What you will learn")
        XCTAssertEqual(newScreen.learnerOutcome, "Greet someone confidently")
        XCTAssertEqual(newScreen.learnerDuration, "About one minute")
        XCTAssertEqual(newScreen.learnerInstruction, "Tap to continue")
    }

    func testForbiddenReleaseCopyIsRejected() {
        for token in [
            "A1-C03-RP001", "S27–S28", "the course dependency graph",
            "production-ready today", "screen placeholder", "prototype fixture",
            "Authored texts", "Every screen follows this", "the course production rule",
        ] {
            XCTAssertNil(CourseTextContract.learnerText(token), token)
        }
        XCTAssertEqual(
            CourseTextContract.learnerText("Listen and choose the best answer."),
            "Listen and choose the best answer.")
        XCTAssertEqual(
            CourseTextContract.learnerText("5 map cards (ILL003–007) ↔ 5 country words"),
            "5 map cards ↔ 5 country words")
    }

    func testNormalizedPracticeCopyIsLearnerFacingAcrossTheCourse() {
        for (position, entry) in store.flat.enumerated() {
            let model = PlayerModel(course: store, start: position)
            for item in model.items {
                let values =
                    [item.instr, item.ok, item.no, item.word, item.prompt]
                    .compactMap { $0 }
                    + (item.hints ?? [])
                    + item.opts.compactMap(\.text)
                    + item.opts.compactMap { $0.ill?.alt }
                for value in values where !value.isEmpty {
                    XCTAssertTrue(
                        CourseTextContract.isLearnerFacing(value),
                        "unsafe practice copy at \(entry.chapter.id)/\(entry.lesson.id)/\(entry.screen.id)/\(item.id): \(value)"
                    )
                }
            }
        }
    }

    func testEveryAuthoredTileKeyHasADeterministicIndexPath() {
        for (position, entry) in store.flat.enumerated() {
            let model = PlayerModel(course: store, start: position)
            for (itemIndex, item) in model.items.enumerated() where item.kind == "order" {
                model.i = itemIndex
                assertSolvable(
                    tiles: model.tileTask.tiles, key: model.tileTask.key,
                    context: "\(entry.chapter.id)/\(entry.lesson.id)/\(entry.screen.id)/\(item.id)")
            }

            switch entry.screen.payload {
            case .tiles(let payload):
                for task in payload.tasks ?? [] {
                    assertSolvable(
                        task: task,
                        context:
                            "\(entry.chapter.id)/\(entry.lesson.id)/\(entry.screen.id)/\(task.id)")
                }
            case .order(let payload):
                for task in payload.tasks ?? [] {
                    assertSolvable(
                        task: task,
                        context:
                            "\(entry.chapter.id)/\(entry.lesson.id)/\(entry.screen.id)/\(task.id)")
                }
            case .emailAssembly(let payload):
                assertSolvable(
                    tiles: payload.tiles ?? [], key: payload.key ?? [],
                    context: "\(entry.chapter.id)/\(entry.lesson.id)/\(entry.screen.id)")
            default:
                break
            }
        }
    }

    func testSemanticComponentRolesAreStable() {
        XCTAssertEqual(
            AUSurfaceRole.allCases.map(\.rawValue),
            [
                "canvas", "section", "task", "selectedTask", "insetInfo", "modal",
            ])
        XCTAssertEqual(
            AUActionRole.allCases.map(\.rawValue),
            [
                "primary", "secondary", "text", "destructive",
            ])
    }

    func testEveryStructuredPracticeItemHasACompletionModel() {
        for (position, entry) in store.flat.enumerated() {
            let model = PlayerModel(course: store, start: position)
            for item in model.items where item.kind == "pairs" || item.kind == "sort" {
                XCTAssertFalse(
                    item.matches.isEmpty,
                    "missing structured controls at \(entry.chapter.id)/\(entry.lesson.id)/\(entry.screen.id)/\(item.id)"
                )
                XCTAssertTrue(item.matches.allSatisfy { !$0.cue.isEmpty && !$0.answer.isEmpty })
            }
        }
    }

    func testEveryNormalizedPracticeItemExposesAnInteraction() {
        for (position, entry) in store.flat.enumerated() {
            let model = PlayerModel(course: store, start: position)
            for item in model.items {
                let interactive: Bool
                switch item.kind {
                case "speak": interactive = !(item.word ?? "").isEmpty
                case "order":
                    interactive = !item.tiles.isEmpty && !(item.key?.sequence ?? []).isEmpty
                case "pairs", "sort": interactive = !item.matches.isEmpty
                default: interactive = !item.opts.isEmpty
                }
                XCTAssertTrue(
                    interactive,
                    "no interaction at \(entry.chapter.id)/\(entry.lesson.id)/\(entry.screen.id)/\(item.id)"
                )
            }
        }
    }

    private func assertSolvable(
        tiles: [String], key: [String], context: String,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        XCTAssertFalse(tiles.isEmpty, "\(context): no tiles", file: file, line: line)
        XCTAssertFalse(key.isEmpty, "\(context): no key", file: file, line: line)
        XCTAssertGreaterThanOrEqual(
            tiles.count, key.count, "\(context): key length", file: file, line: line)
        var used: Set<Int> = []
        for word in key {
            guard
                let index = tiles.indices.first(where: {
                    !used.contains($0) && PlayerModel.tileMatches(tiles[$0], key: word)
                })
            else {
                XCTFail("\(context): no unused tile for \(word)", file: file, line: line)
                return
            }
            used.insert(index)
        }
        XCTAssertEqual(used.count, key.count, "\(context): incomplete path", file: file, line: line)
    }

    private func assertSolvable(
        task: TileTask, context: String,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        if let options = task.opts, let single = task.key?.single {
            let answers = options.filter { $0.id == single || $0.text == single }
            XCTAssertEqual(
                answers.count, 1, "\(context): ambiguous choice key", file: file, line: line)
            XCTAssertNotNil(
                answers.first?.text.learnerFacing, "\(context): hidden answer", file: file,
                line: line)
            return
        }
        assertSolvable(
            tiles: task.tiles ?? [], key: task.key?.sequence ?? [],
            context: context, file: file, line: line)
    }
}
