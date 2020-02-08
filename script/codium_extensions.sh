#!/bin/bash
### ------------------ Install VSCode/VSCodium extensions ------------------ ###
# Designed for use with Strap: https://github.com/MikeMcQuaid/strap
# Run by strap-after-setup
# CLI: https://code.visualstudio.com/docs/editor/extension-gallery
install_codium_extensions() {
  while read -r EXTENSION; do
    INSTALLED=$($EDITOR --list-extensions | grep -ce "^$EXTENSION\$")
    if [ "$INSTALLED" == "0" ]; then
      echo "Installing $EXTENSION."
      $EDITOR --install-extension "$EXTENSION"
    else
      echo "$EXTENSION already installed."
    fi
  done <~/.dotfiles/.codium/codium-extensions.txt
}
# Editor command must be specified
if [ -z "$1" ]; then
  echo "No editor name was given for the codium_extensions.sh script. "
  echo "Please try again, specifying editor (code, code-insiders, or codium)."
  exit 1
fi
for i in "$@"; do
  EDITOR=$i
  echo "-> Installing extensions for $EDITOR"
  install_codium_extensions
done
