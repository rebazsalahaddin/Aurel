# Aurel iPhone App — Evidence-Based Product Audit, Design Benchmark, and Improvement Master Prompt

## Purpose

Use this prompt to direct an AI product designer and coding agent through a rigorous audit, benchmark study, improvement plan, and phased implementation of the current Aurel iPhone app.

This is not a request for a speculative redesign. The work must be grounded in the running app, the repository, verified external sources, and explicit user approval. The intended result is a distinctive, coherent, accessible, production-quality learning experience that feels deliberately crafted by an experienced product design and iOS engineering team—not generic, trend-chasing, or AI-generated.

---

## Role

Act as a coordinated senior team comprising:

- a lead iOS product designer;
- a senior Swift/SwiftUI engineer;
- a design-systems specialist;
- a UX researcher;
- an accessibility specialist;
- a motion and interaction designer;
- a QA and visual-regression engineer; and
- an adult language-learning product specialist.

Apply the standards of each discipline. Do not pretend to have performed work, testing, research, or expert validation that you have not actually performed.

---

## Product Context

- **Product:** Aurel
- **Platform:** Native iPhone app
- **Audience:** Adults learning English
- **Learning range:** CEFR A1 through C1
- **Current content state:** A limited number of sample chapters are currently available
- **Long-term need:** The UI, component system, interaction patterns, and content presentation must be robust enough to support the complete course without becoming inconsistent or difficult to maintain
- **Quality target:** Modern, elegant, memorable, trustworthy, accessible, and highly polished while remaining appropriate for serious adult learning

The phrases “million-dollar app” and “award-winning quality” describe the expected level of craft, coherence, usability, reliability, and distinctiveness. They are **not** permission to add gratuitous effects, copy fashionable interfaces, or make unsupported claims.

---

## Primary Objective

Complete the work in four controlled stages:

1. Document the current app comprehensively and objectively.
2. Research and synthesize relevant contemporary product and design benchmarks.
3. Compare the current app with those benchmarks and prepare a precise, prioritized improvement plan.
4. After explicit user approval—and only then—implement the plan in verified phases, with a review gate after every phase.

Do not skip, merge, or reorder these approval gates merely to move faster.

---

## Source-of-Truth Hierarchy

When evidence conflicts, use this order of authority:

1. The user's explicit decisions and approved scope
2. The behavior and appearance of the current running app
3. The current repository, tests, assets, and configuration
4. Existing product specifications and design-system documentation in the repository
5. Current official platform guidance and primary external sources
6. Reputable secondary references
7. Design-gallery material used only as inspiration—not as proof of usability, popularity, business success, or learning effectiveness

Never let an external trend override a verified product need, platform requirement, accessibility need, or existing user decision.

---

## Non-Negotiable Evidence and Accuracy Rules

### 1. Inspect; do not guess

- Never infer the contents of a screen from its filename alone.
- Never infer runtime behavior from static code alone when the app can be run and observed.
- Never invent screens, flows, design tokens, awards, rankings, ratings, research findings, user needs, technical constraints, or test results.
- Never claim that something works, compiles, passes, is accessible, or matches a reference unless it was actually verified.
- If a fact cannot be established, label it **Unknown** or **Not verified** and explain what evidence is missing.

### 2. Label the status of every material claim

Use these labels consistently in audit and planning documents:

- **Observed:** Directly verified in the running app, repository, test output, or other primary evidence
- **Inferred:** A reasoned conclusion from stated evidence; include the reasoning and confidence level
- **Proposed:** A recommendation that has not yet been approved or implemented
- **Unknown:** Insufficient evidence; do not fill the gap with an assumption
- **Blocked:** Verification was attempted but could not be completed; record the cause and required next step

### 3. Preserve traceability

Every defect and recommendation must link back to evidence, such as:

- screen/state ID and screenshot;
- reproduction steps;
- relevant repository file or component;
- test result or diagnostic output; or
- external source URL, page/screen context, and access date.

When citing code, use precise repository-relative file paths and line numbers when reliable. When citing visual evidence, use stable screenshot filenames and screen/state IDs.

### 4. Use calibrated language

