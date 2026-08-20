# Aurel — defect ledger

Schema: `ID · title · severity · agent · source-of-truth ref · repro · expected vs actual · evidence · status · fix commit · retest`
Severity: **S0** crash/data loss/lesson uncompletable · **S1** wrong content/broken flow/a11y blocker/secret · **S2** visible deviation from design/ or english_course/ · **S3** cosmetic/internal.
Statuses: `open → verified → fixing → fixed → retested-closed | deferred-owner | source-staleness`.

## Fixed

| ID | Title | Sev | Found by | Fix commit | Retest |
|---|---|---|---|---|---|
| S0-001 | SVGPathShape infinite loop on `s`/`t` path commands — main-thread hang on the Goal screen (any accessibility client: XCUITest, VoiceOver) | S0 | harness bring-up (Phase 0.5) | (this iteration) | SVGPathShapeTests 4/4; SmokeSuite 4/4 incl. full onboarding walk |

**S0-001 detail.** Source: authored exam-goal icon `…c0 1.7 2.6 3 5.8 3s5.8-1.3 5.8-3…` (design Aurel.dc.html goal screen glyph). The parser's command switch had `S`/`T` but no lowercase `s`/`t`; the fallback consumed zero tokens, so the scan index never advanced — `path(in:)` spun forever on the main thread during layout. Repro: render any `d` containing lowercase `s`/`t`; AX snapshot or layout triggers it. Also fixed: implicit M-repetition pairs drew as moves instead of lines (e.g. the close icon's `M18 6 6 18` half-X). Regression: `AurelTests/SVGPathShapeTests.swift` (every authored icon path returns; exam icon non-empty; implicit-M pairs draw lines; s/S/t/T parse).

## Open (seeded from Phase 0 recon — to be verified/adjudicated in the loop)

| ID | Title | Sev | Agent | Source ref | Status |
|---|---|---|---|---|---|
| S1-001 | Dynamic Type non-functional: 483 fixed-size font call sites, `AUTypeScale.scaled()` has 0 callers, Settings text-size control (typeStep) persists but drives nothing | S1 | device-matrix / design-fidelity | design `--au-type` zoom (Aurel.dc.html:113,121,2757–2761) | open |
| S1-002 | `.assessReview` dispatches to `UnbuiltScreen` placeholder (authored screen exists) | S1 | navigation-state | Aurel.dc.html:349 | open |
| S1-003 | Startup `fatalError` on store-open failure (`AurelApp.swift:12`) — corrupt store = unrecoverable crash | S1 | data-persistence | — | open |
| S1-004 | Startup `fatalError` on course-load failure (`AppEnvironment.swift:21`) | S1 | data-persistence | — | open |
| S2-001 | `AUREL_SCREEN` env debug hook calls `persist()` — a debug route writes SwiftData (onboardedAt pollution) | S2 | adversarial-input | — | open (UI-test fast path `-AUREL_TEST_START` added WITHOUT persist; env hook still persists) |
| S2-002 | Three unstructured `Task { sleep }` races in AppRouter (assessPick 0.42 s / pickSceneReply 0.64 s / toggleSpeak 2.6 s) — rapid taps stack tasks | S2 | swiftui-correctness | — | open |
| S2-003 | 58 hardcoded Color literals in feature files bypass the token system (dark-mode/duplication risk) | S2 | design-fidelity | styles.css / --au-* layer | open |
| S2-004 | Alt-text parity drift: `course-c1.js:21` (V003 context) paraphrases the authored ILL002 alt; `course-c2.js:229` paraphrases ILL033 | S2 | content-fidelity | english_course alt_text records | open (source-side: fix belongs in the app's export pipeline, not design/) |
| S2-005 | ILL036 registered complete (36/36) in C2/C3 blocks but referenced by no screen in the banks | S2 | content-fidelity | ILLUSTRATION_ID_REGISTER.csv | open |
| S2-006 | Stale shell copy: Home "Chapters 1–3 are authored; 4–12 planned" and paywall "Twenty-four chapters" vs course reality (C4 done, 12-chapter arc) | S2 | content-fidelity | STATE.md / A1_COURSE_OVERVIEW.md | source-staleness (owner decision 3: keep design verbatim, log) |
| S3-001 | Empty AppIcon (1024 slot, no image) | S3 | device-matrix | — | backlog |
| S3-002 | `nextLine` player type handled but unused by any bank (dead branch) | S3 | architecture | CourseScreen.dc.html:1202 | backlog |
| S3-003 | CourseScreen dark-token subset (10 `--au-*` names + shadow overrides missing vs shell) — player dark-modes on a smaller surface | S3 | design-fidelity | CourseScreen.dc.html:20 | backlog (owner ruling: intentional-looking asymmetry) |
| S3-004 | WCAG: primary-button label `#fff8f0` on `--color-accent-600` = 4.26:1 — passes the 3:1 large-text threshold (16.5 pt semibold) but not 4.5:1 body-text | S3 | accessibility | qa/evidence/token-contrast.json | backlog (authored palette — owner register) |

## Owner decisions register

1. C04 + C05-L1/L2 authored in english_course but outside design/ scope → **deferred-owner** (verify C1–C3 only this run).
2. C3 quiz S29–S32 pending-in-design vs authored-in-course → **implemented from english_course** (commit `83be99c`).
3. Stale copy (S2-006) → keep design verbatim, logged.
