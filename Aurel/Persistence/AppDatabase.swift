import Foundation
import SwiftData

enum AppSchema {
    static let all: [any PersistentModel.Type] = [
        LearnerProfile.self,
        DayLog.self,
        LessonRecord.self,
        MistakeItem.self,
    ]

    /// The app's single on-disk store.
    static func makeContainer(inMemory: Bool = false) throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        return try ModelContainer(for: Schema(all), configurations: [config])
    }

    // MARK: Startup recovery (S1-003)

    /// The outcome of opening the store with recovery.
    struct OpenResult {
        let container: ModelContainer
        /// True when the on-disk store could not be opened, was moved aside,
        /// and a fresh store was created — the learner's local progress was
        /// reset (surfaced by the recovery banner in RootView).
        let recovered: Bool
    }

    /// Open the store; if the on-disk store cannot be opened (corrupt or
    /// incompatible), move it aside once and create a fresh store instead of
    /// crash-looping on every launch. The moved-aside copy stays on disk for
    /// manual recovery. A second failure falls back to an in-memory store so
    /// the app still launches.
    static func openWithRecovery(storeURL: URL? = nil) -> OpenResult {
        do {
            return OpenResult(container: try makeContainer(at: storeURL), recovered: false)
        } catch {
            moveStoreAside(storeURL)
            do {
                return OpenResult(container: try makeContainer(at: storeURL), recovered: true)
            } catch {
                // A valid static schema with a memory store cannot fail on
                // disk state; this is the absolute last resort.
                guard let memory = try? makeContainer(inMemory: true) else {
                    fatalError("Aurel could not open any store: \(error)")
                }
                return OpenResult(container: memory, recovered: true)
            }
        }
    }

    static func makeContainer(at url: URL?) throws -> ModelContainer {
        let config =
            url.map { ModelConfiguration(url: $0) }
            ?? ModelConfiguration(isStoredInMemoryOnly: false)
        return try ModelContainer(for: Schema(all), configurations: [config])
    }

    /// Move the store's sidecar files (`store`, `-wal`, `-shm`) next to
    /// themselves, tagged `.recovered-<timestamp>` — never deleted.
    static func moveStoreAside(_ url: URL?, now: Date = Date()) {
        let base =
            url ?? URL.applicationSupportDirectory.appendingPathComponent("default.store")
        let stamp = Int(now.timeIntervalSince1970)
        for suffix in ["", "-wal", "-shm"] {
            let src = URL(fileURLWithPath: base.path + suffix)
            guard FileManager.default.fileExists(atPath: src.path) else { continue }
            let dst = URL(fileURLWithPath: base.path + suffix + ".recovered-\(stamp)")
            try? FileManager.default.moveItem(at: src, to: dst)
        }
    }
}
