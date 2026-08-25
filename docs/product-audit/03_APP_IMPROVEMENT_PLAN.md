# Aurel app improvement plan

Plan date: 2026-08-24  
Status: **Approved; PH-00–PH-03 implemented for the authorized local-first scope — see `04_IMPLEMENTATION_TRACKER.md`**  
Inputs: `01_CURRENT_APP_STATE.md` findings ISS-001–ISS-014 and `02_DESIGN_BENCHMARK_RESEARCH.md` patterns PAT-001–PAT-012

## Method, environment, and limitations

- **Observed input:** The current build, runtime evidence, test baseline, source architecture, course bank, and coverage limitations are recorded in Stage 1.
- **Observed input:** Current platform/product references and their limitations were verified online on 2026-08-24 and recorded in Stage 2. The supplemental authenticated Mobbin pass completed 37 targeted searches and mapped all five Aurel flows, 20 router screens, 34 material states, six screen families, and 29 authored presentation kinds; gallery limitations remain explicit.
- **Plan contract:** This document specifies outcomes, dependencies, acceptance criteria, and verification; implementation status and evidence are recorded separately in `04_IMPLEMENTATION_TRACKER.md`.
- **Unknown:** Production backend, App Store Connect products, support/legal destinations, notification policy, widget scope, launch locales, and real-device speech privacy requirements were not supplied. The plan isolates these as decisions rather than inventing them.
- **Historical baseline:** Renderer-wide runtime baselines were incomplete because of ISS-010. PH-01 closed that defect and established the required baselines; the original risk remains part of the audit record.
- **Effort scale:** S = roughly ≤2 focused engineering days; M = roughly 3–7 days; L = more than one focused week. These are order-of-magnitude estimates, not commitments, and exclude external review/asset/legal lead time.

## Executive diagnosis

### Preserve

- **Observed:** Aurel’s Caprasimo/Figtree editorial voice, arc/daylight/desert metaphor, copper/cream/espresso palette, and cinematic learning art are specific and recognizable.
- **Observed:** The learning model is coherent: practical outcomes, guided-to-independent practice, widening review, optional speech, clarity-not-accent framing, grace days, and non-punitive streak language.
- **Observed:** Bundled content, SwiftData durability/recovery, explicit empty states, large controls, Dynamic Type infrastructure, reduced-motion mapping, and sound/haptic gates are strong foundations.

### Most important gaps

1. **Observed — trust/safety:** account, subscription, restore, delete, reminders, notifications, weekly email, widget, help, and voice privacy copy do not match executable capability (ISS-001–ISS-004, ISS-006, ISS-014).
2. **Observed — primary-flow geometry/accessibility:** paywall/account controls collide with system chrome and repeated CTA contrast is 4.26:1 (ISS-005, ISS-009).
3. **Observed — learning/content integrity:** internal authoring IDs and production notes are learner-facing, while localization infrastructure is absent (ISS-007, ISS-008).
4. **Observed — regression confidence:** the second-lesson walker is broken and 22/29 authored presentation kinds are not runtime-verified (ISS-010, ISS-013).
5. **Inferred — hierarchy/system:** dense card/pill repetition gives unrelated content similar weight and makes bespoke screens harder to govern (ISS-012).

### Root causes versus symptoms

| Root cause | Evidence | Symptoms |
|---|---|---|
| Prototype state is presented through production-strength copy/controls | ISS-001–ISS-004, ISS-006, ISS-014 | False subscription/account/delete/notification/widget/help/privacy outcomes |
| Global physical-stage layout overrides safe areas | Root source + ISS-005 | Paywall bottom and account top collisions; bottom overlay risk |
| Stable authoring identifiers are not separated from display content | ISS-007–ISS-008 | IDs/ranges/production notes visible; no localization boundary |
| Renderer growth outpaced end-to-end fixture coverage | 29 kinds/131 screens + ISS-010/ISS-013 | Low course runtime coverage and uncertain state accessibility |
| Feature-local styling grew without a strict semantic surface hierarchy | ISS-012 and feature source | Many cards/pills/opacity variants with flattened emphasis |

### Why some surfaces feel prototype-generated

This is not caused by the core visual identity. **Observed:** the strongest prototype impression comes from literal implementation vocabulary (`A1-C03-RP001`, screen ranges, “production-ready,” “placeholders”), controls whose named result does not exist, and geometry that ignores system chrome. **Inferred:** adding decorative effects would amplify rather than resolve that impression. A coherent product feels authored when language, service state, layout, and feedback agree.

### Smallest coherent direction

**Proposed:** “A calm, editorial English practice that always tells the truth about today’s task.” Preserve the arc/daylight story and adult tone; make one next action unmistakable; reserve rich scene art for learning moments; reduce surface equivalence; use real iOS capability/state; and make every course renderer pass the same responsive/accessibility contract with a stable position→instruction→answer→feedback→next-action frame.

### Explicitly out of scope

- Replacing the Aurel brand, font families, core desert/arc visual identity, or learning pedagogy without separate evidence
- Copying competitor layouts, illustrations, animation, or gamification
- Adding currencies, hearts, shame-based streak loss, manipulative urgency, or fabricated social proof
- Expanding beyond iPhone, creating new A2+ curriculum, rewriting pedagogical content at scale, or commissioning final art/audio within this plan
- Selecting vendors, legal terms, pricing, tax treatment, or privacy policy without user/legal/product authority
- Implementing any recommendation before the approval gate

## Current-versus-target assessment

No single score is used because the dimensions are not interchangeable.

