# Aurel current app state

Audit date: 2026-08-24  
Scope: current iPhone worktree through Stage 1; no product changes  
Status vocabulary: **Observed** = directly inspected or executed; **Inferred** = supported conclusion from observed evidence; **Proposed** is intentionally absent from this document; **Unknown** = not established; **Blocked** = the named verification could not complete.

## Executive current-state summary

- **Observed:** Aurel is an iPhone-only, portrait SwiftUI/SwiftData app with 20 router-level screens, a four-chapter A1 course containing 131 authored screens, and 29 course presentation kinds used by that content.
- **Observed:** All 20 router-level screens render in the current build. The full first course lesson completes in UI automation; the second-lesson walker cannot complete because its automation helper loops on an already-selected order item.
- **Observed:** The strongest current qualities are the distinctive editorial type and desert/arc art direction, an unusually calm adult learning voice, bundled offline course content, explicit empty/recovery states, optional speaking, reduced-motion handling, and durable lesson/background state.
- **Observed:** The most serious current risks are truthful-commerce/account behavior, destructive-account behavior, controls that promise unavailable notifications/widget/help functions, safe-area collisions in the paywall/account flow, and learner-facing internal authoring IDs.
- **Inferred:** The product is a capable local prototype with production-grade learning and persistence work in several areas, but it is not a truthful production account, commerce, notification, or widget implementation yet.

## Method, environment, and limitations

### Method

- **Observed:** Static inspection covered the app entry point, complete router switch, persistence models/recovery, design tokens, typography, reusable components, motion/feedback/audio helpers, course decoder/renderers, all feature files, test targets, existing QA notes, and the current JSON course bank.
- **Observed:** Runtime inspection used an isolated iPhone 17e simulator for default captures and an iPhone 17 Pro Max for a large-layout/Accessibility XXXL boundary plus dark appearance. The verification route is documented in `AppRouter` as non-persisting.
- **Observed:** Evidence paths and exact reproduction notes are in `docs/product-audit/evidence/current/README.md`.
- **Observed:** Source screenshots are actual simulator output. No current-state mockups or generated substitutes were used.

### Environment

| Item | Observed value |
|---|---|
| Host | macOS 26.6 (25G72), Apple silicon, Asia/Baghdad |
| Xcode | 26.6 (17F113) |
| Swift | 6.3.3; project language setting 6.0 with strict concurrency |
| App | Aurel 0.1.0 (1), `com.aurel.app` |
| Deployment | iOS 26.0, iPhone device family only, portrait only |
| UI/data | SwiftUI + SwiftData; no declared third-party dependencies |
| Scheme/targets | `Aurel`; app, `AurelTests`, `AurelUITests` |
| Default device | iPhone 17e, iOS 26.5, 390×844 pt, portrait |
| Boundary device | iPhone 17 Pro Max, iOS 26.5, 440×956 pt, portrait |
| Repository baseline | HEAD `6b43f1c331d14a6e8ae46840da95cac4e9c0cbc1`; pre-existing modified app files and untracked `output/` preserved |

### Build and test baseline

| Check | Exact configuration | Observed result | Limitation/warning |
|---|---|---|---|
| Debug build | `xcodebuild -project Aurel.xcodeproj -scheme Aurel -configuration Debug -destination 'platform=iOS Simulator,id=89552850-37B3-46C6-A222-9FFA61004997' -derivedDataPath /private/tmp/aurel-product-audit-derived build` | Passed, `BUILD SUCCEEDED` | Xcode warns that traditional headermap style is unsupported and `ALWAYS_SEARCH_USER_PATHS` should be `NO` |
| Unit tests | Same project/scheme, isolated iPhone 17e, `-only-testing:AurelTests` | 93 passed, 0 failed in 2.383 s | An initial attempt on a previously booted Pro simulator was killed before tests began; the clean isolated retry is the reported result |
| Smoke UI | `-only-testing:AurelUITests/SmokeSuite` | 4 passed, 0 failed in 69.255 s | Covers onboarding, relaunch durability, microphone-denied fallback, and verification-route non-persistence |
| Milestone UI | `-only-testing:AurelUITests/MilestoneSuite` | 4 passed, 1 failed | Lesson 1, background/resume, AX hittability, and tab/settings/paywall pass; second-lesson walker times out after 480 s |
| AX boundary | Focused `test3DynamicTypeAXHittability` on iPhone 17e and iPhone 17 Pro Max at Accessibility XXXL | Passed on both; Pro Max focused run 13.520 s | Hittability test is not a full VoiceOver reading-order or Accessibility Inspector audit |

**Observed warnings:** Xcode emitted the headermap warning for all three targets, LLDB version-store diagnostics, and an iOS 26.5 simulator duplicate accessibility-bundle class warning. The successful isolated unit/UI results do not establish these as Aurel product defects. A test-host SwiftData store-create denial appeared during one run and recovered; it was not reproduced as an app-launch failure on the isolated runtime.

### Access and audit limitations

- **Unknown:** The repository contains no original external prototype, research repository, production backend, App Store Connect product configuration, or signed-in production account to inspect.
- **Blocked:** End-to-end runtime completion for lesson 2 and the other course presentation kinds is blocked by `ISS-010`, the UI-walker control-flow defect.
- **Unknown:** A full VoiceOver traversal, Voice Control audit, Accessibility Inspector audit, localization pseudolanguage run, real-device audio session, network-loss injection, memory/energy profile, and App Store sandbox purchase were not available in the existing automation.
- **Observed:** Existing `qa/traceability.md` describes an older 24-screen/117-course-screen state and cannot be treated as current authority.

