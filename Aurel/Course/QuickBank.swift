import Foundation

// MARK: - Quick-practice bank
//
// Port of bankFromCourse() / wordsFromCourse() / sceneFromCourse()
// (Aurel.dc.html lines 1572–1706). The quick-practice session draws from the
// authored chapter banks only — nothing is invented.

/// One quick-practice item, as the shell's lesson runner consumes them.
struct QuickItem: Identifiable, Hashable, Sendable {
    enum Kind: Hashable, Sendable { case flash, choice, listen, order, match, pattern }

    let id: String
    let type: Kind
    var kicker: String = ""
    // flash
    var front: String = ""
    var back: String = ""
    var ex: String = ""
    var ipa: String = ""
    var ill: IllustrationRef? = nil
    // choice / listen
    var options: [String] = []
    var answer: Int = 0
    var prompt: String = ""
    var stem: String = ""
    var why: String = ""
    var hint: String = ""
    // listen
    var audio: String = ""
    var audioAsset: String = ""
    // order
    var words: [String] = []
    var answerText: String { answerString }
    var answerString: String = ""

    var src: String = ""
}

extension QuickItem {
    /// bankFromCourse()
    static func bank(from course: CourseStore) -> [QuickItem] {
        var flash: [QuickItem] = []
        var choice: [QuickItem] = []
        var listen: [QuickItem] = []
        var order: [QuickItem] = []

        for f in course.flat {
            let src = "\(f.chapter.id)-\(f.lesson.id)"
            switch f.screen.payload {
            case .cards(let sc):
                for c in sc.cards ?? [] {
                    guard let fn = c.fn else { continue }
                    flash.append(
                        QuickItem(
                            id: "\(src)-\(c.id)",
                            type: .flash,
                            kicker: "Vocabulary · \(c.id)",
                            front: c.w,
                            back: fn,
                            ex: c.frame ?? "",
                            ipa: c.ipa ?? "",
                            ill: c.ill,
                            src: src
                        ))
                }
            case .practice(let sc):
                append(
                    items: sc.items, src: src, chapterId: f.chapter.id,
                    stimulus: course.listenStimulus,
                    into: &choice, &listen, &order)
            case .quiz(let sc):
                append(
                    items: sc.items, src: src, chapterId: f.chapter.id,
                    stimulus: course.listenStimulus,
                    into: &choice, &listen, &order)
            case .reading(let sc):
                append(
                    items: sc.items, src: src, chapterId: f.chapter.id,
                    stimulus: course.listenStimulus,
                    into: &choice, &listen, &order)
            case .testlet(let sc):
                append(
                    items: sc.items, src: src, chapterId: f.chapter.id,
                    stimulus: course.listenStimulus,
                    into: &choice, &listen, &order)
            default:
                break
            }
        }

        // pick(arr, n) — even sampling, then the authored interleaving.
        func pick<T>(_ arr: [T], _ n: Int) -> [T] {
            let stride = max(1, arr.count / n)
            return arr.enumerated().filter { $0.offset % stride == 0 }.prefix(n).map(\.element)
        }

        var out: [QuickItem] = []
        if !flash.isEmpty { out.append(flash[0]) }
        let c = pick(choice, 2)
        let l = pick(listen, 2)
        let o = pick(order, 1)
        if c.indices.contains(0) { out.append(c[0]) }
        if l.indices.contains(0) { out.append(l[0]) }
        if o.indices.contains(0) { out.append(o[0]) }
        if c.indices.contains(1) { out.append(c[1]) }
        if l.indices.contains(1) { out.append(l[1]) }
        return out
    }

