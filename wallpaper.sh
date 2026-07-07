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

gsettings set org.gnome.desktop.background picture-uri "file://$IMG"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$IMG"
echo "wp: $KEY -> $IMG"
