# Aurel design benchmark research

Research date: 2026-08-24  
Scope: contemporary iPhone/product guidance and directly relevant shipped language-learning patterns  
Claim status: every material row/pattern states its evidence strength or limitation. **Observed** means verified in a linked source; **Inferred** means an Aurel-fit conclusion; **Exploratory** means a hypothesis, not established best practice.

## Method, environment, and limitations

- **Observed:** Research was performed online during this task on 2026-08-24. Time-sensitive Apple policy was checked against the current official App Review Guidelines, last updated 2026-06-08.
- **Observed:** Sources are deliberately weighted toward Apple platform guidance, official award citations, official product/help sites, and first-party product/research posts. No ranking, star rating, price, download count, or popularity claim is used.
- **Observed:** Product-company pages describe shipped features but remain marketing/self-report evidence. They establish that a feature/pattern exists, not that it caused retention, learning, or commercial success.
- **Observed:** An authenticated Mobbin MCP connection was available for the supplemental benchmark pass. Thirty-seven targeted searches (9 flow and 28 deep screen searches) returned 10 flows and 109 individual screens; 149 returned image previews were visually inspected. The complete query log, canonical Mobbin links, relevance misses, and Aurel coverage mapping are in [`evidence/research/MOBBIN_COVERAGE.md`](evidence/research/MOBBIN_COVERAGE.md).
- **Observed:** Mobbin evidence is treated as design-gallery evidence only. The MCP did not expose capture date, app version, accessibility tree, interaction recording, or outcome data; it cannot prove that a pattern is current, accessible, effective, popular, or suitable for Aurel. No Mobbin image or other copyrighted research screenshot was copied into the repository.
- **Unknown:** Long-term learning efficacy and adult-learner preference cannot be concluded from interface documentation alone. Recommendations must preserve that uncertainty.

## Focused reference set

