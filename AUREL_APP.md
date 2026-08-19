# Aurel — the native iPhone app

The design prototype (`design/Aurel.dc.html` + `design/CourseScreen.dc.html`) implemented
natively: **Swift 6 (strict concurrency) · SwiftUI · SwiftData · Combine · iOS 26.0**.
The prototype and the authored course banks remain the source of truth — every string,
color, layout value, and interaction in the app is ported from them verbatim.

## Open and run

```sh
cd ~/Desktop/Aurel
open Aurel.xcodeproj      # Xcode 26.6; pick the "iPhone 17 Pro" simulator, ⌘R
```

From the command line:

```sh
xcodebuild test -project Aurel.xcodeproj -scheme Aurel \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.5'
```

The project file is generated — after adding/removing files run
`xcodegen generate` (and delete `Aurel.xcodeproj` first when files were removed).
Regenerating never touches sources: everything lives in `project.yml`.

## Architecture

| Layer | Where | Notes |
|---|---|---|
| App shell | `Aurel/App/` | `AppEnvironment` (DI container), `AppRouter` — the ported 24-screen state machine with SwiftData write-through, `RootView` dispatch |
| Design system | `Aurel/DesignSystem/` | `DesignTokens` (every CSS var from `styles.css` + the `--au-*` layer + `.aurel-dark` overrides, adaptive via UIColor dynamic providers), `Typography` (bundled Caprasimo + Figtree), `AUIcon` (authored SVG paths rendered verbatim), `Components` (buttons/cards/motion/grain), `Shared` (dusk scenes, stars, tab bar), `ArcSkyView` (the day-arc + travelling sun) |
| Course data | `Aurel/Course/` | `Models/` — Codable mirror of the exported banks (31 screen types behind a discriminated union), `CourseStore` (flat-position math ported from the prototype), `QuickBank` (quick-practice/word-sheet/scene generators) |
| Chapter player | `Aurel/Course/Player/` | `PlayerModel` (bounds/goto/pick/advance/tiles with the authored retry ladder), `CoursePlayerView` chrome, `Screens/` — one view per screen type |
| Features | `Aurel/Features/` | Onboarding (welcome dusk, goal, placement stub, commit, plan), Home, Quick practice + Result, Streak, Cedar Group leaderboard, Practice hub (scenes, say-aloud, review, hunt/reader stubs), Progress, Profile, Settings, Paywall, Login |
| Persistence | `Aurel/Persistence/` | SwiftData: `LearnerProfile`, `DayLog`, `LessonRecord`, `MistakeItem` (spaced-retrieval queue) |
| Services | `Aurel/Services/` | `Speaker` (AVSpeechSynthesizer TTS stand-in behind `AudioPlaying`, ready to swap for real recordings), `Connectivity` (NWPathMonitor → Combine), `ReviewScheduler` (1/3/7/14/30-day), `StreakEngine` (non-punitive, 2 grace days), `SpeechToText` (on-device, optional) |
| Course JSON | `tools/export-course-json.mjs` → `Aurel/Resources/Course/a1-course.json` | Mechanical export of `design/course-c1/2/3.js`; re-run after bank changes |

## Tests (22, all green)

- `CourseDecodingTests` — pins the export: 3 chapters, 40/43/32 screens, 115 total,
  every screen decodes to a typed payload, ≥122 practice items per chapter, quiz
  Form A = 22 items, answer-key shapes.
- `PositionMathTests` — `coursePos/chapterEndPos/courseSpot/promise` against known values.
- `ServicesTests` — interval ladder, due labels, streak halves + grace tokens,
  quick bank provenance, scene script, `joinTiles` punctuation rules.
- `SmokeTests` — bundled fonts registered; Figtree weights resolve to real PS names.

## Fidelity rules the port follows

- Copy, colors, sizes, radii, shadows: transcribed verbatim from the prototype.
- Illustrations stay honest placeholders (stripe field + `ILL` id + `alt`), audio is the
  approved on-device TTS stand-in (governance: scripts only, nothing fabricated).
- Placement, graded readers, and the word-hunt render the authored stub copy.
- Dark mode comes from the prototype's `.aurel-dark` token overrides; Settings →
  Appearance can force light/dark (persisted).
- Governance: streaks are non-punitive, the tap path equals the voice path, transcripts
  release only after a scored response, reduced-motion disables all ambient animation.

## Debug hook

Launch with a screen override to jump straight to any surface:

```sh
SIMCTL_CHILD_AUREL_SCREEN=home xcrun simctl launch "iPhone 17 Pro" com.aurel.app
```

(Accepts any prototype screen name: welcome, goal, plan, course, lesson, streak, …)
