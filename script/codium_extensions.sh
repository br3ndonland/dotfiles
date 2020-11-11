#!/usr/bin/env bash
### --------------------- Install VSCodium extensions --------------------- ###
# Run by strap-after-setup
# CLI: https://code.visualstudio.com/docs/editor/extension-gallery

check_open_vsx() {
  if ! (command -v curl >/dev/null && command -v jq >/dev/null); then
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
  printf "\nInstalling extensions for %s...\n\n" "$EDITOR"
  if [ "$EDITOR" = "code-insiders" ]; then
    cat ~/.dotfiles/codium/extensions/marketplace-open-vsx.txt \
      ~/.dotfiles/codium/extensions/marketplace-proprietary.txt \
      >~/.dotfiles/codium/extensions/marketplace-all.txt
    EXTENSIONS=~/.dotfiles/codium/extensions/marketplace-all.txt
  else
    EXTENSIONS=~/.dotfiles/codium/extensions/marketplace-open-vsx.txt
  fi
  INSTALLED=("$($EDITOR --list-extensions --show-versions)")
  while read -r EXT; do
    EXT_INFO=$(printf %s "${INSTALLED[@]}" | grep "$EXT")
    ! [ "$EXT_INFO" ] && $EDITOR --install-extension "$EXT" && continue
    ! [ "$EDITOR" = "code-insiders" ] && check_open_vsx "$EXT_INFO" && continue
  done <$EXTENSIONS
}

if [ -z "$1" ]; then
  printf "\nError: No editor was given for the codium_extensions.sh script.\n"
  printf "Please specify ≥1 editor: code code-insiders\n"
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
  if ! command -v "$EDITOR" >/dev/null; then
    printf "Error: %s command not in PATH.\n" "$EDITOR" >&2
    return 1
  fi
  if install_codium_extensions; then
    printf "\nExtensions successfully installed for %s.\n" "$i"
  else
    printf "\nError: extensions not successfully installed for %s.\n" "$i"
  fi
done