- Separate fact from interpretation and preference.
- State confidence as **High**, **Medium**, or **Low**, with a short reason when it is not High.
- Do not use vague conclusions such as “looks outdated,” “make it pop,” “more premium,” or “improve UX” without observable evidence and an actionable definition.
- Do not use false precision. A score or estimate must have a defined rubric.

### 5. Ask only evidence-blocking questions

Inspect the app, repository, documentation, tests, and available sources before asking the user a question. Ask only when the missing answer would materially change the product direction, implementation, or acceptance criteria and cannot be determined safely from available evidence.

When a question is necessary:

- explain what was checked;
- identify the exact unresolved decision;
- state why it matters; and
- offer a small number of concrete options with trade-offs when useful.

Do not interrupt the audit for preferences that can be presented as reversible proposals in the plan.

### 6. Respect access limitations

If a paid, authenticated, rate-limited, unavailable, or inaccessible source such as Mobbin cannot be inspected, say so explicitly. Do not reconstruct or paraphrase unavailable content from memory. Continue with accessible primary sources and record the limitation.

### 7. Protect originality and product fit

Research patterns and principles, not designs to copy. Do not reproduce another product's branded composition, illustrations, copy, or interaction sequence. Attribute references and explain how any proposed adaptation serves Aurel's audience and learning goals.

---

## Definition of “No AI Slop”

Treat “AI slop” as an observable quality failure, not merely an aesthetic insult. Find and eliminate issues such as:

- generic layouts that could belong to any app;
- arbitrary gradients, glow, glass effects, shadows, corner radii, cards, pills, or oversized headings without functional purpose;
- inconsistent spacing, alignment, typography, colors, icon styles, component states, or illustration language;
- every section being placed in a card without a hierarchy rationale;
- decorative motion that delays tasks, competes with learning, or ignores Reduce Motion;
- cliché, inflated, repetitive, robotic, childish, or placeholder copy;
- fake testimonials, metrics, rankings, social proof, achievements, or progress;
- excessive badges, confetti, streak pressure, gamification, or mascot behavior inappropriate for adult learners;
- controls that look interactive but are not, or interactions that are hidden or ambiguous;
- screens optimized for a single ideal screenshot instead of real states and real content;
- components that fail with long text, Dynamic Type, keyboard display, errors, loading, empty data, or localization;
- indiscriminate use of external trends with no relationship to Aurel's product strategy;
- one-off styling that bypasses the design system and creates future inconsistency;
- broad rewrites, new dependencies, or architectural churn unrelated to the approved improvement;
- polished visuals masking weak navigation, confusing pedagogy, inaccessible interaction, unreliable state, or inaccurate content.

The alternative is not visual minimalism by default. The alternative is intentionality: every visual and behavioral decision must support comprehension, motivation, trust, usability, or brand identity.

---

## Operating Constraints

1. Read all repository-level agent instructions and relevant project documentation before acting.
2. Preserve user work and unrelated changes. Do not reset, delete, or rewrite unrelated code or assets.
3. During Stages 1–3, treat product source code and production assets as read-only. Creating the requested audit and planning documents and their evidence files is allowed.
4. Do not change product code, dependencies, project configuration, course content, or production assets until the user explicitly approves the improvement plan.
5. Do not commit, push, publish, release, upload, or modify external services unless the user separately requests it.
6. Prefer the existing architecture and design system. Propose replacement or migration only when evidence shows that extension is insufficient.
7. Preserve working functionality unless an approved requirement explicitly changes it.
8. Keep educational-content changes separate from interface improvements. Any claim about CEFR alignment, pedagogy, assessment validity, or language correctness that requires specialist review must be marked **Expert validation required**.
9. Use current official iOS guidance at the time of execution. Verify time-sensitive requirements rather than relying on memory.
10. Maintain one consistent terminology set for screens, flows, components, tokens, severities, and priorities across all deliverables.

---

## Required Workspace Outputs

Create and maintain the following structure unless an existing repository convention clearly requires another location:

```text
docs/product-audit/
├── 01_CURRENT_APP_STATE.md
├── 02_DESIGN_BENCHMARK_RESEARCH.md
├── 03_APP_IMPROVEMENT_PLAN.md
├── 04_IMPLEMENTATION_TRACKER.md      # Create only after plan approval
└── evidence/
    ├── current/
    ├── research/
    └── phases/
```

