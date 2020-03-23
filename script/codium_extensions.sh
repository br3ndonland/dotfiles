#!/bin/sh
### ------------------ Install VSCode/VSCodium extensions ------------------ ###
# Designed for use with Strap: https://github.com/MikeMcQuaid/strap
# Run by strap-after-setup
# CLI: https://code.visualstudio.com/docs/editor/extension-gallery
install_codium_extensions() {
  if ! command -v "$EDITOR" >/dev/null; then
    echo "-> Error: $EDITOR command not in PATH." >&2
    return 1
  fi
  echo "Installing extensions for $EDITOR"
  if [ "$EDITOR" = "code" ] || [ "$EDITOR" = "code-insiders" ]; then
    cat ~/.dotfiles/codium/codium-extensions.txt \
      ~/.dotfiles/codium/code-extensions.txt >~/.dotfiles/codium/all.txt
    EXTENSIONS=~/.dotfiles/codium/all.txt
  else
    EXTENSIONS=~/.dotfiles/codium/codium-extensions.txt
  fi
  while read -r EXTENSION; do
    INSTALLED=$($EDITOR --list-extensions | grep -ce "^$EXTENSION\$")
    if [ "$INSTALLED" = "0" ]; then
      echo "Installing $EXTENSION."
      $EDITOR --install-extension "$EXTENSION"
    else
      echo "$EXTENSION already installed."
    fi
  done <$EXTENSIONS
}
if [ -z "$1" ]; then
  echo "No editor name was given for the codium_extensions.sh script. "
  echo "Please specify ≥1 editor [code, code-insiders, codium]."
  exit 1
fi
for i in "$@"; do
  EDITOR=$i
  # Add editor command to PATH
  case $i in
  code)
    APP="Visual\ Studio\ Code"
    ;;
  code-insiders)
    APP="Visual\ Studio\ Code\ -\ Insiders"
    ;;
  codium)
    APP="VSCodium"
    ;;
  esac
  # TODO: Figure out how to use CLI without restarting terminal to install
  # extensions via Strap. Currently, a terminal restart is needed before the CLI
  # can be used. https://code.visualstudio.com/docs/setup/mac
  # export PATH="$PATH:/Applications/$APP.app/Contents/Resources/app/bin"
  echo $APP
  # Install extensions
  if install_codium_extensions; then
    echo "-> install_codium_extensions() ran successfully for $i."
  else
    echo "-> Error: install_codium_extensions() didn't run successfully for $i."
  fi
done
