import Foundation

// MARK: - Screen payloads
//
// `CourseScreen` decodes the common envelope (id/type/label/step/tip/assets)
// then dispatches on `type` to one payload struct below. Payload fields live at
// the same JSON level as the envelope, so each payload decodes from the same
// container and ignores keys it does not own.
//
// Field optionality: chapters author payloads slightly differently (e.g. a
// warm-up without a gallery), so payload fields are optional and views fall
// back gracefully. The decode tests pin what the current banks carry.

enum ScreenKind: String, Decodable, Hashable, CaseIterable, Sendable {
    case promise, hook, orientation, cards, letterCards, alphabet, numbers
    case warmup, grammarModel, practice, substitution, testlet, tiles, order
    case reading, emailAssembly, conversation, roleplay, missionBrief
    case pronPerceive, pronProduce, quizIntro, quiz, results, remediation
    case reviewPlan, review, chapterMap, pause, pending
    /// Forward-compat: a bank newer than this app.
    case unknown = "__unknown__"

    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = ScreenKind(rawValue: raw) ?? .unknown
    }

    /// The 29 renderer kinds present in the shipping course bank. `pending`
    /// is a supported compatibility renderer; `unknown` is a decode guard.
    static var authoredCases: [ScreenKind] {
        allCases.filter { $0 != .pending && $0 != .unknown }
    }

    /// Authoring-only opening pages that do not provide a learning action.
    /// They remain decodable so older course banks and renderer fixtures stay
    /// compatible, but normal lesson navigation omits them.
    var participatesInLessonFlow: Bool {
        self != .promise && self != .orientation
    }

    var defaultDisplayTitle: String {
        switch self {
        case .promise: String(localized: "Your goal")
        case .hook: String(localized: "Listen to the story")
        case .orientation: String(localized: "How practice works")
        case .cards: String(localized: "Learn the words")
        case .letterCards: String(localized: "Learn the letters")
        case .alphabet: String(localized: "The alphabet")
        case .numbers: String(localized: "Learn the numbers")
        case .warmup: String(localized: "Warm-up")
        case .grammarModel: String(localized: "Notice the pattern")
        case .practice: String(localized: "Practice")
        case .substitution: String(localized: "Build new sentences")
        case .testlet: String(localized: "Listening practice")
        case .tiles: String(localized: "Build the sentence")
        case .order: String(localized: "Put the conversation in order")
        case .reading: String(localized: "Reading practice")
        case .emailAssembly: String(localized: "Build the email")
        case .conversation: String(localized: "Conversation practice")
        case .roleplay: String(localized: "Roleplay")
        case .missionBrief: String(localized: "Your mission")
        case .pronPerceive: String(localized: "Hear the difference")
        case .pronProduce: String(localized: "Say it aloud")
        case .quizIntro: String(localized: "Ready for a check-in?")
        case .quiz: String(localized: "Knowledge check")
        case .results: String(localized: "Your results")
        case .remediation: String(localized: "Practice picks")
        case .reviewPlan: String(localized: "Your review plan")
        case .review: String(localized: "Review and reflect")
        case .chapterMap: String(localized: "Chapter complete")
        case .pause: String(localized: "Take a pause")
        case .pending: String(localized: "More course content is needed")
        case .unknown: String(localized: "Lesson content unavailable")
        }
    }

    var rendererFamily: RendererFamily {
        switch self {
        case .promise, .hook, .orientation, .pause: .opening
        case .cards, .letterCards, .alphabet, .numbers: .cards
        case .warmup, .practice, .testlet, .reading, .quiz: .practice
        case .grammarModel: .grammar
        case .substitution, .tiles, .order, .emailAssembly: .assembly
        case .pronPerceive, .pronProduce: .pronunciation
        case .conversation: .conversation
        case .missionBrief, .roleplay: .mission
        case .quizIntro, .results, .remediation, .reviewPlan, .chapterMap, .pending: .assessment
        case .review: .review
        case .unknown: .unknown
        }
    }
}

enum RendererFamily: String, CaseIterable, Sendable {
    case opening, cards, practice, grammar, assembly, pronunciation
    case conversation, mission, assessment, review, unknown
}

struct CourseScreenDebugMetadata: Hashable {
    let legacyLabel: String?
    let step: String?
    let implementationNote: String?
    let assetIDs: [String]
}

struct CourseScreen: Decodable, Hashable, Identifiable {
    let id: String  // "S01"
    let kind: ScreenKind
    /// New schema fields. Current banks may omit them while the compatibility
    /// decoder supplies a safe kind-level fallback.
    let displayTitle: String?
    let outcome: String?
    let duration: String?
    let instruction: String?
    let debug: CourseScreenDebugMetadata
    let payload: CourseScreenPayload

