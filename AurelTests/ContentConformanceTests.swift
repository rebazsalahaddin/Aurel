import XCTest

@testable import Aurel

/// Content-conformance harness — joins the authored english_course records
/// (parsed into the bundled course-manifest.json fixture by
/// `tools/export-content-manifest.mjs`) against the app's shipped
/// `a1-course.json`.
///
/// The manifest is the english_course side only; everything here reads the
/// shipped JSON dynamically (JSONSerialization) so the join can see every
/// item-bearing surface (`items`, `tasks`, and the C2 emailAssembly screen's
/// `id_`) without going through the app's decodable models.
///
/// Shipped-side field renames (the design-bank projection): instruction and
/// prompt→instr, feedback_correct/_incorrect→ok/no, hint_ladder→hints,
/// correct_option_ids→key, option text→opts[].t.
///
/// ## Documented drift
///
/// The shipped JSON is a hand-tuned projection of english_course, and a small
/// number of differences are REAL, known drift. Each instance is pinned
/// verbatim in `documentedDrift` below: a difference that is not in the
/// registry fails, and a registry entry that no longer occurs also fails —
/// the suite goes green the moment drift is fixed only by pruning its entry,
/// so the registry can never silently rot. The registries mirror the ledger
/// (qa/defects.md S2-004 and the Phase 0.6 conformance findings).
final class ContentConformanceTests: XCTestCase {

    // MARK: - Fixtures

    private lazy var manifest: [String: Any] = {
        guard
            let url = Bundle(for: ContentConformanceTests.self).url(
                forResource: "course-manifest", withExtension: "json")
        else {
            fatalError("course-manifest.json is missing from the test bundle")
        }
        do {
            return try JSONSerialization.jsonObject(with: Data(contentsOf: url)) as! [String: Any]
        } catch {
            fatalError("course-manifest.json failed to parse: \(error)")
        }
    }()

    private lazy var shipped: [[String: Any]] = {
        guard
            let url = Bundle(for: ContentConformanceTests.self).url(
                forResource: "a1-course", withExtension: "json")
                ?? Bundle.main.url(forResource: "a1-course", withExtension: "json")
        else {
            fatalError("a1-course.json is missing from the test and app bundles")
        }
        do {
            return try JSONSerialization.jsonObject(with: Data(contentsOf: url)) as! [[String: Any]]
        } catch {
            fatalError("a1-course.json failed to parse: \(error)")
        }
    }()

    private var manifestChapters: [[String: Any]] {
        manifest["chapters"] as! [[String: Any]]
    }

    private var parseSkipped: [[String: Any]] {
        (manifest["parse"] as! [String: Any])["skipped"] as! [[String: Any]]
    }

    // MARK: - Navigation helpers

    private func obj(_ value: Any?) -> [String: Any]? { value as? [String: Any] }

    private func objs(_ value: Any?) -> [[String: Any]] { value as? [[String: Any]] ?? [] }

    private func str(_ value: Any?) -> String? { value as? String }

    private func strs(_ value: Any?) -> [String] { value as? [String] ?? [] }

    private func chapterId(_ manifestChapter: [String: Any]) -> String {
        str(manifestChapter["dir"])!.replacingOccurrences(of: "_", with: "-")
    }

    private func shippedChapter(_ id: String) -> [String: Any] {
        shipped.first { str($0["id"]) == id }!
    }

    private func shippedLessons(_ chapter: [String: Any]) -> [[String: Any]] {
        objs(chapter["lessons"])
    }

    private func shippedScreens(_ chapter: [String: Any]) -> [[String: Any]] {
        shippedLessons(chapter).flatMap { objs($0["screens"]) }
    }

    /// Every shipped item that carries an id: the `items`/`tasks` arrays plus
    /// the C2 emailAssembly screen, which encodes PR-WR001 at screen level
    /// under `id_`.
    private func shippedItems(_ chapter: [String: Any]) -> [[String: Any]] {
        var out: [[String: Any]] = []
        for screen in shippedScreens(chapter) {
            if let keyed = str(screen["id_"]) {
                var merged = screen
                merged["id"] = keyed
                out.append(merged)
            }
            for prop in ["items", "tasks"] {
                for item in objs(screen[prop]) where str(item["id"]) != nil {
                    out.append(item)
                }
            }
        }
        return out
    }

