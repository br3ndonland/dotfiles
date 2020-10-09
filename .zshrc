#!/bin/zsh
### ------------------------------- exports ------------------------------- ###
export EDITOR="code --wait"
export PATH="/usr/local/sbin:$HOME/.poetry/bin:$PATH"
export SSH_KEY_PATH="$HOME/.ssh/id_rsa_${USER}"
### ------------------------------- aliases ------------------------------- ###
alias dc="docker-compose"
alias python="/usr/local/bin/python3"
### ------ history file configuration - based on ohmyzsh history.zsh ------ ###
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first if HISTFILE > HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history before running
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data
### ---- key bindings - based on https://github.com/romkatv/zsh4humans ---- ###
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
bindkey '^H' backward-kill-word   # alt+bs    delete previous word
bindkey '^[[3;3~' kill-word       # alt+del    delete next word
bindkey '^N' kill-buffer          # ctrl+n     delete all lines
bindkey '^_' undo                 # ctrl+/     undo
bindkey '^\' redo                 # ctrl+\     redo
### ---------- pure prompt: https://github.com/sindresorhus/pure ---------- ###
autoload -U promptinit
promptinit
prompt pure
### ----------------------------- Completions ----------------------------- ###
if type brew &>/dev/null; then
  FPATH=$HOME/.zfunc:"$(brew --prefix)"/share/zsh-completions:$FPATH
  autoload -Uz compinit
  if [ "$(whoami)" = "brendon.smith" ]; then
    compinit -i # Ignore insecure directories (perms issues for non-admin user)
  else
    compinit
  fi
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C "$(brew --prefix)"/bin/terraform terraform
fi
### ------------------------- Syntax highlighting ------------------------- ###
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
