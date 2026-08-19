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
}
