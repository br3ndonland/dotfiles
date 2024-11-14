#!/usr/bin/env bash
### --------------------- Install user Python packages --------------------- ###
# Accepts a path to a requirements.txt file.
# Manage user Python packages after install: https://github.com/pipxproject/pipx

pipx_install_requirements() {
  printf "\n-> Installing user Python packages with pipx...\n\n"
  local package_command pipx_list py
  py="$(python3 --version)"
  pipx_list="$(pipx list)"
  while read -r package; do
    case "$package" in
    awscli) : "aws" ;;
    httpie) : "http" ;;
    *) : "$package" ;;
    esac
    package_command="$_"
    if [[ $(echo "$pipx_list" | grep -ce "package $package .*, $py") -gt 0 ]]; then
      echo "$package already installed."
    elif [[ $(echo "$pipx_list" | grep -ce "package $package") -gt 0 ]]; then
      echo "Reinstalling $package for $py."
      pipx uninstall "$package"
      pipx install --python "$py" "$package"
    elif type "$package_command"; then
      echo "$package already on \$PATH."
    else
      pipx install "$package"
    fi
  done <"$1"
}

if ! type pipx &>/dev/null; then
  printf "\n-> Error: pipx must be installed and on PATH.\n\n"
  exit 1
elif pipx_install_requirements "$@"; then
  printf "\n-> Successful pipx package installation.\n\n"
else
  printf "\n-> Unsuccessful pipx package installation.\n\n"
fi
