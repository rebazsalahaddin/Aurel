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
        case welcome, goal, placement, commit, plan
        case assess, assessReview, login
        case home, course, lesson, result
        case streak, leaderboard, stories, reader, hunt
        case scene, speak, review, progress, profile, settings, paywall

        /// MAIN — the tab bar surfaces (line 1728).
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
            case "placement": .placement
            case "commit": .commit
            case "plan": .plan
            case "assess": .assess
            case "assessReview": .assessReview
            case "login": .login
            case "home": .home
            case "course": .course
            case "lesson": .lesson
            case "result": .result
            case "streak": .streak
            case "leaderboard": .leaderboard
            case "stories": .stories
            case "reader": .reader
            case "hunt": .hunt
            case "scene": .scene
            case "speak": .speak
            case "review": .review
            case "progress": .progress
            case "profile": .profile
            case "settings": .settings
            case "paywall": .paywall
            default: nil
            }
        }

        /// The authored screen name (UI-test root marker `au.screen.<rawName>`).
        var rawName: String {
            switch self {
            case .welcome: "welcome"
            case .goal: "goal"
            case .placement: "placement"
            case .commit: "commit"
            case .plan: "plan"
            case .assess: "assess"
            case .assessReview: "assessReview"
            case .login: "login"
            case .home: "home"
            case .course: "course"
            case .lesson: "lesson"
            case .result: "result"
            case .streak: "streak"
            case .leaderboard: "leaderboard"
            case .stories: "stories"
            case .reader: "reader"
            case .hunt: "hunt"
            case .scene: "scene"
            case .speak: "speak"
            case .review: "review"
            case .progress: "progress"
            case .profile: "profile"
            case .settings: "settings"
            case .paywall: "paywall"
            }
        }
    }

    // MARK: Ephemeral state (seedFor base, lines 1732–1746)

    var screen: Screen = .welcome
    var assessStep = 0
    var assessAnswers: [Int?] = Array(repeating: nil, count: 6)
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
    var loginErr = ""
    var pending: PendingSpot? = nil
    var sceneTurn = 0
    var scenePicks: [Int?] = []
    var boardOut = false
    var boardAll = false
    var boardRules = false
    var dragTray = false
    var selfRate: Int? = nil
    var huntIdx = 0
    var huntShot = false
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
        // Verification hook: SIMCTL_CHILD_AUREL_SCREEN=home
        if let raw = ProcessInfo.processInfo.environment["AUREL_SCREEN"], let s = Screen.named(raw)
        {
            screen = s
            persist()
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
        coursePos = p.coursePos
        notif = NotifPrefs(
            dawn: p.notifDawn, sundown: p.notifSundown, milestone: p.notifMilestone,
            cohort: p.notifCohort)
        sw = SwitchPrefs(
            reminder: p.swReminder, sound: p.swSound, haptics: p.swHaptics, weekly: p.swWeekly)
        themeMode = p.themeMode
        typeStep = p.typeStep
        screen = p.onboardedAt == nil ? .welcome : .home
    }

    /// Write durable fields back to SwiftData.
    func persist() {
        guard let modelContext else { return }
        let profile =
            (try? modelContext.fetch(FetchDescriptor<LearnerProfile>()).first)
            ?? {
                let p = LearnerProfile()
                modelContext.insert(p)
                return p
            }()
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
        if screen != .welcome && screen != .goal && screen != .placement && screen != .commit
            && screen != .plan
        {
            profile.onboardedAt = profile.onboardedAt ?? Date()
        }
        try? modelContext.save()
    }

    // MARK: Simple navigation (the `go` map, line 2027)

    func nav(_ to: Screen) {
        screen = to
        persist()
    }

    // MARK: Onboarding (toggleGoal / assessPick, lines 1863–1880)

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

    func assessPick(_ i: Int) {
        let k = assessStep - 1
        guard k >= 0 && k < 6 else { return }
        assessAnswers[k] = i
        // 420 ms after a pick: advance, or open the review when all six are in.
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.42))
            if assessAnswers.allSatisfy({ $0 != nil }) {
                screen = .assessReview
            } else {
                assessStep = k + 2
            }
        }
    }

    func skipPlacement() { screen = .plan }
    func assessBegin() {
        screen = .plan
        assessStep = 0
    }
    func assessBack() { assessStep = assessStep > 1 ? assessStep - 1 : 0 }
    func assessLast() {
        screen = .assess
        assessStep = 6
    }
    func assessStopEarly() { assessStep = 6 }

    /// assessReviewRows (line 2309–2313): one row per PLACEMENT question —
    /// PLACEMENT is empty by governance, so this is empty exactly as the
    /// authored projection renders it.
    struct AssessReviewRow: Equatable {
        let n: Int
        let prompt: String
        let answer: String
    }

    var assessReviewRows: [AssessReviewRow] {
        []  // PLACEMENT = [] (DECISIONS.md — placement stubs only until F2)
    }
    func assessConfirm() {
        screen = .plan
        assessStep = 0
    }

    // MARK: Login (mock validation, lines 2727–2731)

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
        courseLesson = min(i, 3)
        coursePos =
            i >= 4
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
        sceneTurn = 0
        scenePicks = []
    }

    func pickSceneReply(_ i: Int, turnCount: Int) {
        while scenePicks.count <= sceneTurn { scenePicks.append(nil) }
        scenePicks[sceneTurn] = i
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.64))
            if sceneTurn < turnCount { sceneTurn += 1 }
        }
    }

    func leaveScene() { screen = .stories }

    // MARK: Say-aloud mock (lines 1886–1896)

    func toggleSpeak() {
        if speaking {
            stopSpeak()
            return
        }
        speaking = true
        speakScored = false
        typing = false
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(2.6))
            stopSpeak()
        }
    }

    func stopSpeak() {
        speakTake += 1
        speaking = false
        speakScored = true
        speakVerdict = speakTake >= 2 ? "clear" : "near"
    }

    // MARK: Settings toggles (lines 1882–1884)

    func toggleSw(_ k: WritableKeyPath<SwitchPrefs, Bool>) {
        sw[keyPath: k].toggle()
        persist()
    }

    func toggleNotif(_ k: WritableKeyPath<NotifPrefs, Bool>) {
        notif[keyPath: k].toggle()
        persist()
    }

    // MARK: Paywall (line 2791)

    func startTrial() {
        pro = true
        screen = .home
        persist()
    }
}
