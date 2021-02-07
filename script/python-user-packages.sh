#!/usr/bin/env bash
### --------------------- Install user Python packages --------------------- ###
# Run by strap-after-setup
# Manage user Python packages after install: https://github.com/pipxproject/pipx

pipx_install_requirements() {
  printf "\n-> Installing user Python packages with pipx...\n\n"
  PY="$(python3 --version)"
  PIPX_LIST="$(pipx list)"
  while read -r P; do
    case "$P" in
    awscli) : "aws" ;;
    httpie) : "http" ;;
    *) : "$P" ;;
    esac
    CMD="$_"
    if [[ $(echo "$PIPX_LIST" | grep -ce "package $P .*, $PY") -gt 0 ]]; then
      echo "$P already installed."
    elif [[ $(echo "$PIPX_LIST" | grep -ce "package $P") -gt 0 ]]; then
      echo "Reinstalling $P for $PY."
      pipx uninstall "$P" && pipx install --python "$(command -v python3)" "$P"
    elif command -v "$CMD" &>/dev/null; then
      echo "$P already on PATH at $(command -v "$CMD")."
    else
      pipx install "$P"
    fi
  done <"$HOME/.dotfiles/py/requirements.txt"
}

if ! command -v pipx &>/dev/null; then
  printf "\n-> Error: pipx must be installed and on PATH.\n\n"
  exit 1
elif pipx_install_requirements; then
  printf "\n-> Successful pipx package installation.\n\n"
else
  printf "\n-> Unsuccessful pipx package installation.\n\n"
fi
