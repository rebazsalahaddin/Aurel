import SwiftData
import SwiftUI

/// Executable product capabilities for the running build. Release defaults are
/// deliberately conservative: a surface is enabled only after its service is
/// actually present and verified.
struct AppCapabilities: Equatable, Sendable {
    var accounts: Bool
    var commerce: Bool
    var notifications: Bool
    var weeklyEmail: Bool
    var widget: Bool
    var support: Bool

    static let release = AppCapabilities(
        accounts: false,
        commerce: false,
        notifications: false,
        weeklyEmail: false,
        widget: false,
        support: false
    )

}

/// Dependency container injected at the root; owns the loaded course and the
/// router. Services (audio, connectivity) attach here in the services task.
@MainActor
@Observable
final class AppEnvironment {
    let course: CourseStore
    let router: AppRouter
    let scene: SceneScript
    let wordSheet: [WordRow]
    let speaker: VoicePlayback
    let connectivity: Connectivity

    /// S1-004: the bundled course could not be decoded — RootView shows the
    /// course-recovery surface instead of the shell (a launch-time decode
    /// failure must not crash; retry rebuilds the environment).
    private(set) var courseLoadFailed: Bool

    init(modelContext: ModelContext?, capabilities: AppCapabilities = .release) {
        let store: CourseStore
        do {
            store = try CourseStore.load()
            courseLoadFailed = false
        } catch {
            // The router/chapter plan already renders an honest fallback for
            // an empty course ("Chapter data not loaded"); the recovery view
            // surfaces the failure and offers a retry.
            store = CourseStore(chapters: [])
            courseLoadFailed = true
        }
        course = store
        let playback = VoicePlayback()
        speaker = playback
        router = AppRouter(
            course: store,
            modelContext: modelContext,
            capabilities: capabilities
        )
        router.say.onCaptureWillBegin = { [weak playback] in
            playback?.stop()
        }
        scene = SceneScript.newest(from: store)
        wordSheet = WordRow.words(from: store)
        connectivity = Connectivity()
    }
}
