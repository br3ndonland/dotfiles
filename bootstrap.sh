#!/usr/bin/env bash
### ------------ bootstrap.sh - set up development environment ------------ ###
# https://github.com/MikeMcQuaid/strap, https://github.com/Homebrew/install

set -e

case $(uname -s) in
Darwin)
  export LINUX=0 && export MACOS=1 && export UNIX=1
  if [[ $(uname -m) == "arm64" ]]; then
    DEFAULT_HOMEBREW_PREFIX="/opt/homebrew"
  else
    DEFAULT_HOMEBREW_PREFIX="/usr/local"
  fi
  ;;
Linux) export LINUX=1 && export MACOS=0 && export UNIX=1 ;;
codespace) export CODESPACE=1 ;;
esac

STRAP_CI=${STRAP_CI:=0}
STRAP_DEBUG=${STRAP_DEBUG:-0}
[[ $1 = "--debug" || -o xtrace ]] && STRAP_DEBUG=1
STRAP_INTERACTIVE=${STRAP_INTERACTIVE:-0}
STDIN_FILE_DESCRIPTOR=0
[ -t "$STDIN_FILE_DESCRIPTOR" ] && STRAP_INTERACTIVE=1
STRAP_GIT_NAME=${STRAP_GIT_NAME:?Variable not set}
STRAP_GIT_EMAIL=${STRAP_GIT_EMAIL:?Variable not set}
STRAP_GITHUB_USER=${STRAP_GITHUB_USER:="br3ndonland"}
DEFAULT_DOTFILES_URL="https://github.com/$STRAP_GITHUB_USER/dotfiles"
STRAP_DOTFILES_URL=${STRAP_DOTFILES_URL:="$DEFAULT_DOTFILES_URL"}
STRAP_DOTFILES_BRANCH=${STRAP_DOTFILES_BRANCH:="main"}
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
    if [ "$STRAP_DEBUG" -eq 0 ]; then
      echo "!!! Run '$0 --debug' for debugging output." >&2
    fi
  fi
}
trap "cleanup" EXIT

if [ "$STRAP_DEBUG" -gt 0 ]; then
  set -x
else
  STRAP_QUIET_FLAG="-q"
  Q="$STRAP_QUIET_FLAG"
fi

# Prompt for sudo password and initialize (or reinitialize) sudo
sudo --reset-timestamp

clear_debug() {
  set +x
}
reset_debug() {
  if [ "$STRAP_DEBUG" -gt 0 ]; then
    set -x
  fi
}

