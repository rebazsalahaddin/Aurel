# Aurel — Audit Findings (Phase 1)

> Evidence-based audit of every screen, state, and component. Citations: `File:line`. Severity scale follows `qa/defects.md`: S0 crash/data-loss · S1 wrong content/broken flow/a11y blocker · S2 visible deviation/missing expected behavior · S3 cosmetic. "Missing" = absent vs. the bar for a top-tier learning app (benchmarked in Phase 2/3).

## Part A — Current design system (as built)

### A.1 Color
- **Base roles** (`DesignTokens.swift:86-122`, adaptive light/dark via `UIColor` dynamic providers): `bg` (warm paper), `surface`, `text`, `accent`, `accent-2` (sage), `divider`. Light `bg` #f5ead8-family; dark overrides from `.aurel-dark` (gated by `DesignTokenTests` against `design-tokens.json`).
- **Three constant ramps** (9 steps each, theme-invariant): neutral #f9f4ed→#2e2b25, accent #fff2eb→#402310, accent-2 sage (`DesignTokens.swift:88-95`, `TokenRegistry.swift:45-74`).
- **21 `--au-*` semantic tokens** (`AUColorTokens`, `DesignTokens.swift:132-237`): glow, glow-2, hi, edge, fill, err/err-bg/err-text, ok-bg/ok-text/ok-quiet, tint-bg/tint-text, flat-bg/flat-text, dune/dune-2/dune-text, accent-text, sage-text, accent-press.
- **`AUSceneArt`** (`DesignTokens.swift:367-384`): 9 theme-fixed art colors (dusk cream #f7efe2, sun mid #e29256, deep green) — deliberately not adaptive (S2-003 fix).
- **Gradients** (`AUGradients`, `DesignTokens.swift:245-322`): sky, glass (158°), primaryButton (accent-600→700 + white share), angled selection wash.
- **Contrast debt**: button label on accent = 4.26:1 (S3-004, `qa/defects.md`); dusk-cream text at opacities 0.76/0.58/0.45 over dusk art on Welcome (`WelcomeView.swift:62,67,95`) is unmeasured — flagged for the Phase 3 contrast pass; `qa/evidence/token-contrast.json` covers tokens only.

### A.2 Typography
- **Two bundled families**: **Caprasimo** (display, single weight; headlines 17–96 pt, negative tracking) + **Figtree** (body; 5 static weights resolved via `wght` axis, cached — `Typography.swift:33-130`).
- **Scale**: authored design-point sizes, no named ramp — sizes in use include 8.5–17 body steps and 19/21/22/27/28/29/31/33/34/44/96 pt display steps (grep across Features/Player). Line heights via `.auLine`/`.auHeadLine` helpers (`Typography.swift:169-276`).
- **Dynamic Type**: live via `AUTypeScale` — authored 5-step zoom `[0.88,0.94,1,1.18,1.4]` mapped to content-size categories, max-with-system, driven from Settings + system (`Typography.swift:281-376`, `RootView.swift:50-58`; S1-001 fix).
- **Caps-kicker pattern** pervasive: Figtree bold 8.5–11 pt, tracking 1.0–2.0, uppercase, accent-text or 0.42–0.48-opacity text.

### A.3 Spacing, radii, elevation
- **Spacing** (`AUSpace`, `DesignTokens.swift:63-70`): s1=4.4, s2=8.8, s3=13.2, s4=17.6, s6=26.4, s8=35.2 — but **most screens hand-set paddings** (24 screen margin; 74/70/62 top insets; 44/34/32/28/26 bottoms; 14/16/17/19/20 card insets). The scale exists but is nearly unused (grep: `AUSpace` referenced only inside DesignTokens).
- **Radii** (`AURadius`): sm 8, md 16, lg 28, lgPadded 32.2, btn 22, key 24, pill 999; plus ad-hoc 14/15/17/18/19/20/24/30 at use sites.
- **Shadows** (`DesignTokens.swift:326-355`): auLift (two-layer whisper), auSoft (glass), sm/md/lg CSS approximations; selection glow (`Shared.swift:808`).

### A.4 Iconography & imagery
- **37 authored icon kinds** (`AUIcon.swift:258-264`) rendered from SVG path data verbatim via `SVGPathShape` — no SF Symbols in the UI.
- **Illustrations**: `IllustrationPlaceholder` candy-stripe fields with authored ILL IDs + alt captions (`Components.swift:836-910`) — honest placeholders; real art not commissioned.
- **Photography**: none (V4 replaced the photo hero with authored dusk art).
- **Brand mark**: `AULogoMark` "A over dune" SVG (`Shared.swift:10-38`).

### A.5 Motion & haptics
- **Motion primitives**: `auScreenEntrance` (screen fade+rise, `Components.swift:444-494`), `auStagger` (index-choreographed reveals — used on Welcome/Goal/Commit/Plan and 2 player sites only), `PopIn` (`ArcSkyView.swift:397`), press feedback `.auTap` (scale 0.972, spring 0.22/0.7, `Components.swift:10-18`), `WaveForm` bars, `PingRingStroke` pulse, twinkling `AUStars`, travelling sun in `ArcSkyView`, progress-rail animations (easeInOut 0.3–0.5 s).
- **Reduced motion**: respected in ambient animations (`WaveForm`, `PingRingStroke`, stars) — governance requirement met.
- **Haptics: none anywhere.** Zero `UIImpactFeedbackGenerator`/`sensoryFeedback` call sites in the app target (grep verified). The Settings "Haptics — On answer and completion" toggle (`ProgressProfileSettingsPaywall.swift:681-683`) persists a preference that is never read. Same for "Sound — Soft and sparse" (`:680`). **The single biggest feel gap in the app.**

### A.6 Component styles
- **Buttons**: `APillButton` primary (accent gradient, hi-line overlay, shadow, Figtree 600 16.5, radius 22, 17/22 padding), ghost (glass), quiet (divider outline), dashed (start-over), compact + player variants (`Components.swift:27-235`); `AUKeyButton` (`:236`); `GoOnButton` player CTA (flat accent-600, radius 20, `CoursePlayerView.swift:178-186`); icon buttons = 44×44 circle + hairline ring; brand-mark ghost sign-in buttons.
- **Cards**: `ACard` fill+edge+lift, radius 14–28 (`Components.swift:380`); `AUSelectSurface` selected wash (`Shared.swift:783-817`); glass verdict dock (`.ultraThinMaterial` + gradient, `QuickPracticeViews.swift:52-67`).
- **Inputs**: `AUField`/`AUTextField` glass 54-pt fields (`LoginView.swift:142-201`).
- **Navigation**: no NavigationStack — the entire app is a hand-rolled state-machine switch (`RootView.swift:152+` `ScreenHost`) with screen-level entrance transitions only; custom glass `AUTabBar` (`Shared.swift:602-658`), custom back/close buttons.
- **Lists**: authored rows (board, settings, story, review) — hand-built each time; consistent materials but no shared row component beyond `SelectableRow`.


## Part B — Per-screen audit

### B1. Welcome (`WelcomeView.swift`) — dusk hero
- **Visual (strengths to protect)**: authored night-sky + dune composition, twinkling stars, rising sun (`Shared.swift:227-455`); wordmark row; 44 pt Caprasimo headline "English, unhurried."; staged entrance (`auStagger 0-4`); glass "Chapter One free, no account" chip.
- **UX**: primary "Begin the path" + secondary "Sign in" with gradient rules; both wired (`WelcomeView.swift:75-123`). No first-run vs returning distinction (fine — login is one tap away).
- **Missing states**: none needed (static hero). No launch continuity: blank `UILaunchScreen` (`project.yml:40`) flashes to dusk — a branded launch moment is missing.
- **Accessibility**: dusk-cream at 0.76/0.58/0.45 opacity over art — contrast unverified (likely < 4.5:1 for the 0.45-0.58 tiers); "Sign in" hit area padded to 44 pt min (`:110`) — good.
- **Missing features vs top-tier**: none critical for a hero; the social-proof chip is the authored equivalent.

### B2. Goal — "Why English?" (`OnboardingViews.swift` GoalView)
- **Visual**: paper backdrop (`AUPaper`), step meter (1 of 2), 4 `SelectableRow`s with authored stroke icons in tinted circles; selection wash is delightful (`AUSelectSurface`).
- **UX**: "Pick up to two" enforced; Continue disabled until ≥1. Back → welcome.
- **Missing states**: multi-select cap (2) communicated only in copy — no state change when the cap is hit; feedback is subtle.
- **Accessibility**: rows have `.isSelected` traits (`Shared.swift:770`); step meter is visual only — no "Step 1 of 2" VoiceOver announcement.
- **Missing features**: goal→content personalization is authored intent ("it changes what we put in front of you first") but nothing downstream consumes `goals` beyond storage — `UNVERIFIED — needs human input` on scope.

### B3. Commit — reminder choice (`OnboardingViews.swift` CommitView)
- **Visual/UX**: lesson-shape explanation card, 4 reminder chips (07:30/12:30/19:30/None) as selectable rows; Continue → plan.
- **Missing**: the chosen reminder time is stored but **no notification can ever fire** (no UserNotifications import — see B18). The choice has no consequence; an honest app should wire it or reframe the copy.
- **Accessibility**: same as B2 — chips have selected traits, no announced step.

### B4. Plan (`OnboardingViews.swift` PlanView)
- **Visual**: PlanDusk backdrop, 3 glass plan rows (Today / Each lesson / Chapter), "Start your first lesson" CTA + "See the whole ladder" link.
- **UX**: good summary rhythm; ladder link gives a peek at the future.
- **Missing**: the plan is ephemeral — no way to revisit it after first run.
- **Accessibility**: dusk-cream opacity 0.62 over art — same unverified contrast tier as Welcome.

### B5. Login (`LoginView.swift`)
- **Visual**: 33 pt Caprasimo "Welcome back.", glass fields, error card (icon + message), Apple/Google ghost buttons.
- **UX**: inline validation error from router (`loginErr`, `AppRouter.swift:745-755`); email regex + 6-char password minimum; sign-in is local-only (no real auth backend — v1 scope).
- **Issues**: **"Forgot password" is dead text** — `Text`, not a Button, styled like an accent link (`LoginView.swift:61-67`); tapping does nothing. S2.
- **Missing states**: no loading state on Sign in (instant local check); no password visibility toggle; no keyboard return-key flow between fields.
- **Accessibility**: error is plain text — not announced assertively; "Show password" absent.
- **Missing features vs top-tier**: real auth / account recovery — out of scope for the design phase; the dead link is the fixable defect.


### B6. Home (`HomeView.swift`)
- **Visual**: chapter header with mono wordmark + settings ring, pending-resume `ACard`, day-arc card (`ArcSkyView` travelling sun + streak row + dawn/sundown rows + "One more, for the pleasure of it"), winding lesson path with 5 authored stops and serpentine thread, next-chapter paywall card, floating glass tab bar.
- **UX (strengths)**: the day-arc is a distinctive, on-brand progress metaphor; the resume card is exactly the right friction reduction; "One more" is charming.
- **Issues**:
  - Path stops use **fixed design coordinates** (132/274/124/268/136 × 46/152/266/374/492, `HomeView.swift:486-506`) with a uniform width scale — labels are absolutely positioned; Dynamic Type growth can collide with stop circles (right-aligned labels 128–150 pt wide at fixed widths, `:488-505`). S2 risk at AX sizes.
  - Bottom padding 160 pt clearance (`HomeView.swift:24`) is hand-tuned to 402×874-class devices.
  - Locked stop tap → paywall (`HomeView.swift:480`) — right economics; affordance relies on lock icon + "Opens after …" meta alone.
- **Missing states**: none structural; no time-of-day greeting (the arc already encodes time — could lean in).
- **Accessibility**: path stops are buttons with labels + state metas; VoiceOver order follows layout (labels interleaved with stops) — likely confusing without grouping. UNVERIFIED (needs on-device AX pass).
- **Missing features vs top-tier**: scroll-linked arc animation (sun travelling as you scroll); whole-path overview affordance.

### B7. Course — player chrome (`CoursePlayerView.swift`)
- **Visual**: close button + "Ch 1 · L1 <title>" crumb + lesson progress capsule + sid chip (unbound mode); player body on paper background.
- **Issues**:
  - `minHeight: 790` fixed (`CoursePlayerView.swift:166`) — the authored 402×874 canvas; shorter devices compress poorly, taller ones show dead space. S2.
  - Close saves resume silently — matches the calm ethos, but no transition or haptic marks the save.
  - Screen swaps are instant; only the progress capsule animates (`.easeInOut(0.3)` on `model.p`, `:75`).
- **Missing states**: "Loading course…" is a bare centered `Text` (`:139-143`) — no skeleton, no authored treatment. S3.
- **Accessibility**: no "Lesson 1, screen 5 of 40" announcement on advance; back button labeled; sid chip correctly hidden in bound (production) mode.
- **Missing features vs top-tier**: polish-level only (transitions, progress announcements).

### B8. Lesson — quick practice runner (`QuickPracticeViews.swift` LessonRunnerView)
- **Visual**: capsule progress rail + counter, item body, floating glass verdict dock (ultraThin + gradient, rounded top corners).
- **UX**: auto-advance after correct answers; verdict dock shows check/cross + `ok/no` copy; retry ladder honored.
- **Issues**:
  - Result view carries fixed `minHeight: 874` (`QuickPracticeViews.swift:897`) — same device-assumption family. S2.
  - Verdict dock appears/disappears without animation — abrupt state swap. S3 (motion gap).
  - No haptic on correct/incorrect — the moment that most deserves feedback is silent (systemic A.5 finding, most acute here).
- **Missing states**: no "review-mode" badge when running the mistake queue (copy covers it after the fact on Result).
- **Accessibility**: option rows are buttons; verdicts are not asserted to VoiceOver.

### B9. Result (`QuickPracticeViews.swift` ResultView)
- **Visual**: rays + ambient orbs + contour backdrop, verdict headline ("Cleanly done." / "A start is a start."), settled/review lists, week dots, 3 stat tiles, primary "Practice again" + ghost "Home".
- **Issues**:
  - **Week dots hard-code the first dot as done** (`i == 0` gradient, `QuickPracticeViews.swift:914-941`) regardless of actual weekday or completion — a prototype artifact rendering wrong data. S1 (wrong content).
  - Minutes/stats derive from session counters, not persisted history — acceptable for v1.
- **Missing states**: none (this is the success state).
- **Accessibility**: week dots decorative without legend; stat tiles' grouping UNVERIFIED.
- **Missing features vs top-tier**: a calm "share progress" affordance could live here; optional.


### B10. Streak (`StreakBoardViews.swift` StreakView)
- **Visual**: 96 pt Caprasimo numeral in accent, week dots, month grid, "Best"/"Rest days left" split stats, non-punitive rule copy.
- **Issues**:
  - **"Since 15 August" is hard-coded** (`StreakBoardViews.swift:26`) — a prototype seed date, not the learner's real start date. S1 (wrong content).
  - **"Best 47" is hard-coded** when `baseLessons > 0` (`:48`) — fake statistic. S1.
  - Month grid and week dots derive from the streak engine but are not per-day verified — UNVERIFIED (needs day-log testing).
- **Missing states**: none.
- **Accessibility**: numeral + label reading is implicit; month cells not buttons (fine).
- **Missing features vs top-tier**: milestone moments (e.g. 7-day mark) are described in Settings copy ("When you pass something worth naming") but no milestone celebration exists anywhere. Calm-appropriate version needed.

### B11. Leaderboard — Cedar Group (`StreakBoardViews.swift` LeaderboardView)
- **Visual**: rules card first ("Words retained this week, nothing else…"), my-row highlight, rank/score list, invite + leave/rejoin.
- **Issues**:
  - Board data is a **local mock** (BOARD_ALL fixtures; `boardStory` hard-codes "12/18 words to next rank", `:410-414`). Fine for v1 demo, must be labeled or wired before shipping. S2.
  - No empty state beyond rules; no loading state (instant mock).
- **Accessibility**: rows combine rank + avatar initial + name + score; grouping exists on rows; my-row highlight is color-only (no `accessibilityValue` "you"). S3.
- **Missing features vs top-tier**: none — by design this is deliberately subordinate.

### B12. Stories — Practice hub (`PracticeHubViews.swift` StoriesView)
- **Visual**: "Practice" title, two filled hub rows (Scenes, Say it aloud), quiet row (Review mistakes), "Stories" section with 4 authored reading rows + provenance note.
- **UX**: hierarchy is calm and scannable; sub-labels carry live state ("3 waiting", "In progress — <title>").
- **Issues**: hub rows have no `auStagger` choreography (static list) — inconsistent with onboarding's staged reveals. S3.
- **Missing states**: none (review empty state handled: "Empty — nothing has slipped yet", `:48-49`).
- **Accessibility**: rows are buttons; combined text is read together. Good.
- **Missing features vs top-tier**: none; scope is authored-content-bound by governance.

### B13. Scene (`PracticeHubViews.swift` SceneView)
- **Visual**: solo/duo toggle, turn-by-turn dialogue with reply chips, TTS playback per turn.
- **UX**: reply pick advances after 640 ms (`AppRouter.swift:653-667`) — snappy; replay resets; "Leave" returns to stories.
- **Issues**: turn advance has no animation (chips + bubble swap instantly). S3 motion gap.
- **Missing states**: none.
- **Accessibility**: reply chips are buttons; conversation history is a plain list — no per-turn announcement strategy. UNVERIFIED.

### B14. Speak — "Say this" (`PracticeHubViews.swift` SpeakView)
- **Visual**: 3-take meter, native card with waveform, your-take card with waveform, verdict card, type-instead fallback.
- **Issues**:
  - **The verdict is a mock**: `speakVerdict = speakTake >= 2 ? "clear" : "near"` (`AppRouter.swift:698-704`) — take-count based, not speech analysis; `SpeechToText` service exists but is referenced nowhere outside `Services.swift` (grep verified). The **first take always renders "near" in error-red styling** (`SpeakView.swift:536-537,662-697`) — punishing feedback for an unmeasured attempt, and it contradicts the product's own no-shaming governance. S1 (broken promise in UI) + honesty defect.
  - Waveform heights are `sin()`-based dummies (`speakWaveHeights`, `:516-531`) — cosmetic stand-in; acceptable if styled honestly, but the UI presents them as if measured.
  - The honest disclosure lives in tiny ctx text ("no recording exists yet", `:506`) — easy to miss.

### B16. Progress (`ProgressProfileSettingsPaywall.swift` ProgressView)
- **Visual**: kicker row, "Progress" title, stat pair, 8-week chart, 5 skill rows with mastery fills + weakest callout, A1–C1 ladder with "Not written yet" locks.
- **Issues**:
  - **"Since 15 August" and "Last practised Thursday" are hard-coded** (`:65,72`) — prototype artifacts. S1 (wrong content).
  - Skill numbers are synthetic formulas (`lessonsDone * 8` etc., `:25-55`), not tracked reality. S2 — must be derived from real `LessonRecord` data.
  - 8-week chart data provenance UNVERIFIED (likely static).
- **Missing states**: "Nothing practised yet" handled in the kicker (`:72`).
- **Accessibility**: skill rows are buttons (Speaking → speak, Conversation → scene, else practice) — good; chart not described to VoiceOver. S3.
- **Missing features vs top-tier**: none major; the weakest-skill callout is genuinely good UX.

### B17. Profile (`ProgressProfileSettingsPaywall.swift` ProfileView)
- **Visual**: avatar disc + name + edit, 3 stats, subscription card (Free/Pro states), settings list, milestones section.
- **Issues**: milestones list is static copy; avatar is a disc with initial (no image picker). Acceptable v1.
- **Missing states**: signed-out variant — UNVERIFIED.
- **Accessibility**: rows labeled; edit affordances adequate.
- **Missing features vs top-tier**: none required by governance.

### B18. Settings (`ProgressProfileSettingsPaywall.swift` SettingsView)
- **Visual**: section labels + grouped cards, authored switch style, widget preview row, text-size slider with live label, appearance segmented control, account section with sign out + delete.
- **Issues**:
  - **Four dead toggles**: Haptics (`:681-683`) and Sound (`:680`) read preferences that no code consumes; all four notification toggles (Dawn/Sundown/Milestones/Cedar Group, `:694-715`) persist without any UserNotifications wiring. S2 ×4.
  - "Daily reminder — One, at 19:30" shows the onboarding-chosen time but is not adjustable here (no time picker). S3.
  - Widget preview promises a Home-Screen widget that does not exist (no extension target, `project.yml`). Honest label, missing product. S2.
- **Missing states**: none.
- **Accessibility**: switch rows labeled; slider has no value announcement. S3.
- **Missing features vs top-tier**: none beyond the dead controls (fix is wiring, not new UI).

### B19. Paywall (`ProgressProfileSettingsPaywall.swift` PaywallView)
- **Visual**: dusk sun art, "Continue with Chapters 2–4." value prop, feature list, annual/monthly plan cards at "App Store price", restore link, no-trial disclosure.
- **Issues**:
  - **No StoreKit** — "Start subscribe" flips `pro = true` locally (`AppRouter.swift:724-732`). The screen promises a transaction the app cannot perform. S1 for shipping honesty.
  - Price is honestly absent (by design — App Store supplies it), but with no StoreKit there is nothing to supply it.
- **Missing states**: purchase failure / pending / restore-failure states nonexistent (no transaction layer). S2.
- **Accessibility**: plan cards selectable with traits; restore is a link button.
- **Missing features vs top-tier**: subscription-management deep-link absent. S3.

### B20. SubscribeAccount (`ProgressProfileSettingsPaywall.swift` SubscribeAccountView)
- **Visual**: dusk variant, fields inline-styled (not the `AUTextField` glass treatment used on Login — `:1337-1382`), CTA + StoreKit-legality footnote.
- **Issues**: field styling inconsistency vs Login (hand-rolled plainer fields). S3 consistency.

## Part B (cont.) — Course-player screen families

### B21. Core screens (`CoreScreens.swift`: promise/hook/orientation/pause/cards/letterCards/numbers/alphabet)
- **Promise**: full-bleed stripe illustration slot (392 pt), "New words today", can-do rings, tap-anywhere advance with `PingDot` — the tap-anywhere region is the whole column (`:73-74`), generous. Stagger choreography present (`:49`). **Issue**: the first impression of every lesson is a placeholder stripe field — the app's most repetitive unfinished-feeling surface. S2 (asset gap; the placeholder's own art direction is improvable).
- **Pause**: authored "natural pause halfway" card. Good rhythm.
- **Cards/letterCards/numbers**: carousel with audio play buttons, `WaveForm` on listen buttons, rings progress. Motion present.
- **Alphabet**: A–Z grid + sound-families list with ear icons. Dense but organized.

