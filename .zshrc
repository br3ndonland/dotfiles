#!/usr/bin/env zsh
### Zsh configuration
# usage: ln -fns $(pwd)/.zshrc ~/.zshrc

### options
# initial setup configured by zsh-newuser-install
# To re-run setup: autoload -U zsh-newuser-install; zsh-newuser-install -f
# See man zshoptions or https://zsh.sourceforge.net/Doc/Release/Options.html
HISTFILE=~/.zsh_history
HISTSIZE=10000
setopt autocd extendedglob globdots histignorespace noautomenu nullglob

### keybindings: based on https://github.com/romkatv/zsh4humans
bindkey -e
bindkey -s '^[[1~' '^[[H'
bindkey -s '^[[4~' '^[[F'
bindkey -s '^[[5~' ''
bindkey -s '^[[6~' ''
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^?' backward-delete-char
bindkey '^[[3~' delete-char
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word
bindkey '^H' backward-kill-word
bindkey '^[[3;3~' kill-word
bindkey '^N' kill-buffer

### homebrew
if [[ -z $HOMEBREW_PREFIX ]]; then
  case $(uname) in
  Darwin)
    if [[ $(uname -m) == 'arm64' ]]; then
      HOMEBREW_PREFIX='/opt/homebrew'
    elif [[ $(uname -m) == 'x86_64' ]]; then
      HOMEBREW_PREFIX='/usr/local'
    fi
    ;;
  Linux)
    if [[ -d '/home/linuxbrew/.linuxbrew' ]]; then
      HOMEBREW_PREFIX='/home/linuxbrew/.linuxbrew'
    elif [[ -d $HOME/.linuxbrew ]]; then
      HOMEBREW_PREFIX=$HOME/.linuxbrew
    fi
    if [[ -d $HOMEBREW_PREFIX ]]; then
      PATH=$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH
    fi
    ;;
  esac
fi
if [[ -d $HOMEBREW_PREFIX ]]; then
  eval $($HOMEBREW_PREFIX/bin/brew shellenv)
fi

### exports
if type codium &>/dev/null; then
  editor='codium --wait'
elif type cursor &>/dev/null; then
  editor='cursor --wait'
elif type code &>/dev/null; then
  editor='code --wait'
elif type code-insiders &>/dev/null; then
  editor='code-insiders --wait'
elif type code-exploration &>/dev/null; then
  editor='code-exploration --wait'
else
  editor='vim'
fi
TTY=$(tty)
CURL_BIN_DIR=$HOMEBREW_PREFIX/opt/curl/bin
CURL_CPPFLAGS=-I$HOMEBREW_PREFIX/opt/curl/include
CURL_LDFLAGS=-L$HOMEBREW_PREFIX/opt/curl/lib
CURL_PKG_CONFIG_PATH=$HOMEBREW_PREFIX/opt/curl/lib/pkgconfig
GNU_AWK_BIN_DIR=$HOMEBREW_PREFIX/opt/gawk/libexec/gnubin
GNU_COREUTILS_BIN_DIR=$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin
GNU_FINDUTILS_BIN_DIR=$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin
GNU_GREP_BIN_DIR=$HOMEBREW_PREFIX/opt/grep/libexec/gnubin
GNU_SED_BIN_DIR=$HOMEBREW_PREFIX/opt/gsed/libexec/gnubin
GNU_TAR_BIN_DIR=$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin
LOCAL_BIN_DIR=$HOME/.local/bin
RUST_CARGO_BIN_DIR=$HOME/.cargo/bin
path_array=(
  $CURL_BIN_DIR
  $GNU_AWK_BIN_DIR
  $GNU_COREUTILS_BIN_DIR
  $GNU_FINDUTILS_BIN_DIR
  $GNU_GREP_BIN_DIR
  $GNU_SED_BIN_DIR
  $GNU_TAR_BIN_DIR
  $LOCAL_BIN_DIR
  $RUST_CARGO_BIN_DIR
  $PATH
)
export \
  CPPFLAGS=$CURL_CPPFLAGS \
  EDITOR=$editor \
  GIT_EDITOR=$editor \
  GPG_TTY=$TTY \
  HOMEBREW_NO_ANALYTICS=1 \
  LDFLAGS=$CURL_LDFLAGS \
  PATH=${(j.:.)path_array} \
  PIPX_BIN_DIR=$LOCAL_BIN_DIR \
  PKG_CONFIG_PATH=$CURL_PKG_CONFIG_PATH

### aliases
alias python='python3'
alias tg='terragrunt'

### prompt: https://starship.rs
source <(starship init zsh)

### mise: https://mise.jdx.dev/
source <(mise activate zsh)

### functions
# ensure .zfunc is symlinked to $HOME/.zfunc
typeset -U fpath
fpath+=($HOME/.zfunc)
autoload -Uz $HOME/.zfunc/*(:tX)

### completions
if type brew &>/dev/null && [[ -d $HOMEBREW_PREFIX ]]; then
  fpath+=($HOMEBREW_PREFIX/share/zsh/site-functions)
fi
zstyle :compinstall filename $HOME/.zshrc
autoload -Uz compinit
compinit

### syntax highlighting
if [[ -d $HOMEBREW_PREFIX/share/zsh-syntax-highlighting ]]; then
  . $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -d $HOME/.zsh/zsh-syntax-highlighting ]]; then
  . $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
