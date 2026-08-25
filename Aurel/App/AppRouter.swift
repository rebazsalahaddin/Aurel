import SwiftData
import SwiftUI

// MARK: - App router
//
// The ported DC state machine (Aurel.dc.html Component, lines 1730–2800):
// the screen enum is the prototype's `screen` string; handlers below carry
// the same names and semantics as the authored `go.*` / class methods.
// Durable fields write through to the SwiftData LearnerProfile; the rest is
// ephemeral UI state exactly as in seedFor().

@MainActor
@Observable
final class AppRouter {
    // MARK: Screens (the authored `screen` values, in flow order)

    enum Screen: Equatable {
        case welcome, onboardingSample, onboardingValue, goal, commit, plan, login
        case home, course, lesson, result
        case streak, leaderboard, stories
        case scene, speak, review
        case progress, profile, settings, paywall, subscribeAccount

        /// MAIN — the tab bar surfaces (line 1571).
        var showsTabs: Bool {
            switch self {
            case .home, .stories, .progress, .profile, .leaderboard: true
            default: false
            }
        }

        /// Debug/verification route from the authored screen names.
        static func named(_ raw: String) -> Screen? {
            switch raw {
            case "welcome": .welcome
            case "onboardingSample": .onboardingSample
            case "onboardingValue": .onboardingValue
            case "goal": .goal
            case "commit": .commit
            case "plan": .plan
            case "login": .login
            case "home": .home
            case "course": .course
            case "lesson": .lesson
            case "result": .result
            case "streak": .streak
            case "leaderboard": .leaderboard
            case "stories": .stories
            case "scene": .scene
            case "speak": .speak
            case "review": .review
            case "progress": .progress
            case "profile": .profile
            case "settings": .settings
            case "paywall": .paywall
            case "subscribeAccount": .subscribeAccount
            default: nil
            }
        }

        /// The authored screen name (UI-test root marker `au.screen.<rawName>`).
        var rawName: String {
            switch self {
            case .welcome: "welcome"
            case .onboardingSample: "onboardingSample"
            case .onboardingValue: "onboardingValue"
            case .goal: "goal"
            case .commit: "commit"
            case .plan: "plan"
            case .login: "login"
            case .home: "home"
            case .course: "course"
            case .lesson: "lesson"
            case .result: "result"
            case .streak: "streak"
            case .leaderboard: "leaderboard"
            case .stories: "stories"
            case .scene: "scene"
            case .speak: "speak"
            case .review: "review"
            case .progress: "progress"
            case .profile: "profile"
            case .settings: "settings"
            case .paywall: "paywall"
            case .subscribeAccount: "subscribeAccount"
            }
        }

        /// Setup routes never imply that onboarding has finished. This also
        /// protects partial-route persistence from stamping `onboardedAt`.
        var isOnboarding: Bool {
            switch self {
            case .welcome, .onboardingSample, .onboardingValue, .goal, .commit, .plan, .login:
                true
            default:
                false
            }
        }
    }

    // MARK: Ephemeral state (seedFor base, lines 1575–1588)

    var screen: Screen = .welcome
    var qi = 0
    var sel: Int? = nil
    var checked = false
    var correctCount = 0
    var starter = false
    var courseLesson = 0
    var attempt = 0
    var nudge = false
    var wrongSel: Int? = nil
    var retries = 0
    var reviewMode = false
    var queue: [Int] = []
    var caught = 0
    var wasReview = false
    var lastTotal = 0
    /// §3.6: the home path draw-in plays on the first reveal only — the
    /// flag lives here so it survives navigation within the session.
    var homePathSeen = false
    /// §3.15/F9: streak milestones whose moment has already shown (mirror
    /// of LearnerProfile.milestonesSeen).
    var milestonesSeen: [Int] = []
    /// §3.18: when the current course run began — the honest session clock
    /// for course minutes (the quick runner has its own `sessionStart`).
    var courseStart: Date? = nil
    /// §3.14: when the current run began — Result shows real elapsed
    /// minutes instead of the fixture "6".
    var sessionStart: Date? = nil
    var loginErr = ""
    var pending: PendingSpot? = nil
    var sceneTurn = 0
    var scenePicks: [Int?] = []
    var boardOut = false
    var boardAll = false
    var boardRules = false
    var selfRate: Int? = nil
    var sceneRoleB = false
    var invited = false
    var flipped = false
    var matchSel: (side: Int, key: Int)? = nil
    var matched: [Int] = []
    var matchWrong: Int? = nil
    var built: [String] = []
    var wrongShake = 0
    var plan = "annual"
    var typing = false
    var typed = ""
    /// The typed-instead check (§3.16): a real word comparison against the
    /// target line — never an automatic pass.
    var speakTypedCheck = false
    var speakTypedVerdict: SpeakVerdict.Tier? = nil
    var speakTypedWords = (matched: 0, total: 0)

    enum OnboardingSampleOutcome: String, Equatable, Sendable {
        case notTried, recognized, skipped
    }

    /// The value sample is deliberately outside course progress. Only this
    /// lightweight outcome and its route checkpoint persist.
    var onboardingSampleOutcome: OnboardingSampleOutcome = .notTried
    var onboardingSampleSelection: Int? = nil
    var onboardingCheckpoint: Screen = .welcome
    /// §3.16: the shared say-aloud take coordinator (mic, window, clarity
    /// check). Owned here so the Speak screen and the player's pronProduce
    /// items (§3.11c) share one honest flow.
    let say = SayCoach()

    // MARK: Say-aloud projections (real data from SayCoach — no mock verdicts)

    var speaking: Bool { say.recording }
    var speakTake: Int { say.record.takes }
    var speakVerdict: SpeakVerdict.Tier? { say.record.verdict }
    var speakUnavailable: Bool { say.record.unavailable }
    var speakAssessing: Bool { say.assessing }
    var speakMicDenied: Bool { say.micDenied }
    var speakMatchedWords: (matched: Int, total: Int) {
        (say.record.matchedWords, say.record.totalWords)
    }

