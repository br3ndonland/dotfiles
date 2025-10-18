#!/usr/bin/env zsh
### Zsh configuration for non-interactive shells
# in interactive shells, both `~/.zprofile` and `~/.zshrc` are loaded.
# to avoid activating tools twice, a conditional can be used that checks the
# `$-` special parameter. `$-` will contain `i` if the shell is interactive.
# https://zsh.sourceforge.io/Doc/Release/Files.html
# https://zsh.sourceforge.io/Doc/Release/Parameters.html

if [[ $- != *i* ]]; then
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
  source <(mise activate zsh --shims)
fi
