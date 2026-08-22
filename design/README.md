# Handoff: Aurel — iPhone app (A1 English course)

## Overview

Aurel is an iPhone app that teaches English from A1 upward. The product promise is
"English, unhurried": one focused lesson at a time — about twenty minutes, with a
natural pause halfway — plus a short recall session, no confetti, no shaming. The
design is a warm, editorial, paper-and-dusk aesthetic — not a gamified language app.

This bundle contains the complete hi-fi interactive prototype (20 screens, two seeded
learner states, light + dark themes, online + offline states), the authored A1 course
content for chapters 1–4, the course-source registers those chapters are traceable to,
and the specification needed to build the app natively.

**Target:** native iOS app, iPhone-only, SwiftUI, iOS 17+.

**This is version 4.** V4 removed several things V1–V3 showed that the product cannot
actually deliver. See "Product truths" below before you build anything — those
corrections are the point of this revision and must not be reintroduced.

---

## About the design files

The files in `prototype/` are **design references written in HTML/JS**. They are
prototypes that show the intended look, copy, states, and behaviour. They are *not*
production code to port line by line.

The task is to **recreate these designs natively in SwiftUI**, using Apple's platform
patterns (NavigationStack, TabView, Dynamic Type, SF Symbols where an icon has no
custom drawing) while matching the visual specification below pixel-for-pixel.

To view the prototype: open `prototype/Aurel V4.dc.html` in a browser (Chrome/Safari).
It renders inside an iPhone frame at 402 × 874 pt. Tweak controls in the design tool
expose three props — `theme` (light/dark), `stage` (day-one / mid-journey),
`connection` (online/offline). When opened as a plain file, defaults apply
(light, day-one, online); to see other states, change the `default` values in the
`data-props` attribute on the `<script data-dc-script>` tag near the end of the file.

## Fidelity

**High-fidelity.** Colors, type, spacing, radii, motion curves and every string of copy
are final. Recreate them exactly. Two things are deliberately unfinished and marked as
such in the UI itself:

1. **Illustrations and audio** are placeholders — striped slots carrying the real asset
   ID and alt text from the course bible (e.g. `A1-C01-ILL005`, `AUD002`). Production
   assets are commissioned separately; the ID contract is final.
2. **There are no "awaiting content" stub screens left.** V1–V3 shipped three
   (placement test, camera word hunt, graded reader). All three are gone: none of them
   has authored content anywhere in the course source, and a shell that promises a
   feature the course never specified is a lie in the UI. Build only what is here.

---

## Geometry & platform

| Item | Value |
|---|---|
| Design canvas | 402 × 874 pt (iPhone 16 / 16 Pro logical size) |
| Screen margin | 24 pt left/right, everywhere, on every screen |
| Top inset | Content starts 70 pt from the top on flat screens (below status bar + Dynamic Island) |
| Bottom inset | Tab bar sits above the home indicator; scroll content pads 34 pt at the bottom |
| Tab bar height | 62 pt content + safe area |
| Minimum tap target | 44 × 44 pt — no exceptions |
| Orientation | Portrait only |
| Themes | Light (default) and dark, both fully specified; follow the system setting |

---

## Design tokens

### Color — light theme

| Token | Hex | Use |
|---|---|---|
| `bg` | `#f5ead8` | App background (warm paper) |
| `surface` | `#ebddc5` | Raised surface base |
| `card` | `mix(#fffaf2 78%, surface)` ≈ `#f7f0e4` | Card fill (`.au-card`) |
| `text` | `#201e1d` | Primary text |
| `text/secondary` | `text @ 52%` | Subtitles, metadata |
| `text/tertiary` | `text @ 40%` | Captions, disabled |
| `divider` | `text @ 16%` | Hairlines |
| `edge` | `rgba(32,30,29,.08)` | Card border |
| `accent` | `#c67139` | Brand terracotta (base) |
| `accent/press` `accent-700` | `#8c491a` | Primary button fill, accent text on light |
| `accent-800` | `#643312` | Primary button pressed |
| `accent-100/200` | `#fff2eb` / `#ffe1d0` | Accent tints (chips, selected card fills) |
| `accent-2` (sage) | `#7a8a5e` | "Passed / achieved" only |
| `accent-2-100/700` | `#f0fae1` / `#56633f` | Sage tint fill / sage text on light |
| `error` | `#a34a3c` on `#f9e8e3`, text `#5f261e` | Wrong answers, form errors |

