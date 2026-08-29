# Aurel Illustration Production Specification — A1-C01 Chapter 1 Closeout

**Status:** Accepted, integrated, and QA-passed 2026-08-28  
**Scope:** `A1-C01-ILL012`, `A1-C01-ILL031–ILL034`  
**Purpose:** replace the final five Chapter 1 legacy bitmaps and close the chapter-wide illustration catalog  
**Production order:** Sam anchor (`ILL031`), Sam/Nina scene (`ILL032`), Sam badge surface (`ILL033`), time triptych (`ILL034`), retained yes/no comparison (`ILL012`)

## Placement and continuity audit

- `ILL031` is the arrival/hello image in L04/S33 `QZ-V002`.
- `ILL032` is the give/get thank-you scene in `QZ-V004` and the first-meeting order scene in `QZ-CN002`.
- `ILL033` is Sam Rivera's blank badge on his green t-shirt in `QZ-G001`, `QZ-LS001`, and `QZ-RD001`, and is referenced again by L04/S34a. Only `QZ-RD001` may add `SAM / RIVERA`, and that text must be app-layer typography.
- `ILL034` is the three-time-of-day street comparison in `QZ-V006`; the third panel must unmistakably mean evening.
- `ILL012` has no current live course object reference. Its archived image establishes a two-panel Alex yes/no comparison. The replacement preserves that semantic value so the catalog has no remaining legacy exception.
- Sam Rivera is 25, he/him, with short dark curly hair, a warm round face, a green t-shirt, a blank name badge on a red lanyard, and a canvas tote over one shoulder. Do not infer or add unregistered identity details.

## Shared production contract

- Original premium contemporary editorial 2D illustration; believable adult proportions; softly geometric faces; modest eyes; controlled warm-charcoal line; matte cream, terracotta, sage, mustard, teal, muted green, and muted-slate blocks; restrained paper texture; broad soft shadows; quiet natural light.
- Exact landscape 16:9 composition; faces, complete hands, badge surfaces, hand-object contact, and teaching cues inside 8% horizontal / 10% vertical safe zones.
- Opaque, non-interlaced sRGB PNG delivery at 960×540 in the 2x slot and 1440×810 in the 3x slot; universal 1x bitmap remains unassigned.
- No text inside any image. `ILL033` must contain two truly blank regions large enough for app-layer text.
- Avoid photorealism, photo-adjacent rendering, artist/publisher imitation, anime, chibi anatomy, oversized eyes, stock-vector styling, glossy 3D, dramatic rim light, clutter, excessive micro-detail, malformed or duplicate anatomy, incorrect fingers, merged hands/objects, duplicate props, impossible perspective, decorative frames, captions, letters, names, pseudo-writing, signs, logos, and watermarks.

## Asset briefs

### A1-C01-ILL031 — Sam arrives and says hello

- Canonical Sam walks toward an open Aroa corner-shop doorway while giving one friendly open five-finger wave.
- His leading foot and body path point toward the doorway; this is an arrival and meeting start, never an exit.
- Preserve short dark curls, warm round face, green t-shirt, blank badge on a red lanyard, and canvas tote over one shoulder.
- Use bright neutral daytime light and a simplified culturally neutral corner-shop exterior. Keep the complete wave, feet, doorway, and blank badge readable.
- No other person, goodbye staging, shop sign, lettering, pseudo-writing, or extra badge.

### A1-C01-ILL032 — Sam gives Nina a small box

- At the Community House welcome table, canonical Sam offers one small plain matte box with both hands while canonical Nina receives it with both hands and a warm grateful smile.
- Preserve Sam's green t-shirt, red lanyard, blank badge, and short dark curls; preserve Nina's grey-streaked low bun, teal cardigan, cream top, and dark trousers.
- One box only. The box remains centered between them; four hands must have clear ownership, plausible fingers, and clean contact without merging.
- This must read as give/get/thank-you and also as a calm new meeting. Use quiet morning-to-midday light and restrained Community House context.
- No gift ribbon, text, logo, duplicate box, extra hand, handshake, or cup competing with the exchange.

