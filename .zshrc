# Exports
export EDITOR="code"
# export GPG_TTY=$(tty)
export SSH_KEY_PATH="~/.ssh/rsa_id_invicro"
# Add Homebrew's sbin to $PATH
export PATH="/usr/local/sbin:$PATH"
# oh-my-zsh
export ZSH="/Users/bsmith/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git node npm zsh-syntax-highlighting)
# ENABLE_CORRECTION="true"

source $ZSH/oh-my-zsh.sh

# User configuration
# Pure prompt: https://github.com/sindresorhus/pure
autoload -U promptinit; promptinit
prompt pure
