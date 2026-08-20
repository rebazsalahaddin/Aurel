# Aurel — QA capabilities (Phase 0)

All facts below were **executed and observed** on this machine (2026-08-20). Baseline gate log:
`/tmp/aurel-baseline-gate.log` (session-local; numbers transcribed here).

## Toolchain

| Item | Value |
|---|---|
| Xcode | 26.6 (Build 17F113) |
| Swift | 6.3.3 (swiftlang-6.3.3-1.3, target arm64-apple-macosx26.0); app builds in Swift 6 language mode with `SWIFT_STRICT_CONCURRENCY: complete` |
| Format/lint | `swift format` 6.3.0 **bundled in the Xcode toolchain** (`/Applications/Xcode.app/.../usr/bin/swift-format`) — no SwiftLint/SwiftFormat installed, no Homebrew on this machine; config `.swift-format` (v1 schema: 4-space indent, 100-col, max 1 blank line) |
| Node | v24.18.1 (for `tools/*.mjs` exporters) |
| Dependency manager | **none** — zero third-party dependencies (no SPM/CocoaPods/Carthage); first-party only |
| Project generation | xcodegen (`project.yml`); `Aurel.xcodeproj` is committed. **Regen gotcha:** delete `Aurel.xcodeproj` before `xcodegen generate` whenever files were removed |

## Project

| Item | Value |
|---|---|
| Scheme / targets | scheme `Aurel`; targets `Aurel` (app, `com.aurel.app`) + `AurelTests` (unit, TEST_HOST). UI-test target added this run: `AurelUITests` |
| Deployment target | iOS 26.0 (iPhone-only `TARGETED_DEVICE_FAMILY: 1`, portrait-only) |
| Bundled resources | 6 fonts (Caprasimo + Figtree ×5), `Resources/Course/a1-course.json`, `Resources/Design/design-tokens.json` (added this run) |
| Info.plist keys | `NSMicrophoneUsageDescription`, `NSSpeechRecognitionUsageDescription` (on-device wording), `UIAppFonts`, `UILaunchScreen: {}` |

## Verified working commands

```sh
# Full gate (clean build + all tests)
xcodebuild clean build test -project Aurel.xcodeproj -scheme Aurel \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.5'

# Lint (strict — exit code is the gate)
xcrun swift-format lint --strict --configuration .swift-format --recursive --parallel \
  Aurel AurelTests AurelUITests

# Exporter drift (all three must reproduce committed outputs byte-for-byte)
node tools/export-course-json.mjs
node tools/export-design-tokens.mjs
node tools/export-content-manifest.mjs
git diff --exit-code -- Aurel/Resources AurelTests/Fixtures

# Evidence
xcrun simctl io booted screenshot qa/evidence/<name>.png
```

## Simulator inventory (reconciled vs deployment target 26.0)

iOS 26.5 runtime: iPhone 17 Pro · 17 Pro Max · 17e · Air · 17 (+ iPads — N/A, iPhone-only app).
iOS 27.0 runtime: same iPhones (beta — smoke only, never the gate).
**Gate device**: iPhone 17 Pro / OS 26.5. **Matrix devices**: iPhone 17e (smallest) + iPhone 17 Pro Max (largest).
No physical device attached — hardware-only paths are VERIFICATION-BLOCKED (see REPORT).

## Test inventory

**Baseline (start of run): 22 unit tests, 0 UI tests** — CourseDecodingTests (8) + PositionMathTests
(4) + ServicesTests (8) + SmokeTests (2). Coverage: course JSON decode counts/shapes, position
math, review scheduler / streak rules / quick bank / joinTiles, font registration + weight
resolution. **Not covered at baseline:** router state machine, player mechanics, persistence
round-trip, any view/UI layer, design tokens, content fidelity vs `english_course/`.

**Added this run (Phase 0.5):** `AurelUITests` (SmokeSuite + MilestoneSuite),
`DesignTokenTests` (token coverage + values + WCAG contrast + typography scale),
`ContentConformanceTests` (verbatim content vs `english_course/` manifest). See `qa/REPORT.md`
for the final inventory.

## Baseline snapshot (2026-08-20, branch `qa/hardening` @ `2e76608`)

| Metric | Value |
|---|---|
| Clean build | **SUCCEEDED** (exit 0) |
| Tests | **22 passed / 0 failed** (`** TEST SUCCEEDED **`) |
| Warning lines in gate log | **25 total** = 10 Swift code warnings + 15 toolchain/build notices |
| — code warnings (fixable) | 4× unused immutable `cta` · 2× unused `item` · 2× unused `kind` · 2× deprecated `Text` `+` concatenation |
| — non-code (toolchain) | 3× appintentsmetadataprocessor metadata notice · 2× "Traditional headermap" · 10× "not stripping binary (signed)" from Apple test frameworks |
| swift-format violations | pre-baseline 1485 → **0** after format baseline commit `2e76608` |

**Exit-gate rule:** zero *new* warnings vs the 25-line baseline (and code warnings should only
decrease). Warning-count method: `grep -c 'warning:' <log>` on the full xcodebuild log.

## Permissions controllable here

- Microphone: `xcrun simctl privacy "iPhone 17 Pro" revoke microphone com.aurel.app` (also `grant`/`reset`).
- Speech recognition: **no `simctl privacy` service exists** → denied-path coverage is unit-level
  (`SpeechToText.requestAuthorization`) + a UI interruption-monitor tripwire.
- Notifications: none requested by the app today (no UNUserNotificationCenter usage) — nothing to test.

## Environment-blocked (VERIFICATION-BLOCKED — never silently skipped)

Physical device (real mic/SFSpeechRecognizer quality, haptics, telephony/Siri interruption,
push, low storage/memory, App Store pipeline incl. icon validation) · speech-denied system alert
UI · VoiceOver gesture navigation (identifier/audit coverage only) · iOS 27.0 beta runtime as a
gate · C4/C5 content (owner-deferred this run) · backend (planned; boundaries audited only).
