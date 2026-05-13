#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Publishing Android release bundle to Google Play..."
cd "$ROOT_DIR/android"
./gradlew publishReleaseBundle

echo "==> Done. Visit Google Play Console to monitor processing."
