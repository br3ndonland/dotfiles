#!/usr/bin/env bash
### ------------------------ symlink dotfiles repo ------------------------ ###

symlink_dir_contents() {
  TARGET_DIR=$3/${1##"$2"/}
  ! [ -d "$TARGET_DIR" ] && mkdir -p "$TARGET_DIR"
  for FILE in "$1/"*; do
    symlink_file "$FILE" "$2" "$3"
  done
}

symlink_file() {
  ln -nsfF "$1" "$3/${1##"$2"/}"
}

symlink_repo_dotfiles() {
  echo "-> Symlinking dotfiles into home directory."
  DOT_DIR=$HOME/.dotfiles
  IGNORES=(
    "$DOT_DIR/.DS_Store"
    "$DOT_DIR/.git"
    "$DOT_DIR/.gitattributes"
    "$DOT_DIR/.github"
    "$DOT_DIR/.gitignore"
  )
  for DOTFILE in "$DOT_DIR/."*; do
    if ! [[ ${IGNORES[*]} =~ $DOTFILE ]]; then
      [ -d "$DOTFILE" ] && symlink_dir_contents "$DOTFILE" "$DOT_DIR" "$HOME"
      [ -f "$DOTFILE" ] && symlink_file "$DOTFILE" "$DOT_DIR" "$HOME"
    fi
  done
  ln -nsfF "$DOT_DIR/Brewfile" "$HOME/.Brewfile"
}

symlink_vscode_settings() {
  echo "-> Symlinking VSCode settings."
  SETTINGS_DIR=$HOME/.dotfiles/vscode
  case $(uname -s) in
  Darwin) : "$HOME/Library/Application Support" ;;
  Linux) : "$HOME/.config" ;;
  *) echo "-> Error: symlink.sh only supports macOS and Linux." && return 1 ;;
  esac
  DIRS=(
    "$_/Code"
    "$_/Code - Exploration"
    "$_/Code - Insiders"
    "$_/Cursor"
    "$_/VSCodium"
  )
  for DIR in "${DIRS[@]}"; do
    symlink_dir_contents "$SETTINGS_DIR/User" "$SETTINGS_DIR" "$DIR"
  done
}

if symlink_repo_dotfiles && symlink_vscode_settings; then
  echo "-> Symlinking successful. Finishing up..."
  chmod 700 "$HOME"/.gnupg
  chmod 600 "$HOME"/.gnupg/gpg.conf
  # Restart Karabiner after symlinking config
  # https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/
  KARABINER=gui/"$(id -u)"/org.pqrs.karabiner.karabiner_console_user_server
  if launchctl kickstart "$KARABINER" &>/dev/null; then
    launchctl kickstart -k "$KARABINER"
  else
    echo "-> Skipping Karabiner restart."
  fi
  echo "-> Finished."
else
  echo "-> Symlinking unsuccessful."
  ! [ -d "$HOME"/.dotfiles ] && echo "-> Error: Dotfiles directory not found."
fi