### A1-C01-ILL033 — Sam's blank badge surface

- Close view of Sam's green t-shirt and red lanyard, with one matte-cream badge nearly frontal and centered.
- Show exactly one badge with exactly one simple top attachment and exactly two subtle blank capsule-like regions: shorter upper first-name region and longer lower last-name region.
- The badge occupies about 46% of frame width; both blank regions are evenly lit and large enough for responsive `SAM` and `RIVERA` app-layer text.
- No face, hands, letters, names, pseudo-writing, extra pin, extra slot, logo, or decorative border.

### A1-C01-ILL034 — morning / afternoon / evening street triptych

- Three equal vertical panels show the exact same Aroa corner-shop street geometry from the same camera and crop.
- Panel one: low rising sun outside the frame, warm horizontal light, and long soft shadows — morning.
- Panel two: high neutral daylight, low-chroma blue sky, and short soft shadows — afternoon.
- Panel three: dark blue sky and two warm street lamps/building lights — evening.
- Maintain identical building, doorway, awning, tree, pavement, and perspective across all panels. Use only quiet separators; no decorative border.
- No people, words, signs, clocks, numerals, sun labels, moon symbol, or changing architecture.

### A1-C01-ILL012 — Alex yes/no comparison

- Two equal vertical panels on one calm cream editorial background show canonical Alex waist-up in the same camera, scale, mustard sweater, glasses, and neutral light.
- Left panel: Alex gives one small affirmative nod with a relaxed positive expression and arms down.
- Right panel: Alex gives one clear gentle head shake plus exactly one complete open refusal hand at chest height.
- The distinction must be understandable from posture and gesture without words or color-only coding. Use no motion glyphs, checkmarks, crosses, punctuation, or embedded panel labels.

## Renderer integration requirement

- In L04/S33, ordinary `ILL033` occurrences remain visually blank so listening and grammar answers are not disclosed.
- In `QZ-RD001` only, place `SAM` over the upper slot and `RIVERA` over the lower slot using responsive SwiftUI geometry and expose the combined accessible label “Sam Rivera badge.”
- Overlay alignment must pass compact, standard, and large iPhone screenshots.

## Batch QA gates

Inspect Sam identity, Nina continuity, every hand and finger, box count/contact, badge blankness and geometry, arrival direction, triptych structural identity, time-of-day contrast, Alex identity, yes/no gesture distinction, safe zones, 16:9 ratio, opacity, sRGB profile, thumbnail readability, app-layer badge alignment, accessibility, and clipping. Exercise all four live Lesson 4 images in the real quiz renderer on compact, standard, and large iPhones. Verify `ILL012` as an accepted catalog asset even though it has no current screen placement.

## Production outcome

- All five source masters were accepted and preserved under `Archive/IllustrationProduction/2026-08-28-A1-C01-Chapter-1-Closeout/masters/`.
- Every asset was normalized to an opaque, non-interlaced sRGB PNG at 960×540 for 2x and 1440×810 for 3x; universal 1x remains unassigned.
- The five outgoing active legacy bitmaps were retired only after byte-for-byte comparison against preserved originals. Recovery remains available in both the global legacy archive and this batch's `references/legacy-originals/` folder.
- `QZ-G001` and `QZ-LS001` continue to show a blank `ILL033`. `QZ-RD001` alone adds responsive `SAM` and `RIVERA` app-layer typography with the accessible label “Sam Rivera badge.”
- The real L04/S33 quiz traversal passed on iPhone 17e, iPhone 17 Pro, and iPhone 17 Pro Max: 3 tests passed, 0 failed, with 15 retained screenshots. `ILL012` passed source/catalog visual QA because it has no live course placement.
- The app build passed after integration. Chapter 1 now has production replacements for all 36 illustration IDs and no active legacy bitmap exception.
