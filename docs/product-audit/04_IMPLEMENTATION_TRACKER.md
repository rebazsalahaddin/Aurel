# Aurel implementation tracker

Plan approved: 2026-08-24  
Approved scope: **PH-00 through PH-03**  
Plan source: [`03_APP_IMPROVEMENT_PLAN.md`](03_APP_IMPROVEMENT_PLAN.md)  
Status: **PH-03 local-first engineering implementation complete — Ready for review**

## Scope and decision boundary

- **Observed:** The user confirmed PH-00, PH-01, and PH-02 were implemented successfully and approved, then explicitly authorized PH-03 on 2026-08-25.
- **PH-01 result:** 29/29 authored kinds, 14/14 lessons, and 131/131 screens are runtime-verified; ISS-010 is closed.
- **PH-02 result:** First use now demonstrates a progress-free learning task before setup; goal and pace visibly shape the next Learn card; Learn/Practice/Progress/You have distinct jobs; recommendation and practice-evidence derivations are deterministic.
- **Implemented release posture:** Account, commerce, notifications, weekly email, widget, and support capabilities default to unavailable. A surface is enabled only after its executable service is provided.
- **Implemented speech posture:** Recognition is on-device-only. When on-device recognition is unavailable, capture does not begin and the existing type/skip alternatives remain available.
- **PH-03 decision applied:** DEC-001 remains the honest local-first Chapter 1 posture. No external capability was invented without its product IDs, backend, legal/support destinations, service assets, and separate authorization. REC-003 is therefore satisfied by the existing release removal/gating path, not by a simulated purchase flow.
- **Still unresolved by design:** DEC-002 iOS floor, any broader DEC-003 speech architecture, and DEC-004 launch locales/curriculum translation. PH-01 uses English as the source locale plus pseudolanguage QA without implying translation.
- **Research basis:** PH-00 and PH-01 follow the approved plan informed by the exhaustive authenticated Mobbin pass documented in [`MOBBIN_COVERAGE.md`](evidence/research/MOBBIN_COVERAGE.md). No new Mobbin research was needed or performed during implementation.

## Phase status

| Phase | Status | Authorization |
|---|---|---|
| PH-00 — Truth and release safety | Complete | Authorized 2026-08-24 |
| PH-01 — Renderer, content, and component foundations | Complete; approved by user | Authorized 2026-08-25 |
| PH-02 — Primary learning and information architecture | **Engineering complete; ready for review** | Authorized 2026-08-25 |
| PH-03 — Production capabilities and launch hardening | **Engineering complete for authorized local-first scope; ready for review** | Authorized 2026-08-25 |

## Recommendation traceability

| Recommendation | Result | Status |
|---|---|---|
| REC-001 | Release-safe capability model; unavailable account, commerce, notification/email, widget, and support actions are hidden or replaced by truthful, non-transactional states | Complete for PH-00 |
| REC-002 | Confirmed local deletion erases all SwiftData models; cancellation is a no-op; relaunch produces a fresh guest; sign-out preserves learning data | Complete for PH-00 |
| REC-004 | On-device recognition is mandatory before capture; unsupported devices/locales record no take; purpose strings and fallback copy match behavior | Complete for PH-00 simulator scope |
| REC-005 | Release paywall/account routes use real safe areas; unavailable-state content and CTA frames are tested on small/common/large iPhones | Complete for PH-00 routes |
| REC-006 | Primary copper CTA pair moved to accent-700 and now gates at 6.47:1; critical route labels, targets, Dynamic Type, contrast, and motion configurations were checked | Complete for PH-00 subset |
| REC-006 breadth | Named semantic roles, non-color state, AX3XL, Increase Contrast, and Reduce Motion across ten renderer families and boundary devices | Complete for PH-01 simulator scope |
| REC-007 | Deterministic 29-kind fixtures and a bounded walker complete all 14 lessons / 131 screens | Complete |
| REC-008 | Compatible display/debug fields, learner-copy guard, 410-key string catalog, pseudolanguage, and current generated traceability | Complete subject to DEC-004 locales |
| REC-009 | Ten governed renderer families plus semantic surfaces, actions, selected states, and stable tabs | Complete for PH-01 |
| REC-010 | Progress-free value sample before setup; deterministic skip/back/relaunch; goal and 10/20-minute pace visibly alter the first recommendation; existing learners bypass onboarding | Engineering complete; external learner validation remains |
| REC-011 | Distinct four-tab jobs; shared reason/duration/outcome recommendation; stable evidence-level derivation and explanation; valid empty/locked/completed/offline actions | Engineering complete; external learner validation remains |
| REC-003 | Release paywall/account/commerce remain non-transactional and unavailable because no StoreKit products, entitlement service, legal URLs, or account policy were supplied; no fake commerce ships | Complete for authorized local-first scope |
| REC-012 | Shared semantic learning feedback, retry/reveal actions, playback/capture handoff, background interruption cleanup, Reduce Motion completion, privacy manifest, and bounded course-load baseline | Engineering complete; real-device/specialist validation remains |

