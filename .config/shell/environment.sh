#!/usr/bin/env sh
# Shared shell environment for Bash and Zsh.

if [ -n "${DOTFILES_SHELL_ENV_LOADED:-}" ]; then
  # shellcheck disable=SC2317
  return 0 2>/dev/null || exit 0
fi
DOTFILES_SHELL_ENV_LOADED=1

dotfiles_path_prepend() {
  [ -n "${1:-}" ] || return 0
  [ -d "$1" ] || return 0
  case ":${PATH:-}:" in
  *":$1:"*) ;;
  *) PATH=$1${PATH:+:$PATH} ;;
  esac
}

dotfiles_select_editor() {
  for dotfiles_editor in codium code code-insiders code-exploration; do
    if command -v "$dotfiles_editor" >/dev/null 2>&1; then
      printf '%s --wait' "$dotfiles_editor"
      return 0
    fi
  done
  printf '%s' "vim"
}

if [ -z "${HOMEBREW_PREFIX:-}" ]; then
  case "$(uname -s)" in
  Darwin)
    case "$(uname -m)" in
    arm64) HOMEBREW_PREFIX=/opt/homebrew ;;
    x86_64) HOMEBREW_PREFIX=/usr/local ;;
    esac
    ;;
  Linux)
    if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
      HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew
    elif [ -x "$HOME/.linuxbrew/bin/brew" ]; then
      HOMEBREW_PREFIX=$HOME/.linuxbrew
    elif [ -d /home/linuxbrew/.linuxbrew ]; then
      HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew
    elif [ -d "$HOME/.linuxbrew" ]; then
      HOMEBREW_PREFIX=$HOME/.linuxbrew
    fi
    ;;
  esac
fi

if [ -n "${HOMEBREW_PREFIX:-}" ]; then
  dotfiles_path_prepend "$HOMEBREW_PREFIX/bin"
  dotfiles_path_prepend "$HOMEBREW_PREFIX/sbin"
  if [ -x "$HOMEBREW_PREFIX/bin/brew" ]; then
    eval "$("$HOMEBREW_PREFIX/bin/brew" shellenv)"
  fi
fi

dotfiles_editor="$(dotfiles_select_editor)"
dotfiles_path_prepend "$HOME/.lmstudio/bin"
dotfiles_path_prepend "$HOME/.local/bin"
dotfiles_path_prepend "$HOME/.cargo/bin"
export ASTRO_TELEMETRY_DISABLED=1
export DISABLE_TELEMETRY=1
export EDITOR="$dotfiles_editor"
export GIT_EDITOR="$dotfiles_editor"
export GITHUB_TOOLSETS="default,actions,dependabot,discussions,gists,git,github_support_docs_search,labels,security_advisories"
export HATCH_ENV_TYPE_VIRTUAL_PATH=.venv
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_PREFIX
export PATH
export PIPX_BIN_DIR="$HOME/.local/bin"
export VERCEL_TELEMETRY_DISABLED=1
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

if [ -n "${HOMEBREW_PREFIX:-}" ]; then
  # curl
  export CPPFLAGS="${CPPFLAGS:+$CPPFLAGS }-I$HOMEBREW_PREFIX/opt/curl/include"
  export LDFLAGS="${LDFLAGS:+$LDFLAGS }-L$HOMEBREW_PREFIX/opt/curl/lib"
  export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/curl/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
  dotfiles_path_prepend "$HOMEBREW_PREFIX/opt/curl/bin"
  # GNU
  dotfiles_path_prepend "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
  dotfiles_path_prepend "$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin"
  dotfiles_path_prepend "$HOMEBREW_PREFIX/opt/gawk/libexec/gnubin"
  dotfiles_path_prepend "$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin"
  dotfiles_path_prepend "$HOMEBREW_PREFIX/opt/grep/libexec/gnubin"
  dotfiles_path_prepend "$HOMEBREW_PREFIX/opt/gsed/libexec/gnubin"
fi

if tty >/dev/null 2>&1; then
  GPG_TTY="$(tty)"
  export GPG_TTY
fi

unset dotfiles_editor