### B22. Practice renderer (`PracticeScreen.swift`: practice/quiz/testlet/warmup/reading)
- **Strengths**: the retry ladder (miss → Hint 1 → Hint 2 → reveal) is implemented with dashed hint cards (`:536-559`); item progress rail animates; ok/no verdict cards colored correctly; the confusable chip ("Feel it:") is a lovely authored touch.
- **Issues**:
  - **S2-011 (open)**: order-item hints never surface — authored hints for 10/15 order items are invisible (`qa/defects.md:71`). S2.
  - Verdict card + hint ladder appear without transition animation. S3.
  - No haptic on verdict (systemic A.5) — most acute here.
  - Choice-item pick state before check: UNVERIFIED (may lack a temporary selected state).
- **Missing states**: none (retry ladder covers remediation inline).
- **Accessibility**: verdict not announced; "1 / 6" counter visual only.

### B23. Assembly screens (`AssemblyScreens.swift`: order/tiles/emailAssembly/substitution/missionBrief/roleplay)
- **Order**: numbered rows with picked-order circles; "Undo all" + Go on; demo chips for the alphabetical warm-up.
- **Tiles**: sentence assembly with `CompactFlowChips`; punctuation joining rules ported (ServicesTests).
- **Roleplay**: turn counter, tile groups, feedback card after turn 2, "Safe stop" + Speak — the dual path (speak or tap) honors governance.
- **Issues**: tile pick/unpick has no animation; "Undo all" has no haptic. S3 motion.
- **Accessibility**: tiles are buttons with labels; order numbers visual.