## PH-03 task checklist

- [x] Keep unconfigured account, commerce, notification/email, widget, and support capabilities unavailable in Release.
- [x] Replace duplicated player/practice verdict logic with one semantic feedback grammar that names the accepted answer or criterion and the learner's next action.
- [x] Preserve a genuine retry before answer reveal, then provide a clear continue action after reveal.
- [x] Provide equivalent feedback meaning through text and accessibility announcements rather than color, haptics, sound, or motion alone.
- [x] Stop model playback before recording and discard an interrupted in-progress take on app/player backgrounding.
- [x] Apply Reduce Motion to the remaining theme, card, sky, and Settings theme transitions touched by PH-03.
- [x] Add and bundle the release privacy manifest and remove the obsolete user-header-path build setting.
- [x] Establish one bounded bundled-course load baseline without profiling unrelated screens.
- [x] Run only the focused PH-03 test class and one optimized Release build; do not run exhaustive UI or full-app regression suites.

## PH-03 delivered behavior

1. **Coherent learning feedback**
   - Chapter lessons and Quick Practice now use the same correct/retry/revealed contract.
   - Correct and revealed states name the accepted answer/order; retry states state the criterion and keep the answer hidden; every state announces the valid next action.
   - Meaning is present in visible text and a combined accessibility label, independent of color, sound, haptics, or animation.

2. **Audio and lifecycle safety**
   - Beginning speech capture stops model playback first. Starting model playback clears an unfinished learner take.
   - Leaving the active app/player stops playback and resets active capture, preventing a partial recording from being counted after an interruption.

3. **Release hardening**
   - Remaining PH-03 motion sites use the shared reduced-motion behavior.
   - `PrivacyInfo.xcprivacy` explicitly declares no tracking or collected-data categories for the current local-only implementation, omits the empty required-reason API key as Apple requires, and is present in the Release bundle.
   - Release configuration disables obsolete recursive user-header searching; the optimized simulator product builds successfully.

## PH-03 focused verification log

| Check | Result | Evidence |
|---|---|---|
| PH-03 semantic feedback, audio handoff/interruption, release posture/privacy, and bounded course-load tests | **4 passed, 0 failed** | `/tmp/aurel-ph03-derived/Logs/Test/Test-Aurel-2026.08.25_16-09-46-+0300.xcresult` |
| Bounded bundled-course load | **Pass: 131 screens loaded in 0.010 s; 2 s ceiling** | Same focused result bundle |
| Optimized Release simulator build | **Pass** | `/private/tmp/aurel-ph03-release/Build/Release-iphonesimulator/Aurel.app` |
| Release privacy/configuration checks | **Pass** | Bundled `PrivacyInfo.xcprivacy`; release-only verification hooks absent; localization catalog and plists parse |
| Scope discipline | **Pass** | No full unit regression, exhaustive renderer walk, all-screen traversal, or broad UI suite was run |

The focused simulator run used iPhone 17 Pro on iOS 26.5. Only `PH03LaunchHardeningTests` ran. The Release target was then built once; no UI test executed.

## PH-03 validation boundary

