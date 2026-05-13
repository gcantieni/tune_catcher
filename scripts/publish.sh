#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-}"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
KEYS_DIR="$ROOT_DIR/.keys"
SCRIPTS_DIR="$ROOT_DIR/scripts"

if [ -z "$TARGET" ]; then
  echo "Usage: publish.sh <ios|macos|android>"
  exit 1
fi

ENV_FILE="$KEYS_DIR/env.sh"
if [ ! -f "$ENV_FILE" ]; then
  echo "Missing .keys/env.sh — see .keys/README.md for setup instructions"
  exit 1
fi
# shellcheck source=/dev/null
source "$ENV_FILE"

case "$TARGET" in
  ios)     bash "$SCRIPTS_DIR/publish_ios.sh" ;;
  macos)   bash "$SCRIPTS_DIR/publish_macos.sh" ;;
  android) bash "$SCRIPTS_DIR/publish_android.sh" ;;
  *)       echo "Unknown target: $TARGET — use ios, macos, or android"; exit 1 ;;
esac
