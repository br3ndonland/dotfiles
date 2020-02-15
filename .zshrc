#!/bin/zsh
### ------------------------------- Exports ------------------------------- ###
export EDITOR="codium"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"
export SSH_KEY_PATH="~/.ssh/id_rsa_${USER}"
### ------------------------------- Aliases ------------------------------- ###
alias dc="docker-compose"
alias gpa="git push; if git remote | grep "keybase"; then git push keybase; fi;
if git remote | grep "srht"; then git push srht; fi;"
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
fpath=(/usr/local/share/zsh-completions $fpath)
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
