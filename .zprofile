#!/usr/bin/env zsh
# Zsh configuration for login shells
# https://zsh.sourceforge.io/Doc/Release/Files.html

shell_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
[[ -f "$shell_config_dir/env.sh" ]] && . "$shell_config_dir/env.sh"
[[ $- == *i* ]] && return

if command -v mise &>/dev/null; then
  eval "$(mise activate zsh --shims)"
fi
