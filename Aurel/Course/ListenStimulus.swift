import Foundation

// MARK: - Listen-then-answer stimulus
//
// Course audio is still a TTS stand-in, but listen-then-answer items must not
// speak the keyed option or a whole conversation. Dialogue lines are indexed
// from conversation turns, testlet challenge/scripts/transfer scripts, and
// lineAud aliases. `playLines` is 1-based to match `_L1`, `_L2`.

struct ListenStimulus: Sendable, Hashable {
    struct Line: Sendable, Hashable {
        let speaker: String
        let text: String
    }

    /// chapterID → short aud (AUD043) → lines
    private let scripts: [String: [String: [Line]]]

    init(chapters: [CourseChapter]) {
        var scripts: [String: [String: [Line]]] = [:]

        func put(_ chapterID: String, _ aud: String?, _ lines: [Line]) {
            guard let aud, !aud.isEmpty, aud != "LINE", !lines.isEmpty else { return }
            let short = Self.shortID(aud)
            var chapter = scripts[chapterID] ?? [:]
            guard chapter[short] == nil else { return }
            chapter[short] = lines
            scripts[chapterID] = chapter
        }

        for chapter in chapters {
            for lesson in chapter.lessons {
                for screen in lesson.screens {
                    if case .conversation(let conversation) = screen.payload {
                        let lines = (conversation.turns ?? []).map {
                            Line(speaker: $0.sp, text: $0.t)
                        }
                        put(chapter.id, conversation.aud, lines)
                        put(chapter.id, conversation.lineAud, lines)
                    }
                }
            }
        }

        for chapter in chapters {
            for lesson in chapter.lessons {
                for screen in lesson.screens {
                    guard case .testlet(let testlet) = screen.payload else { continue }
                    if let challenge = testlet.challenge, !challenge.isEmpty {
                        put(
                            chapter.id, testlet.aud,
                            challenge.map { Line(speaker: $0.sp, text: $0.t) })
                    }
                    if let authored = testlet.scripts, !authored.isEmpty {
                        put(
                            chapter.id, testlet.aud,
                            authored.map { Line(speaker: $0.sp, text: $0.t) })
                        for line in authored {
                            put(
                                chapter.id, line.id,
                                [Line(speaker: line.sp, text: line.t)])
                        }
                    }
                }
            }
        }

        // Do not copy a testlet's long stimulus onto every item aud — transfer
        // items often reuse short models (AUD030, AUD032) that must stay one line.

        let aliases = ["AUD044": "AUD043", "AUD051": "AUD050"]
        for (chapterID, table) in scripts {
            for (alias, source) in aliases {
                if let lines = table[source] {
                    put(chapterID, alias, lines)
                }
            }
        }

        for chapter in chapters {
            for lesson in chapter.lessons {
                for screen in lesson.screens {
                    guard case .testlet(let testlet) = screen.payload,
                        let transfer = testlet.transferScript, !transfer.isEmpty
                    else { continue }
                    let transferLines = transfer.map { Line(speaker: $0.sp, text: $0.t) }
                    for item in testlet.items ?? [] {
                        put(chapter.id, item.aud, transferLines)
                    }
                }
            }
        }

        self.scripts = scripts
    }

    func lines(chapterID: String, aud: String?) -> [Line] {
        guard let aud, !aud.isEmpty else { return [] }
        return scripts[chapterID]?[Self.shortID(aud)] ?? []
    }

    /// Joins the requested 1-based lines. Speaker names prefix a turn so a
    /// gist clip with two voices is countable without playing the full talk.
    func spokenText(chapterID: String, aud: String?, playLines: [Int]?) -> String? {
        guard let playLines, !playLines.isEmpty else { return nil }
        let all = lines(chapterID: chapterID, aud: aud)
        guard !all.isEmpty else { return nil }
        let picked: [String] = playLines.compactMap { number in
            let index = number - 1
            guard all.indices.contains(index) else { return nil }
            let line = all[index]
            let speaker = line.speaker.trimmingCharacters(in: .whitespacesAndNewlines)
            if speaker.isEmpty { return line.text }
            return "\(speaker.capitalized): \(line.text)"
        }
        guard !picked.isEmpty else { return nil }
        return picked.joined(separator: " ")
    }

    static func shortID(_ aud: String) -> String {
        if let range = aud.range(of: "AUD", options: .caseInsensitive) {
            return String(aud[range.lowerBound...])
        }
        return aud
    }
}

enum ListenCue {
    /// The text Listen should speak for a listen-then-answer item.
    static func spoken(
        said: SaidLine?,
        prompt: String?,
        playLines: [Int]?,
        aud: String?,
        chapterID: String,
        stimulus: ListenStimulus,
        keyText: String?,
        word: String?
    ) -> String? {
        if let said = said?.t.trimmingCharacters(in: .whitespacesAndNewlines), !said.isEmpty {
            return said
        }
        // `You hear: “…”` is the stimulus. `Who says “…”?` names a line the
        // learner must identify — prefer `playLines` so they hear the turn.
        let whoSays = prompt?.localizedCaseInsensitiveContains("who says") == true
        if !whoSays, let quoted = quoted(from: prompt) { return quoted }
        if let excerpt = stimulus.spokenText(
            chapterID: chapterID, aud: aud, playLines: playLines)
        {
            return excerpt
        }
        if whoSays, let quoted = quoted(from: prompt) { return quoted }
        if let keyText, !keyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return keyText
        }
        if let word, !word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return word
        }
        return nil
    }

    /// Quoted span in a learner prompt (`You hear: “…”`, `Who says: "…"`).
    static func quoted(from prompt: String?) -> String? {
        guard let prompt, !prompt.isEmpty else { return nil }
        if let start = prompt.firstIndex(of: "“") {
            let after = prompt.index(after: start)
            if after < prompt.endIndex, let end = prompt[after...].firstIndex(of: "”") {
                let text = String(prompt[after..<end]).trimmingCharacters(in: .whitespaces)
                if !text.isEmpty { return text }
            }
        }
        if let start = prompt.firstIndex(of: "‘"),
            let end = prompt[prompt.index(after: start)...].firstIndex(of: "’")
        {
            let text = String(prompt[prompt.index(after: start)..<end])
                .trimmingCharacters(in: .whitespaces)
            if !text.isEmpty { return text }
        }
        var open: String.Index?
        for index in prompt.indices where prompt[index] == "\"" {
            if let start = open {
                let text = String(prompt[prompt.index(after: start)..<index])
                    .trimmingCharacters(in: .whitespaces)
                if !text.isEmpty { return text }
                open = nil
            } else {
                open = index
            }
        }
        return nil
    }
}
