import Observation
import SwiftUI

// MARK: - Course player model
//
// Port of CourseScreen.dc.html's DCLogic (lines 1143–1720): position within
// the flat screen list, per-screen sub-state, item normalization, and the
// pick / advance / tile mechanics with the authored retry ladder.

@MainActor
@Observable
final class PlayerModel {
    // position + sub-state (state = {...}, line 1144)
    var p: Int
    var i = 0  // item index within screen
    var c = 0  // card index
    var sel: String? = nil
    var wrong = 0
    var done = false
    var plays = 0
    var caps = false
    var demo = 0
    var tried = false
    var notice = 0
    var revealed = false
    var order: [Int] = []  // tile order (indexes into tiles)
    var picked: [String: String] = [:]
    var tk = 0  // task index (tiles/order screens)
    var teachShut = false
    var rec = 0
    var showScore = false
    var flip: [String: Bool] = [:]
    var turn = 1  // conversation/roleplay turn

    let course: CourseStore
    let bound: Bool
    var onFinish: () -> Void
    var onExit: () -> Void
    var onScreen: (Int) -> Void

    /// The audio stand-in (TTS), attached by the hosting view.
    var speaker: (any AudioPlaying)?

    /// Speak authored text as the not-yet-recorded audio stand-in.
    func speak(_ text: String?, slow: Bool = false) {
        guard let text, !text.isEmpty else { return }
        speaker?.speak(text, slow: slow)
    }

    /// The authored text an audio-cued item should speak — the key option for
    /// listening items (the thing you hear), the headword for cards.
    var speakTextForItem: String? {
        guard let item else { return nil }
        if let key = item.key?.single {
            return item.opts.first { $0.id == key || $0.text == key }?.text
        }
        return item.word ?? item.prompt ?? nil
    }

    init(
        course: CourseStore, start: Int, bound: Bool = true,
        onScreen: @escaping (Int) -> Void = { _ in },
        onExit: @escaping () -> Void = {},
        onFinish: @escaping () -> Void = {}
    ) {
        self.course = course
        self.bound = bound
        self.onScreen = onScreen
        self.onExit = onExit
        self.onFinish = onFinish
        self.p = start
    }

    // MARK: Bounds (lines 1155–1164) — inside a lesson, no wandering out

    var bounds: (min: Int, max: Int) {
        let f = course.flat
        guard !f.isEmpty else { return (0, 0) }
        guard bound else { return (0, f.count - 1) }
        let here = f[max(0, min(f.count - 1, p))]
        var mn = 0
        var mx = f.count - 1
        for k in 0..<f.count where f[k].lesson == here.lesson {
            if mn == 0, k > 0, f[k - 1].lesson != here.lesson { mn = k }
            mx = k
        }
        if f[0].lesson == here.lesson { mn = 0 }
        return (mn, mx)
    }

    // MARK: goto (lines 1178–1187)

    func goto(_ newP: Int) {
        let f = course.flat
        guard !f.isEmpty else { return }
        let b = bounds
        if newP > b.max {
            onFinish()
            return
        }
        if newP < b.min {
            onExit()
            return
        }
        let n = max(b.min, min(b.max, newP))
        onScreen(n)
        p = n
        i = 0
        c = 0
        sel = nil
        wrong = 0
        done = false
        plays = 0
        caps = false
        demo = 0
        tried = false
        notice = 0
        revealed = false
        order = []
        picked = [:]
        rec = 0
        showScore = false
        flip = [:]
        turn = 1
        tk = 0
        teachShut = false
    }

    var cur: CourseStore.FlatScreen? {
        course.flat.indices.contains(p) ? course.flat[p] : nil
    }

    // MARK: Item normalization (lines 1192–1211)

    /// The single item renderer's input, unifying practice/quiz/testlet/
    /// warm-up/reading/nextLine items.
    struct PlayerItem: Identifiable {
        let id: String
        var instr: String = ""
        var icon: String = "eye"
        var aud: String? = nil
        var ill: IllustrationRef? = nil
        var scene: String? = nil
        var opts: [PracticeOption] = []
        var key: AnswerKey? = nil
        var ok: String? = nil
        var no: String? = nil
        var hints: [String]? = nil
        var unscored = false
        var bubbles = false
        var said: (sp: String, t: String)? = nil
        var word: String? = nil
        var digit: String? = nil
        var confusable: String? = nil
        var kind: String? = nil
        var big = false
        var secs: Int? = nil
        var prompt: String? = nil
        var tiles: [String] = []

        func isKey(_ o: PracticeOption) -> Bool {
            o.id == key?.single || o.text == key?.single
        }
    }

