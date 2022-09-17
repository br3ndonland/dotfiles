#!/usr/bin/env bash
### ----------------------------- Linux setup ----------------------------- ###
# A simple Linux setup script for Homebrew, Brew Bundle, and apt-get.

set -eo pipefail

# Download and install Homebrew: https://docs.brew.sh/Homebrew-on-Linux
if command -v brew &>/dev/null; then
  printf "\nHomebrew detected.\n"
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
skips="awscli black deno jupyterlab macos-trash mas zsh-completions"
export HOMEBREW_BUNDLE_BREW_SKIP="$skips"
if [ -f "$HOME/.Brewfile" ]; then
  printf "\nInstalling %s with Brew Bundle.\n" "$HOME/.Brewfile"
  brew bundle check --global || brew bundle --global
else
  printf "\nDownloading Brewfile and installing with Brew Bundle.\n"
  BREWFILE="${STRAP_GITHUB_USER:-br3ndonland}/dotfiles/HEAD/Brewfile"
  curl -fsSL "$RAW/$BREWFILE" | brew bundle --file=-
fi

# Set up Proton VPN
deb_file="protonvpn-stable-release_1.0.1-1_all.deb"
deb_path="$HOME/Downloads/$deb_file"
printf "\nDownloading Proton VPN setup DEB to %s\n" "$deb_path"
curl -fsSL -o "$deb_path" "https://protonvpn.com/download/$deb_file"
printf "\nInstalling Proton VPN setup DEB from %s\n" "$deb_path"
sudo apt-get install -qy "$deb_path"
sudo apt-get update

# Install apt-get packages
PACKAGES=(
  apt-transport-https
  build-essential
  ca-certificates
  curl
  gnupg-agent
  protonvpn-cli
  software-properties-common
)
[ -n "$1" ] && PACKAGES+=("[@]")
for PACKAGE in "${PACKAGES[@]}"; do
  sudo apt-get install -qy "$PACKAGE"
done
