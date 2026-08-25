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
            app.launchArguments = ["-AUREL_RENDERER_KIND", kind]
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

    func testPseudolanguageAndAXLayoutKeepsCoreNavigationUsable() {
        app.launchArguments = [
            "-AUREL_TEST_START", "home",
            "-NSDoubleLocalizedStrings", "YES",
            "-NSDoubleLocalizedStringsIncludeDefault", "YES",
            "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL",
        ]
        app.launch()

        let window = app.windows.firstMatch
        XCTAssertTrue(window.waitForExistence(timeout: 10))
        for identifier in ["au.tab.learn", "au.tab.practice", "au.tab.progress", "au.tab.you"] {
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
                "-AUREL_RENDERER_KIND", kind,
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
        app.launchArguments = ["-AUREL_RENDERER_KIND", "practice"]
        app.launch()

        let options = app.buttons.matching(
            NSPredicate(format: "identifier BEGINSWITH 'au.player.option.'"))
        let first = options.firstMatch
        XCTAssertTrue(first.waitForExistence(timeout: 12))
        if !first.isHittable { app.swipeUp() }
        XCTAssertTrue(first.isHittable)
        first.tap()
        XCTAssertTrue(first.isSelected, "picked option must expose the selected trait")
        XCTAssertFalse(
            String(describing: first.value ?? "").isEmpty,
            "picked option must expose text feedback in addition to color")
    }

    func testGuidedRoleplayTilesAdvanceToARealCompletionAction() {
        app.launchArguments = ["-AUREL_RENDERER_KIND", "roleplay"]
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
