import XCTest

@testable import Aurel

/// Pins the exported course JSON against the authored banks.
/// Bank headers (design/course-c*.js) declare: C1 4 lessons · 122 practice
/// items + 22 quiz; the export summary declares 40/43/32 screens.
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
            [40, 43, 32])
        XCTAssertEqual(Self.store.flat.count, 115)
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
        // of C1–C3 delivered 122/122 (governance QA_STATUS).
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
        XCTAssertEqual(quizItems.count, 2, "two quiz screens across the course")
        XCTAssertTrue(quizItems.contains(22), "quiz Form A has 22 items; got \(quizItems)")
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
