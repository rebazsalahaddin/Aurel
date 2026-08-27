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
        #if AUREL_VERIFICATION
        // UI-test hermeticity: `-AUREL_TEST_RESET` starts the launch from a
        // pristine learner store. Without it, a used simulator (Xcode ⌘U on a
        // device that already ran the suites) replays persisted lesson
        // records, the chapter shell, and the pending card — all of which
        // re-shape Home and break the suites' documented fresh-install
        // assumptions. The moved-aside copy stays on disk; the fresh open
        // succeeds, so this is NOT surfaced as a corruption recovery.
        if ProcessInfo.processInfo.arguments.contains("-AUREL_TEST_RESET") {
            AppSchema.moveStoreAside(nil)
        }
        #endif
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
