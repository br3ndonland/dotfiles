#!/usr/bin/env bash
### ---------------------- Install VSCode extensions ---------------------- ###
# CLI: https://code.visualstudio.com/docs/editor/extension-gallery

check_open_vsx() {
  if ! (command -v curl &>/dev/null && command -v fx &>/dev/null); then
    printf "curl and antonmedv/fx required to check extension version.\n"
    return
  fi
  URL="https://open-vsx.org/api/$(printf %s "$1" | cut -d @ -f 1 | tr '.' '/')"
  LOCAL_VERSION=$(printf %s "$1" | cut -d @ -f 2)
  OPEN_VSX_VERSION=$(
    curl -fs -X GET "$URL" -H "accept: application/json" |
      fx .version
  )
  if [[ "$LOCAL_VERSION" == "$OPEN_VSX_VERSION" ]]; then
    printf "Extension '%s' up-to-date with Open VSX.\n" "$1"
  else
    $EDITOR --install-extension "$(printf %s "$1" | cut -d @ -f 1)" --force
  fi
}

install_extensions() {
  printf "\nInstalling extensions for %s...\n\n" "$1"
  PREFIX="$HOME/.dotfiles/vscode/extensions/marketplace"
  if [[ "$1" == "code-exploration" ]] || [[ "$1" == "code-insiders" ]]; then
    cat "$PREFIX-open-vsx.txt" "$PREFIX-proprietary.txt" >"$PREFIX-all.txt"
    EXTENSIONS="$PREFIX-all.txt"
  else
    EXTENSIONS="$PREFIX-open-vsx.txt"
  fi
  INSTALLED=("$($1 --list-extensions --show-versions)")
  while read -r EXT; do
    EXT_INFO=$(printf %s "${INSTALLED[@]}" | grep "$EXT@")
    if [ "$EXT_INFO" ]; then
      printf "Extension '%s' installed.\n" "$EXT_INFO"
    else
      $1 --install-extension "$EXT"
    fi
    if [ "$1" = "codium" ]; then check_open_vsx "$EXT_INFO"; else continue; fi
  done <"$EXTENSIONS"
}

if [ -z "$1" ]; then
  printf "\nError: No argument was provided. Please specify ≥1 editor.\n"
  exit 1
fi

for i in "$@"; do
  case $i in
  code) : "Code" ;;
  code-exploration) : "Visual Studio Code - Exploration" ;;
  code-insiders) : "Visual Studio Code - Insiders" ;;
  codium) : "VSCodium" ;;
  esac
  MACOS_BIN="/Applications/$_.app/Contents/Resources/app/bin"
  if command -v "$i" &>/dev/null; then
    printf "\n%s command on PATH.\n" "$i"
  elif [ "$(uname -s)" = "Darwin" ] && [ -d "$MACOS_BIN" ]; then
    export PATH="$MACOS_BIN:$PATH"
    printf "\n%s command loaded onto PATH.\n" "$i"
  fi
  if ! command -v "$i" &>/dev/null; then
    printf "\nError: %s command not on PATH.\n" "$i" >&2
    exit 1
  elif install_extensions "$i"; then
    printf "\nExtensions successfully installed for %s.\n" "$i"
  else
    printf "\nError: extensions not successfully installed for %s.\n" "$i"
  fi
done
