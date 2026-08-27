import Foundation

// MARK: - Router additions: setters + the chapter plan
//
// Ports of courseChapters() (Aurel.dc.html lines 1760–1771), CHAPTER_PLAN /
// NEXT_CH / ORD / FALLBACK_CH (lines 1627–1648), and the simple state setters
// the onboarding screens use.

extension AppRouter {
    // MARK: Setters used by onboarding/settings

    func setCommitMinutes(_ value: Int) {
        AUFeedback.selection()
        commit = value
        persist()
    }
    func setRemindAt(_ value: String) {
        AUFeedback.selection()
        remindAt = value
        persist()
    }
    func setThemeMode(_ value: Int) {
        AUFeedback.selection()
        themeMode = value
        persist()
    }
    func setTypeStep(_ value: Int) {
        AUFeedback.selection()
        typeStep = value
        persist()
    }
}

/// The A1 map, verbatim from 03_A1_foundation/A1_COURSE_OVERVIEW.md: three
/// arcs, 12 chapters, 42 lessons. Chapters 1–3 are authored; 4–12 planned.
enum ChapterPlan {
    struct Entry: Sendable, Hashable {
        let n: Int
        let arc: String
        let name: String
        let kind: String  // "new" | "review"
        let lessons: Int
    }

    static let all: [Entry] = [
        Entry(
            n: 1, arc: "Meet and connect", name: "Hello! My Name Is Alex", kind: "new", lessons: 4),
        Entry(
            n: 2, arc: "Meet and connect", name: "Spell It and Share Your Details", kind: "new",
            lessons: 4),
        Entry(n: 3, arc: "Meet and connect", name: "Where Are You From?", kind: "new", lessons: 3),
        Entry(
            n: 4, arc: "Meet and connect", name: "Checkpoint Review 1: Welcome-Day Mission",
            kind: "review", lessons: 3),
        Entry(
            n: 5, arc: "People, home, daily life", name: "My Family and the People I Know",
            kind: "new", lessons: 3),
        Entry(
            n: 6, arc: "People, home, daily life",
            name: "At Home: Rooms, Things, and Where They Are", kind: "new", lessons: 3),
        Entry(
            n: 7, arc: "People, home, daily life", name: "My Day: Routines, Days, and Time",
            kind: "new", lessons: 4),
        Entry(
            n: 8, arc: "People, home, daily life",
            name: "Checkpoint Review 2: A Visit and a Busy Day", kind: "review", lessons: 3),
        Entry(
            n: 9, arc: "Food, town, social plans", name: "At the Café: Food, Drinks, and Prices",
            kind: "new", lessons: 3),
        Entry(
            n: 10, arc: "Food, town, social plans",
            name: "Around Town: Places, Transport, and Directions", kind: "new", lessons: 3),
        Entry(
            n: 11, arc: "Food, town, social plans",
            name: "What Are You Doing? Weather and Free-Time Plans", kind: "new", lessons: 3),
        Entry(
            n: 12, arc: "Food, town, social plans", name: "Checkpoint Review 3: A Day in Town",
            kind: "review", lessons: 3),
    ]

    static let ordinals = [
        "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven",
        "Twelve",
    ]
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
            return [
                ChapterHeader(
                    no: "Chapter One", name: "Hello! My Name Is Alex", level: "A1 · Foundation",
                    band: "A1", count: 4,
                    lessons: ["Chapter data not loaded"],
                    metas: ["load course-c1.js, course-c2.js, course-c3.js"],
                    promise: "the chapter banks are not loaded.",
                    nextNo: "Chapter Two", nextName: "Spell It and Share Your Details"
                )
            ]
        }
        return chs.enumerated().map { i, c in
            ChapterHeader(
                no:
                    "Chapter \(ChapterPlan.ordinals.indices.contains(i) ? ChapterPlan.ordinals[i] : "\(i + 1)")",
                name: c.title,
                level: "A1 · Foundation",
                band: "A1",
                count: c.lessons.count,
                lessons: c.lessons.map(\.title) + ["Chapter complete"],
                metas: c.lessons.map { "\($0.screens.count) screens · \($0.time)" } + [
                    "the chapter map"
                ],
                promise: course.promise(for: c),
                nextNo: i + 1 < ChapterPlan.all.count
                    ? "Chapter \(ChapterPlan.ordinals[i + 1])" : "",
                nextName: i + 1 < ChapterPlan.all.count ? ChapterPlan.all[i + 1].name : ""
            )
        }
    }

    var chapterHeader: ChapterHeader {
        let headers = chapterHeaders
        return headers.indices.contains(chapterIdx) ? headers[chapterIdx] : headers[0]
    }
}

