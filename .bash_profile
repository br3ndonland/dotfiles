#!/usr/bin/env bash
# Bash configuration for login shells
# https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html

shell_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
# shellcheck source=.config/shell/env.sh
[[ -f "$shell_config_dir/env.sh" ]] && . "$shell_config_dir/env.sh"

if [[ $- == *i* ]]; then
  [[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
  return
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash --shims)"
fi
