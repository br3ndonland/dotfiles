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
### ---------------------------- Integrations ----------------------------- ###
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
fpath=(/usr/local/share/zsh-completions $fpath)
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