### Color — dark theme

| Token | Hex |
|---|---|
| `bg` | `#1c1917` |
| `surface` | `#272220` |
| `card` | `mix(#fff 5.5%, surface)` |
| `text` | `#f4ebdd` |
| `divider` | `rgba(244,235,221,.16)` |
| `edge` | `rgba(255,255,255,.08)` |
| `accent` | `#dc8b57` (accent text on dark: `accent-300 #ffc6a5`) |
| `accent-2` | `#a3b383` |
| `error` | `#d97a67`, bg `#d97a67 @ 17%`, text `#ffd6cb` |

Primary buttons keep the `#8c491a` fill in both themes with `#fff8f0` labels.

**Color means exactly three things.** Accent = action and "you are here". Cream/tint
inversion = selected or available. Sage = passed or achieved. Nothing else gets a hue.

### Typography

Two faces, both bundled with the app:

- **Display / headings — Caprasimo, regular (400).** Used for every headline, card
  title, numeral figure. Never for body copy or UI labels.
- **Body / UI — Figtree**, weights 400 / 600 / 700.

| Role | Face | Size / weight | Notes |
|---|---|---|---|
| Hero headline | Caprasimo | 38–44 pt, line-height 1.05, tracking −0.02em | Welcome, paywall |
| Screen title | Caprasimo | 29–33 pt, line-height 1.1, tracking −0.02em | Onboarding questions, tab titles |
| Section heading | Caprasimo | 25 pt | Result, streak, story titles |
| Card title | Caprasimo | 18–19 pt, line-height 1.25 | Option cards, list cards |
| Body | Figtree 400 | 15 pt / 1.55 | Paragraphs, subheads |
| Body small | Figtree 400 | 13–13.5 pt / 1.5 | Card subtitles, helper text |
| Caption | Figtree 400 | 11.5–12.5 pt | Metadata |
| Micro caps | Figtree 700 | 9.5–10.5 pt, tracking 0.14em, uppercase | Kickers, section labels, badges |
| Button label | Figtree 600 | 16.5 pt, tracking 0.014em | Primary/ghost buttons |
| Tab label | Figtree 700 | 10 pt | Tab bar |
| Numerals | Figtree 700 + `tabular-nums` | 19–96 pt | Streak/stat figures |

Map these to iOS text styles so Dynamic Type works: hero → `.largeTitle`, screen title →
`.title`, card title → `.headline`, body → `.body`, body small → `.subheadline`,
caption → `.caption`, micro caps → `.caption2`. Cap growth at AX3 for the display face
(Caprasimo has no optical sizes); let text blocks scroll rather than clip.

### Spacing

8-ish scale actually used: **4 · 6 · 8 · 10 · 12 · 14 · 16 · 20 · 22 · 24 · 26 · 34**.
Rules: screen margin 24; heading → subhead 8–10; subhead → content 22–26;
card gap 10–12; section gap 22–26; bottom pad 34.

### Radii

`999` (pills, chips, avatars, icon buttons) · `28` (sheets, hero cards) · `24`
(large cards, key button) · `22` (buttons, standard cards) · `20` (tab pills) ·
`18` (small cards) · `17` (list rows, badges). No other values.

### Elevation

| Token | Light | Dark |
|---|---|---|
| `lift` (cards) | `0 1px 2px rgba(74,48,26,.05), 0 10px 22px -16px rgba(74,48,26,.4)` | `0 2px 5px rgba(0,0,0,.4), 0 14px 30px -18px rgba(0,0,0,.7)` |
| `soft` (glass) | `0 10px 26px -16px rgba(74,48,26,.5)` | `0 14px 32px -16px rgba(0,0,0,.8)` |

Buttons are flat — no shadow. Glass surfaces use a 18–20 px blur with 1.6–1.7
saturation and a 1 px `edge` border (SwiftUI: `.ultraThinMaterial` + border).

### Motion

