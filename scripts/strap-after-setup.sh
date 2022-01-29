#!/usr/bin/env bash
### ----------------- Bootstrap post-installation scripts ----------------- ###
# Run by run_dotfile_scripts in bootstrap.sh
# Scripts must be executable (chmod +x)
echo "-> Running strap-after-setup. Some steps may require password entry."

### Configure macOS
if [ "${MACOS:-0}" -gt 0 ] || [ "$(uname)" = "Darwin" ]; then
  "$HOME"/.dotfiles/scripts/macos.sh
else
  echo "Not macOS. Skipping macos.sh."
fi

### Install Poetry
if command -v pipx &>/dev/null && ! command -v poetry &>/dev/null; then
  pipx install poetry
else
  echo "Skipping Poetry install."
fi

### Install VSCode extensions
for i in {code,code-exploration,code-insiders,code-server,codium}; do
  if [ "${CODESPACE:-0}" -gt 0 ] || [ "$(whoami)" = "codespace" ]; then
    echo "Error: Codespaces VSCode CLI can't install extensions."
  else
    "$HOME"/.dotfiles/scripts/vscode-extensions.sh "$i"
  fi
done

### Set shell
if ! [[ $SHELL =~ "zsh" ]] && command -v zsh &>/dev/null; then
  echo "--> Changing shell to Zsh. Password entry required."
  [ "${LINUX:-0}" -gt 0 ] || [ "$(uname)" = "Linux" ] &&
    command -v zsh | sudo tee -a /etc/shells
  sudo chsh -s "$(command -v zsh)" "$USER"
else
  echo "Shell is already set to Zsh."
fi
