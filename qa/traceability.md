# Aurel traceability matrix — through PH-02

Sources of truth: `Aurel/Resources/Course/a1-course.json`, the Swift router/player implementation, and `docs/product-audit/03_APP_IMPROVEMENT_PLAN.md`. Counts below are generated from the current shipping course bank and pinned by tests.

Status vocabulary: **runtime-verified** · **unit-verified** · **release-gated** · **deferred-decision**.

## Phase totals

| Scope | Current count | Current status |
|---|---:|---|
| Shell screens | 20 (`SCR-001`–`SCR-020`) | Existing smoke/milestone coverage passes; semantic tabs/actions and catalog extraction applied |
| Authored chapters | 4 | Runtime-verified |
| Authored lessons | 14 | Runtime-verified in one uninterrupted deterministic walk |
| Authored course screens | 131 | Runtime-verified by the lesson walk |
| Authored renderer kinds | 29 | 29/29 runtime-verified with render, close, and Home exit |
| Renderer families | 10 | Representative AX3XL + Increase Contrast + Reduce Motion coverage |
| Source-localization keys | 465 | Catalog compiles; PH-01 pseudolanguage route and PH-02 source extraction pass |

## Shell screens

| ID | Surface | Primary implementation | PH-01 evidence/status |
|---|---|---|---|
| SCR-001 | Welcome/value sample | `Features/Onboarding/WelcomeView.swift`, `Features/Onboarding/OnboardingViews.swift` | PH-02 value-first and progress-free sample journey |
| SCR-002 | Goal selection | `Features/Onboarding/OnboardingViews.swift` | First goal changes the visible Learn reason; focused unit/UI coverage |
| SCR-003 | Pace commitment | `Features/Onboarding/OnboardingViews.swift` | 10/20-minute selection changes visible duration; PH-00 reminder gate retained |
| SCR-004 | Plan/value summary | `Features/Onboarding/OnboardingViews.swift` | Goal reason, pace, duration, and outcome are data-driven |
| SCR-005 | Login/unavailable account | `Features/Login/LoginView.swift` | Release-gated by PH-00; milestone regression |
| SCR-006 | Home/learning path | `Features/Home/HomeView.swift` | One reason/duration/outcome recommendation across focused PH-02 states; stable tabs |
| SCR-007 | Authored player | `Course/Player/CoursePlayerView.swift` | 29 kinds, 14 lessons, 131 screens runtime-verified |
| SCR-008 | Quick practice | `Features/QuickPractice/QuickPracticeViews.swift` | Smoke/milestone regression; cataloged |
| SCR-009 | Result | `Features/QuickPractice/QuickPracticeViews.swift` | Milestone regression |
| SCR-010 | Streak | `Features/PracticeHub/StreakBoardViews.swift` | Existing route coverage retained |
| SCR-011 | Sample leaderboard | `Features/PracticeHub/StreakBoardViews.swift` | Tab/milestone regression |
| SCR-012 | Practice hub | `Features/PracticeHub/PracticeHubViews.swift` | Distinct learner-chosen job; activity duration/outcome labels; focused tab journey |
| SCR-013 | Scene | `Features/PracticeHub/PracticeHubViews.swift` | Cataloged learner copy |
| SCR-014 | Speak | `Features/PracticeHub/PracticeHubViews.swift` | Smoke denial path; PH-00 privacy gate retained |
| SCR-015 | Review | `Features/PracticeHub/PracticeHubViews.swift` | Cataloged learner copy |
| SCR-016 | Progress | `Features/Progress/ProgressProfileSettingsPaywall.swift` | Stable completed-lesson evidence levels, learner explanation, and next-improvement action |
| SCR-017 | Profile/You | `Features/Progress/ProgressProfileSettingsPaywall.swift` | Distinct identity/settings job; valid empty and unavailable-chapter actions |
| SCR-018 | Settings | `Features/Progress/ProgressProfileSettingsPaywall.swift` | AX/milestone regression; truthful PH-00 capabilities retained |
| SCR-019 | Unavailable paywall | `Features/Progress/ProgressProfileSettingsPaywall.swift` | PH-00 release-safe geometry/capability gate retained |
| SCR-020 | Unavailable account/subscription | `Features/Progress/ProgressProfileSettingsPaywall.swift` | PH-00 release-safe geometry/capability gate retained |

## Authored renderer inventory

