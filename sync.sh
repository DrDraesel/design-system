#!/usr/bin/env bash
# Sync the lab design system into an app's static folder.
# Usage: bash sync.sh <app> [static-subdir]
#   app: runtrack | bertec-jump | neurosync | <any dir under ~/projects>
# Copies tokens.css + components.css only — never the preview or the Qt theme.
set -euo pipefail

ROOT="C:/Users/GAMEPOWER/projects"
SRC="$ROOT/design-system"
APP="${1:?usage: sync.sh <app> [static-subdir]}"
SUB="${2:-static}"
DEST="$ROOT/$APP/$SUB/lab-ui"

[ -d "$ROOT/$APP" ] || { echo "no such app: $ROOT/$APP" >&2; exit 1; }
mkdir -p "$DEST"

# stamp so drift is visible
{
  echo "/* lab design system — synced $(date -u +%Y-%m-%dT%H:%MZ) from projects/design-system */"
} > "$DEST/.sync-stamp"

cp "$SRC/tokens.css" "$DEST/tokens.css"
cp "$SRC/components.css" "$DEST/components.css"

echo "synced -> $DEST"
echo "  link in the page head:"
echo "    <link rel=\"stylesheet\" href=\"/$SUB/lab-ui/tokens.css\">"
echo "    <link rel=\"stylesheet\" href=\"/$SUB/lab-ui/components.css\">"
echo "  and add class=\"lab-bg\" to <body>"