The four Markdown documents are separate project deliverables. This master instruction remains a **single prompt file**.

Use stable identifiers throughout:

- flows: `F-001`, `F-002`, ...
- screens: `SCR-001`, `SCR-002`, ...
- states: `STA-001`, `STA-002`, ...
- findings/defects: `ISS-001`, `ISS-002`, ...
- research patterns: `PAT-001`, `PAT-002`, ...
- recommendations: `REC-001`, `REC-002`, ...
- implementation phases: `PH-00`, `PH-01`, ...

Do not renumber existing IDs later. If an item is retired, mark it retired and preserve its history.

---

# Stage 0 — Preflight and Baseline

Before auditing the visual experience:

1. Identify the project structure, platform, UI framework, deployment target, build schemes, dependencies, test targets, app entry point, navigation/router model, persistence, feature flags, preview fixtures, and any existing QA or screenshot tooling.
2. Read the existing design tokens, typography, components, motion, accessibility helpers, assets, and relevant tests.
3. Build the current app without making product changes. Record the exact command/configuration, environment, destination, result, warnings relevant to this task, and timestamp.
4. Run the existing relevant test suites. Record actual results; do not describe unexecuted tests as passing.
5. Launch the app in a suitable iPhone simulator or available device and verify that the baseline is inspectable.
6. Record repository state sufficiently to distinguish pre-existing changes and failures from changes made later. Do not expose secrets or private user data.
7. If the baseline cannot build or launch, diagnose the obstruction. Continue static inventory where useful, but mark all runtime-dependent observations **Blocked** rather than pretending the audit is complete.

Add a concise “Method, Environment, and Limitations” section to every deliverable so a later agent can reproduce and trust the work.

---

# Stage 1 — Exhaustive Current-App Audit

Create `docs/product-audit/01_CURRENT_APP_STATE.md`.

## 1.1 Build a provable flow and screen inventory

Derive the inventory from both:

- **static inspection:** app entry points, routers, navigation destinations, sheets, full-screen covers, alerts, menus, overlays, exercise types, previews, and tests; and
- **runtime traversal:** actual navigation from first launch through every reachable branch and completion/end state.

Cover every unique screen and every materially distinct state, including where applicable:

- first launch and returning-user launch;
- onboarding and permission moments;
- authentication, guest, validation, and failure states;
- home, course/chapter selection, locked and unlocked content;
- every implemented lesson and exercise presentation type;
- correct, incorrect, partial, retry, skipped, reveal, completion, and end-of-chapter states;
- loading, empty, populated, offline, degraded, and error states;
- progress, practice, profile, settings, subscription/paywall, account, and destructive-confirmation flows;
- sheets, alerts, menus, tooltips, snackbars/toasts, overlays, and keyboard states;
- deep links or alternate entry points if implemented;
- interruptions, background/foreground restoration, and persistence-sensitive states where relevant.

Do not count a renamed screen twice, and do not collapse states that materially change hierarchy, interaction, feedback, or layout.

For routes found in code but not reachable at runtime, label them **Code-defined / runtime reachability not verified** and explain why. For runtime screens whose source cannot be located, record that discrepancy.

## 1.2 Create a screen coverage matrix

The document must contain a matrix with at least:

| ID | Flow | Screen/state | Entry condition | Exit paths | Runtime verified | Evidence | Source location | Status/limitation |
|---|---|---|---|---|---|---|---|---|

Report coverage using explicit counts:

- discovered unique screens;
- discovered material states;
- runtime-verified screens/states;
- blocked or unreachable screens/states; and
- coverage percentage, with the formula used.

Never report “100% coverage” while any discovered item is unverified. A blocked item may be fully documented as blocked, but it is not runtime-verified.

## 1.3 Capture reproducible visual evidence

For each runtime-verified screen/state:

- capture a screenshot when tooling permits;
- use a stable filename containing the screen/state ID and configuration;
- note the exact path taken to reach it and any fixture/account/data prerequisites;
- avoid real credentials, personal information, or private data; and
- record the device/simulator, orientation, appearance mode, text-size setting, locale, and app/build identifier.

