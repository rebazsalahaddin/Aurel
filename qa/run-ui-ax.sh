#!/bin/bash
# AX-size UI test across the device matrix (smallest + largest).
# Usage: qa/run-ui-ax.sh   — runs MilestoneSuite/test3 on iPhone 17e and 17 Pro Max.
set -euo pipefail
cd "$(dirname "$0")/.."

for DEVICE in "iPhone 17e" "iPhone 17 Pro Max"; do
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
  echo "=== $DEVICE ($UDID) ==="
  xcrun simctl boot "$UDID" 2>/dev/null || true
  xcrun simctl bootstatus "$UDID" -b >/dev/null
  xcrun simctl uninstall "$UDID" com.aurel.app 2>/dev/null || true
  xcodebuild test \
    -project Aurel.xcodeproj -scheme Aurel \
    -destination "platform=iOS Simulator,id=$UDID" \
    -only-testing:AurelUITests/MilestoneSuite/test3DynamicTypeAXHittability \
    -resultBundlePath "/tmp/aurel-ui-ax-$(date +%s).xcresult" \
    2>&1 | grep -E "Test Case|TEST|error:" || true
done
