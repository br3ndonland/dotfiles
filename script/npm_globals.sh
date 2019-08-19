#!/bin/bash
### --------------------- Install global npm packages --------------------- ###
# Based on https://github.com/ianwalter/dotnpm/blob/master/install.sh
# Designed for use with Strap: https://github.com/MikeMcQuaid/strap
# Run by strap-after-setup
npm_install_globals() {
  if [ -d ~/.dotfiles ]; then
    (
      echo "-> Dotfiles directory found. Installing global npm packages..."
      # Make directory for symlink, if it doesn't already exist (-p)
      mkdir -p ~/.npm
      # Create symlink (ln -s), and don't prompt (-i) before overwrite (-f)
      if [ ! -f ~/.npm/npm-globals.txt ]; then
        ln -s -f ~/.dotfiles/.npm/npm-globals.txt ~/.npm/npm-globals.txt
      fi
      # Install npm packages listed in npm-globals.txt
      package_dir="$(npm config get prefix)/lib"
      packages=$(npm ls -g --parseable --depth=0)
      packages=${packages//$package_dir/}
      packages=${packages//\/node_modules\//}
      while read -r p; do
        installed=$(echo "$packages" | grep -ce "^$p\$")
        if [ "$installed" == "0" ]; then
          echo "Installing $p."
          npm install -g "$p" || echo "-> Error: package $p not found in npm."
        else
          echo "$p already installed."
        fi
      done <~/.dotfiles/.npm/npm-globals.txt
      echo "-> Done installing npm packages."
    )
  else
    echo "-> Error: dotfiles directory not found."
  fi
}
if npm_install_globals; then
  echo "-> npm_install_globals() ran successfully."
else
  echo "-> Error: npm_install_globals() did not run successfully."
fi
