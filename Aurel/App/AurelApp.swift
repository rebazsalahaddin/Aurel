import SwiftData
import SwiftUI

@main
struct AurelApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try AppSchema.makeContainer()
        } catch {
            fatalError("Aurel could not open its store: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.modelContext, container.mainContext)
        }
        .modelContainer(container)
    }
}