- App Store products, an account/backend, entitlement policy, legal URLs, notification/email service, widget assets, and support service were not supplied or separately authorized. Their entry points remain honestly unavailable and no corresponding lifecycle proof is claimed.
- The optimized simulator build and bounded load check are engineering evidence, not an Instruments trace on representative real hardware.
- Real-device speech/audio interruptions, manual VoiceOver/Voice Control traversal, independent accessibility/privacy review, and PH-02 adult-learner research still require people/devices outside this implementation pass.
- In accordance with the user's direction, the previously approved app was not re-tested exhaustively.

## PH-02 task checklist

- [x] Place one safe recognition task before goal and pace setup without changing durable course progress.
- [x] Explain lesson duration, first outcome, free scope, and speaking/recording behavior before setup.
- [x] Persist the value-sample checkpoint and outcome; make skip, back, relaunch, and final completion deterministic.
- [x] Keep existing onboarded learners on their established route.
- [x] Make the first goal change the Learn recommendation reason and the 10/20-minute choice change its duration.
- [x] Give Learn, Practice, Progress, and You one explicit, distinct job each.
- [x] Render one Learn recommendation with reason, duration, outcome, and one primary action across pending, due-review, complete, and available-lesson states.
- [x] Derive practice-evidence labels from durable completed-lesson evidence and explain that they are not test scores or permanent mastery.
- [x] Give unavailable chapters and empty milestones an honest, valid next action; retain bundled offline lesson access.
- [x] Add only focused PH-02 unit and UI coverage, then update evidence and traceability.

## PH-02 delivered behavior

1. **Value-first onboarding**
   - Welcome opens a short contextual reply task before goal or pace questions. The task neither records speech nor mutates lesson/streak progress.
   - The next screen states the roughly 20-minute lesson length, natural halfway pause, first practical outcome, Chapter One free/no-account scope, and optional voice behavior.
   - A persisted checkpoint restores partial onboarding. `onboardedAt` is written only when the learner starts the first lesson; existing completed profiles bypass the route.

2. **Observable personalization**
   - The first selected goal supplies the exact reason shown on the Learn recommendation and plan.
   - The 10- or 20-minute pace supplies the recommendation duration. Reminder UI remains truthful to the PH-00 capability gate.

3. **Coherent top-level IA**
   - Learn owns the single recommended next task and path; Practice owns learner-chosen activity; Progress owns evidence plus next improvement; You owns identity, preferences, and local data.
   - The shared recommendation contract always exposes reason, duration, outcome, and a valid destination. Leaderboard routes remain within You for selected-tab semantics.
   - Evidence levels use stable thresholds (`not started`, `introduced`, `practised`, `building`, `repeated`, `well rehearsed`) from completed lessons rather than a fabricated mastery percentage.

4. **State-safe actions**
   - Pending lessons resume, due items review, completed days offer optional practice, completed/free-scope chapters route to practice, and offline Home keeps the bundled next lesson available.
   - Unavailable chapters offer Chapter One practice; empty milestones start the next valid Learn action.

## PH-02 focused verification log

| Check | Result | Evidence |
|---|---|---|
| PH-02 router/derivation tests | **10 passed, 0 failed** | `/tmp/aurel-ph02-derived/Logs/Test/Test-Aurel-2026.08.25_15-39-31-+0300.xcresult` |
| Value-first onboarding + four-tab UI traversal | **2 passed, 0 failed** | `/tmp/aurel-ph02-derived/Logs/Test/Test-Aurel-2026.08.25_15-29-38-+0300.xcresult` |
| PH-02 source strings | **Pass: catalog compiles; 465 total keys** | `Aurel/Resources/Localizable.xcstrings`, `/tmp/aurel-ph02-localization` |
| Scope discipline | **Pass** | Only the new PH-02 logic suite and two PH-02 journeys were run; no full-app regression or exhaustive screen suite was performed |

The focused simulator run used iPhone 17 Pro on iOS 26.5. The project’s existing traditional-headermap warning remains; the focused build introduced no Swift compiler error.

## PH-02 validation boundary

