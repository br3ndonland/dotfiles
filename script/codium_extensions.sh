#!/bin/sh
### ------------------ Install VSCode/VSCodium extensions ------------------ ###
# Designed for use with Strap: https://github.com/MikeMcQuaid/strap
# Run by strap-after-setup
# CLI: https://code.visualstudio.com/docs/editor/extension-gallery
install_codium_extensions() {
  if ! command -v "$EDITOR" >/dev/null; then
    printf "Error: %s command not in PATH.\n" "$EDITOR" >&2
    return 1
  fi
  printf "Installing extensions for %s\n" "$EDITOR"
  if [ "$EDITOR" = "code" ] || [ "$EDITOR" = "code-insiders" ]; then
    cat ~/.dotfiles/codium/extensions/marketplace-open-vsx.txt \
      ~/.dotfiles/codium/extensions/marketplace-proprietary.txt \
      >~/.dotfiles/codium/extensions/marketplace-all.txt
    EXTENSIONS=~/.dotfiles/codium/extensions/marketplace-all.txt
  else
    EXTENSIONS=~/.dotfiles/codium/extensions/marketplace-open-vsx.txt
  fi
  while read -r EXTENSION; do
    INSTALLED=$($EDITOR --list-extensions | grep -ce "^$EXTENSION\$")
    if [ "$INSTALLED" = "0" ]; then
      printf "Installing %s.\n" "$EXTENSION"
      $EDITOR --install-extension "$EXTENSION"
    else
      printf "%s already installed.\n" "$EXTENSION"
    fi
  done <$EXTENSIONS
}
if [ -z "$1" ]; then
  printf "Error: No editor was given for the codium_extensions.sh script.\n"
  printf "Please specify ≥1 editor [code, code-insiders, codium].\n"
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
  printf "%s\n" $APP
  # Install extensions
  if install_codium_extensions; then
    printf "install_codium_extensions() successful for %s.\n" "$i"
  else
    printf "Error: install_codium_extensions() unsuccessful for %s.\n" "$i"
  fi
done
