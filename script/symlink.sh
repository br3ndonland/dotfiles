#!/bin/bash
### ---------------- Symlink dotfiles into home directory ----------------- ###
# Run by strap-after-setup

symlink_dotfiles() {
  echo "-> Symlinking dotfiles into home directory."
  DOTS=$HOME/.dotfiles
  NOTS=("$DOTS/.git" "$DOTS/.github" "$DOTS/.gitignore")
  for FILE in "$DOTS/."*; do
    ! [[ ${NOTS[*]} =~ $FILE ]] && ln -fns "$FILE" "$HOME/${FILE##$DOTS/}"
  done
}

symlink_vscodium() {
  echo "-> Symlinking VSCodium settings."
  DOTS=$HOME/.dotfiles/codium/User
  APP_DIR=$HOME/Library/Application\ Support
  for DIR in $APP_DIR/{VSCodium,Code\ -\ Insiders}/User; do
    ! [ -d "$DIR" ] && mkdir -p "$DIR"
    for FILE in "$DOTS/"*; do
      ln -fns "$FILE" "$DIR/${FILE##$DOTS/}"
    done
  done
}

set_perms() {
  echo "-> Setting permissions on GPG directories."
  chmod 700 ~/.gnupg
  chmod 600 ~/.gnupg/gpg.conf
}

if symlink_dotfiles && symlink_vscodium; then
  echo "-> Symlinking successful."
  # https://pqrs.org/osx/karabiner/document.html#configuration-file-path
  # Restart Karabiner after symlinking config
  KARABINER=gui/"$(id -u)"/org.pqrs.karabiner.karabiner_console_user_server
  if (launchctl kickstart "$KARABINER"); then
    launchctl kickstart -k "$KARABINER"
  fi
else
  echo "-> Symlinking unsuccessful."
  ! [ -d ~/.dotfiles ] && echo "-> Error: Dotfiles directory not found"
fi

if set_perms; then
  echo "-> Permissions successfully set on GPG directories."
else
  echo "-> Permissions not successfully set on GPG directories."
fi
