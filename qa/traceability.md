# Aurel — traceability matrix (Phase 1)

Sources of truth: `design/` (Aurel.dc.html = app shell; CourseScreen.dc.html = player; course-c1/2/3.js = banks) and `english_course/` (content authority). Statuses: **mapped** (implemented + covered) · **stub-as-authored** (renders the authored honest stub) · **deferred-owner** (outside this run by owner decision) · **open-defect** (ledger ID).

## 1. Shell screens — design (24) → app

| # | `screen` | Design source (Aurel.dc.html) | App view | Status |
|---|---|---|---|---|
| 1 | welcome | 125 | `Features/Onboarding/WelcomeView.swift` | mapped (SmokeSuite t1) |
| 2 | goal | 181 | `Features/Onboarding/OnboardingViews.swift:GoalView` | mapped (SmokeSuite t1) |
| 3 | placement | 229 | `OnboardingViews.swift:PlacementView` | mapped (SmokeSuite t1) |
| 4 | assess | 295 | `OnboardingViews.swift:AssessStubView` | stub-as-authored (placement deferred by governance, DECISIONS.md) |
| 5 | assessReview | 349 | **not dispatched — `UnbuiltScreen` placeholder** (`App/RootView.swift`) | open-defect **S1-002** |
| 6 | commit | 257 | `OnboardingViews.swift:CommitView` | mapped (SmokeSuite t1) |
| 7 | plan | 377 | `OnboardingViews.swift:PlanView` | mapped (SmokeSuite t1) |
| 8 | login | 412 | `Features/Login/LoginView.swift` | mapped |
| 9 | home | 451 | `Features/Home/HomeView.swift` | mapped (SmokeSuite t1/t2, Milestone t1) |
| 10 | course | 636 → CourseScreen import | `Course/Player/CoursePlayerView.swift` | mapped (SmokeSuite t2, Milestone t1/t2) |
| 11 | lesson | 640 | `Features/QuickPractice/QuickPracticeViews.swift:LessonRunnerView` | mapped |
| 12 | result | 841 | `QuickPracticeViews.swift:ResultView` | mapped |
| 13 | streak | 887 | `Features/PracticeHub/StreakBoardViews.swift:StreakView` | mapped |
| 14 | leaderboard | 933 | `StreakBoardViews.swift:LeaderboardView` | mapped |
| 15 | stories (Practice hub) | 993 | `Features/PracticeHub/PracticeHubViews.swift:StoriesView` | mapped (SmokeSuite t4 tab matrix) |
| 16 | hunt | 1049 | `PracticeHubViews.swift:HuntStubView` | stub-as-authored |
| 17 | reader | 1075 | `PracticeHubViews.swift:ReaderStubView` | stub-as-authored |
| 18 | scene | 1101 | `PracticeHubViews.swift:SceneView` | mapped |
| 19 | speak | 1154 | `PracticeHubViews.swift:SpeakView` | mapped (SmokeSuite t3) |
| 20 | review | 1240 | `PracticeHubViews.swift:ReviewView` | mapped |
| 21 | progress | 1275 | `Features/Progress/…:ProgressView` | mapped (Milestone t4) |
| 22 | profile | 1337 | `…:ProfileView` | mapped (Milestone t4) |
| 23 | settings | 1402 | `…:SettingsView` | mapped (SmokeSuite t4, Milestone t3) |
| 24 | paywall | 1469 | `…:PaywallView` | mapped (Milestone t4) |

Overlays/states (not `screen` values): word-detail sheet (`sheetOpen`, 1519–1548) → `PracticeHubViews` word sheet — mapped; tab bar (1550) → `AUTabBar` — mapped; offline banner (453) → `OfflineBanner` — mapped; `course` sub-states starter/reviewMode/pending → `PlayerModel`/`AppRouter.pending` — mapped (SmokeSuite t2); text-size control (1455) → `SettingsView` typeStep — **open-defect S1-001** (control persists but drives nothing).

## 2. Player screen types — design (31, CourseScreen.dc.html dispatch :1339–1346) → app