| Dimension | Current assessment | Evidence | Target outcome | Gap | Confidence |
|---|---|---|---|---|---|
| Product clarity | Strong daily-course idea; prototype/service and internal language leak | ISS-001, 003, 004, 006, 007 | Every label describes an observable learner outcome/capability | High trust/content gap | High |
| Learning-flow effectiveness | Strong scaffold and review concept; incomplete renderer/runtime evidence | First lesson pass; 7/29 kinds; ISS-010 | All authored kinds complete, recover, and lead to an explicit next action | High verification gap | High |
| Visual coherence/distinctiveness | Distinctive identity; dense surfaces flatten hierarchy | Preserved strengths, ISS-012 | Same identity with a smaller semantic surface set and clearer emphasis | Medium system gap | Medium |
| Interaction/feedback | Large controls, clear basic states; inert/false controls and safe-area collisions | ISS-001–006 | Every affordance has a truthful, immediate, recoverable result | Critical gap | High |
| Accessibility/inclusion | Dynamic Type/Reduce Motion foundations and AX3XL passes; contrast/semantics breadth incomplete | ISS-005, 009, 013 | All core flows pass defined contrast, semantics, input, motion, and boundary matrix | High gap | High |
| Content integrity/adult voice | Calm and adult; authoring/production terms leak; no localization path | ISS-007, 008 | Governed learner vocabulary, localization-ready strings/content, no internal IDs | High content-system gap | High |
| Platform fit | SwiftUI/SwiftData, sharing, permissions, recovery; commerce/delete/notification/widget/safe areas are nonfunctional or nonnative | ISS-001–005 | Real iOS capability and state drive each platform-facing surface | Critical gap | High |
| Performance/reliability | Build/units/smoke/first lesson pass; broader traversal/profiling absent | Baseline, ISS-010, ISS-013 | Complete renderer regression matrix and profiled boundary journeys | Medium-high evidence gap | High |
| Trust/privacy/monetization | Free scope is clear; paid/account/delete/voice claims are unsafe | ISS-001, 002, 014 | Verifiable account/commerce/data behavior and appropriately qualified privacy copy | Critical gap | High |
| System/content scalability | Typed bank and components exist; runtime/state coverage and localization lag | 131 screens, 29 kinds, ISS-008, 010–013 | Every kind uses governed display fields/components/fixtures and future content enters the same checks | High governance gap | High |

## Recommendation contracts

### REC-001 — Put every unavailable capability behind a truthful product-state gate

- **Status:** Proposed
- **Priority:** P0
- **Addresses:** ISS-001, ISS-003, ISS-004, ISS-006; PAT-005
- **Affected flows/screens/components:** F-001, F-005; SCR-003, SCR-005, SCR-017–SCR-020; router capability state and rows/CTAs
- **Problem:** Active-looking controls promise account, purchase, restore, notifications/email, widget, and support results that the current app cannot produce.
- **Desired outcome:** A user can never trigger or rely on a named service that is unavailable in the running build.
- **Proposed change:** Add explicit capability states (`available`, `unavailable`, `prototype/test` excluded from release). In release UI, hide unavailable commerce/account entry points or show a noninteractive, plainly labeled availability explanation. Replace reminder/notification/widget/help claims with only capabilities authorized for the build. Do not use “coming soon” unless a release commitment exists.
- **Preserve:** Chapter 1 free access, current visual voice, existing settings organization where the underlying capability is real.
- **Rationale:** Truthful state is required before persuasive polish; PAT-005 and Apple policy treat capability as behavior, not copy.
- **Evidence:** ISS-001/003/004/006; Apple App Review and HIG In-app Purchase sources in Stage 2.
- **Dependencies:** User decision DEC-001 for long-term production-service scope; PH-00 can safely gate without that decision.
- **Risks and trade-offs:** Short-term UI may expose fewer features; avoid suggesting roadmap certainty.
- **Acceptance criteria:** (1) Release build contains no actionable sign-in/subscribe/restore/notify/email/widget/help control without an executable result; (2) capability state is covered by unit/UI tests; (3) verification-route/test fixtures cannot leak into release state.
- **Verification method:** Repository capability inventory; UI traversal in available/unavailable fixtures; automated assertion that release config excludes prototype state.
- **Effort:** M
- **Confidence:** High — direct source/runtime evidence
- **Expert validation required:** Yes — product owner for launch scope; legal only if user-facing commitments remain

### REC-002 — Implement a verifiable local/account deletion and sign-out contract

- **Status:** Proposed
- **Priority:** P0
- **Addresses:** ISS-002; PAT-005
- **Affected flows/screens/components:** F-005; SCR-017, SCR-018, SCR-001; SwiftData and future account client
- **Problem:** Delete confirms erasure but only navigates; sign out preserves local identity state.
- **Desired outcome:** Confirmation produces the exact declared deletion result, and sign out reliably clears account credentials/session without falsely deleting learning data.
- **Proposed change:** Define local-only versus remote-account semantics. For local mode, delete all Aurel models/preferences and recreate a guest profile after explicit confirmation. For a future remote account, delete/queue the server account plus local data and expose truthful pending/failure states. Separate “Sign out” from “Delete account.”
- **Preserve:** Confirmation before destructive action and clear description of consequences.
- **Rationale:** Deletion is a privacy operation and must be observable and testable.
- **Evidence:** ISS-002; Apple account-deletion guidance.
- **Dependencies:** DEC-001; data-retention/legal policy if remote accounts are approved.
- **Risks and trade-offs:** Irreversible local loss; transaction/subscription records may need separate explanatory handling.
- **Acceptance criteria:** (1) Seeded models/preferences are absent after confirmed local deletion and relaunch; (2) cancellation changes nothing; (3) sign out clears only defined session/account fields; (4) failure/pending messaging matches actual state.
- **Verification method:** In-memory and disk SwiftData tests, UI confirmation/cancel/delete/relaunch test, remote contract tests if applicable.
- **Effort:** M
- **Confidence:** High — behavior and policy are explicit
- **Expert validation required:** Yes — privacy/legal for remote retention; product for guest-progress policy

### REC-003 — Make the subscription surface StoreKit-driven or remove it from release

- **Status:** Proposed
- **Priority:** P0
- **Addresses:** ISS-001, ISS-005; PAT-005
- **Affected flows/screens/components:** F-005; SCR-019, SCR-020, profile/home locked states; entitlement model
- **Problem:** Paywall/restore/account copy represents an App Store transaction while local booleans grant Pro.
- **Desired outcome:** Paid access, pricing, period, eligibility, purchase, restore, pending, cancellation, failure, and entitlement are driven by real store/account state—or no purchase UI ships.
- **Proposed change:** If commerce is approved, integrate StoreKit products/transactions and an entitlement source of truth; render localized `displayPrice`, duration, benefits, legal links, restore/sign-in, ineligible/offline/pending/error states; remove the local `pro = true` shortcut. If not approved, remove paywall/restore/subscription claims and keep the later chapters honestly locked/unavailable or free per product decision.
- **Preserve:** Chapter 1 free experience, two-plan comparison only if products exist, benefit-led Aurel styling.
- **Rationale:** Apple’s purchase contract requires functional, localized, recoverable transactions.
- **Evidence:** ISS-001/005; PAT-005; Apple HIG In-app Purchase/App Review Guidelines.
- **Dependencies:** DEC-001, App Store Connect products, legal URLs, account/entitlement policy.
- **Risks and trade-offs:** StoreKit and server-account synchronization add state complexity; a local-only entitlement may not satisfy cross-device product intent.
- **Acceptance criteria:** (1) No hard-coded/fabricated price or entitlement; (2) sandbox purchase/restore/pending/cancel/failure tests pass; (3) already-entitled users are not offered duplicate subscription; (4) legal links resolve; (5) release fallback when products are unavailable is truthful.
- **Verification method:** StoreKit test configuration, sandbox matrix, UI tests, entitlement persistence/relaunch, manual App Store copy review.
- **Effort:** L
- **Confidence:** High on need, Medium on scope pending architecture
- **Expert validation required:** Yes — commerce/product/legal/backend

