#!/usr/bin/env bash

### options
HISTCONTROL=ignoreboth
shopt -s globstar histappend nullglob

### aliases
alias python='python3'

### prompt: https://starship.rs
eval "$(starship init bash)"