| Kind | Screens | Family | Verification |
|---|---:|---|---|
| `alphabet` | 1 | cards | Runtime-verified |
| `cards` | 12 | cards | Runtime + representative AX |
| `chapterMap` | 4 | assessment | Runtime-verified |
| `conversation` | 3 | conversation | Runtime + representative AX; learner title/scene contract |
| `emailAssembly` | 1 | assembly | Runtime-verified |
| `grammarModel` | 4 | grammar | Runtime + representative AX |
| `hook` | 6 | opening | Runtime-verified |
| `letterCards` | 1 | cards | Runtime-verified |
| `missionBrief` | 3 | mission | Runtime + representative AX |
| `numbers` | 4 | cards | Runtime-verified |
| `order` | 2 | assembly | Runtime + deterministic key path |
| `orientation` | 1 | opening | Runtime; learner guidance contract |
| `pause` | 2 | opening | Runtime + explicit Continue/Break actions |
| `practice` | 24 | practice | Runtime + selected-state semantics |
| `promise` | 2 | opening | Runtime + representative AX |
| `pronPerceive` | 5 | pronunciation | Runtime + representative AX |
| `pronProduce` | 3 | pronunciation | Runtime-verified |
| `quiz` | 4 | practice | Runtime-verified |
| `quizIntro` | 3 | assessment | Runtime-verified |
| `reading` | 6 | practice | Runtime-verified |
| `remediation` | 3 | assessment | Runtime-verified |
| `results` | 4 | assessment | Runtime + representative AX |
| `review` | 5 | review | Runtime + representative AX; asset IDs replaced by learner set names |
| `reviewPlan` | 3 | assessment | Runtime-verified |
| `roleplay` | 4 | mission | Runtime + full lesson journey; stable Safe stop |
| `substitution` | 2 | assembly | Runtime-verified |
| `testlet` | 9 | practice | Runtime; learner rung/support/unlock copy |
| `tiles` | 5 | assembly | Runtime + representative AX + deterministic key paths |
| `warmup` | 5 | practice | Runtime-verified |

Compatibility-only `pending` and forward guard `unknown` are intentionally excluded from the 29 authored kinds.

## Content units

| Chapter | Lessons | Screens | Status |
|---|---:|---:|---|
| `A1-C01` | 4 | 40 | Runtime-verified |
| `A1-C02` | 4 | 43 | Runtime-verified |
| `A1-C03` | 3 | 34 | Runtime-verified |
| `A1-C04` | 3 | 14 | Runtime-verified |
| **Total** | **14** | **131** | **Runtime-verified** |

## PH-01 recommendation traceability

| Recommendation | Acceptance evidence | Status |
|---|---|---|
| REC-006 breadth | Named surface/action roles; non-color selected values/traits; AX3XL, Increase Contrast, Reduce Motion on compact/common/large devices | Complete for PH-01 simulator scope |
| REC-007 | 29-kind fixture suite; 14-lesson/131-screen continuous walker; bounded unchanged-state failure; focused regression fixtures | Complete |
| REC-008 | Compatible display/debug schema; all 131 `displayTitle` fields; forbidden-copy contract; visible author-token UI scan; 410-key string catalog; pseudolanguage | Complete, with launch locales deferred to DEC-004 |
| REC-009 | Ten named renderer families; semantic surfaces/actions/tabs; stable accessibility identifiers; component catalog | Complete for PH-01 |

## PH-02 recommendation traceability

| Recommendation | Acceptance evidence | Status |
|---|---|---|
| REC-010 | Progress-free task before setup; explicit duration/outcome/free/voice scope; persisted skip/back/relaunch; goal and pace alter visible recommendation; existing learners bypass | Engineering complete; adult-learner comprehension validation remains external |
| REC-011 | Four distinct tab jobs; shared reason/duration/outcome/action contract; stable evidence-level thresholds and explanation; valid state actions; tab ownership/preservation tests | Engineering complete; UX/learning-design validation remains external |

## Automated gates

- `PH01FoundationTests`: generated inventory, family coverage, 14/131 fixtures, schema compatibility, learner-copy rejection, practice normalization, structured completion, deterministic tile paths, and semantic roles.
- `RendererCoverageSuite`: 29/29 render/close/exit, zero visible author IDs, pseudolanguage navigation, ten representative AX/reduced-motion families, and non-color selected state.
- `MilestoneSuite`: uninterrupted 14-lesson traversal plus focused mixed-tile/roleplay, structured-practice, remaining-lesson, restoration, AX, navigation, and release-safety checks.
- `SmokeSuite`: onboarding, durable relaunch, denied microphone alternative, and fixture-route purity.
- `PH02JourneyTests`: progress-free sample, onboarding restoration/completion, goal/pace effects, recommendation states, evidence derivation, four-tab jobs, and tab-state preservation.
- `PH02NavigationSuite` plus the updated onboarding smoke journey: focused value-first and four-tab UI traversal.
- Release build scan: PH-01 fixture environment keys/identifiers are absent from the optimized executable.

## Decision and launch boundaries

- **DEC-004 remains deferred-decision:** English is the source locale; pseudolanguage is a QA route. Additional launch locales and curriculum translation require explicit approval and language review.
- Simulator semantics do not replace a manual VoiceOver/Voice Control pass or real-device speech/audio review; those remain PH-03 launch gates.
- PH-02 engineering is complete. Accessibility-inclusive adult-learner comprehension research and independent UX/learning-design approval have not been fabricated and remain validation gates.
- PH-03 has not started and remains unauthorized.