### REC-004 — Align voice-data behavior and permission copy

- **Status:** Proposed
- **Priority:** P0
- **Addresses:** ISS-014; PAT-003, PAT-005
- **Affected flows/screens/components:** F-002/F-004; SCR-007, SCR-014; `Info.plist`, `SpeechToText`, speaking states
- **Problem:** The purpose string guarantees on-device recognition while code requires it only when supported.
- **Desired outcome:** The system either enforces on-device-only recognition or clearly discloses the actual behavior before capture, while optional alternatives remain equal.
- **Proposed change:** Choose a privacy contract. Preferred safe default: if on-device recognition is unsupported, do not start recognition; record no take or provide an unscored rehearsal/type path. Align permission and in-context copy exactly with behavior. Preserve temporary-file deletion and fail-soft states.
- **Preserve:** Permission-on-action, type/skip alternatives, no accent score, calm denial/recovery.
- **Rationale:** Speech data is sensitive; a conditional API cannot support an unconditional claim.
- **Evidence:** ISS-014; Apple Privacy guidance; Babbel/Busuu limitation disclosure patterns.
- **Dependencies:** DEC-003; real-device platform/privacy verification.
- **Risks and trade-offs:** On-device-only may reduce supported devices/locales; broader recognition requires a materially different privacy disclosure/consent architecture.
- **Acceptance criteria:** (1) Purpose and in-app copy match executable code; (2) unsupported recognition never silently uses a broader path; (3) recorded files are deleted on success/failure/cancel; (4) denial/unavailable alternatives complete the task.
- **Verification method:** Injected capability unit tests, denied/unsupported UI tests, real-device packet/privacy review, temp-file lifecycle test.
- **Effort:** M
- **Confidence:** High on mismatch, Medium on chosen contract pending decision
- **Expert validation required:** Yes — privacy and iOS speech specialist

### REC-005 — Replace physical-edge assumptions with a tested safe-area layout contract

- **Status:** Proposed
- **Priority:** P0
- **Addresses:** ISS-005; PAT-006, PAT-009
- **Affected flows/screens/components:** All, immediately SCR-019/SCR-020 and custom tab/bottom CTAs; `RootView`, screen containers
- **Problem:** Root-level safe-area ignoring lets system status/home chrome intersect controls.
- **Desired outcome:** No actionable or essential text intersects system chrome on any supported iPhone/text/appearance configuration.
- **Proposed change:** Keep decorative backgrounds edge-to-edge but move content/control geometry into safe-area-aware containers. Define shared top navigation, scroll, sticky CTA, and tab-inset primitives. Reserve actual tab/keyboard/home-indicator space rather than screen-specific magic padding.
- **Preserve:** Full-bleed course/welcome art and custom tab identity.
- **Rationale:** Decoration can ignore safe areas; content and actions should not. A shared contract removes repeated compensation.
- **Evidence:** ISS-005 screenshots; Apple Layout/Tab Bars guidance.
- **Dependencies:** None for PH-00 fixes; component consolidation in PH-01.
- **Risks and trade-offs:** Visual alignment shifts; course art crop must be reviewed rather than globally inset.
- **Acceptance criteria:** (1) SCR-019/020 collisions are absent at 390×844 and 440×956; (2) all scroll ends expose content above tab/home/keyboard; (3) full-bleed art remains intentional; (4) snapshot/frame tests cover safe-area primitives.
- **Verification method:** Small/common/large iPhone matrix, default/AX3XL, light/dark, keyboard shown, frame-containment UI assertions and screenshots.
- **Effort:** M
- **Confidence:** High — direct visual evidence and known root policy
- **Expert validation required:** No

### REC-006 — Gate core contrast and accessibility semantics in the design system

- **Status:** Proposed
- **Priority:** P0
- **Addresses:** ISS-009, ISS-013; PAT-006
- **Affected flows/screens/components:** All primary buttons, tabs, custom controls, charts, player renderers; tokens and tests
- **Problem:** Repeated CTA contrast is 4.26:1 and current AX automation establishes hittability, not semantic completeness.
- **Desired outcome:** Core tasks meet defined contrast, semantics, non-color, target, Dynamic Type, and motion criteria by default.
- **Proposed change:** Adjust the accent/on-accent semantic pair to ≥4.5:1 for normal button text in light/dark and define increased-contrast variants. Make accessibility labels/values/traits, Voice Control names, reading groups, and Reduce Motion states required component/renderer contracts. Turn exact contrast and selected semantic checks into gating tests.
- **Preserve:** Copper role and warm-white visual character; large targets and existing AX labels.
- **Rationale:** System-level variants fix repeated defects once and PAT-006 requires breadth beyond a single AX size.
- **Evidence:** ISS-009/013; Apple Accessibility/Typography/contrast criteria; 2025/2026 award citations.
- **Dependencies:** Token/component work in PH-01; DEC-002 only affects OS matrix, not thresholds.
- **Risks and trade-offs:** Color shifts can alter art harmony; custom font scaling may change density.
- **Acceptance criteria:** (1) Normal CTA text ≥4.5:1 in default light/dark; (2) nontext state cues ≥3:1 where applicable and not color-only; (3) core flow VoiceOver/Voice Control audits have no unlabeled, duplicate, or illogical-order blockers; (4) Reduce Motion removes axis/depth/ambient repetition; (5) AX sizes preserve content/task completion.
- **Verification method:** Token contrast tests, Accessibility Inspector, VoiceOver/Voice Control manual scripts, UI frame/label tests, Reduce Motion screenshots.
- **Effort:** L
- **Confidence:** High — exact token evidence and official criteria
- **Expert validation required:** Yes — accessibility review for representative renderer families

### REC-007 — Restore renderer-wide end-to-end evidence before broad visual refactoring