### B24. Language screens (`LangScreens.swift`: review/grammarModel/pronPerceive/pronProduce/conversation)
- **Review**: rings, checklist lines, word gallery grid, audio chips — compact and complete.
- **Grammar**: tables + model sentences; dense but typographically organized.
- **Pron pair**: perceive (minimal pairs, ear buttons) and produce (waveform + take meter + slow toggle) — produce scoring shares the mock-verdict limitation (B14). UNVERIFIED whether it uses `SpeechToText`.
- **Conversation**: turn rows with speaker tags, branching read-back card, lock note.
- **Issues**: same systemic gaps — no haptics, instant state swaps, 0.34–0.42-opacity meta text contrast unverified.

### B25. Assess screens (`AssessScreens.swift`: pending/quizIntro/results/remediation/reviewPlan/chapterMap)
- **QuizIntro**: rules card before the chapter quiz — good expectation-setting.
- **Results/Remediation/ReviewPlan**: outcome breakdown, restudy list, review schedule. The authored assessReview screen is implemented (S1-002 fix).
- **ChapterMap**: ladder with done/next/locked rows + "Next:" dashed card.
- **Pending**: the honest stub — "Awaiting course content" + planned list + source citation. Governance-correct.
- **Issues**: none structural; share the systemic gaps.

