# Aurel — Improvement Plan (Phase 4)

> The complete, implementation-ready transformation plan. Owner decision governing scope: **"Evolve the language"** — keep the paper-and-dusk brand, Caprasimo/Figtree voice, authored copy, and calm governance (no confetti, no shaming, non-punitive streaks); redesign layouts, components, interactions, motion, and states wherever evidence shows a better pattern. Every item cites code or a Mobbin reference.

## 1. Executive summary

**Where Aurel stands:** an unusually strong foundation — distinctive identity, a tested token system, principled UX (retry ladder, rest days, honest stubs) — undermined by *execution-depth* gaps: zero haptics/sound, one motion primitive, fake data leaks, dead controls, and unanimated state changes (`AUDIT_FINDINGS.md` Part C).

**Target direction:** make Aurel *felt*, not just seen. Keep the dusk. Add the senses: haptic/motion/sound firing together at every action moment (the pattern every Mobbin reference shares — P2/P6). Make every rendered number real (SwiftData-derived). Complete every promised control. Elevate the placeholder illustration into brand art. Result: the calm app that also feels expensive.

**Goals:**
1. A complete feedback layer (haptics + sound + motion system) — the single largest premium delta.
2. Data honesty: zero hard-coded dates/stats/verdicts in shipped UI.
3. State craft: every state change animated; loading/empty/error/permission states complete.
4. Signature moments: path draw-in + travelling sun (Home), docked verdict (core loop), completion ritual (Result), milestone moments (Streak).
5. Accessibility: AX announcements, verified contrast, device adaptivity.
6. Brand first-touch: app icon + launch screen.

**Explicitly out of scope (owner decisions pending):** real auth backend, cohort backend, StoreKit products (IDs/prices — design README open decisions), commissioned illustration art, recorded audio. The plan stages these with honest labels instead of promises.

## 2. New design system spec

### 2.1 Color tokens (additions only — existing palette/ramps/tokens unchanged, `DesignTokens.swift`)
| New token | Light | Dark | Use |
|---|---|---|---|
| `--au-scrim` | black 85% → 0 gradient | same | Guaranteed text floor over dusk art (Welcome/Plan text tiers) |
| `--au-recording` | accent-2 ramp 600 | same | Live-recording state ring on Speak |
| `--au-ill-pattern` | accent 7% / cream 5% | same | Placeholder v2 field (§2.8) |

**Rule additions:** body text over art sits on `--au-scrim` or tests ≥ 4.5:1; meta text opacity floor raised from 0.40 → 0.55 after the contrast pass (`GAP_ANALYSIS.md` §0.8).

### 2.2 Typography (unchanged scale, new rules)
Families, sizes, tracking, `AUTypeScale` steps stay exactly as built (`Typography.swift`). New rules: (a) text over art uses `AUSceneArt.duskCream` at ≥ 0.76 opacity; (b) 0.4–0.55-opacity meta tiers are deprecated for anything below 14 pt.

### 2.3 Spacing & radii (adoption, not change)
`AUSpace`/`AURadius` values stay. New rule: new/modified layouts consume the scale (s2/s3/s4/s6) instead of ad-hoc paddings; existing authored paddings stay. The fixed `minHeight: 874/790` frames are replaced by available-height layouts in the screens listed in §3.

### 2.4 Elevation (unchanged)
`auLift`/`auSoft`/`auShadow*` as built (`DesignTokens.swift:326-355`).

### 2.5 Motion system (NEW — `AUMotion`)
| Token | Value | Used for |
|---|---|---|
| `AUMotion.instant` | 0.15 s easeOut | Toggle flips, chip picks |
| `AUMotion.quick` | spring(response 0.25, damping 0.8) | Verdict cards, hint ladder, tile insert/remove |
| `AUMotion.flow` | spring(response 0.4, damping 0.85) | Verdict dock slide, plan-card selection |
| `AUMotion.scene` | 0.5 s easeInOut + 24 pt slide | Player screen swaps, scene turns |
| `AUMotion.stagger` | 60 ms index delay (existing `auStagger`) | List/entrance choreography |

**Choreography rule (the P2 takeaway):** at any action moment, color + motion + haptic fire in the same frame — verdicts, selections, completions. **Reduce-motion rule:** every token degrades to opacity-only crossfades (extends the existing ambient-animation gating to system motion).

### 2.6 Haptics & sound (NEW — `AUFeedback`, `AUSound` services)
| Event | Haptic | Sound |
|---|---|---|
| Row/chip/plan selection | `UISelectionFeedbackGenerator` | — |
| Correct verdict | `UINotificationFeedbackGenerator .success` | Two-note soft chime |
| Miss verdict | `UIImpactFeedbackGenerator .soft` ×2 (80 ms apart) | Low muted thud |
| Toggle | `.light` impact | — |
| Lesson complete | `.success` + delayed `.rigid` | Three-note arpeggio |
| Streak milestone | `.success` | Single warm bell |


