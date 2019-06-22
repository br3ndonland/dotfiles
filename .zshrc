#!/bin/zsh
# Exports
export EDITOR="code"
# export GPG_TTY=$(tty)
# Add Homebrew's sbin to $PATH
export PATH="/usr/local/sbin:$PATH"
export SSH_KEY_PATH="~/.ssh/id_rsa_${USER}"
# oh-my-zsh
export ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME=""
plugins=(git node npm zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# User configuration
# Pure prompt: https://github.com/sindresorhus/pure
autoload -U promptinit
promptinit
prompt pure
# Aliases
alias ssh-add=/usr/bin/ssh-add
# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
