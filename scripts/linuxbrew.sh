#!/usr/bin/env bash
### ----------------------------- Linux setup ----------------------------- ###
# A simple Linux setup script for Homebrew, Brew Bundle, and apt-get.

set -eo pipefail

# Set up DEB packages
# Proton VPN: https://protonvpn.com/support/linux-vpn-tool/
if command -v xdg-user-dir &>/dev/null; then
  download_dir=$(xdg-user-dir DOWNLOAD)
else
  mkdir -p "$HOME/Downloads"
  download_dir="$HOME/Downloads"
fi
deb_url="https://repo.protonvpn.com/debian/dists/stable/main/binary-all"
deb_file="protonvpn-stable-release_1.0.4_all.deb"
deb_path="$download_dir/$deb_file"
printf "\nDownloading Proton VPN setup DEB to %s\n" "$deb_path"
curl -fsSL -o "$deb_path" "$deb_url/$deb_file"
printf "\nInstalling Proton VPN setup DEB from %s\n" "$deb_path"
sudo dpkg -i "$deb_path"
sudo apt update

# Install apt-get packages
PACKAGES=(
  apt-transport-https
  build-essential
  ca-certificates
  curl
  file
  git
  gnupg-agent
  procps
  protonvpn-cli
  software-properties-common
)
[ -n "$1" ] && PACKAGES+=("[@]")
for PACKAGE in "${PACKAGES[@]}"; do
  sudo apt-get install -qy "$PACKAGE"
done

detect_homebrew_prefix() {
  if [ -n "$HOMEBREW_PREFIX" ] && [ -d "$HOMEBREW_PREFIX" ]; then
    return
  elif [ -d "$HOME/.linuxbrew" ]; then
    HOMEBREW_PREFIX="$HOME/.linuxbrew"
  else
    HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  fi
}

# Download and install Homebrew: https://docs.brew.sh/Homebrew-on-Linux
if command -v brew &>/dev/null; then
  printf "\nHomebrew detected.\n"
else
  printf "\nbrew command not in shell environment. Attempting to load."
  detect_homebrew_prefix
  eval "$("$HOMEBREW_PREFIX"/bin/brew shellenv)"
  if ! command -v brew &>/dev/null; then
    printf "\nHomebrew not found. Downloading and installing Homebrew.\n"
    BREW_SCRIPT="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
    NONINTERACTIVE=1 /usr/bin/env bash -c "$(curl -fsSL $BREW_SCRIPT)"
  fi
  detect_homebrew_prefix
  eval "$("$HOMEBREW_PREFIX"/bin/brew shellenv)"
  command -v brew &>/dev/null || printf "\nError: Homebrew not found" && exit 1
fi
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >>~/.profile