    struct PendingSpot: Equatable {
        var pos: Int
        var title: String
        var at: Int
        var of: Int
    }

    // MARK: Durable state (write-through to LearnerProfile)

    var goals: [String] = []
    var level = "a1"
    var email = ""
    var pass = ""
    var commit = 10
    var remindAt = "07:30"
    var streak = 0
    var lessonsDone = 0
    var baseLessons = 0
    var basePos = 0
    var chapterIdx = 0
    var pro = false
    var mistakes: [Int] = []
    var arcs = 0
    var dayLesson = false
    var dayRecall = false

    // Day rollover (S1-009) — durable, mirrored onto LearnerProfile.
    var activeDay: Date? = nil
    var dayStartStreak = 0
    var dayCounted = false
    var graceMonth = 0
    var graceUsed = 0

    var coursePos = 0
    var notif = NotifPrefs()
    var sw = SwitchPrefs()
    var themeMode = 0  // 0 system · 1 light · 2 dark
    var typeStep = 2  // text-size index; 2 = standard

    struct NotifPrefs: Equatable {
        var dawn = false
        var sundown = false
        var milestone = false
        var cohort = false
    }

    struct SwitchPrefs: Equatable {
        var reminder = false
        var sound = true
        var haptics = true
        var weekly = false
    }

    // MARK: Dependencies

    let course: CourseStore
    let capabilities: AppCapabilities
    private let modelContext: ModelContext?

    // MARK: Init

    init(
        course: CourseStore,
        modelContext: ModelContext? = nil,
        capabilities: AppCapabilities = .release
    ) {
        self.course = course
        self.modelContext = modelContext
        self.capabilities = capabilities
        if let modelContext,
            let profile = try? modelContext.fetch(FetchDescriptor<LearnerProfile>()).first
        {
            load(from: profile)
            sanitizeUnavailablePrototypeState(in: profile, context: modelContext)
        }
        // Midnight rollover (S1-009): durable day flags must never outlive
        // their day — the prototype was session-scoped, the port persists.
        rolloverDayIfNeeded()
        #if AUREL_VERIFICATION
            // Verification hook: SIMCTL_CHILD_AUREL_SCREEN=home — routes like the
            // fast path and never writes the store (a debug route must not mark
            // the learner onboarded).
            if let s = Self.screenHook(ProcessInfo.processInfo.environment) {
                screen = s
            }
            // UI-test fast path: launch with ["-AUREL_TEST_START", "home"] — routes
            // like the env hook but never writes the store.
            let args = ProcessInfo.processInfo.arguments
            if let i = args.firstIndex(of: "-AUREL_TEST_START"), i + 1 < args.count,
                let s = Screen.named(args[i + 1])
            {
                screen = s
            }
            // PH-01 deterministic renderer fixtures. These routes exist only in
            // verification builds and never stamp progress or onboarding state.
            if let i = args.firstIndex(of: "-AUREL_RENDERER_KIND"), i + 1 < args.count,
                let kind = ScreenKind(rawValue: args[i + 1]),
                let fixture = course.rendererFixture(for: kind)
            {
                coursePos = fixture.position
                screen = .course
            }
            if let i = args.firstIndex(of: "-AUREL_LESSON_INDEX"), i + 1 < args.count,
                let index = Int(args[i + 1]), course.lessonFixtures.indices.contains(index)
            {
                coursePos = course.lessonFixtures[index].position
                screen = .course
            }
            if let i = args.firstIndex(of: "-AUREL_THEME_MODE"), i + 1 < args.count,
                let mode = Int(args[i + 1]), (0...2).contains(mode)
            {
                themeMode = mode
            }
        #endif
    }

    #if AUREL_VERIFICATION
        /// The `AUREL_SCREEN` verification hook: pure routing only — a debug
        /// route must never write SwiftData (S2-001: it used to `persist()` and
        /// stamped `onboardedAt` for a debug launch).
        static func screenHook(_ env: [String: String]) -> Screen? {
            env["AUREL_SCREEN"].flatMap(Screen.named)
        }
    #endif

    func load(from p: LearnerProfile) {
        goals = p.goals
        level = p.level
        email = capabilities.accounts ? p.email : ""
        commit = p.commitMinutes
        remindAt = capabilities.notifications ? p.remindAt : ""
        streak = p.streakDays
        lessonsDone = p.lessonsDone
        baseLessons = p.baseLessons
        basePos = p.basePos
        chapterIdx = p.chapterIdx
        pro = capabilities.commerce ? p.isPro : false
        mistakes = p.mistakeBankIndexes
        arcs = p.dayArcsCompleted
        dayLesson = p.dayLessonDone
        dayRecall = p.dayRecallDone
        activeDay = p.activeDay
        dayStartStreak = p.dayStartStreak
        dayCounted = p.dayCounted
        graceMonth = p.graceMonth
        graceUsed = p.graceUsed
        coursePos = p.coursePos
        notif =
            capabilities.notifications
            ? NotifPrefs(
                dawn: p.notifDawn, sundown: p.notifSundown,
                milestone: p.notifMilestone, cohort: p.notifCohort)
            : NotifPrefs()
        sw = SwitchPrefs(
            reminder: capabilities.notifications ? p.swReminder : false,
            sound: p.swSound,
            haptics: p.swHaptics,
            weekly: capabilities.weeklyEmail ? p.swWeekly : false)
        themeMode = p.themeMode
        typeStep = p.typeStep
        milestonesSeen = p.milestonesSeen
        onboardingSampleOutcome =
            OnboardingSampleOutcome(rawValue: p.onboardingSampleOutcome) ?? .notTried
        onboardingSampleSelection = onboardingSampleOutcome == .recognized ? 0 : nil
        onboardingCheckpoint = Self.onboardingScreen(named: p.onboardingCheckpoint) ?? .welcome
        syncFeedbackGates()  // the persisted Haptics/Sound prefs gate the services
        screen = Self.launchScreen(
            onboardingCheckpoint: onboardingCheckpoint,
            completedOnboarding: p.onboardedAt != nil,
            authenticatedAccount: capabilities.accounts && !p.email.isEmpty
        )
    }

