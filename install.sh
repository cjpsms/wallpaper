#!/bin/bash
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"

install_pkg() {
  if command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm "$@"
  elif command -v apt >/dev/null 2>&1; then
    sudo apt install -y "$@"
  else
    echo "Unsupported package manager — install manually: $*"
    exit 1
  fi
}

if ! command -v jq >/dev/null 2>&1; then
  echo "Installing jq..."
  install_pkg jq
fi

if ! command -v gsettings >/dev/null 2>&1 && ! command -v swaybg >/dev/null 2>&1; then
  echo "Installing swaybg (wallpaper backend for non-GNOME Wayland compositors, e.g. niri/sway)..."
  install_pkg swaybg
fi

if [ ! -f "$DIR/config.json" ]; then
  cp "$DIR/config.example.json" "$DIR/config.json"
  echo "Created config.json from config.example.json — edit it to point at your own wallpapers."
fi

mkdir -p ~/.local/bin
ln -sf "$DIR/wallpaper.sh" ~/.local/bin/wp
echo "Installed: wp -> $DIR/wallpaper.sh"

case ":$PATH:" in
  *:"$HOME/.local/bin":*) ;;
  *) echo "Note: ~/.local/bin is not on your PATH — add it to your shell profile." ;;
esac