    /// Every shipped vocabulary card: `cards` screens plus the warm-up/review
    /// `gallery` arrays — the same surfaces CourseStore.allVocabCards reads.
    private func shippedCards(_ chapter: [String: Any]) -> [[String: Any]] {
        var out: [[String: Any]] = []
        for screen in shippedScreens(chapter) {
            for prop in ["cards", "gallery"] {
                for card in objs(screen[prop]) where str(card["id"]) != nil {
                    out.append(card)
                }
            }
        }
        return out
    }

    private func manifestRecords(_ manifestChapter: [String: Any], _ kind: String)
        -> [[String: Any]]
    {
        objs((manifestChapter["records"] as? [String: Any])?[kind])
    }

    /// Authored record id → shipped item id: "A1-C01-PR-V001" → "PR-V001",
    /// "A1-C03-L01-PR-V001" → "PR-V001", "A1-C03-L03-WR001" → "WR001". The C3
    /// chapter quiz keeps its full ids in the bank ("A1-C03-QZ-L001").
    private func localId(_ recordId: String, chapter: String) -> String {
        if chapter == "A1-C03", recordId.contains("-QZ-") { return recordId }
        var parts = recordId.components(separatedBy: "-")
        parts.removeFirst(2)
        if let first = parts.first, first.count == 3, first.hasPrefix("L"),
            first.dropFirst().allSatisfy(\.isNumber)
        {
            parts.removeFirst()
        }
        return parts.joined(separator: "-")
    }

    /// Bank ids decomposed from one authored record carry a " · " suffix
    /// ("PR-G030 · blank 1") — they join on the prefix.
    private func joinKey(_ itemId: String) -> String {
        itemId.components(separatedBy: " · ").first ?? itemId
    }

    /// Quote-glyph canon: the C1/C2 banks set single-quoted words in curly
    /// glyphs where english_course uses straight ones — bank typography, not
    /// content, so strings compare modulo glyph direction.
    private func canon(_ s: String) -> String {
        s.replacingOccurrences(of: "‘", with: "'")
            .replacingOccurrences(of: "’", with: "'")
            .replacingOccurrences(of: "“", with: "\"")
            .replacingOccurrences(of: "”", with: "\"")
    }

    private func optionSignature(_ options: [[String: Any]]) -> String {
        options.compactMap { option -> String? in
            let id = str(option["id"]) ?? "?"
            let text = str(option["t"]) ?? str(option["text"]) ?? ""
            return "\(id):\(text)"
        }
        .joined(separator: "|")
    }

    /// The chapter's vocab records by their chapter-local id ("V001").
    private func vocabByLocalId(_ manifestChapter: [String: Any]) -> [String: [String: Any]] {
        var out: [String: [String: Any]] = [:]
        for record in manifestRecords(manifestChapter, "vocab") {
            if let id = str(record["id"]) {
                out[id.components(separatedBy: "-").last!] = record
            }
        }
        return out
    }

    /// The chapter's vocab records by primary spelling ("Canada") — used to
    /// resolve text-form keys onto the referenced card's art.
    private func vocabBySpelling(_ manifestChapter: [String: Any]) -> [String: [String: Any]] {
        var out: [String: [String: Any]] = [:]
        for record in manifestRecords(manifestChapter, "vocab") {
            if let spelling = str(record["spelling"]) {
                out[spelling] = record
            }
        }
        return out
    }

    // MARK: - The documented-drift registry

    private struct Drift: Equatable, Hashable {
        let key: String
        let shipped: String
    }