| Move | Spec |
|---|---|
| Screen enter | 0.44 s, `cubic-bezier(.16,.84,.3,1)`, translateY 13 → 0, scale 0.994 → 1 |
| Staggered list enter | 0.52 s same curve, delays 0.03 s → 0.43 s in 0.06 s steps |
| Tap feedback | scale 0.972, 0.16 s `cubic-bezier(.2,.8,.3,1)`; buttons translateY 0.5 px |
| Pop (badges, verdicts) | 0.34 s, overshoot to 1.04 |
| Wrong answer | shake 0.38 s, ±6 px |
| Tab indicator | 0.42 s `cubic-bezier(.22,.86,.28,1)` slide |
| Ambient (sky twinkle, sun rise, ray rotation, blob drift) | 1.2–120 s loops, decorative |
| Reduce Motion | All of the above disabled; ambient elements render static. The prototype's `@media (prefers-reduced-motion)` block lists exactly what turns off. |

Haptics: light impact on any selection; success on a correct answer; warning on a
wrong one; medium on lesson completion.

---

## Product truths — corrections made in V4, do not reintroduce

Every item below was in V1–V3 and was wrong. The prototype in this bundle is already
corrected; these notes exist so implementation does not quietly restore them.

| Was shown | Truth | Where it now lives |
|---|---|---|
| Adaptive placement test + level-band picker (onboarding steps 2 and 3) | No placement item is authored anywhere in the course source, and `DECISIONS.md` records placement as a deferred premium ("stubs only, session F2"). Everyone starts where the course starts. | Removed. Onboarding is 2 steps, not 4. The CEFR ladder is still visible — honestly labelled — on the Progress tab. |
| "Ten minutes a day" / a 5-10-20-minute commitment picker | The authored lessons run ≈20 minutes with a designed pause point around the middle. No lesson is a five-minute lesson. | The commitment picker is gone. Step 2 states the real duration and offers one optional reminder (including "No reminder"). |
| "Start seven free days" | There is no trial in the product model. Chapter 1 is the free experience. | Paywall CTA is "Create account and subscribe". Copy says "No free trial — Chapter 1 is the free experience." |
| Hard-coded `$59.99` / `$8.99` prices | Prices are set by App Store Connect and are per-storefront. Hard-coding them ships a lie in 40 currencies. | Plan rows read "App Store price"; the note says price, billing period and renewal terms come from the App Store at checkout. Wire to StoreKit 2 products. |
| "The whole ladder, open." | Only chapters 1–4 exist. A2–C1 are not written. | Paywall promises "Chapters 2–4" and says A2 and beyond arrive as they are written. |
| No account-creation step before subscribing | You cannot subscribe or restore without an account. | New `subscribeAccount` screen sits between paywall and purchase. A "Restore purchase" affordance is on the paywall (App Store requirement). |
| Camera word hunt; graded-reader library | Neither is in the A1 course plan; no word lists, no reader prose, no privacy ruling for the camera. | Both removed. The Practice tab lists only the four authored reading texts, each opening in the chapter that authored it. |
| Chapter 3 quiz/results/remediation/wrap-up as "awaiting content" | Chapter 3 is complete in source; the stubs were stale. | S29–S32 now carry the authored Form A quiz (32 items), the gate, the four clinic seeds and the spaced-review export. |
| Chapter 4 missing entirely | Chapter 4 (Checkpoint Review 1) is authoring-complete and self-QA'd. | Fully transcribed in `course-c4.js`: 14 screens, both clinics, the door roleplay and Checkpoint 1. |
| "Opens with Pro" on chapters that do not exist | Chapters 5+ are not built. | Chapter 5 and beyond read "In development", never "opens with subscription". |

### One correction still outstanding

**Learner-facing copy has not been validated for the stated 12+ audience.** The course
governance requires it; this pass deliberately did not rewrite copy. Treat it as a
human-validation gate before release, not a code task.

---

## Component library

Build these once; every screen composes from them.

**Primary button** — full width inside 24 pt margins, padding 17 × 22, radius 22,
fill `#8c491a`, label `#fff8f0` Figtree 600 16.5. Pressed: fill `#643312` + 0.5 px
translate. Disabled: `text @ 6%` fill, `text @ 32%` label, inset 1 px border.

**Ghost button** — same geometry, glass fill, 1 px `edge` border, `text` label.

**Text link button** — Figtree 600 14.5, `accent-700` (light) / `accent-300` (dark),
13 pt padding all round (meets 44 pt), underline grows from the centre on press.

