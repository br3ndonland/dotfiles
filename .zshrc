#!/bin/zsh
### ------------------------------- Exports ------------------------------- ###
export EDITOR="code"
export PATH="/usr/local/sbin:$PATH"
export SSH_KEY_PATH="~/.ssh/id_rsa_${USER}"
### ------------------------------- Aliases ------------------------------- ###
alias ssh-add=/usr/bin/ssh-add
### ------------------------------- Prompt -------------------------------- ###
# Pure prompt: https://github.com/sindresorhus/pure
autoload -U promptinit
promptinit
prompt pure
### ----- History file configuration - based on oh-my-zsh history.zsh ----- ###
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
### ---------------------------- Integrations ----------------------------- ###
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
fpath=(/usr/local/share/zsh-completions $fpath)
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
