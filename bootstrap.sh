#!/usr/bin/env bash
### ------------ bootstrap.sh - set up development environment ------------ ###
# https://github.com/MikeMcQuaid/strap, https://github.com/Homebrew/install

set -e

OS=$(uname -s)
case $OS in
Darwin)
  export LINUX=0 MACOS=1 UNIX=1
  if [[ $(uname -m) == "arm64" ]]; then
    DEFAULT_HOMEBREW_PREFIX="/opt/homebrew"
  else
    DEFAULT_HOMEBREW_PREFIX="/usr/local"
  fi
  ;;
Linux)
  export LINUX=1 MACOS=0 UNIX=1
  if [[ -d $HOME/.linuxbrew ]]; then
    DEFAULT_HOMEBREW_PREFIX="$HOME/.linuxbrew"
  else
    DEFAULT_HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  fi
  [[ $(id -un) == "codespace" ]] && export CODESPACE=1
  ;;
*) echo "Unsupported operating system $OS" && exit 1 ;;
esac
[[ -z $HOMEBREW_PREFIX ]] && HOMEBREW_PREFIX="$DEFAULT_HOMEBREW_PREFIX"

STRAP_ADMIN=${STRAP_ADMIN:-0}
if groups | grep -qE "\b(admin)\b"; then STRAP_ADMIN=1; else STRAP_ADMIN=0; fi
export STRAP_ADMIN
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
STRAP_SUDO=0

sudo_askpass() {
  if [ -n "$SUDO_ASKPASS" ]; then
    sudo --askpass "$@"
  else
    sudo "$@"
  fi
}

