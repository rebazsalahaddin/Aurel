#!/bin/bash
# UI-parity helper: build once, then launch the app on a given prototype screen
# and capture the simulator framebuffer.
#
#   tools/shot.sh build            — rebuild + reinstall
#   tools/shot.sh <screen> [name]  — launch AUREL_SCREEN=<screen>, shoot to /tmp/aurel_shots/<name>.png
set -euo pipefail

DD=/tmp/aurel-dd
APP="$DD/Build/Products/Debug-iphonesimulator/Aurel.app"
OUT=/tmp/aurel_shots
mkdir -p "$OUT"

if [ "${1:-}" = "build" ]; then
  xcodebuild -project Aurel.xcodeproj -scheme Aurel \
    -destination 'platform=iOS Simulator,name=iPhone 17' \
    -derivedDataPath "$DD" build 2>&1 | grep -E "error:|warning: .*deprecat|BUILD" | head -40
  xcrun simctl terminate booted com.aurel.app 2>/dev/null || true
  xcrun simctl install booted "$APP"
  echo "installed"
  exit 0
fi

SCREEN="${1:-welcome}"
NAME="${2:-$SCREEN}"
xcrun simctl terminate booted com.aurel.app 2>/dev/null || true
if [ "${RESET:-}" = "1" ]; then
  xcrun simctl uninstall booted com.aurel.app 2>/dev/null || true
  xcrun simctl install booted "$APP"
fi
SIMCTL_CHILD_AUREL_SCREEN="$SCREEN" xcrun simctl launch booted com.aurel.app >/dev/null
sleep "${DELAY:-3}"
xcrun simctl io booted screenshot --type=png "$OUT/$NAME.png" 2>/dev/null
echo "$OUT/$NAME.png"
