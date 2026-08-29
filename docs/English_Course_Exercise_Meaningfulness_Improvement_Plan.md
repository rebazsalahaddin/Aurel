# Aurel — Exercise Meaningfulness Improvement Plan

**Scope:** Listening (testlet) exercise family + exercise-content integrity across the whole A1 course
**Source of defect report:** Owner usability report — "tapping Listen plays a full conversation, then three choices that have nothing to do with it; the user has no idea what to choose or why."
**Audit date:** 2026-08-27 (all file paths / line numbers / JSON records verified against the working tree on this date; line numbers may shift ±few lines after edits)
**Status:** Approved for phased implementation. Each phase ends with a user-confirmed commit.

---

## 0. How to use this document — implementing-agent contract

You (the implementing agent) are executing this plan phase by phase. This section is binding.

### 0.1 Read before touching anything

1. `README.md` (root) — build/test commands, project layout, conventions.
2. `Aurel/Course/Player/Screens/PracticeScreen.swift` — the renderer for practice · quiz · **testlet** · warmup · reading items.
3. `Aurel/Course/Player/PlayerModel.swift` — item state (`m.done`, `m.revealed`, `m.plays`), `speak(_:audio:slow:lineIndex:)`, `resolvedAudioID(_:)`.
4. `Aurel/Services/VoicePlayback.swift` + `Aurel/Services/AudioCatalog.swift` — recorded-audio playback, per-line replay, bundled catalog.
5. `AurelTests/ContentConformanceTests.swift` — what course-JSON fields are pinned against the authored manifest (see §2, D-07 note).
6. `Aurel/Resources/Course/a1-course.json` — the shipped course bank (pretty-printed JSON, ~604 KB). **All Phase 2/3 content edits happen here.**

### 0.2 Ground rules

- **Content is authored, never invented.** Only apply the exact edits enumerated in this plan. Where the plan gives a *rule* instead of an exact value (Phase 2 Table 2B), apply the rule mechanically and list every resulting change back to the user before committing.
- **Do not modify:** `Archive/**` (read-only authored authority), `AurelTests/Fixtures/course-manifest.json` (generated fixture), `Aurel/Resources/Audio/**` (catalog + WAVs), `tools/**`.
- **Do not regenerate audio.** The ~40 missing "fresh take" recordings are a documented follow-up (§8), not part of this plan.
- **No new dependencies.** SwiftUI only; design tokens only (never hardcode colors — `Color.auFill`, `Color.auEdge`, `Color.auAccentText`, `Color.auTintBg`, … as in surrounding code).
- New learner-facing copy uses `String(localized:)` (existing pattern) and is written for an **A1 self-taught reader** (short, plain words).
- Swift style: 4-space indent, 100-column lines, `.swift-format` — run `xcrun swift-format lint --recursive --configuration .swift-format Aurel` after Swift edits.
- **Do not change** `PlayerModel.speakTextForItem` (see D-08 — known limitation, guarded, out of scope).
- Every phase must leave the unit suite green. Never commit a red build.
- Preserve Unicode exactly when editing JSON (the bank uses typographic quotes `“ ” ’` and em/en dashes; `canon()` in the conformance tests normalizes them, but option/hint comparisons are quote-sensitive after canon — copy values verbatim from this document).

### 0.3 Commit & confirmation protocol (MANDATORY)

The user must explicitly confirm every phase before it is committed. Workflow per phase:

1. Implement the phase completely (all tasks in its section).
2. Run that phase's **Verification** block; everything must pass.
3. Report to the user: a summary of what changed, `git diff --stat`, and any deviation from the plan (with reason).
4. **Ask:** “Phase N is complete and verified — confirm the commit?” Then STOP and wait.
5. Only on explicit confirmation: `git add <exactly the files listed for that phase>` then `git commit` with the suggested message (adapt wording if the user asks).
6. Do not start Phase N+1 until Phase N is committed (unless the user explicitly merges the order).

Never: commit without confirmation · mix phases in one commit · `git push` · amend previous commits · commit with failing tests.

Suggested commit messages:

| Phase | Message |
|---|---|
| 1 | `fix(player): meaningful listening UX — post-answer transcript, image-option labels, plain-language rungs` |
| 2 | `fix(content): honest listening instructions and learner-facing prompts (46 items, 16 prompts)` |
| 3 | `fix(content): repair misleading item feedback; register drift in conformance suite` |
| 4 | `test(content): add ListeningSanityTests guarding listening-exercise integrity` |

### 0.4 Phase order & dependencies

Phase 1 (app) and Phase 2 (content) are independent. Phase 3 touches the same JSON as Phase 2 — do it after 2 to keep diffs reviewable. Phase 4 (tests) must be last so the new guards lock in Phases 1–3. Recommended order: **1 → 2 → 3 → 4**.

---

## 1. Executive summary

The reported screen (Chapter 1 · Lesson 3 · “Gist task”, item `PR-LS001` "How many people talk?") is pedagogically authored against its audio, but the *experience* breaks for an A1 self-learner because of one app bug that makes the choices unreadable, one unfulfilled UI promise, raw assessment jargon, and a content regression in Chapters 3–4 where 46 items say “Listen” with no audio at all. Additionally 16 learner-visible prompts still contain authoring artifacts (“(replay, T03–T04)”, “T8:”, “Line model:”…).

Fixes, mapped to defects (§2):

- **Phase 1 (app):** image options show their meaning instead of “Picture A” (D-01); the promised line-by-line transcript is revealed after each answer, with tap-a-line-to-replay (D-02, D-06 mitigation); rung chips render plain-language labels instead of “GIST → DETAIL → SPEAKER/TRANSFER” (D-03).
- **Phase 2 (content):** all 46 audio-less “Listen” items get honest instructions (“Read.”/“Look.”) — three of them gain their authored stimulus line as visible text so they stay meaningful (D-04); all 16 artifact prompts are cleaned (D-05); a handful of C4 feedback strings that say “Listen:” for read items are aligned (C4 is unpinned).
- **Phase 3 (content, pinned fields):** the 5 worst misleading/garbled feedback strings in C1–C3 are repaired and registered in `documentedDrift` (D-07).
- **Phase 4 (tests):** a new `ListeningSanityTests` suite permanently guards: “Listen ⇒ has audio”, “prompts are learner-facing”, “testlet items carry audio”.