    private enum CodingKeys: String, CodingKey {
        case id, type, displayTitle, outcome, duration, instruction
        case label, step, tip, assets
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        let rawKind = try c.decode(String.self, forKey: .type)
        kind = ScreenKind(rawValue: rawKind) ?? .unknown
        displayTitle = try c.decodeIfPresent(String.self, forKey: .displayTitle)
        outcome = try c.decodeIfPresent(String.self, forKey: .outcome)
        duration = try c.decodeIfPresent(String.self, forKey: .duration)
        instruction = try c.decodeIfPresent(String.self, forKey: .instruction)
        debug = CourseScreenDebugMetadata(
            legacyLabel: try c.decodeIfPresent(String.self, forKey: .label),
            step: try c.decodeIfPresent(String.self, forKey: .step),
            implementationNote: try c.decodeIfPresent(String.self, forKey: .tip),
            assetIDs: try c.decodeIfPresent([String].self, forKey: .assets) ?? []
        )
        payload = try CourseScreenPayload(from: decoder, kind: kind)
    }

    var learnerTitle: String {
        CourseTextContract.learnerText(displayTitle) ?? kind.defaultDisplayTitle
    }

    var learnerOutcome: String? { CourseTextContract.learnerText(outcome) }
    var learnerDuration: String? { CourseTextContract.learnerText(duration) }
    var learnerInstruction: String? { CourseTextContract.learnerText(instruction) }
}

enum CourseScreenPayload: Decodable, Hashable {
    case promise(PromiseScreen)
    case hook(HookScreen)
    case orientation(OrientationScreen)
    case cards(CardsScreen)
    case letterCards(LetterCardsScreen)
    case alphabet(AlphabetScreen)
    case numbers(NumbersScreen)
    case warmup(WarmupScreen)
    case grammarModel(GrammarModelScreen)
    case practice(PracticeScreen)
    case substitution(SubstitutionScreen)
    case testlet(TestletScreen)
    case tiles(TilesScreen)
    case order(OrderScreen)
    case reading(ReadingScreen)
    case emailAssembly(EmailAssemblyScreen)
    case conversation(ConversationScreen)
    case roleplay(RoleplayScreen)
    case missionBrief(MissionBriefScreen)
    case pronPerceive(PronPerceiveScreen)
    case pronProduce(PronProduceScreen)
    case quizIntro(QuizIntroScreen)
    case quiz(QuizScreen)
    case results(ResultsScreen)
    case remediation(RemediationScreen)
    case reviewPlan(ReviewPlanScreen)
    case review(ReviewScreen)
    case chapterMap(ChapterMapScreen)
    case pause(PauseScreen)
    case pending(PendingScreen)
    case unknown

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let raw = try c.decode(String.self, forKey: .type)
        let kind = ScreenKind(rawValue: raw) ?? .unknown
        self = try Self.decode(from: decoder, kind: kind)
    }

    init(from decoder: Decoder, kind: ScreenKind) throws {
        self = try Self.decode(from: decoder, kind: kind)
    }

    private enum CodingKeys: String, CodingKey { case type }

    private static func decode(from decoder: Decoder, kind: ScreenKind) throws
        -> CourseScreenPayload
    {
        switch kind {
        case .promise: .promise(try PromiseScreen(from: decoder))
        case .hook: .hook(try HookScreen(from: decoder))
        case .orientation: .orientation(try OrientationScreen(from: decoder))
        case .cards: .cards(try CardsScreen(from: decoder))
        case .letterCards: .letterCards(try LetterCardsScreen(from: decoder))
        case .alphabet: .alphabet(try AlphabetScreen(from: decoder))
        case .numbers: .numbers(try NumbersScreen(from: decoder))
        case .warmup: .warmup(try WarmupScreen(from: decoder))
        case .grammarModel: .grammarModel(try GrammarModelScreen(from: decoder))
        case .practice: .practice(try PracticeScreen(from: decoder))
        case .substitution: .substitution(try SubstitutionScreen(from: decoder))
        case .testlet: .testlet(try TestletScreen(from: decoder))
        case .tiles: .tiles(try TilesScreen(from: decoder))
        case .order: .order(try OrderScreen(from: decoder))
        case .reading: .reading(try ReadingScreen(from: decoder))
        case .emailAssembly: .emailAssembly(try EmailAssemblyScreen(from: decoder))
        case .conversation: .conversation(try ConversationScreen(from: decoder))
        case .roleplay: .roleplay(try RoleplayScreen(from: decoder))
        case .missionBrief: .missionBrief(try MissionBriefScreen(from: decoder))
        case .pronPerceive: .pronPerceive(try PronPerceiveScreen(from: decoder))
        case .pronProduce: .pronProduce(try PronProduceScreen(from: decoder))
        case .quizIntro: .quizIntro(try QuizIntroScreen(from: decoder))
        case .quiz: .quiz(try QuizScreen(from: decoder))
        case .results: .results(try ResultsScreen(from: decoder))
        case .remediation: .remediation(try RemediationScreen(from: decoder))
        case .reviewPlan: .reviewPlan(try ReviewPlanScreen(from: decoder))
        case .review: .review(try ReviewScreen(from: decoder))
        case .chapterMap: .chapterMap(try ChapterMapScreen(from: decoder))
        case .pause: .pause(try PauseScreen(from: decoder))
        case .pending: .pending(try PendingScreen(from: decoder))
        case .unknown: .unknown
        }
    }
}