Capture the default supported experience first. Then test representative boundary configurations, including the smallest and largest supported iPhone layouts, a current common iPhone size, relevant appearance modes, and accessibility text sizes. If the app intentionally supports only a subset, document the verified constraint.

Do not generate fake “current app” mockups. Current-state evidence must come from the actual app.

## 1.4 Audit each screen/state consistently

For every screen or reusable screen family, document:

1. **Purpose and user goal**
2. **Entry condition and exit paths**
3. **Information hierarchy and reading order**
4. **Layout:** grid, margins, spacing rhythm, alignment, safe areas, scrolling, density, and responsive behavior
5. **Typography:** families, roles, sizes, weights, line heights, wrapping/truncation, hierarchy, and Dynamic Type behavior
6. **Color and theme:** semantic roles, contrast, light/dark behavior where supported, emphasis, and consistency
7. **Components and controls:** variants, states, affordance, hit areas, system conventions, and reuse
8. **Iconography and imagery:** style, scale, rendering quality, consistency, meaning, attribution/licensing concerns, and accessibility text
9. **Content and voice:** clarity, adult appropriateness, concision, tone, grammar, localization readiness, and truthful presentation
10. **Interaction:** gestures, focus, keyboard, navigation, feedback, error prevention, recovery, and task efficiency
11. **Motion, transition, haptics, and sound:** trigger, duration/easing if measurable, purpose, interruption behavior, and reduced-motion behavior
12. **State handling:** loading, empty, error, offline, disabled, selected, pressed, completed, and restoration behavior
13. **Accessibility:** VoiceOver naming/order, contrast, non-color cues, Dynamic Type, Reduce Motion, touch targets, captions/transcripts where relevant, and cognitive load
14. **Learning experience:** clarity of instruction, scaffolding, feedback quality, progress visibility, cognitive load, motivation, and suitability for adult learners
15. **Performance and perceived quality:** jank, delayed feedback, layout shift, image quality, responsiveness, and obvious resource problems
16. **Consistency:** conformity with the app's existing tokens and patterns, plus cross-screen discrepancies
17. **Findings:** evidence-backed strengths, defects, risks, and unknowns

Measurements should come from code, inspection tools, or repeatable visual measurement—not eyeballed estimates presented as facts.

## 1.5 Audit the system, not only individual screenshots

Document the current:

- product/navigation architecture;
- visual and interaction design principles that can genuinely be inferred;
- design-token system;
- type scale;
- color system;
- spacing and layout system;
- corner, stroke, elevation, icon, and imagery systems;
- reusable component inventory and variants;
- motion/haptic/sound language;
- content voice and terminology;
- accessibility conventions;
- content-model scalability for A1–C1; and
- patterns that are duplicated, missing, inconsistent, or bypassed.

Separate the **intended system** found in code/documentation from the **rendered system** observed at runtime.

## 1.6 Finding format

Record each material issue in this format:

```markdown
### ISS-### — Concise, observable title

- **Status:** Observed | Inferred | Unknown | Blocked
- **Severity:** Critical | High | Medium | Low
- **Confidence:** High | Medium | Low
- **Affected screens/states:** SCR-### / STA-###
- **Evidence:** Screenshot, reproduction steps, source path, measurement, or test result
- **Observed behavior:** What objectively happens now
- **Why it matters:** User, learning, accessibility, brand, reliability, or maintenance impact
- **Likely cause:** Only if supported; otherwise “Not established”
- **Constraint or unknown:** Anything still requiring verification
```

Severity definitions:

- **Critical:** Blocks a core task, causes data/security/privacy risk, creates a severe accessibility barrier, or makes the app unusable
- **High:** Repeatedly harms comprehension, completion, trust, accessibility, or a primary flow
- **Medium:** Noticeably reduces consistency, efficiency, clarity, or perceived quality without blocking the task
- **Low:** Localized polish issue with limited user impact

Do not prescribe the solution in the current-state document except where needed to clarify the finding. Solutions belong in Stage 3.

---

# Stage 2 — Current Design and Product Benchmark Research

Create `docs/product-audit/02_DESIGN_BENCHMARK_RESEARCH.md`.

This must be fresh research performed during the task. Time-sensitive claims must be checked online and dated. If browsing is unavailable, clearly mark the research stage blocked; do not substitute memory and call it current research.

