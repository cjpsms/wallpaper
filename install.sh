#!/bin/bash
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"

if ! command -v jq >/dev/null 2>&1; then
  echo "Installing jq..."
  sudo apt install -y jq
fi

mkdir -p ~/.local/bin
ln -sf "$DIR/wallpaper.sh" ~/.local/bin/wallpaper
echo "Installed: wallpaper -> $DIR/wallpaper.sh"

case ":$PATH:" in
  *:"$HOME/.local/bin":*) ;;
  *) echo "Note: ~/.local/bin is not on your PATH — add it to your shell profile." ;;
esac
