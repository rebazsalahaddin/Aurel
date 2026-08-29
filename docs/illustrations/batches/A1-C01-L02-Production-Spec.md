# Aurel Illustration Production Specification — A1-C01 / L02 “You and Your Name”

**Status:** Accepted and integrated 2026-08-28  
**Reference standard:** approved Lesson 1 visual system and production cast key  
**Production order:** Set C states (`ILL013–ILL017`), continuity review, then names/first meetings (`ILL018–ILL022`)

## Course and placement audit

- **Lesson objective:** describe a basic personal state; ask and answer a name; introduce oneself; respond at a first meeting; ask “How are you?” and return the question.
- **Primary placements:** S11 state cards, S12 name cards, S14/S18 practice, S15 follow-up cards, S17 pronunciation, and S19 review.
- **Asset reuse:** `ILL013–017` form a comparison system and must work together; `ILL018` supports name / first name / last name; `ILL019` supports both full and short self-introductions plus my/your contrasts; `ILL022` supports both “How are you?” and “And you?”
- **Target UI:** Chapter 1 `IllustrationPlaceholder`, exact 16:9, `scaledToFit`, rounded 20–24 point masks. Main card height is 224 points; picture-option reuse is substantially smaller.

## Shared production contract

- **Approved visual language:** original premium contemporary editorial 2D; believable adult proportions; softly geometric faces; modest eyes; controlled warm-charcoal line; matte cream, terracotta, sage, mustard, teal, and muted-slate color blocks; restrained paper texture; broad soft shadows; quiet natural light; background detail below subject detail.
- **Delivery:** opaque non-interlaced sRGB PNG; 960×540 in the 2x slot and 1440×810 in the 3x slot; no assigned 1x bitmap.
- **Safe zone:** every face, complete hand, badge, line slot, and teaching gesture inside 8% horizontal / 10% vertical; critical details outside the outer 12% corners.
- **Continuity:** Alex, Maya, Leo, and Nina must match the approved production cast key and Lesson 1 assets. Canonical clothing and accessories remain stable.
- **Educational test:** the target state or social action must be understandable before the word is read; posture and gesture carry meaning, never color alone.
- **Universal avoid list:** photorealism, photo-adjacent rendering, artist/publisher imitation, anime, oversized eyes, chibi anatomy, stock-vector corporate styling, glossy 3D, dramatic rim light, clutter, excessive micro-detail, malformed or duplicate anatomy, incorrect finger count, merged hands/objects, duplicate props, impossible perspective, internal frames, borders, captions, letters, names, signs, logos, and watermarks.

## Set C — the state-expression system

The five state images are a deliberately comparable family: same Community House garden-wall environment, eye-level camera, medium/waist-up scale, soft late-morning light, and equivalent subject size. Expressions stay natural and adult. Body posture and arm position—not color—create the ordered distinction `fine → okay → not bad → good → great`. Because each image also appears as a small picture option, hands and shoulder silhouettes must remain unmistakable after downscaling.

### A1-C01-ILL013 — “good”

- **Character:** canonical Maya.
- **Scene:** Maya faces the learner at the Community House garden wall, shoulders relaxed, arms naturally down and visible, with a warm full but restrained smile.
- **Distinction:** clearly happier than “fine” and “okay,” but less energetic than “great.” No wave, shrug, raised arm, or prop.
- **Framing:** waist-up with negative space around both shoulders; star pin visible but secondary.
- **Alt source:** “Maya smiles warmly with relaxed shoulders, feeling good.”

### A1-C01-ILL014 — “fine”

- **Character:** canonical Leo, without the apron so both Leo state images match his striped shirt.
- **Scene:** Leo gives one subtle content nod, soft closed-mouth smile, relaxed shoulders, and arms resting naturally low/out of the teaching area.
- **Distinction:** calm, mildly positive, and lowest-energy positive state; no shrug or raised palms.
- **Framing:** match `ILL017` camera, scale, clothing, light, and background exactly enough to read as a deliberate pair.
- **Alt source:** “Leo gives a gentle content nod with a soft smile, feeling fine.”

### A1-C01-ILL015 — “okay”

- **Character:** canonical Nina.
- **Scene:** Nina holds exactly one open hand flat and level at upper-chest height in a familiar “so-so / okay” gesture; the other arm remains relaxed. Her mouth is a small neutral-to-positive smile.
- **Distinction:** neutral-positive rather than unhappy; one level hand is the dominant semantic cue.
- **Framing:** complete hand and wrist fully visible, fingers together but individually plausible; no notebook.
- **Alt source:** “Nina holds one hand level in a so-so tilt with a small neutral smile, feeling okay.”

### A1-C01-ILL016 — “great”

- **Character:** canonical Alex, including round glasses and mustard sweater; backpack omitted for the pose.
- **Scene:** Alex raises both complete arms high in a celebratory V with two anatomically correct open five-finger hands and an energetic open smile.
- **Distinction:** unmistakably the strongest positive state; lively without a childlike or exaggerated cartoon expression.
- **Framing:** medium view wide enough to keep both hands, wrists, and elbows inside the safe zone; face remains large enough for mobile.
- **Alt source:** “Alex raises both arms high with a big open smile, feeling great.”

### A1-C01-ILL017 — “not bad”

- **Character:** canonical Leo in the same striped shirt, camera, light, and environment as `ILL014`.
- **Scene:** Leo gives an easy small shoulder shrug with both open palms at lower-chest height and a modest friendly smile.
- **Distinction:** mildly positive and conversational, between okay and good; both palms and the lifted shoulders carry the meaning.
- **Framing:** hands fully visible and separated; do not crop elbows or merge fingers into the shirt.
- **Alt source:** “Leo gives an easy shrug with open palms and a small friendly smile — not bad.”