    /// One pinned shipped-vs-authored difference. Keys are
    /// "<chapter> <record>.<field>" and `shipped` is the exact value the app
    /// delivers today; anything outside this list is new drift and fails.
    /// One pinned shipped-vs-authored difference. Keys are
    /// "<chapter> <record>.<field>" and `shipped` is the exact value the app
    /// delivers today; anything outside this list is new drift and fails.
    ///
    /// The registry is currently EMPTY: the 40 documented drift entries were
    /// fixed in the export pipeline (tools/content-corrections.mjs, ledger
    /// S1-005/006, S2-004b/007/008/009/010). The mechanism stays as the
    /// tripwire for NEW drift — an entry may only land here together with a
    /// matching exporter correction or an owner deferral.
    private static let documentedDrift: Set<Drift> = []

    /// The registry slice a given test owns, by record-field suffix.
    private func registry(_ suffixes: String...) -> Set<Drift> {
        Self.documentedDrift.filter { entry in
            suffixes.contains { entry.key.hasSuffix($0) }
        }
    }

    /// Asserts `mismatches` contain nothing beyond the registry slice, and
    /// that the slice is fully exercised — no stale entries.
    private func assertExactlyDocumented(
        _ mismatches: [Drift], registry: Set<Drift>, field: String, file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let undocumented = Set(mismatches).subtracting(registry)
        XCTAssertTrue(
            undocumented.isEmpty,
            "undocumented \(field) drift (\(undocumented.count)): "
                + "\(undocumented.sorted { $0.key < $1.key })",
            file: file, line: line)
        let stale = registry.subtracting(Set(mismatches))
        XCTAssertTrue(
            stale.isEmpty,
            "stale registry entries (drift since fixed — prune them): "
                + "\(stale.sorted { $0.key < $1.key })",
            file: file, line: line)
    }

    // MARK: - 1. Lesson titles + order per chapter

    func testLessonMapsMatchManifest() {
        var mismatches: [Drift] = []
        for manifestChapter in manifestChapters {
            let id = chapterId(manifestChapter)
            let shippedLessons = shippedLessons(shippedChapter(id)).compactMap {
                (id: str($0["id"]), title: str($0["title"]))
            }
            let authored = objs(manifestChapter["lessons"]).compactMap {
                (id: str($0["id"]), title: str($0["title"]))
            }
            XCTAssertEqual(
                shippedLessons.map(\.id), authored.map(\.id),
                "\(id): shipped lesson order must match the manifest lesson map")
            XCTAssertEqual(shippedLessons.count, authored.count, "\(id): lesson count")
            for (shippedLesson, authoredLesson) in zip(shippedLessons, authored)
            where shippedLesson.title != authoredLesson.title {
                mismatches.append(
                    Drift(
                        key: "\(id) \(authoredLesson.id ?? "?").title",
                        shipped: shippedLesson.title ?? ""))
            }
        }
        assertExactlyDocumented(
            mismatches, registry: registry(".title"), field: "lesson title")
    }

    // MARK: - 2. Quiz item counts and id sets

    func testQuizBanksMatchAuthoredRecords() {
        let expectedCounts = ["A1-C01": 22, "A1-C02": 26, "A1-C03": 32]
        for manifestChapter in manifestChapters {
            let id = chapterId(manifestChapter)
            let records = manifestRecords(manifestChapter, "quiz")
            XCTAssertEqual(
                records.count, expectedCounts[id], "\(id): authored quiz Form A record count")
            let items = shippedItems(shippedChapter(id)).filter { str($0["id"])!.contains("QZ-") }
            XCTAssertEqual(items.count, expectedCounts[id], "\(id): shipped quiz items")
            let authoredIds = Set(records.map { localId(str($0["id"])!, chapter: id) })
            let shippedIds = Set(items.map { joinKey(str($0["id"])!) })
            XCTAssertEqual(
                shippedIds, authoredIds,
                "\(id): quiz item ids differ — only-authored "
                    + "\(authoredIds.subtracting(shippedIds).sorted()), only-shipped "
                    + "\(shippedIds.subtracting(authoredIds).sorted())")
        }
    }

    // MARK: - 3. Per-item conformance (options, key, ok, no, hints, tiles)