## Product and technical architecture

| Area | Current system | Status and evidence |
|---|---|---|
| Entry/root | `AurelApp` opens a SwiftData container with recovery; `RootView` constructs `AppEnvironment` and switches all screens | **Observed:** `Aurel/App/AurelApp.swift`, `Aurel/App/RootView.swift` |
| Navigation | One observable `AppRouter.Screen` state machine; a custom four-item tab bar appears on home, stories, progress, profile, and leaderboard | **Observed:** 20 exhaustive enum cases and root switch; no unhandled route |
| Persistence | `LearnerProfile`, `DayLog`, `LessonRecord`, and `MistakeItem` in SwiftData; corrupt disk store is moved aside before fallback | **Observed:** `Aurel/Persistence/AppDatabase.swift`; recovery unit tests |
| Course content | Bundled JSON, four chapters/14 lessons/131 screens, decoded into typed payloads and renderer families | **Observed:** `a1-course.json`; decoder/model tests |
| Connectivity | `NWPathMonitor` drives an offline banner; the course bank is bundled | **Observed:** `Services.swift`; runtime offline injection not performed |
| Speech | AV speech synthesis, microphone recording/metering, optional on-device recognition where supported, type/skip alternatives | **Observed:** service code and mic-denied smoke test; real-device recognition quality unknown |
| Commerce/account | Local strings and booleans simulate sign-in, account, subscription, and restore; no StoreKit, authentication client, server, or entitlements | **Observed:** `AppRouter.signIn/startSubscribe/restorePurchase/createAccountAndSubscribe`; repository search |
| Notifications/widget | Settings persist preference booleans and show widget guidance; no notification scheduler/authorization API or widget-extension target exists | **Observed:** router toggles and project target inventory |
| Localization | UI strings are embedded in Swift/JSON; `SWIFT_EMIT_LOC_STRINGS` is disabled; no strings catalog is present | **Observed:** `project.yml` and repository inventory |
| Feature flags/fixtures | Environment/launch-argument verification routes and preview seed; no production feature-flag service | **Observed:** router initialization and previews |

## Flow inventory

| ID | Flow | Entry | Primary sequence | Material branches/end states | Status |
|---|---|---|---|---|---|
| F-001 | First-use and account entry | Fresh local profile | SCR-001 → SCR-002 → SCR-003 → SCR-004 → SCR-006 | SCR-005 returning sign-in; goal selection limit; reminder choice; plan ladder sheet; validation/forgot-password states | **Observed:** onboarding smoke passes; some sheets are static-only |
| F-002 | Daily learning path | SCR-006 | Home chapter card/node → SCR-007 authored course → home/result | Locked/unlocked/completed nodes, optional extra practice, course pause/close, chapter completion | **Observed:** lesson 1 completes; wider renderer coverage is partial |
| F-003 | Quick lesson and completion | SCR-006 or practice entry | SCR-008 → SCR-009 → SCR-010/home | Reveal, knew/didn't, word detail, completion/share/repractice | **Observed:** default screens captured; all interaction variants not separately captured |
| F-004 | Practice and social | Tab bar → SCR-012/SCR-011 | Stories → SCR-013; speaking → SCR-014; review → SCR-015 | Sample leaderboard, role-play choices, microphone denied/type fallback, empty/populated review | **Observed:** default/empty/denied states verified; populated review not runtime verified |
| F-005 | Progress, profile, settings, paywall | Tab bar/profile/settings | SCR-016 → SCR-017 → SCR-018 / SCR-019 → SCR-020 | Theme/type, delete confirmation, free/pro, restore, legal links, subscription form | **Observed:** screens and round trip render; external/service outcomes are local simulations |

## Router-level screen coverage matrix

