#!/bin/sh
### --------------------- Install VSCodium extensions --------------------- ###
# Run by strap-after-setup
# CLI: https://code.visualstudio.com/docs/editor/extension-gallery
install_codium_extensions() {
  if ! command -v "$EDITOR" >/dev/null; then
    printf "Error: %s command not in PATH.\n" "$EDITOR" >&2
    return 1
  fi
  printf "\nInstalling extensions for %s\n\n" "$EDITOR"
  if [ "$EDITOR" = "code-insiders" ]; then
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
  printf "\nError: No editor was given for the codium_extensions.sh script.\n"
  printf "Please specify ≥1 editor: code code-insiders codium\n"
  exit 1
fi

for i in "$@"; do
  EDITOR=$i
  case $i in
  code)
    APP="VSCodium"
    ;;
  code-insiders)
    APP="Visual\ Studio\ Code\ -\ Insiders"
    ;;
  esac
  if [ "$(uname -s)" = "Darwin" ]; then
    export PATH="/Applications/$APP.app/Contents/Resources/app/bin:$PATH"
  fi
  if install_codium_extensions; then
    printf "\nExtensions successfully installed for %s.\n" "$i"
  else
    printf "\nError: extensions not successfully installed for %s.\n" "$i"
  fi
done
