# Aurel — defect ledger

Schema: `ID · title · severity · agent · source-of-truth ref · repro · expected vs actual · evidence · status · fix commit · retest`
Severity: **S0** crash/data loss/lesson uncompletable · **S1** wrong content/broken flow/a11y blocker/secret · **S2** visible deviation from design/ or english_course/ · **S3** cosmetic/internal.
Statuses: `open → verified → fixing → fixed → retested-closed | deferred-owner | source-staleness`.

## Fixed

| ID | Title | Sev | Found by | Fix commit | Retest |
|---|---|---|---|---|---|
| S0-001 | SVGPathShape infinite loop on `s`/`t` path commands — main-thread hang on the Goal screen (any accessibility client: XCUITest, VoiceOver) | S0 | harness bring-up (Phase 0.5) | `9787a55` | SVGPathShapeTests 4/4; SmokeSuite 4/4 incl. full onboarding walk |

## Fixed (iteration 1 — pending gate re-run)

| ID | Title | Sev | Fix summary | Retest |
|---|---|---|---|---|
| S0-002 | Order items in practice screens stall Go-on | S0 | `PlayerModel.itemCanGo` ports the line-1590 override (`itemOrder → tileCorrect`); regression `PlayerModelTests` (4 tests) + MilestoneSuite L2 walk (test5) | unit green (fix5); UI gate pending |
| S1-001 | Dynamic Type non-functional | S1 | `AUTypeScale` live (5 authored steps as categories, max-with-system), scaling inside `Font.figtree/caprasimo`, RootView wiring from persisted typeStep + dynamicTypeSize | `SmokeTests.testTypeScaleStepsScale` |
| S1-003 | Startup fatalError on store-open failure | S1 | `AppSchema.openWithRecovery` — move-aside + fresh store + in-memory last resort; banner surfaces reset | manual + code path |
| S1-004 | Startup fatalError on course-load failure | S1 | `AppEnvironment.courseLoadFailed` → `CourseRecoveryView` with retry | code path |
| S1-005 | C2-L02/C3-L03 lesson titles | S1 | exporter correction (tools/content-corrections.mjs) | ContentConformanceTests (empty registry) |
| S1-006 | C2 Set C V010–V018 ill ids/Alts | S1 | exporter corrections ×9 | variant counts updated + conformance |
| S1-007 | goCourse(3) on 3-lesson chapter → C1L1 | S1 | threshold generalized to chapter lesson count | `AppRouterTests.testChapterCompleteRoutes…` |
| S1-009 | No day rollover; streak capped at 1 | S1 | `rolloverDayIfNeeded` (init + scenePhase active), `dayHalfCompleted` counts once, grace via `StreakEngine.rolloverRuling`, durable fields on LearnerProfile | `AppRouterTests` 3 tests + ServicesTests |
| S2-001 | AUREL_SCREEN hook persists | S2 | pure `screenHook(_:)` routing | `AppRouterTests.testScreenHookIsPureRouting` |
| S2-002 | 3 unstructured Task races | S2 | task handles + cancel/supersede on re-pick, back, leave, stop | `AppRouterTests` 4 tests |
| S2-004b | QZ-N005/ILL033 alt paraphrase | S2 | exporter correction | conformance |
| S2-007 | 4 C3 option orders rotated | S2 | exporter corrections (order + key) | conformance |
| S2-008 | PR-V014 emoji / QZ-WR001 "(? )" | S2 | exporter corrections (authored verbatim; "(? )" IS the authored string — bank had normalized it; flag likely source typo to owner) | conformance |
| S2-009 | V009 trailing period | S2 | exporter correction | conformance |
| S2-010 | 22 cardAlt paraphrases | S2 | exporter corrections (13 standalone + 9 inside S1-006 swap) | conformance |
| S2-011 | Authored order-item hints invisible | S2 | hint block in orderView (rung "Hint 1", first authored hint) after a wrong complete ordering | UI gate pending |

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
| S1-005 | C2-L02 and C3-L03 lesson titles drift from authored H1s: ships "Numbers, Contacts, and Are You…?" vs "Big Numbers and Contact Details"; "Profile Cards and Your Dot" vs "Profiles, Your Introduction, the Chapter Quiz" | S1 | content-fidelity (manifest harness) | A1_C02_L02_LESSON.md:1, A1_C03_L03_LESSON.md:1 | open — fix in export pipeline, design/ untouched |
| S1-006 | C2 Set C cards V010–V018 carry shifted illustration ids vs authored records AND briefs (V010 phone → ILL016 seven-cups with phone alt attached; ILL018–022/024 misassigned) | S1 | content-fidelity (manifest harness) | design/course-c2.js:50–58 vs english_course records | open — fix in export pipeline |
| S2-007 | Four C3 practice items reorder options vs authored order (keys remapped, answer text preserved): PR-RD003, PR-RD005, PR-LS012, PR-CV016 | S2 | content-fidelity (manifest harness) | A1_C03 LESSON records | open |
| S2-008 | Feedback copy drift: PR-V014 ok drops " 🙂"; QZ-WR001 no "(? )"→"(?)" | S2 | content-fidelity (manifest harness) | C1 records | open |
| S2-009 | C2 V009 `w` drops trailing period ("Please speak slowly.") | S2 | content-fidelity (manifest harness) | C2 records | open |
| S2-010 | Card alts paraphrase record alt_text — 21 further instances beyond S2-004 (C1 ×7, C2 ×14 incl. V003–V018, C3 V032) | S2 | content-fidelity (manifest harness) | vocab records | open — app export pipeline |
| S3-005 | 58 ILL ids carry >1 distinct alt within a chapter (english_course authors per-use alts — record alt_text ≠ ILL-brief alt; surface pinned, not asserted one-alt) | S3 | content-fidelity | ILL briefs vs records | backlog |

