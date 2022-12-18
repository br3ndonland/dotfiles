#!/usr/bin/env bash

### options
HISTCONTROL=ignoreboth
shopt -s globstar histappend nullglob

### aliases
alias python='python3'
if command -v gsed &>/dev/null; then alias sed='gsed'; fi

### prompt: https://starship.rs
eval "$(starship init bash)"
