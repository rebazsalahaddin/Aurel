import Observation
import SwiftUI
import UIKit

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
    /// Craft overhaul L7: direction of the last goto (+1 forward, -1 back),
    /// read by the player to drive direction-aware screen-swap transitions.
    var lastDelta = 1
    var sel: String? = nil
    var wrong = 0
    var done = false
    var plays = 0
    /// Card indexes on the current screen whose Listen button has been tapped.
    var heardCardIndexes: Set<Int> = []
    var caps = false
    var demo = 0
    var tried = false
    var notice = 0
    var revealed = false
    var learningStep = 0
    var learningSelection: String? = nil
    var learningComplete = false
    var learningWrong = 0
    var order: [Int] = []  // tile order (indexes into tiles)
    var picked: [String: String] = [:]
    var tk = 0  // task index (tiles/order screens)
    var teachShut = false
    var rec = 0
    var showScore = false
    var quizCorrect = 0
    var quizTotal = 0

    var quizScorePercentage: Int {
        quizTotal > 0 ? Int(round(Double(quizCorrect) / Double(quizTotal) * 100)) : 0
    }

    var quizPassed: Bool {
        quizScorePercentage >= 75
    }

    var flip: [String: Bool] = [:]
    var turn = 1  // conversation playback turn
    var matchSelection: Int? = nil
    var matched: Set<Int> = []

    struct RoleplayLine: Identifiable, Equatable {
        let id: Int
        let speaker: String
        let text: String
        let learner: Bool
    }

    var roleplayLines: [RoleplayLine] = []
    var roleplayUsedGroups: Set<String> = []
    var roleplayUserTurns = 0
    var roleplayFinished = false
    private var roleplayStarted = false
    private var roleplayLineSerial = 0

    /// Shared say-aloud take coordinator for pronunciation screens (§3.11c).
    let say = SayCoach()

    let course: CourseStore
    let bound: Bool
    var onFinish: () -> Void
    var onExit: () -> Void
    var onScreen: (Int) -> Void

    /// The recorded course player, attached by the hosting view.
    var speaker: (any AudioPlaying)? {
        didSet {
            let playback = speaker
            say.onCaptureWillBegin = { playback?.stop() }
        }
    }

    /// The player narrowed to the recorded-audio implementation, whose
    /// karaoke state (`spokenLineText`/`spokenRange`) screen views observe.
    /// Reading it in a view body tracks the underlying observables.
    var playback: VoicePlayback? {
        speaker as? VoicePlayback
    }

    // MARK: Karaoke identity (the dialogue timeline resolver's consumer)
    //
    // Screens ask the MODEL whether a rendered row is the one being spoken.
    // Matching runs on playback identity — (asset id, absolute catalog line
    // index) resolved through `KaraokeTimeline` — never on raw text equality,
    // so duplicated lines, TTS-paced scripts, and learner turns stay
    // deterministic, and stale playback from another screen can never light
    // foreign rows.

    /// True while the asset behind `audio` is playing and its currently
    /// spoken catalog line is the one that voices row `index` of `rows`.
    func isSpeakingRow(_ index: Int, in rows: [KaraokeTimeline.Row], audio: String?) -> Bool {
        guard let playback, playback.speaking,
            let assetID = resolvedAudioID(audio),
            playback.spokenAssetID == assetID,
            let asset = playback.catalog.asset(assetID),
            !asset.lines.isEmpty
        else { return false }
        let map = karaokeMap(for: assetID, rows: rows, lines: asset.lines)
        guard map.indices.contains(index), let line = map[index] else { return false }
        return line == playback.spokenLine
    }

    /// Single-line variant: identity first; text matching only on the TTS
    /// fallback (no catalog asset was resolved).
    func isSpeakingText(
        _ text: String, speaker: String? = nil, audio: String? = nil
    ) -> Bool {
        guard let playback else { return false }
        if let assetID = resolvedAudioID(audio) {
            return playback.isSpoken(audioID: assetID, text: text, speaker: speaker)
        }
        return playback.isSpoken(text: text, speaker: speaker)
    }

    /// Row→line maps are pure functions of (asset, rows) — computed once per
    /// screen, then cached for the session.
    private var karaokeMaps: [String: [Int?]] = [:]

    private func karaokeMap(
        for assetID: String, rows: [KaraokeTimeline.Row], lines: [AudioCatalog.Line]
    ) -> [Int?] {
        let signature = rows.map(\.text).joined(separator: "\u{1}")
        let key = assetID + "|" + String(rows.count) + "|" + signature
        if let cached = karaokeMaps[key] { return cached }
        let map = KaraokeTimeline.align(rows: rows, lines: lines)
        karaokeMaps[key] = map
        return map
    }

    /// Plays the authored offline take when `audio` resolves in the current
    /// chapter, with text-to-speech retained only as a missing-asset fallback.
    func speak(
        _ text: String?, audio: String? = nil, slow: Bool = false,
        lineIndex: Int? = nil
    ) {
        guard let text, !text.isEmpty else { return }
        // Stop a live learner take so it never talks over the model; keep
        // the finished recording so the YOU play control still works.
        say.interruptForModelPlayback()
        speaker?.speak(
            audioID: resolvedAudioID(audio), text: text, slow: slow,
            lineIndex: lineIndex)
    }

    func resolvedAudioID(_ reference: String?) -> String? {
        guard let reference = reference?.trimmingCharacters(in: .whitespacesAndNewlines),
            !reference.isEmpty
        else { return nil }
        if reference.contains("-AUD") { return reference }
        guard let chapterID = cur?.chapter.id else { return nil }
        return "\(chapterID)-\(reference)"
    }

    /// Single-choice key match with id-first precedence. Authored keys are
    /// option ids ("B"); text stays the fallback for banks that key by option
    /// text (warm-up frames). Precedence matters when an option's text echoes
    /// another option's id — a letter item whose keyed answer is option B
    /// ("D") must not also grade the option showing the letter "B".
    nonisolated static func matchesKey(_ option: PracticeOption, key: String?, opts: [PracticeOption]) -> Bool {
        guard let key, !key.isEmpty else { return false }
        if opts.contains(where: { $0.id == key }) { return option.id == key }
        return option.text == key
    }

    /// The authored text an audio-cued item should speak — the key option for
    /// listening items (the thing you hear), the headword for cards.
    var speakTextForItem: String? {
        guard let item else { return nil }
        if let answer = item.opts.first(where: { item.isKey($0) })?.text {
            return answer
        }
        return item.word ?? item.prompt ?? nil
    }

    /// The phrase Listen should send to the player for the visible card.
    func speakText(for card: PlayerCard) -> String {
        if card.letter {
            let letter = card.main.split(separator: " ").first.map(String.init) ?? card.main
            return letter
        }
        if card.number {
            return card.main.split(separator: " ").last.map(String.init) ?? card.main
        }
        guard let assetID = resolvedAudioID(card.aud),
            let asset = audioCatalog.asset(assetID),
            !asset.lines.isEmpty
        else {
            return VoicePlayback.cleanCardWord(card.main)
        }
        if card.main.contains("/") {
            let unique = Set(
                VoicePlayback.ellipsisSegments(asset.lines[0].text).map(VoicePlayback.heardWords)
                    .filter { !$0.isEmpty })
            if unique.count > 1 {
                return asset.lines[0].text
            }
        }
        return VoicePlayback.cleanCardWord(card.main)
    }

    func listenToCurrentCard() {
        let card = self.card
        plays += 1
        heardCardIndexes.insert(c)
        speak(speakText(for: card), audio: card.aud, slow: plays > 1)
    }

    /// Cue text for a pronunciation-perceive MODEL control: the phrase the
    /// take should voice, so `selectTake` can clip a chain to this trial.
    func speakText(forPerceive item: PronPerceiveItem) -> String {
        if let word = item.word, !word.isEmpty {
            return word
        }
        let opts = item.opts ?? []
        if let key = item.key?.single, !key.isEmpty,
            let option = opts.first(where: { Self.matchesKey($0, key: key, opts: opts) }),
            let text = option.text, !text.isEmpty
        {
            return text
        }
        if let prompt = item.prompt {
            if prompt.localizedCaseInsensitiveContains("tap the strong word:") {
                let parts = prompt.components(separatedBy: ":")
                if parts.count > 1 {
                    let phrase = parts.dropFirst().joined(separator: ":")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    if !phrase.isEmpty { return phrase }
                }
            }
            return prompt
        }
        return " "
    }

    /// Cue text for a pronunciation-produce MODEL control.
    func speakText(forProduce item: PronProduceItem) -> String {
        var text = item.word.replacingOccurrences(of: "·", with: "")
        if text.contains("___") {
            text = text.replacingOccurrences(of: "___", with: "Alex")
        }
        if item.word == "H-A-D-D-A-D" {
            return "H. A. D. D. A. D."
        }
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Play the authored perceive-model take for this card, never a silent cue.
    func listenToPerceiveModel(_ item: PronPerceiveItem) {
        speak(speakText(forPerceive: item), audio: item.aud)
    }

    /// Play the authored produce-model take for this card.
    func listenToProduceModel(_ item: PronProduceItem) {
        speak(speakText(forProduce: item), audio: item.aud)
    }

    var hasHeardCurrentCard: Bool {
        heardCardIndexes.contains(c)
    }

    func moveToCard(_ index: Int) {
        let list = cardList
        guard list.indices.contains(index), index != c else { return }
        speaker?.stop()
        c = index
        rec = 0
        plays = 0
    }

    private var audioCatalog: AudioCatalog {
        playback?.catalog ?? Self.bundledCatalog
    }

    private static let bundledCatalog = AudioCatalog(bundle: .main)

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
        say.reset()
        // Leaving a screen ends its audio: playback state (and the karaoke
        // highlight derived from it) must never leak into the next screen.
        speaker?.stop()
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
        let direction = newP < p ? -1 : 1
        var n = max(b.min, min(b.max, newP))
        while (b.min...b.max).contains(n), !f[n].screen.kind.participatesInLessonFlow {
            n += direction
        }
        if n > b.max {
            onFinish()
            return
        }
        if n < b.min {
            onExit()
            return
        }
        // Craft overhaul L7: remember travel direction so the screen-swap
        // transition slides the correct way on back navigation.
        if let next = course.flat.indices.contains(n) ? course.flat[n] : nil {
            if next.screen.kind == .quizIntro || (next.screen.kind == .quiz && cur?.screen.kind != .quiz) {
                quizCorrect = 0
                quizTotal = 0
            }
        }
        lastDelta = n - p
        onScreen(n)
        p = n
        i = 0
        c = 0
        sel = nil
        wrong = 0
        done = false
        plays = 0
        heardCardIndexes = []
        caps = false
        demo = 0
        tried = false
        notice = 0
        revealed = false
        learningStep = 0
        learningSelection = nil
        learningComplete = false
        learningWrong = 0
        order = []
        picked = [:]
        rec = 0
        showScore = false
        flip = [:]
        turn = 1
        matchSelection = nil
        matched = []
        roleplayLines = []
        roleplayUsedGroups = []
        roleplayUserTurns = 0
        roleplayFinished = false
        roleplayStarted = false
        roleplayLineSerial = 0
        tk = 0
        teachShut = false

        if let cur {
            let screens = cur.lesson.screens.filter { $0.kind.participatesInLessonFlow }
            let pos = (screens.firstIndex(where: { $0.id == cur.screen.id }) ?? 0) + 1
            let lessonNum = Int(cur.lesson.id.filter { $0.isNumber }) ?? 1
            AUAX.playerPosition(lesson: lessonNum, screen: pos, total: max(1, screens.count))
        }
    }

    var cur: CourseStore.FlatScreen? {
        course.flat.indices.contains(p) ? course.flat[p] : nil
    }

    // MARK: Meaning-first grammar pulses

    func pickLearning(_ option: PracticeOption, key: String, opts: [PracticeOption]) {
        learningSelection = option.id
        if Self.matchesKey(option, key: key, opts: opts) {
            AUFeedback.correct()
        } else {
            learningWrong += 1
            AUFeedback.miss()
        }
    }

    func advanceLearning(total: Int) {
        guard total > 0 else {
            learningComplete = true
            return
        }
        if learningStep + 1 < total {
            learningStep += 1
            learningSelection = nil
            learningWrong = 0
        } else {
            learningComplete = true
        }
    }

    var practiceTeachingComplete: Bool {
        guard case .practice(let screen) = cur?.screen.payload,
            let pulses = screen.teach?.meaningPulses, !pulses.isEmpty
        else { return true }
        return learningComplete
    }

    // MARK: Guided roleplay

    var roleplayRequiredGroups: [TileGroup] {
        guard case .roleplay(let roleplay) = cur?.screen.payload else { return [] }
        return (roleplay.tileGroups ?? []).filter { !Self.isOptionalRoleplayGroup($0.g) }
    }

    var roleplayActiveGroup: TileGroup? {
        roleplayRequiredGroups.first { !roleplayUsedGroups.contains($0.g) }
    }

    var roleplayProgressCount: Int {
        roleplayRequiredGroups.filter { roleplayUsedGroups.contains($0.g) }.count
    }

    var roleplaySuggestedReply: String? { roleplayActiveGroup?.t.first }

    func prepareRoleplay() {
        guard !roleplayStarted,
            case .roleplay(let roleplay) = cur?.screen.payload
        else { return }

        roleplayStarted = true
        roleplayFinished = false
        done = false

        if let opener = roleplay.opener.learnerFacing {
            appendRoleplayLine(
                speaker: Self.roleplayPartnerName(roleplay), text: opener, learner: false)
        } else if let opening = roleplay.transcript?.first(where: { $0.sp != "YOU" }) {
            appendRoleplayLine(speaker: opening.sp, text: opening.t, learner: false)
        }
    }

    func restartRoleplay() {
        say.reset()
        speaker?.stop()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            roleplayLines = []
            roleplayUsedGroups = []
            roleplayUserTurns = 0
            roleplayFinished = false
            roleplayStarted = false
            roleplayLineSerial = 0
            prepareRoleplay()
        }
        AUFeedback.press()
    }

    /// One visible tile is one learner turn. The partner adds one short prompt
    /// for the next guided step; no counter can reveal canned learner answers.
    func chooseRoleplayReply(_ text: String, group: String) {
        prepareRoleplay()
        guard !roleplayFinished,
            let active = roleplayActiveGroup,
            active.g == group,
            active.t.contains(text),
            case .roleplay(let roleplay) = cur?.screen.payload
        else { return }

        say.reset()
        withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
            appendRoleplayLine(speaker: "YOU", text: text, learner: true)
            roleplayUsedGroups.insert(group)
            roleplayUserTurns += 1
        }
        AUFeedback.selection()

        let hitTurnLimit = roleplayUserTurns >= (roleplay.turnLimit ?? 8)
        let nextGroup = roleplayActiveGroup
        let willFinish = nextGroup == nil || hitTurnLimit

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(460))
            guard !Task.isCancelled else { return }
            withAnimation(.spring(response: 0.48, dampingFraction: 0.84)) {
                self.appendRoleplayLine(
                    speaker: Self.roleplayPartnerName(roleplay),
                    text: Self.roleplayPartnerReply(nextGroup: nextGroup, finished: willFinish),
                    learner: false)
                self.roleplayFinished = willFinish
                self.done = willFinish
            }

            if willFinish {
                AUFeedback.correct()
                AUAX.announce("Roleplay complete. Go on when you are ready.")
            }
        }
    }

    private func appendRoleplayLine(speaker: String, text: String, learner: Bool) {
        roleplayLines.append(
            RoleplayLine(
                id: roleplayLineSerial, speaker: speaker, text: text, learner: learner))
        roleplayLineSerial += 1
    }

    private static func isOptionalRoleplayGroup(_ group: String) -> Bool {
        let value = group.lowercased()
        return value.contains("optional") || value.contains("follow-up")
    }

    private static func roleplayPartnerName(_ roleplay: RoleplayScreen) -> String {
        roleplay.partner?.split(separator: " ").first.map { String($0).uppercased() }
            ?? String(localized: "PARTNER")
    }

    private static func roleplayPartnerReply(nextGroup: TileGroup?, finished: Bool) -> String {
        if finished { return String(localized: "Thank you! See you!") }

        let next = nextGroup?.g.lowercased() ?? ""
        if next.contains("confirm") { return String(localized: "Is that right?") }
        if next.contains("spell") { return String(localized: "How do you spell that?") }
        if next.contains("name") { return String(localized: "What's your name?") }
        if next.contains("origin") { return String(localized: "Where are you from?") }
        if next.contains("job") { return String(localized: "What do you do?") }
        if next.contains("state") { return String(localized: "How are you?") }
        if next.contains("detail") { return String(localized: "One detail, please.") }
        if next.contains("repair") { return String(localized: "Could you repeat that, please?") }
        if next.contains("introduce") { return String(localized: "Who is your friend?") }
        if next.contains("close") { return String(localized: "It was nice talking with you.") }
        if next.contains("greet") { return String(localized: "Hello!") }
        return String(localized: "What would you like to say next?")
    }

    // MARK: Item normalization (lines 1192–1211)

    /// The single item renderer's input, unifying practice/quiz/testlet/
    /// warm-up/reading/nextLine items.
    struct PlayerItem: Identifiable {
        struct Match: Identifiable {
            let id: Int
            let cue: String
            let answer: String
        }

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
        var matches: [Match] = []

        func isKey(_ o: PracticeOption) -> Bool {
            PlayerModel.matchesKey(o, key: key?.single, opts: opts)
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
                    instr: CourseTextContract.learnerText(f.q)
                        ?? String(localized: "Choose the best answer."),
                    icon: f.icon ?? "ear",
                    aud: f.aud,
                    opts: opts,
                    key: .single(f.key),
                    ok: String(localized: "Yes — \(f.key)"),
                    no: String(localized: "Try again."),
                    hints: [
                        "Listen or look once more.", "Two options belong to a different moment.",
                    ],
                    unscored: true
                ))
        }
        return out
    }

    private func normalized(_ list: [PracticeItem]?) -> [PlayerItem] {
        (list ?? []).filter(hasUsableOptions).map { it in
            PlayerItem(
                id: it.id,
                instr: CourseTextContract.learnerText(it.instr)
                    ?? String(localized: "Choose the best answer."),
                icon: it.icon ?? "eye",
                aud: it.aud,
                ill: learnerIllustration(it.ill),
                scene: it.scene.learnerFacing,
                opts: (it.opts ?? []).map(learnerOption),
                key: it.key,
                ok: it.ok.learnerFacing,
                no: it.no.learnerFacing,
                hints: it.hints?.compactMap(CourseTextContract.learnerText),
                word: learnerAudioCue(for: it),
                kind: it.kind,
                big: it.big ?? false,
                secs: it.secs,
                prompt: learnerPrompt(it),
                tiles: it.tiles ?? [],
                matches: learnerMatches(it)
            )
        }
    }

    /// Illustration choices must ship as real artwork. An authored option with
    /// no packaged image is omitted with its whole item instead of leaking an
    /// eye icon or an image-generation description into the learner flow.
    private func hasUsableOptions(_ item: PracticeItem) -> Bool {
        (item.opts ?? []).allSatisfy { option in
            guard let illustration = option.ill else { return true }
            return UIImage(named: illustration.id) != nil
        }
    }

    /// The app uses TTS while authored recordings are not bundled. Image-match
    /// items therefore need an actual learner cue rather than an opaque AUD id.
    private func learnerAudioCue(for item: PracticeItem) -> String? {
        if let word = item.word.learnerFacing { return word }
        guard item.aud != nil else { return nil }

        if let pairs = item.pairs, !pairs.isEmpty {
            if pairs.count == 1 { return CourseTextContract.learnerText(pairs[0].first) }
            if let key = item.key?.single,
                let optionIndex = (item.opts ?? []).firstIndex(where: { $0.id == key }),
                pairs.indices.contains(optionIndex)
            {
                return CourseTextContract.learnerText(pairs[optionIndex].first)
            }
        }

        if let sequence = item.key?.sequence, !sequence.isEmpty {
            return Self.joinTiles(sequence, tight: false)
        }

        guard let key = item.key?.single else { return item.prompt.learnerFacing }
        let opts = item.opts ?? []
        guard let option = opts.first(where: { Self.matchesKey($0, key: key, opts: opts) })
        else { return item.prompt.learnerFacing }
        if let text = option.text.learnerFacing { return text }
        guard let alt = CourseTextContract.learnerText(option.ill?.alt) else {
            return item.prompt.learnerFacing
        }
        return Self.shortIllustrationCue(from: alt)
    }

    private static func shortIllustrationCue(from alt: String) -> String {
        if let suffix = alt.components(separatedBy: "—").last?.trimmingCharacters(
            in: .whitespacesAndNewlines),
            suffix != alt, !suffix.isEmpty
        {
            return suffix
        }

        let lower = alt.lowercased()
        let cues: [(needle: String, cue: String)] = [
            ("not bad", "not bad"), ("so-so", "okay"), ("arms raised", "great"),
            ("arms up", "great"), ("full warm smile", "good"), ("warm full smile", "good"),
            ("dark sky", "evening"), ("morning", "morning"), ("afternoon", "afternoon"),
            ("café", "the café"), ("community hall", "the community hall"),
            ("park", "the park"),
        ]
        return cues.first(where: { lower.contains($0.needle) })?.cue ?? alt
    }

    private func learnerPrompt(_ item: PracticeItem) -> String? {
        switch item.kind {
        case "pairs": return String(localized: "Match each item with its partner.")
        case "sort": return String(localized: "Place each card in the matching group.")
        default: return item.prompt.learnerFacing
        }
    }

    private func learnerMatches(_ item: PracticeItem) -> [PlayerItem.Match] {
        if item.kind == "pairs" {
            return (item.pairs ?? []).enumerated().compactMap { index, pair in
                guard pair.count >= 2,
                    let answer = CourseTextContract.learnerText(pair[1])
                else { return nil }
                return PlayerItem.Match(
                    id: index,
                    cue: CourseTextContract.learnerText(pair[0])
                        ?? String(localized: "Picture \(index + 1)"),
                    answer: answer)
            }
        }
        if item.kind == "sort" {
            var matches: [PlayerItem.Match] = []
            for basket in item.baskets ?? [] {
                guard let answer = CourseTextContract.learnerText(basket.icon) else { continue }
                for cue in basket.text.components(separatedBy: " · ") {
                    guard let cue = CourseTextContract.learnerText(cue) else { continue }
                    matches.append(PlayerItem.Match(id: matches.count, cue: cue, answer: answer))
                }
            }
            return matches
        }
        return []
    }

    private func learnerIllustration(_ illustration: IllustrationRef?) -> IllustrationRef? {
        guard let illustration else { return nil }
        return IllustrationRef(
            id: illustration.id,
            alt: CourseTextContract.learnerText(illustration.alt)
                ?? String(localized: "Illustration"))
    }

    private func learnerOption(_ option: PracticeOption) -> PracticeOption {
        PracticeOption(
            id: option.id,
            text: CourseTextContract.learnerText(option.text),
            ill: learnerIllustration(option.ill))
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
    /// Speak items are ungraded listen-and-say: Go-on (and skip) unlock after
    /// the learner hears the model (`plays > 0`).
    var itemCanGo: Bool {
        guard let it = item else { return false }
        if it.kind == "order" {
            if isQuiet { return tileComplete }
            return tileCorrect
        }
        if it.kind == "speak" {
            return plays > 0
        }
        if isQuiet {
            return sel != nil
        }
        return done
    }

    /// Play the speak-item model. Marks the item heard so the dock CTAs unlock.
    func listenToSpeakModel() {
        guard let it = item, it.kind == "speak" else { return }
        plays += 1
        speak(it.word ?? it.prompt ?? "", audio: it.aud)
    }

    func selectMatchCue(_ id: Int) {
        guard !matched.contains(id) else { return }
        matchSelection = id
        AUFeedback.selection()
    }

    func selectMatchAnswer(_ id: Int) {
        guard matchSelection == id, !matched.contains(id) else { return }
        matched.insert(id)
        matchSelection = nil
        done = matched.count == item?.matches.count && !(item?.matches.isEmpty ?? true)
        AUFeedback.correct()
    }

    func assignSortMatch(_ id: Int, answer: String) {
        guard let match = item?.matches.first(where: { $0.id == id }), !matched.contains(id)
        else { return }
        if match.answer == answer {
            matched.insert(id)
            done = matched.count == item?.matches.count && !(item?.matches.isEmpty ?? true)
            AUFeedback.correct()
        } else {
            AUFeedback.miss()
        }
    }

    func pick(_ o: PracticeOption, item: PlayerItem) {
        guard !done else { return }
        if isQuiet {
            sel = o.id
            AUFeedback.selection()
            return
        }
        let correct = item.isKey(o)
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

    func confirmQuizAnswer() {
        guard isQuiet, !done, let it = item else { return }
        if it.kind == "order" {
            guard tileComplete else { return }
            quizTotal += 1
            if tileCorrect {
                quizCorrect += 1
                AUFeedback.correct()
            } else {
                AUFeedback.miss()
            }
            done = true
            advance()
            return
        }

        guard let s = sel, let opt = it.opts.first(where: { $0.id == s }) else { return }
        quizTotal += 1
        let correct = it.isKey(opt)
        if correct {
            quizCorrect += 1
            AUFeedback.correct()
        } else {
            AUFeedback.miss()
        }
        done = true
        advance()
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
            matchSelection = nil
            matched = []
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
        var badge: String? = nil
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
                            aud: Self.letterAudioReference(
                                l, familyAud: f.aud, chapterID: cur.chapter.id),
                            letter: true
                        ))
                }
            }
            return out
        case .numbers(let s):
            return (s.nums ?? []).map { n in
                PlayerCard(
                    main: n.d + "  " + n.w, ipa: n.ipa ?? "", sub: "count scene",
                    aud: Self.numberAudioReference(n.d, chapterID: cur.chapter.id), digit: n.d,
                    number: true)
            }
        case .cards(let s):
            return (s.cards ?? []).map { c in
                PlayerCard(
                    main: c.w, ipa: c.ipa ?? "", sub: c.fn ?? "", ill: c.ill, aud: c.aud, id: c.id,
                    chunk: c.chunk ?? false, badge: c.badge, moment: c.frame ?? "")
            }
        default:
            return []
        }
    }

    var card: PlayerCard {
        let list = cardList
        return list.indices.contains(c) ? list[c] : PlayerCard()
    }

    /// Isolated letter models exist only for the confusable pairs; every other
    /// letter still points at its family recitation, which Listen clips to that
    /// letter's own phrase.
    private static func letterAudioReference(
        _ letter: String, familyAud: String?, chapterID: String
    ) -> String? {
        let isolated: [String: Int] = [
            "B": 15, "D": 16, "E": 17, "H": 18, "M": 19, "N": 20, "R": 21, "S": 22,
        ]
        if chapterID == "A1-C02", let asset = isolated[letter] {
            return String(format: "A1-C02-AUD%03d", asset)
        }
        return familyAud
    }

    /// Chapter 2's number bank authored individual models for every number
    /// except one/four, which live in the 0–5 count-along take and are clipped
    /// to the matching word on Listen.
    private static func numberAudioReference(_ digit: String, chapterID: String) -> String? {
        guard chapterID == "A1-C02", let value = Int(digit), (0...20).contains(value) else {
            return nil
        }
        let asset: Int
        switch value {
        case 0: asset = 26
        case 1, 4: asset = 27
        case 2: asset = 23
        case 3: asset = 24
        case 5: asset = 25
        case 6...20: asset = 27 + value
        default: return nil
        }
        return String(format: "A1-C02-AUD%03d", asset)
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
        let target: String?
        let tiles: [String]
        let key: [String]
        let ok: String
        let no: String

        init(instr: String, target: String? = nil, tiles: [String], key: [String], ok: String, no: String) {
            self.instr = instr
            self.target = target
            self.tiles = tiles
            self.key = key
            self.ok = ok
            self.no = no
        }
    }

    private func normalizedTileTask(_ task: TileTask, seed: String) -> TileTaskState {
        let options = task.opts ?? []
        let tiles = task.tiles ?? options.compactMap { $0.text.learnerFacing }
        let key: [String]
        if let sequence = task.key?.sequence {
            key = sequence
        } else if let single = task.key?.single,
            let answer = options.first(where: { $0.id == single || $0.text == single })
        {
            key = answer.text.learnerFacing.map { [$0] } ?? []
        } else {
            key = []
        }
        return mixedTileTask(
            TileTaskState(
                instr: CourseTextContract.learnerText(task.instr)
                    ?? String(localized: "Put in order."),
                target: task.target.learnerFacing,
                tiles: tiles, key: key,
                ok: task.ok.learnerFacing ?? "", no: task.no.learnerFacing ?? ""), seed: seed)
    }

    var tileTask: TileTaskState {
        guard let cur else {
            return TileTaskState(
                instr: String(localized: "Put in order."), tiles: [], key: [], ok: "", no: "")
        }
        let s = cur.screen
        if let it = item, it.kind == "order" {
            return mixedTileTask(
                TileTaskState(
                    instr: CourseTextContract.learnerText(it.instr)
                        ?? String(localized: "Put in order."),
                    target: it.prompt.learnerFacing,
                    tiles: it.tiles, key: it.key?.sequence ?? [],
                    ok: it.ok.learnerFacing ?? "", no: it.no.learnerFacing ?? ""),
                seed: "\(s.id)|\(it.id)")
        }
        switch s.payload {
        case .tiles(let t):
            if let task = (t.tasks ?? []).indices.contains(tk) ? (t.tasks ?? [])[tk] : nil {
                return normalizedTileTask(task, seed: "\(s.id)|\(task.id)")
            }
        case .order(let o):
            if let task = (o.tasks ?? []).indices.contains(tk) ? (o.tasks ?? [])[tk] : nil {
                return normalizedTileTask(task, seed: "\(s.id)|\(task.id)")
            }
        case .emailAssembly(let e):
            return mixedTileTask(
                TileTaskState(
                    instr: e.instr.learnerFacing ?? String(localized: "Put in order."),
                    target: e.spoken.learnerFacing,
                    tiles: e.tiles ?? [], key: e.key ?? [],
                    ok: e.ok.learnerFacing ?? "", no: e.no.learnerFacing ?? ""), seed: s.id)
        default:
            break
        }
        return TileTaskState(
            instr: String(localized: "Put in order."), tiles: [], key: [], ok: "", no: "")
    }

    var tileLine: String {
        let tiles = tileTask.tiles
        return Self.joinTiles(
            order.map { tiles.indices.contains($0) ? tiles[$0] : "" },
            tight: cur?.screen.kind == .emailAssembly)
    }

    func displayTileLine(target: String?) -> String {
        if let target, target.contains("___") {
            if tileLine.isEmpty {
                return target
            }
            return target.replacingOccurrences(of: "___", with: tileLine)
        }
        return tileLine.isEmpty ? " " : tileLine
    }

    var orderedTileTexts: [String] {
        let tiles = tileTask.tiles
        return order.compactMap { tiles.indices.contains($0) ? tiles[$0] : nil }
    }

    /// Full-sentence ordering is presented as separate turns rather than one
    /// paragraph. Word-order and email tasks keep their normal inline field.
    var usesLineAssembly: Bool {
        let key = tileTask.key
        guard key.count >= 3 else { return false }
        let sentenceCount = key.filter(Self.looksLikeCompleteLine).count
        return sentenceCount >= max(2, key.count - 1)
    }

    var tileComplete: Bool {
        !tileTask.key.isEmpty && order.count == tileTask.key.count
    }

    var tileCorrect: Bool {
        tileComplete
            && order.enumerated().allSatisfy { j, k in
                tileTask.tiles.indices.contains(k)
                    && (tileTask.key.indices.contains(j)
                        ? Self.tileMatches(tileTask.tiles[k], key: tileTask.key[j]) : false)
            }
    }

    /// Some guided-writing keys name a safe category (for example “country”)
    /// while the visible tile offers a concrete choice (“any of the ten
    /// countries”). Exact authored answers still take precedence; this small
    /// stem rule keeps those deliberately flexible slots deterministic.
    static func tileMatches(_ tile: String, key: String) -> Bool {
        let tile = tile.folding(
            options: [.caseInsensitive, .diacriticInsensitive], locale: .current
        )
        .trimmingCharacters(in: .whitespacesAndNewlines)
        let key = key.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        if tile == key || tile.contains(key) || key.contains(tile) { return true }
        if key.hasSuffix("y") {
            return tile.contains(String(key.dropLast()) + "ies")
        }
        return false
    }

    static func tilesAreInAnswerOrder(_ tiles: [String], key: [String]) -> Bool {
        tiles.count == key.count
            && tiles.enumerated().allSatisfy { index, tile in
                key.indices.contains(index) && tileMatches(tile, key: key[index])
            }
    }

    private func mixedTileTask(_ task: TileTaskState, seed: String) -> TileTaskState {
        TileTaskState(
            instr: task.instr,
            target: task.target,
            tiles: Self.mixedTiles(task.tiles, answer: task.key, seed: seed),
            key: task.key,
            ok: task.ok,
            no: task.no
        )
    }

    /// Stable Fisher–Yates mixing keeps buttons still during SwiftUI updates,
    /// but guarantees that a solvable task never opens already answered.
    private static func mixedTiles(_ tiles: [String], answer: [String], seed: String) -> [String] {
        guard tiles.count > 1 else { return tiles }

        var state: UInt64 = 1_469_598_103_934_665_603
        for byte in seed.utf8 {
            state ^= UInt64(byte)
            state = state &* 1_099_511_628_211
        }

        var mixed = tiles
        for upper in stride(from: mixed.count - 1, through: 1, by: -1) {
            state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
            mixed.swapAt(upper, Int(state % UInt64(upper + 1)))
        }

        if tilesAreInAnswerOrder(mixed, key: answer) {
            for index in 0..<(mixed.count - 1) {
                mixed.swapAt(index, index + 1)
                if !tilesAreInAnswerOrder(mixed, key: answer) { return mixed }
                mixed.swapAt(index, index + 1)
            }
        }
        return mixed
    }

    private static func looksLikeCompleteLine(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.contains(" ")
            && (trimmed.hasSuffix(".") || trimmed.hasSuffix("!") || trimmed.hasSuffix("?")
                || trimmed.range(of: #"^[A-Z][A-Z]+:\s+"#, options: .regularExpression) != nil)
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
        AUFeedback.tileSnap()
        if let ix = order.firstIndex(of: k) {
            order.remove(at: ix)
        } else if tileTask.key.indices.contains(order.count) {
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