    /// The per-screen item walk inside bankFromCourse (lines 1582–1600).
    private static func append(
        items: [PracticeItem]?,
        src: String,
        chapterId: String,
        stimulus: ListenStimulus,
        into choice: inout [QuickItem],
        _ listen: inout [QuickItem],
        _ order: inout [QuickItem]
    ) {
        for it in items ?? [] {
            if it.kind == "order", let tiles = it.tiles, !tiles.isEmpty {
                var item = QuickItem(
                    id: "\(src)-\(it.id)", type: .order, kicker: "Word order · \(it.id)")
                item.prompt = it.instr.isEmpty ? "Put in order." : it.instr
                item.words = tiles
                item.answerString = (it.key?.sequence ?? []).joined(separator: " ")
                item.why = it.ok ?? ""
                item.hint = it.no ?? ""
                item.src = src
                order.append(item)
                continue
            }
            let opts = (it.opts ?? []).filter { !($0.text ?? "").isEmpty }
            guard opts.count >= 2, it.kind != "image", it.kind != "pairs", it.kind != "sort",
                it.kind != "speak"
            else { continue }
            let answer = max(
                0, opts.firstIndex { $0.id == it.key?.single || $0.text == it.key?.single } ?? 0)
            var base = QuickItem(
                id: "\(src)-\(it.id)",
                type: it.aud != nil ? .listen : .choice,
                kicker: it.id.replacingOccurrences(
                    of: "^PR-", with: "", options: .regularExpression) + " · " + src
            )
            base.options = opts.compactMap(\.text)
            base.answer = answer
            base.why = it.ok ?? ""
            base.hint = it.no ?? ""
            base.src = src
            if it.aud != nil {
                let keyText =
                    opts.indices.contains(answer) ? opts[answer].text : nil
                let cue = ListenCue.spoken(
                    said: it.said,
                    prompt: it.prompt,
                    playLines: it.playLines,
                    aud: it.aud,
                    chapterID: chapterId,
                    stimulus: stimulus,
                    keyText: keyText,
                    word: it.word)
                base.audio = cue ?? it.prompt ?? "Listening prompt"
                base.audioAsset = it.aud.map { "\(chapterId)-\($0)" } ?? ""
                base.prompt = it.prompt ?? ""
                listen.append(base)
            } else {
                base.prompt = it.instr.isEmpty ? "Choose." : it.instr
                base.stem = it.prompt ?? ""
                choice.append(base)
            }
        }
    }

}

// MARK: - Word sheet (wordsFromCourse)

struct WordRow: Identifiable, Hashable, Sendable {
    let id: String
    let w: String
    let m: String
    let e: String
    let r: String
    let st: String
    let seen: String
    let ill: IllustrationRef?
    let aud: String

    /// wordsFromCourse()
    static func words(from course: CourseStore) -> [WordRow] {
        var out: [WordRow] = []
        for f in course.flat {
            if case .cards(let sc) = f.screen.payload {
                for c in sc.cards ?? [] {
                    guard let fn = c.fn else { continue }
                    out.append(
                        WordRow(
                            id: "\(f.chapter.id)-\(f.lesson.id)-\(c.id)",
                            w: c.w,
                            m: fn,
                            e: c.frame ?? "",
                            r: c.ipa.map { ipa in ipa + (c.stress.map { " · \($0)" } ?? "") } ?? "",
                            st: "Taught",
                            seen: "\(f.chapter.id)-\(f.lesson.id)-\(c.id)",
                            ill: c.ill,
                            aud: c.aud.map { "\(f.chapter.id)-\($0)" } ?? ""
                        ))
                }
            }
        }
        return out
    }
}

// MARK: - Scene player (sceneFromCourse)

struct SceneScript: Sendable, Hashable {
    struct Reply: Sendable, Hashable {
        let t: String
        let reg: String
    }

    struct Turn: Sendable, Hashable {
        let them: String
        let replies: [Reply]
    }

    let title: String
    let role: String
    let close: String
    let source: String
    let turns: [Turn]

    /// sceneFromCourse() — the newest authored roleplay plus its rehearsal taps.
    static func newest(from course: CourseStore) -> SceneScript {
        for f in course.flat.reversed() {
            var roleplay: RoleplayScreen?
            for s in f.lesson.screens {
                if case .roleplay(let rp) = s.payload {
                    roleplay = rp
                    break
                }
            }
            guard let rp = roleplay else { continue }

            // The rehearsal practice with ≥3-option items on the same lesson.
            var rehearsalItems: [PracticeItem] = []
            for s in f.lesson.screens {
                if case .practice(let pr) = s.payload {
                    let items = (pr.items ?? []).filter { ($0.opts ?? []).count >= 3 }
                    if !items.isEmpty {
                        rehearsalItems = items
                        break
                    }
                }
            }
            guard !rehearsalItems.isEmpty else { continue }

            return SceneScript(
                title: (f.screen.label ?? "").replacingOccurrences(
                    of: "^Roleplay — ", with: "", options: .regularExpression) + " · "
                    + (rp.spec ?? ""),
                role: rp.scenario ?? "",
                close: "Slots completed, not perfection: "
                    + (rp.checklist ?? []).joined(separator: " · ") + ".",
                source: "\(f.chapter.id) · \(f.lesson.src ?? "")",
                turns: rehearsalItems.map { it in
                    Turn(
                        them: it.prompt ?? "",
                        replies: (it.opts ?? []).map { o in
                            Reply(
                                t: o.text ?? "",
                                reg: (o.id == it.key?.single || o.text == it.key?.single)
                                    ? (it.ok ?? "") : (it.no ?? ""))
                        }
                    )
                }
            )
        }
        return SceneScript(
            title: "Scene — awaiting content",
            role: "No roleplay is authored yet.",
            close: "",
            source: "",
            turns: [Turn(them: "", replies: [])]
        )
    }
}