// MARK: - Chapter progression

extension AppRouter {
    /// True when every authored lesson of the chapter has a learner completion
    /// record (review-only runs don't count). Derived from LessonRecord —
    /// never stored twice — so it stays data-honest with the Progress
    /// aggregates that read the same records (§3.18).
    func chapterComplete(_ idx: Int) -> Bool {
        guard course.chapters.indices.contains(idx) else { return false }
        let done = Set(
            lessonRecords()
                .filter { !$0.wasReview && $0.chapterIdx == idx }
                .map(\.lessonIdx))
        return done.count >= course.chapters[idx].lessons.count
    }

    /// Moves the shell onto another authored chapter — the learner just
    /// finished the current one, or opened the next-chapter card. Re-bases the
    /// per-chapter path math so the new chapter's first stop reads as the
    /// learner's next stop (pathAt/currentPathIndex restart at 0 while
    /// `lessonsDone` keeps its course-wide total), and persists through the
    /// existing LearnerProfile mirror (`chapterIdx`/`baseLessons` are durable
    /// fields, restored by load(from:)).
    func goToChapter(_ idx: Int) {
        guard course.chapters.indices.contains(idx), idx != chapterIdx else { return }
        AUFeedback.selection()
        chapterIdx = idx
        baseLessons = lessonsDone
        basePos = 0
        courseLesson = 0
        coursePos = course.lessonStartPos(chapterIdx: idx, lessonIdx: 0)
        persist()
    }

    /// Auto-advance after a lesson lands: when that lesson was the chapter's
    /// last missing one, home reveals the next authored chapter (its header,
    /// path, and recommended card follow `chapterIdx`) instead of stranding
    /// the learner in a finished one. Idempotent — re-running never skips past
    /// an incomplete chapter — and clamps at the last authored chapter, where
    /// further completions simply stay put.
    func advanceToNextChapterIfComplete() {
        guard chapterComplete(chapterIdx),
            course.chapters.indices.contains(chapterIdx + 1)
        else { return }
        goToChapter(chapterIdx + 1)
    }

    /// The next-chapter card's reachable target: the authored chapter after
    /// the current one, when its content actually ships in the bundle. Nil
    /// for the last authored chapter and for plan-only successors — the card
    /// keeps its paywall route in those cases.
    var nextAuthoredChapterIdx: Int? {
        let next = chapterIdx + 1
        return course.chapters.indices.contains(next) ? next : nil
    }

    /// The next-chapter card's tap. A bundled next chapter opens directly on
    /// home (goToChapter's re-base puts its first stop at the learner's
    /// position); a plan-only successor keeps the authored paywall route.
    func openNextChapter() {
        if let next = nextAuthoredChapterIdx {
            goToChapter(next)
        } else {
            nav(.paywall)
        }
    }

    /// The return card's target: the authored chapter before the current one
    /// while the shell sits past Chapter One. Nil on Chapter One — the card
    /// hides and the tap is a no-op.
    var previousAuthoredChapterIdx: Int? {
        chapterIdx > 0 ? chapterIdx - 1 : nil
    }

    /// The return card's tap. Routes through goToChapter so the earlier
    /// chapter's opener is re-based as the learner's next stop and the move
    /// persists through the same durable mirror the forward jump uses —
    /// without fabricating completion records.
    func goBackChapter() {
        guard let previous = previousAuthoredChapterIdx else { return }
        goToChapter(previous)
    }
}

// MARK: - PH-02 information architecture contracts

extension AppRouter {
    enum TopLevelSection: String, CaseIterable, Equatable, Sendable {
        case learn, practice, progress, you

        var title: String {
            switch self {
            case .learn: String(localized: "Learn")
            case .practice: String(localized: "Practice")
            case .progress: String(localized: "Progress")
            case .you: String(localized: "You")
            }
        }

        var purpose: String {
            switch self {
            case .learn: String(localized: "Today’s recommended lesson and the path ahead.")
            case .practice: String(localized: "Choose a scene, speaking, review, or story.")
            case .progress:
                String(localized: "See practice evidence and the next skill to strengthen.")
            case .you: String(localized: "Your profile, preferences, and local data.")
            }
        }
    }

