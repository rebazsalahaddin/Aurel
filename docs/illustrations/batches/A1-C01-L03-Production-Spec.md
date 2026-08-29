# Aurel Illustration Production Specification — A1-C01 / L03 “A Real First Meeting”

**Status:** Accepted and integrated 2026-08-28  
**Reference standard:** approved Lesson 1–2 visual system and production cast key  
**Production order:** storyboard Set F (`ILL023–ILL027`), continuity review, challenge scene (`ILL028`), then reading surfaces (`ILL029–ILL030`)

## Course and placement audit

- **Lesson objective:** understand and rehearse a complete first meeting: arrive and greet, welcome, ask and give names, say “Nice to meet you,” ask and answer “How are you?”, and close politely.
- **Primary placements:** S20 five-panel conversation storyboard, S21/S23 listening testlets, S25 practice and image options, S27 badge reading, and S28 welcome-card reading.
- **Later reuse:** `ILL023` also supports L04/S30 mission brief; `ILL028` and `ILL030` also support L04/S33 quiz.
- **Storyboard continuity:** `ILL023–027` are one morning event at one Community House welcome table. Nina and Maya, clothing, badge design, table, cups, camera height, light direction, and background architecture must remain stable across the sequence.
- **Renderer integration:** S20 currently exposes five authored panel identifiers but only renders text placeholders. S27 and S28 decode app-layer text but do not show their authored art surfaces. This batch includes renderer support so the accepted illustrations are visible and correctly layered in the real screens.

## Shared production contract

- **Approved visual language:** original premium contemporary editorial 2D; believable adult proportions; softly geometric faces; modest eyes; controlled warm-charcoal line; matte cream, terracotta, sage, mustard, teal, and muted-slate color blocks; restrained paper texture; broad soft shadows; quiet natural light; background detail below subject detail.
- **Delivery:** opaque non-interlaced sRGB PNG; 960×540 in the 2x slot and 1440×810 in the 3x slot; no assigned 1x bitmap.
- **Safe zone:** every face, complete hand, blank badge, overlay surface, and teaching gesture inside 8% horizontal / 10% vertical; critical details outside the outer 12% corners.
- **Continuity:** Alex, Maya, Leo, and Nina must match the approved production cast key and accepted Lesson 1–2 assets. Canonical clothing and accessories remain stable.
- **Educational test:** the social action and temporal order must be understandable before words are read. Arrival, welcome, name exchange, meeting, and exit must not collapse into interchangeable two-person poses.
- **Universal avoid list:** photorealism, photo-adjacent rendering, artist/publisher imitation, anime, oversized eyes, chibi anatomy, stock-vector corporate styling, glossy 3D, dramatic rim light, clutter, excessive micro-detail, malformed or duplicate anatomy, incorrect finger count, merged hands/objects, duplicate props, impossible perspective, internal frames, borders, captions, letters, names, pseudo-writing, signs, logos, and watermarks.

## Set F — five-panel first-meeting storyboard

Use the Community House welcome-table visual language established by accepted `ILL002`: cream architecture, simple garden foliage, restrained table, exactly three ceramic cups when cups are visible, and soft low morning light. Use the same eye-level camera family and matte palette across all five panels. Nina and Maya wear identical blank two-line name badges throughout the sequence. The panels must still read as a coherent strip when reduced to thumbnails.

### A1-C01-ILL023 — arrival / greeting

- **Meaning:** Nina arrives; the first greeting starts the conversation.
- **Scene:** canonical Nina approaches the welcome table from the left with one small open five-finger wave. Canonical Maya waits behind or beside the table on the right and returns one smaller wave.
- **Direction:** Nina’s walking path clearly moves toward Maya and the table; neither person appears to leave.
- **Continuity:** Nina’s grey-streaked low bun and teal cardigan; Maya’s tied-back dark wavy hair, olive jacket, cream top, and star pin; both blank badges visible but secondary.
- **Framing:** medium-wide, eye level, table and Community House doorway readable, exactly three cups if cups enter frame.
- **Alt source:** “Nina walks toward the welcome table where Maya waits, waving, in morning light.”

### A1-C01-ILL024 — welcome