**Key button** (the tall CTA, e.g. "Start your first lesson") — radius 24, accent fill,
title + sublabel stacked left, circular knob on the right that translates on press.

**Option card** (onboarding answers, commit choices, level picker) — radius 22,
card fill, 1 px `edge`; leading 40–44 pt circular icon chip; Caprasimo 18 title +
13 pt secondary subtitle; min height 64 pt; whole card tappable. Selected: accent-100
fill + 1.5 px accent border + accent-800 icon; text stays at full opacity.

**List card** — grouped rows inside one radius-22 card, row min height 44 pt (50–56
typical), label 15 pt, value `text @ 52%`, trailing chevron, hairline `divider`
between rows.

**Stat block** — Figtree 700 tabular numeral (28–33 pt) over a micro-caps label.
Zero-state shows an em dash `—`, never "0".

**Tab bar** — 4 tabs: Learn · Practice · Progress · You (mapped to screens `home`,
`stories`, `progress`, `profile`). Sliding accent pill indicator behind the active
tab, width `(container − 23) / 4`, radius 20; active label `#fff6ea`, inactive
`text @ 62%`; icons scale 1.07 and lift 1 px when active.

**Lesson path** — vertical trail of nodes: active node accent-filled with concentric
ripple rings, done nodes accent tint + check, locked nodes card fill + lock glyph,
connected by a 2 px dashed `divider` line. Whole row tappable, ≥ 72 pt.

**Progress bar / ring** — bar 4 pt tall, accent fill on `text @ 12%` track, counter
right-aligned 12.5 pt. Ring 120 pt diameter, 4 pt stroke.

**Image slot** — every illustration is a striped placeholder carrying its asset ID
in micro caps plus the alt text in 13 pt secondary. Keep the ID visible in debug
builds; in production the slot becomes the asset with the alt text as the
accessibility label.

**Word sheet** — bottom sheet (radius 28 top corners) with the word, IPA, stress
note, function line and example frame; opens from any word chip in the runner.

---

## Screen inventory

20 screens, in prototype order. Route key = the `screen` state value.

| # | Route | Name | Purpose |
|---|---|---|---|
| 1 | `welcome` | Welcome | Night-sky hero, "English, unhurried." → Begin the path / Sign in. Badge: "Chapter One free, no account" |
| 2 | `goal` | Why English? (1 of 2) | Pick up to two goals; shapes which examples and review items come back first. Never reorders the course — the A1 dependency graph is fixed |
| 3 | `commit` | A focused lesson, with a pause halfway (2 of 2) | States the real ≈20-minute lesson shape; one optional reminder (07:30 / 12:30 / 19:30 / none) |
| 4 | `plan` | Your plan | Dusk-toned summary: today's lesson, the per-lesson rule, the chapter ahead → first lesson |
| 5 | `login` | Welcome back | Email + password, inline validation, forgot-password, new-here link |
| 6 | `home` | Learn (tab 1) | Chapter header, the two halves of today (lesson / recall), streak row, lesson path, resume banner |
| 7 | `course` | Lesson runner | The authored A1 lesson: the full step-type set (see below), progress rail, close-with-resume |
| 8 | `lesson` | Quick practice runner | Short mixed drill: flash, choice, match, listen, pattern, order |
| 9 | `result` | Lesson result | Minutes, what settled, what to review, practice-again |
| 10 | `streak` | The arc | Week dots, month view, rest-day rule ("two rest days a month are built in") |
| 11 | `leaderboard` | Cedar Group | Opt-in cohort of 30, rules explainer, leave/rejoin, invite. Reached from Progress — never surfaced above learning |
| 12 | `stories` | Practice (tab 2) | Say it aloud, Scenes, Review mistakes, and the four authored reading texts |
| 13 | `scene` | Scene | Two-role dialogue; solo or pass-the-phone; pick your reply, hear it back |
| 14 | `speak` | Say this | Speak a line, native/slow playback, verdict, type-instead fallback |
| 15 | `review` | Loose ends | Mistake queue; empty state: "Nothing loose." |
| 16 | `progress` | Progress (tab 3) | Words retained, minutes total, 8-week chart, the A1–C1 ladder (A2+ labelled "Not written yet") |
| 17 | `profile` | You (tab 4) | Identity header + edit, three stats, subscription card, settings list, milestones |
| 18 | `settings` | Settings | Daily rhythm, notifications, Home Screen widget, account (sign out + delete) |
| 19 | `paywall` | Aurel Pro | "Continue with Chapters 2–4." Annual/monthly at App Store price, restore purchase, no trial |
| 20 | `subscribeAccount` | Create your account | Email + password, required before purchase or restore; Chapter 1 progress carries over |