    static func topLevelSection(for screen: Screen) -> TopLevelSection? {
        switch screen {
        case .home: .learn
        case .stories: .practice
        case .progress: .progress
        case .profile, .leaderboard, .settings: .you
        default: nil
        }
    }

    struct GoalFocus: Equatable, Sendable {
        let title: String
        let reason: String
        let planLine: String
    }

    var goalFocus: GoalFocus {
        switch goals.first {
        case "work":
            GoalFocus(
                title: String(localized: "Work and interviews"),
                reason: String(localized: "Your work goal puts a confident first meeting first."),
                planLine: String(
                    localized: "Start with a greeting you can use with a colleague or interviewer.")
            )
        case "travel":
            GoalFocus(
                title: String(localized: "Travel and living abroad"),
                reason: String(localized: "Your travel goal puts a useful first meeting first."),
                planLine: String(
                    localized: "Start with a greeting you can use when you arrive somewhere new."))
        case "exam":
            GoalFocus(
                title: String(localized: "Exam preparation"),
                reason: String(localized: "Your exam goal puts clear, complete answers first."),
                planLine: String(
                    localized: "Start by building a short answer with clear meaning and word order."
                ))
        case "self":
            GoalFocus(
                title: String(localized: "English for yourself"),
                reason: String(localized: "Your personal goal puts everyday conversation first."),
                planLine: String(
                    localized: "Start with a natural greeting you can reuse in conversation."))
        default:
            GoalFocus(
                title: String(localized: "Everyday English"),
                reason: String(
                    localized: "A practical first meeting is the clearest place to begin."),
                planLine: String(
                    localized: "Start with a natural greeting and a simple introduction."))
        }
    }

    struct NextAction: Equatable, Sendable {
        enum Destination: Equatable, Sendable {
            case resumeCourse
            case course(Int)
            case review
            case practice
            case scene
            case speak
        }

        let title: String
        let reason: String
        let duration: String
        let outcome: String
        let buttonTitle: String
        let destination: Destination
    }

    var currentPathIndex: Int {
        max(0, basePos + (lessonsDone - baseLessons))
    }

    /// Learn owns the single recommended task. Every state states why it is
    /// next, how long it should take, and what changes when it is done.
    var learnNextAction: NextAction {
        let chapter = chapterHeader
        if let pending {
            return NextAction(
                title: String(localized: "Resume \(pending.title)"),
                reason: String(
                    localized:
                        "You stopped at step \(pending.at) of \(pending.of), so your place is still waiting."
                ),
                duration: String(localized: "Up to \(max(1, commit)) minutes"),
                outcome: String(localized: "Continue toward: \(chapter.promise)"),
                buttonTitle: String(localized: "Resume where you stopped"),
                destination: .resumeCourse)
        }

        if dayLesson, !dayRecall, !mistakes.isEmpty {
            let count = mistakes.count
            return NextAction(
                title: count == 1
                    ? String(localized: "Catch one word")
                    : String(localized: "Catch \(count) words"),
                reason: String(
                    localized: "These are the words that need another look after today’s lesson."),
                duration: count == 1
                    ? String(localized: "About 1 minute")
                    : String(localized: "About \(min(count, 5)) minutes"),
                outcome: String(
                    localized: "A correct recall moves each word to a wider review interval."),
                buttonTitle: count == 1
                    ? String(localized: "Review one word")
                    : String(localized: "Review \(count) words"),
                destination: .review)
        }

        if dayLesson || dayRecall {
            return NextAction(
                title: String(localized: "Choose what to practise"),
                reason: String(
                    localized: "Today’s required work is complete; anything else is optional."),
                duration: String(localized: "3–10 minutes"),
                outcome: String(
                    localized: "Keep one skill active without changing today’s streak."),
                buttonTitle: String(localized: "Choose optional practice"),
                destination: .practice)
        }

        if currentPathIndex >= chapter.count {
            return NextAction(
                // The chapter's own ordinal ("Keep Chapter Four fresh") — the
                // copy used to hardcode "Chapter One" and lie the moment the
                // learner moved past it.
                title: String(localized: "Keep \(chapter.no) fresh"),
                reason: String(localized: "You completed the lessons available in this chapter."),
                duration: String(localized: "3–10 minutes"),
                outcome: String(localized: "Revisit a scene, story, spoken line, or due word."),
                buttonTitle: String(localized: "Choose practice"),
                destination: .practice)
        }

        let index = min(currentPathIndex, max(0, chapter.count - 1))
        let lessonTitle =
            chapter.lessons.indices.contains(index)
            ? chapter.lessons[index] : String(localized: "Next lesson")
        let fullLesson = commit > 10
        return NextAction(
            title: lessonTitle,
            reason: goalFocus.reason,
            duration: fullLesson
                ? String(localized: "About 20 minutes for the full lesson")
                : String(localized: "About 10 minutes to the natural pause"),
            outcome: String(localized: "You’ll \(chapter.promise)"),
            buttonTitle: currentPathIndex == 0
                ? String(localized: "Start today’s lesson")
                : String(localized: "Continue today’s path"),
            destination: .course(index))
    }

