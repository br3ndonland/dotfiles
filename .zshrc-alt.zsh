#!/usr/bin/env zsh
# shellcheck shell=bash
### -------------------- Alternative Zsh configuration -------------------- ###
# To use: ln -fns .zshrc-alt.zsh ~/.zshrc

### Initial setup configured by zsh-newuser-install
# To re-run setup: autoload -U zsh-newuser-install; zsh-newuser-install -f
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=50000
setopt autocd extendedglob nomatch

### Keybindings: based on https://github.com/romkatv/zsh4humans
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

### Exports
if command -v code >/dev/null 2>&1; then
  export EDITOR="code --wait"
elif command -v code-insiders >/dev/null 2>&1; then
  export EDITOR="code-insiders --wait"
else
  export EDITOR="vim"
fi
export GPG_TTY=$(tty)
export PATH=$HOME/.poetry/bin:$PATH
export SSH_KEY_PATH=$HOME/.ssh/id_rsa_$USER
if [ "$(uname)" = "Linux" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

### Aliases
alias python="python3"

### Prompt: https://github.com/sindresorhus/pure
if [ -d $HOME/.zsh/pure ]; then
  fpath+=$HOME/.zsh/pure
  autoload -U promptinit
  promptinit
  prompt pure
fi

### Completions
if type brew &>/dev/null; then
  fpath+=$HOME/.zfunc:"$(brew --prefix)"/share/zsh-completions
  autoload -Uz compinit
  if [ "$(whoami)" = "brendon.smith" ]; then
    compinit -i # Ignore insecure directories (perms issues for non-admin user)
  else
    compinit
  fi
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C "$(brew --prefix)"/bin/terraform terraform
  # shellcheck disable=SC1090
  . "$(brew --prefix)"/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  zstyle :compinstall filename '~/.zshrc'
  autoload -Uz compinit
  compinit
fi