    func testPracticeItemsMatchAuthoredRecords() {
        var mismatches: [Drift] = []
        for manifestChapter in manifestChapters {
            let id = chapterId(manifestChapter)
            let vocab = vocabBySpelling(manifestChapter)
            let byJoin = Dictionary(grouping: shippedItems(shippedChapter(id))) {
                joinKey(str($0["id"])!)
            }
            let records =
                manifestRecords(manifestChapter, "practice")
                + manifestRecords(manifestChapter, "quiz")
            for record in records {
                let recordId = str(record["id"])!
                let matches = byJoin[localId(recordId, chapter: id)] ?? []
                XCTAssertFalse(
                    matches.isEmpty, "\(id): authored record \(recordId) ships nowhere")
                // Decomposed bank ids ("PR-G030 · blank 1") are bank-authored
                // per-step derivatives — the decomposition set is pinned
                // exactly in testDecompositionInventory, and per-step feedback
                // rewrites are excluded from field equality here.
                for item in matches where !str(item["id"])!.contains(" · ") {
                    compareFields(
                        record, item: item, chapterId: id, vocab: vocab,
                        mismatches: &mismatches)
                }
            }
        }
        assertExactlyDocumented(
            mismatches, registry: registry(".options", ".key", ".tiles", ".ok", ".no", ".hints"),
            field: "practice item")
    }

    /// Field-by-field comparison for one joined (non-decomposed) pair. Only
    /// fields both sides carry are compared — the C3 records author no hint
    /// ladders or second estimates, so those bank fields have no counterpart.
    private func compareFields(
        _ record: [String: Any], item: [String: Any], chapterId: String,
        vocab: [String: [String: Any]], mismatches: inout [Drift]
    ) {
        let itemId = str(item["id"])!

        // Options — verbatim, in authored order (id + text). Records whose
        // options are prose ("map cards — Canada / Japan / Egypt") have no
        // ordered option list to compare and are skipped here; their keys are
        // still resolved below.
        if let options = record["options"] as? [[String: Any]],
            !options.isEmpty,
            options.allSatisfy({ str($0["id"]) != nil && str($0["text"]) != nil }),
            let bankOptions = item["opts"] as? [[String: Any]]
        {
            let authored = optionSignature(options)
            let bank = optionSignature(bankOptions)
            if canon(authored) != canon(bank) {
                mismatches.append(Drift(key: "\(chapterId) \(itemId).options", shipped: bank))
            }
        }

        // Key — resolved through each side's own options so letter keys and
        // text keys (C3's "Canada"-style roll lookups over map-card options)
        // land on the same answer art/text.
        if let authoredKey = strs(record["key"]).first, let bankKey = str(item["key"]) {
            let authoredAnswer = resolve(
                authoredKey, options: (record["options"] as? [[String: Any]]) ?? [],
                textKey: "text", chapterId: chapterId, vocab: vocab)
            let bankAnswer = resolve(
                bankKey, options: (item["opts"] as? [[String: Any]]) ?? [], textKey: "t",
                chapterId: chapterId, vocab: vocab)
            if canon(authoredAnswer) != canon(bankAnswer) {
                mismatches.append(
                    Drift(key: "\(chapterId) \(itemId).key", shipped: "\(bankKey) → \(bankAnswer)"))
            }
        }

        // Tile-order items: the tiles are the options.
        let authoredTiles = strs(record["tiles"])
        let bankTiles = strs(item["tiles"])
        if !authoredTiles.isEmpty, !bankTiles.isEmpty,
            canon(authoredTiles.joined(separator: "␟")) != canon(bankTiles.joined(separator: "␟"))
        {
            mismatches.append(
                Drift(
                    key: "\(chapterId) \(itemId).tiles",
                    shipped: bankTiles.joined(separator: "␟")))
        }

        // Feedback and hint rungs — verbatim modulo quote glyphs.
        for field in ["ok", "no"] {
            if let authoredValue = str(record[field]).map(canon),
                let bankValue = str(item[field]).map(canon),
                authoredValue != bankValue
            {
                mismatches.append(
                    Drift(key: "\(chapterId) \(itemId).\(field)", shipped: bankValue))
            }
        }
        let authoredHints = strs(record["hints"]).map(canon)
        let bankHints = strs(item["hints"]).map(canon)
        if !authoredHints.isEmpty, !bankHints.isEmpty, authoredHints != bankHints {
            mismatches.append(
                Drift(
                    key: "\(chapterId) \(itemId).hints", shipped: bankHints.joined(separator: "␟")))
        }
    }

