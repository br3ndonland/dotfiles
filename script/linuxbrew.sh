#!/usr/bin/env bash
### ----------------------------- Linux setup ----------------------------- ###
# A simple Linux setup script for Homebrew, Brew Bundle, and apt-get.

# Download and install Homebrew: https://docs.brew.sh/Homebrew-on-Linux
if command -v brew >/dev/null 2>&1; then
  printf "Homebrew detected."
else
  RAW="https://raw.githubusercontent.com"
  BREW_SCRIPT="Homebrew/install/master/install.sh"
  printf "\nDownloading and installing Homebrew.\n"
  printf "\n" | /usr/bin/env bash -c "$(curl -fsSL $RAW/$BREW_SCRIPT)"
  if [ -d /home/linuxbrew/.linuxbrew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [ -d ~/.linuxbrew ]; then
    eval "$(~/.linuxbrew/bin/brew shellenv)"
  else
    printf "Homebrew Linux directory not found."
  fi
fi

# Install Homebrew dependencies from Brewfile with Brew Bundle
if [ -f ~/.Brewfile ]; then
  brew bundle check --global
else
  printf "\nDownloading Brewfile and installing with Brew Bundle.\n"
  BREWFILE="${GITHUB_USER:-br3ndonland}/homebrew-brewfile/main/Brewfile"
  curl -fsSL "$RAW/$BREWFILE" | brew bundle --file=-
fi

# Install apt-get packages
declare -a PACKAGES=(
  apt-transport-https
  build-essential
  ca-certificates
  curl
  gnupg-agent
  software-properties-common
)
[ "$1" ] && PACKAGES+=("[@]")
for PACKAGE in "${PACKAGES[@]}"; do
  sudo apt-get install -qy "$PACKAGE"
done