sudo_init() {
  if [ "$STRAP_INTERACTIVE" -eq 0 ]; then
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
      cat <<-BASH
				#!/usr/bin/env bash
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

# Given a list of scripts in the dotfiles repo, run the first one that exists
run_dotfile_scripts() {
  if [ -d ~/.dotfiles ]; then
    (
      cd ~/.dotfiles
      for i in "$@"; do
        if [ -f "$i" ] && [ -x "$i" ]; then
          log "Running dotfiles $i:"
          if [ "$STRAP_DEBUG" -eq 0 ]; then
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

[ "$USER" = "root" ] && abort "Run bootstrap.sh as yourself, not root."

if [ "$MACOS" -gt 0 ]; then
  [ "$STRAP_CI" -eq 0 ] && caffeinate -s -w $$ &
  groups | grep $Q -E "\b(admin)\b" || abort "Add $USER to admin."
  logn "Configuring security settings:"
  SAFARI="com.apple.Safari"
  sudo_askpass defaults write $SAFARI \
    $SAFARI.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
  sudo_askpass defaults write $SAFARI \
    $SAFARI.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles \
    -bool false
  sudo_askpass defaults write com.apple.screensaver askForPassword -int 1
  sudo_askpass defaults write com.apple.screensaver askForPasswordDelay -int 0
  sudo_askpass defaults write \
    /Library/Preferences/com.apple.alf globalstate -int 1
  sudo_askpass launchctl load \
    /System/Library/LaunchDaemons/com.apple.alf.agent.plist 2>/dev/null
  if [ -n "$STRAP_GIT_NAME" ] && [ -n "$STRAP_GIT_EMAIL" ]; then
    FOUND="Found this computer? Please contact"
    LOGIN_TEXT=$(escape "$FOUND $STRAP_GIT_NAME at $STRAP_GIT_EMAIL.")
    echo "$LOGIN_TEXT" | grep -q '[()]' && LOGIN_TEXT="'$LOGIN_TEXT'"
    sudo_askpass defaults write \
      /Library/Preferences/com.apple.loginwindow LoginwindowText "$LOGIN_TEXT"
    logk
  fi
fi

# Check for and enable full-disk encryption
logn "Checking full-disk encryption status:"
VAULT_MSG="FileVault is (On|Off, but will be enabled after the next restart)."
if fdesetup status | grep $Q -E "$VAULT_MSG"; then
  logk
elif [ "$MACOS" -eq 0 ] || [ "$STRAP_CI" -gt 0 ]; then
  echo
  logn "Skipping full-disk encryption."
elif [ "$STRAP_INTERACTIVE" -gt 0 ]; then
  echo
  log "Enabling full-disk encryption on next reboot:"
  sudo_askpass fdesetup enable -user "$USER" |
    tee ~/Desktop/"FileVault Recovery Key.txt"
  logk
else
  echo
  abort "Run 'sudo fdesetup enable -user \"$USER\"' for full-disk encryption."
fi

# Set up Xcode Command Line Tools
install_xcode_clt() {
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
      if [ "$STRAP_INTERACTIVE" -gt 0 ]; then
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
    if [ "$STRAP_INTERACTIVE" -gt 0 ]; then
      logn "Asking for Xcode license confirmation:"
      sudo_askpass xcodebuild -license
      logk
    else
      abort "Run 'sudo xcodebuild -license' to agree to the Xcode license."
    fi
  fi
}

if [ "$MACOS" -gt 0 ]; then
  install_xcode_clt
  check_xcode_license
else
  log "Not macOS. Xcode CLT install and license check skipped."
fi

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

# Set up GitHub HTTPS credentials
if git credential-osxkeychain 2>&1 | grep $Q "git.credential-osxkeychain"; then
  # Execute credential in case it's a wrapper script for credential-osxkeychain
  if git "credential-$(git config --global credential.helper 2>/dev/null)" 2>&1 |
    grep -v $Q "git.credential-osxkeychain"; then
    git config --global credential.helper osxkeychain
  fi
  if [ -n "$STRAP_GITHUB_USER" ] && [ -n "$STRAP_GITHUB_TOKEN" ]; then
    PROTOCOL="protocol=https\\nhost=github.com"
    printf "%s\\n" "$PROTOCOL" | git credential reject
    printf "%s\\nusername=%s\\npassword=%s\\n" \
      "$PROTOCOL" "$STRAP_GITHUB_USER" "$STRAP_GITHUB_TOKEN" |
      git credential approve
  else
    log "Skipping Git credential setup."
  fi
  logk
fi

# Check for and install any remaining software updates
logn "Checking for software updates:"
if softwareupdate -l 2>&1 | grep $Q "No new software available."; then
  logk
else
  if [ "$MACOS" -gt 0 ] && [ "$STRAP_CI" -eq 0 ]; then
    echo
    log "Installing software updates:"
    sudo_askpass softwareupdate --install --all
    check_xcode_license
  else
    log "Skipping software updates."
  fi
  logk
fi

# Set up dotfiles
if [ -n "$STRAP_DOTFILES_URL" ] && [ -n "$STRAP_DOTFILES_BRANCH" ]; then
  log "Fetching $STRAP_DOTFILES_URL:"
  if [ ! -d "$HOME/.dotfiles" ]; then
    log "Cloning to ~/.dotfiles and checking out $STRAP_DOTFILES_BRANCH."
    git clone $Q "$STRAP_DOTFILES_URL" \
      --branch "$STRAP_DOTFILES_BRANCH" ~/.dotfiles
  else
    log "Checking out $STRAP_DOTFILES_BRANCH in ~/.dotfiles."
    (
      cd ~/.dotfiles
      git stash
      git checkout "$STRAP_DOTFILES_BRANCH"
      git pull $Q --rebase --autostash
    )
  fi
  run_dotfile_scripts script/symlink.sh
  logk
fi

install_homebrew() {
  logn "Installing Homebrew:"
  HOMEBREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
  [ -n "$HOMEBREW_PREFIX" ] || HOMEBREW_PREFIX="$DEFAULT_HOMEBREW_PREFIX"
  [ -d "$HOMEBREW_PREFIX" ] || sudo_askpass mkdir -p "$HOMEBREW_PREFIX"
  sudo_askpass chown "root:wheel" "$HOMEBREW_PREFIX" 2>/dev/null || true
  (
    cd "$HOMEBREW_PREFIX"
    sudo_askpass mkdir -p \
      Cellar Caskroom Frameworks bin etc include lib opt sbin share var
    sudo_askpass chown "$USER:admin" \
      Cellar Caskroom Frameworks bin etc include lib opt sbin share var
  )
  HOMEBREW_REPOSITORY="$(brew --repository 2>/dev/null || true)"
  [ -n "$HOMEBREW_REPOSITORY" ] || HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew"
  [ -d "$HOMEBREW_REPOSITORY" ] || sudo_askpass mkdir -p "$HOMEBREW_REPOSITORY"
  sudo_askpass chown -R "$USER:admin" "$HOMEBREW_REPOSITORY"
  if [ "$HOMEBREW_PREFIX" != "$HOMEBREW_REPOSITORY" ]; then
    ln -sf "$HOMEBREW_REPOSITORY/bin/brew" "$HOMEBREW_PREFIX/bin/brew"
  fi
  export GIT_DIR="$HOMEBREW_REPOSITORY/.git" GIT_WORK_TREE="$HOMEBREW_REPOSITORY"
  git init $Q
  git config remote.origin.url "https://github.com/Homebrew/brew"
  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  git fetch $Q --tags --force
  git reset $Q --hard origin/HEAD
  unset GIT_DIR GIT_WORK_TREE
  logk
  export PATH="$HOMEBREW_PREFIX/bin:$PATH"
  logn "Updating Homebrew:"
  brew update
  logk
}

run_brew_installs() {
  if ! command -v brew &>/dev/null; then
    log "brew command not in shell environment. Attempting to load."
    eval "$($DEFAULT_HOMEBREW_PREFIX/bin/brew shellenv)"
    command -v brew &>/dev/null && logk || return 1
  fi
  if [ "$STRAP_CI" -gt 0 ]; then
    log "Setting up Homebrew Cask and Mac App Store installs to skip in CI."
    casks="$(brew bundle list --cask --quiet | tr '\n' ' ')"
    mas_ids=""
    prefix='*mas*, id: '
    while read -r brewfile_line; do
      # shellcheck disable=SC2295
      [[ $brewfile_line == *$prefix* ]] && mas_ids+="${brewfile_line##$prefix} "
    done <"Brewfile"
    export HOMEBREW_BUNDLE_CASK_SKIP="${casks%% }"
    export HOMEBREW_BUNDLE_MAS_SKIP="${mas_ids%% }"
  fi
  log "Running Homebrew installs."
  # Install from local Brewfile
  if [ -f "$HOME/.Brewfile" ]; then
    log "Installing from user Brewfile:"
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
  # Run a custom Brew command
  if [ -n "$CUSTOM_BREW_COMMAND" ]; then
    log "Executing 'brew $CUSTOM_BREW_COMMAND':"
    # shellcheck disable=SC2086
    brew $CUSTOM_BREW_COMMAND
    logk
  fi
}

if [ "$MACOS" -gt 0 ]; then
  RAW="https://raw.githubusercontent.com"
  BREW_SCRIPT="Homebrew/install/HEAD/install.sh"
  /usr/bin/env bash -c "$(curl -fsSL $RAW/$BREW_SCRIPT)" || install_homebrew
  run_brew_installs || abort "Unable to load Homebrew."
elif [ "$LINUX" -gt 0 ]; then
  run_dotfile_scripts script/linuxbrew.sh
else
  log "Skipping Homebrew installs."
fi

run_dotfile_scripts script/strap-after-setup

STRAP_SUCCESS=1
log "Your system is now bootstrapped!"
