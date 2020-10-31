#!/bin/bash
### ------------ bootstrap.sh - set up development environment ------------ ###
# https://github.com/MikeMcQuaid/strap, https://github.com/MikeMcQuaid/dotfiles
set -e
[ "$(uname -s)" = "Darwin" ] && export MACOS=1 && export UNIX=1
[ "$(uname -s)" = "Linux" ] && export LINUX=1 && export UNIX=1
[ "$(whoami)" = "codespace" ] && export CODESPACE=1
[[ "$1" = "--debug" || -o xtrace ]] && STRAP_DEBUG="1"
STRAP_SUCCESS=""

sudo_askpass() {
  if [ -n "$SUDO_ASKPASS" ]; then
    sudo --askpass "$@"
  else
    sudo "$@"
  fi
}

cleanup() {
  set +e
  sudo_askpass rm -rf "$CLT_PLACEHOLDER" "$SUDO_ASKPASS" "$SUDO_ASKPASS_DIR"
  sudo --reset-timestamp
  if [ -z "$STRAP_SUCCESS" ]; then
    if [ -n "$STRAP_STEP" ]; then
      echo "!!! $STRAP_STEP FAILED" >&2
    else
      echo "!!! FAILED" >&2
    fi
    if [ -z "$STRAP_DEBUG" ]; then
      echo "!!! Run '$0 --debug' for debugging output." >&2
    fi
  fi
}
trap "cleanup" EXIT

if [ -n "$STRAP_DEBUG" ]; then
  set -x
else
  STRAP_QUIET_FLAG="-q"
  Q="$STRAP_QUIET_FLAG"
fi

STDIN_FILE_DESCRIPTOR="0"
[ -t "$STDIN_FILE_DESCRIPTOR" ] && STRAP_INTERACTIVE="1"
STRAP_GIT_NAME=${STRAP_GIT_NAME:-"Brendon Smith"}
STRAP_GIT_EMAIL=${STRAP_GIT_EMAIL:-"br3ndonland@protonmail.com"}
STRAP_GITHUB_USER=${STRAP_GITHUB_USER:-"br3ndonland"}
STRAP_GITHUB_TOKEN=${STRAP_GITHUB_TOKEN?STRAP_GITHUB_TOKEN not set}

# Prompt for sudo password and initialize (or reinitialize) sudo
sudo --reset-timestamp

clear_debug() {
  set +x
}
reset_debug() {
  if [ -n "$STRAP_DEBUG" ]; then
    set -x
  fi
}

sudo_init() {
  if [ -z "$STRAP_INTERACTIVE" ]; then
    return
  fi
  local SUDO_PASSWORD SUDO_PASSWORD_SCRIPT
  if ! sudo --validate --non-interactive &>/dev/null; then
    while true; do
      read -rsp "--> Enter your password (for sudo access):" SUDO_PASSWORD
      echo
      if sudo --validate --stdin 2>/dev/null <<<"$SUDO_PASSWORD"; then
        break
      fi
      unset SUDO_PASSWORD
      echo "!!! Wrong password!" >&2
    done
    clear_debug
    SUDO_PASSWORD_SCRIPT="$(
      cat <<BASH
#!/bin/bash
echo "$SUDO_PASSWORD"
BASH
    )"
    unset SUDO_PASSWORD
    SUDO_ASKPASS_DIR="$(mktemp -d)"
    SUDO_ASKPASS="$(mktemp "$SUDO_ASKPASS_DIR"/strap-askpass-XXXXXXXX)"
    chmod 700 "$SUDO_ASKPASS_DIR" "$SUDO_ASKPASS"
    bash -c "cat > '$SUDO_ASKPASS'" <<<"$SUDO_PASSWORD_SCRIPT"
    unset SUDO_PASSWORD_SCRIPT
    reset_debug
    export SUDO_ASKPASS
  fi
}
sudo_refresh() {
  clear_debug
  if [ -n "$SUDO_ASKPASS" ]; then
    sudo --askpass --validate
  else
    sudo_init
  fi
  reset_debug
}