- **Status:** Proposed
- **Priority:** P1
- **Addresses:** ISS-010, ISS-013; PAT-006, PAT-011
- **Affected flows/screens/components:** F-002; SCR-007; `MilestoneSuite`, 29 course kinds, evidence tooling
- **Problem:** The order helper loops and only 7/29 authored kinds complete an end-to-end runtime walk.
- **Desired outcome:** Every authored kind has a deterministic fixture/state test and every lesson/chapter has a bounded completion path.
- **Proposed change:** Correct walker sequencing so selecting an order can advance; add deterministic per-kind fixture entry, correct/incorrect/retry/skip/restore cases, stall signatures that include selection state, and screenshot/AX evidence for each renderer family. Keep content-bank decode/count checks.
- **Preserve:** Stable accessibility identifiers, authored answer-key approach, bounded timeouts, current smoke tests.
- **Rationale:** Shared visual/component work is unsafe when most content presentations cannot be traversed reliably.
- **Evidence:** ISS-010/013 and combined 59.0% coverage; Stage 2 Mobbin renderer-family pass shows repeated stable lesson-region patterns across Duolingo, Babbel, and Speak but does not validate Aurel's runtime behavior.
- **Dependencies:** None; first PH-01 task.
- **Risks and trade-offs:** Tests can overfit content wording; fixtures must target contracts, not pixel-exact art.
- **Acceptance criteria:** (1) Existing MilestoneSuite passes without retry; (2) all 29 authored kinds launch/advance/exit through deterministic fixtures; (3) every lesson completes or yields a named content defect; (4) stalls attach state/tree/screenshot within a bounded limit.
- **Verification method:** Unit decoder/model suite, per-kind UI suite, lesson/chapter walkers on 17e and one common device, selected Pro Max AX run.
- **Effort:** L
- **Confidence:** High — failure cause is directly observed
- **Expert validation required:** No; pedagogy review only for answer-key fixture assumptions

### REC-008 — Establish learner-facing content fields and localization boundaries

- **Status:** Proposed
- **Priority:** P1
- **Addresses:** ISS-007, ISS-008, ISS-011; PAT-008
- **Affected flows/screens/components:** F-001–F-005; onboarding, home, practice/scene, paywall, all course schemas; QA docs
- **Problem:** IDs, screen ranges, dependency/production notes leak into UI and strings cannot be localized systematically.
- **Desired outcome:** Stable internal traceability remains intact while every displayed label is learner-facing, localizable, and content-reviewed.
- **Proposed change:** Separate `id`, `displayTitle`, `outcome`, `duration`, `instruction`, and debug/support metadata in content models. Move shell copy to a string catalog and define course-localization strategy. Remove `A1-C03-RP001`, `S27–S28`, “dependency graph,” “production-ready,” and placeholder commentary from release UI. Update QA traceability from the same inventory source.
- **Preserve:** Stable screen/content IDs in JSON, tests, analytics/evidence; calm adult voice; specific skill/outcome language.
- **Rationale:** Internal stability and learner clarity are compatible only when they are separate fields.
- **Evidence:** ISS-007/008/011; PAT-008.
- **Dependencies:** DEC-004 launch locales; content/editorial owner; schema migration compatibility.
- **Risks and trade-offs:** JSON migration touches 131 screens; localization of curriculum has pedagogical implications beyond UI translation.
- **Acceptance criteria:** (1) Release UI search finds no forbidden authoring/production tokens; (2) every shell string is cataloged; (3) every content display field has validation and fallback; (4) pseudolanguage reveals no clipping/blocker; (5) traceability counts are generated/verified against current router/bank.
- **Verification method:** Schema/decode tests, forbidden-copy lint, pseudolocalization UI matrix, editorial review, generated inventory diff.
- **Effort:** L
- **Confidence:** High on gap, Medium on curriculum-localization scope
- **Expert validation required:** Yes — language pedagogy/editorial/localization

### REC-009 — Consolidate semantic surfaces, controls, and navigation hierarchy

- **Status:** Proposed
- **Priority:** P1
- **Addresses:** ISS-012; PAT-007, PAT-009
- **Affected flows/screens/components:** SCR-006, SCR-011, SCR-012, SCR-016–SCR-019; design tokens/components/tab bar
- **Problem:** Many unrelated hierarchy levels share similarly large cards, pills, strokes, and elevation, while feature-local variants bypass shared component state.
- **Desired outcome:** A learner can distinguish primary action, navigation, selectable task, information, status, and sample/empty content before reading every label.
- **Proposed change:** Define a limited semantic surface set (canvas, section, task card, selected task, inset info, modal), action hierarchy (primary, secondary, text, destructive), and state variants. Keep the four labeled tabs and reserve their geometry. Migrate feature-local copies to components only where behavior/state genuinely matches; do not homogenize learning art.
- **Preserve:** Caprasimo/Figtree, arc/desert imagery, copper emphasis, large rounded tactile controls where task-relevant.
- **Rationale:** PAT-007 favors a coherent hook and restraint; hierarchy reduces scanning and maintenance cost.
- **Evidence:** ISS-012; current component inventory/runtime captures.
- **Dependencies:** REC-005/006 tokens and safe-area primitives.
- **Risks and trade-offs:** Over-consolidation can erase character or force unlike learning tasks into one component.
- **Acceptance criteria:** (1) Every migrated surface/action maps to a named semantic role; (2) no feature-local duplicate of a shared state without documented exception; (3) primary action is visually unique per screen; (4) tabs never cover scroll-end content; (5) snapshot diffs are approved by family.
- **Verification method:** Component catalog/previews, token lint/search, family screenshot review, UI tab-state preservation tests.
- **Effort:** L
- **Confidence:** Medium — system inference needs design review
- **Expert validation required:** Yes — product design/accessibility

### REC-010 — Deliver first learning value earlier and make personalization observable

- **Status:** Proposed
- **Priority:** P2
- **Addresses:** setup cost described in Family A; PAT-001
- **Affected flows/screens/components:** F-001; SCR-001–SCR-004, first lesson entry
- **Problem:** Goals, schedule, and a dense plan precede the first learning action, while personalization effects are explained rather than shown.
- **Desired outcome:** A new learner experiences Aurel’s method quickly and can see how any requested preference changes today’s path.
- **Proposed change:** Prototype a short value-first route: welcome → one safe recognition/speaking-optional task → concise outcome → goal/schedule only where they change the next card/reminder. Keep sign-in optional and defer purchase. Compare against a tightened current sequence; do not ship based on preference alone.
- **Preserve:** Chapter 1 free/no-account, two-goal maximum, calm plan, permission-on-action.
- **Rationale:** PAT-001 and Apple Onboarding guidance; the current value proposition is better demonstrated by learning than dependency-graph explanation.
- **Evidence:** Stage 1 Family A and PAT-001; Mobbin MBQ-001 visually confirms progressive decisions and deferral within one shipped onboarding sequence, but this remains an opportunity rather than a measured Aurel conversion defect.
- **Dependencies:** Truthful reminder capability from REC-001; content prototype and learner research.
- **Risks and trade-offs:** Too little orientation can make a 20-minute lesson feel unexpected; a demo task must not corrupt durable progress.
- **Acceptance criteria:** (1) Prototype exposes a meaningful task before nonessential setup; (2) every retained question changes a named visible behavior; (3) skip/back/relaunch are deterministic; (4) adult-learner usability study shows comprehension of duration/outcome/free scope; (5) approved variant passes AX/keyboard matrix.
- **Verification method:** Instrumented prototype/usability study, route/persistence UI tests, comprehension questions, accessibility review.
- **Effort:** M
- **Confidence:** Medium — official guidance is strong; Aurel behavior requires user validation
- **Expert validation required:** Yes — UX research and learning design

