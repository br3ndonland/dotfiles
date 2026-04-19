#!/usr/bin/env bash
# Bash configuration for interactive shells
# https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html
#
# to avoid activating tools twice, a conditional can be used that checks the
# `$-` special parameter. `$-` will contain `i` if the shell is interactive.
# https://www.gnu.org/software/bash/manual/html_node/Special-Parameters.html
[[ $- != *i* ]] && return

shell_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/shell"
# shellcheck source=.config/shell/env.sh
[[ -f "$shell_config_dir/env.sh" ]] && . "$shell_config_dir/env.sh"

# options
HISTCONTROL=ignoreboth
shopt -s dotglob histappend nullglob
shopt -s globstar 2>/dev/null || true
set -o emacs # keybindings - also see .inputrc

# exports
shell_functions_dir="$shell_config_dir/functions"
if [[ -d "$shell_functions_dir" ]]; then
  case ":$PATH:" in
  *":$shell_functions_dir:"*) ;;
  *) export PATH="$shell_functions_dir${PATH:+:$PATH}" ;;
  esac
fi

# shellcheck source=.config/shell/interactive.sh
[[ -f "$shell_config_dir/interactive.sh" ]] && . "$shell_config_dir/interactive.sh"
