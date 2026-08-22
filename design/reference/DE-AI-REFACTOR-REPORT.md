# Aurel — De-AI Refactor Report

**Date:** 16 August 2026
**Scope:** Full design + code review of the Aurel welcome screen and design system, with the goal of removing every cue that makes the app read as "designed and built by AI," and replacing it with deliberate, senior-level craft.
**Result:** All 14 identified tells resolved. Build succeeds with zero warnings. Verified on iPhone 17 Pro, 17 Pro Max, and iPhone 17e simulators with pixel-level screenshot sampling.

---

## 1. The problem, in one paragraph

The app's engineering bones were sound — dark-first color lock, scrim-based contrast engineering, token architecture, HIG-compliant touch targets. But everything sitting *on* those bones carried recognizable AI fingerprints: a raw AI-generated background whose filename was literally the image-generator prompt, one novelty font doing every typographic job, over-written "clever" copy, an empty app icon, code comments citing spec documents that don't exist, and numbers in comments that contradicted the code beneath them. A veteran reviewer would spot most of these within five minutes.

---

## 2. Tell → Fix — the complete list

### Tier 1 — The loudest tells

#### 1. AI-generated background image (prompt saved as the filename)

**Before:** The welcome backdrop was a single 1024×1536 PNG named
*"Enhanced high-definition sky version of the dark nature iPhone app welcome background, with smoother twilight gradients, reduced pixelation…"* — an image-generator prompt used as a filename, visible to anyone who opens the asset catalog. It was registered at **1× only** (a 3× device needs 1179 px of width — the image was being upscaled and rendered soft), it had AI photography's tell-tale over-smoothed look, and it was un-repeatable for future screens.

**After:** The image was deleted. `AurelBackground.swift` now draws a **hand-authored, fully procedural twilight hillside**:

- **Sky** — a 6-stop vertical gradient from ink charcoal at the zenith through dusty mauve into amber at the horizon.
- **Horizon glow** — a soft radial bloom in `.plusLighter` blend mode where the sun has just set.
- **Hills** — three silhouettes (far/mid/near) stepping toward the viewer; depth through value, not detail. Ridge lines are smooth quadratic curves through seeded points, with an edge-fade easing the ridge down toward both screen edges so the composition breathes in the middle.
- **Stars** — 46 sparse, low-alpha specks confined to the upper sky.
- **Film grain** — a 160 px mid-gray noise tile rendered once into a `UIColor` pattern, tiled at 5% opacity in `.overlay` blend. This texture is what keeps a vector scene from reading as a flat gradient.
- **Determinism** — a tiny SplitMix64 PRNG (`SeededRandom`) with fixed seeds. The same scene renders on every device, at every resolution, forever. *Empirically verified:* pixel samples were byte-identical across three different device simulators.

**Why it's better:** resolution-independent (kills the 1×/2×/3× problem), zero asset bytes, ownable and repeatable on every future screen, and it cannot carry anyone else's fingerprints.

#### 2. No app icon

**Before:** `AppIcon.appiconset` contained an empty stub `Contents.json` with three unfilled entries (light/dark/tinted).

**After:** Real 1024×1024 PNGs generated for all three slots via a one-time CoreGraphics/CoreText script (kept in `/tmp`, never committed):
- **Light:** amber ground + ink "A"
- **Dark:** warm-ink ground + amber "A"
- **Tinted:** neutral grays (the system applies its own tint)

The glyph is optically centered using its *tight* glyph-path bounds — not the line box — with a 0.8%-of-size upward nudge, because a triangular glyph carries its mass above geometric center. The icon and the in-app logo mark now share one brand system.

#### 3. One novelty font doing every job

**Before:** Caprasimo — a chunky rounded novelty display face — was used for the headline, wordmark, logo glyph, *and button labels*. Applying a display face to UI chrome is the classic "AI found one cool font" pattern.

**After:** A deliberate **two-tier type system** in `AurelFont.swift`:
- **Display tier:** Caprasimo, restricted to exactly two jobs — the headline and the logo glyph.
- **UI tier:** SF Pro with deliberate weights — small-caps semibold wordmark (tracking 2.4), semibold button labels, system subhead.

**Why:** professionals never set UI chrome in a novelty face. The contrast between the display tier (personality) and UI tier (restraint) is itself a designed decision.

#### 4. Over-written "clever" copy

