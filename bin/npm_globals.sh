#!/bin/bash
### Install global npm packages ###
# Based on https://github.com/ianwalter/dotnpm/blob/master/install.sh
# Designed for use with Strap:
# https://github.com/MikeMcQuaid/strap
# Run by run_dotfile_scripts() in strap.sh
npm_install_globals() {
  if [ -d ~/.dotfiles ]; then
    (
      echo "Dotfiles directory found. Installing global npm packages..."
      # Make directories for symlinks, if they don't already exist
      mkdir -p ~/.npm
      # Create symlink to package list (ln -s), and prompt (-i) before overwrite (-f)
      ln -s -f -i ~/.dotfiles/.npm/npm-globals.txt ~/.npm/npm-globals.txt
      # Install npm packages listed in npm-globals.txt
      package_dir="$(npm config get prefix)/lib"
      packages=$(npm ls -g --parseable --depth=0)
      packages=${packages//$package_dir/}
      packages=${packages//\/node_modules\//}
      while read -r p; do
        installed=$(echo "$packages" | grep -ce "^$p\$")
        if [ "$installed" == "0" ]; then
          echo "Installing $p."
          npm install -g "$p"
        else
          echo "$p already installed."
        fi
      done <~/.dotfiles/.npm/npm-globals.txt
      echo "Done installing npm packages."
    )
  else
    echo "Dotfiles directory not found. Installation of npm packages not successful."
  fi
}
if npm_install_globals; then
  echo "npm_install_globals() ran successfully."
else
  echo "npm_install_globals() did not run successfully."
fi
