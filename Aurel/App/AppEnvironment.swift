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

    init(modelContext: ModelContext?) {
        let store: CourseStore
        do {
            store = try CourseStore.load()
        } catch {
            fatalError("Aurel could not load its course: \(error)")
        }
        course = store
        router = AppRouter(course: store, modelContext: modelContext)
        scene = SceneScript.newest(from: store)
        wordSheet = WordRow.words(from: store)
        speaker = Speaker()
        connectivity = Connectivity()
    }
}