### REC-011 — Make home, practice, and progress answer one coherent “what next and why” question

- **Status:** Proposed
- **Priority:** P2
- **Addresses:** ISS-012 and terminology/metric observations; PAT-002, PAT-004, PAT-009
- **Affected flows/screens/components:** F-002–F-005; SCR-006, SCR-012, SCR-015–SCR-017
- **Problem:** Home, practice, and progress each contain useful information, but competing cards/metrics and unexplained mastery terms distribute the next action.
- **Desired outcome:** Each top-level section has a distinct job and consistently explains the recommended next task, evidence, duration, and consequence.
- **Proposed change:** Learn = today’s recommended lesson/retrieval and path; Practice = user-chosen scene/speech/story/mistakes; Progress = evidence and next improvement; You = identity/settings/support. Define mastery label derivations and expose explanations. Preserve optional exploration and non-punitive recovery.
- **Preserve:** Four tab labels, two-part day, skill categories, empty states, grace-day language, authored stories.
- **Rationale:** PAT-002/004/009; actionable progress avoids adding coercive gamification.
- **Evidence:** Current family audits and ISS-012; Mobbin MBQ-011/014/015 examples were clearest when a recommended task, due work, or next review was explicit, while metric validity remains unproven.
- **Dependencies:** REC-008 content names and REC-009 hierarchy.
- **Risks and trade-offs:** Reducing duplicated entry points can lower discoverability; deep links/state restoration must be preserved.
- **Acceptance criteria:** (1) Each tab has one documented top-level job; (2) recommended task always includes reason/duration/outcome; (3) mastery/status labels have tested derivations and learner explanations; (4) empty/offline/locked/completed states still provide a valid next action; (5) tab switches preserve section state.
- **Verification method:** IA content inventory, task-based usability, state matrix UI tests, analytics plan reviewed before measurement.
- **Effort:** L
- **Confidence:** Medium — clear system evidence, user preference unmeasured
- **Expert validation required:** Yes — product/learning design/UX research

### REC-012 — Finish learning-feedback, motion, audio, and performance coherence after foundations

- **Status:** Proposed
- **Priority:** P2
- **Addresses:** ISS-013 and current unknowns; PAT-003, PAT-010, PAT-011, PAT-012
- **Affected flows/screens/components:** SCR-007–SCR-015; renderer feedback, result, speaking, motion/sound/haptic services, image pipeline
- **Problem:** The code has thoughtful feedback primitives, but full renderer behavior, real-device speech/audio, reduced motion, and performance are not verified as one system.
- **Desired outcome:** Correct/incorrect/partial/skip/completion feedback is consistent and immediate; motion/audio reinforce meaning without delay; long lessons remain responsive.
- **Proposed change:** Define one adaptive lesson frame and feedback grammar per learning state: stable position/progress and exit; concise instruction; task content; answer-local judgment that names the accepted answer/criterion and meaning when pedagogically valid; and an immediate retry/remediation/continue action. Keep clarity-only speech, use brief/cancelable transitions, remove nonmeaningful ambient/repeated motion under Reduce Motion, coordinate haptic/sound with state, and profile launch/player/image memory on boundary devices. Optimize assets only from measured evidence.
- **Preserve:** Current calm tone, sound/haptic switches, temporary audio deletion, cinematic course art, feedback that never shames.
- **Rationale:** PAT-003/010/011/012 and Apple Motion/Accessibility; a repeated frame lowers interaction relearning across 29 kinds, while answer-local meaning/recovery serves the course scaffold. Performance changes require profiling, not guesses.
- **Evidence:** Stage 1 shared-system audit and ISS-013; Mobbin MBQ-004/012/027/033–037 provides visually inspected shipped examples of stable progress/actions and answer-local correction/remediation. It does not establish efficacy, accessibility, or implementation correctness. Unprofiled areas remain explicitly Unknown.
- **Dependencies:** REC-006/007/009 and real-device access.
- **Risks and trade-offs:** Removing too much motion can reduce spatial continuity; image optimization can damage art quality; audio tests are device/environment sensitive.
- **Acceptance criteria:** (1) Every renderer kind has named feedback states and maps position, instruction, task, feedback, and next action to the shared adaptive frame or documents an accessibility-reviewed exception; (2) every judgment names an accepted answer/criterion and provides an immediate valid retry/remediation/continue path unless assessment rules explicitly defer it; (3) no state relies on color/audio/motion alone; (4) repeated action is never blocked on an animation; (5) Reduce Motion matrix passes; (6) baseline launch/player memory/frame responsiveness is recorded and regressions have thresholds; (7) real-device mic/playback interruption tests pass.
- **Verification method:** Renderer UI suite, reduced-motion/voiceover manual matrix, Instruments signposts/profile, real-device audio interruption tests, before/after evidence.
- **Effort:** L
- **Confidence:** Medium — direction supported, performance defects unmeasured
- **Expert validation required:** Yes — accessibility, audio/speech, performance, learning design

## Proposed design direction specification

### Experience principles and mood

1. **Proposed — One honest next step:** each screen names the learner’s present task and observable result.
2. **Proposed — Warm, not childish:** editorial typography and cinematic scenes; no mascots, currencies, shame, artificial urgency, or confetti by default.
3. **Proposed — Practice is safe:** errors are information; type/skip/replay/hint are valid routes; clarity is not accent judgment.
4. **Proposed — The day has rhythm, not pressure:** daylight/arc and grace days visualize continuity without punishment.
5. **Proposed — Platform behavior is real:** commerce, deletion, permission, notification, widget, link, keyboard, and safe-area states come from iOS capabilities.