    /// Launch routing has one explicit boundary: a fresh or partially set-up
    /// learner returns to the welcome/onboarding route; a signed-in account
    /// skips it. Completed local-only learners also retain their Home fast
    /// path because returning to Welcome would strand existing progress.
    static func launchScreen(
        onboardingCheckpoint: Screen,
        completedOnboarding: Bool,
        authenticatedAccount: Bool
    ) -> Screen {
        if authenticatedAccount || completedOnboarding { return .home }
        return onboardingCheckpoint.isOnboarding ? onboardingCheckpoint : .welcome
    }

    /// Remove legacy prototype-only identity, entitlement, and delivery state
    /// so a release build cannot revive it after relaunch.
    private func sanitizeUnavailablePrototypeState(
        in profile: LearnerProfile,
        context: ModelContext
    ) {
        var changed = false
        if !capabilities.accounts, !profile.email.isEmpty {
            profile.email = ""
            changed = true
        }
        if !capabilities.commerce, profile.isPro {
            profile.isPro = false
            changed = true
        }
        if !capabilities.notifications {
            if !profile.remindAt.isEmpty || profile.swReminder || profile.notifDawn
                || profile.notifSundown || profile.notifMilestone || profile.notifCohort
            {
                profile.remindAt = ""
                profile.swReminder = false
                profile.notifDawn = false
                profile.notifSundown = false
                profile.notifMilestone = false
                profile.notifCohort = false
                changed = true
            }
        }
        if !capabilities.weeklyEmail, profile.swWeekly {
            profile.swWeekly = false
            changed = true
        }
        if changed { try? context.save() }
    }

    /// Write durable fields back to SwiftData.
    func persist() {
        guard let modelContext else { return }
        let profile = fetchOrCreateProfile()
        profile.goals = goals
        profile.level = level
        profile.email = email
        profile.commitMinutes = commit
        profile.remindAt = remindAt
        profile.streakDays = streak
        profile.lessonsDone = lessonsDone
        profile.baseLessons = baseLessons
        profile.basePos = basePos
        profile.chapterIdx = chapterIdx
        profile.isPro = pro
        profile.mistakeBankIndexes = mistakes
        profile.dayArcsCompleted = arcs
        profile.dayLessonDone = dayLesson
        profile.dayRecallDone = dayRecall
        profile.activeDay = activeDay
        profile.dayStartStreak = dayStartStreak
        profile.dayCounted = dayCounted
        profile.graceMonth = graceMonth
        profile.graceUsed = graceUsed
        profile.coursePos = coursePos
        profile.notifDawn = notif.dawn
        profile.notifSundown = notif.sundown
        profile.notifMilestone = notif.milestone
        profile.notifCohort = notif.cohort
        profile.swReminder = sw.reminder
        profile.swSound = sw.sound
        profile.swHaptics = sw.haptics
        profile.swWeekly = sw.weekly
        profile.themeMode = themeMode
        profile.typeStep = typeStep
        profile.milestonesSeen = milestonesSeen
        profile.onboardingCheckpoint = onboardingCheckpoint.rawName
        profile.onboardingSampleOutcome = onboardingSampleOutcome.rawValue
        if !screen.isOnboarding {
            profile.onboardedAt = profile.onboardedAt ?? Date()
        }
        try? modelContext.save()
    }

    /// The profile row persist()/upsertDayLog() write through — fetched,
    /// created on first sight. (Extracted from persist(), Stage 2.)
    private func fetchOrCreateProfile() -> LearnerProfile {
        let existing = modelContext.flatMap { ctx in
            (try? ctx.fetch(FetchDescriptor<LearnerProfile>()))?.first
        }
        if let existing { return existing }
        let p = LearnerProfile()
        modelContext?.insert(p)
        return p
    }

    // MARK: Day rollover + streak accounting (S1-009)

    /// Close out the previous active day and reset the two-halves flags when
    /// a new day begins. Idempotent within a day (gap <= 0 returns). The
    /// ruling — chain carries / grace token / reset — comes from
    /// `StreakEngine.rolloverRuling`; the visible streak semantics are the
    /// authored ones: the lesson half shows "Day one" (`max(streak, 1)`,
    /// Aurel.dc.html:1921/2275), and the day's point lands when both halves
    /// are done ("A day counts when both halves are done", line 2338–2339).
    func rolloverDayIfNeeded(now: Date = Date(), calendar: Calendar = .current) {
        let today = calendar.startOfDay(for: now)
        if let active = activeDay {
            let gap = calendar.dateComponents([.day], from: active, to: today).day ?? 0
            if gap <= 0 { return }
            let ruling = StreakEngine.rolloverRuling(
                closingDayCounted: dayCounted,
                gapDays: gap,
                graceMonth: graceMonth,
                graceUsed: graceUsed,
                today: today,
                calendar: calendar)
            graceMonth = ruling.graceMonth
            graceUsed = ruling.graceUsed
            if ruling.chainContinues {
                // A counted day already banked its point into `streak`; a
                // grace-bridged day keeps the banked chain instead.
                streak = dayCounted ? streak : dayStartStreak
            } else {
                streak = 0
            }
        }
        dayStartStreak = streak
        dayLesson = false
        dayRecall = false
        arcs = 0
        dayCounted = false
        activeDay = today
        persist()
    }

    /// The second half of the day landed — count the day's streak point
    /// exactly once.
    func dayHalfCompleted() {
        if dayLesson && dayRecall && !dayCounted {
            dayCounted = true
            streak = dayStartStreak + 1
        }
    }

    // MARK: Session + day history (Stage-2 data honesty, §3.14)

