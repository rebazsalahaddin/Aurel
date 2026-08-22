# Aurel — Screen Inventory (Phase 1.1)

> Source of truth for the UI/UX transformation. Every screen, flow, modal, banner, state, and reusable component in the app, enumerated with file citations. Router screens are the `AppRouter.Screen` enum (`Aurel/App/AppRouter.swift:17-23`); the player renders 31 authored screen payload types (`Aurel/Course/Models/ScreenPayloads.swift:15-21`).

## 1. Router screens (the shell state machine — 20 screens)

| # | Screen name | Purpose | File / route | Type |
|---|---|---|---|---|
| 1 | Welcome | Night-sky dusk hero: "English, unhurried." → Begin the path / Sign in. Chip: "Chapter One free, no account" | `Aurel/Features/Onboarding/WelcomeView.swift` (`welcome`) | Screen (full-bleed art) |
| 2 | Goal — "Why English?" (step 1 of 2) | Pick up to two learning goals (work / travel / exam / myself); shapes which examples surface first | `Aurel/Features/Onboarding/OnboardingViews.swift` — `GoalView` (`goal`) | Screen (scroll) |
| 3 | Commit — "A focused lesson, with a pause halfway" (step 2 of 2) | States the ≈20-min lesson shape; choose daily reminder time (07:30 / 12:30 / 19:30 / none) | `Aurel/Features/Onboarding/OnboardingViews.swift` — `CommitView` (`commit`) | Screen (scroll) |
| 4 | Plan — "Your plan" | Dusk-toned summary: today's lesson, per-lesson rule, the chapter ahead → first lesson | `Aurel/Features/Onboarding/OnboardingViews.swift` — `PlanView` (`plan`) | Screen (dusk art + scroll) |
| 5 | Login — "Welcome back." | Email + password, inline validation error, forgot-password link, Apple/Google ghost buttons, new-here link | `Aurel/Features/Login/LoginView.swift` (`login`) | Screen (scroll + form) |
| 6 | Home — Learn (tab 1) | Chapter header, pending-resume card, day-arc card (lesson + recall halves), winding lesson path (5 stops), next-chapter paywall card | `Aurel/Features/Home/HomeView.swift` (`home`) | Screen (scroll + tabs) |
| 7 | Course — Lesson runner | The authored A1 lesson: 31 step types (§2 below), progress rail, close-with-resume | `Aurel/Course/Player/CoursePlayerView.swift` + `Screens/*.swift` (`course`) | Screen (player chrome) |
| 8 | Lesson — Quick practice runner | Short mixed drill: flash, choice, match, listen, pattern, order items; verdict dock; auto-advance | `Aurel/Features/QuickPractice/QuickPracticeViews.swift` — `LessonRunnerView` (`lesson`) | Screen (runner + dock) |
| 9 | Result — Lesson result | Minutes, "what settled / what to review", week dots, stat tiles, practice-again | `Aurel/Features/QuickPractice/QuickPracticeViews.swift` — `ResultView` (`result`) | Screen (stats) |
| 10 | Streak — "The arc" | Week dots, month view, rest-day rule ("two rest days a month are built in"), huge streak numeral | `Aurel/Features/PracticeHub/StreakBoardViews.swift` — `StreakView` (`streak`) | Screen (stats) |
| 11 | Leaderboard — Cedar Group | Opt-in cohort of 30, rules explainer, leave/rejoin, invite; reached from Progress — never above learning | `Aurel/Features/PracticeHub/StreakBoardViews.swift` — `LeaderboardView` (`leaderboard`) | Screen (list + tabs) |
| 12 | Stories — Practice (tab 2) | Hub: Scenes, Say it aloud, Review mistakes + four authored reading texts | `Aurel/Features/PracticeHub/PracticeHubViews.swift` — `StoriesView` (`stories`) | Screen (hub list + tabs) |
| 13 | Scene — two-role dialogue | Solo or pass-the-phone; pick your reply each turn, hear it back; replay | `Aurel/Features/PracticeHub/PracticeHubViews.swift` — `SceneView` (`scene`) | Screen (dialogue runner) |
| 14 | Speak — "Say this" | Speak a line (2.6 s take window), native/slow playback, verdict (near/clear), type-instead fallback | `Aurel/Features/PracticeHub/PracticeHubViews.swift` — `SayView` (`speak`) | Screen (recording UI) |
| 15 | Review — "Loose ends" | Spaced-retrieval mistake queue with due dates (1/3/7/14/30-day ladder); empty state "Nothing loose." | `Aurel/Features/PracticeHub/PracticeHubViews.swift` — `ReviewView` (`review`) | Screen (queue list) |
| 16 | Progress (tab 3) | Words retained, minutes total, 8-week chart, 5 skill rows with mastery states, A1–C1 ladder (A2+ "Not written yet") | `Aurel/Features/Progress/ProgressProfileSettingsPaywall.swift` — `ProgressView` (`progress`) | Screen (stats + tabs) |
| 17 | Profile — You (tab 4) | Identity header + edit, three stats, subscription card, settings list, milestones | `Aurel/Features/Progress/ProgressProfileSettingsPaywall.swift` — `ProfileView` (`profile`) | Screen (list + tabs) |
| 18 | Settings | Daily rhythm, notifications, Home-Screen widget, Cedar Group toggle, text size, appearance, account (sign out + delete) | `Aurel/Features/Progress/ProgressProfileSettingsPaywall.swift` — `SettingsView` (`settings`) | Screen (form/list) |
| 19 | Paywall — Aurel Pro | "Continue with Chapters 2–4." Annual/monthly at App Store price, restore purchase, no trial, dusk sun art | `Aurel/Features/Progress/ProgressProfileSettingsPaywall.swift` — `PaywallView` (`paywall`) | Screen (marketing) |
| 20 | SubscribeAccount — Create your account | Email + password required before purchase/restore; Chapter 1 progress carries over | `Aurel/Features/Progress/ProgressProfileSettingsPaywall.swift` — `SubscribeAccountView` (`subscribeAccount`) | Screen (form) |

