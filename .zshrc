#!/usr/bin/env zsh
### Zsh configuration for interactive shells
# in interactive shells, both `~/.zprofile` and `~/.zshrc` are loaded.
# to avoid activating tools twice, a conditional can be used that checks the
# `$-` special parameter. `$-` will contain `i` if the shell is interactive.
# https://zsh.sourceforge.io/Doc/Release/Files.html
# https://zsh.sourceforge.io/Doc/Release/Parameters.html
[[ $- != *i* ]] && return

# usage: ln -fns $(pwd)/.zshrc ~/.zshrc

### options
# initial setup configured by zsh-newuser-install
# To re-run setup: autoload -U zsh-newuser-install; zsh-newuser-install -f
# See man zshoptions or https://zsh.sourceforge.net/Doc/Release/Options.html
HISTFILE=~/.zsh_history
HISTSIZE=10000
setopt autocd extendedglob globdots histignorespace noautomenu nullglob

# keybindings
#
# https://github.com/romkatv/zsh4humans/blob/v5/z4h.zsh
# https://zsh.sourceforge.io/Guide/zshguide04.html
# https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html

# activate Emacs mode for greater consistency with Bash and Readline
bindkey -d
bindkey -e

# string replacement bindings

bindkey -s '^[OM'    '^M'                  # Enter -> Carriage Return
bindkey -s '^[Ok'    '+'                   # + on numeric keypad -> plain +
bindkey -s '^[Om'    '-'                   # - on numeric keypad -> plain -
bindkey -s '^[Oj'    '*'                   # * on numeric keypad -> plain *
bindkey -s '^[Oo'    '/'                   # / on numeric keypad -> plain /
bindkey -s '^[OX'    '='                   # = on numeric keypad -> plain =
bindkey -s '^[OH'    '^[[H'                # Home key
bindkey -s '^[OF'    '^[[F'                # End key
bindkey -s '^[OA'    '^[[A'                # Up arrow key
bindkey -s '^[OB'    '^[[B'                # Down arrow
bindkey -s '^[OD'    '^[[D'                # Left arrow
bindkey -s '^[OC'    '^[[C'                # Right arrow
bindkey -s '^[[1~'   '^[[H'                # Home key (alternative key code)
bindkey -s '^[[4~'   '^[[F'                # End key (alternative key code)
bindkey -s '^[Od'    '^[[1;5D'             # Alt‑Left
bindkey -s '^[Oc'    '^[[1;5C'             # Alt-Right
bindkey -s '^[^[[D'  '^[[1;3D'             # Alt‑Left (alternative key code)
bindkey -s '^[^[[C'  '^[[1;3C'             # Alt-Right (alternative key code)
bindkey -s '^[[7~'   '^[[H'                # 7 on numeric keypad -> Home key
bindkey -s '^[[8~'   '^[[F'                # 8 on numeric keypad -> End key
bindkey -s '^[[3\^'  '^[[3;5~'             # Shift-Delete (alternative key code)
bindkey -s '^[^[[3~' '^[[3;3~'             # Alt-Delete (alternative key code)

# command bindings

bindkey '^[[1;3D'    'backward-word'       # Alt-Left
bindkey '^[[1;5D'    'backward-word'       # Alt-Left
bindkey '^[[1;3C'    'forward-word'        # Alt-Right
bindkey '^[[1;5C'    'forward-word'        # Alt-Right

bindkey '^[[1;9D'    'beginning-of-line'   # Command-Left (⌘ ←)
bindkey '^[[H'       'beginning-of-line'   # Home key
bindkey '^[[1;9C'    'end-of-line'         # Command-Right (⌘ →)
bindkey '^[[F'       'end-of-line'         # End key

bindkey '^[[3~'      'delete-char'         # Delete

bindkey '^[[3;5~'    'kill-word'           # Alt-Delete
bindkey '^[[3;3~'    'kill-word'           # Shift-Delete

bindkey '^[[3;9~'    'kill-line'           # Command-Delete (⌘ ⌦)

