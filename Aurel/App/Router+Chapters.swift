import Foundation

// MARK: - Router additions: setters + the chapter plan
//
// Ports of courseChapters() (Aurel.dc.html lines 1760–1771), CHAPTER_PLAN /
// NEXT_CH / ORD / FALLBACK_CH (lines 1627–1648), and the simple state setters
// the onboarding screens use.

extension AppRouter {
    // MARK: Setters used by onboarding/settings

    func setLevel(_ value: String) { level = value; persist() }
    func setCommitMinutes(_ value: Int) { commit = value; persist() }
    func setRemindAt(_ value: String) { remindAt = value; persist() }
    func setThemeMode(_ value: Int) { themeMode = value; persist() }
    func setTypeStep(_ value: Int) { typeStep = value; persist() }
}

/// The A1 map, verbatim from 03_A1_foundation/A1_COURSE_OVERVIEW.md: three
/// arcs, 12 chapters, 42 lessons. Chapters 1–3 are authored; 4–12 planned.
enum ChapterPlan {
    struct Entry: Sendable, Hashable {
        let n: Int
        let arc: String
        let name: String
        let kind: String   // "new" | "review"
        let lessons: Int
    }

    static let all: [Entry] = [
        Entry(n: 1, arc: "Meet and connect", name: "Hello! My Name Is Alex", kind: "new", lessons: 4),
        Entry(n: 2, arc: "Meet and connect", name: "Spell It and Share Your Details", kind: "new", lessons: 4),
        Entry(n: 3, arc: "Meet and connect", name: "Where Are You From?", kind: "new", lessons: 3),
        Entry(n: 4, arc: "Meet and connect", name: "Checkpoint Review 1: Welcome-Day Mission", kind: "review", lessons: 3),
        Entry(n: 5, arc: "People, home, daily life", name: "My Family and the People I Know", kind: "new", lessons: 3),
        Entry(n: 6, arc: "People, home, daily life", name: "At Home: Rooms, Things, and Where They Are", kind: "new", lessons: 3),
        Entry(n: 7, arc: "People, home, daily life", name: "My Day: Routines, Days, and Time", kind: "new", lessons: 4),
        Entry(n: 8, arc: "People, home, daily life", name: "Checkpoint Review 2: A Visit and a Busy Day", kind: "review", lessons: 3),
        Entry(n: 9, arc: "Food, town, social plans", name: "At the Café: Food, Drinks, and Prices", kind: "new", lessons: 3),
        Entry(n: 10, arc: "Food, town, social plans", name: "Around Town: Places, Transport, and Directions", kind: "new", lessons: 3),
        Entry(n: 11, arc: "Food, town, social plans", name: "What Are You Doing? Weather and Free-Time Plans", kind: "new", lessons: 3),
        Entry(n: 12, arc: "Food, town, social plans", name: "Checkpoint Review 3: A Day in Town", kind: "review", lessons: 3),
    ]

    static let ordinals = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve"]
}

extension AppRouter {
    /// The chapter cards the shell renders (courseChapters()). Falls back to
    /// FALLBACK_CH when no bank loaded.
    struct ChapterHeader: Sendable, Hashable {
        let no: String
        let name: String
        let level: String
        let band: String
        let count: Int
        let lessons: [String]
        let metas: [String]
        let promise: String
        let nextNo: String
        let nextName: String
    }

    var chapterHeaders: [ChapterHeader] {
        let chs = course.chapters
        if chs.isEmpty {
            return [ChapterHeader(
                no: "Chapter One", name: "Hello! My Name Is Alex", level: "A1 · Foundation", band: "A1", count: 4,
                lessons: ["Chapter data not loaded"],
                metas: ["load course-c1.js, course-c2.js, course-c3.js"],
                promise: "the chapter banks are not loaded.",
                nextNo: "Chapter Two", nextName: "Spell It and Share Your Details"
            )]
        }
        return chs.enumerated().map { i, c in
            ChapterHeader(
                no: "Chapter \(ChapterPlan.ordinals.indices.contains(i) ? ChapterPlan.ordinals[i] : "\(i + 1)")",
                name: c.title,
                level: "A1 · Foundation",
                band: "A1",
                count: c.lessons.count,
                lessons: c.lessons.map(\.title) + ["Chapter complete"],
                metas: c.lessons.map { "\($0.screens.count) screens · \($0.time)" } + ["the chapter map"],
                promise: course.promise(for: c),
                nextNo: i + 1 < ChapterPlan.all.count ? "Chapter \(ChapterPlan.ordinals[i + 1])" : "",
                nextName: i + 1 < ChapterPlan.all.count ? ChapterPlan.all[i + 1].name : ""
            )
        }
    }

    var chapterHeader: ChapterHeader {
        let headers = chapterHeaders
        return headers.indices.contains(chapterIdx) ? headers[chapterIdx] : headers[0]
    }
}
