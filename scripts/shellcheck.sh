#!/usr/bin/env bash

git ls-files \
  '*.sh' \
  '*.bash' \
  '.config/shell/functions/*' |
  xargs --no-run-if-empty shellcheck