### B26. Cross-cutting findings (app-wide)
1. **Zero haptics** despite the authored toggle (A.5) — S2, systemic.
2. **No StoreKit, no UserNotifications, no sound design** — Settings promises unwired (B18/B19). S1/S2.
3. **Fixed 402×874 geometry**: `minHeight: 874/790`, absolute path coordinates, edge-measured insets with `ignoresSafeArea` (`RootView.swift:31-41`). Dynamic Type at AX sizes + shorter devices are the stress cases. S2.
4. **Static data posing as live**: week dots (B9), streak dates (B10/B16), due labels (B15), leaderboard (B11), speak verdict (B14). S1 where it misleads.

## Part C — Diagnosis: what reads "generic" vs "premium" today

**Already premium (protect, do not regress):**
1. A genuinely distinctive identity: paper-and-dusk palette, Caprasimo display voice, authored microcopy ("A start is a start.", "One more, for the pleasure of it.") — most learning apps have none of this.
2. Distinctive compositions: the day-arc with travelling sun, the winding lesson path, the glass floating tab bar, honest stripe placeholders carrying alt text.
3. A rigorous, tested token system (`DesignTokenTests` gates every color against the CSS export).
4. Principled UX: retry ladder, non-punitive streak with rest days, dual tap/speak paths, honest stubs, resume card.

