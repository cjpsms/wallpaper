#!/bin/bash
# wp <key>      — set desktop background from config.json { "key": "/path/to/image" }
# wp <filename> — if not a known key: a bare filename is looked up in config.json's "dir",
#                 a path (contains "/" or starts with ~) is used as-is
DIR="$(dirname "$(readlink -f "$0")")"
CONFIG="$DIR/config.json"

list_keys() {
  jq -r 'to_entries | map(select(.key != "dir")) | map(.key) | join(", ")' "$CONFIG"
}

set_wallpaper() {
  local IMG="$1"
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
}

NAME="$1"
if [ -z "$NAME" ]; then
  echo "Usage: wp <key>"
  echo "       wp <filename>   (grab a file directly from config.json's \"dir\")"
  echo "Available: $(list_keys)"
  exit 1
fi

IMG=$(jq -r --arg k "$NAME" '.[$k] // empty' "$CONFIG")

if [ -n "$IMG" ]; then
  IMG="${IMG/#\~/$HOME}"
  if [ ! -f "$IMG" ]; then
    echo "File not found: $IMG"
    exit 1
  fi
  set_wallpaper "$IMG"
  echo "wp: $NAME -> $IMG"
  exit 0
fi

if [[ "$NAME" == /* || "$NAME" == */* || "$NAME" == ~* ]]; then
  IMG="$NAME"
else
  WPDIR=$(jq -r '.dir // empty' "$CONFIG")
  if [ -z "$WPDIR" ]; then
    echo "Unknown key: $NAME"
    echo "Available: $(list_keys)"
    exit 1
  fi
  WPDIR="${WPDIR/#\~/$HOME}"
  IMG="$WPDIR/$NAME"
fi

IMG="${IMG/#\~/$HOME}"
if [ ! -f "$IMG" ]; then
  echo "Unknown key or file not found: $NAME"
  echo "Available: $(list_keys)"
  exit 1
fi

set_wallpaper "$IMG"
echo "wp: $IMG"
