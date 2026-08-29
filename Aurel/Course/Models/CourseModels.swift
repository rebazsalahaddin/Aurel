import Foundation

// MARK: - Course data model
//
// Codable mirror of the exported course banks (tools/export-course-json.mjs →
// Aurel/Resources/Course/a1-course.json). Field names match the authored JSON
// exactly; every optional mirrors a field only some chapters carry.

// MARK: Envelope

struct CourseChapter: Decodable, Hashable, Identifiable {
    let id: String  // "A1-C01"
    let n: Int
    let arc: String
    let title: String
    let mission: String
    let canDos: [String]
    let doNotTeach: [String]
    let lessons: [CourseLesson]
}

struct CourseLesson: Decodable, Hashable, Identifiable {
    let id: String  // "L01"
    let type: String  // "V" | "G" | "C+R" | "M" | "V+G" | "G+C" | "R+M"
    let n: Int
    let title: String
    let time: String  // "18–20 min" — display string
    let pause: String?  // "after Practice A (≈10 min)"
    let src: String?  // authored markdown source
    let screens: [CourseScreen]
}

// MARK: Shared sub-types

/// `[ILL]` reference — `{id: "A1-C01-ILL005", alt: "…"}`. Illustrations stay
/// placeholders by governance; `alt` is the accessibility text.
struct IllustrationRef: Decodable, Hashable {
    let id: String
    let alt: String
}

/// A dialogue line — `{sp: "MAYA", t: "Hello!"}`.
struct ChatLine: Decodable, Hashable {
    let sp: String
    let t: String
}

/// A vocabulary card from a micro-set.
struct VocabCard: Decodable, Hashable, Identifiable {
    let id: String  // "V001"
    let w: String
    let ipa: String?
    let stress: String?
    let aud: String?
    let ill: IllustrationRef?
    let fn: String?
    let frame: String?
    let face: String?
    let badge: String?
    let chunk: Bool?
}

/// Practice option — `{id: "A", t: "hello"}` or `{id: "B", ill: {…}}` for image choices.
struct PracticeOption: Decodable, Hashable, Identifiable {
    let id: String
    let text: String?
    let ill: IllustrationRef?

    private enum CodingKeys: String, CodingKey {
        case id
        case text = "t"
        case ill
    }
}

/// A spoken stimulus line on a listen-then-answer item — `{sp: "LEO", t: "My name is Leo."}`.
struct SaidLine: Decodable, Hashable {
    let sp: String
    let t: String
}

/// Answer keys are option ids ("A") for choices and ordered tile texts for
/// assembly tasks.
enum AnswerKey: Decodable, Hashable {
    case single(String)
    case sequence([String])

    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if let s = try? c.decode(String.self) {
            self = .single(s)
        } else {
            self = .sequence(try c.decode([String].self))
        }
    }

    var single: String? { if case .single(let s) = self { s } else { nil } }
    var sequence: [String]? { if case .sequence(let s) = self { s } else { nil } }
}

/// One scored practice item (vocabulary/grammar/conversation/listening/reading
/// banks and the quiz share this shape). Variants: `kind` "image" (image
/// options), "speak" (say-aloud, `word`), "order" (`tiles` + sequence key).
struct PracticeItem: Decodable, Hashable, Identifiable {
    let id: String
    let instr: String
    let icon: String?  // ear | eye | choose | mouth
    let kind: String?  // image | speak | order (omitted = plain choice)
    let aud: String?
    let ill: IllustrationRef?
    let scene: String?
    let prompt: String?
    let word: String?
    let opts: [PracticeOption]?
    let tiles: [String]?
    let key: AnswerKey?
    let ok: String?
    let no: String?
    let hints: [String]?
    let secs: Int?
    let a11y: [String]?
    let big: Bool?  // quiz Form A large-print items
    let note: String?
    let bubbles: Bool?
    let said: SaidLine?
    /// 1-based catalog / dialogue line numbers (`_L1` is `1`). When set, Listen
    /// plays only these turns instead of the keyed answer or the full talk.
    let playLines: [Int]?
}

/// pronunciation produce item — `{id, word, aud, note}`.
struct PronProduceItem: Decodable, Hashable, Identifiable {
    let id: String
    let word: String
    let aud: String?
    let note: String?
}

