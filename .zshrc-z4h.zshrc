#!/usr/bin/env zsh
### zsh4humans: https://github.com/romkatv/zsh4humans
# usage: ln -fns $(pwd)/.zshrc-z4h.zshrc ~/.zshrc

### style
zstyle ':z4h:' auto-update 'ask'
zstyle ':z4h:' auto-update-days '28'
zstyle ':z4h:' prompt-position top
zstyle ':z4h:bindkey' keyboard 'mac'
zstyle ':z4h:autosuggestions' forward-char 'accept'
zstyle ':z4h:ssh:*' enable 'no'
zstyle ':zle:up-line-or-beginning-search' leave-cursor 'yes'
zstyle ':zle:down-line-or-beginning-search' leave-cursor 'yes'
zstyle :compinstall filename $HOME/.zshrc

### repos
# z4h install ohmyzsh/ohmyzsh || return

### initialization
z4h init || return

### exports
if command -v code-exploration &>/dev/null; then
  export EDITOR='code-exploration --wait'
elif command -v code-insiders &>/dev/null; then
  export EDITOR='code-insiders --wait'
elif command -v code &>/dev/null; then
  export EDITOR='code --wait'
elif command -v codium &>/dev/null; then
  export EDITOR='codium --wait'
else
  export EDITOR='vim'
fi
TTY=$(tty)
export GPG_TTY=$TTY
export SSH_KEY_PATH=$HOME/.ssh/id_rsa_$USER
case $(uname) in
Darwin)
  if [[ $(uname -m) == 'arm64' ]]; then
    BREW_PREFIX='/opt/homebrew'
  elif [[ $(uname -m) == 'x86_64' ]]; then
    BREW_PREFIX='/usr/local'
  fi
  ;;
Linux) BREW_PREFIX='/home/linuxbrew/.linuxbrew' ;;
esac
eval $($BREW_PREFIX/bin/brew shellenv)

### PATH extensions: array items must be unquoted and $path must be lowercase
path=($path $HOME/.local/bin $HOME/.poetry/bin)

### sources: z4h source /path/to/script

### keybindings
z4h bindkey undo Ctrl+/                # undo last command line change
z4h bindkey redo Alt+/                 # redo last undone command line change
z4h bindkey z4h-cd-back Shift+Left     # cd into previous directory
z4h bindkey z4h-cd-forward Shift+Right # cd into next directory
z4h bindkey z4h-cd-up Shift+Up         # cd into parent directory
z4h bindkey z4h-cd-down Shift+Down     # cd into a child directory

### additional functions and completions
md() {
  [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" || return
}
compdef _directories md
if type brew &>/dev/null; then
  fpath+=$HOME/.zfunc:$(brew --prefix)/share/zsh/site-functions
  if [[ -d $(brew --prefix)/bin/terraform ]]; then
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C $(brew --prefix)/bin/terraform terraform
  fi
fi

### autoload functions
autoload -Uz compinit zmv
# ignore insecure directories (perms issues for non-admin user)
[[ $(whoami) = 'brendon.smith' ]] && compinit -i || compinit

### aliases
alias dc='docker-compose'
alias python='python3'
alias tree='tree -a -I .git'

### Zsh options: http://zsh.sourceforge.net/Doc/Release/Options.html
setopt autocd extendedglob globdots histignorespace noautomenu nomatch