// MARK: Lesson-opening screens

/// S01 — the can-do promise. Full-bleed illustration, "New words today", can-do lines.
struct PromiseScreen: Decodable, Hashable {
    let ill: IllustrationRef?
    let newToday: String?
    let newTodayLabel: String?
    let canDos: [String]?
    let vo: String?
}

/// Scene hook — characters plant the target language before teaching.
struct HookScreen: Decodable, Hashable {
    let scene: String?
    let aud: String?
    let delivery: String?
    let ill: IllustrationRef?
    let lines: [ChatLine]?
    let scored: Bool?
    let plant: String?
    let lead: String?
    let note: String?
}

/// First-use orientation — how the practice mechanics work.
struct OrientationScreen: Decodable, Hashable {
    let intro: String?
    let demos: [DemoEntry]?
}

// MARK: Vocabulary

/// Micro-set card gallery (the core "cards" screen).
struct CardsScreen: Decodable, Hashable {
    let chip: String?
    let cards: [VocabCard]?
    let encounter: String?
    let strengthStrip: [String]?
    let badgeSchema: Bool?
    let story: String?
    let flowDots: [String]?
    let preAud: String?
    let chunkRule: String?
    let spoken: SpokenPair?
    let artRule: String?
    let attachedNote: String?
    let frameNote: String?
    let panels: [String]?
    let upgrade: String?
}

struct LetterCardsScreen: Decodable, Hashable {
    let chip: String?
    let families: [LetterFamily]?
    let letterNames: [String: String]?
    let flow: String?
}

struct AlphabetScreen: Decodable, Hashable {
    let head: String?
    let rule: String?
    let ill: IllustrationRef?
    let letterNames: [String: String]?
    let families: [LetterFamily]?
    let note: String?
}

struct NumbersScreen: Decodable, Hashable {
    let chip: String?
    let head: String?
    let rule: String?
    let nums: [NumberCard]?
    let strip: [String]?
    let flow: String?
    let confusables: [String]?
    let pat: String?
    let countAlong: String?
    let note: String?
}

/// Warm-up retrieval — gallery re-shown, then quick frames.
struct WarmupScreen: Decodable, Hashable {
    let head: String?
    let sub: String?
    let gallery: [VocabCard]?
    let dots: Int?
    let frames: [WarmFrame]?
    let bank: String?
    let rule: String?
    let story: String?
    let note: String?
}

// MARK: Grammar

struct GrammarModelScreen: Decodable, Hashable {
    let notice: [NoticeBlock]?
    let records: [GrammarRecord]?
    let dockNote: String?
    let ill: IllustrationRef?
    let paradigm: [GrammarRow]?
    let explain: String?
    let more: String?
    let notYet: String?
    let patternTiles: [String]?
}

struct SubstitutionScreen: Decodable, Hashable {
    let ids: String?
    let slots: [SubstitutionSlot]?
    let strip: [String]?
    let note: String?

    struct SubstitutionSlot: Decodable, Hashable {
        let slot: String
        let opts: [String]
    }
}

// MARK: Practice

struct PracticeScreen: Decodable, Hashable {
    let items: [PracticeItem]?
    let bank: String?
    let dock: String?
    let interleave: Bool?
    let ids: String?
    let chartChip: Bool?
    let digitStrip: [String]?
    let ladder: String?
    let blended: String?
    let pauseCard: PauseCard?
    let close: String?
    let teach: TeachBlock?
    let head: String?
}

/// Listening ladder rung.
struct TestletScreen: Decodable, Hashable {
    let rung: String?
    let support: String?
    let aud: String?
    let ids: String?
    let items: [PracticeItem]?
    let unlock: String?
    let delivery: String?
    let challenge: [ChatLine]?
    let note: String?
    let digitStrip: [String]?
    let ill: IllustrationRef?
    let groups: [TestletGroup]?
    let transferScript: [ChatLine]?
    let scripts: [ScriptLine]?

    struct TestletGroup: Decodable, Hashable {
        let n: String
        let stim: String
        let ids: String?
        let note: String?
    }