## Set D/E — names, introductions, and reciprocal questions

### A1-C01-ILL018 — blank name-badge schema

- **Meaning:** the reusable concept of a name and its first/last-name line structure.
- **Scene:** a clean close-up of a blank matte cream name badge pinned to a simple muted-slate woven shirt. The badge is centered, nearly frontal, and occupies about 46% of the frame width. A small round pin sits at top center.
- **Badge geometry:** exactly two subtle empty line slots: a shorter upper slot and a longer lower slot. They are graphic shapes only—no letters, pseudo-writing, names, or handwriting.
- **App-layer support:** leave even, low-detail space around both line slots so the SwiftUI layer can softly highlight `both`, `top`, or `bottom` without fighting the artwork.
- **Framing:** no face and no pointing hand; the schema, not a character, is primary. This geometry becomes a reusable identity visual in later lessons.
- **Alt source:** “A blank name badge pinned to a shirt, with two empty line shapes where names go.”

### A1-C01-ILL019 — self-introduction / my and your name

- **Meaning:** a person identifies themself while another person is the conversational partner; supports “My name is…”, “I'm…”, and later my/your contrasts.
- **Scene:** at the Community House badge table, canonical Alex and Maya face one another wearing identical blank two-line badges. Alex lightly touches or openly gestures toward their own badge with one hand; the other hand opens toward Maya. Maya listens with one hand near her own badge and a small friendly expression.
- **Hierarchy:** Alex’s self-badge gesture first; two distinct badges and reciprocal person relationship second; minimal table/door context third.
- **Anatomy/object logic:** exactly two badges, both blank; no pointing toward the learner/camera; hands do not cover badge line slots.
- **Alt sources served:** “Alex gestures toward the blank badge on their own chest while speaking” and the short friendly self-introduction card.

### A1-C01-ILL020 — “What's your name?”

- **Meaning:** asking another person’s name.
- **Scene:** canonical Maya and Alex at the same badge table. Maya leans slightly toward Alex with one gentle open questioning hand oriented toward Alex’s blank badge; Alex listens attentively. Both wear blank badges.
- **Hierarchy:** Maya’s eye line, open question gesture, and orientation toward Alex’s badge first; people second; minimal Community House context third.
- **Anatomy/object logic:** exactly two badges, both blank; one clear open hand; no speech bubble or question mark.
- **Alt source:** “Maya leans in with an open hand, asking a friendly question.”

### A1-C01-ILL021 — “Nice to meet you”

- **Meaning:** a warm first meeting.
- **Scene:** canonical Nina and Leo meet near the Community House welcome table and share one natural handshake while making friendly eye contact. Their free arms are relaxed.
- **Hierarchy:** single plausible handshake and mutual eye contact first; recognizable Nina/Leo second; restrained welcome-table context third.
- **Anatomy/object logic:** exactly two people and one handshake; each wrist/hand belongs clearly to the correct arm, no doubled fingers, and no second greeting gesture.
- **Alt source:** “Nina and Leo shake hands warmly at their first meeting, both smiling.”

### A1-C01-ILL022 — “How are you?” / “And you?”

- **Meaning:** a caring state question and a reciprocal return of the same question.
- **Scene:** canonical Maya and Leo face one another near the welcome table. Maya looks at Leo with warm care and extends one gentle open hand toward him; Leo receives the question with relaxed eye contact and returns a smaller open hand toward Maya.
- **Hierarchy:** reciprocal eye line and two directional open-hand gestures first; people second; minimal table/cups context third.
- **Anatomy/object logic:** hands remain separated and point to the other speaker, not themselves; no cup is held; expressions are attentive rather than romantic or distressed.
- **Alt sources served:** “Maya looks at Leo with warm care, one gentle open hand toward him” and “The open caring hand turns back toward the first speaker — and you?”

## Batch QA gates

For every image, inspect face identity, hairline, ears, eyes, mouth, finger count, wrist/hand ownership, shoulder/limb connections, badge count and blankness, line-slot geometry, grip/contact, floor/table perspective, text artifacts, safe zones, exact ratio, color profile, and small-option legibility. Compare all five state images as one ordered semantic strip and compare the two Leo images as a direct continuity pair. Compare `ILL019`, `ILL020`, and `ILL022` for gesture direction so self-introduction, name question, and state question remain distinct. Reject or correct any failure before integration. Then validate all cards in the real S11/S12/S15 pagers at compact, standard, and large iPhone sizes.

## Production outcome

- `ILL013–ILL022` were accepted, normalized to 960×540 @2x and 1440×810 @3x opaque sRGB PNGs, and integrated after the prior active originals were verified in the legacy archive.
- The course’s `both`, `top`, and `bottom` badge metadata now reaches the card renderer, which places a responsive translucent highlight over the blank slots in `ILL018` without putting text into the artwork.
- Real in-app artwork coverage passed on iPhone 17e, iPhone 17 Pro, and iPhone 17 Pro Max with 0 failures. Manual review confirmed safe zones, gesture semantics, anatomy/contact logic, badge alignment, and small-card readability.
- The final iPhone 17 Pro simulator build succeeded after catalog compilation and app validation.
- Accepted prompt payloads, master/output hashes, output rules, and QA evidence paths are recorded in `A1-C01-L02-Final-Prompts.md`.
