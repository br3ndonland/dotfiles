#!/usr/bin/env zsh
### Zsh configuration
# usage: ln -fns $(pwd)/.zshrc ~/.zshrc

### initial setup configured by zsh-newuser-install
# To re-run setup: autoload -U zsh-newuser-install; zsh-newuser-install -f
# See man zshoptions or http://zsh.sourceforge.net/Doc/Release/Options.html
HISTFILE=~/.zsh_history
HISTSIZE=10000
setopt autocd extendedglob globdots histignorespace noautomenu nomatch

### keybindings: based on https://github.com/romkatv/zsh4humans
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
export PATH=$HOME/.local/bin:$PATH
export POETRY_HOME=$HOME/.local
export SSH_KEY_PATH=$HOME/.ssh/id_rsa_$USER

### aliases
alias python='python3'

### homebrew
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

### prompt: https://github.com/sindresorhus/pure
if ! type brew &>/dev/null || [[ $(uname) = 'Linux' ]]; then
  [[ -d $HOME/.zsh/pure ]] && fpath+=$HOME/.zsh/pure
fi
autoload -U promptinit
promptinit
prompt pure

### completions
if type brew &>/dev/null; then
  fpath+=$HOME/.zfunc:$(brew --prefix)/share/zsh/site-functions
fi
zstyle :compinstall filename $HOME/.zshrc
autoload -Uz compinit
# ignore insecure directories (perms issues for non-admin user)
[[ $(whoami) = 'brendon.smith' ]] && compinit -i || compinit

### syntax highlighting
if [[ -d $(brew --prefix)/share/zsh-syntax-highlighting ]]; then
  . $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -d $HOME/.zsh/zsh-syntax-highlighting ]]; then
  . $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
