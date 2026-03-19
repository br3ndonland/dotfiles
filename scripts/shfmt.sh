#!/usr/bin/env bash

shopt -s dotglob globstar nullglob

set -e

case $1 in
check)
  files=$(shfmt -f .)
  if [ -n "$files" ]; then
    printf "Found the following files:\n%s\n" "$files"
    shfmt -d . .{bash,z,zfunc/}*
  else
    echo "No shell scripts for shfmt to check."
  fi
  ;;
format) shfmt -w . .{bash,z,zfunc/}* ;;
*) echo "[ERROR] Unsupported argument $1" >&2 && exit 1 ;;
esac