### 2.7 Component specs (updates)
- **Verdict dock (player + lesson runner):** unified container = verdict banner + CTA in one dock (P2: Duolingo exercise); slide-up with `AUMotion.flow`; success uses `auOkBg` wash + check; miss uses `auErrBg` wash (never saturated); haptic per §2.6; dock hides the CTA while the hint ladder is open.
- **Hint ladder card:** dashed accent border (existing) + staggered reveal (`AUMotion.quick`), one rung at a time.
- **Plan card (paywall):** selected = accent hairline + tint wash + scale 1.01; transition `AUMotion.flow`; selection haptic (P5: Universe/Open).
- **Settings row:** switch flip animates with `AUMotion.instant` + `.light` haptic.
- **Tile chips:** insert/remove with `AUMotion.quick`; correct assembly → glow pulse (accent shadow, 300 ms) + success haptic.
- **Empty/error states:** every list surface gets the authored-voice empty pattern (Review's "Nothing loose." is the model); error cards reuse `auErrBg` + icon + one-line recovery action.
- **Loading state:** paper background + wordmark pulse (opacity 0.6↔1, 1.2 s) — replaces the bare `Text("Loading course…")`.

### 2.8 Illustration placeholder v2
Keep the honesty contract verbatim (ILL ID kicker + alt caption, `Components.swift:836`). Upgrade the field: stripe → **dusk-paper gradient** (`AUSceneArt` ramps) with a subtle 7%-accent hatch at 135°, 1 pt accent-300 hairline inset, authored corner radius. Reads as intentional art direction, not a wireframe. No asset fabrication.

### 2.9 Accessibility baseline (applies to every screen)
- AX announcements: onboarding "Step N of 2"; player "Lesson L, screen S of T"; verdicts ("Correct"/"Try again"); streak delta; chart one-line summaries.
- Contrast: composite-on-art measured via extended `token-contrast` tooling; fix anything < 4.5:1 body / < 3:1 large.
- Touch targets: 44 pt everywhere (verify path labels).
- Dynamic Type: AX3 stress pass on the Home path + player layouts.

## 3. Per-screen action plan

### 3.1 Welcome (`Features/Onboarding/WelcomeView.swift`, route `welcome`)
- **Current + issues:** dusk hero with stagger choreography — the strongest screen (audit B1). One gap: blank launch flash precedes it (`project.yml:40`).
- **Target:** [P9: Oura welcome, Starling welcome] — launch-screen continuity into the hero.
- **Changes:** add a branded launch screen (dusk gradient + centered wordmark, `UILaunchScreen` colors via Info.plist); add the `--au-scrim` floor under the text block if the contrast pass requires it; keep everything else verbatim.
- **Implementation notes:** Info.plist `UILaunchScreen` properties in `project.yml`; scrim inside `WelcomeDusk` (`Shared.swift:227`). No dependencies.

### 3.2 Goal (`Features/Onboarding/OnboardingViews.swift` — GoalView, route `goal`)
- **Current + issues:** step meter + 4 `SelectableRow`s; multi-select cap communicated by copy only; no step AX announcement (audit B2).
- **Target:** [P7: Oura onboarding goal, Sesame onboarding].
- **Changes:** selection haptic via `AUFeedback.selection` on `SelectableRow` taps (benefits every consumer); add `.accessibilityLabel("Step 1 of 2")` on `StepHeader`; on a third pick, pulse the "Pick up to two" caption + play a soft double-haptic (cap feedback).
- **Implementation notes:** `Shared.swift` `SelectableRow`; haptics depend on the §5 stage-1 `AUFeedback` service.

### 3.3 Commit (`OnboardingViews.swift` — CommitView, route `commit`)
- **Current + issues:** reminder chips store a time no notification can fire (audit B3 — systemic §3.20).
- **Target:** [P7: Substack interests] for chip feedback.
- **Changes:** chip selection haptic; when the notifications layer lands (§5 stage 8), the chosen time becomes the default for the Dawn notification — until then the screen copy stays as authored (the time is stored).
- **Implementation notes:** same `SelectableRow` path; no copy changes (authored verbatim).

### 3.4 Plan (`OnboardingViews.swift` — PlanView, route `plan`)
- **Current + issues:** dusk summary rows + CTA; dusk-cream 0.62 contrast unverified (audit B4).

### 3.5 Login (`Features/Login/LoginView.swift`, route `login`)
- **Current + issues:** dead "Forgot password" text styled as a link (`:61-67`); no return-key flow; error not announced assertively (audit B5).
- **Target:** [P9: Starling welcome] for the quiet secondary-sign-in pattern.
- **Changes:** "Forgot password" becomes a `Button` opening an authored sheet ("We'll send a reset link" flow — local-only v1 shows "Account recovery arrives with online accounts" instead of a fake send); `.submitLabel(.next/.done)` chain email→password→submit; error announced via `UIAccessibility.post`; add a password-visibility toggle.
- **Implementation notes:** `LoginView.swift` only; `AUField` gains an optional error slot (§2.7).

### 3.6 Home (`Features/Home/HomeView.swift`, route `home`)
- **Current + issues:** chapter header, resume card, day-arc card, winding path (fixed coordinates, `:486-506`), paywall card, glass tab bar (audit B6).
- **Target:** [P1: Duolingo path home, Babbel course home] — current-stop emphasis, path draw-in, node pop-in.
- **Changes:** (a) `WindingPathShape` gains a `trim`-based draw-in on first reveal (1.2 s easeInOut, accent thread) with sequential `LessonPathNode` pop-in (`PopIn`, 60 ms stagger); (b) the open stop gets a persistent `PingRingStroke` pulse + "You are here" AX label; (c) the day-arc sun becomes scroll-linked (offset-driven along the arc — reduce-motion: static); (d) locked-stop first tap shows a 2-line explainer ("Opens after <prev lesson> — Chapter One is free, later chapters come with Aurel Pro"), paywall on the second tap; (e) path labels get minimum-scale + wrap rules for AX sizes; (f) AX grouping per stop (label + state + meta as one element).
- **Implementation notes:** `HomeView.swift`, `ArcSkyView.swift`; scroll-linked sun via a scroll-offset preference, subtle (0.3 multiplier). No copy changes.

### 3.7 Course player chrome (`Course/Player/CoursePlayerView.swift`, route `course`)
- **Current + issues:** instant screen swaps; `minHeight: 790` rigidity; bare loading text (audit B7).
- **Target:** [P2: Duolingo exercise chrome].
- **Changes:** (a) screen-swap transition: outgoing slides −24 pt + fades, incoming slides +24 pt (`AUMotion.scene`); (b) loading state = paper + pulsing wordmark (§2.7); (c) `minHeight` replaced by available-height computation (GeometryReader), authored 790 as the tall-device minimum; (d) AX announcement on advance: "Lesson {L}, screen {S} of {T}".
- **Implementation notes:** `CoursePlayerView.swift`; transitions wrap the `screenBody` switch with `.transition(.asymmetric(...))` + `.id(model.p)`; announcement hook in `PlayerModel.goto`.

- **Target:** [P9: Starling welcome] — value-summary rhythm (already matches).
- **Changes:** contrast-pass the 0.62 tier; apply `--au-scrim` if it fails; stagger parity already present.
- **Implementation notes:** `PlanDusk` (`Shared.swift:457`); contrast tooling from §5 stage 1.


### 3.8 Player — Core screens (`Course/Player/Screens/CoreScreens.swift`)
- **Current + issues:** promise/hook/orientation/pause/cards/letterCards/numbers/alphabet — placeholder stripe field is every lesson's first impression (audit B21).
- **Target:** [P2: Duolingo exercise energy — press feedback + continue slide].
- **Changes:** (a) `IllustrationPlaceholder` upgraded to v2 (§2.8) — one change re-skins all 115 player screens' art slots; (b) tap-anywhere advance gets a `.light` press haptic; (c) card listen buttons get an active accent tint while `Speaker.isSpeaking`; (d) can-do rings stagger on Promise (already present — verify).
- **Implementation notes:** `Components.swift:836` (placeholder v2), `CoreScreens.swift` for tints. Placeholder v2 must keep the `IllustrationPlaceholder` API (ill/height/radius/fullBleed) so no call site changes.

### 3.9 Player — Practice renderer (`Course/Player/Screens/PracticeScreen.swift`)
- **Current + issues:** retry ladder implemented but order-item hints invisible (**S2-011**, `qa/defects.md:71`); verdict/hint cards pop in (`:518-559`); no haptics (audit B22).
- **Target:** [P2: Duolingo multiple-choice, Quizlet study] — docked verdict, color+motion+haptic together.
- **Changes:** (a) verdict becomes a docked banner unified with the Go-on/Next CTA (slides up `AUMotion.flow`, ok/miss washes, paired haptics per §2.6); (b) hint ladder reveals rung-by-rung (`AUMotion.quick`); (c) **S2-011 fix:** order items render their authored hints after a wrong complete ordering (rung "Hint 1", first authored hint — the `CourseScreen.dc.html:1590` intent with corrected index math); (d) confusable/chart chip entrance transitions; (e) AX verdict announcements.
- **Implementation notes:** `PracticeScreen.swift` + a new `PlayerVerdictDock` component in `Components.swift`; hints ship in `a1-course.json` order items already.

### 3.10 Player — Assembly screens (`Course/Player/Screens/AssemblyScreens.swift`)
- **Current + issues:** order/tiles/emailAssembly/substitution/missionBrief/roleplay — tile pick/unpick unanimated; Undo all feedback-less (audit B23).
- **Target:** [P1 node-pop-in energy on chips; P2 haptic pairing].
- **Changes:** (a) `CompactFlowChips` insert/remove animation (`AUMotion.quick`, `matchedGeometryEffect` between source row and sentence); (b) correct assembly → glow pulse + success haptic (calm celebration); (c) "Undo all" gets `.light` haptic + quick fade-reset of numbered rows; (d) roleplay "Speak" gets the shared recording-state ring (§3.14).
- **Implementation notes:** `AssemblyScreens.swift`, `CompactFlowChips` (`PracticeScreen.swift:988`).

### 3.11 Player — Language screens (`Course/Player/Screens/LangScreens.swift`)
- **Current + issues:** review/grammarModel/pronPerceive/pronProduce/conversation — meta text 0.34–0.42 opacity unverified; turn swaps instant (audit B24).
- **Target:** [P6: Speak conversation exercise] for turn transitions.
- **Changes:** (a) meta-text opacity floor 0.55 after contrast measurement; (b) conversation turns transition with `AUMotion.scene` (active turn slides/fades in); (c) pronProduce adopts the shared `LiveWaveform` + honest verdict treatment (§3.14); (d) grammar-table rows get tap-to-hear with the active-tint treatment.
- **Implementation notes:** `LangScreens.swift`; shared `LiveWaveform` component extracted from §3.14.

### 3.12 Player — Assess screens (`Course/Player/Screens/AssessScreens.swift`)
- **Current + issues:** pending/quizIntro/results/remediation/reviewPlan/chapterMap — structurally complete (audit B25); share the systemic gaps.
- **Target:** [P4: Atoms/Babbel stats reveal].
- **Changes:** (a) results bars fill sequentially on appear (`AUMotion.quick`, 80 ms stagger); (b) chapter-map next chapter gets a one-time pulse; (c) AX summaries on the results breakdown; (d) Pending screen keeps its honest stub treatment verbatim (governance).
- **Implementation notes:** `AssessScreens.swift` only.

### 3.13 Lesson runner (`Features/QuickPractice/QuickPracticeViews.swift` — LessonRunnerView, route `lesson`)
- **Current + issues:** verdict dock pops in/out; Result carries fixed `minHeight: 874` (`:897`); no haptics; no review-mode badge (audit B8).
- **Target:** [P2: Duolingo exercise; Quizlet study].
- **Changes:** (a) dock slides with `AUMotion.flow` and stays resident while verdict is active (no re-pop between items — content crossfades inside); (b) verdict haptics per §2.6; (c) review-mode badge ("Review — loose ends") beside the progress rail when `reviewMode`; (d) available-height layout replaces the 874 fixed frame; (e) keyboard-avoidance pass for order items.
- **Implementation notes:** `QuickPracticeViews.swift`; badge uses the `ATag` component.

Gating: `sw.haptics` / `sw.sound` preferences (already persisted, `AppRouter` SwitchPrefs) + reduce-motion for choreography. Sound ducks under TTS playback. No sound on locked/error taps (calm).


### 3.14 Result (`QuickPracticeViews.swift` — ResultView, route `result`)
- **Current + issues:** **S1** week dots hard-code the first dot (`i == 0`, `:914-941`); stats derive from session counters (audit B9).
- **Target:** [P4: Atoms/Babbel stat tiles] — real data + AX summaries + calm completion ritual.
- **Changes:** (a) week dots derive from `DayLog` for the current week (today's dot fills on arc completion; earlier days show real history); (b) completion moment: stat tiles stagger in, success haptic + three-note arpeggio (§2.6), rays backdrop already authored; (c) AX summary on the stat row ("12 minutes · 6 settled · 2 to review"); (d) honest stats: minutes from session timing, settled/review from the run's items.
- **Implementation notes:** `QuickPracticeViews.swift`, `Persistence/Models.swift` `DayLog`; completion sound via `AUSound`.

### 3.15 Streak (`Features/PracticeHub/StreakBoardViews.swift` — StreakView, route `streak`)
- **Current + issues:** **S1** "Since 15 August" hard-coded (`:26`); "Best 47" fake (`:48`); month/week cells not data-driven (audit B10).
- **Target:** [P3: Babbel streak, Duolingo streak] — today-ring emphasis, real cells, calm milestone.
- **Changes:** (a) "Since {date}" from `LearnerProfile` start date; (b) Best from `DayLog` streak history; (c) every week/month cell driven by `DayLog` with a today-ring (accent ring pulse); (d) milestone moment at 7/30/100 days: authored line ("Seven quiet days.") + dawn-glow wash + warm bell — appears once, logged to profile; (e) AX: streak-change announcement.
- **Implementation notes:** `StreakBoardViews.swift`, `StreakEngine` (`Services.swift`), `LearnerProfile`/`DayLog`.

### 3.16 Speak (`Features/PracticeHub/PracticeHubViews.swift` — SpeakView, route `speak`)
- **Current + issues:** **S1** mock verdict — first take always "near" in error styling (`AppRouter.swift:703`, `SpeakView.swift:536-537,662-697`); `sin()` dummy waveforms (`:516-531`); `SpeechToText` service exists but is unused (grep-verified); no mic-permission-denied state (audit B14).
- **Target:** [P6: Speak exercise, ElevenLabs recorder] — live waveform, recording ring, honest verdict.
- **Changes:** (a) `LiveWaveform` component driven by `AVAudioRecorder` metering (real amplitude bars, accent-2 tint); (b) mic button gets an expanding recording ring while the take window runs; (c) **verdict honesty:** wire the existing `SpeechToText` service for a clarity-only check (the course forbids accent scoring) — output tiers "clear" / "near" / "nothing heard", with "near" rendered in the neutral tier (not error red) and copy per governance ("Closer each time."); if recognition is unavailable (permission denied / unsupported locale), the screen shows takes without verdict coloring and an honest one-line note; (d) mic-permission-denied state: Settings deep-link card ("The microphone is off. Aurel never keeps your voice."); (e) native playback scrubbing the waveform (progress tint).
- **Implementation notes:** `PracticeHubViews.swift`, `AppRouter.swift` `toggleSpeak/stopSpeak`, `Services.swift` `SpeechToText`; permission strings already in `project.yml:50-58`.

### 3.17 Review (`PracticeHubViews.swift` — ReviewView, route `review`)
- **Current + issues:** **S2** due labels positional (`:916`) — not `ReviewScheduler` dates (audit B15).
- **Target:** [P4: Vocabulary due lists].
- **Changes:** (a) due badges from the scheduler's real intervals ("Due tomorrow" / "Due in 3 days" — actual next-due dates); (b) urgency badge styling (soonest = accent tint, later = flat); (c) empty state kept verbatim.
- **Implementation notes:** `PracticeHubViews.swift`, `ReviewScheduler` (`Services.swift`).

### 3.18 Progress (`Features/Progress/ProgressProfileSettingsPaywall.swift` — ProgressView, route `progress`)
- **Current + issues:** **S1** "Since 15 August"/"Last practised Thursday" hard-coded (`:65,72`); **S2** synthetic skill numbers (`:25-55`); chart provenance unverified (audit B16).
- **Target:** [P4: Babbel/Vocabulary/Atoms stats].
- **Changes:** (a) dates from `LearnerProfile`/`DayLog` ("Since 22 August" / "Last practised today"); (b) skills derived from `LessonRecord` aggregates by authored skill tags (the course JSON carries item types); (c) 8-week chart from `DayLog` history — empty weeks render as zero-height bars (no invented history); (d) AX one-line chart summary; (e) skill-row tap-through verified (Speaking → speak, Conversation → scene — already routed, keep).
- **Implementation notes:** `ProgressProfileSettingsPaywall.swift`, `Persistence/Models.swift`; small aggregation helper in `Services.swift`.

### 3.19 Profile (`ProgressProfileSettingsPaywall.swift` — ProfileView, route `profile`)
- **Current + issues:** static milestones copy; avatar disc (audit B17).
- **Target:** [P8: Garmin profile rows] — row consistency only.
- **Changes:** (a) milestones render from real streak/lesson events ("Fourteen days in August", derived) or the section hides when empty (honesty); (b) row visual consistency pass (chevron + divider rhythm from settings rows); (c) sign-out header state verified.
- **Implementation notes:** `ProgressProfileSettingsPaywall.swift`; milestones derive from `DayLog`/`LearnerProfile`.

### 3.20 Settings (`ProgressProfileSettingsPaywall.swift` — SettingsView, route `settings`)
- **Current + issues:** **S2** four dead toggles (`:680-715`); widget preview promises a missing product (`:720-742`); reminder time not adjustable (audit B18).
- **Target:** structural parity already; wiring is the work.
- **Changes:** (a) **UserNotifications wiring:** first enable requests permission; Dawn fires at the onboarding-chosen time (default 19:30, authored copy "Today's lesson is ready."); Sundown only when items are actually due; Milestones on streak/lesson milestones; Cedar Group gated on `boardOut`; all off by default (governance); (b) Haptics/Sound toggles become live gates of `AUFeedback`/`AUSound` (§2.6) — no longer dead; (c) reminder time-picker row (the four Commit chips, in-place); (d) widget row: honest "Coming later" label (keeps the arc art) or removal — default honest label; (e) toggle haptic + `AUMotion.instant` switch animation; (f) slider announces its value ("Step 3 of 5 — Larger").
- **Implementation notes:** new `Notifications` service in `Services.swift`; Settings rows in the same file.

### 3.21 Paywall (`ProgressProfileSettingsPaywall.swift` — PaywallView, route `paywall`)
- **Current + issues:** **S1** simulated purchase (`AppRouter.swift:724-732`); no pending/failure/restore states (audit B19).
- **Target:** [P5: Universe paywall, Open paywall, Docusign upgrade].
- **Changes:** (a) plan-card selection animation (accent hairline + tint wash + scale 1.01, `AUMotion.flow`) + selection haptic; (b) CTA text reflects the chosen plan ("Continue — Annual" / "Continue — Monthly"); (c) StoreKit state machine when products exist: loading prices, pending, success, failure (calm error card + retry), restore with result feedback; until then the screen keeps honest no-price copy and the existing button label (no fake prices — governance); (d) manage-subscription deep link when StoreKit lands.
- **Implementation notes:** `ProgressProfileSettingsPaywall.swift`, `AppRouter.swift` subscribe paths; StoreKit gated on owner product IDs (design README open decision #1).

### 3.22 SubscribeAccount (`ProgressProfileSettingsPaywall.swift` — SubscribeAccountView, route `subscribeAccount`)
- **Current + issues:** field styling inconsistent with Login (`:1337-1382`); no field-level validation (audit B20).
- **Target:** [P5: Docusign account step].
- **Changes:** (a) adopt `AUField`/`AUTextField` for both fields; (b) field-level validation (email format, password length) with inline errors on submit attempt; (c) confirm-password field; (d) return-key chain.
- **Implementation notes:** `ProgressProfileSettingsPaywall.swift`; reuses Login components.

### 3.23 Leaderboard (`StreakBoardViews.swift` — LeaderboardView, route `leaderboard`)
- **Current + issues:** **S2** mock board data (`:410-414`) presented as real (audit B11).
- **Target:** [P8: Strava, Garmin leaderboards] — with our rules-first framing retained.
- **Changes:** (a) until a cohort backend exists (owner decision), the board renders a labeled sample state: kicker chip "Sample group — cohorts arrive with online accounts" + the same rows (visual system stays demonstrable, promise stays honest); (b) my-row gets `.accessibilityValue("You")` + a slightly stronger wash; (c) top-3 rank numerals in accent (complete the partial treatment).
- **Implementation notes:** `StreakBoardViews.swift` only.

### 3.24 Scene (`PracticeHubViews.swift` — SceneView, route `scene`)
- **Current + issues:** the 640 ms turn advance is visually instant (audit B13).
- **Target:** [P6: Speak conversation exercise].
- **Changes:** (a) turn transition `AUMotion.scene` — previous turn fades/slides up, new turn + reply chips slide in; (b) TTS-speaking indicator: the active turn's ear icon pulses while `Speaker.isSpeaking`; (c) scene-complete calm moment (authored line + success haptic) when the last turn resolves.
- **Implementation notes:** `PracticeHubViews.swift`; the advance task (`AppRouter.swift:653-667`) triggers the transition instead of a hard swap.

### 3.25 Stories hub (`PracticeHubViews.swift` — StoriesView, route `stories`)
- **Current + issues:** static list entrance vs onboarding's staged reveals (audit B12).
- **Target:** [P1: Babbel course home hub rows].
- **Changes:** hub rows + story rows stagger in with `auStagger` (60 ms, cap 8 items); live sub-states already authored ("3 waiting", "In progress").
- **Implementation notes:** `PracticeHubViews.swift`; reuses the existing modifier.

### 3.26 Cross-cutting states (banners, recovery, launch)
- **Current + issues:** offline banner (Home only — acceptable, bundled content); `StoreRecoveredBanner` and `CourseRecoveryView` exist and work; blank launch + empty icon (S3-001, audit B26.6).
- **Target:** [P9: Oura/Starling launch continuity].
- **Changes:** (a) branded launch screen (dusk gradient + wordmark via `project.yml` `UILaunchScreen` properties; welcome hero matches); (b) authored app icon: dusk-gradient rounded square + cream "A over dune" mark (the `AULogoMark` composition), all sizes; (c) banners get `AUMotion.flow` entrance (verify each mount point); (d) Speak screen offline note ("Recognition runs on this phone — it works offline.") — copy check only.
- **Implementation notes:** `project.yml` Info.plist + `Assets.xcassets/AppIcon.appiconset` (render the mark from the authored SVG at 1024² and scale); banners in `RootView.swift`/`Shared.swift`.

## 4. New features to add (and where they belong)

| # | Feature | Where it lives | Evidence/benchmark | Notes |
|---|---|---|---|---|
| F1 | `AUFeedback` haptic service | `Aurel/DesignSystem/` (new file) | P2/P5/P7 | Gates on `sw.haptics`; §2.6 table |
| F2 | `AUSound` feedback-sound service | `Aurel/DesignSystem/` (new file) | P2 | Gates on `sw.sound`; ducks under TTS |
| F3 | `AUMotion` token set | `DesignTokens.swift` extension | P2/P5/P6 | §2.5 table; reduce-motion degrades |
| F4 | `PlayerVerdictDock` component | `Components.swift` | P2: Duolingo/Quizlet | Player + lesson runner |
| F5 | `LiveWaveform` + recording ring | `Components.swift` + `Services.swift` | P6: Speak/ElevenLabs | Real metering; shared by §3.11/§3.16 |
| F6 | Illustration placeholder v2 | `Components.swift` | audit B21 | Brand-pattern upgrade, contract kept |
| F7 | Local notifications service | `Services.swift` (new `Notifications`) | audit B18/B3 | Dawn/Sundown/Milestone/cohort gates |
| F8 | Data-honesty helpers | `Services.swift` aggregation | audit B9/B10/B15/B16 | SwiftData → view models |
| F9 | Milestone moments (calm) | Streak + Result | P3 | 7/30/100 days, once each |
| F10 | Branded launch + app icon | `project.yml` + assets | P9 | Kills the white flash (B1) |
| F11 | AX announcement helpers | `Components.swift` | §2.9 baseline | Steps, screens, verdicts, charts |
| F12 | Path draw-in + scroll-linked sun | `HomeView.swift`/`ArcSkyView.swift` | P1 | Signature moment |

Deliberately **not** added (governance/owner decisions): streak-freeze purchases, leagues/daily-quests gamification, streak-saver ads, notification nags, confetti anywhere, share-to-social prompts, fake social proof. Engagement comes from calm loops: the dawn/sundown ritual, the review ladder, milestone lines, "One more, for the pleasure of it".

## 5. Implementation order

**Stage 0 — Branch hygiene (before any code):** commit the in-flight `qa/hardening` work; branch `design/transformation` from it. (Confirmed at the Phase 5 gate.)

**Stage 1 — Foundation (design system first, per the mandate):** F1 `AUFeedback`, F2 `AUSound`, F3 `AUMotion`, F11 AX helpers, F6 placeholder v2, contrast tooling extension. Unit tests for each service (haptic/sound gating, motion degrade, placeholder contract — extend the `DesignTokenTests`/`SmokeTests` patterns).

**Stage 2 — Core loop (highest value):** §3.9 Practice renderer (verdict dock + S2-011 hints + haptics), §3.13 Lesson runner (dock slide + badge + layout), §3.14 Result (real week dots + completion ritual). MilestoneSuite must stay green.

**Stage 3 — Home signature:** §3.6 path draw-in, node pop-in, current-stop ring, scroll-linked sun, locked-stop explainer, AX grouping.

**Stage 4 — Data honesty:** §3.15 Streak, §3.18 Progress, §3.17 Review due dates, §3.23 Leaderboard sample label, §3.19 Profile milestones.

**Stage 5 — Speak honesty:** §3.16 live waveform, recording ring, permission states, verdict rework (+ §3.11 pronProduce adoption).

**Stage 6 — Player chrome + remaining player families:** §3.7 transitions/loading/layout, §3.8 core polish, §3.10 assembly motion, §3.12 assess reveals.

**Stage 7 — Account cluster:** §3.5 Login fixes, §3.22 SubscribeAccount fields, §3.21 Paywall states, §3.20 Settings wiring (F7 notifications, time picker, toggle gates).

**Stage 8 — Onboarding + hub polish:** §3.2–3.4 AX/haptics/contrast, §3.24 Scene transitions, §3.25 Stories stagger.

**Stage 9 — Brand first-touch:** §3.26 launch screen + app icon + banner entrances.

**Stage 10 — Full verification:** all unit + UI tests; screenshot parity pass per screen (existing `tools/shot.sh` + `qa/ui-parity` workflow); on-device AX audit; AX3 Dynamic Type stress; light+dark sweep.

## 6. Success criteria per screen

| Screen | Verified done when |
|---|---|
| Welcome (3.1) | Launch screen shows dusk brand → hero with no white flash; contrast pass ≥ 4.5:1 on text tiers; screenshots light+dark |
| Goal (3.2) | Selection haptic fires (manual + unit test of the feedback call); "Step 1 of 2" AX label present; third-pick cap feedback visible |
| Commit (3.3) | Chip selection haptic; stored time feeds the Dawn notification default once Stage 7 lands (unit test) |
| Plan (3.4) | 0.62-tier contrast measured and passing (or scrim applied); no other visual change |
| Login (3.5) | "Forgot password" is a Button with an honest sheet; return-key chain works; error announced; visibility toggle works |
| Home (3.6) | Path draw-in plays once (first reveal only); open-stop ring pulses; sun tracks scroll (reduce-motion: static); locked-stop explainer then paywall; AX grouping verified; AX3 labels wrap without collision |
| Course chrome (3.7) | Screen swaps animate forward/back; loading state branded; layout correct on 375-pt and 440-pt widths; "Lesson L, screen S of T" announced |
| Core screens (3.8) | Placeholder v2 renders on every ILL slot (spot-check promise/cards across C1–C3); listen buttons tint while speaking; press haptic on advance |
| Practice renderer (3.9) | Verdict dock slides with paired haptic + sound; S2-011 hints surface on wrong orderings; hint ladder animates; AX verdict announced; MilestoneSuite green |
| Assembly (3.10) | Tile insert/remove animates; correct-assembly glow + haptic; Undo-all haptic |
| Language (3.11) | Meta text ≥ 0.55 opacity passing contrast; turns animate; pronProduce uses LiveWaveform + honest verdict |
| Assess (3.12) | Results bars fill sequentially; chapter-map pulse once; AX summaries present; Pending stub verbatim |
| Lesson runner (3.13) | Dock slides and crossfades between items; review-mode badge; 375-pt layout verified; haptics on verdicts |
| Result (3.14) | Week dots reflect real `DayLog` (unit test: today-only completion marks exactly one dot); completion haptic+sound once; AX stat summary |
| Streak (3.15) | "Since" from profile start (unit test); Best from history; today-ring; milestone appears once at 7 (test) |
| Speak (3.16) | Waveform reacts to real mic input; recording ring; permission-denied state reachable; "near" never error-red; honest note when recognition unavailable; no mock verdicts |
| Review (3.17) | Due badges match `ReviewScheduler` (unit test against the ladder) |
| Progress (3.18) | Dates/stats/chart all SwiftData-derived (unit test with seeded store); empty history renders zero bars; AX chart summary |
| Profile (3.19) | Milestones real or section hidden; row rhythm consistent |
| Settings (3.20) | Notification toggles schedule real local notifications (unit test via mock center); haptics/sound toggles gate the services; time picker works; slider announces |
| Paywall (3.21) | Plan selection animates + haptic; CTA reflects plan; state machine handles pending/failure/restore once StoreKit exists (or honest pre-StoreKit labeling) |
| SubscribeAccount (3.22) | Fields use `AUField`; inline validation; return-key chain |
| Leaderboard (3.23) | Sample-state label visible; my-row AX "You"; top-3 accent |
| Scene (3.24) | Turns animate; speaking pulse; complete moment fires once |
| Stories hub (3.25) | Rows stagger; states live |
| Cross-cutting (3.26) | Branded launch + icon in place; banners animate in; offline note on Speak |

**Global acceptance (every stage):** full test suite green (`xcodebuild test`), screenshots captured for touched screens, no new color literals outside tokens (existing `ColorLiteralTripwireTests` extended), reduce-motion sweep for every new animation, light+dark screenshots.

## 7. Mandatory self-check

- [x] Every screen in `SCREEN_INVENTORY.md` has a section in §3 (20 router screens §3.1–3.25; the 31 player payload types are covered in §3.7–3.12 family sections with per-type call-outs; cross-cutting states §3.26).
- [x] Every finding has a code or Mobbin citation (sections cite `File:line` or `MOBBIN_RESEARCH.md` P-references).
- [x] No placeholders, truncation, or ellipses (all lists complete; the only deferrals are explicit owner decisions with honest interim treatments).
- [x] Design system fully specified (§2.1–2.9).
- [x] Implementation order defined (§5, stages 0–10, design system first).


Each stage ends with: build, full test suite, screenshots of touched screens, and a report against the §6 criteria.



