#!/usr/bin/env zsh
### Zsh configuration
# usage: ln -fns $(pwd)/.zshrc ~/.zshrc

### options
# initial setup configured by zsh-newuser-install
# To re-run setup: autoload -U zsh-newuser-install; zsh-newuser-install -f
# See man zshoptions or http://zsh.sourceforge.net/Doc/Release/Options.html
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
if command -v codium &>/dev/null; then
  editor='codium --wait'
elif command -v code &>/dev/null; then
  editor='code --wait'
elif command -v code-insiders &>/dev/null; then
  editor='code-insiders --wait'
elif command -v code-exploration &>/dev/null; then
  editor='code-exploration --wait'
else
  editor='vim'
fi
TTY=$(tty)
GNU_FINDUTILS_BIN_DIR=$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin
GNU_GREP_BIN_DIR=$HOMEBREW_PREFIX/opt/grep/libexec/gnubin
GNU_SED_BIN_DIR=$HOMEBREW_PREFIX/opt/gsed/libexec/gnubin
GNU_TAR_BIN_DIR=$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin
PIPX_BIN_DIR=$HOME/.local/bin
RUST_CARGO_BIN_DIR=$HOME/.cargo/bin
export \
  EDITOR=$editor \
  GIT_EDITOR=$editor \
  GPG_TTY=$TTY \
  HOMEBREW_NO_ANALYTICS=1 \
  PATH=$PIPX_BIN_DIR:$RUST_CARGO_BIN_DIR:$GNU_FINDUTILS_BIN_DIR:$GNU_GREP_BIN_DIR:$GNU_SED_BIN_DIR:$GNU_TAR_BIN_DIR:$PATH \
  PIPX_BIN_DIR=$PIPX_BIN_DIR

### aliases
alias python='python3'

### prompt: https://starship.rs
source <(starship init zsh)

### completions
if type brew &>/dev/null && [[ -d $HOMEBREW_PREFIX ]]; then
  fpath+=$HOME/.zfunc:$HOMEBREW_PREFIX/share/zsh/site-functions
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
