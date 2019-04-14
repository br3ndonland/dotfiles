#!/bin/bash
#/ Symlink dotfiles into home directory
#/ Designed for use with Strap:
#/ https://github.com/MikeMcQuaid/strap
#/ Run by run_dotfile_scripts() in strap.sh
symlink_dotfiles() {
  if [ -d ~/.dotfiles ]; then
    (
      echo "Dotfiles directory found."
      # Make directories for symlinks, if they don't already exist
      mkdir -p ~/{.gnupg,.ssh}
      # Create symlinks (ln -s), and prompt (-i) before overwrite (-f)
      # TODO: read ~/.dotfiles and iterate over, instead of hardcoding paths
      ln -s -f -i ~/.dotfiles/.gitconfig ~/.gitconfig
      ln -s -f -i ~/.dotfiles/.gitmessage ~/.gitmessage
      ln -s -f -i ~/.dotfiles/.hyper.js ~/.hyper.js
      ln -s -f -i ~/.dotfiles/.zshrc ~/.zshrc
      ln -s -f -i ~/.dotfiles/.gnupg/gpg.conf ~/.gnupg/gpg.conf
      ln -s -f -i ~/.dotfiles/.gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
      ln -s -f -i ~/.dotfiles/.ssh/config ~/.ssh/config
    )
  else echo "Dotfiles directory not found."
  fi
}
symlink_dotfiles