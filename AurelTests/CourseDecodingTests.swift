import XCTest

@testable import Aurel

/// Pins the exported course JSON against the authored banks.
/// Bank headers (design/course-c*.js) declare: C1 4 lessons · 122 practice
/// items + 22 quiz; the export summary declares 40/43/34 screens. The C3
/// closer (S29–S32) is transcribed from A1_C03_L03_LESSON.md by the exporter:
/// quiz Form A with 32 items, then results/remediation/reviewPlan/chapterMap.
final class CourseDecodingTests: XCTestCase {
    static let store: CourseStore = {
        guard
            let url = Bundle(for: CourseDecodingTests.self).url(
                forResource: "a1-course", withExtension: "json")
                ?? Bundle.main.url(forResource: "a1-course", withExtension: "json")
        else {
            fatalError("a1-course.json missing from test bundle")
        }
        let data = try! Data(contentsOf: url)
        let chapters = try! JSONDecoder().decode([CourseChapter].self, from: data)
        return CourseStore(chapters: chapters)
    }()

    func testThreeChaptersDecode() {
        XCTAssertEqual(Self.store.chapters.map(\.id), ["A1-C01", "A1-C02", "A1-C03"])
        XCTAssertEqual(
            Self.store.chapters.map(\.title),
            [
                "Hello! My Name Is Alex",
                "Spell It and Share Your Details",
                "Where Are You From?",
            ])
        XCTAssertEqual(Self.store.chapters.map(\.n), [1, 2, 3])
    }

    func testLessonCounts() {
        XCTAssertEqual(Self.store.chapters.map { $0.lessons.count }, [4, 4, 3])
        XCTAssertEqual(
            Self.store.chapters[0].lessons.map(\.title),
            ["Say Hello", "You and Your Name", "A Real First Meeting", "The Welcome Mission"])
    }

    func testScreenCounts() {
        XCTAssertEqual(
            Self.store.chapters.map { ch in ch.lessons.reduce(0) { $0 + $1.screens.count } },
            [40, 43, 34])
        XCTAssertEqual(Self.store.flat.count, 117)
        // The C3 chapter quiz replaced the four pending placeholders (S29–S32)
        // with six authored screens; no `pending` screen remains anywhere.
        XCTAssertFalse(Self.store.flat.contains { $0.screen.kind == .pending })
        let c3 = Self.store.chapters[2].lessons[2]
        XCTAssertEqual(
            c3.screens.map(\.id),
            ["S23", "S24", "S25", "S26", "S27", "S28", "S29", "S29a", "S30", "S30a", "S31", "S32"])
        XCTAssertEqual(
            c3.screens.map(\.kind),
            [
                .reading, .tiles, .testlet, .practice, .roleplay, .missionBrief,
                .quizIntro, .quiz, .results, .remediation, .reviewPlan, .chapterMap,
            ])
    }

    func testEveryScreenDecodesToATypedPayload() {
        for f in Self.store.flat {
            if case .unknown = f.screen.payload {
                XCTFail("unhandled screen type at \(f.chapter.id) \(f.lesson.id) \(f.screen.id)")
            }
        }
    }

    func testPracticeCounts() {
        // Bank headers: C1 = 122 practice items + 22 quiz Form A; every chapter
        // of C1–C3 delivered 122/122 (governance QA_STATUS). C3's chapter quiz
        // (transcribed by the exporter from A1_C03_L03_LESSON.md) adds 32 items.
        let items = Self.store.allPracticeItems.count
        XCTAssertGreaterThanOrEqual(
            items, 366, "expected ≥ 122 items per chapter across 3 chapters, got \(items)")
        let quizItems = Self.store.flat.filter {
            if case .quiz = $0.screen.payload { true } else { false }
        }
        .compactMap { f -> Int? in
            if case .quiz(let q) = f.screen.payload { return q.items?.count }
            return nil
        }
        XCTAssertEqual(quizItems.count, 3, "three quiz screens across the course")
        XCTAssertTrue(quizItems.contains(22), "C1 quiz Form A has 22 items; got \(quizItems)")
        XCTAssertTrue(quizItems.contains(26), "C2 quiz Form A has 26 items; got \(quizItems)")
        XCTAssertTrue(quizItems.contains(32), "C3 quiz Form A has 32 items; got \(quizItems)")
        // The C3 quiz bank is the authored 32 records: L5 · N5 · V5 · G6 ·
        // LS5 · RD4 · CN2, cumulative share 8 of 32.
        XCTAssertEqual(Set(quizItems), [22, 26, 32])
    }

