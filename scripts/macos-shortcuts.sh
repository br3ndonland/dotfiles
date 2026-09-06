#!/usr/bin/env bash
### ----------------------- Install macOS shortcuts ----------------------- ###

set -euo pipefail

# Cmd+Escape conflicts with the macOS Game Overlay shortcut. Disable it at:
# System Settings > Keyboard > Keyboard Shortcuts > Mission Control > Game Overlay

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
readonly REPO_DIR
readonly SHORTCUTS_DIR="$REPO_DIR/shortcuts"

if [ "$(uname -s)" != "Darwin" ]; then
  echo "-> Skipping shortcuts installation outside macOS."
  exit 0
fi

if ! INSTALLED_SHORTCUTS=$(shortcuts list 2>/dev/null); then
  echo "Error: Could not list shortcuts. Open the Shortcuts app and try again." >&2
  exit 1
fi
readonly INSTALLED_SHORTCUTS

FOUND_SHORTCUT=0
OPENED_SHORTCUT=0

# File basenames must match shortcut names for the installed check to work.
for SHORTCUT_FILE in "$SHORTCUTS_DIR"/*.shortcut; do
  [ -e "$SHORTCUT_FILE" ] || continue
  FOUND_SHORTCUT=1

  SHORTCUT_NAME=${SHORTCUT_FILE##*/}
  SHORTCUT_NAME=${SHORTCUT_NAME%.shortcut}

  if grep -Fqx -- "$SHORTCUT_NAME" <<<"$INSTALLED_SHORTCUTS"; then
    echo "-> Shortcut already installed: $SHORTCUT_NAME"
    continue
  fi

  open -a Shortcuts "$SHORTCUT_FILE"
  echo "-> Finish importing '$SHORTCUT_NAME' in Shortcuts."
  OPENED_SHORTCUT=1
done

if [ "$FOUND_SHORTCUT" -eq 0 ]; then
  echo "-> No .shortcut files found in $SHORTCUTS_DIR."
elif [ "$OPENED_SHORTCUT" -gt 0 ]; then
  echo "-> For Cmd+Escape shortcuts, disable Game Overlay at:"
  echo "   System Settings > Keyboard > Keyboard Shortcuts > Mission Control > Game Overlay"
fi