abort() {
  STRAP_STEP=""
  echo "!!! $*" >&2
  exit 1
}
log() {
  STRAP_STEP="$*"
  sudo_refresh
  echo "--> $*"
}
logn() {
  STRAP_STEP="$*"
  sudo_refresh
  printf -- "--> %s " "$*"
}
logk() {
  STRAP_STEP=""
  echo "OK"
}
escape() {
  printf '%s' "${1//\'/\'}"
}

# Given a list of scripts in the dotfiles repo, run the first one that exists.
run_dotfile_scripts() {
  if [ -d ~/.dotfiles ]; then
    (
      cd ~/.dotfiles
      for i in "$@"; do
        if [ -f "$i" ] && [ -x "$i" ]; then
          log "Running dotfiles $i:"
          if [ -z "$STRAP_DEBUG" ]; then
            "$i" 2>/dev/null
          else
            "$i"
          fi
          break
        fi
      done
    )
  fi
}

[ "$USER" = "root" ] && abort "Run Strap as yourself, not root."
groups | grep $Q -E "\b(admin)\b" || abort "Add $USER to the admin group."

[ $MACOS ] && [ -z "$STRAP_CI" ] && caffeinate -s -w $$ &

if [ $MACOS ]; then
  logn "Configuring security settings:"
  SAFARI="com.apple.Safari"
  defaults write $SAFARI $SAFARI.ContentPageGroupIdentifier.WebKit2JavaEnabled \
    -bool false
  defaults write $SAFARI \
    $SAFARI.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles \
    -bool false
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0
  sudo_askpass defaults write \
    /Library/Preferences/com.apple.alf globalstate -int 1
  sudo_askpass launchctl load \
    /System/Library/LaunchDaemons/com.apple.alf.agent.plist 2>/dev/null
fi
if [ $MACOS ] && [ -n "$STRAP_GIT_NAME" ] && [ -n "$STRAP_GIT_EMAIL" ]; then
  FOUND="Found this computer? Please contact"
  LOGIN_TEXT=$(escape "$FOUND $STRAP_GIT_NAME at $STRAP_GIT_EMAIL.")
  echo "$LOGIN_TEXT" | grep -q '[()]' && LOGIN_TEXT="'$LOGIN_TEXT'"
  sudo_askpass defaults write \
    /Library/Preferences/com.apple.loginwindow LoginwindowText "$LOGIN_TEXT"
  logk
fi

# Check and enable full-disk encryption.
logn "Checking full-disk encryption status:"
VAULT_MSG="FileVault is (On|Off, but will be enabled after the next restart)."
if fdesetup status | grep $Q -E "$VAULT_MSG"; then
  logk
elif [ ! $MACOS ] || [ -n "$STRAP_CI" ]; then
  echo
  logn "Skipping full-disk encryption."
elif [ -n "$STRAP_INTERACTIVE" ]; then
  echo
  log "Enabling full-disk encryption on next reboot:"
  sudo_askpass fdesetup enable -user "$USER" |
    tee ~/Desktop/"FileVault Recovery Key.txt"
  logk
else
  echo
  abort "Run 'sudo fdesetup enable -user \"$USER\"' for full-disk encryption."
fi