### Tab-bar surfaces
`AUTabBar` (glass floating bar, `Aurel/DesignSystem/Components/Shared.swift:602`) shows on: home, stories, progress, profile, leaderboard (`AppRouter.Screen.showsTabs`, `AppRouter.swift:25-30`). Tabs: Learn · Practice · Progress · You.


## 2. Course-player screen types (31 payload types → 24 views)

Rendered inside `PlayerChrome` (`Aurel/Course/Player/CoursePlayerView.swift:41-145`); dispatch at `CoursePlayerView.swift:113-144`. 115 authored screens across chapters 1–3 (CourseDecodingTests: 40/43/32).

| # | Payload type | View | File | Purpose |
|---|---|---|---|---|
| 1 | `promise` | `PromiseScreenView` | `Screens/CoreScreens.swift:10` | Lesson opener: full-bleed illustration slot, "New words today", can-do checklist, tap-anywhere advance |
| 2 | `hook` | `HookScreenView` | `Screens/CoreScreens.swift:80` | "This chapter" lead-in framing |
| 3 | `orientation` | `OrientationScreenView` | `Screens/CoreScreens.swift` | Lesson orientation text |
| 4 | `pause` | `PauseScreenView` | `Screens/CoreScreens.swift` | Halfway pause ("a natural pause halfway") |
| 5 | `cards` | `CardsScreenView` | `Screens/CoreScreens.swift` | Vocabulary card carousel |
| 6 | `letterCards` | `CardsScreenView` (shared) | `Screens/CoreScreens.swift` | Letter-card variant |
| 7 | `numbers` | `CardsScreenView` (shared) | `Screens/CoreScreens.swift` | Number-card variant |
| 8 | `alphabet` | `AlphabetScreenView` | `Screens/CoreScreens.swift` | A–Z chart with sound families |
| 9 | `warmup` | `PracticeScreenView` (shared) | `Screens/PracticeScreen.swift:8` | Warm-up drill items |
| 10 | `grammarModel` | `GrammarScreenView` | `Screens/LangScreens.swift` | Grammar model presentation (tables, examples) |
| 11 | `practice` | `PracticeScreenView` | `Screens/PracticeScreen.swift:8` | The 6-item-shape drill renderer (flash/choice/match/listen/pattern/order) with retry ladder |
| 12 | `substitution` | `SubstitutionScreenView` | `Screens/AssemblyScreens.swift` | Substitution table practice |
| 13 | `testlet` | `PracticeScreenView` (shared) | `Screens/PracticeScreen.swift` | Grouped assessment rung with digit strip |
| 14 | `tiles` | `TilesScreenView` | `Screens/AssemblyScreens.swift` | Tap word tiles into a sentence |
| 15 | `order` | `OrderScreenView` | `Screens/AssemblyScreens.swift:10` | Numbered ordering task + Undo all |
| 16 | `reading` | `PracticeScreenView` (shared) | `Screens/PracticeScreen.swift` | Authored reading text + comprehension |
| 17 | `emailAssembly` | `TilesScreenView` (shared) | `Screens/AssemblyScreens.swift` | Assemble an email from tiles |
| 18 | `conversation` | `ConversationScreenView` | `Screens/LangScreens.swift` | Scripted dialogue with branching read-back |
| 19 | `roleplay` | `RoleplayScreenView` | `Screens/AssemblyScreens.swift` | Two-part roleplay with tile groups + feedback |
| 20 | `missionBrief` | `MissionScreenView` | `Screens/AssemblyScreens.swift` | Speaking-mission briefing card |
| 21 | `pronPerceive` | `PronPerceiveScreenView` | `Screens/LangScreens.swift` | Minimal-pair perception drill |
| 22 | `pronProduce` | `PronProduceScreenView` | `Screens/LangScreens.swift` | Production drill with waveform + take meter |
| 23 | `quizIntro` | `QuizIntroScreenView` | `Screens/AssessScreens.swift` | Chapter-quiz rules introduction |
| 24 | `quiz` | `PracticeScreenView` (shared) | `Screens/PracticeScreen.swift` | Chapter quiz items (Form A = 22 items) |
| 25 | `results` | `ResultsScreenView` | `Screens/AssessScreens.swift` | Quiz outcome breakdown |
| 26 | `remediation` | `RemediationScreenView` | `Screens/AssessScreens.swift` | What to restudy |
| 27 | `reviewPlan` | `ReviewPlanScreenView` | `Screens/AssessScreens.swift` | Post-quiz review scheduling plan |
| 28 | `review` | `ReviewScreenView` | `Screens/LangScreens.swift:10` | Compact lesson-end review (rings, lines, word gallery) |
| 29 | `chapterMap` | `ChapterMapScreenView` | `Screens/AssessScreens.swift` | Chapter ladder map (done/next/locked) |
| 30 | `pending` | `PendingScreenView` | `Screens/AssessScreens.swift:10` | Honest "awaiting course content" stub (placement) |
| 31 | `unknown` | Fallback `Text("Loading course…")` | `CoursePlayerView.swift:139` | Decode-failure guard |

