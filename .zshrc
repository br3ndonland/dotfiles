#!/usr/bin/env zsh
### Zsh configuration
# usage: ln -fns $(pwd)/.zshrc ~/.zshrc

### initial setup configured by zsh-newuser-install
# To re-run setup: autoload -U zsh-newuser-install; zsh-newuser-install -f
# See man zshoptions or http://zsh.sourceforge.net/Doc/Release/Options.html
HISTFILE=~/.zsh_history
HISTSIZE=10000
setopt autocd extendedglob globdots histignorespace noautomenu nullglob

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

### homebrew
[[ -z $HOMEBREW_PREFIX ]] && case $(uname) in
Darwin)
  if [[ $(uname -m) == 'arm64' ]]; then
    HOMEBREW_PREFIX='/opt/homebrew'
  elif [[ $(uname -m) == 'x86_64' ]]; then
    HOMEBREW_PREFIX='/usr/local'
  fi
  ;;
Linux) HOMEBREW_PREFIX='/home/linuxbrew/.linuxbrew' ;;
esac
eval $($HOMEBREW_PREFIX/bin/brew shellenv)

### exports
if command -v code &>/dev/null; then
  export EDITOR='code --wait'
elif command -v code-insiders &>/dev/null; then
  export EDITOR='code-insiders --wait'
elif command -v code-exploration &>/dev/null; then
  export EDITOR='code-exploration --wait'
elif command -v codium &>/dev/null; then
  export EDITOR='codium --wait'
else
  export EDITOR='vim'
fi
TTY=$(tty)
export GPG_TTY=$TTY
export PATH=$HOME/.local/bin:$PATH

### aliases
alias python='python3'

### prompt: https://starship.rs
eval $(starship init zsh)

### completions
if type brew &>/dev/null; then
  fpath+=$HOME/.zfunc:$HOMEBREW_PREFIX/share/zsh/site-functions
fi
zstyle :compinstall filename $HOME/.zshrc
autoload -Uz compinit
compinit

### syntax highlighting
if [[ -d $HOMEBREW_PREFIX/share/zsh-syntax-highlighting ]]; then
  . $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -d $HOME/.zsh/zsh-syntax-highlighting ]]; then
  . $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
