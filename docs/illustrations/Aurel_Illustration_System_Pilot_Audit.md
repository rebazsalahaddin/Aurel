# Aurel Illustration System — Pre-Production Audit and Pilot Specification

**Status:** One pilot produced, integrated, and QA-verified · awaiting explicit user approval  
**Audit date:** 2026-08-27; pilot completed 2026-08-28 (Asia/Baghdad)  
**Pilot asset:** `A1-C01-ILL001` — The Welcome Event Setting

## 1. Aurel app audit

### Architecture

- Native iPhone-only SwiftUI app, targeting portrait orientation. The app is organized into app routing, course models/player, feature modules, a shared design system, SwiftData persistence, bundled course JSON, audio resources, and an Xcode asset catalog.
- The maintained course source of truth is `Aurel/Resources/Course/a1-course.json`: four chapters, fourteen lessons, and 131 screens.
- Illustration references are authored as `IllustrationRef` IDs in course JSON. `IllustrationPlaceholder` resolves each ID with `UIImage(named:)`, preserves aspect ratio with `scaledToFit()`, clips to the declared frame, and applies the course-authored accessibility label.
- Missing art intentionally falls back to a branded descriptive placeholder rather than leaking internal IDs.

### UI personality

Aurel is calm, premium, warm, mature, approachable, and editorial. It is not visually juvenile. The interface combines:

- Caprasimo display type with Figtree body type;
- parchment and cream surfaces;
- restrained terracotta and sage accents;
- large rounded cards and buttons;
- fine borders, soft depth, generous breathing room, and clear hierarchy;
- native motion that is subtle and reducible for accessibility.

The illustration system therefore needs to be quieter, flatter, lighter, and more graphically deliberate than the active legacy imagery. It should read at mobile size before it rewards closer inspection.

### Image placement

- Chapter 1 image placements are explicitly forced to `16:9` in the promise, hook, pause, card, meaning-pulse, practice, mission, and review treatments.
- The pilot appears in four live contexts: C1/L1/S01 promise, C1/L1/S02 story hook, C1/L1/S06 pause, and C1/L4/S33 quiz.
- S01 is full-bleed with a bottom hairline; S02 uses a 22-point rounded frame within 22-point horizontal screen padding. Both use `scaledToFit`, so an exact-ratio source produces no crop or distortion.
- The app targets iPhone only. Validation should cover compact, standard, and large portrait widths; iPad validation is out of scope for the current target configuration.

## 2. Legacy illustration audit

- 36 active PNGs exist in `Aurel/Support/Assets.xcassets`, named `A1-C01-ILL001` through `A1-C01-ILL036`.
- All 36 are approximately `16:9`: 30 are 1280×720 and six are 1672×941.
- 32 active IDs are referenced by live course objects. Four active assets are currently orphaned by the maintained course JSON: ILL012, ILL024, ILL026, and ILL029. They remain preserved and untouched.
- The course references 100 unique illustration IDs overall: 32 C01, 31 C02, 32 C03, two C04, and three character anchors. Sixty-eight referenced IDs do not yet have active image sets and correctly render the branded placeholder.
- Visual inspection of every active PNG found a coherent but unsuitable previous-generation system: dark amber dominance, cinematic glow, dense environmental detail, anime-adjacent facial construction, repeated generic smiles, and inconsistent compliance with the binding no-text rule. ILL019 and ILL033 contain embedded text; several badge images contain line-like marks intended to live in the app layer.
- The complete starting asset catalog has been copied without modification to `Archive/LegacyIllustrations/2026-08-27-active-a1-c01/Assets.xcassets`.
- `Archive/LegacyIllustrations/2026-08-27-active-a1-c01/MANIFEST.md` records every original path, exact dimensions, format, SHA-256, live course locations, and replacement status. All 36 archive hashes match the active originals at the archive gate.

## 3. Course illustration audit

### Canonical cast

- **Alex Kim:** 26, they/them, light-brown skin, short black hair, round glasses, mustard sweater, brown backpack; bright, welcoming host.
- **Maya Haddad:** 28, she/her, brown skin, dark-brown wavy hair usually tied back, olive jacket or green scrubs, small star pin; warm, calm encourager.
- **Leo Novak:** 31, he/him, light skin, tall, curly auburn hair, beard, blue apron over a striped shirt; friendly and relaxed.
- **Nina Petrova:** 29, she/her, light-olive skin, grey-streaked dark hair in a low bun, teal cardigan, notebook; patient and clear.
- **Sam Rivera:** 25, he/him, warm round face, short dark curly hair, green T-shirt, blank badge on red lanyard, canvas tote; cheerful.

