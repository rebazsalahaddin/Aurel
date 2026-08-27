import Foundation

// MARK: - Dialogue timeline resolver
//
// Maps the rows a screen renders onto the recorded takes of the asset that
// voices them — the "Dialogue Timeline Resolver" step of the karaoke pipeline:
//
//   Audio Player → spokenAssetID + spokenLine → KaraokeTimeline.align → row
//
// Matching is identity/order based, never raw text equality:
//   * Authored recordings carry TTS pacing that the learner-facing rows do
//     not ("…" pauses, inserted fragments like "Hmm — today:"), so rows are
//     matched on normalized, punctuation-free word tokens.
//   * Learner ("YOU") turns are never recorded and never highlight.
//   * Duplicate lines (the same speaker saying the same words twice) resolve
//     in authored ORDER — the cursor only ever moves forward — so exactly one
//     row can ever map to a given take, and only one row can be active at a
//     time.
//   * A row the audio never voices maps to nil and simply stays dark (an
//     asset whose narration script differs from the dialogue on screen).

enum KaraokeTimeline {
    /// One rendered line a screen wants highlighted while it is spoken.
    struct Row: Hashable {
        let speaker: String?
        let text: String

        init(speaker: String?, text: String) {
            self.speaker = speaker
            self.text = text
        }

        init(text: String) {
            self.init(speaker: nil, text: text)
        }
    }

    /// For each row, the index of the catalog line that voices it — nil when
    /// no line does (learner turns, text the recording never says).
    /// Deterministic: a pure function of (rows, lines).
    static func align(rows: [Row], lines: [AudioCatalog.Line]) -> [Int?] {
        var mapped = [Int?](repeating: nil, count: rows.count)
        let candidates = lines.map { line in
            (speaker: normalizedSpeaker(line.speaker), tokens: tokens(line.text))
        }
        var cursor = 0

        for (index, row) in rows.enumerated() {
            let speaker = normalizedSpeaker(row.speaker ?? "")
            if speaker == "YOU" { continue }  // learner turns are never recorded
            let rowTokens = tokens(row.text)
            guard !rowTokens.isEmpty else { continue }

            // Pass 1 — exact normalized text (the authored norm).
            if let hit = match(
                from: cursor, speaker: speaker, tokens: rowTokens,
                candidates: candidates, paced: false)
            {
                mapped[index] = hit
                cursor = hit + 1
                continue
            }
            // Pass 2 — paced variant: the recording may insert or keep extra
            // filler tokens; the row's tokens must still appear in order.
            if let hit = match(
                from: cursor, speaker: speaker, tokens: rowTokens,
                candidates: candidates, paced: true)
            {
                mapped[index] = hit
                cursor = hit + 1
            }
        }
        return mapped
    }

    /// Case/diacritic-folded, punctuation-free word tokens — "Hi, Maya! …"
    /// and "Hi Maya" grade identically.
    static func tokens(_ text: String) -> [String] {
        text.folding(
            options: [.caseInsensitive, .diacriticInsensitive],
            locale: Locale(identifier: "en_US")
        )
        .components(separatedBy: CharacterSet.alphanumerics.inverted)
        .filter { !$0.isEmpty }
    }

    /// `needle` appears in `haystack` in order (extras allowed between
    /// matches); an empty needle never matches.
    static func isOrderedSubsequence(_ needle: [String], of haystack: [String]) -> Bool {
        guard !needle.isEmpty else { return false }
        var matched = 0
        for token in haystack where matched < needle.count {
            if token == needle[matched] { matched += 1 }
        }
        return matched == needle.count
    }

    private static func normalizedSpeaker(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    }

    /// A row speaker is optional; when both name one, they must agree.
    private static func speakersAgree(_ row: String, _ line: String) -> Bool {
        row.isEmpty || line.isEmpty || row == line
    }

    private static func match(
        from cursor: Int,
        speaker: String,
        tokens: [String],
        candidates: [(speaker: String, tokens: [String])],
        paced: Bool
    ) -> Int? {
        for line in cursor..<candidates.count
        where speakersAgree(speaker, candidates[line].speaker) {
            let lineTokens = candidates[line].tokens
            if paced {
                if isOrderedSubsequence(tokens, of: lineTokens)
                    || isOrderedSubsequence(lineTokens, of: tokens)
                {
                    return line
                }
            } else if lineTokens == tokens {
                return line
            }
        }
        return nil
    }
}