| ID | Flow | Screen/state | Entry condition | Exit paths | Runtime verified | Evidence | Source location | Status/limitation |
|---|---|---|---|---|---|---|---|---|
| SCR-001 | F-001 | Welcome | Fresh launch or sign out/delete navigation | Goal, Login | Yes | `SCR-001-welcome.png`, Smoke 1 | `WelcomeView.swift:5` | **Observed** |
| SCR-002 | F-001 | Goal selection | Begin path | Commit, back | Yes | `SCR-002-goal.png`, Smoke 1 | `OnboardingViews.swift:10` | **Observed:** capture shows two selected goals |
| SCR-003 | F-001 | Commitment/reminder | Continue with goals | Plan, back | Yes | `SCR-003-commit.png`, Smoke 1 | `OnboardingViews.swift:124` | **Observed** |
| SCR-004 | F-001 | Plan preview | Save reminder | Home/course, ladder sheet | Yes | `SCR-004-plan.png`, Smoke 1 | `OnboardingViews.swift:218` | **Observed:** ladder sheet not separately captured |
| SCR-005 | F-001 | Sign in | Welcome/profile restore path | Home, welcome, forgot sheet | Yes | `SCR-005-login.png` | `LoginView.swift:5` | **Observed:** real authentication unavailable |
| SCR-006 | F-002 | Home/learning path | Returning launch, onboarding completion, tab | Course, quick lesson, settings, paywall, tabs | Yes | `SCR-006-home.png`, `STA-025-home-dark-pro-max.png`, UI suites | `HomeView.swift:8` | **Observed:** locked and completed data states captured across evidence |
| SCR-007 | F-002 | Bound authored course player | Home course node | Advance/back/close/home | Yes | `SCR-007-course.png`, Milestone 1 | `CoursePlayerView.swift:8` | **Observed:** 7/29 used presentation kinds complete end to end |
| SCR-008 | F-003 | Quick-practice runner | Home extra practice | Result, close, word detail | Yes | `SCR-008-lesson.png` | `QuickPracticeViews.swift:10` | **Observed** |
| SCR-009 | F-003 | Result | Lesson/quick lesson completion | Home, streak, repeat, share | Yes | `SCR-009-result.png`, Milestone 1 | `QuickPracticeViews.swift:808` | **Observed** |
| SCR-010 | F-003 | Streak detail | Result/home | Back | Yes | `SCR-010-streak.png` | `StreakBoardViews.swift:8` | **Observed** |
| SCR-011 | F-004 | Cedar Group leaderboard | Tab/profile | Tabs, show-all, board opt-out | Yes | `SCR-011-leaderboard.png`, Milestone 4 | `StreakBoardViews.swift:411` | **Observed:** explicitly labeled sample group |
| SCR-012 | F-004 | Practice hub/stories | Practice tab | Scene, speak, review, story | Yes | `SCR-012-stories.png`, Milestone 4 | `PracticeHubViews.swift:10` | **Observed** |
| SCR-013 | F-004 | Scene role-play | Practice hub | Reply/advance/close | Yes | `SCR-013-scene.png` | `PracticeHubViews.swift:295` | **Observed:** default scenario only |
| SCR-014 | F-004 | Say it aloud | Practice hub | Record/type/skip/back | Yes | `SCR-014-speak.png`, Smoke 3 | `PracticeHubViews.swift:540` | **Observed:** denial fallback; real-device recognition unknown |
| SCR-015 | F-004 | Review | Practice hub | Review item, speaking, back | Yes | `SCR-015-review.png` | `PracticeHubViews.swift:972` | **Observed:** empty state; populated state unverified |
| SCR-016 | F-005 | Progress | Progress tab | Skill detail/practice/tabs | Yes | `SCR-016-progress.png`, Milestone 4 | `ProgressProfileSettingsPaywall.swift:10` | **Observed:** partial data state |
| SCR-017 | F-005 | Profile | You tab | Leaderboard, paywall, settings, help | Yes | `SCR-017-profile.png`, Milestone 4 | `ProgressProfileSettingsPaywall.swift:506` | **Observed:** free guest state |
| SCR-018 | F-005 | Settings | Home/profile | Back, paywall, welcome, confirmation | Yes | `SCR-018-settings.png`, `STA-024-settings-axxxl-pro-max.png` | `ProgressProfileSettingsPaywall.swift:829` | **Observed:** top and AX boundary; lower controls static-inspected |
| SCR-019 | F-005 | Paywall | Locked content/profile/settings | Home, subscribe-account, restore, legal links | Yes | `SCR-019-paywall.png`, Milestone 4 | `ProgressProfileSettingsPaywall.swift:1328` | **Observed:** purchase is simulated |
| SCR-020 | F-005 | Subscribe account | Guest paywall CTA | Home/paywall | Yes | `SCR-020-subscribeAccount.png` | `ProgressProfileSettingsPaywall.swift:1604` | **Observed:** account/subscription are simulated |

## Authored course-presentation coverage

The 29 rows below are unique JSON `type` values, not 131 duplicate authored instances. Counts are exact `jq` counts from the bundled bank. The seven kinds in lesson 1 completed a full runtime walk; the rest decode and have renderers but were not counted as runtime verified.

| Presentation kind | Authored count | Renderer family | Runtime verified | Evidence/status |
|---|---:|---|---|---|
| promise | 2 | Core | Yes | **Observed:** SCR-007 and lesson-1 completion |
| hook | 6 | Core | Yes | **Observed:** lesson-1 completion |
| orientation | 1 | Core | Yes | **Observed:** lesson-1 completion |
| cards | 12 | Core | Yes | **Observed:** lesson-1 completion |
| pause | 2 | Core | Yes | **Observed:** lesson-1/background-resume |
| practice | 24 | Practice | Yes | **Observed:** lesson-1 completion; many embedded subforms remain unverified |
| review | 5 | Language | Yes | **Observed:** lesson-1 completion |
| alphabet | 1 | Core | No | **Blocked:** code-defined/authored, runtime traversal incomplete |
| letterCards | 1 | Core | No | **Blocked** |
| numbers | 4 | Core | No | **Blocked** |
| warmup | 5 | Practice | No | **Blocked:** seen only in incomplete lesson-2 run, not counted complete |
| testlet | 9 | Practice | No | **Blocked** |
| quiz | 4 | Practice | No | **Blocked** |
| reading | 6 | Practice | No | **Blocked** |
| order | 2 | Assembly | No | **Blocked** |
| tiles | 5 | Assembly | No | **Blocked** |
| emailAssembly | 1 | Assembly | No | **Blocked** |
| substitution | 2 | Assembly | No | **Blocked** |
| missionBrief | 3 | Assembly | No | **Blocked** |
| roleplay | 4 | Assembly | No | **Blocked** |
| grammarModel | 4 | Language | No | **Blocked** |
| pronPerceive | 5 | Language | No | **Blocked** |
| pronProduce | 3 | Language | No | **Blocked** |
| conversation | 3 | Language | No | **Blocked** |
| quizIntro | 3 | Assessment | No | **Blocked** |
| results | 4 | Assessment | No | **Blocked** |
| remediation | 3 | Assessment | No | **Blocked** |
| reviewPlan | 3 | Assessment | No | **Blocked** |
| chapterMap | 4 | Assessment | No | **Blocked** |