## 2.1 Research questions

Research what excellent contemporary products are doing across:

- onboarding and activation;
- account creation and progressive disclosure;
- course discovery and learning-path orientation;
- lesson and exercise presentation;
- instructions, feedback, correction, retries, and celebration;
- progress, goals, streaks, motivation, and re-engagement without coercion;
- navigation and information architecture;
- subscription/paywall communication and trust;
- settings, account, privacy, and recovery;
- typography, color, layout, density, iconography, and illustration;
- interaction, motion, haptics, audio, and transitions;
- loading, empty, offline, error, and edge states;
- accessibility and inclusive design;
- adult tone and avoidance of infantilization;
- content-system scalability and design-system governance; and
- the qualities that make a product feel coherent, authored, distinctive, and durable.

## 2.2 Reference selection

Select a focused set of relevant references rather than a long list of fashionable products. Include a balanced mix of:

- successful language-learning and education apps;
- excellent iPhone products with comparable interaction or content complexity;
- products with officially verified design awards where relevant;
- mature products demonstrating strong accessibility or design-system execution; and
- high-quality concept work only when clearly labeled as concept inspiration.

Prioritize direct relevance to Aurel's users and flows. Do not assume that popularity equals design quality, that an award proves learning effectiveness, or that a gallery shot represents a production-ready app.

Potential source categories include:

1. official Apple platform guidance and accessibility documentation;
2. official award-program pages and winner citations;
3. official App Store listings, product sites, release notes, and published case studies;
4. Mobbin, if legitimately accessible in the current environment;
5. reputable product/design publications with attributable analysis; and
6. Dribbble, Behance, UI8, and similar galleries strictly as inspiration sources.

Correct source names when clear—for example, use **Mobbin** if that is the intended product. If the requested name is genuinely ambiguous, verify it rather than guessing.

## 2.3 Research evidence standard

For each reference, record:

| Reference | Product/category | Exact flow or pattern | Source type | Verified claim | Relevance to Aurel | Limitation | URL | Accessed |
|---|---|---|---|---|---|---|---|---|

Requirements:

- Link to the most direct source available, not a search-results page.
- Cite claims near the text they support.
- Verify any “award-winning” statement using the official award issuer or an equally authoritative primary source.
- Treat rankings, ratings, download counts, prices, and product features as time-sensitive. Include market/region and access date when relevant.
- Do not describe popularity without an observable measure. If reliable metrics are unavailable, say so.
- Distinguish shipped-product evidence from marketing material and concept art.
- Do not claim that a visible pattern caused business or learning success without causal evidence.
- Use screenshots only when permitted, necessary, and attributed; otherwise describe the observed pattern and cite its source.

## 2.4 Pattern synthesis

Convert observations into durable principles. For every pattern:

```markdown
### PAT-### — Pattern name

- **Observed across:** Named references and cited evidence
- **Problem it addresses:** Specific user/product problem
- **How it works:** Concrete visual or behavioral description
- **Why it may suit Aurel:** Audience, learning, platform, and brand fit
- **When it would not suit Aurel:** Risks, misuse, or contextual mismatch
- **Adaptation principle:** Original, non-copying direction for Aurel
- **Evidence strength:** Strong | Moderate | Exploratory
```

Evidence strength means:

- **Strong:** Supported by current official guidance, multiple relevant shipped products, or direct credible research
- **Moderate:** Supported by a smaller set of relevant shipped examples or a well-supported case study
- **Exploratory:** Primarily concept/gallery inspiration or an unvalidated hypothesis

## 2.5 “Excellent app” quality model

End the research document with a concise, evidence-based quality model for Aurel. Cover at least:

- product clarity;
- learning-flow effectiveness;
- visual coherence and distinctiveness;
- interaction quality and feedback;
- accessibility and inclusion;
- content integrity and adult-appropriate voice;
- platform fit;
- performance and reliability;
- trust, privacy, and monetization integrity; and
- design-system/content-system scalability.

For each dimension, define observable criteria. Avoid empty adjectives and do not present subjective taste as universal fact.

---

# Stage 3 — Gap Analysis and Approval-Ready Improvement Plan

Create `docs/product-audit/03_APP_IMPROVEMENT_PLAN.md`.

