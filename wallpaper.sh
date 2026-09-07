#!/bin/bash
# wp <key> — set desktop background from config.json { "key": "/path/to/image" }
DIR="$(dirname "$(readlink -f "$0")")"
CONFIG="$DIR/config.json"
KEY="$1"

if [ -z "$KEY" ]; then
  echo "Usage: wp <key>"
  echo "Available: $(jq -r 'keys | join(", ")' "$CONFIG")"
  exit 1
fi

IMG=$(jq -r --arg k "$KEY" '.[$k] // empty' "$CONFIG")
if [ -z "$IMG" ]; then
  echo "Unknown key: $KEY"
  echo "Available: $(jq -r 'keys | join(", ")' "$CONFIG")"
  exit 1
fi

IMG="${IMG/#\~/$HOME}"
if [ ! -f "$IMG" ]; then
  echo "File not found: $IMG"
  exit 1
fi

if command -v gsettings >/dev/null 2>&1 && pgrep -x gnome-shell >/dev/null 2>&1; then
  gsettings set org.gnome.desktop.background picture-uri "file://$IMG"
  gsettings set org.gnome.desktop.background picture-uri-dark "file://$IMG"
elif command -v swaybg >/dev/null 2>&1; then
  pkill -x swaybg 2>/dev/null
  setsid swaybg -i "$IMG" -m fill >/dev/null 2>&1 &
  disown
else
  echo "No supported backend found (need GNOME's gsettings, or swaybg for other Wayland compositors)."
  exit 1
fi
echo "wp: $KEY -> $IMG"