### homebrew
if [[ -z $HOMEBREW_PREFIX ]]; then
  case $(uname) in
  Darwin)
    if [[ $(uname -m) == 'arm64' ]]; then
      HOMEBREW_PREFIX='/opt/homebrew'
    elif [[ $(uname -m) == 'x86_64' ]]; then
      HOMEBREW_PREFIX='/usr/local'
    fi
    ;;
  Linux)
    if [[ -d '/home/linuxbrew/.linuxbrew' ]]; then
      HOMEBREW_PREFIX='/home/linuxbrew/.linuxbrew'
    elif [[ -d $HOME/.linuxbrew ]]; then
      HOMEBREW_PREFIX=$HOME/.linuxbrew
    fi
    if [[ -d $HOMEBREW_PREFIX ]]; then
      PATH=$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH
    fi
    ;;
  esac
fi
if [[ -d $HOMEBREW_PREFIX ]]; then
  eval $($HOMEBREW_PREFIX/bin/brew shellenv)
fi

### exports
# exports are set up with locals inside an anonymous function so that only the
# exported variables persist in the shell session and not the local variables.
# https://zsh.sourceforge.io/Doc/Release/Functions.html#Anonymous-Functions
() {
  local editor
  if type codium &>/dev/null; then
    editor='codium --wait'
  elif type cursor &>/dev/null; then
    editor='cursor --wait'
  elif type code &>/dev/null; then
    editor='code --wait'
  elif type code-insiders &>/dev/null; then
    editor='code-insiders --wait'
  elif type code-exploration &>/dev/null; then
    editor='code-exploration --wait'
  else
    editor='vim'
  fi

  local CURL_BIN_DIR=$HOMEBREW_PREFIX/opt/curl/bin
  local CURL_CPPFLAGS=-I$HOMEBREW_PREFIX/opt/curl/include
  local CURL_LDFLAGS=-L$HOMEBREW_PREFIX/opt/curl/lib
  local CURL_PKG_CONFIG_PATH=$HOMEBREW_PREFIX/opt/curl/lib/pkgconfig
  local GNU_AWK_BIN_DIR=$HOMEBREW_PREFIX/opt/gawk/libexec/gnubin
  local GNU_COREUTILS_BIN_DIR=$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin
  local GNU_FINDUTILS_BIN_DIR=$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin
  local GNU_GREP_BIN_DIR=$HOMEBREW_PREFIX/opt/grep/libexec/gnubin
  local GNU_SED_BIN_DIR=$HOMEBREW_PREFIX/opt/gsed/libexec/gnubin
  local GNU_TAR_BIN_DIR=$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin
  local LOCAL_BIN_DIR=$HOME/.local/bin
  local RUST_CARGO_BIN_DIR=$HOME/.cargo/bin
  local TTY=$(tty)

  local path_array=(
    $CURL_BIN_DIR
    $GNU_AWK_BIN_DIR
    $GNU_COREUTILS_BIN_DIR
    $GNU_FINDUTILS_BIN_DIR
    $GNU_GREP_BIN_DIR
    $GNU_SED_BIN_DIR
    $GNU_TAR_BIN_DIR
    $LOCAL_BIN_DIR
    $RUST_CARGO_BIN_DIR
    $PATH
  )

  export \
    CPPFLAGS=$CURL_CPPFLAGS \
    EDITOR=$editor \
    GIT_EDITOR=$editor \
    GPG_TTY=$TTY \
    HATCH_ENV_TYPE_VIRTUAL_PATH=.venv \
    HOMEBREW_NO_ANALYTICS=1 \
    LDFLAGS=$CURL_LDFLAGS \
    PATH=${(j.:.)path_array} \
    PIPX_BIN_DIR=$LOCAL_BIN_DIR \
    PKG_CONFIG_PATH=$CURL_PKG_CONFIG_PATH
}

### aliases
alias python='python3'
alias tg='terragrunt'

### prompt: https://starship.rs
source <(starship init zsh)

### mise: https://mise.jdx.dev/
source <(mise activate zsh)

### functions
# ensure .zfunc is symlinked to $HOME/.zfunc
typeset -U fpath
fpath+=($HOME/.zfunc)
autoload -Uz $HOME/.zfunc/*(:tX)

### completions
if type brew &>/dev/null && [[ -d $HOMEBREW_PREFIX ]]; then
  fpath+=($HOMEBREW_PREFIX/share/zsh/site-functions)
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
