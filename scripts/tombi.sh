#!/usr/bin/env bash

shopt -s dotglob globstar nullglob

set -e

export XDG_CONFIG_HOME="$PWD/.config"

case $1 in
check) tombi lint ./**/*.toml ;;
format) tombi format ./**/*.toml ;;
*) echo "[ERROR] Unsupported argument $1" >&2 && exit 1 ;;
esac