# Set up Xcode Command Line Tools.
install_xcode() {
  if ! [ -f "/Library/Developer/CommandLineTools/usr/bin/git" ]; then
    log "Installing the Xcode Command Line Tools:"
    CLT_STRING=".com.apple.dt.CommandLineTools.installondemand.in-progress"
    CLT_PLACEHOLDER="/tmp/$CLT_STRING"
    sudo_askpass touch "$CLT_PLACEHOLDER"
    CLT_PACKAGE=$(softwareupdate -l |
      grep -B 1 "Command Line Tools" |
      awk -F"*" '/^ *\*/ {print $2}' |
      sed -e 's/^ *Label: //' -e 's/^ *//' |
      sort -V |
      tail -n1)
    sudo_askpass softwareupdate -i "$CLT_PACKAGE"
    sudo_askpass rm -f "$CLT_PLACEHOLDER"
    if ! [ -f "/Library/Developer/CommandLineTools/usr/bin/git" ]; then
      if [ -n "$STRAP_INTERACTIVE" ]; then
        echo
        logn "Requesting user install of Xcode Command Line Tools:"
        xcode-select --install
      else
        echo
        abort "Install Xcode Command Line Tools with 'xcode-select --install'."
      fi
    fi
    logk
  fi
}
check_xcode_license() {
  if /usr/bin/xcrun clang 2>&1 | grep $Q license; then
    if [ -n "$STRAP_INTERACTIVE" ]; then
      logn "Asking for Xcode license confirmation:"
      sudo_askpass xcodebuild -license
      logk
    else
      abort "Run 'sudo xcodebuild -license' to agree to the Xcode license."
    fi
  fi
}
[ $MACOS ] && install_xcode && check_xcode_license

logn "Configuring Git:"
if [ -n "$STRAP_GIT_NAME" ] && ! git config user.name >/dev/null; then
  git config --global user.name "$STRAP_GIT_NAME"
fi

if [ -n "$STRAP_GIT_EMAIL" ] && ! git config user.email >/dev/null; then
  git config --global user.email "$STRAP_GIT_EMAIL"
fi

if [ -n "$STRAP_GITHUB_USER" ] &&
  [ "$(git config github.user)" != "$STRAP_GITHUB_USER" ]; then
  git config --global github.user "$STRAP_GITHUB_USER"
fi

# Squelch git 2.x warning message when pushing
if ! git config push.default >/dev/null; then
  git config --global push.default simple
fi

# Setup GitHub HTTPS credentials.
if git credential-osxkeychain 2>&1 | grep $Q "git.credential-osxkeychain"; then
  if [ "$(git config --global credential.helper)" != "osxkeychain" ]; then
    git config --global credential.helper osxkeychain
  fi

  if [ -n "$STRAP_GITHUB_USER" ] && [ -n "$STRAP_GITHUB_TOKEN" ]; then
    PROTOCOL="protocol=https\\nhost=github.com"
    printf "%s\\n" "$PROTOCOL" | git credential-osxkeychain erase
    printf "%s\\nusername=%s\\npassword=%s\\n" \
      "$PROTOCOL" "$STRAP_GITHUB_USER" "$STRAP_GITHUB_TOKEN" |
      git credential-osxkeychain store
  fi
fi
logk

# Setup Homebrew directory and permissions.
logn "Installing Homebrew:"

HOMEBREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
[ -n "$HOMEBREW_PREFIX" ] || HOMEBREW_PREFIX="/usr/local"
[ -d "$HOMEBREW_PREFIX" ] || sudo_askpass mkdir -p "$HOMEBREW_PREFIX"

if [ "$HOMEBREW_PREFIX" = "/usr/local" ]; then
  sudo_askpass chown "root:wheel" "$HOMEBREW_PREFIX" 2>/dev/null || true
fi
(
  cd "$HOMEBREW_PREFIX"
  sudo_askpass mkdir -p Cellar Frameworks bin etc include lib opt sbin share var
  sudo_askpass chown -R "$USER:admin" \
    Cellar Frameworks bin etc include lib opt sbin share var
)

HOMEBREW_REPOSITORY="$(brew --repository 2>/dev/null || true)"

[ -n "$HOMEBREW_REPOSITORY" ] || HOMEBREW_REPOSITORY="/usr/local/Homebrew"
[ -d "$HOMEBREW_REPOSITORY" ] || sudo_askpass mkdir -p "$HOMEBREW_REPOSITORY"
sudo_askpass chown -R "$USER:admin" "$HOMEBREW_REPOSITORY"

if [ $HOMEBREW_PREFIX != $HOMEBREW_REPOSITORY ]; then
  ln -sf "$HOMEBREW_REPOSITORY/bin/brew" "$HOMEBREW_PREFIX/bin/brew"
