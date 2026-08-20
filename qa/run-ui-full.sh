#!/bin/bash
# Full UI suite (Smoke + Milestone) across the device matrix.
# Usage: qa/run-ui-full.sh [gate-device] — matrix devices (17e, 17 Pro Max)
# run the AX test via qa/run-ui-ax.sh; this script runs the gate device.
set -euo pipefail
cd "$(dirname "$0")/.."

DEVICE="${1:-iPhone 17 Pro}"
BUNDLE="com.aurel.app"

xcrun simctl boot "$DEVICE" 2>/dev/null || true
xcrun simctl bootstatus "$DEVICE" -b >/dev/null
xcrun simctl uninstall "$DEVICE" "$BUNDLE" 2>/dev/null || true
xcrun simctl privacy "$DEVICE" revoke microphone "$BUNDLE" 2>/dev/null || true



RESULT="/tmp/aurel-ui-full-$(date +%s).xcresult"
xcodebuild test \
  -project Aurel.xcodeproj -scheme Aurel \
  -destination "platform=iOS Simulator,name=$DEVICE,OS=26.5" \
  -only-testing:AurelUITests \
  -resultBundlePath "$RESULT" \
  2>&1 | grep -E "Test Case|Test Suite|TEST|error:" || true
echo "result bundle: $RESULT"