### Identity

- **Remain:** Caprasimo display character, Figtree reading/control voice, Aurel arc mark, daylight/dune metaphor, copper/cream/espresso, authored amber scenes.
- **Evolve:** Use Caprasimo for short display statements and learning phrases, not dense utility/meta copy. Let scene art be the richest layer; reduce equal decorative weight across settings/data lists.
- **Deprecate:** learner-facing internal IDs, generic production commentary, decorative cards/pills without a semantic role, glass/elevation variants that do not communicate interaction or hierarchy.

### Type roles

| Role | Proposed use | Rule |
|---|---|---|
| Display | Chapter outcome, completion statement, scene phrase | Caprasimo; short; wraps fully; scales without clipping |
| Section title | Top-level and major content group | Caprasimo or Figtree Bold by hierarchy, one consistent role per family |
| Instruction/body | Task instruction, explanation, dialogue | Figtree Regular/Medium, generous line height, default near platform body size |
| Action | Button/link/tab labels | Figtree Semibold/Bold, concise verb/result |
| Metadata | Duration, level, date, status | Figtree Medium/Semibold; never smaller than legible minimum; not the only state cue |
| Internal/debug | Stable IDs and content coordinates | Never in release UI; support/evidence overlay only |

### Color and appearance

- **Proposed:** Keep semantic roles (`canvas`, `surface`, `text`, `secondary`, `accent`, `onAccent`, `success`, `warning`, `error`, `divider`) independent of raw ramps.
- **Proposed:** Default normal text/CTA combinations meet ≥4.5:1; nontext/state boundaries meet ≥3:1 where applicable; increased-contrast variants are explicit.
- **Proposed:** Light/dark keep the same semantic hierarchy, not simple inversion. Course art may stay art-directed dark, but controls/content remain accessibility-tested.
- **Proposed:** Color never carries correctness, selection, lock, or progress alone.

### Spacing, geometry, and density

- **Proposed:** Backgrounds/art may extend edge-to-edge; readable content and controls use safe-area-aware top/bottom guides.
- **Proposed:** Retain the established 24 pt content margin where it survives boundary tests; use the token scale rather than local numeric variants.
- **Proposed:** One primary action per screen; reserve sticky CTA/tab/keyboard height in scroll content. Dense data/settings screens use sections/dividers before more cards.
- **Proposed:** Test 390×844, a current common iPhone, and 440×956 at default and Accessibility XXXL, portrait only unless scope changes.

### Shape, border, depth, and surfaces

- **Proposed:** Canvas has no elevation; section/task cards use one standard radius/stroke; selected/primary task has one higher-emphasis state; inset information and empty/sample states are visually quieter; modal/sticky controls use platform-appropriate separation.
- **Proposed:** Pills are reserved for compact status/filter/segmented choice, not every container or action. Shadows indicate lift/overlay, not decoration.

### Icons and illustration

- **Proposed:** Keep the custom icon family where it has verified meaning; define weight/size grids and labels/hidden decoration contracts. Use familiar platform symbols when meaning is conventional and custom art adds no identity.
- **Proposed:** Course illustrations keep a shared palette, character/cultural continuity, focal-safe crop, alt text, and provenance/license record. Do not generate replacement art solely for stylistic novelty.

### Components and states

- **Proposed required variants:** primary/secondary/text/destructive buttons; task/info/selected/locked/completed/sample cards; fields with idle/focused/error/disabled; switch with real capability state; banners for info/offline/recovery/error; tab and top navigation; sticky CTA; confirmation; renderer feedback.
- **Proposed:** Each component declares default/dark/increased-contrast, pressed/disabled/loading/error, Dynamic Type/VoiceOver/Voice Control, Reduce Motion, and localization behavior.
- **Proposed:** Course renderers share an adaptive semantic frame—position/exit, instruction, task, answer feedback, next action—while story/scene layouts may use a documented variant that preserves reading order, recovery, and safe geometry.

### Navigation and IA

- **Proposed:** Learn, Practice, Progress, You remain the four top-level destinations. Course/player, speaking/scene, settings, and commerce are task-focused routes with clear back/close semantics. Tabs preserve state and never act as commands.
- **Proposed:** One recommended lesson/retrieval anchors Learn; exploration remains secondary. Practice is choice, Progress is evidence, You is account/preferences/support.

### Content voice and terminology

- **Proposed:** Short, specific, adult, reassuring, active. Explain errors without blame. State duration, consequence, and capability limits plainly.
- **Proposed:** Use learner nouns (“Say hello,” “Introduce a friend,” “Name and contact details”), not authoring nouns (“RP001,” “S27,” “dependency graph,” “production-ready”).
- **Proposed:** Stable internal identifiers remain mandatory in schema/tests/evidence and invisible in release display.

### Feedback, error, loading, empty, and offline

- **Proposed:** Each state says what happened, whether work/data is safe, and the next valid action. Loading appears only for real waiting. Empty states distinguish “not started,” “nothing due,” and “unavailable.” Offline copy names what remains possible. Service-unavailable is not rendered as success.
- **Proposed:** Correct/incorrect/partial judgments identify the accepted answer or criterion and attach explanation/meaning only when authored or expert-validated; every judgment offers a bounded recovery or continue path without shame.

### Motion, haptics, and sound

- **Proposed:** Pressed feedback is immediate; answer/completion motion is short and tied to meaning; route transitions preserve orientation; all can be interrupted. Reduce Motion removes axis/depth/ambient repetition and uses fades/state changes. Haptic/sound never carries meaning alone and respects saved/system settings.

### Accessibility and responsive behavior

- **Proposed:** VoiceOver reading order follows visual/task order; values/traits update with selection/progress; controls have stable Voice Control names; focus returns logically after sheets/errors. AX sizes reflow rather than shrink or truncate. Captions/transcripts accompany spoken learning where relevant.
- **Proposed:** Each of 29 renderer kinds inherits the shared contract and has a deterministic state fixture. Full A1–C1 growth adds content rows, not new ungoverned styling for every lesson.

## Phased implementation plan

### PH-00 — Truth and release safety

