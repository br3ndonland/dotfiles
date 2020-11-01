#!/usr/bin/env bash
### --------------------- Install global npm packages --------------------- ###
# Run by strap-after-setup
# Manage global packages after install: https://www.npmjs.com/package/npm-check

npm_install_globals() {
  if [ -d ~/.dotfiles ]; then
    (
      echo "-> Dotfiles directory found. Installing global npm packages..."
      # Install npm packages listed in npm-globals.txt
      package_dir="$(npm config get prefix)/lib"
      packages=$(npm ls -g --parseable --depth=0)
      packages=${packages//$package_dir\/node_modules\//}
      while read -r p; do
        installed=$(echo "$packages" | grep -ce "^$p\$")
        if [ "$installed" == "0" ]; then
          echo "Installing $p."
          npm install -g "$p" || echo "-> Error: package $p not found in npm."
        else
          echo "$p already installed."
        fi
      done <~/.dotfiles/js/npm-globals.txt
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