    /// Real elapsed minutes of the current run, rounded up, minimum one —
    /// the honest "Minutes" tile on Result.
    var sessionMinutes: Int {
        guard let sessionStart else { return 1 }
        let secs = Date().timeIntervalSince(sessionStart)
        return max(1, Int((secs / 60).rounded(.up)))
    }

    /// The day's halves land in a DayLog row (upsert, one row per day) so
    /// Result / Streak / Progress render real history instead of fixture
    /// numbers. Internal (not private) for the Stage-2 regression tests.
    /// Stage-4 addition: run minutes accrue into the row (§3.18 chart).
    func upsertDayLog(caughtDelta: Int = 0, minutesDelta: Int = 0, now: Date = Date()) {
        guard let modelContext else { return }
        let cal = Calendar.current
        let today = cal.startOfDay(for: now)
        let logs = (try? modelContext.fetch(FetchDescriptor<DayLog>())) ?? []
        let log =
            logs.first { cal.isDate($0.day, inSameDayAs: today) }
            ?? {
                let l = DayLog(day: today, learner: fetchOrCreateProfile())
                modelContext.insert(l)
                return l
            }()
        log.lessonDone = dayLesson
        log.recallDone = dayRecall
        if caughtDelta > 0 { log.caught += caughtDelta }
        if minutesDelta > 0 { log.minutes += minutesDelta }
    }

    /// The current week (Monday…Sunday) as completion booleans — a day
    /// counts when both halves are done (governance), read from DayLog.
    /// Days after today stay false.
    func weekCompletedDays(now: Date = Date()) -> [Bool] {
        let cal = Calendar.current
        let logs: [DayLog]
        if let modelContext, let fetched = try? modelContext.fetch(FetchDescriptor<DayLog>()) {
            logs = fetched
        } else {
            logs = []
        }
        let today = cal.startOfDay(for: now)
        let weekday = (cal.component(.weekday, from: today) + 5) % 7  // Mon = 0
        return (0..<7).map { offset in
            guard offset <= weekday,
                let day = cal.date(byAdding: .day, value: offset - weekday, to: today)
            else { return false }
            return logs.first { cal.isDate($0.day, inSameDayAs: day) }
                .map { $0.lessonDone && $0.recallDone } ?? false
        }
    }

    // MARK: Data honesty (Stage 4 — §3.15/§3.17/§3.18/§3.19)

    /// All DayLog rows, oldest first — the real history Streak/Progress
    /// render from (F8 aggregation helpers).
    func dayLogs() -> [DayLog] {
        guard let modelContext,
            let logs = try? modelContext.fetch(FetchDescriptor<DayLog>())
        else { return [] }
        return logs.sorted { $0.day < $1.day }
    }

    /// Completed lessons from LessonRecord (real run history), oldest first.
    func lessonRecords() -> [LessonRecord] {
        guard let modelContext,
            let records = try? modelContext.fetch(FetchDescriptor<LessonRecord>())
        else { return [] }
        return records.sorted { $0.finishedAt < $1.finishedAt }
    }

    /// The learner's honest start date — onboarding completion (fallback:
    /// profile creation). Drives "Since {date}" on Streak/Progress (§3.15/§3.18).
    func profileStartDate() -> Date? {
        guard let modelContext,
            let p = (try? modelContext.fetch(FetchDescriptor<LearnerProfile>()))?.first
        else { return nil }
        return p.onboardedAt ?? p.createdAt
    }

    /// The last day either half of the arc was done — "Last practised …"
    /// on Progress (§3.18).
    func lastPractisedDay() -> Date? {
        dayLogs().last { $0.lessonDone || $0.recallDone }?.day
    }

    /// Elapsed minutes of the current course run, rounded up, minimum one —
    /// the honest course-side minutes (§3.18).
    func courseMinutes() -> Int {
        guard let courseStart else { return 1 }
        let secs = Date().timeIntervalSince(courseStart)
        return max(1, Int((secs / 60).rounded(.up)))
    }

    /// A completed course lesson lands in LessonRecord (§3.18) — idempotent
    /// per (chapter, lesson) so re-runs never double-count.
    func recordLessonCompletion(now: Date = Date()) {
        guard let modelContext else { return }
        let existing = (try? modelContext.fetch(FetchDescriptor<LessonRecord>())) ?? []
        guard
            !existing.contains(where: {
                $0.chapterIdx == chapterIdx && $0.lessonIdx == courseLesson
            })
        else { return }
        modelContext.insert(
            LessonRecord(
                chapterIdx: chapterIdx, lessonIdx: courseLesson, endPos: coursePos,
                wasReview: false, learner: fetchOrCreateProfile()))
    }

    /// Longest run of consecutive complete days over real history — the
    /// honest "Best" figure on Streak (§3.15). Pure: unit-testable.
    static func bestStreak(over logs: [DayLog], calendar: Calendar = .current) -> Int {
        let completeDays = logs.filter { $0.lessonDone && $0.recallDone }.map { $0.day }.sorted()
        var best = 0
        var run = 0
        var prev: Date? = nil
        for day in completeDays {
            if let prev, calendar.dateComponents([.day], from: prev, to: day).day == 1 {
                run += 1
            } else {
                run = 1
            }
            best = max(best, run)
            prev = day
        }
        return max(best, 0)
    }

    /// Practised minutes per week for the last 8 weeks (index 0 = oldest
    /// week, 7 = the current week), from DayLog history — empty weeks are
    /// zero-height, never invented (§3.18). Pure: unit-testable.
    static func weeklyMinutes(
        _ logs: [DayLog], now: Date = Date(), calendar: Calendar = .current
    ) -> [Int] {
        let today = calendar.startOfDay(for: now)
        let weekday = (calendar.component(.weekday, from: today) + 5) % 7  // Mon = 0
        guard
            let currentWeekStart = calendar.date(
                byAdding: .day, value: -weekday, to: today
            )
        else { return Array(repeating: 0, count: 8) }
        return (0..<8).map { back in
            let weeksBack = 7 - back
            guard
                let weekStart = calendar.date(
                    byAdding: .day, value: -(weeksBack * 7), to: currentWeekStart
                )
            else { return 0 }
            return
                logs
                .filter { $0.day >= weekStart && ($0.day < currentWeekStart || back == 7) }
                .reduce(0) { $0 + $1.minutes }
        }
    }