`pending` is implemented in `ScreenKind` and has a renderer, but has zero instances in the current bank. It is **Code-defined / runtime reachability not verified** and excluded from the 29 authored-kind denominator. `unknown` is a forward-compatibility fallback, not an authored screen.

## Material state inventory

| ID | State | Screen/family | Runtime verified | Evidence/status |
|---|---|---|---|---|
| STA-001 | First-launch welcome | SCR-001 | Yes | **Observed:** capture and clean smoke |
| STA-002 | Returning launch to home | SCR-006 | Yes | **Observed:** relaunch smoke |
| STA-003 | Zero/one goal selected | SCR-002 | Yes | **Observed:** onboarding smoke interaction |
| STA-004 | Two-goal limit and replacement guidance | SCR-002 | Yes | **Observed:** SCR-002 |
| STA-005 | Reminder choice selected | SCR-003 | Yes | **Observed:** SCR-003 and smoke |
| STA-006 | Plan populated from choices | SCR-004 | Yes | **Observed:** SCR-004 |
| STA-007 | Ladder sheet | SCR-004 | No | **Unknown:** source-defined, not captured |
| STA-008 | Sign-in validation error | SCR-005 | No | **Unknown:** source-defined; no production auth exists |
| STA-009 | Forgot-password sheet | SCR-005 | No | **Unknown:** source-defined, not captured |
| STA-010 | Home with locked first node | SCR-006 | Yes | **Observed:** STA-025 |
| STA-011 | Home after completed lesson | SCR-006 | Yes | **Observed:** SCR-006 |
| STA-012 | Course correct/advance | SCR-007 | Yes | **Observed:** milestone lesson 1 |
| STA-013 | Course incorrect/retry | SCR-007 | Yes | **Observed:** milestone walker attempts answers; exact feedback screenshot absent |
| STA-014 | Course pause and resume | SCR-007 | Yes | **Observed:** milestone background/resume |
| STA-015 | Process death and durable restore | SCR-007/SCR-006 | Yes | **Observed:** smoke relaunch plus milestone background |
| STA-016 | Lesson completion/result | SCR-009 | Yes | **Observed:** SCR-009 and milestone 1 |
| STA-017 | Streak populated | SCR-010 | Yes | **Observed:** SCR-010 |
| STA-018 | Sample leaderboard | SCR-011 | Yes | **Observed:** SCR-011 |
| STA-019 | Speaking idle | SCR-014 | Yes | **Observed:** SCR-014 |
| STA-020 | Microphone denied with type alternative | SCR-014 | Yes | **Observed:** Smoke 3 |
| STA-021 | Live take/clarity verdict | SCR-014/course | No | **Unknown:** simulator real recognition not treated as reliable evidence |
| STA-022 | Review empty | SCR-015 | Yes | **Observed:** SCR-015 |
| STA-023 | Review populated/due | SCR-015 | No | **Unknown:** source-defined |
| STA-024 | Accessibility XXXL layout | SCR-006/SCR-018 | Yes | **Observed:** AX test and STA-024 evidence |
| STA-025 | Dark appearance | SCR-006 | Yes | **Observed:** STA-025 evidence |
| STA-026 | Offline banner | Shared | No | **Unknown:** source-defined; loss injection not performed |
| STA-027 | Recovered local-store banner | Root | No | **Unknown:** recovery logic unit-tested, visible banner not runtime-induced |
| STA-028 | Course-load recovery | Root | No | **Unknown:** source-defined, bundled decode succeeds |
| STA-029 | Guest paywall | SCR-019 | Yes | **Observed:** SCR-019 |
| STA-030 | Account-holder paywall/restore | SCR-019 | No | **Unknown:** only local simulated branch |
| STA-031 | Delete-account confirmation | SCR-018 | No | **Unknown:** source-defined, not captured |
| STA-032 | Delete-account result | SCR-018/SCR-001 | No | **Observed in source only:** navigation occurs without deletion |
| STA-033 | Free guest profile | SCR-017 | Yes | **Observed:** SCR-017 |
| STA-034 | Pro profile | SCR-017 | No | **Unknown:** local simulated branch, not captured |

## Coverage accounting

- **Observed discovered unique surfaces:** 49 = 20 router-level screens + 29 authored course presentation kinds.
- **Observed runtime-verified surfaces:** 27 = all 20 router-level screens + 7 presentation kinds completed end to end.
- **Observed discovered material states:** 34.
- **Observed runtime-verified material states:** 22.
- **Blocked/unverified:** 22 authored presentation kinds + 12 material states; zero router-level screens are blocked from rendering.
- **Surface coverage:** `27 / 49 = 55.1%`.
- **State coverage:** `22 / 34 = 64.7%`.
- **Combined coverage:** `(27 + 22) / (49 + 34) = 49 / 83 = 59.0%`.

This is not reported as 100%. Static decoding and unit coverage do not substitute for runtime interaction coverage.

## Screen-family audit

### Family A — Onboarding and login (SCR-001–SCR-005)

