#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
KEYS_DIR="$ROOT_DIR/.keys"

: "${ASC_KEY_ID:?'ASC_KEY_ID not set — check .keys/env.sh'}"
: "${ASC_ISSUER_ID:?'ASC_ISSUER_ID not set — check .keys/env.sh'}"

ARCHIVE_PATH="$ROOT_DIR/build/macos/Runner.xcarchive"
EXPORT_PATH="$ROOT_DIR/build/macos/export"
KEY_PATH="$KEYS_DIR/asc_api_key.p8"
ALTOOL_KEYS_DIR="$HOME/.private_keys"

if [ ! -f "$KEY_PATH" ]; then
  echo "Missing $KEY_PATH — see .keys/README.md for setup instructions"
  exit 1
fi

mkdir -p "$ALTOOL_KEYS_DIR"
cp "$KEY_PATH" "$ALTOOL_KEYS_DIR/AuthKey_${ASC_KEY_ID}.p8"

cd "$ROOT_DIR"

echo "==> Archiving macOS app..."
xcodebuild archive \
    -workspace macos/Runner.xcworkspace \
    -scheme Runner \
    -configuration Release \
    -archivePath "$ARCHIVE_PATH"

echo "==> Exporting for App Store..."
xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportOptionsPlist "scripts/ExportOptions-AppStore-macOS.plist" \
    -exportPath "$EXPORT_PATH"

PKG_FILE=$(find "$EXPORT_PATH" -name "*.pkg" | head -1)
if [ -z "$PKG_FILE" ]; then
  echo "No .pkg found in $EXPORT_PATH — verify export options and signing"
  exit 1
fi

echo "==> Uploading $PKG_FILE to App Store Connect..."
xcrun altool --upload-app \
    -f "$PKG_FILE" \
    --type osx \
    --apiKey    "$ASC_KEY_ID" \
    --apiIssuer "$ASC_ISSUER_ID"

echo "==> Done. Visit App Store Connect to monitor processing."
