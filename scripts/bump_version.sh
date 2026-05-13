#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PUBSPEC="$ROOT_DIR/pubspec.yaml"
TYPE="${1:-patch}"

current=$(grep '^version:' "$PUBSPEC" | sed 's/version: //' | tr -d '[:space:]')
semver="${current%+*}"
build="${current#*+}"

IFS='.' read -r major minor patch_ver <<< "$semver"

build=$((build + 1))

case "$TYPE" in
  major) major=$((major + 1)); minor=0; patch_ver=0 ;;
  minor) minor=$((minor + 1)); patch_ver=0 ;;
  patch) patch_ver=$((patch_ver + 1)) ;;
  *) echo "Unknown type: $TYPE — use patch, minor, or major"; exit 1 ;;
esac

new_version="${major}.${minor}.${patch_ver}+${build}"
echo "Bumping: $current → $new_version"
perl -i -p -e "s/^version: .*/version: ${new_version}/" "$PUBSPEC"
