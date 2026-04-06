#!/usr/bin/env sh
### ---------------------- Install VSCode extensions ---------------------- ###
# CLI: https://code.visualstudio.com/docs/editor/extension-marketplace

install_extensions() {
  printf "\nInstalling extensions for '%s'...\n\n" "$1"
  case $1 in
  code*)
    cat \
      "$HOME/.dotfiles/vscode/extensions/marketplace-open-vsx.txt" \
      "$HOME/.dotfiles/vscode/extensions/marketplace-microsoft.txt" \
      >"/tmp/marketplace-all.txt"
    extensions="/tmp/marketplace-all.txt"
    ;;
  *)
    extensions="$HOME/.dotfiles/vscode/extensions/marketplace-open-vsx.txt"
    ;;
  esac
  while read -r extension; do
    case $extension in
    '#'*) printf "Skipping commented extension '%s'\n\n" "$extension" && continue ;;
    *'@prerelease')
      extension="${extension%@prerelease}"
      pre=1
      printf "Installing pre-release extension '%s'\n" "$extension"
      ;;
    *) printf "Installing extension '%s'\n" "$extension" ;;
    esac
    extension_name=$(printf %s "$extension" | cut -d @ -f 1)
    [ "$extension" = "$extension_name" ] && latest=1 || true
    $1 --install-extension "$extension" ${latest:+ --force} ${pre:+ --pre-release}
    printf '\n'
  done <"$extensions"
}

if [ -z "$1" ]; then
  printf "\nError: No argument was provided. Please specify ≥1 editor.\n"
  exit 1
fi

for i in "$@"; do
  case $i in
  code) distro="Visual Studio Code" ;;
  code-exploration) distro="Visual Studio Code - Exploration" ;;
  code-insiders) distro="Visual Studio Code - Insiders" ;;
  codium) distro="VSCodium" ;;
  esac
  MACOS_BIN="/Applications/$distro.app/Contents/Resources/app/bin"
  if type "$i" >/dev/null 2>&1; then
    printf "\n%s command on PATH.\n" "$i"
  elif [ "$(uname -s)" = "Darwin" ] && [ -d "$MACOS_BIN" ]; then
    export PATH="$MACOS_BIN:$PATH"
    printf "\n%s command loaded onto PATH.\n" "$i"
  fi
  if ! type "$i" >/dev/null 2>&1; then
    printf "\nError: %s command not on PATH.\n" "$i" >&2
    exit 1
  elif install_extensions "$i"; then
    printf "Extensions successfully installed for %s.\n" "$i"
  else
    printf "Error: extensions not successfully installed for %s.\n" "$i"
  fi
done