    /// Total practised minutes over real history (§3.18). Pure.
    static func totalMinutes(_ logs: [DayLog]) -> Int {
        logs.reduce(0) { $0 + $1.minutes }
    }

    /// One month-grid cell state (§3.15): a completed day, a past day that
    /// did not complete, a future day, or a day outside the month.
    enum MonthDayState: Equatable { case done, quiet, future, outside }

    /// The current month's grid states, index 0 = the 1st (§3.15). Pure:
    /// unit-testable.
    static func monthStates(
        _ logs: [DayLog], now: Date = Date(), calendar: Calendar = .current
    ) -> [MonthDayState] {
        let today = calendar.startOfDay(for: now)
        let comps = calendar.dateComponents([.year, .month], from: today)
        guard let monthStart = calendar.date(from: comps) else {
            return Array(repeating: .outside, count: 31)
        }
        let daysInMonth = calendar.range(of: .day, in: .month, for: today)?.count ?? 30
        return (0..<31).map { i in
            guard i < daysInMonth,
                let date = calendar.date(byAdding: .day, value: i, to: monthStart)
            else { return .outside }
            if date > today { return .future }
            return logs.first { calendar.isDate($0.day, inSameDayAs: date) }
                .map { $0.lessonDone && $0.recallDone ? MonthDayState.done : .quiet } ?? .quiet
        }
    }

    // MARK: Mistake ladder persistence (§3.17)

    /// Live MistakeItem rows for the current queue — bankIndex → row. The
    /// Review screen derives its real due labels from these.
    func mistakeRows() -> [Int: MistakeItem] {
        guard let modelContext,
            let rows = try? modelContext.fetch(FetchDescriptor<MistakeItem>())
        else { return [:] }
        return Dictionary(rows.map { ($0.bankIndex, $0) }, uniquingKeysWith: { a, _ in a })
    }

    /// Real due label for a queue item (§3.17): "Due now", "Due tomorrow",
    /// or "Due in N days" — from the row's actual next-due date. Items
    /// without a row (legacy queue entries) fall back to "Due tomorrow",
    /// the ladder's first rung. Pure: unit-testable.
    static func dueLabel(
        for row: MistakeItem?, now: Date = Date(), calendar: Calendar = .current
    ) -> String {
        guard let row else { return "Due tomorrow" }
        let days =
            calendar.dateComponents(
                [.day], from: calendar.startOfDay(for: now), to: calendar.startOfDay(for: row.dueAt)
            ).day ?? 0
        if row.dueAt <= now { return "Due now" }
        if days <= 0 { return "Due today" }
        if days == 1 { return "Due tomorrow" }
        return "Due in \(days) days"
    }

    /// Whether a queue item is due (its ladder date has arrived) — the
    /// urgency tier for the badge styling (§3.17b).
    static func isDue(_ row: MistakeItem?, now: Date = Date()) -> Bool {
        guard let row else { return false }
        return row.dueAt <= now
    }

    /// Land the run's outcome on the mistake ladder (§3.17): catches widen
    /// the interval (1 → 3 → 7 → 14 → 30 → leaves the list), misses reset
    /// to the first rung. `caught`/`missed` are bank indexes. The visible
    /// queue re-syncs to the live rows (soonest due first).
    func advanceMistakeLadder(caught: [Int], missed: [Int], now: Date = Date()) {
        guard let modelContext else { return }
        let cal = Calendar.current
        let rows = mistakeRows()
        for idx in caught {
            if let row = rows[idx] {
                if let next = ReviewScheduler.nextInterval(after: row.intervalDays) {
                    row.intervalDays = next
                    row.dueAt = cal.date(byAdding: .day, value: next, to: now) ?? now
                } else {
                    // The 30-day catch stuck — the item leaves the list.
                    modelContext.delete(row)
                }
            } else {
                // Caught without a row (a legacy queue entry): the first
                // catch widens to the second rung and stays.
                let row = MistakeItem(
                    bankIndex: idx, word: "", intervalDays: 3,
                    learner: fetchOrCreateProfile())
                row.dueAt = cal.date(byAdding: .day, value: 3, to: now) ?? now
                modelContext.insert(row)
            }
        }
        for idx in missed {
            if let row = rows[idx] {
                row.intervalDays = 1
                row.dueAt = cal.date(byAdding: .day, value: 1, to: now) ?? now
            } else {
                modelContext.insert(
                    MistakeItem(
                        bankIndex: idx, word: "", intervalDays: 1, learner: fetchOrCreateProfile()))
            }
        }
        syncQueueFromRows()
    }

    /// Re-derive the visible queue from the live MistakeItem rows.
    private func syncQueueFromRows() {
        guard let modelContext,
            let rows = try? modelContext.fetch(FetchDescriptor<MistakeItem>())
        else { return }
        mistakes = rows.sorted { $0.dueAt < $1.dueAt }.map { $0.bankIndex }
    }

    // MARK: Calm milestone moments (§3.15/F9)

    /// Milestone days whose authored moment is due — the streak has reached
    /// the day and the moment has not been shown yet. 7 / 30 / 100. Pure.
    static func dueMilestones(streak: Int, seen: [Int]) -> [Int] {
        [7, 30, 100].filter { streak >= $0 && !seen.contains($0) }
    }

    /// Show-once bookkeeping: log the milestone to the profile (§3.15).
    func markMilestoneShown(_ day: Int) {
        guard let modelContext,
            let p = (try? modelContext.fetch(FetchDescriptor<LearnerProfile>()))?.first
        else { return }
        if !p.milestonesSeen.contains(day) {
            p.milestonesSeen.append(day)
            try? modelContext.save()
        }
        milestonesSeen = p.milestonesSeen
    }

