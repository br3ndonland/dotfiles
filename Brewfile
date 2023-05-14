cask_args appdir: "/Applications", require_sha: true
tap "homebrew/bundle"
tap "homebrew/cask"
tap "homebrew/cask-versions"
tap "homebrew/core"
tap "homebrew/services"

brew "awscli"
brew "bash"
brew "black", restart_service: :changed
brew "ffmpeg"
brew "findutils"
brew "flake8"
brew "gh"
brew "git"
brew "git-lfs"
brew "gnupg"
brew "gnu-sed"
brew "gnu-tar"
brew "go"
brew "grep"
# brew "helm"
brew "httpie"
brew "jq"
brew "jupyterlab"
brew "libfido2"
brew "macos-trash" if OS.mac?
brew "mas" if OS.mac?
brew "media-info"
brew "mkvtoolnix"
brew "mp4v2"
brew "mypy"
# brew "mysql-client"
brew "node"
brew "openssh"
brew "pinentry"
# brew "pinentry-mac"
brew "pipx"
brew "pnpm"
brew "postgresql@15", restart_service: :changed
brew "pre-commit"
brew "prettier"
brew "python"
brew "r"
brew "rust"
brew "shellcheck"
brew "shfmt"
brew "starship"
brew "terraform"
# brew "terraformer"
brew "typescript"
brew "wrangler"
brew "ykman"
brew "zsh"
brew "zsh-completions"
brew "zsh-syntax-highlighting"

cask "1password"
cask "brave-browser"
# cask "datagrip"
cask "docker"
cask "firefox"
cask "handbrake",
  args: {
    appdir: "/Users/nonadmin/Applications"
  },
  binaries: false if system "command -v dscl &>/dev/null && dscl . list /Users | grep -q 'nonadmin'"
# cask "inkscape"
cask "karabiner-elements"
cask "kitty"
cask "makemkv",
  args: {
    appdir: "/Users/nonadmin/Applications"
  },
  binaries: false if system "command -v dscl &>/dev/null && dscl . list /Users | grep -q 'nonadmin'"
cask "plex-media-server"
# cask "postico"
# cask "postman"
cask "protonvpn"
# cask "rstudio"
# cask "session-manager-plugin"
cask "transmission"
# cask "visual-studio-code"
cask "vlc"
cask "vscodium"
cask "zotero" # no arm64_big_sur yet

# mas "1password", id: 1333542190
mas "bear", id: 1091189122
mas "cascadea", id: 1432182561
mas "daisydisk", id: 411643860
mas "duckduckgo privacy essentials", id: 1482920575
mas "keynote", id: 409183694
mas "numbers", id: 409203825
mas "pages", id: 409201541
mas "pdf expert", id: 1055273043
