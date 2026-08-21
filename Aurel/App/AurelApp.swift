import SwiftData
import SwiftUI

@main
struct AurelApp: App {
    let container: ModelContainer
    @State private var storeRecovered: Bool

    init() {
        // S1-003: an unopenable (corrupt) store must not crash-loop the app —
        // it is moved aside once and a fresh store is created; the banner in
        // RootView surfaces the local-progress reset.
        let result = AppSchema.openWithRecovery()
        container = result.container
        _storeRecovered = State(initialValue: result.recovered)
    }

    var body: some Scene {
        WindowGroup {
            RootView(storeRecovered: storeRecovered)
                .environment(\.modelContext, container.mainContext)
        }
        .modelContainer(container)
    }
}