## 3. Cross-cutting states, banners, and overlays

| Item | Purpose | File | Trigger |
|---|---|---|---|
| `OfflineBanner` | "Working offline — today's lesson is already here" glass banner | `Shared.swift:716`, mounted in `HomeView.swift:28-36` | `Connectivity.isOnline == false` (NWPathMonitor → Combine, `Services.swift`) |
| Resume card ("Pick up where you stopped?") | Mid-lesson close stores position; resume/start-over offered on Home | `HomeView.swift` `pendingCard` (router `pending: PendingSpot`, `AppRouter.swift:129-134`) | `leaveCourse()` with lesson incomplete |

## 4. Reusable components (design-system inventory)

### Foundations
| Component | File | Notes |
|---|---|---|
| `Palette` (base roles + neutral/accent/accent-2 ramps, light+dark) | `DesignTokens.swift:86-122` | Adaptive UIColors via dynamic providers |
| `AUColorTokens` (`--au-*` layer: glow, hi, edge, fill, err/ok/tint/flat/dune pairs) | `DesignTokens.swift:132-237` | 21 semantic tokens |
| `AUSceneArt` (theme-fixed dusk/sun art colors) | `DesignTokens.swift:367-384` | Centralized scene-art literals (S2-003 fix) |
| `AUGradients` (sky, glass 158°, primaryButton, angled) | `DesignTokens.swift:245-322` | CSS-exact gradient ports |
| `AUSpace` (s1–s8: 4.4…35.2) / `AURadius` (sm 8 … pill 999) | `DesignTokens.swift:63-80` | Spacing + radii scales |
| Shadow modifiers `auLift/auSoft/auShadowSm/Md/Lg` | `DesignTokens.swift:326-355` | CSS approximations |
| `Typography`: `Figtree` + `Caprasimo` helpers, `AUTypeScale` (5 steps), `AUHeading`, `AUParagraph` | `Typography.swift:33-276` | Variable-font weight resolution + cached |