- **Purpose, entry, exit, hierarchy:** **Observed.** A short welcome→goals→daily rhythm→plan funnel leads directly into free Chapter 1; returning learners can open sign-in from two welcome controls. Each page has one dominant decision and clear back/continue exits.
- **Layout/type/color:** **Observed.** 24 pt horizontal margins, large Caprasimo display headings, Figtree body/control copy, cream light surfaces and an espresso welcome/plan scene. Goal cards and reminder cards preserve large targets. The plan/commit controls sit close to the physical bottom because the root ignores safe areas.
- **Components/imagery/content:** **Observed.** Custom step header, selectable surfaces, pill CTA, brand mark, abstract contour/desert art. The adult tone is calm and concrete. The plan paragraph exposes content-system language such as “dependency graph,” which is accurate but not naturally learner-facing.
- **Interaction/state/accessibility:** **Observed.** Goal selection prevents more than two and explains replacement. Keyboard fields use content types and submit labels. No account service exists; sign-in validation is only regex/password length. AX labels exist on back/sign-in controls; full VoiceOver order is **Unknown**.
- **Learning/perceived quality/consistency:** **Inferred.** Goal and schedule choices create orientation without coercive gamification, but setup is longer than the first meaningful learning action and its notification promise is not implemented.

### Family B — Home, path, and authored course (SCR-006–SCR-007)

- **Purpose, hierarchy:** **Observed.** Home foregrounds chapter outcome, today’s two-part rhythm, and a vertical learning path. The bound player uses a persistent close/back control, lesson label, progress, then one authored learning task.
- **Layout/type/color:** **Observed.** Home uses a dense large-title/card/path composition; the custom floating tab bar overlays scrolling content. Course deliberately forces the espresso scheme to protect art direction. Runtime images are high-resolution, consistent amber/espresso illustrations; assets total about 52 MB before asset-catalog processing.
- **Components/content:** **Observed.** Arc/dune scene, chapter status card, node states, progress strips, 29 typed authored kinds collapsed into renderer families. The content bank scales structurally to four chapters and 131 screens, but many optional payload fields and renderer-specific branches increase QA surface.
- **Interaction/state:** **Observed.** Lesson 1 completes; process death/background restoration passes. The second-lesson automated walker stalls at an embedded order task due to test logic. Bundled course plus offline banner supports degraded connectivity; runtime offline state is **Unknown**.
- **Accessibility/motion/audio:** **Observed.** Custom course controls have labels and ≥44 pt targets in inspected code, Reduce Motion changes route transitions to opacity, and sound/haptics are gated by settings. Course art has supplied alt text or explicit decorative hiding. Full renderer VoiceOver coverage is **Blocked** with the traversal gap.
- **Learning quality:** **Observed/Inferred.** Promise→orientation→cards→practice→review→pause scaffolding is strong and adult-appropriate. A single first lesson is 18–20 minutes, materially longer than many mobile “bite-sized” sessions; whether that duration fits target behavior is **Unknown** without learner evidence.

### Family C — Quick practice, result, and streak (SCR-008–SCR-010)

- **Purpose/hierarchy:** **Observed.** Quick practice shows one card/task at a time, then a completion page with outcomes, correct/word/minute metrics, streak, share, repeat, and return actions.
- **Layout/components:** **Observed.** Large card, progress segments, three self-assessment controls, and sticky bottom CTA use the shared cream/copper language. The result page is information-dense but vertically ordered from achieved outcome to metrics to next actions.
- **Feedback/state:** **Observed.** Reveal/known/missed controls, word detail, share sheet, spaced-return copy, and completion feedback are present. Screenshot state showing `0/5 correct` beside a positive completion sentence is truthful but can create mixed emphasis.
- **Accessibility/learning:** **Observed/Inferred.** Non-color labels accompany state, hit regions are large, and the streak message explicitly emphasizes the habit rather than the number. The self-report quick lesson does not establish objective recall accuracy.

### Family D — Practice, scene, speaking, review, and sample group (SCR-011–SCR-015)

- **Purpose/IA:** **Observed.** The Practice tab groups scenes, optional speaking, mistakes, and authored stories. Cedar Group is a top-level/tab-compatible sample comparison surface.
- **Layout/type/content:** **Observed.** Repeated card rows are legible and consistent; scene/speaking use focused single-task layouts. Learner-facing titles expose `A1-C03-RP001`, `S27–S28`, and “Chapter map / next,” which read like internal authoring metadata.
- **Speaking/privacy:** **Observed.** Permission is requested only after a user action; denial produces a Settings recovery and type/skip alternatives. Temporary recordings are deleted after recognition. Recognition requests on-device processing only when the recognizer supports it, so the absolute privacy wording in `Info.plist` is stronger than the conditional code path; actual OS behavior on unsupported recognition is **Unknown**.
- **Review/social state:** **Observed.** Review has a clear empty state; populated review is static-only. Cedar Group prominently labels itself a sample group, reducing deception risk, but also displays a fabricated learner identity/rank within that sample.
- **Learning/accessibility:** **Inferred.** Scenes and clarity-not-accent speaking reinforce practical adult language and psychological safety. Three unlabeled numbered progress circles rely on context, and full spoken-control order is **Unknown**.

### Family E — Progress and profile (SCR-016–SCR-017)

- **Purpose/hierarchy:** **Observed.** Progress separates grammar, listening, conversation, speaking, and vocabulary, then recommends a next practice. Profile uses real local lesson/streak/word data and honest empty milestones.
- **Layout/components:** **Observed.** Skill rows, status chips, progress bars, stat cards, and profile rows reuse type/color tokens but are visually card-heavy. Floating tabs overlap the lowest currently visible content while scroll padding allows further traversal.
- **Content/state:** **Observed.** Empty categories say “Not started”/“Nothing recorded yet.” Profile identifies local guest state and free subscription. “Help and contact” has a chevron and button affordance but an empty action.
- **Learning/accessibility:** **Observed/Inferred.** Skill breakdown and next recommendation make progress actionable. Charts expose a synthesized accessibility summary. The meaning of “seen,” “retained,” and mastery thresholds is not explained to the learner.

