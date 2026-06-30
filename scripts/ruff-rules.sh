#!/usr/bin/env bash

set -e

ruff_args=(
  --isolated
  --extension rules:python
  --config "format.quote-style = 'preserve'"
)

rules_files=(
  .codex/rules/default.rules
)

case $1 in
check) ruff format "${ruff_args[@]}" --check "${rules_files[@]}" ;;
format) ruff format "${ruff_args[@]}" "${rules_files[@]}" ;;
*) echo "[ERROR] Unsupported argument $1" >&2 && exit 1 ;;
esac