| type | Design line | Renderer (`Course/Player/Screens/`) | Bank usage c1/c2/c3 | Status |
|---|---|---|---|---|
| promise | 96 | CoreScreens | 1/1/1 | mapped |
| hook | 120 | CoreScreens | 1/1/1 | mapped |
| orientation | 159 | CoreScreens | 1/1/1 | mapped |
| pause | 178 | CoreScreens | 1/1/1 | mapped |
| cards (+letterCards/numbers piggyback :1340) | 202 | CoreScreens | 5/6/5 | mapped |
| alphabet | 266 | CoreScreens | 2/1/1 | mapped |
| practice (+quiz/testlet/warmup/reading piggyback :1341) | 294 | PracticeScreen | 23/24/19 | mapped |
| pending | 554 | AssessScreens | 0/0/0 (C3's four replaced by the real quiz — owner decision 2) | mapped (renders authored lock copy) |
| review | 575 | LangScreens | 1/1/1 | mapped |
| grammarModel | 607 | LangScreens | 1/2/2 | mapped |
| pronPerceive | 685 | LangScreens | 1/1/0 | mapped |
| pronProduce | 722 | LangScreens | 1/1/0 | mapped |
| conversation | 753 | LangScreens | 1/1/1 | mapped |
| order | 800 | AssemblyScreens | 1/1/0 | mapped |
| tiles (+emailAssembly piggyback :1343) | 833 | AssemblyScreens | 2/2/1 | mapped |
| substitution | 886 | AssemblyScreens | 1/1/0 | mapped |
| missionBrief | 913 | AssemblyScreens | 1/1/1 | mapped |
| roleplay | 950 | AssemblyScreens | 1/1/1 | mapped |
| quizIntro | 1005 | AssessScreens | 1/1/1 (C3 via decision 2) | mapped |
| results | 1019 | AssessScreens | 1/1/1 (C3 via decision 2) | mapped |
| remediation | 1053 | AssessScreens | 1/1/1 (C3 via decision 2) | mapped |
| reviewPlan | 1077 | AssessScreens | 1/1/1 (C3 via decision 2) | mapped |
| chapterMap | 1108 | AssessScreens | 1/1/1 | mapped |
| nextLine | 1202 | (handled at :1341) | 0/0/0 — dead branch, no bank instance | backlog **S3-002** |

Screen totals: 40/43/34 = 117 shipped (CourseDecodingTests pins). `pending` screens in banks: 0 (post decision 2).

## 3. Content units — english_course → data → views

| Unit | english_course source | Data file | Shipped | Status |
|---|---|---|---|---|
| A1-C01 L01–L04 (incl. quiz Form A 22) | 04_A1_chapters/A1_C01/* | design/course-c1.js → a1-course.json | 4 lessons · 40 screens | mapped (CourseDecoding + ContentConformance*) |
| A1-C02 L01–L04 (quiz 26) | A1_C02/* | course-c2.js | 4 lessons · 43 screens | mapped |
| A1-C03 L01–L03 (quiz 32) | A1_C03/* | course-c3.js + exporter C3-closer step | 3 lessons · 34 screens | mapped (quiz per owner decision 2, `83be99c`) |
| A1-C04 L01–L03 (Checkpoint 1) | A1_C04/* (complete, QA-passed) | **no design bank** | absent | **deferred-owner** (decision 1) |
| A1-C05 L01–L02 | A1_C05/* (L03 unauthored upstream) | **no design bank** | absent | **deferred-owner** (decision 1) |
| C06–C12, F1–F3 | not yet authored upstream | — | — | not defects (pending authoring) |
| Foundation ledgers (LEXICAL/GRAMMAR/AUDIO/ILL registers, can-do matrix) | 03_A1_foundation/* | projected into banks via authoring | — | referenced by conformance checks |

## 4. Orphans — both directions

**Source-side (specified, not fully shipped):**
- ILL036 (C2 + C3 blocks marked 36/36 used in ILLUSTRATION_ID_REGISTER.csv) referenced by no bank screen → **S2-005**.
- Alt-text parity: two bank sites paraphrase authored alt_text (`course-c1.js:21`, `course-c2.js:229`) → **S2-004**.
- Stale shell copy (Home chapter count, paywall "Twenty-four chapters") → **S2-006 source-staleness** (owner decision 3).
- Quiz `distractor_rationales` / `rationale` / governance fields: intentionally not projected by design's own projection (documented in the bank headers) — not defects.
- C3 quiz results strong/developing/next copy: authored in C1/C2 closers only — C3 fields absent by source (flagged in the decision-2 implementation report) — noted, not a defect.

**App-side (implemented without a source target):**
- None found — every screen type and shell surface maps to a design element; `UnbuiltScreen` exists only as the assessReview placeholder (counted as S1-002, not an orphan).
- `-AUREL_TEST_START` fast path + `SIMCTL_CHILD_AUREL_SCREEN` env hook are test infrastructure, not features.

## 5. Coverage by the harness (post Phase 0.5)

- **Unit:** course decode/count pins per chapter · position math · services (scheduler/streak/bank/scene/joinTiles) · fonts · **DesignTokenTests** (all three CSS layers, both themes) · **SVGPathShapeTests** (every authored icon path) · **ContentConformanceTests*** (verbatim options/keys/feedback/hints per item vs english_course).
- **UI:** SmokeSuite 4/4 (cold launch + onboarding walk, force-quit durability, mic-denied tap path, fast-path purity) · MilestoneSuite (lesson e2e, background/resume, AX3XL hittability on 17e/17 Pro Max via `qa/run-ui-ax.sh`, tab/settings/paywall matrix).
- *ContentConformanceTests landed (commit `18b4875`): 366 practice + 80 quiz + 84 vocab records joined to the shipped JSON; documented-drift registry pins the bank-vs-english_course drift (ledger S1-005/006, S2-007..010).

## 6. Owner decisions register

1. C04 + C05-L1/L2 → **deferred-owner** (design banks intentionally cover C1–C3 per design/README).
2. C3 quiz pending→authored conflict → **implemented from english_course** (`83be99c`).
3. Stale copy → **kept verbatim**, logged (S2-006).
