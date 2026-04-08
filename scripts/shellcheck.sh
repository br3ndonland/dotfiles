#!/usr/bin/env bash

git ls-files '*.sh' '*.bash' | xargs --no-run-if-empty shellcheck