Plus two cross-cutting states: **offline** (banner "Working offline — today's lesson is
already here", audio failure fallback) and **resume** ("Pick up where you stopped?" →
Resume / Start over).

---

## The lesson runner (the heart of the app)

`course` renders one authored lesson as a sequence of full-screen steps. Chapters 1–4
are authored in `prototype/course-c1.js` … `-c4.js` (transcribed verbatim from the
`english_course/04_A1_chapters` source files — no string in them is invented). The
renderer (`CourseScreen.dc.html`) is **field-driven, not type-driven**: a step's shape
comes from which fields it carries, so adding a step type means adding data, not code.
Types present:

`promise` · `hook` · `orientation` · `cards` · `practice` · `pause` · `review` ·
`warmup` · `grammarModel` · `pronPerceive` · `pronProduce` · `conversation` ·
`testlet` · `order` · `substitution` · `reading` · `tiles` · `missionBrief` ·
`roleplay` · `quizIntro` · `quiz` · `results` · `remediation` · `reviewPlan` ·
`chapterMap` · `alphabet` · `letterCards` · `numbers` · `emailAssembly`

Chapter 4 is a **review chapter**: zero new targets by design (course master prompt
§9.4). Every item in it retrieves a Chapter 1–3 ledger row, and Checkpoint 1 gates the
whole of Arc 1 (pass = ≥38/47 overall with ≥70% in vocabulary, grammar, listening and
conversation, plus the speaking mission completed by voice **or** tap). Retries draw
the authored 12-item parallel pool first, then the 15-item alternate form; generation
beyond those pools is not approved.

