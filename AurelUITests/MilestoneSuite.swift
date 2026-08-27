import XCTest

/// Milestone suite — e2e lesson completion, background/resume, Dynamic-Type
/// AX sizes, and the tab/settings/paywall round trip. Runs at loop milestones
/// and at exit (~15–25 min on the gate device; `qa/run-ui-ax.sh` runs the AX
/// test on the matrix devices).
///
/// The lesson walker is state-driven, not scripted: the authored retry ladder
/// guarantees forward progress (miss → hint → reveal), so the walk needs no
/// baked answer keys to complete a lesson end-to-end. Answer-key-driven walks
/// land with the content-conformance fixture in a loop iteration.
@MainActor
final class MilestoneSuite: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() async throws {
        try await super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        // Self-sufficiency: suites run alphabetically (Milestone before
        // Smoke), so this suite cannot assume an onboarded store — bootstrap
        // to Home through the non-persisting fast path instead. The reset
        // also clears whatever a previous Xcode run persisted on this device
        // (chapter shell, lesson records, pending card), which would
        // otherwise re-shape Home and bury the path nodes behind the tab bar.
        app.launchArguments = ["-AUREL_TEST_RESET", "-AUREL_TEST_START", "home"]
    }

    // MARK: helpers (same query discipline as SmokeSuite)

    @discardableResult
    private func anyElement(_ id: String) -> XCUIElement {
        app.descendants(matching: .any).matching(identifier: id).firstMatch
    }

    @discardableResult
    private func wait(
        _ id: String, timeout: TimeInterval = 6, file: StaticString = #filePath, line: UInt = #line
    ) -> XCUIElement {
        let candidates: [XCUIElement] = [
            app.buttons.matching(identifier: id).firstMatch,
            app.textFields.matching(identifier: id).firstMatch,
            anyElement(id),
        ]
        for candidate in candidates where candidate.waitForExistence(timeout: timeout) {
            return candidate
        }
        XCTAssertTrue(false, "Missing element \(id)", file: file, line: line)
        return candidates[0]
    }

    @discardableResult
    private func tap(_ id: String, timeout: TimeInterval = 8) -> XCUIElement {
        let e = wait(id, timeout: timeout)
        e.tap()
        return e
    }

    /// Path stops sit low in the 724-pt path canvas and end up behind the
    /// floating tab bar whenever anything above the path is tall (pending
    /// card, return card, day-complete state) — XCUI's center-tap then hits
    /// the tab and the player never opens. Scroll the stop clear of the bar
    /// before tapping, exactly what a user does. Same discipline as
    /// SmokeSuite's revealAndTap.
    private func revealAndTap(_ id: String, timeout: TimeInterval = 10) {
        let e = wait(id, timeout: timeout)
        let bar = app.buttons.matching(identifier: "au.tab.practice").firstMatch
        if bar.exists, e.frame.maxY > bar.frame.minY - 8 {
            let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.82))
            let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.62))
            start.press(forDuration: 0.02, thenDragTo: end)
        }
        e.tap()
    }

    private func onHome(timeout: TimeInterval = 10) -> Bool {
        if app.buttons["au.tab.learn"].exists { return true }
        return app.buttons.matching(identifier: "au.tab.learn").firstMatch.waitForExistence(
            timeout: timeout)
    }

    /// The authored tile answers, keyed by the sorted tile set: order-kind
    /// practice items, standalone tile/order tasks, and emailAssembly keys
    /// from a1-course.json (bundled with the UI-test target), plus option keys
    /// keyed by item ID.
    private static let (orderKeys, optionKeys, lessonCount):
        (
            [String: [String]], [String: String], Int
        ) = {
            guard
                let url = Bundle(for: MilestoneSuite.self).url(
                    forResource: "a1-course", withExtension: "json"),
                let data = try? Data(contentsOf: url),
                let chapters = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
            else { return ([:], [:], 0) }
            var oMap: [String: [String]] = [:]
            var pMap: [String: String] = [:]
            var lessonCount = 0
            func addOrder(_ tiles: [String]?, _ key: [String]?) {
                guard let tiles, let key, !tiles.isEmpty else { return }
                oMap[tiles.sorted().joined(separator: "\u{1F}")] = key
            }
            func addChoiceAsOrder(_ options: [[String: Any]]?, _ key: String?) {
                guard let options, let key else { return }
                let tiles = options.compactMap { $0["t"] as? String }
                guard
                    let answer = options.first(where: {
                        ($0["id"] as? String) == key || ($0["t"] as? String) == key
                    })?["t"] as? String
                else { return }
                addOrder(tiles, [answer])
            }
            for ch in chapters {
                let lessons = ch["lessons"] as? [[String: Any]] ?? []
                lessonCount += lessons.count
                for les in lessons {
                    for sc in les["screens"] as? [[String: Any]] ?? [] {
                        for it in sc["items"] as? [[String: Any]] ?? [] {
                            addOrder(it["tiles"] as? [String], it["key"] as? [String])
                            if let id = it["id"] as? String, let key = it["key"] as? String {
                                pMap[id] = key
                            }
                        }
                        for t in sc["tasks"] as? [[String: Any]] ?? [] {
                            addOrder(t["tiles"] as? [String], t["key"] as? [String])
                            addChoiceAsOrder(t["opts"] as? [[String: Any]], t["key"] as? String)
                            if let id = t["id"] as? String, let key = t["key"] as? String {
                                pMap[id] = key
                            }
                        }
                        // Meaning-pulse choices carry authored keys too
                        // (grammar screens); they surface through the same
                        // au.player.option.<id> contract as practice items.
                        for p in sc["meaningPulses"] as? [[String: Any]] ?? [] {
                            if let id = p["id"] as? String, let key = p["key"] as? String {
                                pMap[id] = key
                            }
                        }
                        addOrder(sc["tiles"] as? [String], sc["key"] as? [String])
                        if let id = sc["id"] as? String, let key = sc["key"] as? String {
                            pMap[id] = key
                        }
                    }
                }
            }
            return (oMap, pMap, lessonCount)
        }()

    /// The last bundled chapter hosts the plan-only successor, so it is the
    /// one surface where the next-chapter card keeps its access route.
    private static let lastAuthoredChapterIdx: Int = {
        guard
            let url = Bundle(for: MilestoneSuite.self).url(
                forResource: "a1-course", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let chapters = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
        else { return 0 }
        return max(0, chapters.count - 1)
    }()

    /// The practice Next/Go-on pill — only when actually tappable (the pill
    /// is rendered disabled at 0.45 opacity until the item is passable).
    private func enabledGoOn(timeout: TimeInterval = 0.5) -> XCUIElement? {
        let go = app.buttons["au.player.go-on"]
        if go.exists && go.isEnabled { return go }
        guard go.waitForExistence(timeout: timeout), go.isEnabled else { return nil }
        return go
    }

    /// Tap a button by identifier through a FRESH query with a real frame.
    /// An element reference captured even one statement earlier goes stale
    /// when the player advances screens — XCUI then taps a dying element
    /// whose frame resolves to {{inf, inf}, {0, 0}} and aborts the run (the
    /// historical "Failed to tap" failure class).
    @discardableResult
    private func tapFresh(_ id: String, timeout: TimeInterval = 2) -> Bool {
        let e = app.buttons[id]
        guard e.waitForExistence(timeout: timeout) else { return false }
        if !e.isHittable { app.swipeUp() }
        guard e.isHittable, !e.frame.isInfinite, !e.frame.isEmpty else { return false }
        e.tap()
        return true
    }

    /// The player's screen transition is the authored 0.42 s flow; advancing
    /// taps return while both screens are still mid-flight, so the next
    /// round's queries would catch the dying item mid-removal. Let the
    /// transition land before acting again.
    private func settleAfterAdvance() {
        usleep(450_000)
    }

    /// Order items: solve deterministically from the authored key — tap the
    /// tile buttons by label, in key order (fresh items only: the line starts
    /// empty because advance()/goto() reset the order).
    private func solveOrderItemIfPresent() -> Bool {
        let tiles = app.buttons.matching(
            NSPredicate(format: "identifier BEGINSWITH 'au.player.tile.'"))
        guard tiles.firstMatch.exists else { return false }
        let labels: [String] = (0..<tiles.count).compactMap { i in
            let t = tiles.element(boundBy: i)
            return t.exists ? t.label : nil
        }
        guard !labels.isEmpty,
            let key = Self.orderKeys[labels.sorted().joined(separator: "\u{1F}")]
        else { return false }
        var used: Set<Int> = []
        for word in key {
            let exact = (0..<tiles.count).first { index in
                guard !used.contains(index) else { return false }
                return tiles.element(boundBy: index).label == word
            }
            let flexible = (0..<tiles.count).first { index in
                guard !used.contains(index) else { return false }
                let label = tiles.element(boundBy: index).label
                if label.localizedCaseInsensitiveContains(word) { return true }
                if word.lowercased().hasSuffix("y") {
                    return label.lowercased().contains(
                        String(word.lowercased().dropLast()) + "ies")
                }
                return false
            }
            let index = exact ?? flexible
            guard let index else { return false }
            let tile = tiles.element(boundBy: index)
            if !tile.isHittable { app.swipeUp() }
            guard tile.exists, tile.isHittable else { return false }
            tile.tap()
            used.insert(index)
        }
        return true
    }

    /// Walk course screens until the lesson finishes and Home returns.
    /// Returns the number of advances performed. Cheap visible-state
    /// signature: leading static text labels + control count. Unchanged
    /// across rounds while the walker acts = true stall.
    private func stateSignature() -> String {
        let texts = app.staticTexts.allElementsBoundByIndex.prefix(5).map(\.label)
        let controls = app.buttons.count
        return texts.joined(separator: "|") + "#\(controls)"
    }

    @discardableResult
    private func walkLessonToEnd(timeout: TimeInterval = 480) -> Int {
        var advances = 0
        var stalledRounds = 0
        var signature = stateSignature()
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            // A player screen is the overwhelmingly common state in this
            // loop. Keep the negative Home probe short so exhaustive course
            // coverage does not add seconds of idle polling per item.
            if onHome(timeout: 0.15) { return advances }

            // Order items: solved from the authored key (fresh items only).
            if solveOrderItemIfPresent() {
                advances += 1
            }

            // Tap-only pair and sort activities use deterministic semantic
            // controls while preserving the learner's actual interaction.
            for index in 0..<20 {
                let cue = app.buttons["au.player.match.cue.\(index)"]
                guard cue.exists else { break }
                let answer = app.buttons["au.player.match.answer.\(index)"]
                if !cue.isHittable { app.swipeUp() }
                if cue.isHittable, answer.exists, answer.isHittable {
                    cue.tap()
                    answer.tap()
                    advances += 2
                }
            }
            for index in 0..<20 {
                let answer = app.buttons["au.player.sort.correct.\(index)"]
                guard answer.exists else { break }
                if !answer.isHittable { app.swipeUp() }
                if answer.isHittable {
                    answer.tap()
                    advances += 1
                }
            }

            // Some long practice banks surface a learner-controlled pause
            // card in place of the item controls. Continue is the bounded
            // route through the lesson; Break intentionally exits it.
            let pauseContinue = app.buttons["au.player.pause-card.continue"]
            if pauseContinue.exists {
                if !pauseContinue.isHittable { app.swipeUp() }
                if pauseContinue.exists, pauseContinue.isHittable {
                    pauseContinue.tap()
                    advances += 1
                    continue
                }
            }

            // Roleplay: choose one visible reply per guided step. Speaking is
            // optional pronunciation practice and must never auto-answer.
            let roleplayExit = app.buttons["au.player.roleplay.safe-stop"]
            if roleplayExit.exists {
                for _ in 0..<8 {
                    let tile = app.buttons.matching(
                        NSPredicate(
                            format: "identifier BEGINSWITH 'au.player.roleplay.tile.'")
                    ).firstMatch
                    guard tile.exists else { break }
                    if !tile.isHittable { app.swipeUp() }
                    if tile.exists, tile.isHittable {
                        tile.tap()
                        advances += 1
                    }
                }

                let goOn = app.buttons["au.btn.go-on"]
                if !goOn.isHittable { app.swipeUp() }
                if goOn.exists, goOn.isHittable {
                    goOn.tap()
                    advances += 1
                    continue
                }

                if !roleplayExit.isHittable { app.swipeUp() }
                if roleplayExit.exists, roleplayExit.isHittable {
                    roleplayExit.tap()
                    advances += 1
                    continue
                }
            }

            // Practice options: solve directly from authored key if known, else climb retry ladder
            let options = app.buttons.matching(
                NSPredicate(format: "identifier BEGINSWITH 'au.player.option.'"))
            if options.firstMatch.exists {
                var solved = false
                let fixture = app.descendants(matching: .any).matching(
                    NSPredicate(format: "identifier BEGINSWITH 'au.player.fixture.item.'")
                ).firstMatch
                var candidateIDs: [String] = []
                if fixture.exists {
                    candidateIDs.append(
                        fixture.identifier.replacingOccurrences(
                            of: "au.player.fixture.item.", with: ""))
                }
                candidateIDs.append(
                    contentsOf: app.staticTexts.allElementsBoundByIndex.prefix(6).map(\.label))
                for id in candidateIDs {
                    if let key = Self.optionKeys[id],
                        tapFresh("au.player.option.\(key)")
                    {
                        advances += 1
                        settleAfterAdvance()
                        solved = true
                        break
                    }
                }
                if !solved {
                    var picks = 0
                    let n = max(1, options.count)
                    while picks < 4, enabledGoOn(timeout: 0.5) == nil {
                        let option = options.element(boundBy: picks % n)
                        if option.exists {
                            if !option.isHittable { app.swipeUp() }
                            if option.isHittable, !option.frame.isInfinite {
                                option.tap()
                                advances += 1
                                settleAfterAdvance()
                            }
                        }
                        picks += 1
                    }
                }
            }

            // Substitution chips: pick the first chip in each slot group.
            let chips = app.buttons.matching(
                NSPredicate(format: "identifier BEGINSWITH 'au.player.chip.'"))
            if chips.firstMatch.exists {
                var idx = 0
                while true {
                    let chip = chips.element(boundBy: idx)
                    guard chip.exists, chip.isHittable else { break }
                    chip.tap()
                    advances += 1
                    idx += 1
                }
            }

            // The gated pill — only when enabled.
            if let go = enabledGoOn(timeout: 0.25) {
                if !go.isHittable { app.swipeUp() }
                go.tap()
                advances += 1
                continue
            }

            // Generic advancement: any *enabled* au.btn.* CTA on this screen
            // (Check / Next card / Go on / Skip — say it later …). Disabled
            // ones are skipped — the option/order passes above satisfy them.
            let ctas = app.buttons.matching(
                NSPredicate(format: "identifier BEGINSWITH 'au.btn.' AND enabled == true"))
            var tapped = false
            for i in 0..<max(ctas.count, 4) {
                let cta = ctas.element(boundBy: i)
                guard cta.exists else { continue }
                if !cta.isHittable {
                    app.swipeUp()
                }
                guard cta.isHittable || cta.exists else { continue }
                cta.tap()
                advances += 1
                tapped = true
                break
            }
            if !tapped, !options.firstMatch.exists {
                // A screen type without an exposed control — tap the screen
                // center (the promise screen's "tap anywhere").
                app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.6)).tap()
                advances += 1
            }

            let newSignature = stateSignature()
            if newSignature == signature {
                stalledRounds += 1
                if stalledRounds == 6 {
                    let tree = XCTAttachment(string: app.debugDescription)
                    tree.lifetime = .keepAlways
                    tree.name = "walker-stall-tree.txt"
                    add(tree)
                    let shot = XCTAttachment(screenshot: app.screenshot())
                    shot.lifetime = .keepAlways
                    shot.name = "walker-stall.png"
                    add(shot)
                    XCTFail("Walker stalled — screen unchanged for 6 rounds; tree attached")
                    return advances
                }
            } else {
                stalledRounds = 0
                signature = newSignature
            }
        }
        let shot = XCTAttachment(screenshot: app.screenshot())
        shot.lifetime = .keepAlways
        shot.name = "walker-stall.png"
        add(shot)
        XCTFail("Lesson did not finish within \(timeout)s")
        return advances
    }

    // MARK: 1 — the starter lesson, end to end

    func test1FirstLessonEndToEnd() {
        app.launch()
        XCTAssertTrue(onHome(timeout: 30))
        revealAndTap("au.home.node.0")
        XCTAssertTrue(
            app.buttons.matching(identifier: "au.player.close").firstMatch.waitForExistence(
                timeout: 10))

        let advances = walkLessonToEnd()
        XCTAssertGreaterThan(advances, 10, "the starter lesson has more than ten screens")
        XCTAssertTrue(onHome(), "finishing the lesson must return Home")
    }

    // MARK: 2 — background and resume mid-lesson (twice)

    func test2BackgroundResumeMidLesson() {
        app.launch()
        XCTAssertTrue(onHome(timeout: 30))
        revealAndTap("au.home.node.0")
        XCTAssertTrue(
            app.buttons.matching(identifier: "au.player.close").firstMatch.waitForExistence(
                timeout: 10))

        for cycle in 0..<2 {
            for _ in 0...cycle {
                let go = app.buttons.matching(identifier: "au.player.go-on").firstMatch
                if go.waitForExistence(timeout: 4) { go.tap() }
            }
            XCUIDevice.shared.press(.home)
            sleep(2)
            app.activate()
            XCTAssertTrue(
                app.buttons.matching(identifier: "au.player.close").firstMatch.waitForExistence(
                    timeout: 10),
                "cycle \(cycle): the player must survive backgrounding")
        }

        walkLessonToEnd()
        XCTAssertTrue(onHome())
    }

    // MARK: 3 — Dynamic Type at AX sizes (run on matrix devices via run-ui-ax.sh)

    func test3DynamicTypeAXHittability() {
        app.launchArguments = [
            "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL",
            "-AUREL_TEST_START", "home",
        ]
        app.launch()  // setUp's fast path + the AX content size
        XCTAssertTrue(onHome(timeout: 30))

        let window = app.windows.firstMatch
        func assertUsable(_ id: String, file: StaticString = #filePath, line: UInt = #line) {
            let e = wait(id, timeout: 10, file: file, line: line)
            if !e.isHittable {
                app.swipeUp()
            }
            XCTAssertTrue(e.isHittable, "\(id) not hittable at AX3XL", file: file, line: line)
            XCTAssertTrue(
                window.frame.contains(e.frame),
                "\(id) frame \(e.frame) outside window \(window.frame)",
                file: file, line: line)
        }
        assertUsable("au.tab.learn")
        assertUsable("au.tab.practice")
        assertUsable("au.home.profile")
        assertUsable("au.tab.settings")

        // Settings surface at AX size.
        tap("au.tab.settings")
        assertUsable("au.settings.type.0")
        assertUsable("au.settings.type.4")
    }

    // MARK: 4 — tab matrix + settings/paywall round trip

    func test4TabMatrixAndSettingsPaywall() {
        app.launch()
        XCTAssertTrue(onHome(timeout: 30))

        for tab in ["au.tab.practice", "au.tab.progress", "au.tab.settings", "au.tab.learn"] {
            tap(tab, timeout: 10)
        }
        XCTAssertTrue(onHome())

        tap("au.tab.settings")
        tap("au.settings.type.4")  // Largest
        tap("au.settings.type.2")  // back to Default
        // Settings is a tab surface — leave through the tab bar.
        tap("au.tab.learn")
        XCTAssertTrue(onHome(timeout: 10))

        // A locked chapter is never a dead end. The access route lives on the
        // LAST authored chapter — its successor is planned but not bundled,
        // so the card keeps the paywall route there (on earlier chapters the
        // card opens the bundled successor directly on Home). Park the shell
        // on the last chapter with the verification hook, then tap through.
        app.terminate()
        app.launchArguments = [
            "-AUREL_TEST_RESET", "-AUREL_TEST_START", "home",
            "-AUREL_CHAPTER_INDEX", "\(Self.lastAuthoredChapterIdx)",
        ]
        app.launch()
        XCTAssertTrue(onHome(timeout: 10))

        let next = app.buttons.matching(identifier: "au.home.next-chapter").firstMatch
        XCTAssertTrue(next.waitForExistence(timeout: 8))
        XCTAssertTrue(next.isEnabled, "locked chapter must offer a clear next action")
        // Scroll the card clear of the floating tab bar before tapping.
        for _ in 0..<6 where !next.isHittable {
            app.swipeUp()
        }
        XCTAssertTrue(next.isHittable, "the next-chapter card never scrolled into view")
        next.tap()
        XCTAssertTrue(
            anyElement("au.capability.chapters-unavailable").waitForExistence(timeout: 8),
            "the plan-only next chapter must open its access route")
    }

    // MARK: PH-00 — safe capability routes

    func test6Phase00ReleaseSafetySurfaces() {
        for (screen, rootID) in [
            ("paywall", "au.capability.chapters-unavailable"),
            ("subscribeAccount", "au.capability.account-subscription-unavailable"),
        ] {
            app.launchArguments = ["-AUREL_TEST_START", screen]
            app.launch()

            let root = anyElement(rootID)
            XCTAssertTrue(root.waitForExistence(timeout: 10))
            let back = wait("\(rootID).back", timeout: 5)
            let window = app.windows.firstMatch
            XCTAssertTrue(
                window.frame.contains(root.frame), "\(screen) content must stay in the window")
            XCTAssertTrue(
                window.frame.contains(back.frame), "\(screen) action must clear system chrome")
            XCTAssertTrue(back.isHittable)
            app.terminate()
        }
    }

    // MARK: 5 — Lesson 2 end to end (S0-002 UI regression: L2's practice
    // screens carry "Put in order" items whose Go-on used to stay disabled
    // forever — the course dead-ended here)

    func test5SecondLessonEndToEnd() {
        app.launch()
        XCTAssertTrue(onHome(timeout: 30))
        // test1 finished L1, so the open node is L2 ("You and Your Name").
        revealAndTap("au.home.node.1", timeout: 10)
        XCTAssertTrue(
            app.buttons.matching(identifier: "au.player.close").firstMatch.waitForExistence(
                timeout: 10))

        let advances = walkLessonToEnd()
        XCTAssertGreaterThan(advances, 10, "L2 (10 screens, 31 items) is a full walk")
        XCTAssertTrue(onHome(), "finishing L2 must return Home")
    }

    // MARK: PH-01 — every authored lesson has a bounded completion path

    func test7AllAuthoredLessonsCompleteFromDeterministicFixtures() {
        XCTAssertGreaterThan(Self.lessonCount, 0, "course fixture must contain lessons")
        for lessonIndex in 0..<Self.lessonCount {
            app.terminate()
            app.launchArguments = ["-AUREL_TEST_RESET", "-AUREL_LESSON_INDEX", "\(lessonIndex)"]
            app.launch()
            XCTAssertTrue(
                app.buttons.matching(identifier: "au.player.close").firstMatch
                    .waitForExistence(timeout: 12),
                "lesson fixture \(lessonIndex) did not launch")
            // Dense authored banks reach 67 items; the unchanged-state gate
            // remains strict while wall-clock allowance scales to the data.
            let advances = walkLessonToEnd(timeout: 600)
            XCTAssertGreaterThan(
                advances, 0, "lesson fixture \(lessonIndex) did not expose a completion path")
            XCTAssertTrue(onHome(), "lesson fixture \(lessonIndex) did not return Home")
        }
    }

    /// Regression for the densest Chapter 1 route: mixed tile variants feed
    /// a roleplay whose Speak action remains on-screen until Safe stop exits.
    func test8FourthLessonMixedTilesAndRoleplayComplete() {
        app.launchArguments = ["-AUREL_TEST_RESET", "-AUREL_LESSON_INDEX", "3"]
        app.launch()
        XCTAssertTrue(
            app.buttons.matching(identifier: "au.player.close").firstMatch
                .waitForExistence(timeout: 12))
        let advances = walkLessonToEnd(timeout: 600)
        XCTAssertGreaterThan(advances, 0)
        XCTAssertTrue(onHome(), "fourth lesson did not return Home")
    }

    /// A focused regression for the first Chapter 3 route, whose repeated
    /// card/practice alternation exercises the walker's choice transitions.
    func test9NinthLessonCardPracticeSequenceCompletes() {
        app.launchArguments = ["-AUREL_TEST_RESET", "-AUREL_LESSON_INDEX", "8"]
        app.launch()
        XCTAssertTrue(
            app.buttons.matching(identifier: "au.player.close").firstMatch
                .waitForExistence(timeout: 12))
        let advances = walkLessonToEnd(timeout: 600)
        XCTAssertGreaterThan(advances, 0)
        XCTAssertTrue(onHome(), "ninth lesson did not return Home")
    }

    /// Focused tail coverage keeps failures in the later grammar, reading,
    /// mission, and checkpoint fixtures quick to diagnose.
    func test10RemainingAuthoredLessonsComplete() {
        for lessonIndex in 9..<Self.lessonCount {
            app.terminate()
            app.launchArguments = ["-AUREL_TEST_RESET", "-AUREL_LESSON_INDEX", "\(lessonIndex)"]
            app.launch()
            XCTAssertTrue(
                app.buttons.matching(identifier: "au.player.close").firstMatch
                    .waitForExistence(timeout: 12),
                "lesson fixture \(lessonIndex) did not launch")
            let advances = walkLessonToEnd(timeout: 600)
            XCTAssertGreaterThan(advances, 0)
            XCTAssertTrue(onHome(), "lesson fixture \(lessonIndex) did not return Home")
        }
    }
}