    /// Three C3 quiz items pinned verbatim against A1_C03_L03_LESSON.md —
    /// item 1 (A1-C03-QZ-L001, listening), item 12 (A1-C03-QZ-V002, vocabulary
    /// with the ILL020 art), and item 32 (A1-C03-QZ-CN002, culture & inclusion).
    func testC3QuizItemsVerbatim() {
        let quiz = Self.store.flat
            .filter { $0.chapter.id == "A1-C03" }
            .compactMap { f -> QuizScreen? in
                if case .quiz(let q) = f.screen.payload { return q } else { return nil }
            }
        XCTAssertEqual(quiz.count, 1, "exactly one C3 quiz screen")
        guard let items = quiz.first?.items else { return XCTFail("C3 quiz has no items") }
        XCTAssertEqual(items.count, 32, "C3 quiz Form A carries all 32 authored items")
        XCTAssertEqual(items.first?.id, "A1-C03-QZ-L001")
        XCTAssertEqual(items.last?.id, "A1-C03-QZ-CN002")

        func item(_ id: String) -> PracticeItem {
            guard let it = items.first(where: { $0.id == id }) else {
                XCTFail("missing C3 quiz item \(id)")
                return items[0]
            }
            return it
        }

        // §10.8 record A1-C03-QZ-L001 — listening_detail, audio AUD062.
        let l001 = item("A1-C03-QZ-L001")
        XCTAssertEqual(l001.instr, "Listen. Choose.")
        XCTAssertEqual(l001.icon, "ear")
        XCTAssertEqual(l001.aud, "AUD062")
        XCTAssertEqual(l001.prompt, "Where is Maya from?")
        XCTAssertEqual(l001.opts?.map(\.id), ["A", "B", "C"])
        XCTAssertEqual(l001.opts?.compactMap(\.text), ["Egypt", "Peru", "Mexico"])
        XCTAssertEqual(l001.key?.single, "A")
        XCTAssertEqual(l001.ok, "Egypt.")
        XCTAssertEqual(l001.no, "Listen for 'I'm from …'.")

        // §10.8 record A1-C03-QZ-V002 — image_to_word over the ILL020 card.
        let v002 = item("A1-C03-QZ-V002")
        XCTAssertEqual(v002.instr, "Look. Choose.")
        XCTAssertEqual(v002.icon, "eye")
        XCTAssertEqual(v002.ill?.id, "A1-C03-ILL020")
        XCTAssertEqual(
            v002.ill?.alt,
            "Leo, tall with curly auburn hair and beard, blue apron over striped shirt, at a café kitchen counter"
        )
        XCTAssertEqual(v002.prompt, "Leo is a ____.")
        XCTAssertEqual(v002.opts?.compactMap(\.text), ["cook", "driver", "doctor"])
        XCTAssertEqual(v002.key?.single, "A")
        XCTAssertEqual(v002.ok, "A cook!")
        XCTAssertEqual(v002.no, "The café kitchen says cook.")

        // §10.8 record A1-C03-QZ-CN002 — fact_choice, the last authored item.
        let cn002 = item("A1-C03-QZ-CN002")
        XCTAssertEqual(cn002.instr, "Choose.")
        XCTAssertEqual(cn002.icon, "choose")
        XCTAssertEqual(cn002.prompt, "Kenji is from Japan. Kenji speaks ____.")
        XCTAssertEqual(cn002.opts?.compactMap(\.text), ["Arabic", "French", "Japanese"])
        XCTAssertEqual(cn002.key?.single, "C")
        XCTAssertEqual(cn002.ok, "Japanese — in Japan, they speak Japanese.")
        XCTAssertEqual(cn002.no, "Japan's language is Japanese.")
    }

