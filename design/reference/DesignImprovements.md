# Aurel — Design Review & Improvements

---

# Part A — Screen01 (Starting Screen)

## A.1 What the screen is today

Full-bleed, desaturated photograph of a tree-lined path (dark, moody). Top-left brand lockup: orange rounded square with a white "A" + small "AUREL" wordmark. The lower third carries a left-aligned text block on a single shared margin axis:

- Headline — "English, unhurried." (large, bold, 2 lines)
- Subheadline — "A quiet path from your first hello to the argument you win. Ten minutes a day, no confetti."
- Primary CTA — "Start learning" (pill button, warm tan/orange fill, dark label)
- Secondary CTA — "I already have an account" (plain white text)

---

## A.2 What works well — protect these

| Strength | Why it matters |
|---|---|
| Single left alignment axis (logo → headline → CTAs) | Creates a calm, editorial structure. Keep it; don't mix in centered elements. |
| Headline voice ("English, unhurried.") | Distinct, brand-defining tone. The design and copy agree — rare and valuable. |
| Restrained palette (photo + one warm accent) | Elegant and modern; one accent used for both logo and CTA reads as a system. |
| Primary CTA in the bottom third | Sits in the thumb zone; correct for one-handed iPhone use. |
| Photo tone matches the product promise | "Unhurried" copy + unhurried imagery = coherent brand feeling. |

---

## A.3 Weak points & improvements

### A.3.1 Color & contrast — the biggest risk

**Issue: text contrast over a photograph is non-deterministic.** The subheadline (light gray) sits over the photo, whose brightness varies. Today it happens to be legible; a different crop, screen brightness, or daylight viewing can drop body text below WCAG's 4.5:1 minimum (1.4.3). The status bar has the same exposure at the top of the frame.

