#!/usr/bin/env sh
# Shared interactive shell setup for Bash and Zsh.

if [ -n "${DOTFILES_SHELL_INTERACTIVE_LOADED:-}" ]; then
  # shellcheck disable=SC2317
  return 0 2>/dev/null || exit 0
fi
DOTFILES_SHELL_INTERACTIVE_LOADED=1

if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
fi
alias bbi='brew bundle install --global'
alias kc='kubectl'
alias python='python3'
alias tg='terragrunt'

dotfiles_shell_name=""
if [ -n "${BASH_VERSION:-}" ]; then
  dotfiles_shell_name="bash"
elif [ -n "${ZSH_VERSION:-}" ]; then
  dotfiles_shell_name="zsh"
fi

if [ -n "$dotfiles_shell_name" ] &&
  [ "$TERM_PROGRAM" != "WarpTerminal" ] &&
  command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_OPTS="
    --color=fg:#F8F8F2,bg:#22212C,hl:#9580FF,fg+:#F8F8F2,bg+:#454158
    --color=hl+:#9580FF,info:#FFCA80,prompt:#8AFF80,pointer:#FF80BF
    --color=marker:#FF80BF,spinner:#FFCA80,header:#7970A9,border:#7970A9
    --color=gutter:#454158"
  export FZF_CTRL_T_COMMAND='fd --hidden --follow --exclude .git'
  export FZF_CTRL_T_OPTS="
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"
  eval "$(fzf --$dotfiles_shell_name)"
fi

if [ -n "$dotfiles_shell_name" ] && command -v starship >/dev/null 2>&1; then
  eval "$(starship init "$dotfiles_shell_name")"
fi

if [ -n "$dotfiles_shell_name" ] && command -v mise >/dev/null 2>&1; then
  eval "$(mise activate "$dotfiles_shell_name")"
fi

unset dotfiles_shell_name