Practice item shapes inside those steps: **flash** (tap to reveal, I knew it / Didn't),
**choice** (single select + check), **match** (tap phrase, tap meaning), **listen**
(audio + options, slower playback, transcript after response), **pattern** (three
correct examples, then "the rule, once"), **order** (tap word tiles into a sentence).

Item schema (as authored — keep these field names in the app's data model):

```js
{ id: 'PR-V001',            // source id, traceable to the course register
  instr: 'Listen. Choose.', // instruction, from the controlled lexicon
  icon: 'ear',
  aud: 'AUD002',            // audio asset id
  ill: { id: 'A1-C01-ILL005', alt: '…' },
  opts: [{ id: 'A', t: 'hello' }, …],
  key: 'A',                 // correct option
  ok: 'Yes — hello!',       // success line
  no: 'Listen again — …',    // first-miss line
  hints: ['…', '…'],        // escalating hints, one per retry
  secs: 15,                 // expected seconds
  a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] }
```

Vocabulary records carry `w` (word), `ipa`, `stress`, `aud`, `ill`, `fn` (function
gloss), `frame` (pattern example) — the word sheet renders exactly those fields.

Runner rules, as prototyped:
- One item per screen. Check button is disabled until a selection exists.
- First miss → `no` line + hint 1 + shake; second miss → hint 2; third → reveal + it
  joins the mistake queue.
- Correct → `ok` line, pop animation, auto-advance after 420 ms.
- Closing mid-lesson stores position and offers Resume / Start over on Learn.
- Every `a11y` flag in the data is a requirement, not a hint (e.g. transcript must
  appear after the response; replay limits are per item).

---

## State model

The prototype keeps one state object; treat it as the app's domain model. Persisted
keys: `screen`, `goals[]`, `level`, `remindAt` (may be empty = no reminder),
`account` (has an account), `notif{dawn, sundown, milestone, cohort}`, `sw{reminder,sound,haptics,weekly}`, `streak`,
`lessonsDone`, `chapterIdx`, `courseLesson`, `coursePos`, `mistakes[]`, `arcs`,
`pro`, `plan`, `boardOut`, `invited`, `pending{pos,title,at,of}`.

Session-only: `qi`, `sel`, `checked`, `attempt`, `nudge`, `retries`, `matchSel`,
`matched`, `built`, `flipped`, `queue`, `caught`, `speaking`, `speakTake`,
`speakVerdict`, `typed`, `wordSheet`, `sceneTurn`, `scenePicks`, `dayLesson`,
`dayRecall`.

Two seeded states ship in the prototype for review and should be reproducible as
debug fixtures:
- **day-one** — streak 0, no lessons done, not Pro, chapter 1, at `welcome`.
- **mid-journey** — streak 43, 37 lessons done, subscribed, has an account, chapter 2,
  two items in the mistake queue, at `home`.

Day-one rule: never show a bare "0". Streak reads "Day one"; stats read "—".

---

## Content pipeline

Course content is authored outside the app in the `english_course` repository
(`00_governance`, `03_A1_foundation`, `04_A1_chapters/A1_C01…C05`, `07_quality`) with
its own registers: `LEXICAL_LEDGER.csv`, `GRAMMAR_LEDGER.csv`,
`ILLUSTRATION_ID_REGISTER.csv`, `A1_CAN_DO_MATRIX.csv`, `CONTROLLED_INSTRUCTION_LEXICON.md`,
`AUDIO_STYLE_GUIDE.md`, `CHARACTER_AND_VISUAL_BIBLE.md`.

Implement content as **data, not code**: convert the authored chapters to JSON bundled
with the app (and later fetched), matching the schema in the `course-c*.js` files.

State of the course as of this bundle:

| Chapter | Status |
|---|---|
| A1-C01 — Hello! My Name Is Alex | complete, transcribed (`course-c1.js`) |
| A1-C02 — Spell It and Share Your Details | complete, transcribed (`course-c2.js`) |
| A1-C03 — Where Are You From? | complete, transcribed (`course-c3.js`) |
| A1-C04 — Checkpoint Review 1 | complete, transcribed (`course-c4.js`) |
| A1-C05 — My Family and the People I Know | authoring in progress (lessons 1–2 of 3) — show as "In development", never as purchasable |
| A1-C06 … C12 | not written |
| A2 – C1 | await the adaptation guide |

The app must degrade gracefully when a chapter is absent — the prototype's
`FALLBACK_CH` shows the intended behaviour. Never render a chapter that has no data as
though a subscription would open it.

Asset IDs (`A1-C01-ILL005`, `A1-CHAR-…`, `AUD002`) are the contract between the app and
the illustration/audio production tracks. Never inline an illustration; always resolve
by ID so missing assets fall back to the striped slot + alt text.

---

## Accessibility requirements

- 44 × 44 pt minimum on every control (audited; the design conforms).
- Full VoiceOver pass: each card/stat/path node is **one** element with its state
  spoken ("An exam. IELTS, TOEFL, Cambridge. Selected. Button."). Headlines carry the
  header trait. Progress announces "Step 1 of 4".
- Dynamic Type to AX3 minimum: lists scroll under pinned CTAs; the lesson path becomes
  a plain list; three-up stats stack.
- Reduce Motion honoured everywhere (see Motion table).
- Audio items must offer transcripts and respect the per-item `a11y` flags; every
  speaking task has a typing fallback ("Type the sentence instead").
- Contrast: accent is used as a *fill* with near-white labels, or as `accent-700`
  (light) / `accent-300` (dark) when it is text. Never accent text on cream.

---

## Suggested build order for Claude Code

1. **Foundation** — SwiftUI app skeleton, `Theme` (colors, type, spacing, radii,
   shadows, motion), bundled fonts, light/dark, haptics helper, `au-tap` press style.
2. **Component kit** — buttons, option card, list card, stat block, image slot, badge,
   progress bar/ring, bottom sheet, tab bar. Snapshot-test each against the prototype.
3. **Onboarding flow** — screens 1–5 with the real copy, the two-step progress rail,
   goal multi-select (max 2, tap-to-swap), and login validation.
4. **Content layer** — course JSON models + decoding, chapters 1–3 bundled, asset-ID
   resolution with placeholder fallback, mistake queue and scheduling.
5. **Lesson runner** — the step types and 6 practice shapes, hint escalation,
   auto-advance, close/resume, result screen. Build it field-driven, like the prototype.
6. **Home + tabs** — Learn path, Practice, Progress, You, Settings.
6b. **Entitlement** — StoreKit 2: products fetched (never hard-coded prices), account
   required before purchase, restore purchase, Chapter 1 free forever, chapters 2–4
   gated, chapters 5+ shown as in development.
7. **Polish pass** — motion, haptics, VoiceOver, Dynamic Type, offline, empty states.

Suggested structure: `Aurel/DesignSystem/`, `Aurel/Components/`, `Aurel/Features/<flow>/`,
`Aurel/Content/` (models + bundled JSON), `Aurel/Domain/` (progress, streak, review
scheduling), `AurelTests/`.

## Acceptance checklist

- [ ] Side-by-side with the prototype at 402 × 874: colors, type, spacing, radii match.
- [ ] Light and dark both correct; no ad-hoc hues beyond the token list.
- [ ] Every string matches the prototype exactly (copy is designed, not filler).
- [ ] No bare "0" on a day-one account; empty states use the prototype's wording.
- [ ] All tap targets ≥ 44 pt; VoiceOver reads each composite as one element.
- [ ] Reduce Motion and Dynamic Type (to AX3) both pass.
- [ ] Lesson can be abandoned and resumed at the exact step.
- [ ] Missing illustration/audio degrades to the labelled placeholder, never a crash.
- [ ] Sign out and account deletion present (App Store 5.1.1(v)).
- [ ] No price string is hard-coded anywhere; all pricing comes from StoreKit.
- [ ] No trial is offered or implied in any copy.
- [ ] No screen promises a feature with no authored content behind it.
- [ ] Chapters without data read "In development", never "opens with subscription".
- [ ] Restore purchase reachable from the paywall without an existing session.

## Open decisions to confirm before building

1. **Product IDs and price tiers** for the annual and monthly subscriptions, so
   StoreKit can be wired. (Prices themselves are App Store data — this is only about
   which products exist.)
2. **Cohort ("Cedar Group") backend:** real groups of 30, or local-only for v1?
3. **Speech scoring:** on-device recognition vs. a service, and what "near" means.
   The course forbids accent scoring; clarity only.
4. **Notification copy** for the reminder, and confirmation that reminders stay off
   until the learner turns them on.
5. **Age-appropriate copy validation** for the 12+ audience — a human gate, still open.
6. **Chapter 5 timing:** when it lands, does it join the existing subscription or a
   later tier?

## Files in this bundle

```
README.md                        this document — the build spec
prototype/
  Aurel V4.dc.html               the full 20-screen interactive prototype (open this)
  CourseScreen.dc.html           the lesson runner, imported by the prototype
  course-c1.js … course-c4.js    authored A1 chapters 1–4 (content + practice banks)
  support.js                     runtime for the prototype (not for production)
  ios-frame.jsx                  iPhone bezel used by the prototype
  assets/photo.jpg               welcome/learn photograph reference
  _ds/organic-…/                 design-system stylesheet the prototype pulls tokens from
  Aurel Blueprint.dc.html        printable design blueprint: diagnosis + plan
  Aurel A1 Course.dc.html        the A1 course structure as a document
  Aurel - Home Directions.dc.html  Learn-tab layout explorations
course_source/                   the content contract the chapters are traceable to
  00_governance/                 DECISIONS · QA_STATUS · SOURCE_REGISTER · GLOSSARY
  03_A1_foundation/              course overview, dependency graph, can-do matrix,
                                 lexical + grammar ledgers, illustration ID register,
                                 controlled instruction lexicon, audio style guide,
                                 character and visual bible, production state
  04_A1_chapters/                chapter manifests for C01–C04
reference/
  DesignImprovements.md          screen-by-screen design review the design answers
  English_Learning_App_Design_Refinement_Master_Prompt.md
  DE-AI-REFACTOR-REPORT.md
```

The full authored lesson files (`A1_C0n_L0n_LESSON.md`, ~1,000 lines each) and the QA
reports live in the `english_course` repository, not in this bundle — chapters 1–4 are
already transcribed into `course-c*.js`, so you need the repository only to transcribe
chapter 5 or to audit a transcription. The registers in `course_source/` are the parts
the app itself depends on: asset IDs, the instruction lexicon, and the dependency graph.

**Where to start:** open `prototype/Aurel V4.dc.html`, read "Product truths" above,
then build in the order under "Suggested build order". When the prototype and this
document disagree, the prototype wins for visuals and copy; this document wins for
rules and product behaviour.