### Controls & containers
| Component | File | Notes |
|---|---|---|
| `ATapButtonStyle` (`.auTap`) | `Components.swift:10` | Press: scale 0.972 + opacity 0.92, spring 0.22/0.7 |
| `APillButton` (primary/ghost/quiet/dashed × compact/player) | `Components.swift:27` | The system button |
| `AUKeyButton` | `Components.swift:236` | The welcome "Begin the path" key treatment |
| `AUBrandMark` (Apple/Google) | `Components.swift:150` | Sign-in glyph marks |
| `ACard` | `Components.swift:380` | Fill + edge hairline + lift |
| `ATag` (ok/flat/tint) | `Components.swift:406` | Micro-caps badge |
| `IllustrationPlaceholder` + `StripeField` | `Components.swift:836` | Honest striped ILL slot + alt caption |
| `WordSheetView` | `Components.swift:269` | Vocabulary detail card |
| `SelectableRow` + `AUSelectSurface` | `Shared.swift:742-817` | Selected-state row (goal/commit/chips) |
| `AUField` / `AUTextField` | `LoginView.swift:142-201` | Glass form inputs |
| `AuthoredSwitch` | `ProgressProfileSettingsPaywall.swift:924` | Settings toggle |
| `WidgetPreview` | `ProgressProfileSettingsPaywall.swift:953` | Home-Screen widget mock |
| `CompactFlowChips` | `PracticeScreen.swift:988` | Word tile chips (order/roleplay/substitution) |
| `PlaceholderFrame` | `AssessScreens.swift:90` | "Specified, not yet authored" frame |
| `WaveForm` / `PingRingStroke` / `PingDot` | `CoreScreens.swift:774-825`, `Components.swift:497` | Audio affordances |

### Art & ambience
| Component | File | Notes |
|---|---|---|
| `WelcomeDusk` + `SunRise` + `AUStars` + `AUGlint` | `Shared.swift:71-348` | The night-sky hero (twinkling stars, rising sun) |
| `WelcomeDuneField` / `DuneSilhouette` | `Shared.swift:349-455` | Dune landscape art |
| `PlanDusk` | `Shared.swift:457` | Onboarding plan backdrop |
| `AUPaper` / `AURays` / `AmbientOrbs` / `AUContour` | `Components.swift:575-785` | Paper texture + ambient washes |
| `ArcSkyView` (day arc + travelling sun) | `ArcSkyView.swift:39` | Home day-arc card art |
| `LessonPathNode` / `WindingPathShape` | `ArcSkyView.swift:213`, `HomeView.swift:512` | The lesson path stops + serpentine thread |
| `WeekDots` | `ArcSkyView.swift:357` | Streak week dots |
| `AULogoMark` / `AUWordmarkRow` / `StepHeader` | `Shared.swift:10-66, 564` | Brand + onboarding step meter |
| `AUTabBar` | `Shared.swift:602` | Glass floating tab bar |
| `SVGPathShape` + `AUIcon` (37 icon kinds) | `AUIcon.swift:10, 257` | Authored SVG paths rendered verbatim |
| `ScreenEntrance` / `StaggerItem` / `PopIn` | `Components.swift:444-494`, `ArcSkyView.swift:397` | Motion primitives |