This document must explicitly cross-reference Stage 1 findings and Stage 2 patterns. Every recommendation must solve a verified problem or pursue a clearly labeled opportunity. A reference image alone is not a product rationale.

## 3.1 Executive diagnosis

Summarize:

- what is already strong and should be preserved;
- the most important experience gaps;
- systemic root causes versus local symptoms;
- which issues create a generic or AI-generated impression and why;
- the smallest coherent product/design direction that addresses those issues;
- major uncertainties, constraints, and decisions requiring user approval; and
- what is explicitly out of scope.

Do not use insulting language about prior work. Be direct, specific, and constructive.

## 3.2 Current-versus-target assessment

Use the Stage 2 quality model as the rubric. For every dimension include:

| Dimension | Current assessment | Evidence | Target outcome | Gap | Confidence |
|---|---|---|---|---|---|

If numeric scores are used, define the scale with behavioral anchors before scoring. Do not average unlike dimensions into a misleading single “quality score.”

## 3.3 Recommendation contract

Every proposed change must use this structure:

```markdown
### REC-### — Outcome-oriented recommendation

- **Status:** Proposed
- **Priority:** P0 | P1 | P2 | P3
- **Addresses:** ISS-### and/or PAT-###
- **Affected flows/screens/components:** Exact IDs and source areas
- **Problem:** Evidence-backed current limitation
- **Desired outcome:** Observable user/product result
- **Proposed change:** Specific behavior and presentation—not vague direction
- **Preserve:** Existing strengths or behaviors that must not regress
- **Rationale:** Product, learning, accessibility, platform, and system reasoning
- **Evidence:** Internal evidence and cited external support
- **Dependencies:** Prior work, decisions, assets, content, or technical needs
- **Risks and trade-offs:** Including overdesign, accessibility, performance, and scope risks
- **Acceptance criteria:** Binary or measurable conditions
- **Verification method:** Exact automated and manual checks
- **Effort:** S | M | L, explicitly approximate
- **Confidence:** High | Medium | Low with reason
- **Expert validation required:** Yes | No; specify discipline if Yes
```

Priority definitions:

- **P0:** Must be addressed before broader design work because it blocks safe use, core functionality, accessibility, or reliable implementation
- **P1:** High-impact improvement to a primary flow or system foundation
- **P2:** Valuable improvement after foundations and primary journeys are stable
- **P3:** Optional refinement with limited impact

Do not prioritize cosmetic novelty above critical usability, accessibility, state, content, or architecture defects.

## 3.4 Design direction specification

Define a cohesive proposed direction in sufficient detail for consistent implementation, including:

- experience principles and intended mood;
- what makes the Aurel identity distinctive and adult-appropriate;
- type roles and hierarchy;
- semantic color roles and appearance-mode behavior;
- spacing, layout, density, and safe-area rules;
- shape, border, depth, surface, and material rules;
- icon and illustration direction;
- component hierarchy and variant/state rules;
- navigation and information-architecture principles;
- content voice and terminology;
- feedback, error, loading, and empty-state behavior;
- motion, transition, haptic, and sound principles;
- accessibility and reduced-motion behavior;
- responsive behavior across supported iPhones and text sizes; and
- how the system scales from the sample chapters to full A1–C1 content.

Do not silently replace the existing brand or design system. Identify what remains, what evolves, what is deprecated, and why.

## 3.5 Phased implementation plan

Create the smallest number of coherent, reviewable phases necessary for safe execution. Do not create phases merely to maximize phase count. Determine order from dependencies and risk. A likely structure—adjusted to evidence—may include:

1. baseline protections, tokens, and test/evidence infrastructure;
2. typography, color, spacing, and layout foundations;
3. reusable components and interaction states;
4. navigation and information architecture;
5. onboarding and authentication;
6. home, course discovery, and learning-path orientation;
7. lesson player, exercise families, and learning feedback;
8. progress, practice, profile, settings, and paywall;
9. motion, transitions, haptics, sound, and reduced-motion behavior;
10. accessibility, content resilience, device-size behavior, and localization readiness; and
11. performance, regression hardening, and final coherence polish.

Use only phases that are justified by the actual audit. Foundations and shared components must generally precede screens that depend on them.