    var items: [PlayerItem] {
        guard let cur else { return [] }
        switch cur.screen.payload {
        case .warmup(let w): return warmupItems(w)
        case .practice(let pr): return normalized(pr.items)
        case .quiz(let q): return normalized(q.items)
        case .testlet(let t): return normalized(t.items)
        case .reading(let r): return normalized(r.items)
        default: return []
        }
    }

    private func warmupItems(_ w: WarmupScreen) -> [PlayerItem] {
        var out: [PlayerItem] = []
        for (k, f) in (w.frames ?? []).enumerated() {
            var opts: [PracticeOption] = []
            for (j, t) in f.opts.enumerated() {
                opts.append(PracticeOption(id: String.letter(j), text: t, ill: nil))
            }
            out.append(
                PlayerItem(
                    id: "frame \(k + 1)",
                    instr: f.q,
                    icon: f.icon ?? "ear",
                    aud: f.aud,
                    opts: opts,
                    key: .single(f.key),
                    ok: "Yes — \(f.key)",
                    no: "Try again.",
                    hints: [
                        "Listen or look once more.", "Two options belong to a different moment.",
                    ],
                    unscored: true
                ))
        }
        return out
    }

    private func normalized(_ list: [PracticeItem]?) -> [PlayerItem] {
        (list ?? []).map { it in
            PlayerItem(
                id: it.id,
                instr: it.instr,
                icon: it.icon ?? "eye",
                aud: it.aud,
                ill: it.ill,
                opts: it.opts ?? [],
                key: it.key,
                ok: it.ok,
                no: it.no,
                hints: it.hints,
                word: it.word,
                kind: it.kind,
                big: it.big ?? false,
                secs: it.secs,
                prompt: it.prompt,
                tiles: it.tiles ?? []
            )
        }
    }

    var item: PlayerItem? {
        items.indices.contains(i) ? items[i] : nil
    }

    // MARK: pick (lines 1213–1221)

    var isQuiet: Bool { cur?.screen.kind == .quiz }

    /// Whether Next/Go-on is enabled for the current item — `v.canGo`
    /// (lines 1489–1490: `st.done || s.type === 'quiz'`) with the order-item
    /// override at line 1590: `if (itemOrder) { v.canGo = v.tileCorrect }`.
    /// The port originally dropped that override, so order-kind practice items
    /// gated on `done` (which only `pick()` sets) and lessons stalled forever.
    var itemCanGo: Bool {
        guard let it = item else { return false }
        if it.kind == "order" { return tileCorrect }
        return done || isQuiet
    }

    func pick(_ o: PracticeOption, item: PlayerItem) {
        guard !done else { return }
        if isQuiet {
            sel = o.id
            done = true
            return
        }
        let correct = o.id == item.key?.single || o.text == item.key?.single
        if correct {
            sel = o.id
            done = true
            return
        }
        wrong += 1
        sel = o.id
        done = wrong >= 3
        revealed = wrong >= 3
    }

    // MARK: advance (lines 1242–1246)

    func advance() {
        let list = items
        if i + 1 < list.count {
            i += 1
            sel = nil
            wrong = 0
            done = false
            revealed = false
            plays = 0
            order = []
        } else {
            goto(p + 1)
        }
    }

    // MARK: Card list (lines 1248–1262)

    struct PlayerCard: Hashable {
        var main = ""
        var ipa = ""
        var sub = ""
        var ill: IllustrationRef? = nil
        var aud: String? = nil
        var id = ""
        var chunk = false
        var moment = ""
        var symbol = ""
        var digit: String? = nil
        var number = false
        var letter = false
    }

    var cardList: [PlayerCard] {
        guard let cur else { return [] }
        switch cur.screen.payload {
        case .letterCards(let s):
            var out: [PlayerCard] = []
            for f in s.families ?? [] {
                for l in f.letters {
                    out.append(
                        PlayerCard(
                            main: l + "  " + l.lowercased(),
                            ipa: s.letterNames?[l] ?? "",
                            sub: "Family \(f.n)",
                            aud: f.aud,
                            letter: true
                        ))
                }
            }
            return out
        case .numbers(let s):
            return (s.nums ?? []).map { n in
                PlayerCard(
                    main: n.d + "  " + n.w, ipa: n.ipa ?? "", sub: "count scene", digit: n.d,
                    number: true)
            }
        case .cards(let s):
            return (s.cards ?? []).map { c in
                PlayerCard(
                    main: c.w, ipa: c.ipa ?? "", sub: c.fn ?? "", ill: c.ill, aud: c.aud, id: c.id,
                    chunk: c.chunk ?? false, moment: c.frame ?? "")
            }
        default:
            return []
        }
    }