fi

# Download Homebrew.
export GIT_DIR="$HOMEBREW_REPOSITORY/.git" GIT_WORK_TREE="$HOMEBREW_REPOSITORY"
git init $Q
git config remote.origin.url "https://github.com/Homebrew/brew"
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch $Q --tags --force
git reset $Q --hard origin/master
unset GIT_DIR GIT_WORK_TREE
logk

# Update Homebrew.
export PATH="$HOMEBREW_PREFIX/bin:$PATH"
log "Updating Homebrew:"
brew update
logk

# Install Homebrew Bundle, Cask and Services tap.
log "Installing Homebrew taps and extensions:"
brew bundle --file=- <<RUBY
tap 'homebrew/cask'
tap 'homebrew/core'
tap 'homebrew/services'
RUBY
logk

# Check for and install any remaining software updates.
logn "Checking for software updates:"
if softwareupdate -l 2>&1 | grep $Q "No new software available."; then
  logk
else
  if [ $MACOS ] && [ -z "$STRAP_CI" ]; then
    echo
    log "Installing software updates:"
    sudo_askpass softwareupdate --install --all
    check_xcode_license
  else
    echo "Skipping software updates."
  fi
  logk
fi

# Set up dotfiles.
if [ -n "$STRAP_GITHUB_USER" ]; then
  DOTFILES_URL="https://github.com/$STRAP_GITHUB_USER/dotfiles"

  if git ls-remote "$DOTFILES_URL" &>/dev/null; then
    log "Fetching $STRAP_GITHUB_USER/dotfiles from GitHub:"
    if [ ! -d "$HOME/.dotfiles" ]; then
      log "Cloning to ~/.dotfiles:"
      git clone $Q "$DOTFILES_URL" ~/.dotfiles
    else
      (
        cd ~/.dotfiles
        git pull $Q --rebase --autostash
      )
    fi
    run_dotfile_scripts script/setup
    logk
  fi
fi

# Set up Brewfile.
BREW_DOT=".homebrew-brewfile/Brewfile"
if [ -n "$STRAP_GITHUB_USER" ] && {
  [ ! -f "$HOME/.Brewfile" ] || [ "$HOME/.Brewfile" -ef "$HOME/$BREW_DOT" ]
}; then
  BREW_REPO="https://github.com/$STRAP_GITHUB_USER/homebrew-brewfile"
  if git ls-remote "$BREW_REPO" &>/dev/null; then
    log "Fetching $STRAP_GITHUB_USER/homebrew-brewfile from GitHub:"
    if [ ! -d "$HOME/.homebrew-brewfile" ]; then
      log "Cloning to ~/.homebrew-brewfile:"
      git clone $Q "$BREW_REPO" ~/.homebrew-brewfile
      logk
    else
      (
        cd ~/.homebrew-brewfile
        git pull $Q
      )
    fi
    ln -sf ~/.homebrew-brewfile/Brewfile ~/.Brewfile
    logk
  fi
fi

# Install from local Brewfile
if [ -f "$HOME/.Brewfile" ]; then
  log "Installing from user Brewfile on GitHub:"
  brew bundle check --global || brew bundle --global
  logk
fi

# Tap a custom Homebrew tap
if [ -n "$CUSTOM_HOMEBREW_TAP" ]; then
  read -ra CUSTOM_HOMEBREW_TAP <<<"$CUSTOM_HOMEBREW_TAP"
  log "Running 'brew tap ${CUSTOM_HOMEBREW_TAP[*]}':"
  brew tap "${CUSTOM_HOMEBREW_TAP[@]}"
  logk
fi

if [ -n "$CUSTOM_BREW_COMMAND" ]; then
  log "Executing 'brew $CUSTOM_BREW_COMMAND':"
  # shellcheck disable=SC2086
  brew $CUSTOM_BREW_COMMAND
  logk
fi

run_dotfile_scripts script/strap-after-setup

STRAP_SUCCESS="1"
log "Your system is now bootstrapped!"