    struct ScriptLine: Decodable, Hashable {
        let id: String
        let sp: String
        let t: String
    }
}

/// Tile-writing / guided writing.
struct TilesScreen: Decodable, Hashable {
    let ids: String?
    let tasks: [TileTask]?
}

/// Alphabetical order demo + tasks.
struct OrderScreen: Decodable, Hashable {
    let demoWords: [String]?
    let ids: String?
    let tasks: [TileTask]?
}

// MARK: Reading / writing

struct ReadingScreen: Decodable, Hashable {
    let kind: String?
    let ids: String?
    let badges: [ReadingBadge]?
    let items: [PracticeItem]?
    let listenAfter: String?
    let card: [String]?
    let form: ReadingForm?
    let profiles: [ReadingProfile]?
    let note: String?

    struct ReadingForm: Decodable, Hashable {
        let title: String
        let rows: [[String]]
    }
}

/// Guided email assembly.
struct EmailAssemblyScreen: Decodable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case sourceId = "id_"
        case instr, spoken, tiles, key, written, ok, no, hints, safety
    }

    let sourceId: String?
    let instr: String?
    let spoken: String?
    let tiles: [String]?
    let key: [String]?
    let written: String?
    let ok: String?
    let no: String?
    let hints: [String]?
    let safety: String?
}

// MARK: Conversation

struct ConversationScreen: Decodable, Hashable {
    let pkg: String?
    let scenario: String?
    let aud: String?
    let lineAud: String?
    let delivery: String?
    let panels: [String]?
    let turns: [ConversationTurn]?
    let branch: [String]?
    let lock: String?
    let map: [[String]]?
    let challengeNote: String?

    struct ConversationTurn: Decodable, Hashable {
        let n: String
        let sp: String
        let t: String
    }
}

struct RoleplayScreen: Decodable, Hashable {
    let spec: String?
    let partner: String?
    let turnLimit: Int?
    let opener: String?
    let checklist: [String]?
    let slots: [String]?
    let ceiling: String?
    let tileGroups: [TileGroup]?
    let transcript: [ChatLine]?
    let transcriptNote: String?
    let feedback: RoleplayFeedback?
    let redirects: [String]?
    let ends: [String]?
    let fallback: String?
    let scenario: String?
    let partnerCard: String?
    let success: [String]?
    let guardrails: [String]?
    let scoring: String?

    struct RoleplayFeedback: Decodable, Hashable {
        let strong: [String]?
        let next: String?
    }
}

struct MissionBriefScreen: Decodable, Hashable {
    let head: String?
    let body: String?
    let ill: IllustrationRef?
    let checklist: [String]?
    let entries: [String]?
    let privacy: String?
    let card: MissionCard?
    let setup: String?
    let completion: String?
}

// MARK: Pronunciation

struct PronPerceiveScreen: Decodable, Hashable {
    let items: [PronPerceiveItem]?
    let bank: String?
}

struct PronProduceScreen: Decodable, Hashable {
    let items: [PronProduceItem]?
    let bank: String?
}

// MARK: Assessment / chapter close

struct QuizIntroScreen: Decodable, Hashable {
    let head: String?
    let meta: [String]?
    let promise: String?
}

struct QuizScreen: Decodable, Hashable {
    let mix: [[MixCell]]?
    let bank: String?
    let note: String?
    let items: [PracticeItem]?
}

struct ResultsScreen: Decodable, Hashable {
    let rings: [String]?
    let strong: String?
    let developing: String?
    let next: String?
    let score: String?
    let gate: String?
}

struct RemediationScreen: Decodable, Hashable {
    let head: String?
    let sub: String?
    let clinics: [Clinic]?
    let pending: String?
}

struct ReviewPlanScreen: Decodable, Hashable {
    let head: String?
    let sub: String?
    let week: [WeekDay]?
    let exports: [[String]]?
}

/// Compact reminder after each chapter.
struct ReviewScreen: Decodable, Hashable {
    let head: String?
    let lines: [String]?
    let gallery: [VocabCard]?
    let auds: [String]?
    let next: String?
    let rings: Int?
    let ringsFilled: Int?
    let flowDots: [String]?
    let keepCard: String?
    let sweep: String?
}

struct ChapterMapScreen: Decodable, Hashable {
    let head: String?
    let body: String?
    let next: String?
    let arc: String?
    let chapters: [ChapterMapEntry]?
}

/// The honest pause at 8–12 minutes.
struct PauseScreen: Decodable, Hashable {
    let head: String?
    let ill: IllustrationRef?
    let body: String?
    let rings: Int?
    let ringsFilled: Int?
}

/// Honest "awaiting course content" screen (deferred premium).
struct PendingScreen: Decodable, Hashable {
    let awaiting: String?
    let planned: [String]?
    let source: String?
}
