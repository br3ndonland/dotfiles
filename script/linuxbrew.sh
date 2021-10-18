#!/usr/bin/env bash
### ----------------------------- Linux setup ----------------------------- ###
# A simple Linux setup script for Homebrew, Brew Bundle, and apt-get.

set -eo pipefail

# Download and install Homebrew: https://docs.brew.sh/Homebrew-on-Linux
if command -v brew &>/dev/null; then
  printf "Homebrew detected."
else
  RAW="https://raw.githubusercontent.com"
  BREW_SCRIPT="Homebrew/install/HEAD/install.sh"
  printf "\nDownloading and installing Homebrew.\n"
  printf "\n" | /usr/bin/env bash -c "$(curl -fsSL $RAW/$BREW_SCRIPT)"
  if [ -d /home/linuxbrew/.linuxbrew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [ -d "$HOME/.linuxbrew" ]; then
    eval "$("$HOME"/.linuxbrew/bin/brew shellenv)"
  fi
  command -v brew &>/dev/null || printf "\nError: Homebrew not found" && exit 1
fi

# Install Homebrew dependencies from Brewfile with Brew Bundle
skips="awscli black deno jupyterlab macos-trash mas pure zsh-completions"
export HOMEBREW_BUNDLE_BREW_SKIP="$skips"
if [ -f "$HOME/.Brewfile" ]; then
  brew bundle check --global || brew bundle --global
else
  printf "\nDownloading Brewfile and installing with Brew Bundle.\n"
  BREWFILE="${STRAP_GITHUB_USER:-br3ndonland}/dotfiles/HEAD/Brewfile"
  curl -fsSL "$RAW/$BREWFILE" | brew bundle --file=-
fi

# Install apt-get packages
PACKAGES=(
  apt-transport-https
  build-essential
  ca-certificates
  curl
  gnupg-agent
  software-properties-common
)
[ -n "$1" ] && PACKAGES+=("[@]")
for PACKAGE in "${PACKAGES[@]}"; do
  sudo apt-get install -qy "$PACKAGE"
done
