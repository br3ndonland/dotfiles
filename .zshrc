#!/usr/bin/env zsh
# Zsh configuration for interactive shells
# in interactive shells, both `~/.zprofile` and `~/.zshrc` are loaded.
# to avoid activating tools twice, a conditional can be used that checks the
# `$-` special parameter. `$-` will contain `i` if the shell is interactive.
# https://zsh.sourceforge.io/Doc/Release/Files.html
# https://zsh.sourceforge.io/Doc/Release/Parameters.html
[[ $- != *i* ]] && return

shell_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
[[ -f "$shell_config_dir/env.sh" ]] && . "$shell_config_dir/env.sh"

# usage: ln -fns $(pwd)/.zshrc ~/.zshrc

# options
#
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

bindkey -s '^[OM' '^M'         # Enter -> Carriage Return
bindkey -s '^[Ok' '+'          # + on numeric keypad -> plain +
bindkey -s '^[Om' '-'          # - on numeric keypad -> plain -
bindkey -s '^[Oj' '*'          # * on numeric keypad -> plain *
bindkey -s '^[Oo' '/'          # / on numeric keypad -> plain /
bindkey -s '^[OX' '='          # = on numeric keypad -> plain =
bindkey -s '^[OH' '^[[H'       # Home key
bindkey -s '^[OF' '^[[F'       # End key
bindkey -s '^[OA' '^[[A'       # Up arrow key
bindkey -s '^[OB' '^[[B'       # Down arrow
bindkey -s '^[OD' '^[[D'       # Left arrow
bindkey -s '^[OC' '^[[C'       # Right arrow
bindkey -s '^[[1~' '^[[H'      # Home key (alternative key code)
bindkey -s '^[[4~' '^[[F'      # End key (alternative key code)
bindkey -s '^[Od' '^[[1;5D'    # Alt‑Left
bindkey -s '^[Oc' '^[[1;5C'    # Alt-Right
bindkey -s '^[^[[D' '^[[1;3D'  # Alt‑Left (alternative key code)
bindkey -s '^[^[[C' '^[[1;3C'  # Alt-Right (alternative key code)
bindkey -s '^[[7~' '^[[H'      # 7 on numeric keypad -> Home key
bindkey -s '^[[8~' '^[[F'      # 8 on numeric keypad -> End key
bindkey -s '^[[3\^' '^[[3;5~'  # Shift-Delete (alternative key code)
bindkey -s '^[^[[3~' '^[[3;3~' # Alt-Delete (alternative key code)

# command bindings

bindkey '^[[1;3D' 'backward-word' # Alt-Left
bindkey '^[[1;5D' 'backward-word' # Alt-Left
bindkey '^[[1;3C' 'forward-word'  # Alt-Right
bindkey '^[[1;5C' 'forward-word'  # Alt-Right

bindkey '^[[1;9D' 'beginning-of-line' # Command-Left (⌘ ←)
bindkey '^[[H' 'beginning-of-line'    # Home key
bindkey '^[[1;9C' 'end-of-line'       # Command-Right (⌘ →)
bindkey '^[[F' 'end-of-line'          # End key

bindkey '^[[3~' 'delete-char' # Delete

bindkey '^[[3;5~' 'kill-word' # Alt-Delete
bindkey '^[[3;3~' 'kill-word' # Shift-Delete

bindkey '^[[3;9~' 'kill-line' # Command-Delete (⌘ ⌦)
# in the kitty terminal emulator when running `kitten show-key -m kitty`,
# Command-Backspace (⌘ ⌫) shows as 'CSI 127 ; 9 u' ('^[[127;9u'),
# but mapping this sequence to 'backward-kill-line' does not work.
# Instead, `kitty.conf` maps Command-Backspace to a text sequence ('\x15'),
# and this will automatically bind Command-Backspace to 'backward-kill-line'.
# https://sw.kovidgoyal.net/kitty/faq/
# https://sw.kovidgoyal.net/kitty/keyboard-protocol/
# https://github.com/kovidgoyal/kitty/issues/264

[[ -f "$shell_config_dir/interactive.sh" ]] && . "$shell_config_dir/interactive.sh"

# functions
# use an anonymous function so locals do not persist in the shell environment.
# https://zsh.sourceforge.io/Doc/Release/Functions.html#Anonymous-Functions
() {
  local shell_function_files shell_functions_dir
  shell_functions_dir="$shell_config_dir/functions"
  if [[ -d "$shell_functions_dir" ]]; then
    typeset -U fpath
    fpath+=("$shell_functions_dir")
    shell_function_files=("$shell_functions_dir"/*(:tX))
    if ((${#shell_function_files})); then
      autoload -Uz ${shell_function_files:t}
    fi
  fi
}

# completions
if type brew &>/dev/null && [[ -d $HOMEBREW_PREFIX ]]; then
  fpath+=($HOMEBREW_PREFIX/share/zsh/site-functions)
fi
zstyle :compinstall filename $HOME/.zshrc
autoload -Uz compinit
compinit

# syntax highlighting
if [[ -d $HOMEBREW_PREFIX/share/zsh-syntax-highlighting ]]; then
  . $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -d $HOME/.zsh/zsh-syntax-highlighting ]]; then
  . $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