### Family F — Settings, paywall, and account (SCR-018–SCR-020)

- **Purpose/hierarchy:** **Observed.** Settings covers daily rhythm, notifications, widget, comparison, theme, text size, account, and deletion. Paywall presents Chapters 2–4, two durations, benefit list, CTA, restore, terms, and privacy; account form requests email/password.
- **Layout/safe areas:** **Observed.** Settings scrolls and passes AX3XL hittability. At the paywall’s initial 17e position, the primary CTA label is intersected by the home indicator. On subscribe-account, the top-left back circle overlaps the status-time area. These are direct screenshots, not estimates.
- **Content/trust:** **Observed.** Paywall says billing and renewal are set at App Store checkout and calls chapters “production-ready,” but its actions immediately set a local `pro` boolean. Account creation and sign-in are local validation only. Settings claims actual reminders, weekly email, notifications, and a widget without the corresponding services/target.
- **Destructive/recovery:** **Observed.** Delete shows a confirmation saying local progress/settings will be erased, but the destructive action only navigates to welcome. Sign out also only navigates. Help/contact is inert. Terms/privacy are real links, but URL availability/content was not validated.
- **Accessibility:** **Observed.** Large hit targets and AX3XL top-area test pass. Primary copper button foreground/background is 4.26:1 in the repository’s exact contrast diagnostic, below Apple’s 4.5:1 guidance for normal text. The test records this without failing.

### Family G — Shared system and recovery surfaces

- **Observed:** Root offers a course-decode recovery screen, a recovered-store banner, offline banner, confirmation dialog, sheets, pressed states, entrance/stagger motion, haptic/sound gates, and Reduce Motion route fallbacks.
- **Observed:** The type system combines an app text step with system Dynamic Type. Central type/color/spacing/corner/motion tokens exist, but many screens still assemble bespoke surfaces and opacity variants directly.
- **Unknown:** Recovery visuals, offline banner behavior under a real transition, Increase Contrast, Reduce Transparency, VoiceOver order, and memory/energy under long lessons were not runtime audited.

## Intended design system versus rendered system

| System area | Intended/code-defined system | Rendered observation | Status |
|---|---|---|---|
| Identity | Caprasimo display + Figtree utility; arc, sun, dunes, copper/cream/espresso | Distinctive, editorial, warm, recognizably adult | **Observed strength** |
| Type | Central `AUTypeScale` with custom-font Dynamic Type and app step | Hierarchy is clear; display faces can dominate dense screens; AX3XL tested on home/settings | **Observed; wider AX coverage blocked** |
| Color | Semantic token catalog with light/dark ramps and scene-art colors | Coherent across most screens; primary CTA contrast measures 4.26:1 | **Observed discrepancy** |
| Spacing/layout | `AUSpace`, repeated 24 pt margins, large touch targets, root physical-stage model | Strong rhythm, but global safe-area ignoring creates bottom/top collisions on two commerce screens | **Observed discrepancy** |
| Shape/depth | Large continuous corners, strokes, soft lift/shadow, pills | Consistent but frequent cards/pills reduce differentiation among hierarchy levels | **Inferred system pressure** |
| Icons | Custom `AUIcon`, decorative icons hidden and controls labeled | Visually consistent; full semantics audit not run | **Observed/Unknown** |
| Imagery | Named authored illustration IDs and alt text, desert/cinematic palette | High-resolution Chapter 1 art is coherent; later-content asset completeness is **Unknown** | **Observed/Unknown** |
| Components | Pill/link/key buttons, cards, tags, banners, sheets, tab bar, selection rows, player controls | Many shared primitives exist; feature files also create bespoke variants and direct styling | **Observed** |
| Motion/feedback | Central durations/springs, reduced-motion mapping, pressed scale, haptics, sparse sound | Route motion and settings gates work in code/tests; no performance instrumentation | **Observed/Unknown** |
| Voice | Calm, concise, non-punitive, practical; “clarity not accent” | Usually strong; authoring and production terminology leaks on practice/paywall | **Observed discrepancy** |
| Accessibility | AX labels, decorative hiding, min-target helper, Dynamic Type, Reduce Motion | AX3XL targets pass; contrast shortfall and unexecuted VoiceOver audit remain | **Observed gap** |
| Content scaling | Typed payloads and renderer grouping across A1 chapters | 131 screens decode; runtime coverage is only 7/29 kinds end to end | **Observed risk** |

## Material findings

### ISS-001 — Subscription, restore, and account controls simulate success without their named services

- **Status:** Observed
- **Severity:** Critical
- **Confidence:** High
- **Affected screens/states:** SCR-005, SCR-017–SCR-020 / STA-029, STA-030, STA-034
- **Evidence:** `AppRouter.swift:759-776, 1109-1141`; no StoreKit/auth/backend dependency; SCR-019/SCR-020 copy
- **Observed behavior:** Valid-looking email/password strings route to home. Subscribe, restore, and create-account-and-subscribe set a local `pro` boolean or route based on whether a local email string exists. The UI states that App Store checkout, billing, sync, and restore will occur.
- **Why it matters:** A primary trust and commerce flow represents transactions/account recovery that do not occur.
- **Likely cause:** Prototype route logic remains wired to production-form copy.
- **Constraint or unknown:** App Store Connect products and intended production account architecture were unavailable.

### ISS-002 — Delete account confirms erasure but deletes nothing

