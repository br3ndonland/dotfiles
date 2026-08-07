#!/usr/bin/env bash

shopt -s dotglob globstar nullglob

set -e

ruff_args=(
  --isolated
  --extension rules:python
  --config "format.quote-style = 'preserve'"
)

case $1 in
check) ruff format "${ruff_args[@]}" --check .codex/rules/*.rules ;;
format) ruff format "${ruff_args[@]}" .codex/rules/*.rules ;;
*) echo "[ERROR] Unsupported argument $1" >&2 && exit 1 ;;
esac