**Before:** *"A quiet path from your first hello to the argument you win. Ten minutes a day, no confetti."* — two punchlines in one sentence, quirk for quirk's sake, and "unhurried" duplicated from the headline above it.

**After:** *"A few calm minutes a day — from your first words to real conversations."* One idea, one breath, no jokes. ("English, unhurried." was kept — it's genuinely good.)

---

### Tier 2 — Design-craft tells

#### 5. The default letter-in-a-rounded-square logo

**Before:** A Caprasimo "A" in a 62 pt rounded rect at radius 14, white on amber — the default AI brand mark, with zero optical correction.

**After:** Radius raised to 18 (proportional to the 62 pt mark), glyph switched from white to **ink** (`onAccent` — one consistent rule: ink-on-amber everywhere, matching the CTA), and a documented −1.5 pt optical nudge because the glyph's line box runs deep.

#### 6. Temperature-broken palette

**Before:** Warm cream primary (`#F6EFE3`) and warm tan accent — but a **cold blue-gray** secondary (`#C7C9CD`) that belonged to a different color-temperature family entirely.

**After:** Secondary retuned to warm gray `#CDC6B9`, in the same temperature family as the cream and amber. One warm family, one accent — harmony by construction, with contrast (4.5:1+) maintained over both the base ground and the darkened glow band where the subhead actually sits.

#### 7. Empty AccentColor colorset

**Before:** The asset-catalog accent was an empty stub while colors lived only in Swift — meaning any system surface (alerts, text fields, links) would flash default iOS blue inside a warm-amber app.

**After:** `AccentColor.colorset` populated with the true accent for light, dark, **and** high-contrast appearances (a slightly brighter amber for increased contrast). Code and asset catalog now agree.

#### 8. No motion identity or touch feel

**Before:** Only a snappy press-scale. Silent taps, no entrance — the screen simply appears.

**After:**
- **One-time entrance:** the bottom group rises 14 pt and fades in over 0.6 s ease-out; the wordmark fades separately. Guarded so it never re-runs on reappear. Unhurried, like the brand — no springs, no loops.
- **Soft haptic** fires on primary-button press-down (acknowledgement, not celebration).

---

### Tier 3 — Engineering tells

#### 9. Phantom documentation

**Before:** Comments cited `DesignImprovements.md §5.1/§5.3/§5.4/§A.3.5` and `Ref_Temp/Screen01_StartingScreen.png` — **neither exists in the repo**. Confident citations of fictional spec files are a classic LLM tell.

**After:** Every phantom reference deleted. Grep-verified: zero occurrences of `DesignImprovements`, `Ref_Temp`, `Screen01`, or `WelcomeBackground` remain anywhere in the project.

#### 10. Comments contradicting the code

**Before:** The wordmark comment said "18.5 pt" over 16 pt code; the logo glyph was "29 pt" in one file and "31.5 pt" in another; the CTA said "15 pt" over 16 pt code.

**After:** All comments rewritten to describe what the code actually does. This audit also caught a **pre-existing lie**: the accent comment claimed `#D9A066` while the code values were actually `#BC7543`. Since the app has only ever rendered `#BC7543` — and the deeper amber sits better in the new dusk scene — every surface (code token, asset catalog, all three icons) now truthfully uses `#BC7543`.

#### 11. Speculative design system

**Before:** A full `xs`→`xxxl` spacing scale and `AurelRadius.card` existed for screens that don't exist, while real paddings (24, 32, 12, 300…) bypassed the scale inline.

**After:** Scale trimmed to the steps actually in use (`sm/md/lg/xl/xxl` + `screenMargin`); `card` radius removed; every inline padding in `WelcomeView` moved onto the token scale.

#### 12. Hardcoded `frame(width: 300)` on body copy

**Before:** The subhead was locked to 300 pt — on a 320 pt device the available width after margins is 256 pt, so the text clipped.

**After:** Responsive: `frame(maxWidth: 344, alignment: .leading)` + `fixedSize(horizontal: false, vertical: true)`. The measure constraint survives; the clipping bug doesn't.

#### 13. `"Aurel".uppercased()` on a string literal

**Before:** Uppercasing a literal at runtime instead of writing the intended text.

**After:** `Text("Aurel")` with true small caps applied on the `Font` token itself — typographically correct (small caps, not scaled-down capitals), and honest.

#### 14. Pointillist over-commenting

**Before:** Fake-precision commentary ("Caprasimo's line box adds ~13 pt above the glyphs", "measured ≈37 pt") padding every line.

**After:** Comments are terse and true, describing intent rather than performing measurement theater.

---

## 3. What was deliberately kept

The review wasn't all deletion — these decisions were correct and survive untouched:

- **Dark-first lock** (`.preferredColorScheme(.dark)`) — a real design decision, correctly reasoned and commented.
- **The two-part scrim** — light floor over the status bar, deep floor under the copy block. Good contrast engineering; only its values were retuned to the new sky.
- **Bottom-anchored composition with scroll fallback** — the `GeometryReader` + `ScrollView` + `minHeight` pattern that anchors content to the bottom but scrolls at accessibility type sizes.
- **Quiet press states** — squeeze + transparency on primary, fade on secondary. Already restrained; the haptic was added on top.
- **HIG 44 pt minimum touch target** on the secondary button.
- **Token architecture itself** — the enum-based design system structure was right; only its contents were wrong.

---

## 4. Files changed

| File | Change |
|---|---|
| `DesignSystem/AurelBackground.swift` | **Rewritten** — procedural twilight scene (sky, glow, hills, stars, grain) + scrim, replacing the AI photograph |
| `Features/Welcome/WelcomeView.swift` | **Rewritten** — entrance motion, grouped bottom block, responsive copy, refined wordmark/logo, token-based spacing |
| `DesignSystem/AurelFont.swift` | Two-tier type system; Caprasimo restricted to display jobs; SF Pro UI tier |
| `DesignSystem/AurelColor.swift` | Warm-family secondary; truthful accent hex; honest comments |
| `DesignSystem/AurelSpacing.swift` | Trimmed to steps in use |
| `DesignSystem/AurelRadius.swift` | `card` removed; logo radius 14 → 18 |
| `DesignSystem/Components/PrimaryButton.swift` | SF Pro semibold label; soft haptic on press |
| `DesignSystem/Components/SecondaryButton.swift` | Comment cleanup |
| `Assets.xcassets/AccentColor.colorset` | Populated (light / dark / high-contrast) |
| `Assets.xcassets/AppIcon.appiconset` | Three real 1024×1024 icons generated |
| `Assets.xcassets/WelcomeBackground.imageset` | **Deleted** |

The icon generator script lives at `/tmp/aurel_icon/gen.swift` — deliberately outside the repository (it's a one-time tool, not part of the product).

---

## 5. Verification

| Check | Result |
|---|---|
| `xcodebuild` (iPhone 17 Pro simulator) | `** BUILD SUCCEEDED **`, zero warnings |
| Screenshot pixel samples — iPhone 17 Pro (1206×2622) | Ink sky `(16,14,19)` · dusk band `(35,26,33)` · glow `(116,79,51)` · near hill `(6,6,6)` · accent pill exactly `(188,117,67)` = `#BC7543` · cream headline present (60k px) |
| Screenshot pixel samples — iPhone 17 Pro Max (1320×2868) | Identical sampled colors — determinism proven empirically |
| Screenshot pixel samples — iPhone 17e | Identical sampled colors; responsive layout intact on the smaller width |
| Icon PNGs | All three verified 1024×1024 |
| Leftover-reference grep (`WelcomeBackground`, `DesignImprovements`, `Ref_Temp`, `Screen01`, `primaryCTA`, `uppercased`, `xs`, `xxxl`, `.card`) | Zero matches across 13 files |

**Known limitation:** the screenshots and icons could not be eyeballed visually in the review environment — they were verified by pixel sampling instead. A human pass in the simulator is recommended; the scene's tuning knobs (hill `baseY`/`amplitude`, glow position and intensity, star count, grain opacity at 0.05) are isolated constants, easy to adjust to taste.

---

## 6. The principles behind the fixes

For future screens, the rules that governed this refactor:

1. **Own every pixel.** No borrowed or generated imagery that can't be reproduced exactly. Vectors + seeds over assets.
2. **One type face = one job.** Display faces carry personality; system faces carry UI. Never mix those jobs.
3. **One color temperature.** A palette is a family, not a list.
4. **Copy says one thing.** One idea per sentence; zero jokes competing with each other.
5. **Motion acknowledges, never performs.** One entrance, subtle press states, haptics as touch-confirmation.
6. **Comments tell the truth.** If a comment cites a number or a document, that number or document is real — or the comment goes.
7. **Build only what ships.** No speculative tokens, no hypothetical APIs.
