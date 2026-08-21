#!/bin/bash
# Full UI suite (Smoke + Milestone) on the gate device.
# Usage: qa/run-ui-full.sh [device-name]   (default "iPhone 17 Pro")
#
# UDID-pinned: two devices can share a name across runtimes and by-name
# simctl calls then hit the wrong one nondeterministically.
# Two sequential invocations: SmokeSuite first (fresh-install onboarding
# assumptions); MilestoneSuite second (it finishes lessons, which persists
# state SmokeSuite's ordered tests must not see).
set -euo pipefail
cd "$(dirname "$0")/.."

DEVICE="${1:-iPhone 17 Pro}"
BUNDLE="com.aurel.app"

UDID=$(
  xcrun simctl list devices available --json | DEVICE="$DEVICE" python3 -c '
import json, os, sys
d = json.load(sys.stdin)
for runtime, devs in d["devices"].items():
    if "iOS-26-5" in runtime or "iOS 26.5" in runtime:
        for dev in devs:
            if dev["name"] == os.environ["DEVICE"]:
                print(dev["udid"]); sys.exit(0)
sys.exit(1)
'
)
echo "gate device: $DEVICE ($UDID)"

xcrun simctl boot "$UDID" 2>/dev/null || true
xcrun simctl bootstatus "$UDID" -b >/dev/null
xcrun simctl uninstall "$UDID" "$BUNDLE" 2>/dev/null || true
xcrun simctl privacy "$UDID" revoke microphone "$BUNDLE" 2>/dev/null || true

for SUITE in SmokeSuite MilestoneSuite; do
  RESULT="/tmp/aurel-ui-full-$SUITE-$(date +%s).xcresult"
  xcodebuild test \
    -project Aurel.xcodeproj -scheme Aurel \
    -destination "platform=iOS Simulator,id=$UDID" \
    -only-testing:AurelUITests/$SUITE \
    -resultBundlePath "$RESULT" \
    2>&1 | grep -E "Test Case|Test Suite|error:|TEST" || true
  echo "result bundle ($SUITE): $RESULT"
done
