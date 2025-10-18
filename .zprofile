#!/usr/bin/env zsh
### Zsh configuration for non-interactive shells
# https://zsh.sourceforge.io/Doc/Release/Files.html

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

### mise: https://mise.jdx.dev/dev-tools/shims.html
if [[ $- != *i* ]]; then source <(mise activate zsh --shims); fi