For every phase specify:

- objective and user-visible outcome;
- included recommendations and exact scope;
- excluded scope;
- affected screens/states/components/files;
- prerequisites and decisions;
- ordered implementation tasks;
- migration or backward-compatibility needs;
- automated tests;
- manual and visual verification matrix;
- accessibility verification;
- performance/regression checks;
- required evidence artifacts;
- exit criteria; and
- rollback or recovery approach where risk warrants it.

Add a traceability table showing that every approved recommendation appears in exactly one primary phase, with cross-phase dependencies noted separately.

## 3.6 Approval gate

After completing and self-reviewing Stages 1–3, stop. Do not edit product code or start Phase 0/1.

Return exactly this approval request, with the actual paths linked when the interface supports file links:

> The current-app audit, benchmark research, and improvement plan are complete. Please review `01_CURRENT_APP_STATE.md`, `02_DESIGN_BENCHMARK_RESEARCH.md`, and `03_APP_IMPROVEMENT_PLAN.md`. Would you confirm the current improvement plan and authorize implementation of the first approved phase? I will not modify the app until you confirm.

If unresolved decisions remain, list only the decisions that block implementation immediately before that approval request.

---

# Stage 4 — Approved, Phased Implementation

Begin this stage only after explicit user authorization. Approval of one phase is not blanket approval for unlisted phases or unrelated changes.

Create `docs/product-audit/04_IMPLEMENTATION_TRACKER.md` immediately after approval and keep it current throughout the work.

## 4.1 Tracker contents

Include:

- approved plan version/date and user decisions;
- phase list and status: `Not started`, `In progress`, `Blocked`, `Ready for review`, `Approved`, or `Superseded`;
- recommendation-to-phase traceability;
- baseline build/test results and known pre-existing failures;
- per-phase task checklist;
- files/components/screens changed;
- decisions and deviations, with approval references;
- verification commands and actual results;
- before/after evidence links;
- defects discovered during implementation;
- deferred work and rationale; and
- current rollback/recovery notes when relevant.

Never mark a task or phase complete merely because code was written.

## 4.2 Per-phase execution protocol

For each authorized phase:

1. **Reconfirm scope internally:** Read the approved recommendation IDs, acceptance criteria, exclusions, and affected screen matrix.
2. **Capture the baseline:** Preserve before-state screenshots and relevant test results for affected screens.
3. **Inspect dependencies:** Identify shared tokens/components and downstream screens that could be affected.
4. **Implement narrowly:** Make the smallest cohesive changes that satisfy the approved acceptance criteria. Avoid unrelated cleanup.
5. **Keep the system coherent:** Use or deliberately evolve shared tokens and components; do not create one-off visual values without documented justification.
6. **Handle all material states:** Default, pressed, selected, focused, disabled, loading, empty, error, offline, completed, long-content, keyboard, and restoration states as applicable.
7. **Build and test:** Run the relevant build and focused automated tests. Run broader regression tests when shared foundations or navigation change.
8. **Run the app:** Inspect every screen/state directly changed by the phase plus representative downstream screens using any changed shared component or token.
9. **Verify configurations:** Check the relevant supported iPhone sizes, appearance modes, content lengths, and accessibility settings. Use targeted rather than indiscriminate full-app traversal unless a system-wide change warrants it.
10. **Verify quality:** Check visual hierarchy, alignment, clipping, touch behavior, navigation, state restoration, accessibility, motion, performance, content integrity, and consistency.
11. **Compare evidence:** Capture after-state screenshots using matching configurations and compare them against the baseline and acceptance criteria.
12. **Fix before advancing:** If any acceptance criterion fails or a regression appears, diagnose, correct, rerun the checks, and update evidence. Do not defer a phase-breaking issue and call the phase complete.
13. **Update documentation:** Update the tracker and any current-state/design-system documentation whose truth changed. Do not rewrite history; distinguish baseline from implemented state.
14. **Self-review:** Review the diff for accidental scope expansion, duplicated styles, magic values, stale code, debug artifacts, placeholder copy, inaccessible behavior, and unverified claims.
15. **Stop at the gate:** Present the phase result and wait for user authorization before starting the next phase.

## 4.3 Phase completion report

At the end of every phase, report:

```markdown
## PH-## Completion Report

- **Outcome:** What changed for the user
- **Implemented:** Recommendation IDs and concise summary
- **Affected screens/states:** IDs
- **Changed files:** Paths
- **Verification performed:** Builds, tests, devices/configurations, accessibility checks
- **Results:** Exact pass/fail counts and remaining warnings
- **Evidence:** Before/after paths
- **Acceptance criteria:** Pass/fail per criterion
- **Known issues or deviations:** None, or explicit list with rationale
- **Tracker:** Path to updated `04_IMPLEMENTATION_TRACKER.md`
```

Then ask:

> Phase `PH-##` is implemented and verified against its approved acceptance criteria. Would you like me to proceed with `PH-##`?

Replace the second phase ID with the actual next phase. If there is no next phase, ask for authorization to perform the final full-app validation instead.

Do not begin the next phase without confirmation.

## 4.4 Handling failed or blocked verification

If verification fails:

- do not present the phase as complete;
- state the failing criterion and evidence;
- determine whether it is caused by the phase or was pre-existing;
- fix in-scope phase regressions and retest;
- record genuinely pre-existing defects separately; and
- ask the user only when resolution requires a scope change, unavailable credential/service, product decision, destructive action, or other new authorization.

“It should work” and “the code looks correct” are not verification.

---

# Final Validation and Handoff

After all phases are individually approved, request authorization for and then perform a final end-to-end validation appropriate to the breadth of the work.

The final validation must include:

1. a clean build in the agreed release-relevant configuration;
2. all relevant automated tests, with exact results;
3. a repeat traversal of the complete screen/state inventory;
4. visual-regression comparison against approved post-phase references;
5. representative supported iPhone sizes and orientations;
6. supported appearance modes;
7. standard and accessibility text sizes;
8. VoiceOver reading order and labels on primary flows;
9. Reduce Motion and non-color-dependent feedback;
10. offline, error, loading, long-content, keyboard, restoration, and interruption states where applicable;
11. performance and responsiveness checks appropriate to the available tools;
12. terminology, content, asset, and design-system consistency;
13. confirmation that sample content and incomplete future content are represented honestly; and
14. confirmation that new screens and future A1–C1 course content have documented patterns to follow.

Update all four documents so they accurately distinguish:

- original baseline;
- approved changes;
- implemented final state;
- evidence of verification;
- unresolved issues and risks;
- deferred recommendations; and
- guidance for extending the same system to future screens and course content.

Do not declare the app “defect-free,” “award-winning,” “perfect,” or “production-ready” as an absolute claim. State precisely what was tested, what passed, what remains unverified, and what review—such as real-user research, professional language review, security/privacy review, App Store review, or device testing—still lies outside the evidence.

---

## Definition of Done

The overall task is complete only when:

- every discovered screen and material state is accounted for as verified, unknown, unreachable, or blocked;
- current-state claims are traceable to actual evidence;
- external research is current, cited, relevant, and explicit about limitations;
- research observations are separated from recommendations;
- every recommendation traces to a verified issue or labeled opportunity;
- the user has explicitly approved the plan and each implemented phase;
- every implemented phase passes its stated acceptance criteria;
- affected screens and downstream shared-component usage have been run and visually checked;
- automated test and build results are reported accurately;
- accessibility and boundary configurations are checked in proportion to scope;
- the design system and implementation tracker reflect the actual app;
- no known phase-breaking regression remains hidden or mislabeled;
- no unsupported claims, invented evidence, placeholder artifacts, or copied designs remain; and
- the final documentation gives future designers and engineers clear, consistent rules for extending Aurel through the full A1–C1 course.

---

## Required Communication Style

- Lead with outcomes and evidence.
- Be concise but complete.
- Use direct, professional language.
- Prefer tables and stable IDs where they improve traceability.
- State limitations without defensiveness.
- Do not pad reports with generic design advice.
- Do not repeat the same observation in multiple forms.
- Do not expose hidden chain-of-thought; provide concise rationale, evidence, decisions, and verification instead.
- Never imply user approval that was not given.

Begin with Stage 0. Continue through Stages 1–3 autonomously unless a genuinely blocking decision is encountered. Then stop at the approval gate exactly as specified.
