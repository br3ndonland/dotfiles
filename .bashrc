#!/usr/bin/env bash

### options
HISTCONTROL=ignoreboth
shopt -s globstar histappend nullglob

### exports
export PATH=$HOME/.zfunc:$PATH

### aliases
alias python='python3'

### prompt: https://starship.rs
eval "$(starship init bash)"
