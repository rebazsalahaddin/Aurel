# Aurel — runnable app prototype

Imported from the claude.ai/design project **"Mobile app design V3"**
(`https://claude.ai/design/p/f5ce4324-569e-46f2-a04f-009e78cea253`). That project is the
source of truth for the design — if the design changes there, re-import the changed files
(byte-exact copies; sizes noted below for verification).

This is the interactive prototype of the Aurel iPhone app, driven by the same authored
course content that lives in `../english_course/` (chapters A1-C01–C03 are transcribed
into `course-c1/2/3.js`; nothing is invented in the prototype — placement, graded readers
and the word-hunt show honest "awaiting course content" stubs, matching the master
prompt's deferral rulings).

## Run it

From the repo root:

```sh
python3 -m http.server 8143
# then open
open http://localhost:8143/design/Aurel.dc.html
```

- **Serve over http — `file://` will not work.** The DC runtime fetches `./ios-frame.jsx`
  and `CourseScreen.dc.html`, which browsers block from `file://` pages.
- **Internet is required** at boot: `support.js` loads React 18.3.1 (UMD) and Babel
  standalone from unpkg (SRI-pinned), and `_ds/.../styles.css` pulls the Caprasimo +
  Figtree webfonts from Google Fonts.
- Audio and illustrations are placeholders by design — no recordings or illustration
  renders exist yet (see `english_course/00_governance/DECISIONS.md`).

## What's in here

| File | Bytes | Role |
|---|---|---|
| `Aurel.dc.html` | 233,690 | App shell — every screen except the chapter player |
| `CourseScreen.dc.html` | 129,545 | Chapter player (authored course screens S01–S37 style) |
| `course-c1.js` | 114,875 | Chapter 1 data bank → `window.AUREL_COURSE` |
| `course-c2.js` | 112,992 | Chapter 2 data bank |
| `course-c3.js` | 99,588 | Chapter 3 data bank |
| `ios-frame.jsx` | 16,507 | iOS 26 device chrome (`IOSDevice`) |
| `support.js` | 69,150 | DC runtime (generated; loads React/Babel from CDN) |
| `_ds/organic-…/styles.css` | 10,793 | "Organic" design-system tokens + component classes |
| `_ds/organic-…/_ds_bundle.js` | 297 | Design-system bundle stub |

## Screen map (`Aurel.dc.html`)

Welcome → onboarding (goal · placement · daily commitment · plan) → sign-in →
**Home** (chapter header, day-arc card with the travelling sun, lesson path, next
chapter) → chapter player (`CourseScreen`) → quick practice (flashcards, choice,
listening, word order) → results → streak, Cedar Group leaderboard, **Practice** hub
(scene roleplay player, say-aloud with type-instead fallback, mistake review, word-hunt
stub), Progress (skills, ladder), Profile (milestones), Settings (rhythms, text size,
home-screen widget), Paywall.

The component exposes three editor props (set in claude.ai/design, defaults render the
day-one welcome screen):

- `theme` — `light` | `dark`
- `stage` — `day-one` | `mid-journey` (six weeks in: streak 43, chapter 2, mistakes pending)
- `connection` — `online` | `offline` (offline banner + audio retry states)