- **Status:** Observed
- **Severity:** Critical
- **Confidence:** High
- **Affected screens/states:** SCR-018, SCR-001 / STA-031, STA-032
- **Evidence:** `ProgressProfileSettingsPaywall.swift:1080-1098` (confirmation) and destructive action `r.nav(.welcome)`; no deletion call
- **Observed behavior:** The dialog promises permanent erasure of local progress, streaks, and settings. Confirming only navigates to Welcome. Sign out likewise navigates without clearing local identity.
- **Why it matters:** A destructive privacy control makes a false guarantee and leaves the data it says it erased.
- **Likely cause:** Navigation placeholder was retained after the confirmation UI was added.
- **Constraint or unknown:** No remote account exists in the inspected repository.

### ISS-003 — Reminder, notification, and weekly-email switches have no delivery mechanism

- **Status:** Observed
- **Severity:** High
- **Confidence:** High
- **Affected screens/states:** SCR-003, SCR-018 / STA-005
- **Evidence:** Settings copy and `toggleSw`/`toggleNotif`; no `UNUserNotificationCenter`, scheduling, authorization, email, or backend implementation
- **Observed behavior:** Choices persist and switches animate, but no reminder, milestone notification, cohort result, or weekly email is scheduled/sent.
- **Why it matters:** Onboarding and settings ask users to rely on time-sensitive re-engagement that will not occur.
- **Likely cause:** Preference-model UI was implemented before delivery services.
- **Constraint or unknown:** Intended notification policy and email service are unknown.

### ISS-004 — Settings instruct users to add a widget that the app does not ship

- **Status:** Observed
- **Severity:** High
- **Confidence:** High
- **Affected screens/states:** SCR-018 / STA-024
- **Evidence:** Widget preview/instructions in settings; project has only app/unit/UI-test targets and no widget extension or entitlements
- **Observed behavior:** Settings says to add the small Aurel widget and describes its live sun behavior. No widget target exists.
- **Why it matters:** The instruction leads to a feature the user cannot find.
- **Likely cause:** Prototype/roadmap preview is presented as shipped functionality.
- **Constraint or unknown:** Whether a widget is intended for launch is unknown.

### ISS-005 — Primary commerce controls collide with system safe areas

- **Status:** Observed
- **Severity:** High
- **Confidence:** High
- **Affected screens/states:** SCR-019, SCR-020 / STA-029
- **Evidence:** `SCR-019-paywall.png` shows the home indicator crossing the CTA label; `SCR-020-subscribeAccount.png` shows the back control overlapping the status time; root uses `.ignoresSafeArea()`
- **Observed behavior:** System chrome intersects primary navigation/conversion controls in the default 390×844 pt configuration.
- **Why it matters:** The collision harms legibility, touch confidence, accessibility, and trust in a primary purchase flow.
- **Likely cause:** Physical-stage root layout plus insufficient screen-specific safe-area compensation.
- **Constraint or unknown:** Other iPhone sizes may produce different collision points; Pro Max home/settings do not prove these screens safe.

### ISS-006 — Help and contact presents an affordance but performs no action

- **Status:** Observed
- **Severity:** High
- **Confidence:** High
- **Affected screens/states:** SCR-017
- **Evidence:** SCR-017; `profileRow("Help and contact", "", divider: false) {}`
- **Observed behavior:** A full button row with chevron does nothing.
- **Why it matters:** Users cannot reach support from the place explicitly labeled for recovery/contact.
- **Likely cause:** Empty placeholder action.
- **Constraint or unknown:** No intended support channel is defined in the repository.

### ISS-007 — Internal authoring and production language is learner-facing

- **Status:** Observed
- **Severity:** High
- **Confidence:** High
- **Affected screens/states:** SCR-004, SCR-012, SCR-013, SCR-019
- **Evidence:** Screenshots show `A1-C03-RP001`, `S27–S28`, “Chapter map / next,” “dependency graph,” “production-ready today,” and “once production replaces the placeholders”
- **Observed behavior:** Course-bank IDs, screen ranges, implementation terminology, and unfinished-production commentary appear as product copy.
- **Why it matters:** It reduces comprehension and makes shipped surfaces feel like an internal prototype, especially in paid-content claims.
- **Likely cause:** Authoring metadata and implementation notes were promoted into display strings.
- **Constraint or unknown:** The approved learner-facing naming taxonomy is not documented.

### ISS-008 — Core UI and course copy have no localization resource path

- **Status:** Observed
- **Severity:** Medium
- **Confidence:** High
- **Affected screens/states:** All
- **Evidence:** No `.xcstrings`, `.strings`, or localized resources; `SWIFT_EMIT_LOC_STRINGS: NO`; extensive embedded Swift/JSON strings
- **Observed behavior:** English copy and date/format assumptions are coupled directly to views/content.
- **Why it matters:** A full A1–C1 product cannot be localized or pseudolocalized systematically, and long translations cannot be regression-tested.
- **Likely cause:** Current product scope is English-first prototype content.
- **Constraint or unknown:** Launch locales are not specified.

### ISS-009 — Repeated primary-button text contrast is below Apple’s normal-text guidance

- **Status:** Observed
- **Severity:** High
- **Confidence:** High
- **Affected screens/states:** Repeated primary CTAs across SCR-001–SCR-020
- **Evidence:** Exact repository diagnostic: warm-white `#FFF8F0` over accent-600 is 4.26:1 in light/dark; test records but does not fail
- **Observed behavior:** Normal-size primary button labels use a contrast pair below 4.5:1.
- **Why it matters:** Repeated task-completion controls are less legible for low-vision users and do not meet Apple’s cited normal-text threshold.
- **Likely cause:** Brand ramp selected without a passing default/increased-contrast pair.
- **Constraint or unknown:** Increase Contrast behavior for this custom pair was not runtime tested.

