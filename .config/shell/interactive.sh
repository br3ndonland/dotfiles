#!/usr/bin/env sh
# Shared interactive shell setup for Bash and Zsh.

if [ -n "${DOTFILES_SHELL_INTERACTIVE_LOADED:-}" ]; then
  # shellcheck disable=SC2317
  return 0 2>/dev/null || exit 0
fi
DOTFILES_SHELL_INTERACTIVE_LOADED=1

alias kc='kubectl'
alias python='python3'
alias tg='terragrunt'

dotfiles_shell_name=""
if [ -n "${BASH_VERSION:-}" ]; then
  dotfiles_shell_name="bash"
elif [ -n "${ZSH_VERSION:-}" ]; then
  dotfiles_shell_name="zsh"
fi

if [ -n "$dotfiles_shell_name" ] && command -v starship >/dev/null 2>&1; then
  eval "$(starship init "$dotfiles_shell_name")"
fi

if [ -n "$dotfiles_shell_name" ] && command -v mise >/dev/null 2>&1; then
  eval "$(mise activate "$dotfiles_shell_name")"
fi

unset dotfiles_shell_name