    /// Cumulative rule: exactly 8 of the 32 C3 quiz items are flagged —
    /// N001–N005 (C2 numbers), L005 (C1), V004 (C2 spelling), LS003 (C2 repair).
    func testC3QuizCumulativeShare() {
        guard case .quiz(let q) = Self.store.chapters[2].lessons[2].screens[7].payload,
            let items = q.items
        else {
            return XCTFail("C3 S29a is not a quiz screen with items")
        }
        let cumulative = items.filter { ($0.note ?? "").hasPrefix("retrieves ") }
        XCTAssertEqual(cumulative.count, 8, "8/32 = 25.0% cumulative share, the band ceiling")
        XCTAssertEqual(
            cumulative.map(\.id),
            [
                "A1-C03-QZ-L005", "A1-C03-QZ-N001", "A1-C03-QZ-N002", "A1-C03-QZ-N003",
                "A1-C03-QZ-N004", "A1-C03-QZ-N005", "A1-C03-QZ-V004", "A1-C03-QZ-LS003",
            ])
    }

    func testAnswerKeyShapes() {
        let singles = Self.store.allPracticeItems.filter { $0.item.key?.single != nil }
        let sequences = Self.store.allPracticeItems.filter { $0.item.key?.sequence != nil }
        XCTAssertEqual(
            singles.count + sequences.count,
            Self.store.allPracticeItems.compactMap { $0.item.key }.count)
        XCTAssertGreaterThan(singles.count, 300)
        XCTAssertGreaterThanOrEqual(sequences.count, 15)
    }

    func testVocabCardsAvailable() {
        XCTAssertGreaterThan(Self.store.allVocabCards.count, 80)
        XCTAssertEqual(Self.store.allVocabCards.first?.id, "V001")
        XCTAssertEqual(Self.store.allVocabCards.first?.w, "hello")
    }

    func testFirstPromiseScreenContent() {
        let s = Self.store.chapters[0].lessons[0].screens[0]
        XCTAssertEqual(s.id, "S01")
        guard case .promise(let p) = s.payload else { return XCTFail("S01 is not a promise") }
        XCTAssertEqual(p.newToday, "hello · goodbye · thank you · sorry")
        XCTAssertEqual(p.newTodayLabel, "New words today")
        XCTAssertEqual(p.canDos?.count, 3)
        XCTAssertEqual(p.canDos?.first, "You can say hello.")
    }
}

/// Position math — ports of Aurel.dc.html coursePosFor/courseSpot/chapterEndPos.
final class PositionMathTests: XCTestCase {
    let store = CourseDecodingTests.store

    func testCoursePosFor() {
        // C1-L1 starts at 0; C1-L2 starts after L1's screens.
        XCTAssertEqual(store.coursePos(chapterIdx: 0, lessonIdx: 0), 0)
        let l1 = store.chapters[0].lessons[0].screens.count
        XCTAssertEqual(store.coursePos(chapterIdx: 0, lessonIdx: 1), l1)
        // C2 starts after all of C1.
        let c1Total = store.chapters[0].lessons.reduce(0) { $0 + $1.screens.count }
        XCTAssertEqual(store.coursePos(chapterIdx: 1, lessonIdx: 0), c1Total)
        XCTAssertEqual(store.coursePos(chapterIdx: 2, lessonIdx: 0), c1Total + 43)
    }

    func testCourseSpot() {
        XCTAssertEqual(store.courseSpot(0).title, "Say Hello")
        XCTAssertEqual(store.courseSpot(0).of, store.chapters[0].lessons[0].screens.count)
        let c1Total = store.chapters[0].lessons.reduce(0) { $0 + $1.screens.count }
        let spot = store.courseSpot(c1Total)
        XCTAssertEqual(spot.title, store.chapters[1].lessons[0].title)
        XCTAssertEqual(spot.at, 1)
    }

    func testChapterEndPos() {
        let c1Total = store.chapters[0].lessons.reduce(0) { $0 + $1.screens.count }
        XCTAssertEqual(store.chapterEndPos(0), c1Total - 1)
        XCTAssertEqual(store.chapterEndPos(1), c1Total + 43 - 1)
        // The screen at the chapter end position is the chapter map.
        let end = store.screen(at: store.chapterEndPos(0))
        if case .chapterMap = end?.screen.payload {
        } else {
            XCTFail("last C1 screen is not chapterMap")
        }
    }

    func testPromiseForChapter() {
        let text = store.promise(for: store.chapters[0])
        XCTAssertEqual(text, "say hello, say goodbye, and say thank you.")
    }
}
