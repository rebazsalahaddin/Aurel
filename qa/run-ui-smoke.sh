#!/bin/bash
# Smoke UI suite runner — fresh install, mic revoked, gate device.
# Usage: qa/run-ui-smoke.sh [device-name]   (default "iPhone 17 Pro")
#
# Resolves the device name to a UDID on the iOS 26.5 runtime: two devices
# can share a name across runtimes, and by-name simctl calls then hit the
# wrong one nondeterministically (leaving the gate device's app installed).
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
                print(dev["udid"])
                sys.exit(0)
sys.exit(1)
'
)
echo "gate device: $DEVICE ($UDID)"

xcrun simctl boot "$UDID" 2>/dev/null || true
xcrun simctl bootstatus "$UDID" -b >/dev/null

# Fresh install so the ordered SmokeSuite starts from onboarding.
xcrun simctl uninstall "$UDID" "$BUNDLE" 2>/dev/null || true

# Permission preconditions for test3 (tap-path completes with mic denied).
xcrun simctl privacy "$UDID" revoke microphone "$BUNDLE" 2>/dev/null || true

RESULT="/tmp/aurel-ui-smoke-$(date +%s).xcresult"
xcodebuild test \
  -project Aurel.xcodeproj -scheme Aurel \
  -destination "platform=iOS Simulator,id=$UDID" \
  -only-testing:AurelUITests/SmokeSuite \
  -resultBundlePath "$RESULT" \
  2>&1 | grep -E "Test Case|Test Suite|TEST|error:" || true
echo "result bundle: $RESULT"
