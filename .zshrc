# Exports
# gpg
export GPG_TTY=$(tty)
# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id_protonmail"
# Path to your oh-my-zsh installation.
export ZSH="/Users/br3ndonland/.oh-my-zsh"

# Theme
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Plugins
plugins=(git node npm zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration
# Pure prompt: https://github.com/sindresorhus/pure
autoload -U promptinit; promptinit
prompt pure