**What makes it feel unfinished rather than premium (in priority order):**
1. **The senses are silent**: no haptics, no sound, no choreographed motion at the moments that matter (verdicts, completion, streak milestones). The app is beautiful to look at and inert to touch. This is the single largest premium-app delta — award-caliber apps are felt, not just seen.
2. **Placeholder illustration everywhere**: the first screen of every lesson is a candy-stripe box. Even honest placeholders can be art-directed into a brand asset (current stripes read as wireframe).
3. **Fake-data leaks**: hard-coded dates, static week dots, mock verdicts, mock leaderboard — small lies that break trust once noticed.
4. **Instant, unexplained state changes**: verdicts, docks, hint ladders, and scene turns pop in with no transition; no sense of continuity between screens (single fade only).
5. **Missing first-touch and last-touch moments**: blank launch screen, empty app icon, no completion ritual beyond the Result copy.
6. **Dead controls**: five Settings toggles and a "Forgot password" link that do nothing.
7. **Device rigidity**: layouts tuned to one canvas size; Dynamic Type stress untested.

**Conclusion**: the app has an unusually strong design foundation (identity, tokens, principles) and suffers almost entirely from *execution-depth* gaps — feedback (haptics/sound/motion), data honesty, state craft, and asset polish — rather than taste problems. The transformation should therefore be an execution-depth program, not a rebrand. This matches the owner's "Evolve the language" decision.