    // MARK: Simple navigation (the `go` map, line 2027)

    var settingsSource: Screen = .home

    func nav(_ to: Screen) {
        if to == .settings {
            settingsSource = (screen == .profile || screen == .home) ? screen : .home
        }
        if to.isOnboarding, to != .login {
            onboardingCheckpoint = to
        }
        screen = to
        persist()
    }

    func leaveSettings() {
        screen = settingsSource
        persist()
    }

    // MARK: Onboarding (value sample + preferences)

    /// Delayed-transition tasks (S2-002).
    private var sceneReplyTask: Task<Void, Never>?

    private static func onboardingScreen(named raw: String) -> Screen? {
        guard let screen = Screen.named(raw), screen.isOnboarding, screen != .login else {
            return nil
        }
        return screen
    }

    /// The recognition sample has one safe, unambiguous answer. A wrong tap
    /// stays local to the sample; a correct tap persists only the sample
    /// outcome and never changes lesson, streak, review, or day progress.
    func chooseOnboardingSample(_ option: Int) {
        onboardingSampleSelection = option
        if option == 0 {
            onboardingSampleOutcome = .recognized
            AUFeedback.correct()
        } else {
            onboardingSampleOutcome = .notTried
            AUFeedback.miss()
        }
        persist()
    }

    func continueOnboardingSample() {
        guard onboardingSampleOutcome == .recognized else { return }
        nav(.onboardingValue)
    }

    func skipOnboardingSample() {
        onboardingSampleSelection = nil
        onboardingSampleOutcome = .skipped
        nav(.onboardingValue)
    }

    func toggleGoal(_ id: String) {
        AUFeedback.selection()
        if goals.contains(id) {
            goals = goals.filter { $0 != id }
        } else if goals.count >= 2 {
            goals = [goals[1], id]
        } else {
            goals = goals + [id]
        }
        persist()
    }

    var goalHint: String {
        if goals.isEmpty { return "Pick at least one." }
        if goals.count == 1 { return "One more, if you like." }
        return "Two is the limit — tap another to swap."
    }

    func finishOnboarding() {
        screen = .plan
        onboardingCheckpoint = .plan
        persist()
    }

    /// The plan's CTA is the single onboarding completion boundary. Starting
    /// the real lesson stamps onboarding once; the preceding sample remains
    /// progress-free.
    func startFirstLesson() {
        goStarter()
        persist()
    }

    // MARK: Account gates

    func setEmail(_ e: String) { email = e }

    /// Words actually carried by the completed lessons (craft overhaul G7) —
    /// the same store-derived count Progress shows, so Profile stops
    /// fabricating `lessonsDone * 12`. Mirrors `wordsTotal` in ProgressView.
    var wordsLearned: Int {
        let done = Set(
            lessonRecords().filter { !$0.wasReview }.map { "\($0.chapterIdx)-\($0.lessonIdx)" })
        guard !done.isEmpty else { return 0 }
        var words = 0
        for f in course.flat {
            guard done.contains("\(chapterIndex(of: f.chapter.id))-\(f.lesson.n - 1)") else {
                continue
            }
            if case .cards(let sc) = f.screen.payload {
                words += sc.cards?.count ?? 0
            }
        }
        return words
    }

    /// The chapter's index for a chapter id ("A1-C03" → 2).
    private func chapterIndex(of id: String) -> Int {
        course.chapters.firstIndex { $0.id == id } ?? 0
    }
    func setPass(_ p: String) { pass = p }

