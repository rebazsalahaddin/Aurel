import SwiftUI
import XCTest

@testable import Aurel

@MainActor
final class Stage6PlayerTests: XCTestCase {

    func testPlayerPositionAndNavigation() throws {
        let store = CourseDecodingTests.store
        var finished = false
        var exited = false
        let model = PlayerModel(
            course: store,
            start: 0,
            bound: false,
            onExit: { exited = true },
            onFinish: { finished = true }
        )

        XCTAssertEqual(model.p, 0)
        XCTAssertNotNil(model.cur)

        model.goto(1)
        XCTAssertEqual(model.p, 1)

        // Out-of-bounds advance triggers onFinish callback
        model.goto(9999)
        XCTAssertTrue(finished)
        XCTAssertEqual(model.p, 1)

        // Out-of-bounds backtrack triggers onExit callback
        model.goto(-50)
        XCTAssertTrue(exited)
        XCTAssertEqual(model.p, 1)
    }

    func testPlayerLoadingStateView() {
        let loadingView = PlayerLoadingView()
        XCTAssertNotNil(loadingView)
    }

    func testSayCoachRecordResetOnScreenAdvance() {
        let say = SayCoach()
        let recorder = FakeTakeRecorder()
        say.recorder = recorder
        say.onDeviceRecognitionProbe = { true }
        say.micPermissionProbe = { .granted }

        say.toggle(target: "bonjour")
        XCTAssertTrue(say.recording)
        XCTAssertEqual(say.activeTarget, "bonjour")

        say.reset()
        XCTAssertFalse(say.recording)
    }

    func testScreenColumnAuthoringHeight() {
        let col = ScreenColumn(topPad: 24, bottomPad: 28) {
            Text("Test")
        }
        XCTAssertEqual(col.topPad, 24)
        XCTAssertEqual(col.bottomPad, 28)
    }
}
