#!/usr/bin/env bash
### --------------------- Install VSCodium extensions --------------------- ###
# Run by strap-after-setup
# CLI: https://code.visualstudio.com/docs/editor/extension-gallery

check_open_vsx() {
  if ! (command -v curl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1); then
    printf "curl and jq required to check extension version.\n"
    return
  fi
  URL="https://open-vsx.org/api/$(printf %s "$1" | cut -d @ -f 1 | tr '.' '/')"
  LOCAL_VERSION=$(printf %s "$1" | cut -d @ -f 2)
  OPEN_VSX_VERSION=$(
    curl -fs -X GET "$URL" -H "accept: application/json" |
      jq --raw-output .version
  )
  if [[ "$LOCAL_VERSION" == "$OPEN_VSX_VERSION" ]]; then
    printf "Extension '%s' installed and up-to-date with Open VSX.\n" "$1"
  else
    $EDITOR --install-extension "$(printf %s "$1" | cut -d @ -f 1)"
  fi
}

install_codium_extensions() {
  printf "\nInstalling extensions for %s...\n\n" "$1"
  if [[ "$DISTRO" == "code-exploration" || "$DISTRO" == "code-insiders" ]]; then
    cat ~/.dotfiles/codium/extensions/marketplace-open-vsx.txt \
      ~/.dotfiles/codium/extensions/marketplace-proprietary.txt \
      >~/.dotfiles/codium/extensions/marketplace-all.txt
    EXTENSIONS=~/.dotfiles/codium/extensions/marketplace-all.txt
  else
    EXTENSIONS=~/.dotfiles/codium/extensions/marketplace-open-vsx.txt
  fi
  declare -a INSTALLED=("$($1 --list-extensions --show-versions)")
  while read -r EXT; do
    EXT_INFO=$(printf %s "${INSTALLED[@]}" | grep "$EXT")
    if [ "$EXT_INFO" ]; then
      printf "Extension '%s' installed.\n" "$EXT_INFO"
    else
      $1 --install-extension "$EXT"
    fi
    if [ "$1" = "codium" ]; then check_open_vsx "$EXT_INFO"; else continue; fi
  done <$EXTENSIONS
}

if [ -z "$1" ]; then
  printf "\nError: No editor was given for the codium_extensions.sh script.\n"
  printf "Please specify ≥1 editor: code code-insiders\n"
  exit 1
fi

for i in "$@"; do
  case $i in
  code)
    MACOS_APP="Code"
    ;;
  code-insiders)
    MACOS_APP="Visual\ Studio\ Code\ -\ Insiders"
    ;;
  codium)
    MACOS_APP="VSCodium"
    ;;
  esac
  MACOS_BIN="/Applications/$MACOS_APP.app/Contents/Resources/app/bin"
  if [ "$(uname -s)" = "Darwin" ] && [ -d "$MACOS_BIN" ]; then
    export PATH="$MACOS_BIN:$PATH"
  fi
  if ! command -v "$i" >/dev/null 2>&1; then
    printf "\nError: %s command not on PATH.\n" "$i" >&2
    exit 1
  elif install_codium_extensions "$i"; then
    printf "\nExtensions successfully installed for %s.\n" "$i"
  else
    printf "\nError: extensions not successfully installed for %s.\n" "$i"
  fi
done