5. **Entrance choreography inconsistency**: staggered reveals on onboarding only; every other screen pops in with one fade. S3.
6. **No app icon, blank launch screen** (S3-001) — first-touch brand moment missing.
7. **Illustration placeholders across all 115 player screens** — the dominant "unfinished" signal; placeholder art direction can be elevated without violating the honesty rule (ID + alt contract stays).
8. **No loading skeletons**; the "Loading course…" text is bare.
9. **VoiceOver announcements** for progress/verdicts/steps are not implemented (36 label call sites exist, no assertion strategy). UNVERIFIED overall — needs an on-device audit pass.
10. **Contrast debt**: 0.4–0.6-opacity text tiers and dusk-art overlays unmeasured (only flat tokens measured, `qa/evidence/token-contrast.json`).

- **Missing states**: field-level validation errors absent; no confirm-password.
- **Accessibility**: fields labeled with adjacent text labels — good; error announcement absent.

- **Missing states**: mic permission denied state absent (Info.plist has usage strings; no denial UI). S2.
- **Accessibility**: verdict card content read; take meter visual only.

### B15. Review — "Loose ends" (`PracticeHubViews.swift` ReviewView)
- **Visual**: intro copy, due-grouped mistake cards (kind + source + due label + hint/why note), primary "Practise N items".
- **UX**: the 1/3/7/14/30-day ladder is real (`Services.swift` ReviewScheduler); empty state has personality ("Nothing loose. The first slips go here.").
- **Issues**: due labels in `reviewCard` are positional guesses (`k == 0 ? "Due tomorrow" : …`, `:916`) — not the scheduler's real dates. S2 (wrong content).
- **Missing states**: none.
- **Accessibility**: cards combined. Good.
- **Missing features vs top-tier**: none — this screen is ahead of typical competitors conceptually.
