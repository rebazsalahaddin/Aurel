import Foundation
import SwiftData

// MARK: - SwiftData models
//
// The durable half of the prototype's component state (Aurel.dc.html
// seedFor(), lines 1731–1754). Ephemeral UI state (screen, selections, quiz
// position) lives in AppRouter; everything here survives relaunch.

@Model
final class LearnerProfile {
    var createdAt: Date = Date()
    var goals: [String] = []
    var level: String = "a1"
    var email: String = ""
    var commitMinutes: Int = 10
    var remindAt: String = "07:30"
    var isPro: Bool = false

    // Position on the course
    var chapterIdx: Int = 0
    var lessonsDone: Int = 0
    var baseLessons: Int = 0
    var basePos: Int = 0
    var coursePos: Int = 0

    // The day's two halves (streak counts a day only when both are done)
    var streakDays: Int = 0
    var dayLessonDone: Bool = false
    var dayRecallDone: Bool = false
    var dayArcsCompleted: Int = 0

    // Quick-practice mistake queue (bank indexes into CourseStore.allPracticeItems)
    var mistakeBankIndexes: [Int] = []

    // Notifications (notif)
    var notifDawn: Bool = true
    var notifSundown: Bool = true
    var notifMilestone: Bool = true
    var notifCohort: Bool = false

    // Switches (sw)
    var swReminder: Bool = true
    var swSound: Bool = true
    var swHaptics: Bool = true
    var swWeekly: Bool = false

    // Appearance & type
    var themeMode: Int = 0        // 0 system · 1 light · 2 dark
    var typeStep: Int = 2         // text-size index; 2 = standard (of 1…3)

    var onboardedAt: Date?

    @Relationship(deleteRule: .cascade, inverse: \DayLog.learner)
    var dayLogs: [DayLog] = []

    @Relationship(deleteRule: .cascade, inverse: \LessonRecord.learner)
    var lessonRecords: [LessonRecord] = []

    init() {}
}

@Model
final class DayLog {
    var day: Date                 // start-of-day
    var lessonDone: Bool = false
    var recallDone: Bool = false
    var caught: Int = 0           // words caught in review that day
    var learner: LearnerProfile?

    init(day: Date, learner: LearnerProfile? = nil) {
        self.day = Calendar.current.startOfDay(for: day)
        self.learner = learner
    }
}

@Model
final class LessonRecord {
    var finishedAt: Date = Date()
    var chapterIdx: Int = 0
    var lessonIdx: Int = 0
    var endPos: Int = 0           // global course position reached
    var wasReview: Bool = false
    var learner: LearnerProfile?

    init(chapterIdx: Int, lessonIdx: Int, endPos: Int, wasReview: Bool = false, learner: LearnerProfile? = nil) {
        self.chapterIdx = chapterIdx
        self.lessonIdx = lessonIdx
        self.endPos = endPos
        self.wasReview = wasReview
        self.learner = learner
    }
}

/// One word scheduled back by the spaced-retrieval rule (1/3/7/14/30 days).
@Model
final class MistakeItem {
    var bankIndex: Int            // index into CourseStore.allPracticeItems
    var word: String = ""
    var addedAt: Date = Date()
    var dueAt: Date = Date()
    var intervalDays: Int = 1
    var learner: LearnerProfile?

    init(bankIndex: Int, word: String, intervalDays: Int = 1, learner: LearnerProfile? = nil) {
        self.bankIndex = bankIndex
        self.word = word
        self.intervalDays = intervalDays
        self.dueAt = Calendar.current.date(byAdding: .day, value: intervalDays, to: Date()) ?? Date()
        self.learner = learner
    }
}