- The engineering route and deterministic behaviors are complete. The plan’s adult-learner comprehension study and independent learning-design/UX approval require real participants and are not represented as completed.
- No analytics backend, remote experiment flag, notification service, account, commerce, widget, or new curriculum was added.
- Broader launch regression was not run. The PH-03 engineering pass instead used a focused audio lifecycle test and retained real-device speech/audio plus independent accessibility review as explicit external boundaries.

## PH-01 task checklist

- [x] Repair the deterministic walker and enforce a bounded unchanged-state failure.
- [x] Add fixtures for every authored renderer kind and every lesson.
- [x] Generate and pin the current 4-chapter / 14-lesson / 131-screen / 29-kind inventory.
- [x] Separate learner display fields from legacy labels, steps, implementation notes, and asset IDs.
- [x] Add forbidden-copy sanitization and a visible UI scan for author IDs.
- [x] Preserve legacy/new decoder compatibility and all stable content IDs.
- [x] Normalize option, tile, pair, sort, speaking, roleplay, and pause interactions so every authored task is operable.
- [x] Add the English source string catalog and pseudolanguage QA route.
- [x] Establish semantic surface/action/state/tab contracts.
- [x] Run renderer-family AX3XL, Increase Contrast, Reduce Motion, and boundary-device checks.
- [x] Build Release, scan fixture hooks, run unit/smoke/milestone/all-lesson regressions, and visually approve screenshots.
- [x] Update PH-01 traceability/evidence and stop at its then-current approval boundary.

## PH-01 delivered behavior

1. **Exhaustive authored traversal**
   - `CourseStore` exposes deterministic first-occurrence fixtures for all 29 authored kinds and all 14 lessons.
   - The walker completes option tasks, exact/partial tile keys, option-backed tiles, pairs, sorting, pause choices, and roleplay safely.
   - Exact answer labels take precedence over substring matches, eliminating the `to`/`too` stall that caused ISS-010.

2. **Learner/display contract**
   - All 131 screens carry `displayTitle`; legacy author fields remain debug metadata and decoder compatibility remains intact.
   - `CourseTextContract` removes or rejects course, audio, illustration, roleplay, screen-range, dependency, prototype, and production notes.
   - Renderer UI has an automated zero-visible-author-ID gate. Orientation, conversation, review, roleplay, and testlet author notes now render as learner guidance.

3. **Components, accessibility, and localization**
   - Ten renderer families map to named surface/action/state roles.
   - Selected/matched states expose text and accessibility traits rather than color alone; controls and tabs have stable semantic identifiers.
   - Reduce Motion is honored through shared motion behavior.
   - `Localizable.xcstrings` contains 410 English-source keys, compiles successfully, and is exercised through pseudolanguage at AX3XL.

4. **Durable evidence**
   - The generated inventory, component catalog, schema migration map, per-kind screenshots, verification record, and current traceability matrix live in [`evidence/phases/PH-01`](evidence/phases/PH-01/README.md).

## PH-01 verification log

| Check | Result | Evidence |
|---|---|---|
| Optimized Release simulator build | **Pass** | `/tmp/aurel-ph01-release-final-v7/Build/Products/Release-iphonesimulator/Aurel.app` |
| Full unit regression | **111 passed, 0 failed** | `/tmp/PH01-Unit-Final-v6.xcresult` |
| Renderer coverage | **4 passed, 0 failed; 29/29 kinds** | `/tmp/PH01-Renderer-Final-v5.xcresult` |
| Clean-state SmokeSuite | **4 passed, 0 failed** | `/tmp/PH01-Smoke-And-Milestones-Final-v6.xcresult` |
| Existing milestones 1–6 | **6 passed, 0 failed** | `/tmp/PH01-Smoke-And-Milestones-Final-v6.xcresult` |
| Compact boundary, iPhone 17e | **2 passed, 0 failed** | `/tmp/PH01-AX-Compact-Final-v5.xcresult` |
| Large boundary, iPhone 17 Pro Max | **2 passed, 0 failed** | `/tmp/PH01-AX-Large-Final-v5.xcresult` |
| All 14 lessons / 131 screens | **1 passed, 0 failed; 14/14 lessons, 131/131 screens** | `/tmp/PH01-AllLessons-Final-v6.xcresult` |
| String catalog | **Pass: 410 keys; no author IDs** | `Aurel/Resources/Localizable.xcstrings` |
| Release fixture-hook scan | **Pass: hooks absent** | Final optimized executable |