    var card: PlayerCard {
        let list = cardList
        return list.indices.contains(c) ? list[c] : PlayerCard()
    }

    // MARK: Rings (lines 1390–1401)

    struct Ring: Hashable {
        let on: Bool
    }

    func rings(_ n: Int, _ filled: Int) -> [Ring] {
        (0..<max(0, n)).map { Ring(on: $0 < filled) }
    }

    // MARK: joinTiles (lines 1381–1388) — punctuation attaches; emails tight

    static func joinTiles(_ parts: [String], tight: Bool) -> String {
        if tight { return parts.joined() }
        var line = ""
        for t in parts {
            if line.isEmpty {
                line = t
            } else if ". , ! ? @ : ;".contains(t) && t.count == 1 {
                line += t
            } else {
                line += " " + t
            }
        }
        return line
    }

    // MARK: Tile task state (lines 1531–1592)

    struct TileTaskState {
        let instr: String
        let tiles: [String]
        let key: [String]
        let ok: String
        let no: String
    }

    var tileTask: TileTaskState {
        guard let cur else {
            return TileTaskState(instr: "Put in order.", tiles: [], key: [], ok: "", no: "")
        }
        let s = cur.screen
        if let it = item, it.kind == "order" {
            return TileTaskState(
                instr: it.instr, tiles: it.tiles, key: it.key?.sequence ?? [], ok: it.ok ?? "",
                no: it.no ?? "")
        }
        switch s.payload {
        case .tiles(let t):
            if let task = (t.tasks ?? []).indices.contains(tk) ? (t.tasks ?? [])[tk] : nil {
                return TileTaskState(
                    instr: task.instr, tiles: task.tiles ?? [], key: task.key?.sequence ?? [],
                    ok: task.ok ?? "", no: task.no ?? "")
            }
        case .order(let o):
            if let task = (o.tasks ?? []).indices.contains(tk) ? (o.tasks ?? [])[tk] : nil {
                return TileTaskState(
                    instr: task.instr, tiles: task.tiles ?? [], key: task.key?.sequence ?? [],
                    ok: task.ok ?? "", no: task.no ?? "")
            }
        case .emailAssembly(let e):
            return TileTaskState(
                instr: e.instr ?? "Put in order.", tiles: e.tiles ?? [], key: e.key ?? [],
                ok: e.ok ?? "", no: e.no ?? "")
        default:
            break
        }
        return TileTaskState(instr: "Put in order.", tiles: [], key: [], ok: "", no: "")
    }

    var tileLine: String {
        let tiles = tileTask.tiles
        return Self.joinTiles(
            order.map { tiles.indices.contains($0) ? tiles[$0] : "" },
            tight: cur?.screen.kind == .emailAssembly)
    }

    var tileComplete: Bool {
        !tileTask.tiles.isEmpty && order.count == tileTask.tiles.count
    }

    var tileCorrect: Bool {
        tileComplete
            && order.enumerated().allSatisfy { j, k in
                tileTask.tiles.indices.contains(k)
                    && (tileTask.key.indices.contains(j)
                        ? tileTask.tiles[k] == tileTask.key[j] : false)
            }
    }

    var hasTaskNav: Bool {
        guard let cur else { return false }
        switch cur.screen.payload {
        case .tiles(let t): return (t.tasks ?? []).count > 1
        case .order(let o): return (o.tasks ?? []).count > 1
        default: return false
        }
    }

    var taskCount: Int {
        guard let cur else { return 0 }
        switch cur.screen.payload {
        case .tiles(let t): return t.tasks?.count ?? 0
        case .order(let o): return o.tasks?.count ?? 0
        default: return 0
        }
    }

    var taskGoLabel: String { tk < taskCount - 1 ? "Next task" : "Go on" }

    func taskAdvance() {
        if tk < taskCount - 1 {
            tk += 1
            order = []
            sel = nil
            done = false
        } else {
            goto(p + 1)
        }
    }

    // MARK: Tile tap (lines 1566–1578)

    func toggleTile(_ k: Int) {
        if let ix = order.firstIndex(of: k) {
            order.remove(at: ix)
        } else {
            order.append(k)
        }
    }
}

extension Array where Element == Character {
    // No-op (kept for clarity).
}

extension String {
    /// "ABC"[j] — single-letter option id, as authored.
    static func letter(_ j: Int) -> String {
        let abc = "ABC"
        let idx = abc.index(abc.startIndex, offsetBy: Swift.min(j, abc.count - 1))
        return String(abc[idx])
    }
}
