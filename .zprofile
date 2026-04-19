#!/usr/bin/env zsh
# Zsh configuration for login shells
# in interactive shells, both `~/.zprofile` and `~/.zshrc` are loaded.
# to avoid activating tools twice, a conditional can be used that checks the
# `$-` special parameter. `$-` will contain `i` if the shell is interactive.
# https://zsh.sourceforge.io/Doc/Release/Files.html
# https://zsh.sourceforge.io/Doc/Release/Parameters.html
[[ $- == *i* ]] && return

shell_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
[[ -f "$shell_config_dir/env.sh" ]] && . "$shell_config_dir/env.sh"

if command -v mise &>/dev/null; then
  eval "$(mise activate zsh --shims)"
fi