    func signIn() {
        guard capabilities.accounts else {
            withAnimation(AUMotion.flow) {
                loginErr = "Account sign-in isn't available in this build."
            }
            return
        }
        let okMail = email.range(of: #".+@.+\..+"#, options: .regularExpression) != nil
        // Craft overhaul M9: banner state animates (was a hard cut).
        guard okMail else {
            withAnimation(AUMotion.flow) { loginErr = "That email address looks incomplete." }
            return
        }
        guard pass.count >= 6 else {
            withAnimation(AUMotion.flow) { loginErr = "Passwords are at least six characters." }
            return
        }
        withAnimation(AUMotion.flow) {
            loginErr = "An account service isn't connected."
        }
    }

    // MARK: Course player wiring (lines 2028–2036, 2267–2277)

    func goCourse(_ i: Int) {
        // Authored `go.course` (line 2029) hardwires `i >= 4` for the chapter
        // end — written for four-lesson chapters. C3 has three lessons: its
        // "Chapter complete" node passes i = 3, which `coursePos` cannot match
        // and fell through to 0 (C1 · L1 · S01). Generalize the threshold to
        // the chapter's own lesson count — identical for four-lesson chapters
        // (C1/C2), repairs the three-lesson chapter (C3).
        let lessons =
            course.chapters.indices.contains(chapterIdx)
            ? course.chapters[chapterIdx].lessons.count : 4
        courseLesson = min(i, 3)
        coursePos =
            i >= lessons
            ? course.chapterEndPos(chapterIdx)
            : course.lessonStartPos(chapterIdx: chapterIdx, lessonIdx: i)
        pending = nil
        courseStart = Date()  // §3.18 session clock
        screen = .course
    }

    func goStarter() {
        screen = .course
        courseLesson = 0
        coursePos = course.lessonStartPos(chapterIdx: chapterIdx, lessonIdx: 0)
        starter = false
        reviewMode = false
        pending = nil
        courseStart = Date()  // §3.18 session clock
    }

    var lastCoursePos = 0  // trackCourse(n)
    func trackCourse(_ n: Int) { lastCoursePos = n }

    func leaveCourse() {
        let pos = lastCoursePos
        let spot = course.courseSpot(pos)
        coursePos = pos
        pending = PendingSpot(pos: pos, title: spot.title, at: spot.at, of: spot.of)
        screen = .home
        persist()
    }

    func finishCourse() {
        pending = nil
        dayLesson = true
        streak = max(streak, 1)
        dayHalfCompleted()
        // §3.18: the course run's real minutes, from its own session clock.
        let mins = courseMinutes()
        upsertDayLog(minutesDelta: mins)
        // §3.18: the completed course lesson lands in LessonRecord — the
        // Progress aggregates read these.
        recordLessonCompletion()
        lessonsDone = max(lessonsDone, baseLessons + (courseLesson + 1) - basePos)
        courseStart = nil
        screen = .home
        persist()
    }

    func resumePending() {
        coursePos = pending?.pos ?? coursePos
        pending = nil
        if courseStart == nil { courseStart = Date() }  // resume keeps counting
        screen = .course
    }

    func discardPending() {
        resetLesson()
        pending = nil
    }

    // MARK: Quick practice (resetLesson / advance / check, lines 1903–1947)

    func resetLesson() {
        sessionStart = Date()  // every run starts its own clock (§3.14)
        qi = 0
        sel = nil
        checked = false
        correctCount = 0
        mistakes = []
        flipped = false
        matchSel = nil
        matched = []
        matchWrong = nil
        built = []
        attempt = 0
        nudge = false
        wrongSel = nil
        retries = 0
    }

    func reviewRun() {
        let q = mistakes
        guard !q.isEmpty else {
            screen = .review
            return
        }
        resetLesson()
        reviewMode = true
        queue = q
        screen = .lesson
    }

    func leaveLesson(listCount: Int) {
        pending =
            (qi > 0 && !reviewMode)
            ? PendingSpot(
                pos: coursePos, title: course.courseSpot(coursePos).title, at: qi + 1, of: listCount
            )
            : nil
        screen = .home
        persist()
    }

    func restartLesson() {
        resetLesson()
        screen = .lesson
    }

    /// advance() — check first if unanswered, then step or finish.
    func advance(list: [QuickItem]) {
        let q = list.indices.contains(qi) ? list[qi] : nil
        if !checked, let q, q.type != .flash, q.type != .match {
            check(list: list)
            return
        }
        if qi >= list.count - 1 {
            if reviewMode {
                // Mistakes hold display indexes; map them back to bank indexes.
                let wrongIdx =
                    mistakes
                    .filter { queue.indices.contains($0) }
                    .map { queue[$0] }
                let caughtIdx = queue.filter { !wrongIdx.contains($0) }
                caught = caughtIdx.count
                lastTotal = queue.count
                // §3.17: land the run on the real ladder — catches widen
                // (1→3→7→14→30→leaves), misses reset to the first rung.
                // The visible queue re-syncs from the rows.
                advanceMistakeLadder(caught: caughtIdx, missed: wrongIdx)
                reviewMode = false
                wasReview = true
                dayRecall = true
                dayHalfCompleted()
                upsertDayLog(
                    caughtDelta: caught, minutesDelta: sessionMinutes
                )  // recall is the second half (§3.14)
                arcs += 1
                screen = .result
                persist()
                return
            }
            wasReview = false
            pending = nil
            streak = max(streak, 1)
            lessonsDone = max(lessonsDone, 1)
            dayLesson = true
            dayHalfCompleted()
            // §3.17: the run's misses land on the ladder (display indexes
            // are bank indexes in a normal run — the list is the bank).
            advanceMistakeLadder(caught: [], missed: mistakes)
            // The quick lesson is the day's first half (§3.14).
            upsertDayLog(minutesDelta: sessionMinutes)
            screen = .result
            persist()
            return
        }
        qi += 1
        sel = nil
        checked = false
        flipped = false
        selfRate = nil
        matchSel = nil
        matched = []
        matchWrong = nil
        built = []
        attempt = 0
        nudge = false
        wrongSel = nil
    }

    /// check() — neutral retry on first miss, reveal on second.
    func check(list: [QuickItem]) {
        guard list.indices.contains(qi) else { return }
        let q = list[qi]
        var ok = false
        if q.type == .choice || q.type == .listen || q.type == QuickItem.Kind.pattern {
            ok = sel == q.answer
        }
        if q.type == .order { ok = built.joined(separator: " ") == q.answerString }
        if ok {
            checked = true
            nudge = false
            correctCount += attempt == 0 ? 1 : 0
            retries += attempt > 0 ? 1 : 0
            return
        }
        if !mistakes.contains(qi) { mistakes.append(qi) }
        if attempt == 0 {
            nudge = true
            attempt = 1
            wrongSel = sel
            sel = nil
            built = []
            wrongShake += 1
            return
        }
        checked = true
        nudge = false
        wrongShake += 1
    }

    func pickOption(_ i: Int) {
        if !checked && wrongSel != i { sel = i }
    }

    func flip() { flipped.toggle() }

    func pickWord(_ w: String) {
        if !checked { built.append(w) }
    }

    func unpickWord(_ i: Int) {
        if !checked && built.indices.contains(i) { built.remove(at: i) }
    }

    // MARK: Practice hub / scene (lines 2672–2713)

    func setSolo() { sceneRoleB = false }
    func setDuo() { sceneRoleB = true }
    func replayScene() {
        sceneReplyTask?.cancel()
        sceneTurn = 0
        scenePicks = []
    }

    func pickSceneReply(_ i: Int, turnCount: Int) {
        while scenePicks.count <= sceneTurn { scenePicks.append(nil) }
        scenePicks[sceneTurn] = i
        // 640 ms after a pick the turn advances (line 2705); a newer pick
        // supersedes the pending advance instead of stacking a second one.
        sceneReplyTask?.cancel()
        sceneReplyTask = Task { @MainActor in
            do {
                try await Task.sleep(for: .seconds(0.64))
            } catch {
                return  // superseded
            }
            if sceneTurn < turnCount { sceneTurn += 1 }
        }
    }

    func leaveScene() {
        sceneReplyTask?.cancel()
        screen = .stories
    }

    // MARK: Say-aloud (§3.16 — the take state; the mic + recognition live in SayCoach)

    /// Start/stop a take for `target` (the authored say-aloud line). The
    /// mock verdict ladder is gone: the tier comes from the take's real
    /// transcript, or an honest no-verdict state when recognition is
    /// unavailable.
    func toggleSpeak(target: String) {
        speakTypedCheck = false
        say.toggle(target: target)
    }

    /// Manual/auto stop of the running take (kept for the ported callers).
    func stopSpeak() {
        say.finish()
    }

    /// The typed-instead path (§3.16): the same clarity comparison, run on
    /// what the learner typed — a real check, never an automatic pass.
    func checkTyped(target: String) {
        speakTypedVerdict = SpeakVerdict.evaluate(target: target, transcript: typed)
        let words = SpeakVerdict.wordsInOrder(target: target, transcript: typed)
        speakTypedWords = (words.matched, words.total)
        speakTypedCheck = true
        typing = false
        switch speakTypedVerdict {
        case .clear:
            AUFeedback.correct()
            AUSound.shared.correct()
            AUAX.announce("Read and checked. The sentence is right.")
        case .near:
            AUFeedback.press()
            AUAX.announce("Closer each time.")
        case .nothingHeard:
            AUFeedback.miss()
            AUAX.announce("Nothing matched.")
        case nil:
            break
        }
    }

    // MARK: Settings toggles (lines 1882–1884)

    func toggleSw(_ k: WritableKeyPath<SwitchPrefs, Bool>) {
        AUFeedback.selection()
        sw[keyPath: k].toggle()
        syncFeedbackGates()
        persist()
    }

    /// Stage-1 wiring (IMPROVEMENT_PLAN.md §2.6): the Haptics and Sound
    /// settings gate the feedback services live — they were dead switches
    /// before (audit B18).
    func syncFeedbackGates() {
        AUFeedback.isEnabled = sw.haptics
        AUSound.shared.isEnabled = sw.sound
    }

    func toggleNotif(_ k: WritableKeyPath<NotifPrefs, Bool>) {
        AUFeedback.selection()
        notif[keyPath: k].toggle()
        persist()
    }

    // MARK: Account, commerce, and local-data contracts

    var hasAccount: Bool {
        capabilities.accounts && !email.isEmpty
    }

    func startSubscribe() {
        guard capabilities.commerce else {
            loginErr = "Subscriptions aren't available in this build."
            return
        }
        if hasAccount {
            // A real commerce client owns entitlement. Never grant it from a tap.
            loginErr = "A purchase service isn't connected."
        } else {
            screen = .subscribeAccount
        }
    }

    func restorePurchase() {
        guard capabilities.commerce else {
            loginErr = "Purchase restore isn't available in this build."
            return
        }
        loginErr = "A purchase service isn't connected."
    }

    func createAccountAndSubscribe() {
        guard capabilities.accounts, capabilities.commerce else {
            loginErr = "Account subscriptions aren't available in this build."
            return
        }
        let okMail = email.range(of: #".+@.+\..+"#, options: .regularExpression) != nil
        guard okMail, pass.count >= 6 else {
            loginErr = "Enter a valid email and a password of at least six characters."
            return
        }
        loginErr = "A purchase service isn't connected."
    }

    /// Account-session semantics are separate from learning-data semantics.
    /// This is hidden in release until accounts exist, but is defined and
    /// regression-tested now so a future sign-out cannot erase progress.
    func signOut() {
        email = ""
        pass = ""
        pro = false
        loginErr = ""
        if let modelContext,
            let profile = try? modelContext.fetch(FetchDescriptor<LearnerProfile>()).first
        {
            profile.email = ""
            profile.isPro = false
            try? modelContext.save()
        }
        screen = .welcome
    }

    /// Permanently erase every local Aurel model after the UI's explicit
    /// confirmation, then reset the running app to a guest. Normal launch/day
    /// initialization may create a fresh default profile later; deleted
    /// identity, settings, and learning records must never return.
    @discardableResult
    func deleteLocalData() -> Bool {
        guard let modelContext else {
            resetAfterLocalDeletion()
            return true
        }
        do {
            for row in try modelContext.fetch(FetchDescriptor<MistakeItem>()) {
                modelContext.delete(row)
            }
            for row in try modelContext.fetch(FetchDescriptor<DayLog>()) {
                modelContext.delete(row)
            }
            for row in try modelContext.fetch(FetchDescriptor<LessonRecord>()) {
                modelContext.delete(row)
            }
            for row in try modelContext.fetch(FetchDescriptor<LearnerProfile>()) {
                modelContext.delete(row)
            }
            try modelContext.save()
            resetAfterLocalDeletion()
            return true
        } catch {
            modelContext.rollback()
            loginErr = "Aurel couldn't delete the local data. Nothing was changed."
            return false
        }
    }

    /// The explicit cancellation branch for the local-deletion prompt. It is
    /// intentionally side-effect free and kept as a tested router contract so
    /// cancellation can never drift into the destructive path during later UI
    /// refactors.
    func cancelLocalDataDeletion() {}

    private func resetAfterLocalDeletion() {
        goals = []
        level = "a1"
        email = ""
        pass = ""
        commit = 10
        remindAt = ""
        streak = 0
        lessonsDone = 0
        baseLessons = 0
        basePos = 0
        chapterIdx = 0
        pro = false
        mistakes = []
        arcs = 0
        dayLesson = false
        dayRecall = false
        activeDay = nil
        dayStartStreak = 0
        dayCounted = false
        graceMonth = 0
        graceUsed = 0
        coursePos = 0
        notif = NotifPrefs()
        sw = SwitchPrefs()
        themeMode = 0
        typeStep = 2
        milestonesSeen = []
        onboardingSampleOutcome = .notTried
        onboardingSampleSelection = nil
        onboardingCheckpoint = .welcome
        queue = []
        syncFeedbackGates()
        screen = .welcome
    }
}