cleanup() {
  set +e
  if [ -n "$SUDO_ASKPASS" ]; then
    sudo_askpass rm -rf "$CLT_PLACEHOLDER" "$SUDO_ASKPASS" "$SUDO_ASKPASS_DIR"
    sudo --reset-timestamp
  fi
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

clear_debug() {
  set +x
}

reset_debug() {
  if [ "$STRAP_DEBUG" -gt 0 ]; then
    set -x
  fi
}

abort() {
  STRAP_STEP=""
  echo "!!! $*" >&2
  exit 1
}

escape() {
  printf '%s' "${1//\'/\'}"
}

log_no_sudo() {
  STRAP_STEP="$*"
  echo "--> $*"
}

logk() {
  STRAP_STEP=""
  echo "OK"
}

logn_no_sudo() {
  STRAP_STEP="$*"
  printf -- "--> %s " "$*"
}

logskip() {
  STRAP_STEP=""
  echo "SKIPPED"
  echo "$*"
}

sudo_init() {
  if [ "$STRAP_INTERACTIVE" -eq 0 ]; then
    sudo -n -l mkdir &>/dev/null && export STRAP_SUDO=1
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
    STRAP_SUDO=1
    reset_debug
    export STRAP_SUDO SUDO_ASKPASS
  fi
  echo "STRAP_SUDO=$STRAP_SUDO"
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

# Given a list of scripts in the dotfiles repo, run the first one that exists
run_dotfile_scripts() {
  if [ -d "$HOME/.dotfiles" ]; then
    (
      cd "$HOME/.dotfiles"
      for i in "$@"; do
        if [ -f "$i" ] && [ -x "$i" ]; then
          log_no_sudo "Running dotfiles script $i:"
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

# shellcheck disable=SC2086
if [ "$MACOS" -gt 0 ] && [ "$STRAP_ADMIN" -gt 0 ]; then
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
if [ "$MACOS" -eq 0 ] || [ "$STRAP_ADMIN" -eq 0 ] || [ "$STRAP_CI" -gt 0 ]; then
  logskip "Skipping full-disk encryption."
elif [ "$MACOS" -gt 0 ] && [ "$STRAP_ADMIN" -gt 0 ]; then
  logn "Checking full-disk encryption status:"
  VAULT_MSG="FileVault is (On|Off, but will be enabled after the next restart)."
  # shellcheck disable=SC2086
  if fdesetup status | grep $Q -E "$VAULT_MSG"; then
    logk
  elif sudo_askpass fdesetup enable -user "$USER" |
    tee ~/Desktop/"FileVault Recovery Key.txt"; then
    log "Full-disk encryption will be enabled after next reboot:"
    logk
  else
    abort "Run 'sudo fdesetup enable -user \"$USER\"' for full-disk encryption."
  fi
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

# shellcheck disable=SC2086
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

check_software_updates() {
  logn "Checking for software updates:"
  # shellcheck disable=SC2086
  if softwareupdate -l 2>&1 | grep $Q "No new software available."; then
    logk
  else
    if [ "$MACOS" -gt 0 ] && [ "$STRAP_CI" -eq 0 ]; then
      echo
      log "Installing software updates:"
      sudo_askpass softwareupdate --install --all
      check_xcode_license
    else
      logskip "Skipping software updates."
    fi
    logk
  fi
}

if [ "$MACOS" -gt 0 ] && [ "$STRAP_ADMIN" -gt 0 ]; then
  install_xcode_clt
  check_xcode_license
  check_software_updates
else
  logskip "Xcode Command-Line Tools install and license check skipped."
fi

configure_git() {
  logn_no_sudo "Configuring Git:"
  # These calls to `git config` are needed for CI use cases in which certain
  # aspects of the `.gitconfig` cannot be used (like signing commits with SSH).
  # See commit c0542397e817fc1bd711984619eb73a6fdc937b2.
  # Permission denied errors may occur when Git attempts to read
  # [`$XDG_CONFIG_HOME/git/attributes`](https://git-scm.com/docs/gitattributes)
  # or [`$XDG_CONFIG_HOME/git/ignore`](https://git-scm.com/docs/gitignore).
  # These files may be located in `/home/runner/.config` on GitHub Actions
  # runners and inaccessible if a non-root user is running this script.
  if [ "$STRAP_CI" -gt 0 ]; then
    export XDG_CONFIG_HOME="$HOME/.config"
    mkdir -p "$XDG_CONFIG_HOME" && chmod -R 775 "$XDG_CONFIG_HOME"
    git config --global commit.gpgsign false
    git config --global gpg.format openpgp
    if ! git config --global core.attributesfile >/dev/null; then
      touch "$HOME/.gitattributes"
      git config --global core.attributesfile "$HOME/.gitattributes"
    fi
    if ! git config --global core.excludesfile >/dev/null; then
      touch "$HOME/.gitignore_global"
      git config --global core.excludesfile "$HOME/.gitignore_global"
    fi
  fi
  if [ -n "$STRAP_GIT_NAME" ] && ! git config --global user.name >/dev/null; then
    git config --global user.name "$STRAP_GIT_NAME"
  fi
  if [ -n "$STRAP_GIT_EMAIL" ] && ! git config --global user.email >/dev/null; then
    git config --global user.email "$STRAP_GIT_EMAIL"
  fi
  if [ -n "$STRAP_GITHUB_USER" ] &&
    [ "$(git config --global github.user)" != "$STRAP_GITHUB_USER" ]; then
    git config --global github.user "$STRAP_GITHUB_USER"
  fi
  # Set up GitHub HTTPS credentials
  # shellcheck disable=SC2086
  if [ -n "$STRAP_GITHUB_USER" ] && [ -n "$STRAP_GITHUB_TOKEN" ]; then
    PROTOCOL="protocol=https\\nhost=github.com"
    printf "%s\\n" "$PROTOCOL" | git credential reject
    printf "%s\\nusername=%s\\npassword=%s\\n" \
      "$PROTOCOL" "$STRAP_GITHUB_USER" "$STRAP_GITHUB_TOKEN" |
      git credential approve
  else
    logskip "Skipping Git credential setup."
  fi
  logk
}

# The first call to `configure_git` is needed for cloning the dotfiles repo.
configure_git

# Set up dotfiles
# shellcheck disable=SC2086
if [ ! -d "$HOME/.dotfiles" ]; then
  if [ -z "$STRAP_DOTFILES_URL" ] || [ -z "$STRAP_DOTFILES_BRANCH" ]; then
    abort "Please set STRAP_DOTFILES_URL and STRAP_DOTFILES_BRANCH."
  fi
  log_no_sudo "Cloning $STRAP_DOTFILES_URL to $HOME/.dotfiles."
  git clone $Q "$STRAP_DOTFILES_URL" "$HOME/.dotfiles"
fi
strap_dotfiles_branch_name="${STRAP_DOTFILES_BRANCH##*/}"
log_no_sudo "Checking out $strap_dotfiles_branch_name in $HOME/.dotfiles."
# shellcheck disable=SC2086
(
  cd "$HOME/.dotfiles"
  git stash
  git fetch $Q
  git checkout "$strap_dotfiles_branch_name"
  git pull $Q --rebase --autostash
)
run_dotfile_scripts scripts/symlink.sh
# The second call to `configure_git` is needed for CI use cases in which some
# aspects of the `.gitconfig` cannot be used after cloning the dotfiles repo.
configure_git
logk

# shellcheck disable=SC2086
install_homebrew() {
  logn "Installing Homebrew:"
  HOMEBREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
  [ -n "$HOMEBREW_PREFIX" ] || HOMEBREW_PREFIX="$DEFAULT_HOMEBREW_PREFIX"
  [ -d "$HOMEBREW_PREFIX" ] || sudo_askpass mkdir -p "$HOMEBREW_PREFIX"
  sudo_askpass chown -R "root:wheel" "$HOMEBREW_PREFIX" 2>/dev/null || true
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
  sudo_askpass chown -R "root:wheel" "$HOMEBREW_REPOSITORY" 2>/dev/null || true
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

set_up_brew_skips() {
  local brewfile_path casks ci_skips mas_ids mas_prefix
  log_no_sudo "Setting up Homebrew Bundle formula installs to skip."
  ci_skips="awscli black jupyterlab mkvtoolnix zsh-completions"
  [ "$STRAP_CI" -gt 0 ] && HOMEBREW_BUNDLE_BREW_SKIP="$ci_skips"
  if [ -f "$HOME/.Brewfile" ]; then
    brewfile_path="$HOME/.Brewfile"
  elif [ -f "Brewfile" ]; then
    brewfile_path="Brewfile"
  else
    abort "No Brewfile found"
  fi
  log_no_sudo "Setting up Homebrew Bundle cask installs to skip."
  if [ "$MACOS" -gt 0 ] && [ "$brewfile_path" == "$HOME/.Brewfile" ]; then
    casks="$(brew bundle list --global --cask --quiet | tr '\n' ' ')"
  elif [ "$MACOS" -gt 0 ] && [ "$brewfile_path" == "Brewfile" ]; then
    casks="$(brew bundle list --cask --quiet | tr '\n' ' ')"
  else
    log_no_sudo "Cask commands are only supported on macOS."
  fi
  HOMEBREW_BUNDLE_CASK_SKIP="${casks%% }"
  log_no_sudo "Setting up Homebrew Bundle Mac App Store (mas) installs to skip."
  mas_ids=""
  mas_prefix='*mas*, id: '
  while read -r brewfile_line; do
    # shellcheck disable=SC2295
    [[ $brewfile_line == *$mas_prefix* ]] && mas_ids+="${brewfile_line##$mas_prefix} "
  done <"$brewfile_path"
  HOMEBREW_BUNDLE_MAS_SKIP="${mas_ids%% }"
  log_no_sudo "HOMEBREW_BUNDLE_BREW_SKIP='$HOMEBREW_BUNDLE_BREW_SKIP'"
  log_no_sudo "HOMEBREW_BUNDLE_CASK_SKIP='$HOMEBREW_BUNDLE_CASK_SKIP'"
  log_no_sudo "HOMEBREW_BUNDLE_MAS_SKIP='$HOMEBREW_BUNDLE_MAS_SKIP'"
  export HOMEBREW_BUNDLE_BREW_SKIP="$HOMEBREW_BUNDLE_BREW_SKIP"
  export HOMEBREW_BUNDLE_CASK_SKIP="$HOMEBREW_BUNDLE_CASK_SKIP"
  export HOMEBREW_BUNDLE_MAS_SKIP="$HOMEBREW_BUNDLE_MAS_SKIP"
}

run_brew_installs() {
  local brewfile_domain brewfile_path brewfile_url git_branch github_user
  if ! type brew &>/dev/null; then
    log "brew command not in shell environment. Attempting to load."
    eval "$("$HOMEBREW_PREFIX"/bin/brew shellenv)"
    type brew &>/dev/null && logk || return 1
  fi
  # Disable Homebrew Analytics: https://docs.brew.sh/Analytics
  brew analytics off
  [ "$STRAP_CI" -gt 0 ] || [ "$LINUX" -gt 0 ] && set_up_brew_skips
  [ "$LINUX" -gt 0 ] && brew install gcc # "We recommend that you install GCC"
  log "Running Homebrew installs."
  if [ -f "$HOME/.Brewfile" ]; then
    log "Installing from $HOME/.Brewfile with Brew Bundle."
    brew bundle check --global || brew bundle --global
    logk
  elif [ -f "Brewfile" ]; then
    log "Installing from local Brewfile with Brew Bundle."
    brew bundle check || brew bundle
    logk
  else
    [ -z "$STRAP_DOTFILES_BRANCH" ] && STRAP_DOTFILES_BRANCH=HEAD
    git_branch="${STRAP_DOTFILES_BRANCH##*/}"
    github_user="${STRAP_GITHUB_USER:-br3ndonland}"
    brewfile_domain="https://raw.githubusercontent.com"
    brewfile_path="$github_user/dotfiles/$git_branch/Brewfile"
    brewfile_url="$brewfile_domain/$brewfile_path"
    log "Installing from $brewfile_url with Brew Bundle."
    curl -fsSL "$brewfile_url" | brew bundle --file=-
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

# Install Homebrew
# https://docs.brew.sh/Installation
# https://docs.brew.sh/Homebrew-on-Linux
# Homebrew installs require `sudo`, but not necessarily admin
# https://docs.brew.sh/FAQ#why-does-homebrew-say-sudo-is-bad
# https://github.com/Homebrew/install/issues/312
# https://github.com/Homebrew/install/pull/315/files
if [ "$STRAP_SUDO" -eq 0 ]; then
  sudo_init || logskip "Skipping Homebrew installation (requires sudo)."
fi
if [ "$STRAP_SUDO" -gt 0 ]; then
  # Prevent "Permission denied" errors on Homebrew directories
  log "Updating permissions on Homebrew directories"
  sudo_askpass mkdir -p "$HOMEBREW_PREFIX/"{Caskroom,Cellar,Frameworks}
  sudo_askpass chmod -R 775 "$HOMEBREW_PREFIX/"{Caskroom,Cellar,Frameworks}
  sudo_askpass chown -R "$USER" "$HOMEBREW_PREFIX" 2>/dev/null || true
  logk
  if [ "$MACOS" -gt 0 ]; then
    log "Installing Homebrew on macOS"
    script_url="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
    NONINTERACTIVE=$STRAP_CI \
      /usr/bin/env bash -c "$(curl -fsSL $script_url)" || install_homebrew
    logk
  elif [ "$LINUX" -gt 0 ]; then
    # https://docs.brew.sh/Homebrew-on-Linux
    log "Installing Homebrew on Linux"
    run_dotfile_scripts scripts/linuxbrew.sh
    logk
  else
    abort "Unsupported operating system $OS"
  fi
  run_brew_installs || abort "Homebrew installs were not successful."
  brew cleanup
fi

run_dotfile_scripts scripts/strap-after-setup.sh

STRAP_SUCCESS=1
log_no_sudo "Your system is now bootstrapped!"
