#!/bin/bash
### ---------------- Symlink dotfiles into home directory ----------------- ###
# Designed for use with Strap: https://github.com/MikeMcQuaid/strap
# Run by strap-after-setup
symlink_dotfiles() {
  if [ -d ~/.dotfiles ]; then
    (
      echo "-> Dotfiles found. Symlinking dotfiles into home directory."
      # TODO: iterate more effectively over dotfiles instead of hardcoding paths
      # dotdirs (configuration directories that begin with a dot)
      mkdir -p ~/{.config,.gnupg,.ssh}
      ln -fs ~/.dotfiles/.config/karabiner ~/.config
      # https://pqrs.org/osx/karabiner/document.html#configuration-file-path
      # Restart Karabiner after symlinking config
      KARABINER=gui/"$(id -u)"/org.pqrs.karabiner.karabiner_console_user_server
      if (launchctl kickstart "$KARABINER"); then
        launchctl kickstart -k "$KARABINER"
      fi
      ln -fs ~/.dotfiles/.config/kitty ~/.config
      ln -fs ~/.dotfiles/.gnupg/gpg.conf ~/.gnupg/gpg.conf
      ln -fs ~/.dotfiles/.gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
      ln -fs ~/.dotfiles/.ssh/config ~/.ssh/config
      # VSCode and variants
      mkdir -p ~/Library/Application\ Support/Code\ -\ Insiders/User/snippets
      mkdir -p ~/Library/Application\ Support/VSCodium/User/snippets
      ln -fs ~/.dotfiles/codium/User/settings.json \
        ~/Library/Application\ Support/VSCodium/User/settings.json
      ln -fs ~/.dotfiles/codium/User/settings.json \
        ~/Library/Application\ Support/Code\ -\ Insiders/User/settings.json
      ln -fs ~/.dotfiles/codium/User/keybindings.json \
        ~/Library/Application\ Support/VSCodium/User/keybindings.json
      ln -fs ~/.dotfiles/codium/User/keybindings.json \
        ~/Library/Application\ Support/Code\ -\ Insiders/User/keybindings.json
      ln -fs ~/.dotfiles/codium/User/snippets/vue.json \
        ~/Library/Application\ Support/VSCodium/User/snippets/vue.json
      ln -fs ~/.dotfiles/codium/User/snippets/vue.json \
        ~/Library/Application\ Support/Code\ -\ Insiders/User/snippets/vue.json
      # Top-level dotfiles
      ln -fs ~/.dotfiles/.gitconfig ~/.gitconfig
      ln -fs ~/.dotfiles/.gitmessage ~/.gitmessage
      ln -fs ~/.dotfiles/.prettierrc ~/.prettierrc
      ln -fs ~/.dotfiles/.zshrc ~/.zshrc
    )
  else
    echo "-> Error: Dotfiles directory not found. Symlinking not successful."
  fi
}
if symlink_dotfiles; then
  echo "-> symlink_dotfiles() ran successfully."
else
  echo "-> symlink_dotfiles() did not run successfully."
fi

set_perms() {
  # Set permissions for GPG
  chmod 700 ~/.gnupg
  chmod 600 ~/.gnupg/gpg.conf
}
if set_perms; then
  echo "-> set_perms() ran successfully."
else
  echo "-> set_perms() did not run successfully."
fi