    /// Resolves an option key to its answer text: a letter key resolves
    /// through that side's own options (text, or the illustration id when the
    /// option is art — a plain string on the manifest side, an {id, alt} object
    /// on the bank side, and C3's bare "ILL002 …" asset descriptions); a text
    /// key resolves through the chapter's vocab records into the referenced
    /// card's art id.
    private func resolve(
        _ key: String, options: [[String: Any]], textKey: String, chapterId: String,
        vocab: [String: [String: Any]]
    ) -> String {
        if let hit = options.first(where: { str($0["id"]) == key }) {
            if let text = str(hit[textKey]) ?? str(hit["text"]) { return text }
            if let ill = str(hit["ill"]) ?? str(obj(hit["ill"])?["id"]) { return ill }
            if let asset = str(hit["asset"]),
                let ill = asset.range(of: #"ILL\d+"#, options: .regularExpression)
            {
                return "\(chapterId)-\(asset[ill])"
            }
            return key
        }
        if options.contains(where: { str($0[textKey]) == key || str($0["text"]) == key }) {
            return key
        }
        if let record = vocab[key], let ill = str(record["ill"]), !ill.isEmpty {
            return ill
        }
        return key
    }

    // MARK: - 4. Join coverage + the decomposition inventory

    /// Bank ids decomposed from a single authored record — the renderer's
    /// one-item-per-screen split of multi-blank/matching/trial records. The
    /// set is pinned exactly: a new decomposition or a collapsed one fails
    /// until this list is updated.
    private static let decomposedIds: Set<String> = [
        "A1-C01 PR-G030 · blank 1", "A1-C01 PR-G030 · blank 2",
        "A1-C01 PR-P001 · 1", "A1-C01 PR-P001 · 2", "A1-C01 PR-P001 · 3",
        "A1-C01 PR-P001 · 4", "A1-C01 PR-P001 · 5", "A1-C01 PR-P001 · 6",
        "A1-C01 PR-P002 · 1", "A1-C01 PR-P002 · 2", "A1-C01 PR-P002 · 3",
        "A1-C01 PR-P002 · 4", "A1-C01 PR-P002 · 5", "A1-C01 PR-P002 · 6",
        "A1-C01 PR-V036 · pair 1", "A1-C01 PR-V036 · pair 2", "A1-C01 PR-V036 · pair 3",
        "A1-C01 PR-LS011 · transfer", "A1-C01 PR-LS012 · transfer",
        "A1-C01 PR-LS013 · transfer", "A1-C01 PR-LS014 · transfer",
        "A1-C01 PR-LS015 · transfer", "A1-C01 PR-LS016 · transfer",
        "A1-C01 PR-CV006 · card 1", "A1-C01 PR-CV006 · card 2",
        "A1-C01 PR-CV006 · card 3", "A1-C01 PR-CV006 · card 4",
        "A1-C01 PR-CV014 · blank 1", "A1-C01 PR-CV014 · blank 2",
        "A1-C01 PR-RD007 · scene 1", "A1-C01 PR-RD007 · scene 2",
        "A1-C01 PR-WR004 · line 1", "A1-C01 PR-WR004 · line 2",
        "A1-C02 PR-LS011 · transfer", "A1-C02 PR-LS012 · transfer",
        "A1-C02 PR-LS013 · transfer", "A1-C02 PR-LS014 · transfer",
        "A1-C02 PR-LS015 · transfer", "A1-C02 PR-LS016 · transfer",
        "A1-C02 QZ-V004 · cumulative C1", "A1-C02 QZ-LS003 · cumulative C1",
        "A1-C02 QZ-RD002 · cumulative C1", "A1-C02 QZ-CN001 · cumulative C1",
    ]

    func testEveryAuthoredRecordShipsAndViceVersa() {
        for manifestChapter in manifestChapters {
            let id = chapterId(manifestChapter)
            let items = shippedItems(shippedChapter(id))
            let shippedJoinKeys = Set(items.map { joinKey(str($0["id"])!) })
            let records =
                manifestRecords(manifestChapter, "practice")
                + manifestRecords(manifestChapter, "quiz")
            for record in records {
                let key = localId(str(record["id"])!, chapter: id)
                XCTAssertTrue(
                    shippedJoinKeys.contains(key),
                    "\(id): authored record \(str(record["id"])!) ships nowhere")
            }
            let authoredKeys = Set(records.map { localId(str($0["id"])!, chapter: id) })
            for item in items {
                let itemId = str(item["id"])!
                XCTAssertTrue(
                    authoredKeys.contains(joinKey(itemId)),
                    "\(id): shipped item \(itemId) has no authored record")
            }
            let actualDecomposed = Set(
                items.compactMap { item -> String? in
                    let itemId = str(item["id"])!
                    return itemId.contains(" · ") ? "\(id) \(itemId)" : nil
                })
            XCTAssertEqual(
                actualDecomposed, Self.decomposedIds.filter { $0.hasPrefix(id) },
                "\(id): the decomposition inventory drifted")
        }
    }

    // MARK: - 5. Vocab card invariants + card alt parity

    func testVocabCardsMatchAuthoredRecords() {
        var mismatches: [Drift] = []
        for manifestChapter in manifestChapters {
            let id = chapterId(manifestChapter)
            let records = vocabByLocalId(manifestChapter)
            for card in shippedCards(shippedChapter(id)) {
                let cardId = str(card["id"])!
                guard let record = records[cardId] else {
                    XCTFail("\(id): shipped card \(cardId) has no authored record")
                    continue
                }
                if let w = str(card["w"]), w != str(record["spelling"]) {
                    mismatches.append(Drift(key: "\(id) \(cardId).w", shipped: w))
                }
                // An authored empty illustration ("") means app-layer icon, no
                // art — the card then carries `icon`, not `ill`.
                let cardIll = str(obj(card["ill"])?["id"]) ?? ""
                let recordIll = str(record["ill"]) ?? ""
                if cardIll != recordIll {
                    mismatches.append(Drift(key: "\(id) \(cardId).ill", shipped: cardIll))
                }
                // The card's alt must be the record's authored alt_text. The
                // banks sentence-case card alts, so the comparison is
                // case-insensitive on the first character only. Icon-only
                // records (authored illustration "") carry no art alt.
                if let recordAlt = str(record["alt"]), let cardIllObject = obj(card["ill"]) {
                    let cardAlt = str(cardIllObject["alt"]) ?? ""
                    if canon(Self.loweringFirstGlyph(cardAlt))
                        != canon(Self.loweringFirstGlyph(recordAlt))
                    {
                        mismatches.append(
                            Drift(key: "\(id) \(cardId).cardAlt", shipped: cardAlt))
                    }
                }
            }
        }
        assertExactlyDocumented(
            mismatches, registry: registry(".w", ".ill", ".cardAlt"), field: "vocab card")
    }

    // MARK: - 6. Alt-text parity within a chapter (S2-004 class)

    /// ILL ids the shipped JSON currently shows with more than one distinct
    /// alt within their chapter, mapped to the number of distinct alts — the
    /// qa/defects.md S2-004 drift surface, pinned. english_course itself
    /// authors per-use alts (a vocab record's alt_text differs from its ILL
    /// brief's), so what is guaranteed here is the drift SET, exactly: a new
    /// inconsistent id fails, and an id that becomes consistent again fails
    /// until its entry is pruned.
    private static let documentedIllVariantCounts: [String: [String: Int]] = [
        "A1-C01": [
            "A1-C01-ILL001": 4, "A1-C01-ILL002": 6, "A1-C01-ILL003": 3, "A1-C01-ILL004": 5,
            "A1-C01-ILL005": 3, "A1-C01-ILL006": 2, "A1-C01-ILL007": 2, "A1-C01-ILL009": 2,
            "A1-C01-ILL013": 6, "A1-C01-ILL015": 3, "A1-C01-ILL016": 4,
            "A1-C01-ILL017": 3, "A1-C01-ILL018": 8, "A1-C01-ILL019": 4, "A1-C01-ILL020": 5,
            "A1-C01-ILL021": 3, "A1-C01-ILL022": 4, "A1-C01-ILL027": 2, "A1-C01-ILL028": 2,
            "A1-C01-ILL032": 2, "A1-C01-ILL033": 3,
        ],
        "A1-C02": [
            "A1-C02-ILL002": 3, "A1-C02-ILL010": 4, "A1-C02-ILL012": 3, "A1-C02-ILL013": 2,
            "A1-C02-ILL014": 3, "A1-C02-ILL018": 3, "A1-C02-ILL019": 3, "A1-C02-ILL020": 2,
            "A1-C02-ILL022": 2, "A1-C02-ILL023": 3, "A1-C02-ILL024": 5, "A1-C02-ILL028": 4,
            "A1-C02-ILL032": 2, "A1-C02-ILL034": 2,
        ],
        "A1-C03": [
            "A1-C03-ILL001": 7, "A1-C03-ILL002": 5, "A1-C03-ILL003": 3, "A1-C03-ILL004": 2,
            "A1-C03-ILL005": 3, "A1-C03-ILL006": 2, "A1-C03-ILL008": 2, "A1-C03-ILL009": 2,
            "A1-C03-ILL010": 3, "A1-C03-ILL011": 2, "A1-C03-ILL012": 2, "A1-C03-ILL013": 3,
            "A1-C03-ILL014": 2, "A1-C03-ILL015": 3, "A1-C03-ILL016": 2, "A1-C03-ILL017": 3,
            "A1-C03-ILL018": 2, "A1-C03-ILL019": 2, "A1-C03-ILL020": 2, "A1-C03-ILL021": 2,
            "A1-C03-ILL022": 5, "A1-C03-ILL032": 2,
        ],
    ]

    func testAltTextParityWithinChapter() {
        for manifestChapter in manifestChapters {
            let id = chapterId(manifestChapter)
            var altsById: [String: Set<String>] = [:]
            collectAlts(shippedChapter(id), prefix: "\(id)-ILL", into: &altsById)
            let inconsistentCounts = Dictionary(
                uniqueKeysWithValues: altsById.filter { $0.value.count > 1 }
                    .map { ($0.key, $0.value.count) })
            let documentedCounts = Self.documentedIllVariantCounts[id]!
            let newDrift = inconsistentCounts.keys.filter { documentedCounts[$0] == nil }.sorted()
            let fixed = documentedCounts.keys.filter { inconsistentCounts[$0] == nil }.sorted()
            XCTAssertTrue(
                newDrift.isEmpty,
                "\(id): ILL ids newly carrying more than one distinct alt: \(newDrift)")
            XCTAssertTrue(
                fixed.isEmpty,
                "\(id): ILL ids now consistent — prune their registry entries: \(fixed)")
            XCTAssertEqual(
                inconsistentCounts.map { "\($0.key):\($0.value)" }.sorted(),
                documentedCounts.map { "\($0.key):\($0.value)" }.sorted(),
                "\(id): distinct-alt counts per ILL id changed (drift surface)")
        }
    }

    /// Lowercases only the first character (the banks sentence-case card alts);
    /// empty strings pass through.
    private static func loweringFirstGlyph(_ s: String) -> String {
        guard let first = s.first else { return s }
        return String(first.lowercased()) + s.dropFirst()
    }

    private func collectAlts(
        _ node: Any, prefix: String, into altsById: inout [String: Set<String>]
    ) {
        if let dict = node as? [String: Any] {
            if let id = str(dict["id"]), id.hasPrefix(prefix), let alt = str(dict["alt"]) {
                altsById[id, default: []].insert(alt)
            }
            for value in dict.values {
                collectAlts(value, prefix: prefix, into: &altsById)
            }
        } else if let list = node as? [Any] {
            for value in list { collectAlts(value, prefix: prefix, into: &altsById) }
        }
    }

    // MARK: - 7. Screen-count deltas

    func testScreenInventoryDeltasMatchDocumentedSplits() {
        // The banks split some authored screens into extra swaps (C1's
        // S23b/S26b/S34a, C2's S25b/S28b/S31b/S36a) and the exporter's C3
        // closer replacement adds S29a/S30a over the authored S29–S32.
        let documentedExtras: [String: Set<String>] = [
            "A1-C01": ["S23b", "S26b", "S34a"],
            "A1-C02": ["S25b", "S28b", "S31b", "S36a"],
            "A1-C03": ["S29a", "S30a"],
        ]
        for manifestChapter in manifestChapters {
            let id = chapterId(manifestChapter)
            let expectations = obj(manifestChapter["manifest"]) ?? [:]
            let authored = strs(expectations["screenIds"])
            let shippedScreenIds = shippedScreens(shippedChapter(id)).compactMap { str($0["id"]) }
            let extras = documentedExtras[id]!
            XCTAssertEqual(
                Set(shippedScreenIds), Set(authored).union(extras),
                "\(id): shipped screen set ≠ authored inventory + documented splits; unexpected "
                    + Set(shippedScreenIds).subtracting(authored).subtracting(extras).sorted()
                    .joined(separator: ",")
                    + "; missing "
                    + Set(authored).subtracting(shippedScreenIds).sorted().joined(separator: ","))
            XCTAssertEqual(
                shippedScreenIds.count, authored.count + extras.count,
                "\(id): screen count delta")
            if let statedTotal = expectations["screenInventoryTotal"] as? Int {
                XCTAssertEqual(
                    shippedScreenIds.count, statedTotal + extras.count,
                    "\(id): shipped screens vs the manifest's stated inventory (\(statedTotal))")
            }
        }
    }

    // MARK: - 8. Parser gate

    func testParseSkippedIsEmptyForVerifiedChapters() {
        let inScope = parseSkipped.filter { entry in
            guard let file = str(entry["file"]) else { return false }
            return file.contains("/A1_C01/") || file.contains("/A1_C02/")
                || file.contains("/A1_C03/")
        }
        XCTAssertTrue(
            inScope.isEmpty,
            "english_course C01–C03 must parse with zero skipped blocks: \(inScope)")
        // The report-only chapters (owner decision 1: C4/C5 are outside this
        // run's scope) may carry structural continuation blocks; they are
        // recorded, never dropped silently.
        let reportOnly = parseSkipped.filter { entry in
            guard let file = str(entry["file"]) else { return false }
            return file.contains("/A1_C04/") || file.contains("/A1_C05/")
        }
        XCTAssertEqual(
            parseSkipped.count, inScope.count + reportOnly.count,
            "every skipped block must be attributed to a known chapter scope")
    }

    /// Phase 6 (exercise-accuracy audit): a single-choice key must grade
    /// exactly one option. Authored keys are option ids, so an option whose
    /// text echoes another option's id (the C2 letter items: option A shows
    /// "B") used to grade both under the old id-OR-text rule. Grading is
    /// id-first now (`PlayerModel.matchesKey`); this pins the content side —
    /// every keyed item keys exactly one option under that rule.
    func testSingleChoiceKeysGradeExactlyOneOption() {
        for manifestChapter in manifestChapters {
            let id = chapterId(manifestChapter)
            for item in shippedItems(shippedChapter(id)) {
                guard let key = str(item["key"]), (item["tiles"] as? [Any]) == nil,
                    (item["pairs"] as? [Any]) == nil, (item["baskets"] as? [Any]) == nil
                else { continue }
                let opts = objs(item["opts"])
                guard !opts.isEmpty else { continue }
                let matching = opts.filter { opt in
                    let optId = str(opt["id"]) ?? ""
                    let text = str(opt["t"]) ?? ""
                    if opts.contains(where: { str($0["id"]) == key }) {
                        return optId == key
                    }
                    return text == key
                }
                XCTAssertEqual(
                    matching.count, 1,
                    "\(id) \(str(item["id"]) ?? "?"): key \"\(key)\" grades \(matching.count) "
                        + "options — an option's text must not echo another option's id")
            }
        }
    }
}