## Iteration-1 investigations (2026-08-21, four read-only subagents)

**New defects (fresh-eyes sweep + harness analysis):**

| ID | Title | Sev | Agent | Source ref | Status |
|---|---|---|---|---|---|
| S0-002 | "Put in order" items inside **practice** screens permanently disable Next/Go-on: design's `if (itemOrder) { v.canGo = v.tileCorrect }` override (CourseScreen.dc.html:1590) was not ported; `done` is only set by `pick()` which order items never call → lesson uncompletable. 12 shipped items: C1L2-S14 PR-G012/G019/G027 · C2L2-S18 PR-G004/G014/G017/G028 · C3L1-S12 PR-V030/V035 · C3L2-S15 PR-G013 · C3L2-S19 PR-CV007/PR-CV008. Course dead-ends at C1 L2 (quiz-screen order items escape via `isQuiet`, masking it in smoke runs) | S0 | fresh-eyes | CourseScreen.dc.html:1489-1490,1590 | open |
| S1-007 | `goCourse` hardwires `i >= 4` (design Aurel.dc.html:2029 assumes 4-lesson chapters): with C3 (3 lessons) complete, `pathAt=3` → Home "Continue · Chapter complete" (HomeView:223/249) calls `goCourse(3)` → `coursePos(chapterIdx:2, lessonIdx:3)` falls through to `return 0` → routes to **C1 L1 S01** in bound mode | S1 | fresh-eyes | Router+Chapters.swift:51 (C3=3 lessons) vs AppRouter.swift:381-387 | open |
| S1-009 | Day rollover never happens: `dayLesson`/`dayRecall`/`arcs` persist forever with no midnight reset, so from day 2 the day-arc shows yesterday's "done" forever; streak can never exceed 1 (`max(streak,1)` only); `DayLog` model + `StreakEngine` grace rule dead code. Design prototype is session-only so the obligation exists only in the persisted port (copy: Aurel.dc.html:2338-2339 "a day counts when both halves are done", 2421-2426 multi-day streak; Models.swift:27) | S1 | fresh-eyes | Models.swift:27-34, AppRouter.swift:412-419,505-515 | open |
| S2-011 | Authored hints on order items never surface: 10/15 order items carry english_course-authored hints; design intends to show them (CourseScreen.dc.html:1590 `showHint = …(tileComplete && !tileCorrect)`) but its own index math (`hints[min(wrong=0,len)-1]` = `-1` → empty "Hint 0" box) is a prototype artifact; the port renders nothing at all — authored instructional copy invisible | S2 | fresh-eyes | CourseScreen.dc.html:1487-1488,1590; a1-course.json order items | open |
| S2-012 | Unpinned same-class alt drift: quiz-item ill alts paraphrase briefs — QZ-V004 (ILL035), QZ-RD001/RD002 (ILL034); `compareFields` never compares item ill alts so the harness class is invisible today | S2 | content-fidelity | ILL briefs vs c1.js quiz items | open |

