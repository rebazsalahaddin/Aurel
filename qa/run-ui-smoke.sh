#!/bin/bash
# Smoke UI suite runner — fresh install, mic revoked, gate device.
# Usage: qa/run-ui-smoke.sh [device-name]   (default "iPhone 17 Pro")
set -euo pipefail
cd "$(dirname "$0")/.."

DEVICE="${1:-iPhone 17 Pro}"
BUNDLE="com.aurel.app"

xcrun simctl boot "$DEVICE" 2>/dev/null || true
xcrun simctl bootstatus "$DEVICE" -b >/dev/null

# Fresh install so the ordered SmokeSuite starts from onboarding.
xcrun simctl uninstall "$DEVICE" "$BUNDLE" 2>/dev/null || true

# Permission preconditions for test3 (tap-path completes with mic denied).
xcrun simctl privacy "$DEVICE" revoke microphone "$BUNDLE" 2>/dev/null || true

RESULT="/tmp/aurel-ui-smoke-$(date +%s).xcresult"
xcodebuild test \
  -project Aurel.xcodeproj -scheme Aurel \
  -destination "platform=iOS Simulator,name=$DEVICE,OS=26.5" \
  -only-testing:AurelUITests/SmokeSuite \
  -resultBundlePath "$RESULT" \
  2>&1 | grep -E "Test Case|Test Suite|TEST|error:" || true
echo "result bundle: $RESULT"