## PH-00 task checklist

- [x] Reconfirm approved recommendation IDs, exclusions, prerequisites, and affected screen/state matrix.
- [x] Preserve Stage 1 before screenshots and build/test baseline.
- [x] Add an explicit capability model with release-safe defaults and tests.
- [x] Remove or disable unavailable account, commerce, notifications/email, widget, and support affordances without implying a roadmap.
- [x] Sanitize legacy prototype identity, entitlement, and delivery state without removing learning progress.
- [x] Implement verified local delete/cancel/disk-relaunch behavior and separate truthful sign-out semantics.
- [x] Enforce on-device-only recognition and test unsupported/denied alternatives plus temporary-file cleanup.
- [x] Make SCR-019/SCR-020 content and controls safe-area-aware.
- [x] Adjust the primary CTA pair to pass the 4.5:1 normal-text threshold.
- [x] Add focused unit/UI regression protection for capability state, deletion, speech, contrast, and safe geometry.
- [x] Build Release and run focused plus existing regression suites.
- [x] Inspect affected routes across boundary devices, appearance/text/contrast/motion configurations and capture after evidence.
- [x] Review the diff, preserve pre-existing work, and stop before PH-01.

## Delivered behavior

1. **Truthful release capabilities**
   - `AppCapabilities.release` is the only product default.
   - Verification launch hooks and seeded preview state compile only with the Debug `AUREL_VERIFICATION` condition and are absent from the Release binary.
   - Existing prototype `email`, `isPro`, reminder/notification, and weekly-email state is ignored and sanitized when the corresponding service is unavailable.
   - Welcome/profile/settings/home no longer expose actionable service claims in release.
   - Direct legacy paywall/account routes render a truthful availability explanation with one safe back action; no purchase, restore, sign-in, or account-creation result is simulated.

2. **Local data lifecycle**
   - “Delete local data” uses an explicit destructive alert.
   - Confirmation deletes `LearnerProfile`, `DayLog`, `LessonRecord`, and `MistakeItem`, saves the transaction, resets in-memory state, and returns to Welcome.
   - A disk-backed relaunch test proves deleted identity, settings, lesson, day, and mistake data do not return; normal launch creates only a fresh guest profile.
   - Cancellation changes nothing. Sign-out clears account/session fields while retaining learning data.

3. **Speech privacy**
   - Speech capture and transcription both require authorized on-device recognition and set the system request to on-device-only.
   - Unsupported recognition never starts the recorder and records zero takes.
   - Temporary take files are discarded on failure, reset/cancel, and completed checks.
   - Microphone and speech-recognition purpose strings now describe the exact fallback and file lifecycle.

4. **Safe geometry and accessibility**
   - Full-bleed course art is preserved; paywall/account content respects the system safe area.
   - The release fallback component scrolls at large text sizes and keeps its CTA within the window.
   - Primary buttons, selected tabs, open lesson nodes, and the Home day CTA use the accessible copper role.
   - The primary warm-white/accent-700 pair measures **6.47:1** in light and dark against a **4.5:1** gate.

## Files changed by PH-00