    /// Progress turns the weakest evidence row into a specific recovery path
    /// without presenting lesson counts as a test score.
    func progressNextAction(skill: String, evidenceCount: Int) -> NextAction {
        let reason =
            evidenceCount == 0
            ? String(
                localized: "No completed lesson has recorded \(skill.lowercased()) practice yet.")
            : String(
                localized:
                    "\(skill) has the least recorded practice: \(evidenceCount) completed lesson\(evidenceCount == 1 ? "" : "s")."
            )

        switch skill {
        case "Speaking":
            return NextAction(
                title: String(localized: "Strengthen speaking"), reason: reason,
                duration: String(localized: "About 3 minutes"),
                outcome: String(localized: "Compare one clear line without an accent score."),
                buttonTitle: String(localized: "Practise speaking"), destination: .speak)
        case "Listening", "Conversation":
            return NextAction(
                title: String(localized: "Strengthen \(skill.lowercased())"), reason: reason,
                duration: String(localized: "About 5 minutes"),
                outcome: String(localized: "Choose replies in a complete, low-pressure exchange."),
                buttonTitle: String(localized: "Open a scene"), destination: .scene)
        default:
            if !mistakes.isEmpty {
                return NextAction(
                    title: String(localized: "Strengthen \(skill.lowercased())"), reason: reason,
                    duration: mistakes.count == 1
                        ? String(localized: "About 1 minute")
                        : String(localized: "About \(min(mistakes.count, 5)) minutes"),
                    outcome: String(
                        localized: "Recall due material and widen its next review interval."),
                    buttonTitle: String(localized: "Review due words"), destination: .review)
            }
            let index = min(currentPathIndex, max(0, chapterHeader.count - 1))
            return NextAction(
                title: String(localized: "Strengthen \(skill.lowercased())"), reason: reason,
                duration: commit > 10
                    ? String(localized: "About 20 minutes")
                    : String(localized: "About 10 minutes to the pause"),
                outcome: String(localized: "Add new practice evidence in the next lesson."),
                buttonTitle: String(localized: "Start the next lesson"), destination: .course(index)
            )
        }
    }

    func perform(_ action: NextAction) {
        switch action.destination {
        case .resumeCourse: resumePending()
        case .course(let index): goCourse(index)
        case .review: reviewRun()
        case .practice: nav(.stories)
        case .scene: nav(.scene)
        case .speak: nav(.speak)
        }
    }

    enum PracticeEvidenceLevel: Int, CaseIterable, Equatable, Sendable {
        case notStarted, introduced, practised, building, repeated, wellRehearsed

        var label: String {
            switch self {
            case .notStarted: String(localized: "Not started")
            case .introduced: String(localized: "Introduced")
            case .practised: String(localized: "Practised")
            case .building: String(localized: "Building")
            case .repeated: String(localized: "Repeated")
            case .wellRehearsed: String(localized: "Well rehearsed")
            }
        }

        var fill: Double {
            switch self {
            case .notStarted: 0.03
            case .introduced: 0.10
            case .practised: 0.30
            case .building: 0.52
            case .repeated: 0.78
            case .wellRehearsed: 1
            }
        }

        static let explanation =
            String(
                localized:
                    "Levels come from completed lessons that use each skill. They show practice evidence, not a test score or permanent mastery."
            )
    }

    static func practiceEvidenceLevel(for completedLessons: Int) -> PracticeEvidenceLevel {
        switch completedLessons {
        case ...0: .notStarted
        case 1: .introduced
        case 2: .practised
        case 3: .building
        case 4...7: .repeated
        default: .wellRehearsed
        }
    }
}
