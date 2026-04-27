#!/usr/bin/env bash
# Bash configuration for login shells
# https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html

shell_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/shell"

if [[ -f "$shell_config_dir/environment.sh" ]]; then
  # shellcheck source=.config/shell/environment.sh
  source "$shell_config_dir/environment.sh"
fi

if [[ $- == *i* ]]; then
  if [[ -f "$HOME/.bashrc" ]]; then source "$HOME/.bashrc"; fi
  return
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash --shims)"
fi