- **Meaning:** Maya warmly welcomes Nina.
- **Scene:** at the same table, camera family, and morning light, Maya gives one warm open-palm welcome gesture across the table toward Nina. Nina receives the welcome with relaxed attentive posture.
- **Distinction:** Maya’s gesture opens toward the place/table rather than toward Nina’s badge; no handshake, name gesture, or goodbye wave.
- **Framing:** medium two-shot with one dominant complete hand; exactly three cups arranged simply if visible.
- **Alt source:** “Maya makes a warm open welcome gesture toward Nina across the welcome table.”

### A1-C01-ILL025 — name exchange

- **Meaning:** Nina asks Maya’s name; Maya identifies herself.
- **Scene:** Nina and Maya face each other at the same table with exactly two blank two-line badges clearly visible. Nina extends one gentle open questioning hand toward Maya’s badge while Maya lightly touches or openly gestures to her own badge.
- **Distinction:** badge-directed question and self-identification are the dominant cues; no handshake or farewell wave.
- **Object logic:** hands do not cover badge slots; exactly two blank badges; no text or pseudo-writing.
- **Alt source:** “Nina and Maya face each other at the table, blank name badges visible, as they ask and give their names.”

### A1-C01-ILL026 — first-meeting moment

- **Meaning:** “Nice to meet you.”
- **Scene:** Nina and Maya share exactly one natural handshake at the same welcome table, with friendly mutual eye contact and relaxed free arms.
- **Distinction:** the single handshake is unambiguous and central; no second greeting gesture or badge-directed hand.
- **Anatomy:** each wrist belongs clearly to its arm; plausible fingers; one clean contact; hands remain inside the safe zone.
- **Alt source:** “Nina and Maya clasp hands warmly at their first meeting, both smiling.”

### A1-C01-ILL027 — polite exit

- **Meaning:** Maya says “Excuse me … see you” and moves back to the table; the conversation ends politely.
- **Scene:** canonical Maya takes a visible step toward the three cups on the welcome table while turning her head and upper body back to give one small wave. Nina remains behind and returns a smaller wave.
- **Direction:** Maya’s feet and spatial path clearly point to the table, away from the conversation. Nina does not appear to leave.
- **Distinction:** this is an exit, not an arrival or mutual hello; preserve the same location, clothing, badges, and morning light.
- **Alt source:** “Maya steps toward the cups, turning back to wave; Nina waves back — a polite goodbye.”

## Challenge scene

### A1-C01-ILL028 — café terrace afternoon meeting

- **Meaning:** Leo and Maya meet at the Aroa Café in clear afternoon light; supports the full challenge dialogue and the time-of-day question.
- **Scene:** on the accepted café-terrace environment family, canonical Leo faces Maya and gives one friendly open five-finger wave. Maya returns a smaller greeting gesture. Leo wears his blue apron over the cream-and-slate striped shirt; Maya wears her olive jacket and star pin.
- **Time cue:** high bright daylight, low-chroma blue sky, and short soft shadows unmistakably signal afternoon without a dominant sun disk.
- **Framing:** eye-level medium two-shot; simplified café window/table context; exactly two untouched cups if cups are present.
- **Distinction:** clearly a meeting start, not the `ILL022` reciprocal “How are you?” gesture or `ILL027` exit.
- **Alt source:** “Leo waves to Maya from the café terrace under a high afternoon sun.”

## Reading surfaces — app-layer text hosts

Both images are intentionally text-free. Their blank regions must align across compact, standard, and large iPhone widths. The renderer places all names and reading text in SwiftUI with Dynamic Type; image generation must never bake letters or pseudo-writing into the surfaces.

### A1-C01-ILL029 — two blank name badges

- **Meaning:** two readable name-badge schemas side by side for MAYA / HADDAD and LEO / NOVAK app-layer text.
- **Scene:** near-top-down view of exactly two identical matte-cream badges lying horizontally on the welcome table. Both badges are nearly frontal, unrotated or rotated less than two degrees, equal in size, and centered at approximately 31% and 69% of frame width and 52% of frame height.
- **Geometry:** each badge occupies about 31% of frame width and 34% of frame height. Each contains exactly two quiet empty text regions: shorter upper and longer lower. Leave generous clean interiors for app text; one simple pin tab per badge.
- **Background:** simple matte tabletop with restrained paper/wood texture and no foliage shadow crossing either badge.
- **Avoid:** perspective distortion, tilted badges, unequal sizes, extra slots, drawn letters, pseudo-writing, hands, faces, or additional objects.
- **Alt source:** “Two blank name badges lie side by side on the welcome table, each with an empty top and bottom line.”