The source bible also registers one-off later figures and fixes Aroa’s recurring locations. No identity attribute needs to be invented for the pilot.

### Illustration families

The current course needs a controlled family of:

- story-world establishing scenes and dialogue contexts;
- vocabulary scenes with unambiguous times, objects, actions, and gestures;
- emotional-state and body-language portraits;
- name-badge, card, number, alphabet, map, and other app-layer teaching surfaces;
- first-meeting, greeting, farewell, and relationship scenes;
- review and quiz variants that reuse canonical characters without visual drift.

Continuity must preserve faces, proportions, skin tones, hair, height relationships, signature clothing, badges, locations, props, time of day, and story chronology. Text remains native UI unless a later scene specifically requires real-world text and it is manually verified.

## 4. Professional research findings

- Contemporary ELT publishing treats imagery as part of the learning task, not decoration. Oxford’s current English File Fifth Edition describes video and story content embedded into lessons to establish context and functional language, alongside short integrated-skill practice. The relevant production lesson for static art is to make each scene carry situation, relationship, and action rather than merely provide atmosphere. See [Oxford English File Fifth Edition](https://www.oup.com.au/elt/english-file-5e).
- Cambridge’s current visual-literacy guidance argues that images can level access for learners with different language ability and provide context and meaning; it also stresses interpreting who, where, what is happening, and how people feel. This supports character-led scenes with clearly readable situations. See [Unlocking the power of images](https://www.cambridge.org/elt/blog/2025/02/23/unlocking-the-power-of-images-practical-strategies-to-promote-visual-literacy-in-class/).
- Multimedia-learning research identifies coherence and signaling as key ways to reduce irrelevant processing: exclude decorative information and cue the essential organization. For Aurel, subject silhouettes, gaze, gesture, and prop placement should carry the signal; background detail should be subordinate. See [Fiorella and Mayer, Cambridge Handbook of Multimedia Learning](https://www.cambridge.org/core/books/abs/cambridge-handbook-of-multimedia-learning/principles-for-reducing-extraneous-processing-in-multimedia-learning/F29A19FCD34C542806F736E0661C05F5).
- A controlled EFL vocabulary study found better vocabulary gains for picture/video-supported conditions than definition-only or definition-plus-audio conditions. The useful implication is not “add more imagery”; it is to make the visual semantically diagnostic of the target meaning. See [Multimedia Gloss Presentation](https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2020.602520/full).
- Apple’s current image guidance calls for correct scale factors, de-interlaced PNG for raster art, explicit aspect-ratio preservation, safe composition, range-of-device testing, and meaningful accessibility metadata. See [Apple HIG: Images](https://developer.apple.com/design/human-interface-guidelines/images), [Image views](https://developer.apple.com/design/human-interface-guidelines/image-views), and [Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility).

No publisher artwork is copied, traced, style-transferred, or used as a generation reference. Research informs general educational and production principles only.

## 5. Aurel illustration art direction

### Core direction

**Original premium contemporary editorial 2D educational illustration:** matte, warm, graphically clear, lightly textured, human, restrained, and specific to Aurel.

### Character construction

- Believable adult proportions: approximately 5.75–6.25 heads tall for full figures; portrait heads must not enlarge into chibi or anime proportions.
- Clear, distinct silhouettes and height/build relationships.
- Faces use softly geometric planes, modest almond eye shapes, simple noses, restrained mouths, and slight asymmetry. No oversized sparkling eyes, beauty-render skin, or universal open-mouth smiles.
- Hands are simplified but anatomically legible: five fingers, clear thumb direction, unambiguous contact with cups, tables, badges, or other learning objects.
- Clothing uses broad shape blocks and only the folds needed to explain pose.

### Shape language and linework

- Rounded rectangles, softly tapered limbs, arched doorways, and sturdy simple furniture echo Aurel’s continuous card corners without becoming corporate-vector stock art.
- Controlled warm-charcoal outlines: approximately 2.0–2.5 px at 1440 px for outer silhouettes and 1.0–1.5 px internally; no pure-black comic outlines.
- Edges may occasionally disappear where adjacent flat values remain clear, producing a more editorial and less synthetic result.

### Palette

- Paper/background: `#F5EAD8` and `#F9F4ED`
- Surface cream: `#EBDDC5`
- Charcoal ink: `#201E1D`
- Terracotta anchor: `#C67139`
- Supporting orange: `#D67F48` and `#F6A06B`
- Sage anchor: `#7A8A5E`
- Supporting sage: `#8FA073` and `#AEBF92`
- Muted slate blue support: `#6F8792`
- Morning sky support: a low-chroma blue-cream, never saturated cyan

Terracotta is an accent, not a full-scene color wash. Skin tones remain distinct from the accent palette. No uncontrolled rainbow color.

### Perspective, backgrounds, shadows, and texture

- Mostly eye-level or gently elevated editorial views with calm two-point perspective.
- One clear foreground, one middle-ground interaction, and only enough background to establish place.
- Background detail density should be roughly half the subject density; usually three to five supporting objects at most.
- Shadows are broad, soft, and matte: one consistent daylight direction, no cinematic rim light, volumetric haze, glossy highlights, or pseudo-3D rendering.
- Subtle unidirectional paper grain at low opacity; no noisy micro-detail or texture variation that changes between objects.

### Expression system

- Neutral attentive; small warm greeting; thoughtful/concerned; apologetic; genuine celebration.
- Eyebrows, gaze, head angle, shoulders, and hand gesture do most of the emotional work.
- Smiles vary in size and may be closed-mouth. Expressions remain natural and readable at 300-point display width.

## 6. Technical image system

### Pilot frame

- Exact `16:9` landscape composition.
- Master should be generated at or above 1440×810 and downsampled cleanly; no upscaling.
- Production image-set delivery: 960×540 PNG in the `2x` slot and 1440×810 PNG in the `3x` slot; no 1x bitmap is required for the iPhone target.
- De-interlaced opaque PNG, embedded sRGB profile, no alpha unless a future placement requires transparency.

### Safe composition

- Keep faces, all visible hands, cups, the open doorway, and the wave inside an inner safe zone of 8% horizontally and 10% vertically.
- Keep critical detail out of the outer 12% in each corner so the S02 rounded mask cannot touch it.
- Design must remain readable at approximately 276 points wide on a compact hook screen and approximately 430 points wide full-bleed on a large iPhone.

### Scaling and responsive behavior

- Preserve intrinsic ratio with `scaledToFit`; never stretch, squash, or fill-crop.
- Validate compact, standard, and large iPhone portrait sizes, light and dark appearance, default and larger text, and VoiceOver metadata.
- Later chapter images require per-placeholder specifications because not every later call site forces Chapter 1’s `16:9` ratio.

### Naming and integration

- Retain the authored asset ID and image-set name: `A1-C01-ILL001.imageset`.
- Keep all course JSON and Swift references unchanged.
- Replace only image-set pixel files after the legacy hash and QA gate; do not redesign unrelated UI.

## 7. Pilot recommendation

`A1-C01-ILL001` is the strongest representative pilot because it tests the complete system rather than an easy isolated object:

- two canonical recurring characters;
- facial identity and distinct skin tones;
- a readable wave and cup-arranging hand interaction;
- clothing and accessory continuity;
- a specific recurring location;
- a clear morning time cue;
- foreground props, midground people, and background architecture;
- both full-bleed and rounded in-app treatments;
- reuse in a dialogue hook, pause, and assessment option.

### Pilot scene specification

- **Learning objective:** understand a first greeting in context before reading the dialogue.
- **Scene:** sunny morning outside the Aroa Community House. Alex stands in the open doorway and waves. Maya is at the welcome table arranging three ceramic cups.
- **Emotion:** Alex gives a small warm greeting smile; Maya is calmly focused with a gentle acknowledging smile.
- **Framing:** eye-level wide establishing shot; Alex at the left third, doorway near center-left, Maya at the right third; the gesture and cups are immediately legible at thumbnail size.
- **Educational hierarchy:** wave and two-person greeting first; cups and welcome-table context second; simplified community-house architecture third.
- **No embedded text:** no signs, banners, labels, letters, numbers, logos, or watermarks.

## 8. Necessary questions

There are no blocking questions for this pilot. The maintained course, app code, binding character bible, active frame, naming convention, and accessibility text resolve every production-critical decision. Any later production run still requires explicit pilot approval under the master brief.

## 9. Pilot production record

### Generation method and prompt set

The pilot was made with OpenAI's built-in image generation tool in native generation/edit mode. No external publisher artwork, reference image, style transfer, or copyrighted character was supplied. One base image and two narrowly scoped correction passes were used; only the final corrected result entered production.

**Base generation prompt:**

> Create one original 16:9 landscape illustration for Aurel, a premium adult English-learning iPhone app. Show a sunny morning outside the Aroa Community House. Alex Kim stands at the left third in the open doorway and gives a clear five-finger wave: a 26-year-old nonbinary adult with light-brown skin, short black hair, round glasses, mustard sweater, blue trousers, and brown backpack. Maya Haddad stands at the right third behind a welcome table, arranging exactly three distinct ceramic cups: a 28-year-old woman with brown skin, dark-brown wavy hair tied back, olive jacket, cream top, and a small star pin. Their expressions are warm, restrained, and natural. Use believable adult proportions, anatomically legible hands, softly geometric faces, warm-charcoal linework, matte editorial color blocks, restrained paper texture, cream, terracotta, sage, muted slate, and a low-chroma blue morning sky. Eye-level calm two-point perspective; wave and greeting first, cups second, simplified architecture and plants third. Leave faces, all hands, cups, wave, and doorway safely inside the frame for rounded masking. Full rectangular artwork to every edge, with no internal border, paper card, frame, vignette, text, signs, letters, numbers, logos, watermarks, anime styling, oversized eyes, cinematic glow, 3D rendering, or dense background clutter. The scene must remain immediately readable on a phone.

**Correction pass 1:**

> Preserve the composition, identities, palette, and educational hierarchy exactly, but remove the internal rounded paper/card frame and extend the scene cleanly to all four rectangular image edges. Keep the 16:9 layout and all critical details inside the established safe zone. Do not add text or new objects.

**Correction pass 2:**

> Preserve everything else. Correct Maya's hand at the cups so every visible finger is anatomically plausible and wraps only around the outside of the cup; no finger may enter the cup. Keep exactly three separate cups, Alex's five-finger wave, both canonical character designs, the full-bleed rectangular scene, and no text or logos.

### Source, preparation, and integration

- Final generated source: 1672×941 PNG, preserved at `Archive/IllustrationProduction/2026-08-28-A1-C01-ILL001/source-imagegen-1672x941.png`.
- Ratio preparation: a centered 8-pixel horizontal and 5-pixel vertical trim produced a 1664×936 exact-16:9 working master without touching any critical content.
- Active 2x delivery: `Aurel/Support/Assets.xcassets/A1-C01-ILL001.imageset/A1-C01-ILL001@2x.png`, 960×540, SHA-256 `c9454ca87b2fca3908d0f8356f9ed1533794bd661cbe65abfd53c8d5f1cc7979`.
- Active 3x delivery: `Aurel/Support/Assets.xcassets/A1-C01-ILL001.imageset/A1-C01-ILL001@3x.png`, 1440×810, SHA-256 `c5a333ace13b7c76429b4cb09a47f457e523a5f8f26e63f48723f86d4570316d`.
- Both delivery PNGs are opaque, 8-bit RGB, non-interlaced, and carry the `sRGB IEC61966-2.1` profile.
- The image-set name, course JSON, Swift references, and authored accessibility descriptions are unchanged. The legacy active bitmap was retired only after its exact archived copy and SHA-256 were verified.

### In-app QA

- Xcode asset compilation and the complete Aurel app build succeeded for the iOS Simulator. The build emitted only existing unrelated warnings in `Services.swift` and App Intents metadata extraction.
- Full-bleed promise placement passed on iPhone 17e (1170×2532 screenshot), iPhone 17 Pro (1206×2622), and iPhone 17 Pro Max (1320×2868).
- Rounded story-hook placement passed on iPhone 17 Pro. The rounded mask does not touch either face, Alex's wave, Maya's hands, any cup, or the doorway.
- Dark appearance with Accessibility XXXL text passed on iPhone 17 Pro without overlap, crop, or loss of learning hierarchy.
- Manual visual QA passed for canonical character continuity, believable adult proportions, clear eye direction and expressions, five-finger wave, corrected cup contact, exactly three cups, no embedded text/logos/watermarks, mobile legibility, and consistency with Aurel's cream/terracotta/sage design system.
- Evidence is stored in `qa/evidence/illustration-pilot/`. No second illustration was generated.

**Gate:** production is stopped after this single pilot. Continue only after explicit user approval or revision feedback.