- **Objective/user-visible outcome:** The current build stops claiming unavailable services, destructive behavior becomes real, commerce/account geometry is safe, and primary CTA contrast passes.
- **Included recommendations:** REC-001, REC-002, REC-004, REC-005, REC-006 (contrast and core-flow safety subset)
- **Exact scope:** Capability gate; local delete/sign-out contract; voice privacy contract; safe-area primitives/fixes for current screens; default CTA contrast and critical AX checks.
- **Excluded:** Full StoreKit/backend integration, full renderer suite, broad visual redesign, onboarding/IA changes.
- **Affected screens/states/components/files:** F-001/F-004/F-005; SCR-003/005/014/017–020; capability rows/CTAs, top/sticky navigation, semantic color tokens, deletion confirmation; `Aurel/App/AppRouter.swift`, `Aurel/App/RootView.swift`, `Aurel/Services/Services.swift`, `Aurel/Persistence/*`, `Aurel/DesignSystem/DesignTokens.swift`, `Aurel/Features/Progress/ProgressProfileSettingsPaywall.swift`, `Aurel/Features/PracticeHub/PracticeHubViews.swift`, `project.yml`/generated `Info.plist` purpose strings.
- **Prerequisites/decisions:** DEC-003 for voice; PH-00 may choose on-device-only/unavailable fallback. DEC-001 is not required to gate unavailable services, but is required before representing them as available.
- **Ordered tasks:** (1) freeze current evidence; (2) add capability model/release assertions; (3) gate false rows/CTAs/copy; (4) implement tested local delete/sign-out; (5) align voice enforcement/copy; (6) create safe-area containers and fix SCR-019/020; (7) adjust semantic contrast pair; (8) run focused regression/AX/privacy review.
- **Migration/backward compatibility:** Preserve learning records unless delete is confirmed; map existing local `pro/email` prototype fields to an explicit unavailable/guest state without accidental entitlement.
- **Automated tests:** Capability-state unit/UI, delete/cancel/relaunch, sign-out, unsupported/denied speech, contrast token, safe frame containment, existing unit/smoke/milestones.
- **Manual/visual matrix:** 17e/common/Pro Max; light/dark; default/AX3XL; paywall/account/settings/profile/speak; keyboard open; Reduce Motion.
- **Accessibility verification:** VoiceOver order on affected routes, Voice Control names, Increase Contrast, 44 pt targets, no system-chrome intersections.
- **Performance/regression:** Baseline launch and affected route responsiveness; no course/persistence regressions.
- **Required evidence:** Before/after stable screenshots, test result paths, capability inventory, deletion data proof, privacy behavior note.
- **Exit criteria:** All PH-00 acceptance criteria pass; no release UI makes an unavailable capability actionable; zero P0 collision/contrast/delete/privacy findings remain.
- **Rollback/recovery:** Capability gate can default to unavailable; preserve store backup before migration; safe-area/token changes isolated behind shared primitives/tokens.

### PH-01 — Renderer, content, and component foundations

- **Objective/user-visible outcome:** Every authored learning surface is traversable/testable and uses a governed learner-language/accessibility/component contract.
- **Included recommendations:** REC-007, REC-008, REC-009, remaining REC-006 breadth
- **Exact scope:** Walker/per-kind fixtures; content display/debug field separation; shell localization/pseudolocalization; semantic surfaces/actions/tabs; renderer accessibility variants.
- **Excluded:** Final onboarding/IA redesign, production commerce/backend/notification/widget implementation, unmeasured asset optimization.
- **Affected screens/states/components/files:** All SCR/STA rows; semantic surface/action/tab primitives and every course renderer family; `AurelUITests/MilestoneSuite.swift`, `Aurel/Course/Models/*`, `Aurel/Course/Player/*`, `Aurel/Resources/Course/a1-course.json`, `Aurel/DesignSystem/*`, feature views, string catalogs to be created, and current `qa/traceability.md` replacement/update.
- **Prerequisites/decisions:** DEC-004 locales/localization strategy; PH-00 tokens/safe geometry.
- **Ordered tasks:** (1) repair walker; (2) add deterministic fixtures for 29 kinds; (3) establish generated inventory/coverage; (4) migrate display fields and forbidden-copy lint; (5) create string catalog/pseudolanguage route; (6) define semantic surfaces/actions/states; (7) migrate families incrementally; (8) complete renderer VoiceOver/AX/Reduce Motion matrix.
- **Migration/backward compatibility:** Course JSON decoder accepts current and migrated display fields during transition; stable IDs never change; store schema unchanged unless explicitly versioned.
- **Automated tests:** 29-kind fixture suite, all lesson/chapter walks, decoder compatibility, forbidden-copy/localization lint, component contrast/AX, tab state/inset tests.
- **Manual/visual matrix:** Representative screen from each family and renderer family on boundary devices/text/appearance/contrast/motion; pseudolanguage.
- **Accessibility verification:** Accessibility Inspector, VoiceOver/Voice Control scripts, focus after modal/retry, non-color feedback.
- **Performance/regression:** Record suite duration, lesson navigation responsiveness, image memory baseline; avoid pixel snapshots for dynamic course art where semantic assertions suffice.
- **Required evidence:** Per-kind evidence index, component catalog, migration map, current traceability counts, approved screenshots.
- **Exit criteria:** 29/29 authored kinds runtime-verified; no release authoring tokens; component/AX contracts gate CI; all recommendation acceptance criteria pass.
- **Rollback/recovery:** Migrate one family/schema field at a time; keep decoder compatibility and small reviewable commits; revert individual component adoption without ID/data loss.

### PH-02 — Primary learning and information architecture

- **Objective/user-visible outcome:** First use reaches value sooner, and Learn/Practice/Progress/You each provide an unmistakable role and next action.
- **Included recommendations:** REC-010, REC-011
- **Exact scope:** Evidence-tested onboarding variant; home/path recommendation; practice/progress/profile IA, mastery explanations, empty/locked/completed/offline next actions.
- **Excluded:** New curriculum, punitive gamification, final commerce/backend/notification/widget services.
- **Affected screens/states/components/files:** F-001–F-005; SCR-001–006 and SCR-011–018; onboarding step/selection/plan, home path, tabs, progress/mastery/status and profile support entry; `WelcomeView.swift`, `OnboardingViews.swift`, `HomeView.swift`, `PracticeHubViews.swift`, `StreakBoardViews.swift`, `ProgressProfileSettingsPaywall.swift`, `AppRouter.swift`, and related UI/unit tests.
- **Prerequisites/decisions:** Valid reminder capability state; PH-01 language/components; user-research protocol and product outcome definition.
- **Ordered tasks:** (1) define comprehension/task metrics; (2) prototype current-tightened and value-first variants; (3) conduct adult-learner accessibility-inclusive tests; (4) approve one route; (5) implement onboarding persistence; (6) apply four-tab job model; (7) expose mastery derivation/next-action reasons; (8) verify all states.
- **Migration/backward compatibility:** Existing learners bypass onboarding; progress records and route restoration remain; no re-stamping onboarding from verification routes.
- **Automated tests:** First/returning/skip/back/relaunch, goal/reminder effect, tab preservation, every empty/offline/locked/completed next action, mastery derivation.
- **Manual/visual matrix:** New/returning/free/prototype-gated, no-progress/partial/complete, offline, AX/default, light/dark, keyboard.
- **Accessibility verification:** Comprehension at AX sizes, VoiceOver task order, reduced cognitive load, permission timing.
- **Performance/regression:** Time-to-first-interaction/lesson; launch and home scroll responsiveness; persistence/relaunch.
- **Required evidence:** Research protocol/results, approved flow diagram, stable screenshots/states, test results, decision log.
- **Exit criteria:** Approved route meets defined comprehension/task thresholds; all state/AX tests pass; no retained setup question lacks a visible effect.
- **Rollback/recovery:** Feature-flag new onboarding/IA until evidence passes; preserve old route/data migration and disable remotely only if a real flag service is approved.