### ISS-010 — The second-lesson UI regression test cannot advance past an order item

- **Status:** Observed
- **Severity:** High
- **Confidence:** High
- **Affected screens/states:** SCR-007 / course coverage
- **Evidence:** Milestone result: 4 passed, 1 failed; `MilestoneSuite.swift:117-137` returns `true` after tile selection and `:151-156` immediately loops before continuation
- **Observed behavior:** The walker repeatedly taps the same three tile buttons until its 480-second timeout, preventing the named second-lesson regression check and broader traversal.
- **Why it matters:** A previously high-risk dead-end scenario is not protected by a functioning end-to-end test, and 22 authored presentation kinds remain runtime-unverified.
- **Likely cause:** Early `continue` after the order helper suppresses the enabled Go-on path.
- **Constraint or unknown:** This result is not proof that the app’s order item itself is broken.

### ISS-011 — Current QA traceability describes a superseded product surface

- **Status:** Observed
- **Severity:** Medium
- **Confidence:** High
- **Affected screens/states:** Audit/maintenance system
- **Evidence:** `qa/traceability.md` states 24 shell screens and 117 Chapter 1–3 course screens; current router has 20 and bank has 131 across Chapters 1–4
- **Observed behavior:** Existing QA inventory no longer matches the app.
- **Why it matters:** Future reviewers can draw false coverage and scope conclusions.
- **Likely cause:** Product/content evolved without updating the older inventory.
- **Constraint or unknown:** None.

### ISS-012 — Card, pill, and custom-surface repetition flattens hierarchy on dense screens

- **Status:** Inferred
- **Severity:** Medium
- **Confidence:** Medium
- **Affected screens/states:** SCR-006, SCR-011, SCR-012, SCR-016–SCR-019
- **Evidence:** Runtime captures and repeated direct rounded-rectangle/stroke/shadow assemblies in feature files alongside shared primitives
- **Observed behavior:** Many unrelated hierarchy levels use similarly large rounded cards, pills, outlines, and soft elevation.
- **Why it matters:** Dense screens require more scanning because primary, secondary, informational, and sample content can have similar visual weight.
- **Likely cause:** Feature-local styling grew around a broad shared aesthetic without a strict surface hierarchy.
- **Constraint or unknown:** User comprehension testing was not available; this is a supported design-system inference, not a measured task failure.

### ISS-013 — Accessibility verification is strong at text-size hittability but incomplete elsewhere

- **Status:** Unknown
- **Severity:** Medium
- **Confidence:** High
- **Affected screens/states:** All; especially SCR-007 and custom controls
- **Evidence:** AX3XL tests pass on two boundary devices; no automated Accessibility Inspector/VoiceOver order audit; course traversal covers 7/29 kinds
- **Observed behavior:** Labels/minimum targets/reduced motion are widely implemented, but the test suite does not establish semantic order, rotor grouping, Voice Control names, Increase Contrast, or all renderer states.
- **Why it matters:** Custom controls and content-dense exercises can remain inaccessible despite being hittable at large text.
- **Likely cause:** Current UI tests focus on routing and frame containment.
- **Constraint or unknown:** This is a verification gap, not evidence that every untested surface fails.

### ISS-014 — Privacy copy makes an unconditional on-device claim that the implementation only conditionally requests

- **Status:** Observed
- **Severity:** High
- **Confidence:** Medium
- **Affected screens/states:** SCR-014 / STA-020, STA-021
- **Evidence:** `Info.plist` says recognition “never leaves the phone”; `SpeechToText` sets `requiresOnDeviceRecognition = true` only when `supportsOnDeviceRecognition` is true
- **Observed behavior:** On devices/locales that do not support on-device recognition, the request does not require it, while the permission copy remains absolute.
- **Why it matters:** Voice data handling is a sensitive trust promise.
- **Likely cause:** Fail-soft recognition support and privacy copy were authored with different assumptions.
- **Constraint or unknown:** Actual framework behavior on unsupported configurations was not verified on a real device; severity should be re-evaluated with platform/privacy expertise.

## Preserved strengths

- **Observed:** Course content is bundled and decodes deterministically; core learning can work without a network.
- **Observed:** Lesson and day state survive relaunch/backgrounding; corrupt-store and corrupt-course recovery paths exist.
- **Observed:** Speaking is optional, denial is treated as a calm state, and type/skip alternatives remain available.
- **Observed:** Streaks include grace days and copy explicitly avoids punitive loss framing.
- **Observed:** Review intervals are modeled as widening retrieval; empty states explain what will happen next.
- **Observed:** The identity is specific: Caprasimo/Figtree, arc/sun/dune imagery, copper/cream/espresso palette, and cinematic Chapter 1 art.
- **Observed:** The app has shared tokens/components and explicit Reduce Motion, accessibility labeling, decorative hiding, large targets, haptic, and sound gates.
- **Observed:** Sample social content is labeled as sample rather than represented as a live cohort.

## Open evidence questions

- **Unknown:** Is iOS 26.0-only intentional for launch, or a development constraint?
- **Unknown:** Are account, subscription, notifications, email, widget, help, and legal URLs launch scope or prototype-only concepts?
- **Unknown:** What is the approved launch market/localization set and privacy architecture for speech recognition?
- **Blocked:** Can all 29 authored course kinds complete on smallest/common/largest supported iPhones after the milestone walker is repaired?
- **Unknown:** Do real learners understand the 18–20 minute lesson model, two-part day, mastery labels, and sample comparison without explanation?
