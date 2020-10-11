#! /bin/bash
### ----------------------------- Linux setup ----------------------------- ###
# A simple Linux setup script for Homebrew, Brew Bundle, and apt-get.

# Download and install Homebrew: https://docs.brew.sh/Homebrew-on-Linux
RAW="https://raw.githubusercontent.com"
BREW_SCRIPT="Homebrew/install/master/install.sh"
printf "\nDownloading and installing Homebrew.\n"
printf "\n" | /bin/bash -c "$(curl -fsSL $RAW/$BREW_SCRIPT)"
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew &&
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
test -r ~/.bash_profile &&
  echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
test -r ~/.zshrc &&
  echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.zshrc

# Install Homebrew dependencies from Brewfile with Brew Bundle
printf "\nDownloading Brewfile and installing with Brew Bundle.\n"
BREWFILE="${GITHUB_USER:-br3ndonland}/homebrew-brewfile/master/Brewfile"
curl -fsSL "$RAW/$BREWFILE" | brew bundle check || brew bundle

# Install apt-get packages
if [ "$1" ]; then
  declare -a PACKAGES="[@]"
  for PACKAGE in "${PACKAGES[@]}"; do
    "sudo apt-get install -y $PACKAGE"
  done
else
  printf "\nNo apt-get packages specified. No worries.\n"
fi