/// pronunciation perceive item — `{id, instr, prompt, aud, opts, key, note}`.
struct PronPerceiveItem: Decodable, Hashable, Identifiable {
    let id: String
    let instr: String
    let prompt: String?
    let aud: String?
    let opts: [PracticeOption]?
    let key: AnswerKey?
    let note: String?
    let said: SaidLine?
    let playLines: [Int]?
}

/// Warm-up retrieval frame — options are word texts, `key` is the target text.
struct WarmFrame: Decodable, Hashable {
    let q: String
    let icon: String?
    let aud: String?
    let scene: String?
    let opts: [String]
    let key: String
}

/// Tile-assembly task — "Put in order." / tile-writing.
struct TileTask: Decodable, Hashable, Identifiable {
    let id: String
    let instr: String
    let target: String?
    let tiles: [String]?
    let key: AnswerKey?
    let ok: String?
    let no: String?
    let hints: [String]?
    let alt: String?
}

/// Grammar notice block — listen and notice before the rule lands.
struct NoticeBlock: Decodable, Hashable {
    let aud: String?
    let task: String?
    let chat: [ChatLine]?
}

/// Grammar ledger record.
struct GrammarRecord: Decodable, Hashable, Identifiable {
    let id: String
    let title: String
    let pattern: String
    let errs: [[String]]
}

/// Grammar model screen's paradigm table rows.
struct GrammarRow: Decodable, Hashable {
    let cells: [String]

    init(from decoder: Decoder) throws {
        var arr = try decoder.unkeyedContainer()
        var cells: [String] = []
        while !arr.isAtEnd { cells.append(try arr.decode(String.self)) }
        self.cells = cells
    }
}

/// In-practice teaching block (the "teach" object on blended practice screens).
struct TeachBlock: Decodable, Hashable {
    let ill: IllustrationRef?
    let notice: [NoticeBlock]?
    let patternTiles: [String]?
    let explain: String?
    let records: [GrammarRecord]?
    let notYet: String?
}

/// Mid-lesson pause card on long practice screens.
struct PauseCard: Decodable, Hashable {
    let head: String
    let body: String
    let at: String?
}

/// Letter family for the alphabet screens.
struct LetterFamily: Decodable, Hashable {
    let n: Int
    let letters: [String]
    let aud: String?
}

/// Number card for the numbers screens.
struct NumberCard: Decodable, Hashable {
    let d: String  // digit
    let w: String  // word
    let ipa: String?
}

/// Chapter-map entry.
struct ChapterMapEntry: Decodable, Hashable {
    let n: Int
    let t: String
    let s: String
}

/// Review-plan week day.
struct WeekDay: Decodable, Hashable {
    let d: String
    let t: String
    let on: Bool
}

/// Remediation clinic.
struct Clinic: Decodable, Hashable, Identifiable {
    let id: String
    let name: String
    let benefit: String
    let n: Int
    let trigger: String
}

/// Roleplay tile group.
struct TileGroup: Decodable, Hashable {
    let g: String
    let t: [String]
}

/// Reading profile card.
struct ReadingProfile: Decodable, Hashable {
    let n: String
    let ill: IllustrationRef?
    let rows: [[String]]
}

/// Name-badge pair for reading tasks.
struct ReadingBadge: Decodable, Hashable {
    let first: String
    let last: String
}

/// Orientation demo row.
struct DemoEntry: Decodable, Hashable {
    let icon: String
    let word: String
    let demo: String
}

/// Mission contact card.
struct MissionCard: Decodable, Hashable {
    let name: String
    let phone: String
    let email: String
}

/// Spoken/written pair (alphabet screen).
struct SpokenPair: Decodable, Hashable {
    let said: String
    let written: String
}

/// A cell in the quiz `mix` table — strings or counts.
enum MixCell: Decodable, Hashable {
    case text(String)
    case number(Double)

    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if let s = try? c.decode(String.self) {
            self = .text(s)
        } else {
            self = .number(try c.decode(Double.self))
        }
    }

    var display: String {
        switch self {
        case .text(let s): s
        case .number(let n): n == n.rounded() ? String(Int(n)) : String(n)
        }
    }
}