**Adjudications of seeded findings (iteration-1 investigations):**
- S1-005 **confirmed** (both titles; bank vs H1 quotes verified). Fix: exporter corrections table.
- S1-006 **confirmed** (9 ill-id shifts; V010 phone → ILL016 seven-cups + phone alt attached). Fix: exporter.
- S2-004 **split**: (a) course-c1.js:21 V003-context paraphrase = source-side (design bank paraphrase with no record counterpart → folds into S3-005 backlog); (b) course-c2.js:229 ILL033/QZ-N005 paraphrase **confirmed** → exporter fix.
- S2-005 **source-staleness**: ILLUSTRATION_ID_REGISTER.csv over-claims 36/36 wiring for C2/C3 blocks; no english_course lesson screen references ILL036 either. Escalation to content owner (register row), not an app defect. Fix deferred-owner.
- S2-007 **confirmed** (4 items; bank rotated correct answer into slot A, keys remapped). Fix: exporter.
- S2-008 **confirmed** (PR-V014 " 🙂"; QZ-WR001 "(? )"). Fix: exporter.
- S2-009 **confirmed** (V009 `w` trailing period). Fix: exporter.
- S2-010 **confirmed, count corrected to 22** (not 21). Fix: exporter.
- S1-001 **confirmed** — fix is central (2 font helpers + env plumbing), NOT 483 sites: every fixed font resolves through `Font.figtree(_:size:)`/`Font.caprasimo(size:)` (Typography.swift:113-123); zero `.font(.system)`/`@ScaledMetric` in app target. Authored control = 5-step geometric zoom `[0.88,0.94,1,1.18,1.4]` (Aurel.dc.html:2757-2761) — port maps steps onto content-size categories per Typography.swift:127-131 comment.
- S2-003 **confirmed** — 58 literals census: scene-art ramps (22× `#f7efe2` dusk cream, `#fbfaf5` on-accent-2, `#fff7ee` on-accent, `#f0a877` sun, paywall sky stops) have **no `--au-*` token equivalents** (design-gap escalation for promotion to real tokens); centralize as `AUSceneArt` constants + mechanical replacement; 5 sites are visual fixes needing sign-off.
- S1-002 **confirmed with nuance**: `.assessReview` currently unreachable from any interactive path (PLACEMENT bank empty by governance; `Screen.named` lacks the case). Fix implements the authored review screen + route case for state-machine completeness.
- S1-003/S1-004/S2-001/S2-002 **confirmed** (patch specs in iteration notes). Sibling scan: `try! NSRegularExpression` AUIcon.swift:18 (dormant, startup-adjacent) — logged S3-006; preview-only `try!` RootView.swift:97 S3-grade; `lines.last!` CourseStore.swift:107 guarded (safe).

## Owner decisions register

1. C04 + C05-L1/L2 authored in english_course but outside design/ scope → **deferred-owner** (verify C1–C3 only this run).
2. C3 quiz S29–S32 pending-in-design vs authored-in-course → **implemented from english_course** (commit `83be99c`).
3. Stale copy (S2-006) → keep design verbatim, logged.