| Reference | Product/category | Exact flow or pattern | Source type | Verified claim | Relevance to Aurel | Limitation | URL | Accessed |
|---|---|---|---|---|---|---|---|---|
| Apple HIG — Onboarding | iPhone platform guidance | First launch, setup, permissions | Official platform guidance | **Observed:** onboarding should be brief, interactive, optional where possible; postpone nonessential setup and ask permissions in context | Tests Aurel’s four-step setup before first lesson | Guidance, not causal learner research | [Apple](https://developer.apple.com/design/human-interface-guidelines/onboarding) | 2026-08-24 |
| Apple HIG — Layout | iPhone platform guidance | Responsive layout, device/text boundaries | Official platform guidance | **Observed:** preview smallest/largest layouts and varying text sizes; adapt gracefully to context changes | Directly relevant to safe-area collisions and AX/device matrix | General platform guidance | [Apple](https://developer.apple.com/design/human-interface-guidelines/layout) | 2026-08-24 |
| Apple HIG — Typography | iPhone platform guidance | Hierarchy, custom fonts, Dynamic Type | Official platform guidance | **Observed:** minimize typefaces, preserve hierarchy, implement custom-font accessibility behavior, adapt at all sizes, minimize truncation | Supports preserving Aurel’s two-family identity while tightening hierarchy | Does not prescribe Aurel’s brand sizes | [Apple](https://developer.apple.com/design/human-interface-guidelines/typography) | 2026-08-24 |
| Apple HIG — Accessibility/contrast | Inclusive iPhone design | Contrast, Reduce Motion, cognitive load | Official platform guidance | **Observed:** normal text up to 17 pt uses 4.5:1 guidance; reduce automatic/repetitive and axis/depth motion when Reduce Motion is enabled | Directly tests CTA tokens and custom transitions | WCAG thresholds are guidance within Apple’s audit model | [Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility), [contrast criteria](https://developer.apple.com/help/app-store-connect/manage-app-accessibility/sufficient-contrast-evaluation-criteria) | 2026-08-24 |
| Apple HIG — Tab bars | iPhone navigation | Top-level sections and state preservation | Official platform guidance, updated 2026-06-08 | **Observed:** tabs navigate top-level sections, remain predictable, use labels, and preserve state | Relevant to Aurel’s four custom tabs and overlay behavior | Does not require a system tab bar when a custom one remains accessible | [Apple](https://developer.apple.com/design/human-interface-guidelines/tab-bars) | 2026-08-24 |
| Apple HIG — Motion | iPhone interaction | Feedback and transition motion | Official platform guidance | **Observed:** custom motion should be brief/precise, avoid unnecessary repetition, allow interruption | Supports Aurel’s calm motion goal and Reduce Motion work | Does not specify one duration for all contexts | [Apple](https://developer.apple.com/design/human-interface-guidelines/motion) | 2026-08-24 |
| Apple HIG — In-app purchase | iPhone commerce | Paywall, products, restore | Official platform guidance | **Observed:** show total localized price, name/duration/benefits, restore/sign-in, legal links; show store only when payment is possible | Direct contract for Aurel Pro | Product/business requirements still require StoreKit/App Store configuration | [Apple](https://developer.apple.com/design/human-interface-guidelines/in-app-purchase) | 2026-08-24 |
| Apple App Review Guidelines | App distribution/trust | Completeness, IAP, account deletion | Official policy, updated 2026-06-08 | **Observed:** incomplete/misleading functionality is disallowed; IAP must be functional; account creation requires in-app deletion | Establishes launch-blocking trust conditions | Policy interpretation can depend on final product/market; legal advice not provided | [Apple](https://developer.apple.com/app-store/review/guidelines/) | 2026-08-24 |
| Apple account-deletion support | Account/privacy | Deletion UX and data handling | Official implementation guidance | **Observed:** deletion must remove the account and associated data, be easy to find, and keep users informed | Directly relevant to Aurel’s confirmation-only navigation | Remote retention obligations depend on future architecture/law | [Apple](https://developer.apple.com/support/offering-account-deletion-in-your-app/) | 2026-08-24 |
| Duolingo learning-path redesign | Language learning | Home path, guidebook, embedded review | Official product/design post | **Observed:** the redesign centered one path, placed guidance near units, and embedded practice/review into progression | Comparable to Aurel’s arc path and review model | Published 2022; current UI may differ; company-authored rationale, not independent proof | [Duolingo](https://blog.duolingo.com/new-duolingo-home-screen-design/) | 2026-08-24 |
| Duolingo 2025 product highlights | Language learning | Progress score, conversation, celebrations | Official current product summary | **Observed:** 2025 shipped progress scoring, conversation practice, and refreshed milestone/lesson-end animation | Shows contemporary breadth and feedback patterns in a shipped language product | Marketing summary; feature availability varies and causality is not established | [Duolingo](https://blog.duolingo.com/product-highlights/) | 2026-08-24 |
| Babbel Speak launch | Adult language learning | Voice-led scenario practice | Official press release, 2025-09-16 | **Observed:** Babbel describes a voice-led trainer designed to move beginners into speaking while balancing freedom against overwhelming tasks | Strong fit for Aurel’s adult, scaffolded scene/speaking direction | Company framing; no independent learning effect in this source | [Babbel](https://www.babbel.com/press/en-gb/releases/babbel-speak) | 2026-08-24 |
| Babbel speech-recognition help | Adult language learning | Recognition during course/review | Official support documentation | **Observed:** speech recognition is integrated into app course/review flows with platform/language availability constraints | Demonstrates the need to state capability limits near the interaction | Support docs describe availability, not interface quality or efficacy | [Babbel](https://support.babbel.com/hc/en-gb/articles/19211305815570-Speech-recognition) | 2026-08-24 |
| Busuu Conversations | Language learning | Realistic speaking scenarios and feedback | Official product/support pages | **Observed:** conversation practice applies learned material to scenarios and produces post-conversation feedback, with explicit language/platform/attempt limitations | Comparable to Aurel scenes and clarity feedback | AI/product marketing; limitations and availability vary | [Busuu product](https://www.busuu.com/en/languages/speak-fluently-with-busuu-conversations), [Busuu support](https://help.busuu.com/hc/en-gb/articles/21862192336402-What-are-Busuu-Conversations-and-how-can-they-help-me-learn-a-language) | 2026-08-24 |
| Apple Design Awards 2025 | Awarded shipped apps | Distinct learning hook, cognitive load, VoiceOver/Dynamic Type | Official award issuer | **Observed:** Apple recognized CapWords’ single camera-to-word hook and Speechify’s approachable UI, Dynamic Type, VoiceOver, and reduced cognitive load | Relevant examples of distinctive learning interaction and inclusive execution | Award recognizes design/technical achievement, not language-learning efficacy | [Apple](https://developer.apple.com/design/awards/2025/) | 2026-08-24 |
| Apple Design Awards 2026 | Awarded shipped apps | Inclusive controls and coherent visual systems | Official award issuer, 2026-06-02 | **Observed:** Apple cited Guitar Wiz for Dynamic Type, Increased Contrast, and Differentiate Without Color; Tide Guide for a cohesive theme serving readable data | Current bar for accessibility breadth and practical art direction | Award citation is selective and not a full product audit | [Apple](https://www.apple.com/newsroom/2026/06/apple-reveals-winners-of-the-2026-apple-design-awards/) | 2026-08-24 |
| Mobbin — Duolingo onboarding | Language-learning gallery | 20-screen first-use sequence | Authenticated design-gallery MCP; images inspected | **Observed:** visible sequence used progressive disclosure, one decision per screen, persistent bottom actions, and explicit deferral for widget setup | Direct comparison for SCR-001–004 | Snapshot date/version and behavioral outcomes unavailable; mascot/sequence must not be copied | [Mobbin flow](https://mobbin.com/flows/b0b4f93f-5637-46ec-9d77-49ecda6b991d) | 2026-08-24 |
| Mobbin — Duolingo lesson | Language-learning gallery | 33-screen path/lesson/feedback sequence | Authenticated design-gallery MCP; images inspected | **Observed:** persistent progress/exit, answer-local correction with correct answer and meaning, `Explain my mistake`, speaking escape, and a state-adjacent next action were visible | Direct comparison for SCR-006–007 and correct/incorrect/speaking states | Still previews do not verify animation, retry logic, accessibility, or efficacy | [Mobbin flow](https://mobbin.com/flows/72b4b965-7ed8-4d1a-b471-fafd7082f820) | 2026-08-24 |
| Mobbin — Babbel lesson/audio | Adult language-learning gallery | Lesson progression, halfway feedback, final dialogue, listen/repeat | Authenticated design-gallery MCP; images inspected | **Observed:** visible lesson frames used terse instructions, persistent progress, model audio, a large record state, fixed bottom action, and contextual encouragement | Direct comparison for Aurel's course/speaking renderer families | Returned onboarding query was a retrieval miss; speech scoring/permission-denial behavior was not shown | [Lesson flow](https://mobbin.com/flows/da23a235-a8c1-45bc-80d7-dfd5de2680be), [audio flow](https://mobbin.com/flows/da59dddd-bcc2-4dd8-ab17-410792da7465) | 2026-08-24 |
| Mobbin — practice/review/progress | Learning-product gallery | Recommended practice, due review, mistake review, completion, calendars | Authenticated design-gallery MCP; images inspected | **Observed:** stronger screens led with one recommended action and made due items, mistakes, or next review timing visible; weaker examples foregrounded opaque scores/currencies | Direct comparison for SCR-008–016 | Metrics' validity and effect on learning cannot be inferred | [Practice hub](https://mobbin.com/screens/7bb8916e-d373-43c3-9614-70afaf9abfed), [Smart Review](https://mobbin.com/screens/c08fcab6-895e-4f21-b69d-aec52bc08c17), [Babbel plan](https://mobbin.com/screens/832f5742-a189-409a-8bb1-06f5ed82bb60) | 2026-08-24 |
| Mobbin — role-play/pronunciation | Language-learning gallery | Scenario, dialogue history, replay/translation aids, recording | Authenticated design-gallery MCP; images inspected | **Observed:** returned screens placed a concrete scenario or model phrase before response, kept audio/help close, and sometimes offered `Can't speak now` | Direct comparison for SCR-013–014 and conversation/pronunciation kinds | No returned screen explained a calibrated clarity score; AI-avatar intensity is not an Aurel requirement | [Duolingo role-play](https://mobbin.com/screens/60331043-f3ea-41f2-8ca6-ab4383942f17), [Babbel repeat](https://mobbin.com/screens/66a71748-3aff-45a7-bcaf-5ff35a080ad1), [Duolingo repeat](https://mobbin.com/screens/68634e56-78f8-484d-aedb-a2cb6117d216) | 2026-08-24 |
| Mobbin — settings/account trust | Cross-category shipped gallery | Settings grouping, help, delete confirmation/result | Authenticated design-gallery MCP; images inspected | **Observed:** visible settings showed current capability values and distinct destinations; deletion references stated affected data and irreversibility, preserved cancel, and one flow returned to signed-out entry | Direct comparison for SCR-017–018 and ISS-002/003/004/006 | Screens cannot verify actual deletion, notification delivery, support response, or privacy compliance | [Babbel settings](https://mobbin.com/screens/25bd2791-e22e-45fb-93b8-7e928e0db4e9), [deletion examples](https://mobbin.com/screens/e03743df-25a5-4687-bc08-40fe4bc747b8), [deletion flow](https://mobbin.com/flows/31a4ef6e-bf56-44d5-bb1d-e353c0d8030b) | 2026-08-24 |
| Mobbin — subscription sequence | Language-learning gallery | Benefits, plan choice, price/period, purchase progress, return | Authenticated design-gallery MCP; images inspected | **Observed:** visible sequence separated benefits from plan choice, showed price/period and charged term, exposed cancellation/renewal copy, entered purchase authentication/progress, then returned to learning | Direct comparison for SCR-019–020 and simulated entitlement defect | Screens do not verify StoreKit correctness, eligibility, restore, cancellation, or localized accuracy | [Duolingo subscription flow](https://mobbin.com/flows/c71bfa5f-4aab-488b-a2af-d5276353a736), [Babbel plan screen](https://mobbin.com/screens/e7807ab6-b736-434f-a9bc-c3cc231c6f2c) | 2026-08-24 |

## Mobbin coverage and traceability

The supplemental pass was exhaustive against the declared Aurel audit inventory, not against Mobbin's entire catalog:

| Aurel benchmark unit | Coverage | Interpretation |
|---|---:|---|
| Audited flows | 5/5 | Every Aurel flow has targeted Mobbin flow and/or screen queries |
| Router-level screens | 20/20 | Every screen is mapped to direct or clearly labeled adjacent visual evidence |
| Material states | 34/34 | Every state was queried; Mobbin supplied no direct validation for Dynamic Type, process restoration, or local-store/course-load recovery |
| Screen families | 6/6 | Onboarding/auth, path/player, quick result/streak, practice/social, progress/profile, settings/paywall/account all covered |
| Authored presentation kinds | 29/29 | All kinds are mapped through their Core, Practice, Assembly, Language, or Assessment renderer family; no one-to-one competitor equivalence is claimed |

The evidence log preserves all 37 exact queries, selected and rejected result context, canonical URLs, and per-item mappings. Natural-language retrieval misses were retained as limitations—for example, the Busuu onboarding query returned Preply, the denied-microphone query did not return a type/skip recovery state, and the recovery query did not demonstrate preserved lesson progress. This prevents a search result from being mistaken for relevant evidence merely because it was returned.

## Research synthesis by product question

### Onboarding, activation, and progressive disclosure

- **Observed:** Apple advises letting people understand a product through use, keeping prerequisite onboarding brief, postponing nonessential customization, and requesting protected resources at the moment their feature is used. Aurel already does the last part for microphone access but front-loads goals, schedule, and a plan before the first learning action.
- **Observed:** Duolingo’s official path rationale describes confidence from a clear next step plus contextual guidebook/practice rather than a large set of disconnected choices.
- **Observed in Mobbin:** The inspected Duolingo onboarding sequence used one decision per screen, visible progress, a persistent action, and explicit deferral for an optional widget request. The Preply result similarly put notification and scheduling choices in context, but it was an adjacent retrieval result rather than Busuu evidence.
- **Inferred:** Aurel’s reasons-for-learning and schedule can remain, but they need to earn their place by changing a visible near-term experience; otherwise they are setup cost.

### Course orientation, lessons, feedback, and speaking

- **Observed:** Duolingo describes embedding review inside the main path; Babbel and Busuu describe speaking as scenario-based practice tied to learned content rather than an isolated microphone demo.
- **Observed:** Babbel explicitly describes a design tension between unrestricted conversation and overwhelming beginners; Busuu’s support material states availability/attempt limits. These are useful trust patterns: constrain the task, explain what feedback means, and disclose limitations.
- **Observed in Mobbin:** Inspected Duolingo, Babbel, and Speak examples kept progress/exit visible, placed model audio and a concrete prompt before production, and attached correct/incorrect meaning or remediation to the next action. Duolingo and Speak exposed `Can't speak now` in some speaking states. No returned result explained a calibrated clarity score, and no denied-permission result paired retry with type/skip.
- **Inferred:** Aurel’s promise→guided task→scene→review arc is well aligned. It should keep “clarity, not accent” and optional type/skip paths while removing internal IDs and making feedback criteria legible.

### Progress, streaks, and re-engagement

- **Observed:** The reference set uses a clear path, embedded review, scores/milestones, and contextual celebrations. It does not establish that more celebration or stronger streak pressure improves learning for Aurel’s audience.
- **Observed in Mobbin:** Practice/review examples were clearest when they named due mistakes, mastery, or the next review and offered one direct action. Streak references ranged from calendar/history to freezes and vacation pause; several also used pressure-oriented copy that conflicts with Aurel's gentler model.
- **Inferred:** Aurel’s grace days and “habit underneath is the point” copy are differentiated strengths. Progress should answer “what changed, what is next, and why” instead of adding currencies, scarcity, or shame.

### Navigation and information architecture

- **Observed:** Apple defines tabs as persistent top-level navigation with concise labels and preserved section state. Aurel’s Learn/Practice/Progress/You labels fit that model.
- **Observed in Mobbin:** Comparable learning products commonly kept tab context visible on hubs and path screens while using a separate close/progress frame inside lessons. This is pattern evidence only; the returned products used three to six destinations and do not determine Aurel's tab count.
- **Inferred:** The custom art direction can remain, but the tab bar must not obscure active content and route terminology must be learner-facing. Course-bank identifiers belong to tooling/evidence, not primary labels.

### Subscription, account, privacy, and recovery

- **Observed:** Apple’s purchase guidance requires an actual payable product with localized total price, duration, benefits, restore/sign-in, and legal links. Apple policy also requires functional IAP and actual deletion for apps that create accounts.
- **Observed:** Apple’s privacy guidance places permission prompts in context and requires truthful purpose strings; product help pages from Babbel/Busuu state capability limitations.
- **Observed in Mobbin:** The inspected subscription sequence showed benefit explanation, explicit plan choice, price/period and charged term, purchase authentication/progress, and return to learning. Settings/deletion references described capability state and consequences. These screens illustrate disclosure and sequencing but cannot prove StoreKit, restore, deletion, or notification behavior.
- **Inferred:** A polished paywall without transaction/account infrastructure is worse than an honest unavailable state because visual authority increases the credibility of the false promise.

### Visual coherence, interaction, accessibility, and durability

- **Observed:** Apple’s typography/layout guidance supports a small type-family set, preserved hierarchy at large sizes, and smallest/largest device tests. The 2025/2026 award citations reward distinctive hooks and accessibility breadth, not decorative density by itself.
- **Observed:** Apple motion guidance favors brief, precise, interruptible feedback and reduced motion for users who request it.
- **Observed in Mobbin:** The gallery exposed strong default-state hierarchy and several dark surfaces, but fixed screenshots could not establish Dynamic Type, VoiceOver/Voice Control, Reduce Motion, increased contrast, safe-area behavior across devices, keyboard avoidance, or interaction timing. Official Apple guidance and Aurel runtime testing therefore remain authoritative for accessibility/platform conclusions.
- **Inferred:** Aurel’s Caprasimo/Figtree and arc/desert palette already provide identity. Excellence depends on disciplined hierarchy, safe geometry, truthful state, and accessibility variants—not more gradients, glass, shadows, or animation.

## Durable patterns for Aurel

### PAT-001 — Let value precede optional setup and selling

- **Observed across:** Apple Onboarding and In-app Purchase guidance; Duolingo path rationale; Mobbin Duolingo onboarding/subscription flow
- **Problem it addresses:** Abandonment or weak trust before a learner understands the product
- **How it works:** Deliver a meaningful learning interaction early; request preferences/permissions at the moment they change the next task; sell after value is concrete
- **Why it may suit Aurel:** Chapter 1 is already free and bundled, and the first promise/task can demonstrate the distinctive method
- **When it would not suit Aurel:** A safety/legal prerequisite or placement decision genuinely required before content selection
- **Adaptation principle:** Keep goal/schedule questions only where their effect is visible in today’s lesson or reminder state
- **Evidence strength:** Strong

### PAT-002 — One clear next lesson, with nearby rationale and alternatives

- **Observed across:** Duolingo path redesign; Apple tab/navigation guidance; Mobbin Duolingo/Babbel path and practice references
- **Problem it addresses:** Choice overload and uncertainty about sequence
- **How it works:** Home foregrounds one recommended task and its outcome/duration; review and optional practice remain discoverable without competing equally
- **Why it may suit Aurel:** The authored dependency graph already defines sequence and the two-part day supplies a natural recommendation
- **When it would not suit Aurel:** Advanced learners need a deliberate browse/placement path; a forced path must not hide required remediation or accessibility alternatives
- **Adaptation principle:** Express the authored sequence in learner language; keep exploration available as secondary navigation
- **Evidence strength:** Strong

### PAT-003 — Scaffold speaking, preserve control, and disclose boundaries

- **Observed across:** Babbel Speak, Babbel speech-recognition help, Busuu Conversations, Apple privacy guidance; Mobbin Duolingo/Babbel/Speak speaking and role-play references
- **Problem it addresses:** Beginner anxiety, permission pressure, ambiguous scoring, and sensitive-data mistrust
- **How it works:** A concrete scenario and target precede the microphone; replay/slow/hint/type/skip controls remain; feedback scope and availability are explicit
- **Why it may suit Aurel:** “Clarity, not accent” and type/skip paths already establish a humane foundation
- **When it would not suit Aurel:** Recognition cannot meet the stated privacy/availability contract or the feedback is not reliable enough to present as judgment
- **Adaptation principle:** Treat speech as an optional rehearsal with honest confidence/availability states, never a gate or accent score
- **Evidence strength:** Strong

### PAT-004 — Make progress actionable without punitive pressure

- **Observed across:** Duolingo path/2025 product summary; Aurel’s current non-punitive model; Apple cognitive-load award citations; Mobbin review/progress/streak references
- **Problem it addresses:** Metrics that entertain but do not guide learning, or streak mechanics that create shame
- **How it works:** Progress names the skill, evidence, next retrieval/action, and reason; celebrations are proportional and dismissible; recovery is normal
- **Why it may suit Aurel:** Widening review intervals and grace days can turn progress into concrete next steps
- **When it would not suit Aurel:** A metric’s derivation is not defensible or the learner cannot act on it
- **Adaptation principle:** Prefer “what you can now do / what returns next” over currencies, ranks, or opaque percentages
- **Evidence strength:** Moderate

### PAT-005 — Commerce and account trust are executable states, not persuasive copy

- **Observed across:** Apple HIG In-app Purchase, App Review Guidelines, account-deletion guidance; Mobbin subscription/settings/deletion sequences as presentation examples
- **Problem it addresses:** Accidental/misrepresented purchases, fake restore/account state, and privacy-control failure
- **How it works:** The UI is driven by actual product/account/entitlement state; unavailable services are hidden or explicitly unavailable; deletion has a verifiable outcome
- **Why it may suit Aurel:** The local prototype has clear seams where real or honest-disabled states can replace booleans
- **When it would not suit Aurel:** Never; only the implementation scope varies
- **Adaptation principle:** No control may say sign in, subscribe, restore, notify, email, delete, contact, or add a widget unless that result can be observed
- **Evidence strength:** Strong

### PAT-006 — Accessibility is a state matrix, not a final checklist

- **Observed across:** Apple Accessibility, Layout, Typography, audit criteria; 2025/2026 Apple Design Award citations
- **Problem it addresses:** Custom interfaces that pass one text-size check but fail contrast, semantics, motion, or alternative input
- **How it works:** Each component defines default/dark/increased-contrast, Dynamic Type, VoiceOver/Voice Control, Reduce Motion, and disabled/error states; smallest/largest devices are tested continuously
- **Why it may suit Aurel:** Aurel already centralizes type/motion and has many AX labels, so the next step is breadth and gating
- **When it would not suit Aurel:** Never; the exact supported modes can be constrained only when platform/product requirements allow it
- **Adaptation principle:** Keep custom identity, but make accessibility behavior a required variant of every primitive and renderer
- **Evidence strength:** Strong

### PAT-007 — Distinctiveness comes from a coherent hook and restrained system

- **Observed across:** Apple Design Awards 2025 CapWords/Speechify and 2026 Tide Guide/Guitar Wiz citations
- **Problem it addresses:** Generic template surfaces or decorative novelty that obscures the task
- **How it works:** One recognizable interaction/visual idea is repeated where meaningful, while typography, surfaces, and animation are disciplined around content
- **Why it may suit Aurel:** The arc/daylight metaphor, editorial type, and adult desert illustration already form a credible identity
- **When it would not suit Aurel:** The metaphor becomes ornamental, culturally narrow, motion-heavy, or more prominent than learning instructions
- **Adaptation principle:** Preserve arc/daylight and editorial warmth; reduce unrelated card/pill/effect variants and let course scenes carry richness
- **Evidence strength:** Moderate

### PAT-008 — Separate authoring metadata from learner language

- **Observed across:** Duolingo’s learner-facing units/guidebooks; Babbel/Busuu’s scenario descriptions; Mobbin outcome/scenario labels; Aurel’s exposed IDs
- **Problem it addresses:** Internal codes, implementation notes, and production status leaking into the product
- **How it works:** Stable IDs remain in the content model/analytics/evidence while display names, outcomes, durations, and instructions use a learner vocabulary
- **Why it may suit Aurel:** Aurel needs stable IDs for 131 screens but users need human scenario and skill names
- **When it would not suit Aurel:** Support/debug mode deliberately exposes IDs and is clearly separated from production UI
- **Adaptation principle:** Every content object has independent `id`, `displayTitle`, `outcome`, and optional support/debug label
- **Evidence strength:** Moderate

### PAT-009 — Top-level navigation must remain legible, persistent, and non-obscuring

- **Observed across:** Apple Tab Bars and Layout guidance
- **Problem it addresses:** Lost location, covered content, and unstable navigation
- **How it works:** Four concise top-level labels remain predictable; each section preserves state; content reserves actual bottom geometry; modal/player routes explain their different navigation
- **Why it may suit Aurel:** The four current labels are concise and map to distinct learner goals
- **When it would not suit Aurel:** A tab is actually an action or duplicates another section
- **Adaptation principle:** Keep four sections, but measure inset geometry from safe areas and test every scroll end at boundary devices/text sizes
- **Evidence strength:** Strong

### PAT-010 — Feedback motion should explain state, finish quickly, and yield to the learner

- **Observed across:** Apple Motion and Accessibility guidance
- **Problem it addresses:** Repetitive spectacle, delayed action, and vestibular/cognitive load
- **How it works:** Short pressed/answer/completion transitions are tied to a state change, cancelable, and mapped to fade/no-parallax under Reduce Motion
- **Why it may suit Aurel:** The current sound/haptic/motion gates and calm brand already point this way
- **When it would not suit Aurel:** Motion is used as the only carrier of correctness or progress
- **Adaptation principle:** Retain purposeful course/result motion; remove ambient/repeated motion that does not change meaning
- **Evidence strength:** Strong

### PAT-011 — Keep lesson position, instruction, answer state, and next action in one stable frame

- **Observed across:** Mobbin Duolingo/Babbel/Speak lesson, speaking, order, fill-in, and assessment references; Apple Layout guidance
- **Problem it addresses:** Learners losing context between prompt, response, feedback, and progression—especially across many renderer types
- **How it works:** A stable lesson frame keeps exit/progress, a concise instruction, the active task, answer feedback, and the primary next action in predictable regions; specialized content changes inside that frame
- **Why it may suit Aurel:** Aurel has 29 authored presentation kinds, so shared spatial/interaction grammar reduces learning overhead and renderer drift
- **When it would not suit Aurel:** A story/scene or accessibility layout genuinely needs a different reading order or full-screen composition; the frame must adapt rather than force clipping
- **Adaptation principle:** Standardize semantic regions and state transitions, not competitor styling, dimensions, or celebratory intensity
- **Evidence strength:** Moderate — repeated shipped visual pattern plus platform layout guidance; interaction effectiveness not measured

### PAT-012 — Pair every judgment with meaning and an immediate recovery path

- **Observed across:** Mobbin Duolingo incorrect/correct feedback, Speak correction, Babbel completion/remediation, Quizlet review results; Aurel's non-punitive learning intent
- **Problem it addresses:** Correctness feedback that tells a learner only that they failed or passed without helping the next attempt
- **How it works:** Correct/incorrect state names the accepted answer or criterion, adds meaning/explanation at the point of error, and offers a bounded retry, correction review, or continue action
- **Why it may suit Aurel:** The course already scaffolds recognition to production and stores review candidates; answer-local recovery can feed that system without shame
- **When it would not suit Aurel:** The explanation is unreliable, too verbose for the task, or reveals an answer before a genuine retry; assessment rules may require delayed review
- **Adaptation principle:** Use Aurel's calm adult voice and pedagogical content; avoid copying branded `Explain my mistake` features or presenting generative explanations without validation
- **Evidence strength:** Moderate — repeated shipped visual pattern; educational quality and efficacy still need expert validation

## “Excellent Aurel” quality model

| Dimension | Observable excellent criteria |
|---|---|
| Product clarity | A first-time learner can state what today’s task is, how long it takes, what becomes possible, and what is free/paid; internal IDs and production notes never appear |
| Learning-flow effectiveness | Every lesson names an outcome, scaffolds recognition→production→application→retrieval, offers a usable recovery after errors, and returns to an explicit next step |
| Visual coherence/distinctiveness | Arc/daylight/editorial identity is recognizable across launch, path, player, and completion; surface/type hierarchy distinguishes primary, secondary, and informational content without decorative excess |
| Interaction and feedback | Every control’s result is immediate and observable; correct/incorrect/partial/disabled/loading/error states are distinct without color alone; motion is brief and interruptible |
| Accessibility and inclusion | Core flows pass VoiceOver/Voice Control, smallest/largest iPhones, Accessibility sizes, dark/increased-contrast, Reduce Motion/Transparency, 44×44 pt targets, and 4.5:1 normal-text guidance |
| Content integrity/adult voice | Copy is practical, concise, culturally considered, non-punitive, and localized through a governed string/content system; learning and speech claims describe what is actually measured |
| Platform fit | Safe areas, keyboard, permissions, tabs, share, links, account deletion, StoreKit, notifications, and widgets use actual iOS behavior and state |
| Performance/reliability | All authored renderers complete without dead ends; launch/relaunch/recovery are tested; image/audio work stays responsive on boundary devices; no known warning hides a functional failure |
| Trust/privacy/monetization | Account, delete, subscription, restore, price/period, notification, contact, legal, and voice-data claims are executable and verifiable; unavailable functions are not represented as active |
| System scalability | Tokens/components/content schemas cover every state; stable internal IDs are separate from display copy; all 29 renderer kinds and future A1–C1 content share automated fixtures and evidence |

## Research conclusions for Aurel

- **Inferred, high confidence:** Aurel does not need a new visual identity. Its strongest path is to make the existing identity more disciplined and its service/state claims fully truthful.
- **Inferred, high confidence:** Commerce/account/privacy and safe-area defects outrank stylistic refinements because they directly affect trust and task completion.
- **Inferred, high confidence:** The learning architecture should preserve calm scaffolding, optional speaking, widening review, and non-punitive streak recovery.
- **Inferred, high confidence:** Across 29 renderer kinds, Aurel should standardize the lesson frame and answer-to-next-action transition while allowing story/scene content to remain visually distinctive.
- **Inferred, high confidence:** Aurel's denial/type fallback and non-punitive streak language are worth preserving; the Mobbin pass did not reveal a stronger direct analogue for either behavior.
- **Inferred, moderate confidence:** First-use setup should be shortened or interleaved with the first learning value unless user research proves the current funnel’s benefit.
- **Exploratory:** A single early “say/recognize one useful line” interaction may communicate Aurel’s method better than static plan explanation; this requires prototype testing, not assumption.