---

## 2. Defect registry (all verified in the audit)

Line numbers refer to the audited versions and may shift slightly.

### D-01 — Image answer options are labeled “Picture A/B/C”, hiding their meaning
- **Where:** `Aurel/Course/Player/Screens/PracticeScreen.swift`, `optionRow`, line ~1200: `Text("Picture \(o.id)")`.
- **Effect:** The reported screenshot (C1-L3 `PR-LS001` “How many people talk?”) shows option A as an image labeled *Picture A* while B/C read “three people” / “four people”. The learner has no idea what Picture A means. The authored alt text (“Two speakers face each other across the welcome table”) exists on the option and is already used for the accessibility label (line ~1232) and in the verdict's accepted-answer, but is never shown visually.
- **Model fact:** `IllustrationRef.alt` is a non-optional `String` (`Aurel/Course/Models/CourseModels.swift:90-93`).

### D-02 — The promised transcript is never revealed (“no idea WHY”)
- **Where:** `PracticeScreen.swift` `unlockNote` (lines ~894–908) renders: *“Complete the activity to reveal the transcript.”* for testlet screens carrying `unlock`. **No transcript UI exists anywhere** for testlet items (grep for transcript rendering: only `roleplay.transcript` and conversation screens have one).
- **Effect:** after answering, a self-taught A1 learner can never see what was actually said — the single biggest “why” gap. The authored accessibility contract on every listening item (`audio_required_transcript_after_response`, present throughout `Archive/english_course/**/LESSON.md` fences and in the shipped items' `a11y` arrays) is unimplemented.
- **Available data:** the bundled catalog (`Aurel/Resources/Audio/audio-catalog.json`, loaded by `AudioCatalog`) carries every stimulus line (`speaker`, `text`, per-line `file`), and `PlayerModel.speak(_:audio:slow:lineIndex:)` already plays a single catalog line — the building blocks exist and are unused here.

### D-03 — Internal assessment jargon shown raw in the rung chip
- **Where:** `PracticeScreen.swift` `rungHeader` (lines ~103–126): `Text(rung)` renders the raw `rung` field.
- **Shipped values:** `"GIST"`, `"DETAIL"`, `"RESPONSE"`, `"GIST → DETAIL → RESPONSE → TRANSFER"` (C3-L2 S20), `"DETAIL → TRANSFER"` (C3-L3 S25), `"GIST → DETAIL → SPEAKER/TRANSFER"` (C4-L2 S13). “SPEAKER/TRANSFER” is meaningless to a learner.

### D-04 — 46 items instruct “Listen.” but have NO audio (C3/C4 regression)
- **Where:** `a1-course.json`; C1–C2 items always attach `aud`, C3/C4 do not for these. The Listen button renders only `if item.aud != nil` (`PracticeScreen.swift` ~464), so the instruction lies and no listen control appears; a visible text `scene` (or image) is the real stimulus.
- **Root cause:** authored one-line “fresh take” recordings (`stimulusAudio` in the manifest, e.g. *“fresh take — NINA: Leo is my friend. He's a cook.”*) were never generated; the 249-asset catalog has no match.
- **Full inventory (46):**

| Chapter | Lesson | Screen | Type | Items |
|---|---|---|---|---|
| A1-C03 | L01 | S04 | practice | PR-V002, PR-V005 |
| A1-C03 | L01 | S06 | practice | PR-V008, PR-V012 |
| A1-C03 | L01 | S10 | practice | PR-V020, PR-V021, PR-V024, PR-V025 |
| A1-C03 | L01 | S12 | practice | PR-V034, PR-P003 |
| A1-C03 | L02 | S19 | practice | PR-CV001, PR-CV002, PR-CV003, PR-CV004, PR-CV005, PR-CV006, PR-CV009, PR-CV010, PR-CV011, PR-CV012 |
| A1-C03 | L02 | S21 | pronPerceive | PR-P005, PR-P010 |
| A1-C03 | L02 | S20 | testlet | PR-LS010 |
| A1-C03 | L03 | S25 | testlet | PR-LS015, PR-LS016 |
| A1-C04 | L01 | S03 | practice | RT001, RT002, RT003, RT004, RT005, RT006, RT007 |
| A1-C04 | L01 | S04 | practice | CL1-002, CL1-007 |
| A1-C04 | L02 | S11 | practice | RT009, RT010, RT015, RT016 |
| A1-C04 | L02 | S12 | practice | CL2-002, CL2-006, CL2-007, CL2-008 |
| A1-C04 | L03 | S23 | quiz | A1-CP1-LS001, A1-CP1-LS005, A1-CP1-LS008, A1-CP1-CN001 |

### D-05 — 16 learner prompts contain authoring artifacts
Exact list with replacements in Phase 2, Table 2A. Examples: `"Where is Alex from? (replay, T03–T04)"` (C3-L2 S20 `PR-LS002`), `"T8: “I'm fine! …” What happens next?"` (C1-L3 S23 `PR-LS015`), `"Line model: “Nice to meet you, Nina!”"` (C1-L3 S23 `PR-LS013`), `"Which one? (AUD053 line 1, item 3)"` (C3-L2 S21 `PR-P005`), `"Maya's line at turn 8 — what does she want?"` (C2-L3 S25 `PR-LS016`).

### D-06 — Whole-stimulus replay for every item (no turn scoping)
Every testlet item replays the **entire** stimulus from the start (up to 55.5 s / 14 lines for `A1-C04-AUD036`, 6 items). Prompts were authored assuming turn-scoped replay (“(replay, T03–T04)”) that was never implemented. Pre-response turn scoping needs content data this plan does not add; **Phase 1 mitigates** by giving post-answer per-line replay in the transcript (D-02) and Phase 2 removes the turn references from prompts.

### D-07 — Misleading / garbled feedback strings (pinned fields — Phase 3)
`ok`/`no`/`hints` are conformance-pinned for C1–C3 (`ContentConformanceTests.compareFields` compares options, key, tiles, ok, no, hints verbatim after quote-canon; the drift registry `documentedDrift` is currently **empty**). Five strings actively mislead:

| Item | Field | Current (verbatim) | Problem |
|---|---|---|---|
| A1-C03 S20 `PR-LS010` | `ok` | `A cook—he's! New voice, same line.` | garbled; “new voice” that doesn't exist |
| A1-C03 S25 `PR-LS015` | `no` | `The voice says 'my teacher' — then the name.` | there is no voice (no audio on the item) |
| A1-C03 S25 `PR-LS016` | `no` | `Listen AFTER 'isn't' — corrections give the answer.` | item becomes a Read item in Phase 2 |
| A1-C01 S21 `PR-LS001` | `hints[0]` | `Play again; the speaker chips glow per turn.` | no speaker chips exist in the item UI |
| A1-C01 S21 `PR-LS003` | `hints[0]` | `Replay T1.` | turn jargon meaningless to learner |

Optional sixth (recommend fixing): A1-C02 S25 `PR-LS016` `no` = `Her hand is at her ear.` references storyboard art that is not shown on the item.

**Not pinned:** `instr`, `prompt`, `scene`, `aud`, `icon` are NOT compared by the conformance suite — Phase 2 edits them freely. C4/C5 are report-only (counts) in the suite — all C4 fields are free.

### D-08 — TTS fallback speaks the correct answer (known limitation — DO NOT TOUCH)
`PlayerModel.speakTextForItem` (lines ~170–176) returns the keyed option's text as the TTS fallback. This is by design for cards (“the thing you hear”) and is currently unreachable for option items without `aud` (no Listen button renders) and for QuickBank (`.listen` requires `it.aud != nil`, and `AudioCatalogTests.testEveryChapterReferenceResolvesOffline` proves every shipped `aud` resolves). Out of scope; documented here so no agent “fixes” it opportunistically.


---

## 3. Phase 1 — App fixes (Swift)

**Files touched:** `Aurel/Course/Player/Screens/PracticeScreen.swift` only (new accessibility identifiers added; no existing identifier removed or renamed).
**Fixes:** D-01, D-02, D-03 (+D-06 mitigation).

### P1.1 — Image options show their meaning (D-01)

In `optionRow` (~line 1152), next to the existing `let quiet = m.isQuiet`, add:

```swift
// Image options must carry their meaning, not a positional label —
// “Picture A” told the learner nothing about the choice (D-01).
let illLabel = o.ill.flatMap { $0.alt.isEmpty ? nil : $0.alt }
    ?? String(localized: "Picture \(o.id)")
```

Then replace (lines ~1200–1202):

```swift
Text("Picture \(o.id)")
    .font(.figtree(.semibold, size: 14))
    .frame(maxWidth: .infinity, alignment: .leading)
```

with:

```swift
Text(illLabel)
    .font(.figtree(.regular, size: 13.5))
    .auLine(13.5, 1.4)
    .frame(maxWidth: .infinity, alignment: .leading)
```

Regular weight + `auLine` because authored alts are sentences (“Two speakers face each other across the welcome table”). The `big` branch already falls back to `o.ill?.alt` — leave it.

### P1.2 — Plain-language rung chip (D-03)

Add this helper inside `PracticeScreenView` (next to `testletGuidance`, ~line 910):

```swift
/// Assessment rung tokens → learner-facing labels. Unknown tokens are
/// dropped rather than shown raw — “SPEAKER/TRANSFER” is authoring
/// vocabulary, not learner language (D-03).
private func learnerRungLabel(_ rung: String) -> String {
    let tokens: [(token: String, label: String)] = [
        ("GIST", String(localized: "Main idea")),
        ("DETAIL", String(localized: "Details")),
        ("RESPONSE", String(localized: "Your reply")),
        ("SPEAKER", String(localized: "Who says it")),
        ("TRANSFER", String(localized: "New situations")),
    ]
    return tokens
        .filter { rung.range(of: $0.token, options: .caseInsensitive) != nil }
        .map(\.label)
        .joined(separator: " · ")
}
```

In `rungHeader` (~lines 104–115), change the opening of the `HStack` from:

```swift
HStack(spacing: 9) {
    Text(rung)
        .font(.figtree(.bold, size: 9.5))
        .tracking(1.14)
```

to:

```swift
HStack(spacing: 9) {
    Text(learnerRungLabel(rung))
        .font(.figtree(.bold, size: 9.5))
        .tracking(1.14)
```

`learnerRungLabel` never returns empty for the six shipped rung values (all contain at least one known token). Keep the rest of the chip (guidance sentence, background, padding) untouched.

### P1.3 — Post-answer transcript with tap-a-line replay (D-02, mitigates D-06)

**Behavior:** on **testlet** screens only (never quiz — assessment integrity: authored rule says quiz transcripts release only after the whole quiz), once the current item is answered (`m.done` after a correct pick, or `m.revealed` after the miss ladder exhausts), render a dashed “What you heard” card listing the stimulus lines from the audio catalog. Each line is a button that replays just that line. Line taps must **not** increment `m.plays` (that counter belongs to the Listen button).

Add to `PracticeScreenView`:

```swift
// MARK: Post-answer transcript (testlet audio items — the promised reveal, D-02)

@ViewBuilder
private var responseTranscript: some View {
    if case .testlet = m.cur?.screen.kind,
        m.done || m.revealed,
        let item = m.item,
        let aud = item.aud,
        let assetID = m.resolvedAudioID(aud),
        let asset = m.playback?.catalog.asset(assetID),
        !asset.lines.isEmpty
    {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                AUIcon(kind: .ear, size: 14, color: .auAccentText)
                Text(String(localized: "What you heard — tap a line to play it"))
                    .font(.figtree(.bold, size: 9.5))
                    .tracking(1.25)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.auAccentText)
            }
            ForEach(Array(asset.lines.enumerated()), id: \.offset) { idx, line in
                Button {
                    m.speak(line.text, audio: aud, lineIndex: idx)
                } label: {
                    HStack(alignment: .top, spacing: 10) {
                        Text(line.speaker)
                            .font(.figtree(.bold, size: 10))
                            .tracking(0.45)
                            .foregroundStyle(Color.auTextTertiary)
                            .frame(width: 52, alignment: .leading)
                            .padding(.top, 12)
                        KaraokeText(
                            text: line.text,
                            isSpoken: m.isSpeakingText(
                                line.text, speaker: line.speaker, audio: aud),
                            spokenRange: m.playback?.spokenRange
                        )
                        .font(.figtree(.regular, size: 15))
                        .auLine(15, 1.45)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(Color.auFill)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .stroke(Color.auEdge, lineWidth: 1)
                        )
                    }
                }
                .buttonStyle(.auTap)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(line.speaker). \(line.text)")
                .accessibilityIdentifier("au.player.transcript.line.\(idx)")
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(
                    Color.auAccent.opacity(0.34),
                    style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
        )
        .padding(.bottom, 14)
        .transition(
            reduceMotion ? .opacity : .opacity.combined(with: .offset(y: 8)))
    }
}
```

Insert the call in `itemView` immediately after `digitStrip` (i.e. after the line `digitStrip`, before the hint-ladder block):

```swift
// digit strip (testlet)
digitStrip

// The promised line-by-line reveal lands with the verdict (D-02).
responseTranscript
.animation(
    AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion),
    value: m.done)
```

Implementation notes (all verified against the current code):
- `m.playback` is `speaker as? VoicePlayback` — nil in previews/UI shells → the card collapses gracefully.
- `resolvedAudioID(_:)` is internal on `PlayerModel` and handles both short (`AUD043`) and full (`A1-C04-AUD036`) references (chapter-scoped via `cur?.chapter.id`).
- `AudioCatalog.Asset.lines` carry `speaker` (`"ALEX"`, `"NINA"`, `"GUIDE"`, …) and `text`; `VoicePlayback.speak(audioID:text:slow:lineIndex:)` plays exactly one line take and feeds karaoke state (`spokenLineText`, `spokenRange`), which `KaraokeText` + `isSpeakingText(speaker:audio:)` consume — the same pattern as the `said` bubble (lines ~526–553).
- C4 testlet items reference **two** assets across their set (`A1-C04-AUD036` / `A1-C04-AUD037`) — the card follows the current item's `aud`, which is correct.

### P1.4 — Align the unlock note with reality

`unlockNote` (lines ~894–908) currently promises: *“Complete the activity to reveal the transcript.”* With P1.3 the reveal is per-item, so reword the string to:

```swift
Text(String(localized: "Answer each question to reveal the line-by-line transcript — tap a line to hear it."))
```
(keep icon, fonts, layout).

### Phase 1 — Verification

```sh
xcodebuild -project Aurel.xcodeproj -scheme Aurel \
  -destination 'platform=iOS Simulator,name=iPhone 17' build
xcodebuild -project Aurel.xcodeproj -scheme Aurel \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -only-testing:AurelTests test
xcrun swift-format lint --recursive --configuration .swift-format Aurel
```

Manual spot-check (simulator, Chapter 1 → Lesson 3 “A Real First Meeting” → “Gist task”):
1. The three options read meaningfully (image option shows its alt sentence, not “Picture A”).
2. The chip reads “Main idea” (not “GIST”).
3. Answer an item → the dashed “What you heard” card appears; tapping a line plays only that line with karaoke highlight.
4. Before answering, no transcript is visible.
5. C4-L2 “Integrated listening” chip reads “Main idea · Details · Who says it · New situations”.

**Then follow §0.3 (report → user confirmation → commit).**


---

## 4. Phase 2 — Content fixes (`Aurel/Resources/Course/a1-course.json`)

**Files touched:** `a1-course.json` only. **Fixes:** D-04, D-05 (+C4 feedback alignment).
**Method:** the JSON is pretty-printed; apply the edits with a small throwaway `python3` transform (deterministic, reviewable `git diff`) or precise manual edits — never a bulk regex over the whole file. After editing, the file must still decode (run `python3 -m json.tool` on it) and the full unit suite must stay green. Fields touched here (`instr`, `prompt`, `scene`, `aud`, `icon`, and C4-only `ok`/`no`) are NOT conformance-pinned (§2 D-07 note).

### Table 2A — Prompt artifact strips (16 items, exact old → new)

| # | Chapter | Lesson | Screen | Item | Old `prompt` (verbatim) | New `prompt` |
|---|---|---|---|---|---|---|
| 1 | A1-C01 | L03 | S23 | PR-LS013 | `Line model: “Nice to meet you, Nina!”` | `You hear: “Nice to meet you, Nina!”` |
| 2 | A1-C01 | L03 | S23 | PR-LS014 | `Line model: “I'm Leo.”` | `You hear: “I'm Leo.”` |
| 3 | A1-C01 | L03 | S23 | PR-LS015 | `T8: “I'm fine! Excuse me, Nina — see you!” What happens next?` | `You hear: “I'm fine! Excuse me, Nina — see you!” What happens next?` |
| 4 | A1-C01 | L03 | S23 | PR-LS016 | `C6: “I'm great, thank you! And you?” Leo answers:` | `You hear: “I'm great, thank you! And you?” Leo answers:` |
| 5 | A1-C02 | L03 | S25 | PR-LS016 | `Maya's line at turn 8 — what does she want?` | `Maya's last request — what does she want?` |
| 6 | A1-C03 | L02 | S20 | PR-LS002 | `Where is Alex from? (replay, T03–T04)` | `Where is Alex from?` |
| 7 | A1-C03 | L02 | S20 | PR-LS003 | `Alex is a ____. (replay, T05–T06)` | `Alex is a ____.` |
| 8 | A1-C03 | L02 | S20 | PR-LS004 | `Maya is a ____. (replay, T07–T09)` | `Maya is a ____.` |
| 9 | A1-C03 | L02 | S20 | PR-LS007 | `Is Leo from Australia? (replay, T02)` | `Is Leo from Australia?` |
| 10 | A1-C03 | L02 | S20 | PR-LS008 | `Where is Alex from? (replay, T04–T05)` | `Where is Alex from?` |
| 11 | A1-C03 | L02 | S20 | PR-LS009 | `We're from ten countries — who is we? (replay, T06)` | `We're from ten countries — who is we?` |
| 12 | A1-C03 | L03 | S25 | PR-LS013 | `Alex — where is Alex from? (replay, entry 3)` | `Where is Alex from?` |
| 13 | A1-C03 | L03 | S25 | PR-LS014 | `Leo is from ____. (replay, entry 4)` | `Leo is from ____.` |
| 14 | A1-C03 | L02 | S21 | PR-P005 | `Which one? (AUD053 line 1, item 3)` | `Which one do you hear?` |
| 15 | A1-C03 | L02 | S21 | PR-P008 | `Arrow up or arrow down? (AUD054 pair 1 — Is she a …)` | `Arrow up or arrow down?` |
| 16 | A1-C03 | L02 | S21 | PR-P010 | `Which one? (AUD053 line 2, item 2)` | `Which one do you hear?` |

(Note: S21 `PR-P008` **has** audio — only its prompt is cleaned. `PR-P005`/`PR-P010` are also in Table 2B.)

### Table 2B — “Listen” without audio → honest instruction (46 items, rule-based)

For every item in the D-04 inventory apply **exactly** this decision rule:

1. **Exception first:** the three items in Table 2C get their `scene` added and become `Read.` items. The one item in Table 2D (if the user approves audio attachment) keeps `Listen.` and gains `aud`.
2. If the item has a non-empty `scene`, or its `prompt` itself carries the readable stimulus → new verb is `Read.`
3. Else if the item's stimulus is an image (`ill` on the item, or image-only options) → new verb is `Look.`
4. Preserve the original second sentence (`Choose.` / `Tap.`), e.g. `Listen. Choose.` → `Read. Choose.`, `Listen. Tap.` → `Look. Tap.`
5. Set `"icon": "eye"` on every converted item (was `ear`; `AUIcon.Kind(rawIcon:)` resolves `eye`).
6. Touch NOTHING else on the item (no `opts`, `key`, `ok`, `no`, `hints` in C1–C3 — Phase 3 owns those).

Expected outcome per screen (agent must print the final per-item mapping in the phase report):
- C3 S04/S06/S10/S12/S19, C4 S03/S04/S11/S12, C4 S23 → overwhelmingly `Read.` (their scenes/prompts are readable text; verify items with image-only stimuli individually for `Look.`).

### Table 2C — Restore the authored stimulus as visible text (3 items)

These testlet transfer items lost their never-recorded one-line audio; add their authored stimulus line (verbatim from the manifest's `stimulusAudio`) as a `scene` so the exercise keeps its original listening-comprehension shape in text form, then apply Table 2B rule 2 (`Read. Choose.` + `icon: eye`):

| Chapter | Lesson | Screen | Item | Add `scene` (exact value) |
|---|---|---|---|---|
| A1-C03 | L02 | S20 | PR-LS010 | `NINA: Leo is my friend. He's a cook.` |
| A1-C03 | L03 | S25 | PR-LS015 | `KENJI: Nina is my teacher. She's from Peru. Her class is great!` |
| A1-C03 | L03 | S25 | PR-LS016 | `SAM: Kenji is my friend. He isn't from Mexico. He's from Japan!` |

(`scene` is a first-class `PracticeItem` field — `PracticeScreen.swift` lines ~511–524 render it as a small play-icon text card. The play icon is decorative; acceptable. If the agent prefers, it may additionally change that icon to `.eye` when `item.aud == nil` — optional polish, keep minimal.)

### Table 2D — Optional exact-match audio attachment (1 item, needs user sign-off)

| Chapter | Lesson | Screen | Item | Action |
|---|---|---|---|---|
| A1-C04 | L03 | S23 | A1-CP1-LS008 | set `"aud": "A1-C03-AUD058"` and KEEP `Listen. Choose.` + `icon: ear` |

Rationale: the item's scene (“KENJI: Hi. I'm Kenji. I'm from Japan. I speak Japanese and English. I'm an engineer.”) matches asset `A1-C03-AUD058` (text: “Good afternoon. I'm Kenji. I'm from Japan. I'm an engineer. I speak Japanese and English.”, 11.2 s). Cross-chapter full-id references are supported (`resolvedAudioID` passes ids containing `-AUD` straight through; `AudioCatalogTests` guards resolution). If the user declines, apply Table 2B rule 2 instead.

### Table 2E — C4 feedback alignment (C4 is unpinned; safe in Phase 2)

For C4 items converted to `Read.` by Table 2B, fix feedback that still says “Listen/voices”:

| Item | Field | Old | New |
|---|---|---|---|
| A1-CP1-LS001 | `no` | `Two voices: Sam and Nina.` | `Two people: Sam and Nina.` |
| A1-CP1-LS005 | `no` | `Listen: R-I-V-E-R-A.` | `Read: R-I-V-E-R-A.` |
| A1-CP1-LS008 | `no` | `Listen: 'I'm from Japan.'` | `Read: 'I'm from Japan.'` — **skip this row if Table 2D attached audio** |

### Phase 2 — Verification

```sh
python3 -m json.tool Aurel/Resources/Course/a1-course.json > /dev/null   # still valid JSON
python3 <Appendix A.1>   # must print: TOTAL listen-without-audio items: 0
python3 <Appendix A.2>   # must print: total artifact prompts: 0
xcodebuild -project Aurel.xcodeproj -scheme Aurel \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -only-testing:AurelTests test
```

Manual spot-check: C3-L3 S25 — items LS015/LS016 now show the KENJI/SAM scene card with “Read. Choose.”; C1-L3 S23 transfer items show “You hear: …” prompts.

**Then follow §0.3 (report incl. full per-item mapping → user confirmation → commit).**


---

## 5. Phase 3 — Repair pinned misleading feedback (D-07) + drift registry

**Files touched:** `a1-course.json` + `AurelTests/ContentConformanceTests.swift`.

### 3.1 Content edits (exact old → new)

| # | Chapter | Screen | Item | Field | Old (verbatim) | New |
|---|---|---|---|---|---|---|
| 1 | A1-C03 | S20 | PR-LS010 | `ok` | `A cook—he's! New voice, same line.` | `A cook — yes! Leo is a cook.` |
| 2 | A1-C03 | S25 | PR-LS015 | `no` | `The voice says 'my teacher' — then the name.` | `The line says 'my teacher' — then the name.` |
| 3 | A1-C03 | S25 | PR-LS016 | `no` | `Listen AFTER 'isn't' — corrections give the answer.` | `Read AFTER 'isn't' — corrections give the answer.` |
| 4 | A1-C01 | S21 | PR-LS001 | `hints[0]` | `Play again; the speaker chips glow per turn.` | `Play again — count the different voices you hear.` |
| 5 | A1-C01 | S21 | PR-LS003 | `hints[0]` | `Replay T1.` | `Play again and listen to the first line.` |
| 6 (optional, ask user) | A1-C02 | S25 | PR-LS016 | `no` | `Her hand is at her ear.` | `Maya asks to hear the number again.` |

Hint arrays keep their second rung verbatim (e.g. `Two names are spoken. Count them.` stays).

### 3.2 Registering the drift (exact procedure)

`ok`/`no`/`hints` are pinned for C1–C3, so each edited field becomes conformance drift. The registry (`ContentConformanceTests.documentedDrift`, currently `[]`) must list each change or the suite fails. **Deterministic fill procedure** — do not hand-guess `canon()` output:

1. Apply the content edits above.
2. Run only the conformance suite:
   ```sh
   xcodebuild -project Aurel.xcodeproj -scheme Aurel \
     -destination 'platform=iOS Simulator,name=iPhone 17' \
     -only-testing:AurelTests/ContentConformanceTests test 2>&1 | tee /tmp/conf.log
   ```
3. The failure message prints every undocumented `Drift(key: "…", shipped: "…")` verbatim (key format `<chapter> <item-id>.<field>`, e.g. `A1-C03 PR-LS010.ok`; hints are the canon'd array joined with the `␟` separator; `canon` maps `‘ ’ “ ”` → `' ' " "`).
4. Paste exactly those entries into `documentedDrift`, e.g.:
   ```swift
   private static let documentedDrift: Set<Drift> = [
       // Exercise-meaningfulness plan §5 (owner-approved rewordings):
       Drift(key: "A1-C03 PR-LS010.ok", shipped: "A cook — yes! Leo is a cook."),
       // …remaining entries copied verbatim from the test failure output…
   ]
   ```
5. Re-run the suite → green. (The registry is also the audit trail: any future re-export from `english_course` that reverts these strings will trip the *stale-entry* check, forcing reconciliation.)

### Phase 3 — Verification

```sh
python3 -m json.tool Aurel/Resources/Course/a1-course.json > /dev/null
xcodebuild -project Aurel.xcodeproj -scheme Aurel \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -only-testing:AurelTests test
```

Manual spot-check: C1-L3 “Gist task” — miss an item twice → hint ladder shows the new plain hints (no “speaker chips”, no “Replay T1.”).

**Then follow §0.3 (report → user confirmation → commit).**

---

## 6. Phase 4 — Regression guards & final validation

**Files touched:** new `AurelTests/ListeningSanityTests.swift` (+ `xcodegen generate`, because the Xcode project is generated from `project.yml`).

### 4.1 New test file (complete — create verbatim)

```swift
import XCTest
@testable import Aurel

/// Listening-exercise integrity guards (Exercise-Meaningfulness plan, Phase 4).
///
/// Locks in the Phase 1–3 repairs at the content layer:
///  * an instruction that says “Listen” must have recorded audio to hear;
///  * learner-facing prompts must not carry authoring artifacts
///    (replay notes, turn ids, catalog ids, cue letters);
///  * testlet (listening-practice) items always reference a stimulus.
/// Reads the shipped bank with JSONSerialization — the same join style
/// ContentConformanceTests uses, so every item-bearing surface is covered.
final class ListeningSanityTests: XCTestCase {

    private lazy var chapters: [[String: Any]] = {
        guard
            let url = Bundle(for: ListeningSanityTests.self).url(
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

    /// Every shipped item on every item-bearing surface, with provenance.
    private var allItems: [(chapter: String, screen: String, item: [String: Any])] {
        var out: [(String, String, [String: Any])] = []
        for chapter in chapters {
            let chapterId = chapter["id"] as! String
            for lesson in chapter["lessons"] as! [[String: Any]] {
                for screen in lesson["screens"] as! [[String: Any]] {
                    for prop in ["items", "tasks"] {
                        for item in (screen[prop] as? [[String: Any]]) ?? []
                        where item["id"] != nil {
                            out.append((chapterId, screen["id"] as? String ?? "?", item))
                        }
                    }
                }
            }
        }
        return out
    }

    func testListenInstructionsAlwaysHaveAudio() {
        let offenders = allItems.filter {
            (($0.item["instr"] as? String ?? "")
                .trimmingCharacters(in: .whitespaces)
                .lowercased()
                .hasPrefix("listen"))
                && ($0.item["aud"] as? String ?? "").isEmpty
        }
        XCTAssertEqual(
            offenders.count, 0,
            "items instruct Listen but ship no audio: "
                + offenders.map { "\($0.chapter)/\($0.screen)/\($0.item["id"]!)" }.joined(separator: ", "))
    }

    func testTestletItemsAlwaysReferenceAudio() {
        let offenders: [String] = chapters.flatMap { chapter -> [String] in
            let chapterId = chapter["id"] as! String
            return (chapter["lessons"] as! [[String: Any]]).flatMap { lesson in
                (lesson["screens"] as! [[String: Any]]).flatMap { screen -> [String] in
                    guard screen["type"] as? String == "testlet" else { return [] }
                    return ((screen["items"] as? [[String: Any]]) ?? [])
                        .filter { ($0["aud"] as? String ?? "").isEmpty }
                        .map {
                            "\(chapterId)/\(screen["id"] as? String ?? "?")"
                                + "/\($0["id"] as? String ?? "?")"
                        }
                }
            }
        }
        XCTAssertEqual(offenders, [], "testlet items without a stimulus: " + offenders.joined(separator: ", "))
    }

    func testPromptsAreLearnerFacing() {
        // Authoring artifacts that must never reach the learner again (D-05).
        let pattern =
            "\\(replay|\\(entry \\d|\\(AUD\\d{3}|\\bT\\d{1,2}:|\\bC\\d:|Line model|line \\d, item|pair \\d|at turn \\d"
        let regex = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        let offenders = allItems.compactMap { entry -> String? in
            guard let prompt = entry.item["prompt"] as? String, !prompt.isEmpty else { return nil }
            let range = NSRange(prompt.startIndex..<prompt.endIndex, in: prompt)
            guard regex.firstMatch(in: prompt, options: [], range: range) != nil else { return nil }
            return "\(entry.chapter)/\(entry.screen)/\(entry.item["id"]!): \(prompt)"
        }
        XCTAssertEqual(offenders, [], "prompts carrying authoring artifacts: " + offenders.joined(separator: " | "))
    }
}
```

The code above is compile-clean as written (tuple labels convert on `return out`; the inner filter closures operate on the plain `[String: Any]` item dictionaries). If the toolchain still complains, flatten the nested `flatMap`s into `for` loops — semantics stay identical.

### 4.2 Register the file & run everything

```sh
xcodegen generate
xcodebuild -project Aurel.xcodeproj -scheme Aurel \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -only-testing:AurelTests test
xcrun swift-format lint --recursive --configuration .swift-format Aurel
```

Optional (long-running): `bash qa/run-ui-smoke.sh`.

### 4.3 Final manual validation script (simulator)

1. C1-L3 Gist task: image option shows meaning; chip reads “Main idea”; after answering, transcript card appears; tapping a line plays only that line.
2. C3-L3 S25: LS015/LS016 show scene cards + “Read. Choose.”.
3. C4-L2 “Integrated listening”: chip reads “Main idea · Details · Who says it · New situations”; transcript follows each item's audio; per-line replay works for both `AUD036` and `AUD037` items.
4. Miss an item twice anywhere: hint ladder contains no jargon.

**Then follow §0.3 (report → user confirmation → commit).**


---

## 7. Acceptance criteria (definition of done for the whole plan)

1. Appendix A.1 prints `TOTAL listen-without-audio items: 0`.
2. Appendix A.2 prints `total artifact prompts: 0`.
3. Appendix A.3 prints `missing from catalog: []` (still true after any `aud` additions).
4. Full `AurelTests` suite green, including the new `ListeningSanityTests` (3 tests) and `ContentConformanceTests` with the Phase-3 drift registry entries.
5. `xcrun swift-format lint --recursive --configuration .swift-format Aurel` clean.
6. `git status` shows no changes under `Archive/`, `AurelTests/Fixtures/`, `Aurel/Resources/Audio/`, `tools/`.
7. Manual simulator walk (§4.3) passes.
8. Every phase landed as its own user-confirmed commit (§0.3).

## 8. Out of scope — documented follow-ups (do NOT do these in this plan)

- **Generate the ~40 missing “fresh take” recordings** (`node tools/generate-audio.mjs`; `POE_API_KEY` already in root `.env`; generator reads `Archive/english_course`). After generation, the Phase-2 `Read.` items whose authored `stimulusAudio` now exists could return to `Listen.` with real `aud` refs — update Table 2B mappings accordingly and re-run Phase 4 guards.
- **Pre-response turn-scoped replay** (playing just T03–T04 when a question targets those turns) — needs per-item line-range data in the bank; the post-answer per-line transcript (P1.3) mitigates.
- **`speakTextForItem` TTS fallback redesign** (D-08) — currently unreachable; leave guarded.
- **`A1-CP1-G007` singular-they item** (“Where is Alex from? — They're from Canada.”) — intentional per the character bible (Alex: they/them); do not “fix”.
- Rewording remaining C1–C3 `ok`/`no` strings that merely say “Listen again” on items that DO have audio (they are truthful); only the five D-07 strings (+ optional sixth) are in scope.

---

## Appendix A — Audit scripts (run from the repo root; verbatim)

### A.1 — Listen-instruction items without audio (D-04; expect 0 after Phase 2)

```python
python3 - <<'PY'
import json
with open('Aurel/Resources/Course/a1-course.json') as f:
    data = json.load(f)
count = 0
for ch in data:
    for lesson in ch.get('lessons', []):
        for s in lesson.get('screens', []):
            for it in s.get('items', []) or []:
                if (it.get('instr') or '').lower().startswith('listen') and not it.get('aud'):
                    count += 1
                    print(ch['id'], s['id'], it['id'])
print('TOTAL listen-without-audio items:', count)
PY
```

### A.2 — Prompt artifacts (D-05; expect 0 after Phase 2)

```python
python3 - <<'PY'
import json, re
with open('Aurel/Resources/Course/a1-course.json') as f:
    data = json.load(f)
pat = re.compile(r'\(replay|\(entry \d|\(AUD\d{3}|\bT\d{1,2}:|\bC\d:|Line model|line \d, item|pair \d|at turn \d', re.I)
issues = []
for ch in data:
    for lesson in ch.get('lessons', []):
        for s in lesson.get('screens', []):
            for it in s.get('items', []) or []:
                p = it.get('prompt') or ''
                if p and pat.search(p):
                    issues.append((ch['id'], s['id'], it['id'], p))
for i in issues: print(i)
print('total artifact prompts:', len(issues))
PY
```

### A.3 — Every course `aud` reference resolves in the bundled catalog (must stay `[]`)

```python
python3 - <<'PY'
import json
with open('Aurel/Resources/Audio/audio-catalog.json') as f:
    cat = json.load(f)
assets = {a['id'] for a in cat['assets']}
with open('Aurel/Resources/Course/a1-course.json') as f:
    course = json.load(f)
refs = set()
for ch in course:
    for lesson in ch.get('lessons', []):
        for s in lesson.get('screens', []):
            if s.get('aud'): refs.add((ch['id'], s['aud']))
            for it in s.get('items', []) or []:
                if it.get('aud'): refs.add((ch['id'], it['aud']))
missing = [(c, r, (r if '-AUD' in r else c + '-' + r)) for c, r in refs
           if (r if '-AUD' in r else c + '-' + r) not in assets]
print('total refs:', len(refs), 'missing from catalog:', missing)
PY
```

## Appendix B — Testlet stimulus inventory (durations from the bundled catalog)

| Asset | Duration | Lines | Used by | Notes |
|---|---|---|---|---|
| A1-C01-AUD043 | 25.5 s | 8 | C1-L3 S21 (3 items), C1 S33 QZ-LS003 | model dialogue |
| A1-C01-AUD045 | 18.9 s | 7 | C1-L3 S23, C1 S33 QZ-LS004 | challenge take |
| A1-C01-AUD046 | 8.4 s | 4 | C1-L3 S22 (4 items) | detail testlet |
| A1-C02-AUD069 | 46.0 s | 10 | C2-L3 S23 (3), PR-LS016 transfer | longest C2 |
| A1-C02-AUD072 | 16.1 s | 5 | C2-L3 S24 (4) | Sam checks in |
| A1-C02-AUD073 | 7.3 s | 1 | C2-L3 S25 | fast email |
| A1-C03-AUD050 | 47.3 s | 10 | C3-L2 S20 (4) | |
| A1-C03-AUD051 | 34.6 s | 10 | C3-L2 S20 (2) | |
| A1-C03-AUD052 | 25.7 s | 6 | C3-L2 S20 (3) | |
| A1-C03-AUD057/058/059 | 9.5/11.2/16.7 s | 1 each | C3-L3 S25 | profile/roll-call |
| A1-C04-AUD036 | 55.5 s | 14 | C4-L2 S13 (4 of 6) | the “one long listen” |
| A1-C04-AUD037 | 34.4 s | 13 | C4-L2 S13 (2 of 6) | phone/spelling |
| A1-C03-AUD058 | 11.2 s | 1 | (Phase 2 Table 2D candidate for A1-CP1-LS008) | Kenji intro |

## Appendix C — Reference map

| Concern | File | Anchor (audited) |
|---|---|---|
| Item renderer (instruction, Listen button, options, hints) | `Aurel/Course/Player/Screens/PracticeScreen.swift` | `itemView` ~437; Listen button ~464–487; `said` bubble ~526–553; hint ladder ~580–641 |
| Rung chip / groups / digit strip / unlock note | same | `rungHeader` ~103; `groups` ~129; `digitStrip` ~847; `unlockNote` ~894; `testletGuidance` ~910 |
| Option rows incl. “Picture A” | same | `optionsView` ~1126; `optionRow` ~1152 (label at ~1200, a11y at ~1232) |
| Item state / audio resolution / per-line speak | `Aurel/Course/Player/PlayerModel.swift` | `speak` 135; `resolvedAudioID` 148; `speakTextForItem` 170 (do-not-touch, D-08) |
| Recorded playback + karaoke state | `Aurel/Services/VoicePlayback.swift` | `speak(audioID:text:slow:lineIndex:)`; `spokenLineText`/`spokenRange`/`spokenSpeaker` |
| Bundled catalog | `Aurel/Services/AudioCatalog.swift` + `Aurel/Resources/Audio/audio-catalog.json` | `Asset.lines` = per-line speaker/text/file |
| Content pins / drift registry | `AurelTests/ContentConformanceTests.swift` | `compareFields` ~332 (opts/key/tiles/ok/no/hints only); `documentedDrift` ~217; `canon` ~159 |
| Audio-ref guard | `AurelTests/AudioCatalogTests.swift` | `testEveryChapterReferenceResolvesOffline` |
| Course bank | `Aurel/Resources/Course/a1-course.json` | chapters `A1-C01…A1-C04`, lessons `L01…`, screens `S…`, items by `id` |
| Authored authority (read-only) | `Archive/english_course/**` | e.g. `A1_C03_L03_LESSON.md` LS015/LS016 records |
| Authored-manifest fixture (do not edit) | `AurelTests/Fixtures/course-manifest.json` | `stimulusAudio` fields used for Table 2C |

---

*End of plan. Implement §3 → §4 → §5 → §6 in order, honoring §0.3 (per-phase user confirmation before every commit).*
