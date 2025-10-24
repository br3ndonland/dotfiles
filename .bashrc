#!/usr/bin/env bash
### Bash configuration for interactive shells
# https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html
#
# to avoid activating tools twice, a conditional can be used that checks the
# `$-` special parameter. `$-` will contain `i` if the shell is interactive.
# https://www.gnu.org/software/bash/manual/html_node/Special-Parameters.html
[[ $- != *i* ]] && return

### options
HISTCONTROL=ignoreboth
shopt -s dotglob globstar histappend nullglob

### exports
export PATH=$HOME/.zfunc:$PATH

### aliases
alias python='python3'

### prompt: https://starship.rs
source <(starship init bash)

### mise: https://mise.jdx.dev/
source <(mise activate bash)