### A1-C01-ILL030 — blank welcome card

- **Meaning:** a reusable reading surface for the app-layer lines “Welcome!” and “My name is Alex.”
- **Scene:** one matte-cream tented welcome card standing on the welcome table, centered and nearly frontal. The front face occupies about 58% of frame width and 46% of frame height, centered near 50% width / 53% height.
- **Geometry:** exactly two large clean text regions, upper and lower, with enough separation for two responsive lines. Any guide slots remain extremely subtle and contain no marks. Keep the full card silhouette and both lower corners visible.
- **Background:** restrained tabletop and soft cream/sage environment shapes; even quiet light across the card face so app text remains legible.
- **Avoid:** strong cast shadows over the card, skewed perspective, foliage crossing the face, extra cards, letters, pseudo-writing, logo, decorative border, or hands.
- **Alt source:** “A small blank welcome card stands on the table with two empty lines where a greeting and a name can go.”

## Integration requirements

- S20 must render one prominent active 16:9 panel and a five-scene thumbnail rail. Panel identifiers `ILL023–ILL027` resolve against the current chapter. The active panel follows the conversation-turn groups: `T1→023`, `T2→024`, `T3–T4→025`, `T5–T7→026`, `T8→027`; tapping a thumbnail moves the visual focus without exposing internal asset IDs.
- S27 must place MAYA/HADDAD and LEO/NOVAK over the two blank `ILL029` badge faces as app-layer text; preserve accessible combined reading labels.
- S28 must place “Welcome!” and “My name is Alex.” over `ILL030` as app-layer text; preserve accessible combined reading labels.
- All overlays must scale from image geometry rather than fixed pixels, remain aligned at compact/standard/large widths, and remain legible under supported Dynamic Type.

## Batch QA gates

For every image, inspect face identity, hairline, ears, eyes, mouth, badge count and blankness, finger count, wrist/hand ownership, shoulder/limb connections, grip/contact, cup count and ownership, floor/table perspective, text artifacts, safe zones, exact ratio, color profile, and thumbnail legibility. Compare `ILL023–027` as one temporal strip and inspect gesture direction for arrival versus exit. Compare `ILL025` against `ILL019/020` and `ILL026` against `ILL021` so continuity is retained without semantic ambiguity. Validate S20, S21/S23 image uses, S25 image options, S27, and S28 in the real app at compact, standard, and large iPhone sizes before final acceptance.

## Production outcome

- All eight masters were generated individually with the built-in `image_gen` workflow, using the approved cast-continuity key for character scenes. No CLI generator, stock image, external generator, or blind batch fallback was used.
- Accepted source masters are preserved byte-for-byte in `Archive/IllustrationProduction/2026-08-28-A1-C01-L03/masters/`. Active catalog images are opaque non-interlaced sRGB PNGs at 960×540 for 2x and 1440×810 for 3x, with the universal 1x slot intentionally unassigned.
- The untouched pre-production originals remain recoverable under `Archive/LegacyIllustrations/2026-08-27-active-a1-c01/Assets.xcassets/`. Their archived hashes were verified before active replacement; the retired active legacy copies were removed only after catalog validation.
- S20 now renders a prominent active storyboard panel plus five selectable thumbnails with the authored turn mapping. S27 and S28 now render `ILL029` and `ILL030` with responsive, accessible SwiftUI text overlays.
- The three Lesson 3 production-art UI tests passed with zero failures on iPhone 17e, iPhone 17 Pro, and iPhone 17 Pro Max. Manual evidence review confirmed storyboard continuity, cup/badge counts, gesture direction, thumbnail fit, overlay alignment, safe zones, and absence of clipping on all three targets.
- Accepted screenshots are retained under `qa/evidence/illustration-production/A1-C01-L03/`; the initial standard capture export is preserved separately as `standard-iPhone-17-Pro-initial-transition-captures/` and is not the accepted evidence set.
- The iPhone 17 Pro simulator build completed successfully after renderer and catalog integration.