### PH-03 — Production capabilities and launch hardening

- **Objective/user-visible outcome:** Approved paid/account/re-engagement capabilities are real, and the complete learning product is reliable, accessible, and profiled for release.
- **Included recommendations:** REC-003, REC-012; production implementations selected from REC-001 capability decisions
- **Exact scope:** Approved StoreKit/account/entitlement, notification/weekly email/widget/help only if authorized; legal links; full feedback/motion/audio/performance and final regression.
- **Excluded:** Unapproved capabilities, A2+ content, platform expansion, decorative redesign.
- **Affected screens/states/components/files:** F-001–F-005; SCR-005/007–020 and all service lifecycle states; account/entitlement/StoreKit clients, notification/widget/support targets only if approved, player/practice feedback, release configuration; `project.yml`, `AppRouter.swift`, `Services.swift`, `ProgressProfileSettingsPaywall.swift`, course/player/practice files, app entitlements/privacy manifest as required, and new service/extension/test files authorized by DEC-001.
- **Prerequisites/decisions:** DEC-001, DEC-002, DEC-003, DEC-004; App Store Connect/backend/legal/support assets; real devices and specialist review.
- **Ordered tasks:** (1) approve capability architecture; (2) integrate/store-test one service at a time; (3) render all lifecycle/error/offline states; (4) add approved notification/widget/support capability; (5) finalize feedback/motion/audio grammar; (6) profile/optimize measured bottlenecks; (7) execute full regression/accessibility/privacy/commerce matrix; (8) create release evidence/handoff.
- **Migration/backward compatibility:** Entitlement/account migration from local guest data; server idempotency/recovery; widget/notification schema versioning; preserve Chapter 1 offline access.
- **Automated tests:** StoreKit/account contract, purchase/restore/pending/cancel/refund, notification scheduling/authorization, widget timeline if present, 29-kind suite, all state/accessibility/performance smoke.
- **Manual/visual matrix:** Sandbox account/guest/subscribed/lapsed/offline; denied notifications/mic; smallest/common/largest devices; light/dark/contrast/AX/Reduce Motion; real-device audio/interruption; legal/support links.
- **Accessibility verification:** Independent representative audit across onboarding, home, player renderer families, speaking, progress/settings/paywall; App Store accessibility claims only when evidenced.
- **Performance/regression:** Instruments launch/hang/memory/energy, long lesson, background/foreground, image decode, audio interruptions; thresholds compared with PH-01 baseline.
- **Required evidence:** Sandbox transaction proofs, data/account lifecycle proofs, notification/widget/help proofs, profiler captures, final screen/state matrix, defect disposition, release checklist.
- **Exit criteria:** Only approved real capabilities are visible; zero critical/high open regressions; all renderer/core flow/accessibility/privacy/commerce/recovery checks pass; final evidence and rollback plan are reviewed.
- **Rollback/recovery:** Server/service feature kill switches scoped per capability; StoreKit entitlement reconciliation; database backups/migrations; release gating can fall back to honest unavailable state without hiding purchased access.

## Recommendation-to-phase traceability

Each recommendation has exactly one primary implementation phase.

| Recommendation | Primary phase | Cross-phase dependency |
|---|---|---|
| REC-001 | PH-00 | PH-03 may replace unavailable gates with approved real capabilities |
| REC-002 | PH-00 | PH-03 extends deletion to remote account if approved |
| REC-003 | PH-03 | PH-00 gates/removes simulated commerce first |
| REC-004 | PH-00 | PH-03 real-device launch validation |
| REC-005 | PH-00 | PH-01 migrates remaining families to shared primitives |
| REC-006 | PH-01 | PH-00 fixes P0 contrast/core collisions; PH-03 independent audit |
| REC-007 | PH-01 | Enables safe PH-02/PH-03 regression |
| REC-008 | PH-01 | Supplies display/localization system for PH-02/PH-03 |
| REC-009 | PH-01 | Supplies semantic hierarchy for PH-02 |
| REC-010 | PH-02 | Requires truthful capabilities and PH-01 foundations |
| REC-011 | PH-02 | Requires PH-01 content/component contracts |
| REC-012 | PH-03 | Requires PH-01 renderer evidence and PH-02 final journeys |

## Blocking decisions requiring approval

1. **DEC-001 — Product capability mode:** For the next release, should Aurel be an honest local-first Chapter 1 product with account/commerce/notification/widget surfaces gated, or is the implementation scope authorized to include real StoreKit, account/backend, notifications/email, widget, and support? This decision blocks REC-003 and PH-03 service scope, not PH-00 safety gating.
2. **DEC-002 — Platform floor:** Confirm whether iOS 26.0-only is intentional. This determines the final device/OS validation and adoption scope.
3. **DEC-003 — Speech privacy:** Confirm on-device-only recognition with an unavailable/type fallback as the required contract, or authorize a broader disclosed architecture after privacy review. This blocks final REC-004 behavior.
4. **DEC-004 — Localization scope:** Confirm launch locales and whether curriculum translation is in scope now; this determines REC-008 schema/catalog work and expert review.

## Approval boundary

The plan did not itself authorize implementation. The user subsequently authorized PH-00 through PH-03; their changes and evidence are recorded in `04_IMPLEMENTATION_TRACKER.md`. PH-03 was implemented using the already-approved honest local-first release posture because no App Store products, backend, legal URLs, support service, notification/email service, or widget assets were supplied or separately authorized. Those integrations remain outside the implemented scope rather than being simulated. External adult-learner research, real-device audio/interruption validation, and independent accessibility review remain explicit evidence boundaries.
