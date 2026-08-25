# Aurel

An iPhone app for the Aurel A1 English course — a calm, honest, fully
on-device learning experience built with SwiftUI and SwiftData.

## Requirements

- Xcode 26+ with the iOS 26 SDK
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)
- Node.js (only for the content-manifest tool in `tools/`)

## Building

The Xcode project is generated from `project.yml`:

```sh
xcodegen generate          # regenerate Aurel.xcodeproj after adding/removing files
xcodebuild -project Aurel.xcodeproj -scheme Aurel \
  -destination 'platform=iOS Simulator,name=iPhone 17' build
```

Or open `Aurel.xcodeproj` in Xcode and run the **Aurel** scheme (iPhone
simulator).

## Testing

```sh
# Unit tests (fast)
xcodebuild -project Aurel.xcodeproj -scheme Aurel \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -only-testing:AurelTests test

# UI suites
bash qa/run-ui-smoke.sh     # smoke
bash qa/run-ui-full.sh      # full UI matrix
bash qa/run-ui-ax.sh        # accessibility pass
```

## Project layout

```
Aurel/
  App/                 App entry, environment, router, root view
  Course/              Course store, models, player engine and screens
  DesignSystem/        Design tokens, typography, motion, sound, components
  Features/            One folder per learner-facing feature
    Home/  Stories/  PracticeHub/  QuickPractice/
    Progress/  Profile/  Settings/  Paywall/
    Streak/  Leaderboard/  Onboarding/  Login/
  Persistence/         SwiftData models and store recovery
  Services/            Audio playback, speech, connectivity, streak engine
  Resources/           Bundled course JSON, design tokens, localization
  Support/             Asset catalog, Info.plist, privacy manifest
AurelTests/            Unit tests (+ Fixtures)
AurelUITests/          UI test suites
docs/                  Product audit, research, and implementation tracking
english_course/        Authored course content (source material, read-only)
qa/                    QA harness scripts, evidence, traceability
tools/                 Working content tooling (manifest export, screenshots)
Archive/               Superseded material — see Archive/README.md
```

## Conventions

- **Design tokens first.** Colors, spacing, radii, shadows, and type are
  mirrored from `Aurel/Resources/Design/design-tokens.json` and gated by
  `AurelTests/DesignTokenTests`. Never hardcode a color.
- **Content is authored, never invented.** The course lives in
  `Aurel/Resources/Course/a1-course.json`; `ContentConformanceTests` pin it
  against the authored records in `english_course/`.
- **Swift format.** 4-space indent, 100-column lines (`.swift-format`).
  Run `xcrun swift-format lint --recursive --configuration .swift-format Aurel`.
- **Debug-only verification hooks** compile under the `AUREL_VERIFICATION`
  condition (Debug configuration only) and never write the store.