## 5. Navigation flows

```
welcome → goal → commit → plan ──goStarter()──► course (C1L1, bound)
   └─► login ──sign-in──► home
welcome/goal/commit/plan back-chains return one step
home ⇄ settings (settingsSource remembers origin: home|profile)
home → course (bound runner; close → resume card)
home → paywall (locked lesson stop / next-chapter card)
home → streak (from day-arc card)
stories (tab) → scene / speak / review / lesson (reading via story rows)
progress (tab) → leaderboard / paywall / speak / scene
profile (tab) → settings / paywall / subscribeAccount
paywall → subscribeAccount (when no account) → home (pro unlocked)
lesson (quick practice) → result → home | lesson (again)
course → finishCourse() → result → home
```

Durable state writes through to SwiftData `LearnerProfile` (`AppRouter.swift:270-315`); session state (qi, sel, checked, attempt, built, sceneTurn…) is ephemeral, mirroring the prototype's `seedFor()`.

## 6. Out-of-app surfaces (for completeness)

| Surface | Status | Evidence |
|---|---|---|
| App icon | **Empty** AppIcon.appiconset (S3-001) | `Aurel/Support/Assets.xcassets/AppIcon.appiconset` |
| Launch screen | Bare `UILaunchScreen: {}` (blank) | `project.yml:40` |
| Home-Screen widget | Mock preview only in Settings — no widget extension target | `project.yml` (no extension target) |
| StoreKit / purchases | **Not wired** — `startSubscribe()` sets `pro = true` directly | `AppRouter.swift:724-755`; no `import StoreKit` anywhere |
| Push/local notifications | **Not wired** — toggles persist only | `ProgressProfileSettingsPaywall.swift:694-715`; no `UserNotifications` import |
| Haptics | **Not wired** — toggle persists only | `ProgressProfileSettingsPaywall.swift:681-683`; zero feedback-generator call sites |
| Illustrations | Candy-stripe placeholders with ILL IDs (by design, assets not yet commissioned) | `IllustrationPlaceholder` (`Components.swift:836`) |
| Audio | On-device TTS stand-in behind `AudioPlaying` (by design, recordings pending) | `Services.swift:11-54` |

| `StoreRecoveredBanner` | One-time banner after corrupt SwiftData store moved aside (progress reset) | `RootView.swift:115` | `AppSchema.openWithRecovery` (S1-003 fix) |
| `CourseRecoveryView` | Full-screen retry when course JSON fails to load | `RootView.swift:84` | `AppEnvironment.courseLoadFailed` (S1-004 fix) |
| TTS `Speaker` | On-device speech for all audio (`AudioPlaying` protocol, real recordings drop in later) | `Services.swift:11-54` | Every listen/say/scene item |
| Word sheet | Vocabulary detail: word, IPA, stress, function line, example frame; opens from word chips | `WordSheetView` (`Components.swift:269`), data `AppEnvironment.wordSheet` | Word chip tap |
| Seeded demo states | "day-one" (streak 0) vs "mid-journey" (streak 43, ch.2, subscribed) | Prototype fixtures; port simulates via `baseLessons` (`AppRouter.swift:146`) | Debug/test only |
| Dark mode | `.aurel-dark` token overrides; Settings → Appearance (system/light/dark, persisted) | `DesignTokens.swift:104-121`, `RootView.swift:73-79` | `themeMode` |
| Dynamic Type | Authored 5-step text-size zoom mapped to content-size categories, max-with-system | `Typography.swift:281-376`, `RootView.swift:50-58` | Settings text-size slider / system setting |
| Screen jump hook | `SIMCTL_CHILD_AUREL_SCREEN=<name>` / `-AUREL_TEST_START` for QA | `AppRouter.swift:200-213` | Debug/test only |
