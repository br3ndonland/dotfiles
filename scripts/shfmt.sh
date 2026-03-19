#!/usr/bin/env bash

shopt -s dotglob globstar nullglob

set -e

case $1 in
check) shfmt -d . .{bash,z,zfunc/}* ;;
format) shfmt -w . .{bash,z,zfunc/}* ;;
*) echo "[ERROR] Unsupported argument $1" >&2 && exit 1 ;;
esac