| File | PH-00 change | Existing-work note |
|---|---|---|
| `Aurel/App/AppEnvironment.swift` | Release capability model and environment injection | PH-00 only |
| `Aurel/App/AppRouter.swift` | Capability sanitization/gates; local deletion; sign-out; truthful service errors | PH-00 only |
| `Aurel/App/RootView.swift` | Safe-area routing contract for paywall/account routes | PH-00 only |
| `Aurel/DesignSystem/Components/Components.swift` | Truthful unavailable-state component; primary action token adoption | PH-00 only |
| `Aurel/DesignSystem/Components/Shared.swift` | Accessible selected-tab action role | PH-00 only |
| `Aurel/DesignSystem/DesignTokens.swift` | Semantic primary fill/border and darker primary gradient | PH-00 only |
| `Aurel/Features/Home/HomeView.swift` | Non-actionable unavailable chapters and truthful lock explanation; accessible CTA role | Overlaps pre-existing user visual edits; those edits were preserved |
| `Aurel/Features/Login/LoginView.swift` | Truthful account-unavailable route | PH-00 only |
| `Aurel/Features/Onboarding/OnboardingViews.swift` | Reminder controls gated; release copy states that reminders are not scheduled | PH-00 only |
| `Aurel/Features/Onboarding/WelcomeView.swift` | Sign-in entry points gated | PH-00 only |
| `Aurel/Features/Progress/ProgressProfileSettingsPaywall.swift` | Profile/settings gates, local deletion UI, safe paywall/account fallbacks | Overlaps pre-existing user theme work; that work was preserved |
| `Aurel/Services/Services.swift` | On-device speech eligibility and pre-capture enforcement | PH-00 only |
| `Aurel/Support/Info.plist`, `project.yml` | Aligned microphone/speech purpose strings; declared the Debug-only verification condition | PH-00 only |
| `Aurel.xcodeproj/project.pbxproj` | Applied the generated Debug-only verification condition to the checked-in project | PH-00 only |
| `AurelTests/AppRouterTests.swift` | Release account/commerce assertions and speech seam | PH-00 only |
| `AurelTests/DesignTokenTests.swift` | Primary contrast hard gate and evidence generation | PH-00 only |
| `AurelTests/Stage5SpeakTests.swift`, `AurelTests/Stage6PlayerTests.swift` | Unsupported speech, take count, cleanup, reset, and player coverage | PH-00 only |
| `AurelTests/Stage7AccountTests.swift` | Capability, legacy-state migration, delete/cancel/disk-relaunch, and sign-out tests | PH-00 only |
| `AurelUITests/MilestoneSuite.swift` | Unavailable chapter and safe-frame boundary tests | PH-00 only |
| `AurelUITests/SmokeSuite.swift` | Truthful reminder-free onboarding path and updated speech contract | PH-00 only |
| `qa/evidence/token-contrast.json` | Regenerated contrast evidence | PH-00 only |
| `docs/product-audit/04_IMPLEMENTATION_TRACKER.md`, `docs/product-audit/evidence/after/*` | Implementation record and after-state evidence | PH-00 only |

Pre-existing changes in `ArcSkyView.swift`, `AUIcon.swift`, and `QuickPracticeViews.swift` were not part of PH-00 and were left intact. The pre-existing portions of `HomeView.swift` and `ProgressProfileSettingsPaywall.swift` were also preserved.

## Verification log

| Check | Result | Evidence |
|---|---|---|
| Optimized Release simulator build | **Pass** | `/tmp/aurel-ph00-release/Build/Products/Release-iphonesimulator/Aurel.app` |
| Full unit regression | **100 passed, 0 failed** | `/tmp/aurel-ph00-derived/Logs/Test/Test-Aurel-2026.08.25_00-02-42-+0300.xcresult` |
| Clean-state SmokeSuite | **4 passed, 0 failed** | `/tmp/aurel-ph00-derived/Logs/Test/Test-Aurel-2026.08.25_00-04-03-+0300.xcresult` |
| Focused MilestoneSuite: AX hittability, unavailable chapter, safe release routes | **3 passed, 0 failed** | `/tmp/aurel-ph00-derived/Logs/Test/Test-Aurel-2026.08.24_23-51-02-+0300.xcresult` |
| Post-hardening unavailable-route UI check | **1 passed, 0 failed** | `/tmp/aurel-ph00-derived/Logs/Test/Test-Aurel-2026.08.25_00-05-32-+0300.xcresult` |
| iPhone 17e, 390×844, AX3XL | **Pass** | `/tmp/aurel-ph00-ax-17e/Logs/Test/Test-Aurel-2026.08.24_23-41-17-+0300.xcresult` |
| iPhone 17e, 390×844, safe capability routes | **Pass** | `/tmp/aurel-ph00-ax-17e/Logs/Test/Test-Aurel-2026.08.24_23-42-47-+0300.xcresult` |
| iPhone 17 Pro Max, 440×956, AX3XL | **Pass** | `/tmp/aurel-ph00-derived/Logs/Test/Test-Aurel-2026.08.24_23-42-12-+0300.xcresult` |
| iPhone 17 Pro Max, 440×956, safe capability routes | **Pass** | `/tmp/aurel-ph00-derived/Logs/Test/Test-Aurel-2026.08.24_23-43-11-+0300.xcresult` |
| iPhone 17, light + Increase Contrast + Reduce Motion | **Pass** | `/tmp/aurel-ph00-derived/Logs/Test/Test-Aurel-2026.08.24_23-46-39-+0300.xcresult` |
| Primary CTA contrast | **Pass: 6.47:1 light/dark** | [`qa/evidence/token-contrast.json`](../../qa/evidence/token-contrast.json) |
| Release verification-hook scan | **Pass: hooks absent from optimized binary** | `AUREL_TEST_START`, `AUREL_SCREEN`, and `midJourneyPreview` not present in the Release executable |
| Whitespace/error check | **Pass** | `git diff --check` produced no findings |

