#!/usr/bin/env bash
HISTCONTROL=ignoreboth
shopt -s globstar histappend nullglob
eval "$(starship init bash)"
