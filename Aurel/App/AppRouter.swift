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
        case welcome, goal, commit, plan, login
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
    var dragTray = false
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
    var speaking = false
    var speakScored = false
    var speakTake = 0
    var speakVerdict = "near"
    var typing = false
    var typed = ""

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
        var dawn = true
        var sundown = true
        var milestone = true
        var cohort = false
    }

    struct SwitchPrefs: Equatable {
        var reminder = true
        var sound = true
        var haptics = true
        var weekly = false
    }

    // MARK: Dependencies

    let course: CourseStore
    private let modelContext: ModelContext?

    // MARK: Init

    init(course: CourseStore, modelContext: ModelContext? = nil) {
        self.course = course
        self.modelContext = modelContext
        if let modelContext,
            let profile = try? modelContext.fetch(FetchDescriptor<LearnerProfile>()).first
        {
            load(from: profile)
        }
        // Midnight rollover (S1-009): durable day flags must never outlive
        // their day — the prototype was session-scoped, the port persists.
        rolloverDayIfNeeded()
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
    }

    /// The `AUREL_SCREEN` verification hook: pure routing only — a debug
    /// route must never write SwiftData (S2-001: it used to `persist()` and
    /// stamped `onboardedAt` for a debug launch).
    static func screenHook(_ env: [String: String]) -> Screen? {
        env["AUREL_SCREEN"].flatMap(Screen.named)
    }

    /// Preview-only mid-journey seed (seedFor('mid-journey'), line 1747).
    static func midJourneyPreview(course: CourseStore) -> AppRouter {
        let r = AppRouter(course: course)
        r.screen = .home
        r.goals = ["work"]
        r.streak = 43
        r.lessonsDone = 37
        r.baseLessons = 37
        r.basePos = 2
        r.chapterIdx = 1
        r.pro = true
        r.mistakes = [1, 3]
        return r
    }

    func load(from p: LearnerProfile) {
        goals = p.goals
        level = p.level
        email = p.email
        commit = p.commitMinutes
        remindAt = p.remindAt
        streak = p.streakDays
        lessonsDone = p.lessonsDone
        baseLessons = p.baseLessons
        basePos = p.basePos
        chapterIdx = p.chapterIdx
        pro = p.isPro
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
        notif = NotifPrefs(
            dawn: p.notifDawn, sundown: p.notifSundown, milestone: p.notifMilestone,
            cohort: p.notifCohort)
        sw = SwitchPrefs(
            reminder: p.swReminder, sound: p.swSound, haptics: p.swHaptics, weekly: p.swWeekly)
        themeMode = p.themeMode
        typeStep = p.typeStep
        syncFeedbackGates()  // the persisted Haptics/Sound prefs gate the services
        screen = p.onboardedAt == nil ? .welcome : .home
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
        if screen != .welcome && screen != .goal && screen != .commit && screen != .plan {
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
    func upsertDayLog(caughtDelta: Int = 0, now: Date = Date()) {
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

    // MARK: Simple navigation (the `go` map, line 2027)

    var settingsSource: Screen = .home

    func nav(_ to: Screen) {
        if to == .settings {
            settingsSource = (screen == .profile || screen == .home) ? screen : .home
        }
        screen = to
        persist()
    }

    func leaveSettings() {
        screen = settingsSource
        persist()
    }

    // MARK: Onboarding (toggleGoal / finishOnboarding, lines 1705–1710, 2060)

    /// Delayed-transition tasks (S2-002).
    private var sceneReplyTask: Task<Void, Never>?
    private var speakStopTask: Task<Void, Never>?

    func toggleGoal(_ id: String) {
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
        persist()
    }

    // MARK: Login (mock validation, lines 2504–2509)

    func setEmail(_ e: String) { email = e }
    func setPass(_ p: String) { pass = p }

    func signIn() {
        let okMail = email.range(of: #".+@.+\..+"#, options: .regularExpression) != nil
        guard okMail else {
            loginErr = "That email address looks incomplete."
            return
        }
        guard pass.count >= 6 else {
            loginErr = "Passwords are at least six characters."
            return
        }
        loginErr = ""
        screen = .home
        persist()
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
            : course.coursePos(chapterIdx: chapterIdx, lessonIdx: i)
        pending = nil
        screen = .course
    }

    func goStarter() {
        screen = .course
        courseLesson = 0
        coursePos = course.coursePos(chapterIdx: chapterIdx, lessonIdx: 0)
        starter = false
        reviewMode = false
        pending = nil
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
        upsertDayLog()  // the course lesson is the day's first half (§3.14)
        lessonsDone = max(lessonsDone, baseLessons + (courseLesson + 1) - basePos)
        screen = .home
        persist()
    }

    func resumePending() {
        coursePos = pending?.pos ?? coursePos
        pending = nil
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

    func goLesson() {
        resetLesson()
        screen = .lesson
        starter = false
        pending = nil
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
                let backIdx =
                    mistakes
                    .filter { queue.indices.contains($0) }
                    .map { queue[$0] }
                caught = queue.count - backIdx.count
                lastTotal = queue.count
                mistakes = backIdx
                reviewMode = false
                wasReview = true
                dayRecall = true
                dayHalfCompleted()
                upsertDayLog(caughtDelta: caught)  // recall is the second half (§3.14)
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
            upsertDayLog()  // the quick lesson is the day's first half (§3.14)
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

    // MARK: Say-aloud mock (lines 1886–1896)

    func toggleSpeak() {
        if speaking {
            stopSpeak()
            return
        }
        speaking = true
        speakScored = false
        typing = false
        // The 2.6 s take window (line 1890): restarting (or an earlier manual
        // stop) supersedes the pending auto-stop rather than stacking one —
        // the old code stopped the second take early with the first timer.
        speakStopTask?.cancel()
        speakStopTask = Task { @MainActor in
            do {
                try await Task.sleep(for: .seconds(2.6))
            } catch {
                return  // superseded
            }
            stopSpeak()
        }
    }

    func stopSpeak() {
        speakStopTask?.cancel()
        speakTake += 1
        speaking = false
        speakScored = true
        speakVerdict = speakTake >= 2 ? "clear" : "near"
    }

    // MARK: Settings toggles (lines 1882–1884)

    func toggleSw(_ k: WritableKeyPath<SwitchPrefs, Bool>) {
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
        notif[keyPath: k].toggle()
        persist()
    }

    // MARK: Paywall & Subscriptions (lines 2566–2574)

    var hasAccount: Bool {
        !email.isEmpty
    }

    func startSubscribe() {
        if hasAccount {
            pro = true
            screen = .home
            persist()
        } else {
            screen = .subscribeAccount
        }
    }

    func restorePurchase() {
        if hasAccount {
            pro = true
            screen = .home
            persist()
        } else {
            loginErr = "Sign in to restore a purchase."
            screen = .login
        }
    }

    func createAccountAndSubscribe() {
        let okMail = email.range(of: #".+@.+\..+"#, options: .regularExpression) != nil
        guard okMail, pass.count >= 6 else {
            loginErr = "Enter a valid email and a password of at least six characters."
            return
        }
        loginErr = ""
        pro = true
        screen = .home
        persist()
    }
}
