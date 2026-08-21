import SwiftData
import SwiftUI

/// Dependency container injected at the root; owns the loaded course and the
/// router. Services (audio, connectivity) attach here in the services task.
@MainActor
@Observable
final class AppEnvironment {
    let course: CourseStore
    let router: AppRouter
    let scene: SceneScript
    let wordSheet: [WordRow]
    let speaker: Speaker
    let connectivity: Connectivity

    /// S1-004: the bundled course could not be decoded — RootView shows the
    /// course-recovery surface instead of the shell (a launch-time decode
    /// failure must not crash; retry rebuilds the environment).
    private(set) var courseLoadFailed: Bool

    init(modelContext: ModelContext?) {
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
        router = AppRouter(course: store, modelContext: modelContext)
        scene = SceneScript.newest(from: store)
        wordSheet = WordRow.words(from: store)
        speaker = Speaker()
        connectivity = Connectivity()
    }
}
