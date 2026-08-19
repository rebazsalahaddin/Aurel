import Foundation

/// Loads the bundled course and provides the flat-position math the player and
/// shell navigate by. Ports of `coursePosFor` / `courseSpot` / `chapterEndPos`
/// from design/Aurel.dc.html lines 1774–1815.
struct CourseStore: Sendable {
    let chapters: [CourseChapter]

    /// Flattened navigation list — every authored screen in book order.
    let flat: [FlatScreen]

    struct FlatScreen: Sendable, Hashable {
        let chapterIdx: Int
        let lessonIdx: Int
        let screenIdx: Int
        let chapter: CourseChapter
        let lesson: CourseLesson
        let screen: CourseScreen
    }

    // MARK: Loading

    static func load(bundle: Bundle = .main) throws -> CourseStore {
        let url = bundle.url(forResource: "a1-course", withExtension: "json")
            ?? bundle.url(forResource: "a1-course", withExtension: "json", subdirectory: "Course")
            ?? bundle.url(forResource: "a1-course", withExtension: "json", subdirectory: "Resources/Course")
        guard let url else { throw CourseError.missingResource }
        let data = try Data(contentsOf: url)
        let chapters = try JSONDecoder().decode([CourseChapter].self, from: data)
        return CourseStore(chapters: chapters)
    }

    enum CourseError: Error {
        case missingResource
    }

    init(chapters: [CourseChapter]) {
        self.chapters = chapters
        var flat: [FlatScreen] = []
        for (x, ch) in chapters.enumerated() {
            for (y, lesson) in ch.lessons.enumerated() {
                for (z, screen) in lesson.screens.enumerated() {
                    flat.append(FlatScreen(chapterIdx: x, lessonIdx: y, screenIdx: z, chapter: ch, lesson: lesson, screen: screen))
                }
            }
        }
        self.flat = flat
    }

    // MARK: Position math (ported verbatim)

    /// Index of a lesson's first screen inside the flat course list.
    func coursePos(chapterIdx: Int, lessonIdx: Int) -> Int {
        var n = 0
        for x in 0..<chapters.count {
            for y in 0..<chapters[x].lessons.count {
                if x == chapterIdx && y == lessonIdx { return n }
                n += chapters[x].lessons[y].screens.count
            }
        }
        return 0
    }

    /// Which screen of which lesson the player is on — for the resume card.
    func courseSpot(_ pos: Int) -> (title: String, at: Int, of: Int) {
        var n = 0
        for ch in chapters {
            for lesson in ch.lessons {
                let len = lesson.screens.count
                if pos < n + len { return (lesson.title, pos - n + 1, len) }
                n += len
            }
        }
        return ("", 1, 1)
    }

    /// The chapter map is the chapter's last authored screen.
    func chapterEndPos(_ chapterIdx: Int) -> Int {
        guard chapters.indices.contains(chapterIdx) else { return 0 }
        let last = chapters[chapterIdx].lessons.count - 1
        return coursePos(chapterIdx: chapterIdx, lessonIdx: last) + chapters[chapterIdx].lessons[last].screens.count - 1
    }

    func screen(at pos: Int) -> FlatScreen? {
        flat.indices.contains(pos) ? flat[pos] : nil
    }

    // MARK: Derived helpers

    /// "You can say hello, give your name, and ask how someone is." — from S01's
    /// can-do lines, never the manifest mission (ported `promiseFor`).
    func promise(for chapter: CourseChapter) -> String {
        guard let first = chapter.lessons.first?.screens.first else { return "" }
        if case .promise(let p) = first.payload, let canDos = p.canDos {
            let lines = canDos.map {
                $0.replacingOccurrences(of: "^You can ", with: "", options: .regularExpression)
                    .replacingOccurrences(of: "\\.$", with: "", options: .regularExpression)
            }
            if lines.isEmpty { return Array(chapter.canDos.prefix(2)).joined(separator: "; ") }
            if lines.count == 1 { return lines[0] + "." }
            return lines.dropLast().joined(separator: ", ") + ", and " + lines.last! + "."
        }
        return Array(chapter.canDos.prefix(2)).joined(separator: "; ")
    }

    /// Every scored practice item in the course, with its location — the
    /// quick-practice and review banks draw from this.
    struct BankEntry: Sendable, Hashable {
        let item: PracticeItem
        let chapterIdx: Int
        let lessonIdx: Int
        let screenIdx: Int
    }

    var allPracticeItems: [BankEntry] {
        var out: [BankEntry] = []
        for f in flat {
            let items: [PracticeItem]?
            switch f.screen.payload {
            case .practice(let p): items = p.items
            case .quiz(let q): items = q.items
            case .reading(let r): items = r.items
            case .testlet(let t): items = t.items
            default: items = nil
            }
            for item in items ?? [] {
                out.append(BankEntry(item: item, chapterIdx: f.chapterIdx, lessonIdx: f.lessonIdx, screenIdx: f.screenIdx))
            }
        }
        return out
    }

    /// Every vocabulary card in the course (for galleries, quick practice, streak moments).
    var allVocabCards: [VocabCard] {
        var out: [VocabCard] = []
        for f in flat {
            switch f.screen.payload {
            case .cards(let c): out.append(contentsOf: c.cards ?? [])
            case .warmup(let w): out.append(contentsOf: w.gallery ?? [])
            case .review(let r): out.append(contentsOf: r.gallery ?? [])
            default: break
            }
        }
        return out
    }
}