**Fixes**
1. **Add a guaranteed floor with a gradient scrim** behind the text block: black, ~85% opacity at the bottom edge → 0% at ~50–55% screen height. This makes every element over it pass contrast regardless of the photo. Add a subtle top gradient (black, 0 → ~35% over the status bar area) so the clock/icons are always legible.
2. **Define semantic color tokens** (see §5.1) so "text over photo," "accent," and "text-on-accent" are roles, not one-off values.
3. **Accent rules for the tan/orange (~#D9A066):**
   - As a **fill with near-black text**: excellent (~9.5:1) — this is what the CTA does today. Correct; keep it.
   - As **small text on white/light surfaces**: fails (~2.2:1) — never use it this way. On light surfaces, use a darkened accent (e.g., #8A5A24, ~4.9:1 on white) for links/labels.
   - As **text on near-black**: passes (~8.7:1) — fine for dark-theme accents.

### A.3.2 Typography — no scale, subheadline too long

**Issues**
- There is no visible type scale — headline, body, and CTA sizes feel chosen per-element rather than as a ramp.
- The subheadline is ~100 characters, wrapping to 3–4 lines — long for a first-run screen and it dilutes the headline.
- If sizes are fixed (likely, in a static design), Dynamic Type users get no scaling — an HIG expectation on iOS.

**Fixes**
1. Adopt the type ramp in §5.2 — anchored to iOS text styles so Dynamic Type comes for free (`.largeTitle`, `.body`, `.subheadline`).
2. Keep body line measure to ~45–60 characters per line and line-height ≈ 1.45 (17pt text on ~24pt lines). The 24pt screen margin naturally produces this.
3. Trim the subheadline to one thought, keeping the wit, e.g.:
   > *From your first hello to the argument you win — ten unhurried minutes a day.*
   (~70 characters, keeps "no confetti" energy without a fourth line.)
4. Optional, to lean into the editorial tone: set the headline in a serif (e.g., New York, Apple's serif system font) while body stays sans. This is a taste call — test it, keep only if it elevates. **Decide once and apply flow-wide** (see §6).

### A.3.3 Layout & spacing — ad-hoc gaps, safe-area exposure

**Issues**
- Vertical gaps between elements look hand-picked (~20 / ~15 / ~30) rather than from a spacing scale — this is what makes a design feel "almost, not quite."
- The secondary text sits close to the home indicator.
- The large empty middle band works at full size, but on iPhone SE / smaller frames the photo crowds the text block.

**Fixes**
1. Adopt the 8pt spacing scale (§5.3) and use it everywhere: headline → subhead 12pt, subhead → CTA 32–40pt, CTA → secondary 16pt, secondary → home-indicator area ≥ 16pt.
2. Standardize the screen margin at **24pt** and verify the logo's inset matches the text block's inset exactly — the shared axis is the design's best structural feature; identical insets are what make it read as intentional.
3. Respect safe areas explicitly (SwiftUI `safeAreaInsets` / layout guides): primary CTA bottom edge ≥ 20pt above the home indicator; secondary link ≥ 16pt.
4. **Bottom-anchor the text block** (with the spacings above) rather than optically floating it — the photo fills whatever space remains. On small devices, crop the photo (aspect-fill), never shrink the text.

### A.3.4 Buttons & interaction — weak secondary affordance, unspecified states

**Issues**
- "I already have an account" is plain text: weak affordance, and as set it is likely under the 44×44pt minimum touch target (HIG).
- The design shows no pressed/disabled states; a static-looking CTA feels lifeless on device.

**Fixes**
1. Primary CTA spec (§5.4): full width minus 24pt margins, **50pt min height** (44pt is the floor; 50 is comfortable), pill radius = height/2, label 17pt semibold sentence case ("Start learning" is already correct).
2. Secondary CTA: keep it text-style (it's correctly subordinate) but give it a **≥ 44×44pt tap area** via padding, a pressed state (opacity 0.6), and consider a trailing chevron ( `I already have an account ›` ) to signal tappability without adding a competing button.
3. Define states for both: **pressed** (primary: fill 90% opacity or scale 0.98 + light haptic; secondary: opacity 0.6), **disabled** (fill 40%, label 40%), **loading** (in-app spin or label swap — decide before implementation, not during).

### A.3.5 Accessibility

- **VoiceOver:** reading order top→bottom (brand → headline → subhead → primary → secondary); mark the headline with the `.isHeader` trait so VoiceOver rotor users can jump to it; label the CTAs as buttons.
- **Dynamic Type:** verify the layout reflows cleanly up to accessibility sizes (AX5) — with a photo background, allow the text block to scroll rather than clip or overlap the photo.
- **Reduce Motion:** if any photo treatment (Ken Burns, parallax) is planned later, gate it behind `accessibilityReduceMotion`.
- **Contrast:** handled by the scrim (A.3.1) — the point is to make legibility structural, not lucky.

### A.3.6 Brand & imagery polish

1. **Logo clear space:** keep free space around the lockup ≥ half the mark's height on all sides; minimum mark size ~28pt. Document it now — it's the rule most often broken first.
2. **Photo art direction:** write down the grade so future screens match: desaturated, dark, low detail where text sits, warm-neutral cast. Any future background photo must survive "text over it" with the scrim, not fight it.
3. **Launch screen:** set the launch background to the screen's base color (near-black, §5.1) so cold-start doesn't flash white → photo. Small detail, large perceived-quality effect.
4. **Theme stance (decision to make):** this welcome experience is inherently dark. Recommendation: lock the welcome flow to this dark theme (a valid, elegant choice), and define warm light surfaces for content screens (§5.1 `surface/cream`), with the accent flipping to its dark variant. Don't auto-flip this screen with system light mode — it would break the photo treatment.

---

## A.4 Priorities — Screen01

| P | Item | Effort |
|---|---|---|
| **P0** | Bottom + top gradient scrims (contrast floor, status bar) | Small |
| **P0** | Secondary CTA ≥ 44×44pt tap area + pressed states for both CTAs | Small |
| **P0** | Safe-area clearances (CTA ≥ 20pt, secondary ≥ 16pt above home indicator) | Small |
| **P1** | Adopt type ramp + trim subheadline copy | Medium |
| **P1** | 8pt spacing scale, verify logo inset = text inset (24pt margin) | Medium |
| **P2** | Color tokens incl. `accent/deep` for light surfaces; theme-stance decision | Medium |
| **P2** | Launch screen color match, haptic on CTA, photo art-direction notes | Small |

---

# Part B — Screen02 (Onboarding — "Why English?")

## B.1 What the screen is today

Flat, near-black screen (no photo — a deliberate shift to focus mode). Top row: a circled, bordered back button (left, ~32×32) and a thin progress bar with a right-aligned "1 of 3" counter, filled ~one-third in the accent color. Left-aligned headline and subheadline sharing the cards' left margin:

- Headline — "Why English?"
- Subheadline — "It changes what we put in front of you first."

Four stacked single-select option cards, each with a circular icon chip (briefcase, globe, graduation cap, open book), a title, and an example subtitle:

| # | Title | Subtitle | State |
|---|---|---|---|
| 1 | Work and interviews | Meetings, email, negotiation | default |
| 2 | Travel and living abroad | Getting by, getting around | default |
| 3 | **An exam** | IELTS, TOEFL, Cambridge | **selected** — cream fill, thin accent border |
| 4 | Myself | Books, film, conversation | default |

Bottom: "Continue" pill button (accent fill, near-black label). No skip link. Home indicator present.

---

## B.2 What works well — protect these

| Strength | Why it matters |
|---|---|
| Continuity with Screen01 | Same dark ground, same accent, same left alignment axis — the flow already reads as one system. |
| Card list is the right pattern | Single-select option cards with icons is the clearest way to ask a preference question; card tap targets (~64pt tall) comfortably exceed 44pt. |
| Concrete subtitles ("IELTS, TOEFL, Cambridge") | Examples make options self-explanatory — users choose faster and trust the choice. |
| Progress bar + "1 of 3" counter | Sets a short, honest expectation — perfectly on-brand for "unhurried." |
| Cream-inversion selection concept | Flipping the selected card from dark to cream is an elegant, glanceable selected state. The *idea* is right — the execution fails (see B.3.1). |

---

## B.3 Weak points & improvements

### B.3.1 The selected state is illegible — this screen's P0

**Issue: the selected card's text is rendered ghosted, not dark.** On the cream fill, the title "An exam" reads at roughly 40–50% opacity and the subtitle "IELTS, TOEFL, Cambridge" at ~20–30% — approximately 2:1 contrast or worse, far below WCAG's 4.5:1 (1.4.3), and *below the unselected cards*. Selection should raise prominence; here it destroys it. A user who taps a card sees their choice become the hardest thing to read on the screen.

**Fixes**
1. Selected-card text at **100% opacity**: title `#1C1C1E` (≈16:1 on cream), subtitle `#4A4A50` (≈8:1). Both pass AA with room to spare.
2. **The icon chip must flip too:** the accent tan (#D9A066) on cream is only ~2:1. On the selected card, render the icon in `accent/deep` (#8A5A24, ~5.4:1) or give the chip a dark fill with the tan icon.
3. Keep the thin accent border on the selected card — a good secondary signal — but never let color/border be the *only* signal (see B.3.5 VoiceOver traits).

### B.3.2 Style drift from Screen01

**Issues:** the flat background reads a slightly different near-black (~#1A1A1A) than the system base; the Continue button's side margins (~32–40pt) differ from Screen01's CTA geometry; the headline appears set in a serif while Screen01's is sans (confirm in the source file).

**Fixes:** all three are symptoms of missing shared tokens — pull values from §5 instead of re-picking per screen: one `bg/base`, one CTA spec (§5.4), one display face for the whole flow (decide the serif question from A.3.2 once, apply everywhere). Details in §6.

### B.3.3 Navigation & progress affordances

**Issues**
- The circled back button is ~32×32pt — **below the 44×44pt minimum** touch target (HIG). Its thin border on dark reads ~2.3:1, under the 3:1 required for meaningful UI components (WCAG 1.4.11).
- The circled-bordered shape is also the only circle-with-border in the design language — it reads as a foreign element.
- The progress fill and counter work, but the counter is small gray text on dark and nothing announces progress to VoiceOver.

**Fixes**
1. Prefer the **system back chevron** (free edge-swipe gesture, native look, ≥44pt target). If a custom control is required, make it ≥44×44pt with a visible affordance (≥3:1 border or a subtle filled disc).
2. Counter in `text/secondary` (#C7C9CD) at 13pt; progress bar 4pt tall, fill `accent` (≈8.4:1 on base — passes 1.4.11), track `#4A4A52` (decorative, but visible).
3. Announce progress on appear ("Step 1 of 3") via an accessibility notification; hide the bar itself from VoiceOver — the counter carries the information.

### B.3.4 Card system — standardize into a component

**Issues:** card metrics look hand-tuned (~64–68pt heights, ~16–20pt radii, ~12–16pt gaps, 1pt borders); the unselected subtitle gray (~#888) only clears AA by a hair (~4.9:1) and doesn't match Screen01's secondary-text token; no pressed/selection-motion states are specified; and the Continue button's enable logic is undefined (can you proceed with nothing selected?).

**Fixes — one spec, four states**

| State | Fill | Border | Title | Subtitle | Icon chip |
|---|---|---|---|---|---|
| Default | `#1E1E22` | 1pt `#3A3A40` | `text/primary` | `text/secondary` | 40pt circle, icon `accent` |
| Selected | `surface/cream` `#F8F5F0` | 1.5pt `accent` | `#1C1C1E` | `#4A4A50` | icon `accent/deep` |
| Pressed | default @ 85% opacity (or scale 0.98) | — | — | — | — |
| Focused (VoiceOver) | same as default | 2pt `accent` | — | — | — |

- Geometry: height **64pt**, radius **16pt** (matches the radius scale, §5.4), gap **12pt**, side margins 24pt like everything else, icon chip 40pt with 12pt inset.
- Add a **light haptic** + subtle spring (≤0.2s) on selection; gate the spring behind Reduce Motion.
- **Define the Continue logic:** either preselect nothing and disable Continue (disabled state per A.3.4) until a choice is made, or preselect the most common option ("Work and interviews"). Don't ship an enabled button that does nothing. A product call worth making explicitly.
- Worth considering: allow **two selections** (e.g., "Work" + "Myself") — goals are rarely singular. If yes, the copy becomes "Pick up to two" and the pattern needs no structural change.

### B.3.5 Accessibility

- **VoiceOver per card:** merge the chip into one element — e.g., "An exam. IELTS, TOEFL, Cambridge. Selected. Button." — with `.isButton` + `.isSelected` traits so state is spoken, not just colored.
- **Reading order:** back → progress/counter → headline (`.isHeader`) → subheadline → cards 1–4 → Continue.
- **Dynamic Type:** at AX sizes the four cards will overflow — let the card list scroll under a pinned Continue button; never truncate card text.
- **Reduce Motion:** the selection spring and any progress animation respect `accessibilityReduceMotion`.

### B.3.6 Copy polish (minor)

Headline and subheadline are excellent — short, human, and they justify the question ("It changes what we put in front of you first."). Card titles/subtitles are consistent sentence case with concrete examples; keep as-is. Only flow-level decisions remain (multi-select, skip), covered in B.3.4 and §6.

---

## B.4 Priorities — Screen02

| P | Item | Effort |
|---|---|---|
| **P0** | Selected card: text 100% `#1C1C1E`/`#4A4A50`, icon flips to `accent/deep` | Small |
| **P0** | Back button ≥ 44×44pt (or system chevron) with visible affordance | Small |
| **P0** | Unselected subtitle → `text/secondary` token (fixes thin ~4.9:1 margin) | Small |
| **P1** | Card component spec (B.3.4 table) incl. pressed/focused states, haptic, spring | Medium |
| **P1** | Continue geometry to shared CTA spec (full width − 48pt); define enable logic | Small |
| **P1** | Progress a11y: counter token, "Step x of y" announcement, heading trait | Small |
| **P2** | Multi-select decision, scroll-under-CTA at AX type sizes, `bg/base` alignment | Medium |

---

# Part C — Screen03 (Self-Assessment interstitials, 2 states)

## C.1 What these screens are today

Both states are **question-free "moment" screens** — flat dark ground, fully centered content block, one CTA. There is no question text, answer options, or input anywhere on either state (verified across analysis passes):

- **_01 (before starting):** a thin, empty ring (~¼–⅓ of screen width); inside, a very large bold "0" above a small tracked caps label "OF 6 ANSWERED" (gray). Headline — "Six quick questions". Subheadline — "Answer honestly — there is nothing to win." / "It takes about two minutes." CTA — "Begin" (pill, warm fill, near-black label, reads ~⅔ of screen width).
- **_02 (after the first answer):** identical composition; ring ~⅙ filled with an accent arc; "1 OF 6 ANSWERED". Headline — "Keep going". Subheadline — "Each answer narrows the range." / "Nothing is recorded until the end." CTA — "Next question" (reads ~¾ of screen width).

No back, close, or skip affordance on either state. Home indicator present.

## C.2 What works well — protect these

| Strength | Why it matters |
|---|---|
| Honest expectation-setting | "Six quick questions… about two minutes… nothing to win" lowers test anxiety and is perfectly on-brand. |
| Trust copy | "Nothing is recorded until the end" is a genuinely good privacy promise — keep the line and make the product honor it (see C.3.2). |
| Glanceable progress | A ring plus plain-language "x of 6 answered" beats a bare percentage; the ⅙-filled arc state is instantly readable. |
| Single unambiguous CTA | One action per screen — no decision fatigue at a moment when users are mid-task. |
| Deliberate pacing | A breath between questions fits "unhurried." The instinct is right; the *frequency* is the problem (C.3.1). |

## C.3 Weak points & improvements

### C.3.1 An interstitial after every answer doubles the interaction cost — the flow's main UX issue

**Issue:** if this "Next question" moment appears after each of the six answers, the assessment costs ~12 taps instead of 6, and the same "Keep going" headline five times in a row stops being encouragement and becomes wallpaper. A two-minute task quietly becomes three.

**Fixes**
1. **Preferred: move progress onto the question screens** — the ring (or a "2 of 6" counter) in the question header — and **auto-advance** after each answer (~0.4s delay, animated, interrupted by tapping a different option).
2. Keep "moments" only where they earn their tap: the intro (_01) and a **final review/confirm** state at the end.
3. If pacing interstitials stay: vary or drop the repeated headline, let the whole screen accept the tap after a beat, and auto-continue after ~2s.

### C.3.2 No way back, no way out — a linear trap

**Issue:** neither state shows back, close, or skip. "Nothing is recorded until the end" *implies* answers are revisable — but no visible path to revise exists, and a user who starts the assessment on accident must answer their way out. HIG expects people to control navigation.

**Fixes**
1. Keep the system edge-swipe + back chevron on the question screens.
2. Add a **final review state** — the answer list with change taps, then submit — which is what makes "Nothing is recorded until the end" true rather than merely said.
3. A discreet exit (chevron/X) that preserves state, so leaving isn't losing.

### C.3.3 Centered layout breaks the system's left axis — make it a rule, not an accident

**Issue:** Screen01/02 are left-aligned and bottom-anchored; Screen03 is fully centered, vertically and horizontally. Both are legitimate modes — mixed with no stated rule, it reads as drift.

**Fix:** adopt a written layout-mode rule (added to §6): **content screens = left-aligned; "moments" (interstitials, transitions, empty/celebration states) = centered.** Screen03 is then *correct* — but only as policy, and the CTA geometry must stay identical in both modes (full width − 48pt; see C.3.4).

### C.3.4 Same screen, two states, different geometry — token drift again

**Issues**
- The two states read as **different near-blacks** (~#1A1A1A vs ~#121212) — two grounds for one screen.
- CTA widths differ between states (~⅔ vs ~¾ of screen width); the shared spec says full width − 48pt.
- The ring is a 1–3px hairline whose empty track nearly vanishes on the ground; diameter/stroke also differ between the two states.

**Fixes**
1. Both states on `bg/base #141416`, exactly.
2. CTA per §5.4 on both states; "Begin" and "Next question" are the same component.
3. Ring spec (added to §5.4): **120pt diameter, 4pt stroke**, fill `accent`, track `track/progress` (visible but quiet).
4. QC rule: **two states of one screen must be pixel-identical except the content that changes** (figure, arc, copy, label). Build them as one component with states, not two screens.

### C.3.5 Hierarchy & accessibility

**Issues:** the ring figure ("0"/"1") is the largest text on the screen — bigger than the headline — so state outranks message; and the ring reads as three separate things (arc, number, label).

**Fixes**
1. Cap the figure at ≤ headline size (~34pt) or let the headline be the largest element on the intro state.
2. **VoiceOver: one element** — "1 of 6 answered" (merge ring, figure, label; hide the arc graphic); announce progress changes; headline carries `.isHeader`.
3. Dynamic Type: at AX sizes the label won't fit inside a 120pt ring — allow it to move below the ring.
4. Reduce Motion: skip any arc-draw animation.
5. "OF 6 ANSWERED" as a caps label is fine: `text/secondary`, 11–13pt, tracking +1.5 (passes contrast as designed).

### C.3.6 Copy polish (minor)

- "Each answer narrows the range." — "the range" is insider language. Plainer: "Each answer brings your level into focus."
- Leading with a giant "0" on the intro is honest but flat — consider the empty ring without the figure, letting "Six quick questions" own the screen (taste call; either works if hierarchy is fixed per C.3.5).
- Keep verbatim: "It takes about two minutes." and "Nothing is recorded until the end." — the best lines in the flow.

## C.4 Priorities — Screen03

| P | Item | Effort |
|---|---|---|
| **P0** | Both states on `bg/base`; identical CTA spec (full width − 48pt) — one screen, one geometry | Small |
| **P0** | Restore back/edge-swipe on question screens; decide the review-before-submit state | Small |
| **P1** | Interstitial frequency decision (recommended: progress on question screens + auto-advance; keep intro + final review) | Medium |
| **P1** | Ring spec (120pt / 4pt stroke / visible track) + single VoiceOver element; figure ≤ headline size | Small |
| **P2** | Copy pass ("narrows the range"), vary or drop repeated "Keep going", AX-size label placement | Small |

---

# Part D — Screen04 (Home · 4 tabs: Learn / Practice / Progress / You)

## D.1 What the screens are today

**Learn (01).** The photograph returns: a desaturated tree image runs behind the *entire* screen under a gradient scrim (lighter at top, darker toward the bottom). Header: "AUREL" wordmark left, streak pill right (flame icon + "0 DAY STREAK"). No "Learn" title — content starts at "CHAPTER ONE" (orange caps) / "Everyday Openings" (large) / "A2 · Elementary — eight lessons" (gray). A vertical lesson path: the active lesson is a large accent circle ("BEGIN" + play icon) on a darker halo; four locked lessons are smaller outlined circles with gray lock icons, titles beside each, connected by a thin **dashed** tan line.

**Practice (02).** Flat dark. Large left title "Practice" + two-line gray sub ("Loose ends and long-form. Nothing here is scored against you."). A full-width accent pill, "Speak with Aurel" / "Unscripted, five minutes, no grade" with a mic icon (subtitle inside the button). An outlined card "Review mistakes" / "Empty — nothing has slipped yet". Then "STORIES" caps header ("Graded readers" right-aligned) over three cards: *The Lighthouse Keeper* (light cream fill, dark text, A2 badge), *A Letter from Turin* and *Night Train, Slow Country* (dark muted fills, light text, A2/B1 badges, **lock icons**). Large Roman numerals I / II / III as art.

**Progress (03).** Flat dark. Large title "Progress" + sub ("The long view. Recorded quietly, shown only when you ask."). Two stat cards ("0 WORDS RETAINED", "0 MINUTES TOTAL" — numbers ~48px, one orange, one white). A text-only chart card "MINUTES, LAST 8 WEEKS" ("Eight weeks from now this will say something. Today it would be a single mark."). "THE LADDER" card: A1–C1 rows with hairline dividers — A1 "Passed" (sage), A2 "Here" (accent), B1–C1 "Ahead" (gray); every row carries its status word, not just color.

**You (04).** Flat dark. Identity header: orange circle avatar with black "M", "Maya Aldrin" (large bold), "A2 · Elementary — joined today" (gray). Three free-floating stats (0 STREAK / 0 WORDS / 0 LESSONS). A cream "Aurel Pro" card ("Seven days free, then unlimited") with a sage chip + star. A settings card list — Streak "0 days", Cedar Group "Rank 30", Subscription "Free", Settings, Help and contact — white labels, gray values, trailing chevrons, no separators. No sign-out, no edit-profile.

Shared: 4-tab bar (active = accent label + filled icon; inactive gray), solid dark bar.

## D.2 What works well — protect these

| Strength | Why it matters |
|---|---|
| The path metaphor finally drawn | A dashed trail through lesson nodes *is* "a quiet path" — the brand made visible. Keep and tokenize it. |
| Empty-state voice | "Empty — nothing has slipped yet", "Eight weeks from now this will say something" — witty, humane, on-brand. This is the app's best writing. |
| The ladder | A1–C1 with status words + color (not color alone) is honest, calm roadmap communication. |
| Roman-numeral story art | Editorial, zero-illustration-cost differentiation — very "Aurel". |
| Fill = state, not decoration | Available story = cream inversion; locked = muted dark (mirrors Screen02's cream selected card). One idea, reused. |
| Tone-consistent subs per tab | Each tab's subtitle sets expectations ("Nothing here is scored against you", "Recorded quietly, shown only when you ask"). |

## D.3 Weak points & improvements

### D.3.1 Color sprawl — the palette is no longer five ideas (this part's P0)

Green appears in at least three untokenized shades: ladder "Passed" sage, A2 badge fill (pale green), the Pro-card chip (olive). The two Progress stat numbers are colored differently (orange vs white) for no visible reason. Story fills mix light-cream and two dark tones — *stateful*, but undocumented, so it reads as arbitrary until you notice the locks.

**Fixes**
1. Add **one** green token: `success/sage #A5D6A7` — passes as text on dark (~9:1) *and* as a fill with `#1C1C1E` content (~10:1). Use it for: ladder Passed rows, A2 badges, the Pro chip (with a **dark** star — white-on-sage is ~2:1).
2. Stat numbers one color: `text/primary`. Accent is for *action and "you are here"* — not for one arbitrary metric.
3. Write the state rule: **available/selected = `surface/cream` inversion; locked/future = `card/default` muted; action = `accent`** (see §6).
4. Story badges: A2 = sage fill + dark text; B1 = `#4A4A52` fill + white text (~9:1). As verified, current badge text is already legible — tokenize it so it stays that way.

### D.3.2 Contrast & affordance details

1. **"Speak with Aurel" mic icon:** the label is dark; the mic reads white in one pass. Dark label + white icon on the same accent fill is a split decision — make the icon `text/on-accent` like the label (a white icon on accent is ~2.2:1).
2. **Tab bar inactive labels (~#666 on dark ≈ 3:1)** fail WCAG 4.5:1 for small text. Raise inactive tint to `#9A9AA0` (~6:1). Active accent tint ✓ (~8:1).
3. **Streak pill, Learn header:** flame + "0 DAY STREAK" on day one is a small demotivator (see D.3.4) and the copy stumbles ("0 day" → "0-day streak" or "Day 0").
4. **Ladder rows ~40pt** — if tappable (detail views later), raise to ≥44pt.

### D.3.3 The zero parade — no day-1 empty-state strategy

A brand-new user's default journey shows **seven zeros**: streak pill (Learn), two stat cards (Progress), three stats (You), plus "0 days" (You list). Honest — but nobody opens an app to be told "0" seven times.

**Fixes**
1. Apply the Progress-chart voice everywhere zeros appear: the chart card's copy is the model — acknowledge the emptiness with warmth instead of displaying a big "0".
2. Day-1 rules: hide the streak chip until streak ≥ 1 (or "Day 1 of your streak"); replace stat zeros with an em-dash or "Starts today"; You-stats could show "—" until first session.
3. **Metric duplication:** "WORDS" (You) vs "WORDS RETAINED" (Progress) — same number, two names; streak appears in Learn header, You stats, *and* You list. One source of truth, one name each; drop the You list "Streak" row.

### D.3.4 Learn tab — the path needs specs and reasons

**Issues:** the active node (accent circle on a halo) and locked nodes are hand-sized; the dashed connector is a one-off device; locked lessons show locks with **no unlock criteria**; the halo circle is an extra shape language.

**Fixes**
1. Tokenize the path (§5.4): active node 72pt `accent` on a 96pt halo at accent-15%; locked node 56pt `card/default` with lock icon; connector 2pt **dashed** `border/subtle` — the dash *is* the path metaphor, keep it, but as a token.
2. Add one line under the locked group: "Unlocks as you finish lessons." Silence about rules reads as broken, not mysterious.
3. Whole-row tap targets (as designed ✓); keep row height ≥72pt.
4. Keep the missing "Learn" title — "CHAPTER ONE / Everyday Openings" is the real content hierarchy. But ratify the header-mode rule (§6) so Practice/Progress (large title) vs Learn (brand header) vs You (identity header) is policy, not accident.

### D.3.5 Practice tab — two great cards, two questions

1. **"Speak with Aurel"** is a two-line CTA (~64pt tall). Fine — but define it as the *tall CTA* variant in the system (label + in-button sublabel), don't let it be a one-off. Mic icon per D.3.2.
2. **"Review mistakes — Empty"** is a perfect empty state. Decide: does an empty *card* stay tappable (dead tap = bug) or render disabled until it has content?
3. **Stories:** locks on cards 2–3 repeat the no-criteria problem (one line under the section: "New stories unlock as you climb."). The cream/dark fill states work — document them (D.3.1.3).
4. STORIES header + "Graded readers" aside is a nice editorial touch — make it the standard section header (§5.2).

### D.3.6 Progress tab — nearly there

1. Stat cards: unify number color (D.3.1.2); numbers at ~48px dwarf their labels — bring to ~28pt so labels and figures read as one unit.
2. **Chart placeholder:** the copy promises "a single mark" — *show it*: one accent dot on a hairline axis. Empty-but-acknowledged beats empty-and-textual; it also proves the chart exists.
3. Ladder: colors + status words ✓; add a `.isHeader` on "THE LADDER"; rows ≥44pt if they ever navigate; consider making the "Here" row's status a filled accent chip so "you are here" survives color-blind viewing (currently orange text only).

### D.3.7 You tab — missing table stakes

1. **No sign-out and no account-deletion path.** App Store review (guideline 5.1.1(v)) requires account deletion for registered accounts; sign-out is basic expectation. Add both (Settings sub-screen or a row + confirm sheet).
2. **No edit-profile affordance** (name/avatar). An identity header that can't be touched frustrates — pencil/Edit on the avatar, or the header taps into an edit sheet.
3. **"Cedar Group — Rank 30"** for a user who "joined today" is unexplained and numerically odd. Either explain it in-product ("Your class: Cedar · Rank 30 of 120") or hide until meaningful.
4. Aurel Pro card: cream card ✓ (token reuse), but no CTA text — add "Try free ›" so tappability is explicit; chip + star per D.3.1.1.
5. Settings rows ~50–56pt ✓; with 5 rows and no separators, spacing carries grouping — add hairline dividers (`border/subtle` @ 0.5pt) when the list grows past ~5 rows.

### D.3.8 Accessibility (all four tabs)

- **VoiceOver:** stats as single elements ("0 words retained"), ladder rows as "A2, Elementary, Here", story cards including badge + lock state, tab bar via system TabView.
- **Dynamic Type:** the lesson path and three-column You-stats are the risk spots — allow the path to become a plain list at AX sizes; stats stack vertically.
- **Learn's photo + scrim** guarantees contrast structurally ✓ — keep the scrim rule (§5.1) applied to the full screen, not just the header.
- **Reduce Motion:** no path-drawing animation, no badge pulses.

## D.4 Priorities — Screen04

| P | Item | Effort |
|---|---|---|
| **P0** | One green token (`success/sage`) across ladder/badges/chip; dark star on Pro chip | Small |
| **P0** | Stat numbers one color; tab-bar inactive tint to ~#9A9AA0 | Small |
| **P0** | Sign-out + account-deletion path; edit-profile affordance | Medium |
| **P1** | Day-1 empty-state strategy (hide/dash zeros; chart-copy voice flow-wide); metric dedupe | Medium |
| **P1** | Path tokens (nodes/halo/dashed connector) + unlock-criteria line on Learn and Stories | Small |
| **P1** | Mic icon to `text/on-accent`; "single mark" in the chart placeholder; Pro card CTA text | Small |
| **P2** | Header-mode documentation, ladder "Here" chip, settings dividers, Cedar Group copy | Small |

---

## 5. Design tokens (shared, implementation-ready)

### 5.1 Color

| Token | Value | Use |
|---|---|---|
| `bg/base` | `#141416` | Base dark: Screen02 background, launch screen, scrim target |
| `bg/photo-scrim-bottom` | `#000000 @ 85% → 0%` (bottom → ~52% height) | Screen01, behind text block |
| `bg/photo-scrim-top` | `#000000 @ 35% → 0%` (top → ~10% height) | Screen01, status bar floor |
| `text/primary` | `#FFFFFF` | Headlines, card titles |
| `text/secondary` | `#C7C9CD` (min 4.5:1 over base) | Subheads, card subtitles, counters |
| `text/on-accent` | `#1C1C1E` | CTA labels, selected-card title |
| `accent` | `#D9A066` | CTA fill, logo mark, progress fill, icons on dark |
| `accent/deep` | `#8A5A24` | Accent as text/icons on light or cream surfaces (~4.9:1 on white) |
| `surface/cream` | `#F8F5F0` | Selected-card fill (now); light content surfaces (later) |
| `card/default` | `#1E1E22` fill, `#3A3A40` 1pt border | Option cards |
| `track/progress` | `#4A4A52` | Progress bar / ring track |
| `success/sage` | `#A5D6A7` | The one green: "Passed" rows, A2 badges, Pro chip (~9:1 on dark; use `#1C1C1E` content on it) |
| `tab/inactive` | `#9A9AA0` | Inactive tab labels/icons (~6:1 on base) |

### 5.2 Type (iOS styles → Dynamic Type for free)

| Role | Style | Spec |
|---|---|---|
| Headline | `.largeTitle` weight bold | ~34pt, tracking −0.4, line-height ~1.15 |
| Subheadline | `.subheadline` / `.body` | 15–17pt regular, `text/secondary`, line-height ~1.45 |
| CTA label | `.body` weight semibold | 17pt, `text/on-accent` |
| Secondary CTA | `.body` | 17pt, `text/primary` @ 90% |
| Card title | `.body` weight semibold | 17pt |
| Card subtitle | `.subheadline` | 15pt, `text/secondary` (default) / `#4A4A50` (selected) |
| Progress counter | `.caption` | ~13pt, `text/secondary` (bar counter) |
| Ring figure + label | `.largeTitle` bold / `.caption2` | figure ≤34pt (never larger than headline); label 11–13pt uppercase, tracking +1.5 |
| Tab title | `.largeTitle` weight bold | Practice/Progress headers, ~34pt left-aligned |
| Stat value + label | `.title` bold / `.caption2` | ~28pt value (never 48pt); caps label, tracking +1.5 |
| Section header | `.footnote` weight semibold | ~13pt uppercase, tracking +1.5, `text/secondary`; right-aligned aside allowed |
| Wordmark | `.caption` weight semibold | ~13pt uppercase, tracking +1.2 |

### 5.3 Spacing (8pt grid)

`4 · 8 · 12 · 16 · 24 · 32 · 48 · 64`

Screen margin **24** · headline→subhead **12** · subhead→content **32–40** · card gap **12** · section gap **24** · CTA→secondary **16** · any element→home-indicator area **≥16**.

### 5.4 Components & radii

| Element | Spec |
|---|---|
| Primary button | Full width − 48pt, height ≥ 50pt, radius = height/2 (pill), fill `accent`, label `text/on-accent` |
| Secondary button | Text style, tap area ≥ 44×44pt, pressed opacity 0.6, optional trailing `›` |
| Option card | 64pt tall, radius 16, states per B.3.4, tap area = full card |
| Progress bar | 4pt tall, fill `accent`, track `track/progress`, counter right-aligned |
| Progress ring | 120pt diameter, 4pt stroke, fill `accent`, track `track/progress`; one VoiceOver element ("x of 6 answered") |
| Tab bar | System `TabView`, 4 tabs, SF Symbols; active tint `accent`, inactive `tab/inactive`; icons filled both states |
| Lesson path node | Active: 72pt `accent` node on 96pt halo (accent @ 15%). Locked: 56pt `card/default` + lock. Connector: 2pt dashed `#3A3A40`. Row ≥72pt, whole row tappable |
| Story card | ≥72pt tall, radius 16; available = `surface/cream` fill + dark text, locked = `card/default` + light text + lock; numeral as ghost art; badge pill (A2 `success/sage`+dark text, B1 `#4A4A52`+white) |
| Stat card | ~72pt tall, radius 16, `card/default` fill, value 28pt `text/primary` + caps label |
| Settings list row | ≥44pt (50–56 typical), label `text/primary` 17pt, value `text/secondary`, chevron `#6A6A72`, hairline dividers when >5 rows |
| Tall CTA | The "Speak with Aurel" variant: accent pill, 64pt, label 17pt semibold + in-button sublabel 13pt, icon `text/on-accent` |
| Back control | System chevron preferred; custom ≥ 44×44pt, affordance ≥ 3:1 |
| Touch targets | 44×44pt minimum everywhere (HIG floor) |
| Radius scale | pill (buttons) · 14 (logo mark) · 16 (cards) — no other ad-hoc radii |

---

## 6. Cross-screen consistency (flow-wide)

1. **One base color.** Every dark surface sits on `bg/base #141416` exactly. Drift found so far: Screen02's ground, Screen03's two states (~#1A1A1A vs ~#121212), and the Home tabs. One token, every surface.
2. **One display face.** Screen02's headline appears serif where Screen01's is sans — confirm in the source, then apply one headline treatment to every screen in the flow.
3. **One CTA geometry.** "Start learning", "Continue", "Begin", "Next question" (and the tall "Speak with Aurel" variant) are one component family: full width − 48pt, pill, `accent` + `text/on-accent` (§5.4).
4. **Two layout modes — write the rule.** Content screens = left-aligned; "moments" (interstitials, transitions, empty/celebration states) = centered (C.3.3). CTA geometry is identical in both modes.
5. **Color = meaning, and only three meanings.** `accent` marks *action* and *you-are-here*; `surface/cream` marks *selected/available state*; `success/sage` marks *passed/achieved*. Everything else is base, card, or text tone. Story-card fills and Screen02's selected card already follow this — the rule just makes it enforceable. No new hues without a meaning.
6. **Photo scope — ratify the split.** The photo returns on Learn (full-screen under scrim) after flat onboarding. Keep the split as policy: **photo on Welcome + Learn (the path), flat on Practice/Progress/You (the tools)**, with the full-screen scrim rule (§5.1) always applied. Crossfade between them (Reduce Motion-aware).
7. **Three header modes — document them.** Learn = brand header (wordmark + streak chip); Practice/Progress = large title + sub; You = identity header (avatar + name). All three left-aligned on the 24pt axis.
8. **Interstitial economy.** Every extra "moment" screen costs a tap (C.3.1). Progress belongs on question screens; moments belong at start and end.
9. **States of one screen are one component.** States differ only in the content that changes — never in ground color, geometry, or CTA width (C.3.4).
10. **One name per metric.** "Words retained" once — not "Words" on You; streak lives in the Learn header, not in three places (D.3.3).
11. **Flow decisions to close out:** single- vs multi-select goals (B.3.4); onboarding skip; Continue enable logic (B.3.4); interstitial frequency (C.3.1); review-before-submit (C.3.2); sign-out/deletion + edit-profile (D.3.7); day-1 zeros strategy (D.3.3); unlock-criteria copy for lessons and stories (D.3.4/D.3.5).

| P | Cross-screen item | Effort |
|---|---|---|
| **P1** | Align `bg/base` and CTA geometry across all screens/states | Small |
| **P1** | Pick the display face (serif vs sans) once; apply flow-wide | Small |
| **P1** | Ratify layout-mode, color-meaning, photo-scope, and header-mode rules; audit all screens against them | Small |
| **P1** | Tab-bar inactive tint fix; one green token | Small |
| **P2** | Crossfade spec; the §6.11 decision list | Medium |
