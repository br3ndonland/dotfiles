#!/usr/bin/env zsh
# shellcheck shell=bash

### exports
if command -v code >/dev/null 2>&1; then
  export EDITOR="code --wait"
elif command -v code-insiders >/dev/null 2>&1; then
  export EDITOR="code-insiders --wait"
else
  export EDITOR="vim"
fi
if [ "$(uname)" = "Linux" ]; then
  export GPG_TTY=$TTY
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
export PATH="/usr/local/sbin:$HOME/.poetry/bin:$PATH"
export SSH_KEY_PATH=$HOME/.ssh/id_rsa_$USER

### aliases
alias dc="docker-compose"
alias python="python3"

### history file configuration - based on ohmyzsh history.zsh
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history

### key bindings - based on https://github.com/romkatv/zsh4humans
# enable emacs keymap
bindkey -e
# TTY sends different key codes. Translate them to regular.
bindkey -s '^[[1~' '^[[H' # home
bindkey -s '^[[4~' '^[[F' # end
# Do nothing on pageup and pagedown. Better than printing '~'.
bindkey -s '^[[5~' ''
bindkey -s '^[[6~' ''
bindkey '^[[H' beginning-of-line  # home       go to the beginning of line
bindkey '^[[F' end-of-line        # end        go to the end of line
bindkey '^?' backward-delete-char # bs         delete one char backward
bindkey '^[[3~' delete-char       # delete     delete one char forward
bindkey '^[[1;3C' forward-word    # alt+right  go forward one word
bindkey '^[[1;3D' backward-word   # alt+left   go backward one word
bindkey '^H' backward-kill-word   # alt+bs     delete previous word
bindkey '^[[3;3~' kill-word       # alt+del    delete next word
bindkey '^N' kill-buffer          # ctrl+n     delete all lines

### pure prompt: https://github.com/sindresorhus/pure
FPATH+=$HOME/.zsh/pure
autoload -U promptinit
promptinit
prompt pure

### completions and integrations
if type brew &>/dev/null; then
  FPATH+=$HOME/.zfunc:"$(brew --prefix)"/share/zsh-completions
  autoload -Uz compinit
  if [ "$(whoami)" = "brendon.smith" ]; then
    compinit -i # Ignore insecure directories (perms issues for non-admin user)
  else
    compinit
  fi
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C "$(brew --prefix)"/bin/terraform terraform
fi
# if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init -)"; fi
# if which pyenv-virtualenv-init >/dev/null; then
#   eval "$(pyenv virtualenv-init -)"
# fi
# shellcheck disable=SC1090
. "$(brew --prefix)"/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
