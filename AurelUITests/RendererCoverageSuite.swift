import XCTest

/// PH-01 runtime inventory gate. Every kind is entered from the first stable
/// authored occurrence, rendered by the real player, captured, and exited
/// through the real close path.
@MainActor
final class RendererCoverageSuite: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() async throws {
        try await super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    private static let authoredKinds: [String] = {
        guard
            let url = Bundle(for: RendererCoverageSuite.self).url(
                forResource: "a1-course", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let chapters = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
        else { return [] }

        var kinds: Set<String> = []
        for chapter in chapters {
            for lesson in chapter["lessons"] as? [[String: Any]] ?? [] {
                for screen in lesson["screens"] as? [[String: Any]] ?? [] {
                    if let kind = screen["type"] as? String { kinds.insert(kind) }
                }
            }
        }
        return kinds.sorted()
    }()

    /// One representative from every renderer family. This keeps boundary-
    /// device runs proportional while the 29-kind test remains exhaustive.
    private static let representativeKinds = [
        "promise", "cards", "practice", "grammarModel", "tiles",
        "pronPerceive", "conversation", "missionBrief", "results", "review",
    ]

    private func anyElement(_ identifier: String) -> XCUIElement {
        app.descendants(matching: .any).matching(identifier: identifier).firstMatch
    }

    func testAll29AuthoredKindsRenderAndExit() {
        XCTAssertEqual(Self.authoredKinds.count, 29, "the authored renderer inventory changed")
        var leakedAuthoringTokens: [String] = []

        for kind in Self.authoredKinds {
            app.launchArguments = ["-AUREL_TEST_RESET", "-AUREL_RENDERER_KIND", kind]
            app.launch()

            let root = anyElement("au.player.kind.\(kind)")
            XCTAssertTrue(root.waitForExistence(timeout: 12), "\(kind) did not render")
            let authoringToken = app.staticTexts.matching(
                NSPredicate(
                    format: "label MATCHES[c] %@",
                    ".*(A1-C[0-9]+|AUD[0-9]+|ILL[0-9]+|RP[0-9]+).*")
            )
            .firstMatch
            if authoringToken.exists {
                leakedAuthoringTokens.append("\(kind): \(authoringToken.label)")
            }
            let close = app.buttons.matching(identifier: "au.player.close").firstMatch
            XCTAssertTrue(close.waitForExistence(timeout: 4), "\(kind) has no exit path")
            XCTAssertTrue(close.isHittable, "\(kind) exit is not hittable")

            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.name = "renderer-\(kind).png"
            screenshot.lifetime = .keepAlways
            add(screenshot)

            close.tap()
            XCTAssertTrue(
                app.buttons.matching(identifier: "au.tab.learn").firstMatch
                    .waitForExistence(timeout: 8),
                "\(kind) did not exit to Home")
            app.terminate()
        }

        XCTAssertTrue(
            leakedAuthoringTokens.isEmpty,
            "internal authoring tokens reached renderer UI: \(leakedAuthoringTokens.joined(separator: "; "))"
        )
    }

    /// Production-art gate for the complete first vocabulary set. This walks
    /// the real card pager so every commissioned image is exercised at its
    /// actual 16:9 rounded placement, not only validated as a catalog bitmap.
    func testLessonOneGreetingCardArtworkPagesRenderAndNavigate() {
        let expectedWords = [
            "hello", "hi", "good morning", "good afternoon",
            "good evening", "goodbye", "bye", "see you",
        ]

        app.launchArguments = ["-AUREL_TEST_RESET", "-AUREL_RENDERER_KIND", "cards"]
        app.launch()

        let root = anyElement("au.player.kind.cards")
        XCTAssertTrue(root.waitForExistence(timeout: 12), "the Lesson 1 card set did not render")

        for (index, word) in expectedWords.enumerated() {
            let wordLabel = app.staticTexts[word]
            XCTAssertTrue(wordLabel.waitForExistence(timeout: 5), "missing card \(index + 1): \(word)")
            // SwiftUI exposes the incoming label before the asymmetric pager
            // transition has visually settled. Preserve the finished state,
            // not an animation frame, as production-art evidence.
            Thread.sleep(forTimeInterval: 0.6)

            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.name = "lesson-1-set-a-\(index + 1)-\(word).png"
            screenshot.lifetime = .keepAlways
            add(screenshot)

            guard index + 1 < expectedWords.count else { continue }
            let next = app.buttons["Next card"]
            XCTAssertTrue(next.waitForExistence(timeout: 4), "card \(word) has no next action")
            XCTAssertTrue(next.isHittable, "card \(word) next action is not hittable")
            next.tap()
        }

        XCTAssertTrue(app.buttons["Go on"].waitForExistence(timeout: 4))
    }

    /// Production-art gate for the second Lesson 1 vocabulary set. The
    /// verification-only authored-screen route opens S07 directly; the test
    /// still exercises every image through the real card pager and layout.
    func testLessonOnePoliteWordCardArtworkPagesRenderAndNavigate() {
        let expectedWords = [
            "please", "thank you", "thanks", "sorry", "excuse me", "yes", "no",
        ]

        app.launchArguments = [
            "-AUREL_TEST_RESET", "-AUREL_COURSE_SCREEN", "A1-C01", "L01", "S07",
        ]
        app.launch()

        let root = anyElement("au.player.kind.cards")
        XCTAssertTrue(root.waitForExistence(timeout: 12), "the Lesson 1 polite-word set did not render")

        for (index, word) in expectedWords.enumerated() {
            let wordLabel = app.staticTexts[word]
            XCTAssertTrue(wordLabel.waitForExistence(timeout: 5), "missing card \(index + 1): \(word)")
            // SwiftUI exposes the incoming label before the asymmetric pager
            // transition has visually settled. Preserve the finished state,
            // not an animation frame, as production-art evidence.
            Thread.sleep(forTimeInterval: 0.6)

            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.name = "lesson-1-set-b-\(index + 1)-\(word).png"
            screenshot.lifetime = .keepAlways
            add(screenshot)

            guard index + 1 < expectedWords.count else { continue }
            let next = app.buttons["Next card"]
            XCTAssertTrue(next.waitForExistence(timeout: 4), "card \(word) has no next action")
            XCTAssertTrue(next.isHittable, "card \(word) next action is not hittable")
            next.tap()
        }

        XCTAssertTrue(app.buttons["Go on"].waitForExistence(timeout: 4))
    }

    /// Production-art gate for Lesson 2's state vocabulary. The authored
    /// screen begins with its required meaning bridge, so this test completes
    /// that bridge before walking all five cards through the real pager.
    func testLessonTwoStateCardArtworkPagesRenderAndNavigate() {
        app.launchArguments = [
            "-AUREL_TEST_RESET", "-AUREL_COURSE_SCREEN", "A1-C01", "L02", "S11",
        ]
        app.launch()

        let root = anyElement("au.player.kind.cards")
        XCTAssertTrue(root.waitForExistence(timeout: 12), "the Lesson 2 state-card set did not render")

        let bridgeAnswers = ["A", "B", "A"]
        for (index, answer) in bridgeAnswers.enumerated() {
            let option = app.buttons["au.player.option.\(answer)"]
            XCTAssertTrue(option.waitForExistence(timeout: 5), "meaning bridge \(index + 1) has no answer")
            for _ in 0..<5 where !option.isHittable { app.swipeUp() }
            XCTAssertTrue(option.isHittable, "meaning bridge \(index + 1) answer is not hittable")
            option.tap()

            let actionTitle = index + 1 < bridgeAnswers.count ? "Next example" : "Start practice"
            let action = app.buttons[actionTitle]
            XCTAssertTrue(action.waitForExistence(timeout: 5), "meaning bridge \(index + 1) did not advance")
            for _ in 0..<5 where !action.isHittable { app.swipeUp() }
            XCTAssertTrue(action.isHittable, "meaning bridge \(index + 1) action is not hittable")
            action.tap()
        }

        let expectedWords = ["good", "fine", "okay", "great", "not bad"]
        for (index, word) in expectedWords.enumerated() {
            let wordLabel = app.staticTexts[word]
            XCTAssertTrue(wordLabel.waitForExistence(timeout: 5), "missing card \(index + 1): \(word)")
            for _ in 0..<4 { app.swipeDown() }
            Thread.sleep(forTimeInterval: 0.6)

            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.name = "lesson-2-set-c-\(index + 1)-\(word).png"
            screenshot.lifetime = .keepAlways
            add(screenshot)

            guard index + 1 < expectedWords.count else { continue }
            let next = app.buttons["Next card"]
            XCTAssertTrue(next.waitForExistence(timeout: 4), "card \(word) has no next action")
            for _ in 0..<4 where !next.isHittable { app.swipeUp() }
            XCTAssertTrue(next.isHittable, "card \(word) next action is not hittable")
            next.tap()
        }

        XCTAssertTrue(app.buttons["Go on"].waitForExistence(timeout: 4))
    }

    /// Production-art and badge-schema gate for Lesson 2's seven name cards.
    /// The first three cards reuse one illustration with authored both/top/
    /// bottom highlights; the remaining cards exercise the dialogue scenes.
    func testLessonTwoNameCardArtworkPagesRenderAndNavigate() {
        let expectedWords = [
            "name", "first name", "last name", "My name is …",
            "I'm …", "What's your name?", "Nice to meet you",
        ]
        let expectedCredentials = [
            "Badge fields: first name and last name.",
            "Badge fields: first name and last name.",
            "Badge fields: first name and last name.",
            "Badges: Alex Kim and Maya Haddad.",
            "Badges: Alex Kim and Maya Haddad.",
            "Badges: Alex Kim and Maya Haddad.",
            "Badges: Nina Petrova and Leo Novak.",
        ]

        app.launchArguments = [
            "-AUREL_TEST_RESET", "-AUREL_COURSE_SCREEN", "A1-C01", "L02", "S12",
        ]
        app.launch()

        let root = anyElement("au.player.kind.cards")
        XCTAssertTrue(root.waitForExistence(timeout: 12), "the Lesson 2 name-card set did not render")

        for (index, word) in expectedWords.enumerated() {
            let wordLabel = app.staticTexts[word]
            XCTAssertTrue(wordLabel.waitForExistence(timeout: 5), "missing card \(index + 1): \(word)")
            let credentials = app.descendants(matching: .any)
                .matching(NSPredicate(format: "label CONTAINS[c] %@", expectedCredentials[index]))
                .firstMatch
            XCTAssertTrue(
                credentials.waitForExistence(timeout: 5),
                "card \(word) has missing or incorrect badge credentials"
            )
            for _ in 0..<4 { app.swipeDown() }
            Thread.sleep(forTimeInterval: 0.6)

            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.name = "lesson-2-names-\(index + 1).png"
            screenshot.lifetime = .keepAlways
            add(screenshot)

            guard index + 1 < expectedWords.count else { continue }
            let next = app.buttons["Next card"]
            XCTAssertTrue(next.waitForExistence(timeout: 4), "card \(word) has no next action")
            for _ in 0..<4 where !next.isHittable { app.swipeUp() }
            XCTAssertTrue(next.isHittable, "card \(word) next action is not hittable")
            next.tap()
        }

        XCTAssertTrue(app.buttons["Go on"].waitForExistence(timeout: 4))
    }

    /// Production-art gate for the reciprocal state-question scene reused by
    /// both the opening and returning questions in Lesson 2's Set E cards.
    func testLessonTwoQuestionCardArtworkPagesRenderAndNavigate() {
        let expectedWords = ["How are you?", "I'm good/fine/okay", "And you?"]
        let expectedCredentials: [String?] = [
            "Badges: Leo Novak and Maya Haddad.",
            nil,
            "Badges: Leo Novak and Maya Haddad.",
        ]

        app.launchArguments = [
            "-AUREL_TEST_RESET", "-AUREL_COURSE_SCREEN", "A1-C01", "L02", "S15",
        ]
        app.launch()

        let root = anyElement("au.player.kind.cards")
        XCTAssertTrue(root.waitForExistence(timeout: 12), "the Lesson 2 question-card set did not render")

        for (index, word) in expectedWords.enumerated() {
            let wordLabel = app.staticTexts[word]
            XCTAssertTrue(wordLabel.waitForExistence(timeout: 5), "missing card \(index + 1): \(word)")
            if let expectedCredential = expectedCredentials[index] {
                let credentials = app.descendants(matching: .any)
                    .matching(NSPredicate(
                        format: "label CONTAINS[c] %@",
                        expectedCredential
                    ))
                    .firstMatch
                XCTAssertTrue(
                    credentials.waitForExistence(timeout: 5),
                    "card \(word) has missing or incorrect badge credentials"
                )
            }
            for _ in 0..<4 { app.swipeDown() }
            Thread.sleep(forTimeInterval: 0.6)

            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.name = "lesson-2-questions-\(index + 1).png"
            screenshot.lifetime = .keepAlways
            add(screenshot)

            guard index + 1 < expectedWords.count else { continue }
            let next = app.buttons["Next card"]
            XCTAssertTrue(next.waitForExistence(timeout: 4), "card \(word) has no next action")
            for _ in 0..<4 where !next.isHittable { app.swipeUp() }
            XCTAssertTrue(next.isHittable, "card \(word) next action is not hittable")
            next.tap()
        }

        XCTAssertTrue(app.buttons["Go on"].waitForExistence(timeout: 4))
    }

    /// Production-art gate for Lesson 3's five-panel conversation sequence.
    /// Every thumbnail is tapped so the prominent panel, selection outline,
    /// and turn-to-scene mapping are exercised in the real conversation view.
    func testLessonThreeStoryboardArtworkPanelsRenderAndSelect() {
        app.launchArguments = [
            "-AUREL_TEST_RESET", "-AUREL_COURSE_SCREEN", "A1-C01", "L03", "S20",
        ]
        app.launch()

        let root = anyElement("au.player.kind.conversation")
        XCTAssertTrue(root.waitForExistence(timeout: 12), "the Lesson 3 storyboard did not render")

        for scene in 1...5 {
            let selector = app.buttons["Show conversation scene \(scene)"]
            XCTAssertTrue(selector.waitForExistence(timeout: 5), "missing storyboard scene \(scene)")
            for _ in 0..<4 where !selector.isHittable { app.swipeDown() }
            XCTAssertTrue(selector.isHittable, "storyboard scene \(scene) is not selectable")
            selector.tap()
            // Let the player-wide turn transition finish before preserving
            // visual evidence; otherwise XCTest can capture a half-shifted
            // frame even though the settled layout is correct.
            Thread.sleep(forTimeInterval: 1.2)

            let credentials = app.descendants(matching: .any)
                .matching(NSPredicate(
                    format: "label CONTAINS[c] %@",
                    "Badges: Nina Petrova and Maya Haddad."
                ))
                .firstMatch
            XCTAssertTrue(
                credentials.waitForExistence(timeout: 5),
                "storyboard scene \(scene) has missing or incorrect badge credentials"
            )

            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.name = "lesson-3-storyboard-\(scene).png"
            screenshot.lifetime = .keepAlways
            add(screenshot)
        }
    }

    /// Production-art gate for the distinct afternoon café challenge scene.
    func testLessonThreeCafeChallengeArtworkRenders() {
        app.launchArguments = [
            "-AUREL_TEST_RESET", "-AUREL_COURSE_SCREEN", "A1-C01", "L03", "S23",
        ]
        app.launch()

        let root = anyElement("au.player.kind.testlet")
        XCTAssertTrue(root.waitForExistence(timeout: 12), "the Lesson 3 challenge testlet did not render")
        let illustration = app.descendants(matching: .any)
            .matching(NSPredicate(format: "label == %@", "A café terrace in bright afternoon light"))
            .firstMatch
        XCTAssertTrue(illustration.waitForExistence(timeout: 5), "the café challenge art is absent")
        for _ in 0..<4 where !illustration.isHittable { app.swipeUp() }
        Thread.sleep(forTimeInterval: 1.2)

        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "lesson-3-cafe-challenge.png"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }

    /// Production-art and app-layer typography gate for the Lesson 3 badge
    /// pair and welcome card. Text must remain selectable/accessibility-visible
    /// while visually aligning to the generated blank regions.
    func testLessonThreeReadingSurfaceArtworkAndOverlaysRender() {
        let screens = [
            (id: "S27", title: "MAYA HADDAD", filename: "lesson-3-badge-reading.png"),
            (id: "S28", title: "Welcome! My name is Alex.", filename: "lesson-3-welcome-card.png"),
        ]

        for screen in screens {
            app.launchArguments = [
                "-AUREL_TEST_RESET", "-AUREL_COURSE_SCREEN", "A1-C01", "L03", screen.id,
            ]
            app.launch()

            let root = anyElement("au.player.kind.reading")
            XCTAssertTrue(root.waitForExistence(timeout: 12), "\(screen.id) did not render")
            let surface = app.descendants(matching: .any)
                .matching(NSPredicate(format: "label CONTAINS[c] %@", screen.title))
                .firstMatch
            XCTAssertTrue(surface.waitForExistence(timeout: 5), "\(screen.id) overlay text is absent")
            for _ in 0..<4 { app.swipeDown() }
            Thread.sleep(forTimeInterval: 1.2)

            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.name = screen.filename
            screenshot.lifetime = .keepAlways
            add(screenshot)
            app.terminate()
        }
    }

    /// Chapter 1 closeout gate for the four live Lesson 4 illustrations and
    /// the conditional Sam Rivera badge typography. Grammar/listening items
    /// show only exact field labels; the reading item fills the badge with the
    /// values it explicitly asks the learner to read.
    func testChapterOneCloseoutQuizArtworkAndBadgeStatesRender() {
        let itemIDs = [
            "QZ-V001", "QZ-V002", "QZ-V003", "QZ-V004", "QZ-V005", "QZ-V006",
            "QZ-G001", "QZ-G002", "QZ-G003", "QZ-G004", "QZ-G005", "QZ-G006",
            "QZ-LS001", "QZ-LS002", "QZ-LS003", "QZ-LS004", "QZ-RD001",
        ]
        let evidenceNames = [
            1: "chapter-1-closeout-sam-arrives.png",
            3: "chapter-1-closeout-box-exchange.png",
            5: "chapter-1-closeout-time-triptych.png",
            6: "chapter-1-credential-badge-fields.png",
            16: "chapter-1-closeout-badge-sam-rivera.png",
        ]

        app.launchArguments = [
            "-AUREL_TEST_RESET", "-AUREL_COURSE_SCREEN", "A1-C01", "L04", "S33",
        ]
        app.launch()

        let root = anyElement("au.player.kind.quiz")
        XCTAssertTrue(root.waitForExistence(timeout: 12), "the Chapter 1 quiz did not render")

        for (index, itemID) in itemIDs.enumerated() {
            let item = anyElement("au.player.fixture.item.\(itemID)")
            XCTAssertTrue(item.waitForExistence(timeout: 6), "missing quiz item \(itemID)")

            if index == 6 {
                let badgeFields = anyElement("au.player.badge.fields")
                XCTAssertTrue(
                    badgeFields.waitForExistence(timeout: 5),
                    "the grammar badge is missing FIRST NAME / LAST NAME fields"
                )
                XCTAssertEqual(
                    badgeFields.label,
                    "Name badge fields. First name. Last name."
                )
                XCTAssertFalse(
                    anyElement("au.player.badge.sam-rivera").exists,
                    "the grammar badge must not disclose Sam Rivera")
            }
            if index == 16 {
                let populatedBadge = anyElement("au.player.badge.sam-rivera")
                XCTAssertTrue(
                    populatedBadge.waitForExistence(timeout: 5),
                    "the reading badge is missing SAM / RIVERA")
                XCTAssertEqual(populatedBadge.label, "Sam Rivera badge")
            }

            if let evidenceName = evidenceNames[index] {
                Thread.sleep(forTimeInterval: 0.8)
                let screenshot = XCTAttachment(screenshot: app.screenshot())
                screenshot.name = evidenceName
                screenshot.lifetime = .keepAlways
                add(screenshot)
            }

            guard index + 1 < itemIDs.count else { continue }
            let goOn = app.buttons["au.player.go-on"]
            XCTAssertTrue(goOn.waitForExistence(timeout: 5), "\(itemID) has no Go on action")
            XCTAssertTrue(goOn.isEnabled, "\(itemID) unexpectedly blocks quiz navigation")
            if !goOn.isHittable { app.swipeUp() }
            XCTAssertTrue(goOn.isHittable, "\(itemID) Go on action is not tappable")
            goOn.tap()
        }
    }

    func testPseudolanguageAndAXLayoutKeepsCoreNavigationUsable() {
        app.launchArguments = [
            "-AUREL_TEST_RESET", "-AUREL_TEST_START", "home",
            "-NSDoubleLocalizedStrings", "YES",
            "-NSDoubleLocalizedStringsIncludeDefault", "YES",
            "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL",
        ]
        app.launch()

        let window = app.windows.firstMatch
        XCTAssertTrue(window.waitForExistence(timeout: 10))
        for identifier in ["au.tab.learn", "au.tab.practice", "au.tab.progress", "au.tab.settings"] {
            let element = app.buttons.matching(identifier: identifier).firstMatch
            XCTAssertTrue(element.waitForExistence(timeout: 8), "missing \(identifier)")
            XCTAssertTrue(window.frame.contains(element.frame), "\(identifier) escapes the window")
            XCTAssertTrue(element.isHittable, "\(identifier) is not usable")
        }

        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "pseudolanguage-home-ax3xl.png"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }

    func testRepresentativeFamiliesAtAccessibilitySizeAndReducedMotion() {
        for kind in Self.representativeKinds {
            app.launchArguments = [
                "-AUREL_TEST_RESET", "-AUREL_RENDERER_KIND", kind,
                "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL",
                "-UIAccessibilityReduceMotionEnabled", "YES",
                "-UIAccessibilityDarkerSystemColorsEnabled", "YES",
            ]
            app.launch()

            let root = anyElement("au.player.kind.\(kind)")
            XCTAssertTrue(root.waitForExistence(timeout: 12), "\(kind) did not render at AX3XL")
            let close = app.buttons.matching(identifier: "au.player.close").firstMatch
            XCTAssertTrue(close.waitForExistence(timeout: 5), "\(kind) has no close action")
            XCTAssertTrue(
                app.windows.firstMatch.frame.contains(close.frame),
                "\(kind) close escaped the window")
            XCTAssertTrue(close.isHittable, "\(kind) close is not usable")

            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.name = "renderer-family-\(kind)-ax3xl.png"
            screenshot.lifetime = .keepAlways
            add(screenshot)
            app.terminate()
        }
    }

    func testPracticeSelectionAnnouncesStateWithoutRelyingOnColor() {
        app.launchArguments = ["-AUREL_TEST_RESET", "-AUREL_RENDERER_KIND", "practice"]
        app.launch()

        let options = app.buttons.matching(
            NSPredicate(format: "identifier BEGINSWITH 'au.player.option.'"))
        let first = options.firstMatch
        XCTAssertTrue(first.waitForExistence(timeout: 12))
        if !first.isHittable { app.swipeUp() }
        XCTAssertTrue(first.isHittable)
        first.tap()
        // Re-resolve the picked option from a fresh snapshot: the reference
        // captured before the tap predates the state change it caused, and a
        // stale snapshot can read neither trait nor value.
        let picked = app.buttons.matching(
            NSPredicate(format: "identifier BEGINSWITH 'au.player.option.'")
        ).firstMatch
        XCTAssertTrue(picked.waitForExistence(timeout: 4), "the picked option disappeared")
        XCTAssertTrue(picked.isSelected, "picked option must expose the selected trait")
        XCTAssertFalse(
            String(describing: picked.value ?? "").isEmpty,
            "picked option must expose text feedback in addition to color")
    }

    func testGuidedRoleplayTilesAdvanceToARealCompletionAction() {
        app.launchArguments = ["-AUREL_TEST_RESET", "-AUREL_RENDERER_KIND", "roleplay"]
        app.launch()

        let root = anyElement("au.player.kind.roleplay")
        XCTAssertTrue(root.waitForExistence(timeout: 12))

        for _ in 0..<4 {
            let tile = app.buttons.matching(
                NSPredicate(format: "identifier BEGINSWITH 'au.player.roleplay.tile.'")
            ).firstMatch
            XCTAssertTrue(tile.waitForExistence(timeout: 6), "the current guided reply is missing")
            for _ in 0..<4 where !tile.isHittable { app.swipeUp() }
            XCTAssertTrue(tile.isHittable, "the current guided reply is not tappable")
            tile.tap()
        }

        let goOn = app.buttons["au.btn.go-on"]
        XCTAssertTrue(goOn.waitForExistence(timeout: 6), "completed roleplay has no Go on action")
        for _ in 0..<4 where !goOn.isHittable { app.swipeUp() }
        XCTAssertTrue(goOn.isHittable, "completed roleplay's Go on action is not tappable")
        goOn.tap()
        XCTAssertFalse(
            root.waitForExistence(timeout: 2), "Go on left the learner trapped in roleplay")
    }
}