The only build warning is the project’s pre-existing “traditional headermap style” warning. No new Swift compiler warning remains.

## Manual and visual matrix

| Configuration | Routes/states | Result |
|---|---|---|
| iPhone 17, 402×874, dark/default text | Commitment, Home, Say, Profile, Settings, unavailable paywall/account | Visually reviewed; no clipping, false actionable service, or system-chrome collision found |
| iPhone 17, light, Increase Contrast, Reduce Motion | Settings and unavailable capability routes | Visually and automatically checked; content/CTA remain readable and contained |
| iPhone 17e, 390×844, AX3XL | Settings and unavailable paywall | Visually and automatically checked; content scrolls and actions remain reachable |
| iPhone 17 Pro Max, 440×956, default and AX3XL | Unavailable paywall/account route frames | Automated frame containment and hittability pass |
| Keyboard shown | Release account/subscription forms are unavailable and contain no text fields | Not applicable to the shipping PH-00 path; legacy service form remains unreachable |

After screenshots and capture metadata are indexed in [`evidence/after/README.md`](evidence/after/README.md).

## Defects and deviations discovered during PH-00

- **Closed — destructive-row target:** The local-data row needed an explicit full-width, 52 pt target. It now has that target and a stable accessibility identifier.
- **Closed — disk relaunch expectation:** A fresh launch creates a default guest profile during normal day initialization. The deletion contract and test now correctly require the old identity/settings/learning rows to remain absent while permitting that empty guest record.
- **No open PH-00 P0 implementation finding** was observed in the tested simulator scope.
- **Closed in PH-01 — ISS-010:** the walker now uses exact-label precedence, deterministic structured-task handling, and bounded progress checks. All authored lessons complete.

## Validation limits before launch

- Simulator tests cannot replace the REC-004 real-device speech/network/privacy review or audio-interruption testing. A privacy/iOS speech specialist should validate this before launch.
- Automated accessibility trees, labels, frames, target sizes, AX3XL, Increase Contrast, and Reduce Motion were checked. A complete manual VoiceOver/Voice Control traversal and independent accessibility review remain launch work under REC-006/PH-03.
- Delete/cancel/disk-relaunch behavior is automated at the router/SwiftData layer and the native alert wiring was source-reviewed. Direct XCUI activation of the destructive alert buttons was not retained because the bottom settings-row interaction was unstable in the simulator harness; a dedicated stable fixture should be added before release.

## Deferred work

- Real StoreKit, remote accounts/backend, notifications/email, widget extension, and support service remain conditional follow-on integrations. They require a new DEC-001 scope decision plus product/service/legal configuration; their current release entry points remain unavailable.
- Additional launch locales and curriculum translation require DEC-004; the English catalog and pseudolanguage foundation are complete.
- Adult-learner comprehension research for the PH-02 route remains an external validation gate; the deterministic engineering route is implemented.

## Review gate

PH-03 is ready for user review for the authorized local-first scope. Enabling any external account, commerce, re-engagement, widget, or support capability requires its concrete service configuration and separate scope approval; until then, the release-safe unavailable state is the approved rollback and shipping posture.
