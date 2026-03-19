#!/usr/bin/env bash

shopt -s dotglob globstar nullglob

set -- **/*.{bash,sh,zfunc/}*

if [ -n "$1" ]; then
  printf "Found the following files:\n"
  printf "%s\n" "$@"
  shellcheck "$@"
else
  echo "No shell scripts for ShellCheck to check."
fi
