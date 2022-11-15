#!/usr/bin/env bash
### ----------------- Bootstrap post-installation scripts ----------------- ###
# Run by run_dotfile_scripts in bootstrap.sh
# Scripts must be executable (chmod +x)
echo "-> Running strap-after-setup. Some steps may require password entry."

### Configure macOS
if [ "${MACOS:-0}" -gt 0 ] || [ "$(uname)" = "Darwin" ]; then
  "$HOME"/.dotfiles/scripts/macos.sh
  # Configure 1Password SSH agent path for consistency with Linux
  # https://developer.1password.com/docs/ssh/get-started
  mkdir -p ~/.1password && ln -s \
    ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock \
    ~/.1password/agent.sock
else
  echo "Not macOS. Skipping macos.sh."
fi

### Install Hatch
if command -v pipx &>/dev/null && ! command -v hatch &>/dev/null; then
  echo "Installing Hatch with pipx."
  pipx install "hatch>=1,<2"
else
  echo "Skipping Hatch install."
fi

### Install node
if command -v nvm &>/dev/null && ! command -v node &>/dev/null; then
  nvm install --lts
else
  echo "node version is already installed"
fi

### Symlink node for xcode use
if command -v node &>/dev/null && ! [ -L /usr/local/bin/node ]; then
  sudo ln -s "$(which node)" /usr/local/bin
else
  echo "node is already symlinked for xcode"
fi

### TODO: Ensure correct ruby version is installed and symlinked via rbenv
### TODO: Install IDB application using pip; idb-companion already installed via homebrew -- ensure symlinked
### TODO: symlink watchman to /usr/local/bin

### Install VSCode extensions
for i in {code,code-exploration,code-insiders,code-server,codium}; do
  "$HOME"/.dotfiles/scripts/vscode-extensions.sh "$i"
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
