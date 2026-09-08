# wallpaper

Terminal command to switch the desktop background: `wp <key>`. Works on GNOME (via `gsettings`) and on other Wayland compositors like niri/sway (via `swaybg`), auto-detected at run time.

Keys are defined in `config.json` (gitignored — it's personal, not shipped) as a flat map of `key -> image path`. See `config.example.json` for the format:

```json
{
  "dir": "~/Pictures/Wallpapers",
  "p1": "/usr/share/backgrounds/Monument_valley_by_orbitelambda.jpg",
  "p2": "/usr/share/backgrounds/Clouds_by_Tibor_Mokanszki.jpg"
}
```

Add more wallpapers by adding more keys — no script changes needed. The optional `dir` key is not a wallpaper — it's the default folder used by the filename fallback (see below).

## Setup

```bash
git clone https://github.com/cjpsms/wallpaper.git
cd wallpaper
./install.sh
```

`install.sh` installs `jq` if missing (and `swaybg` too, if you're not on GNOME) via `pacman` or `apt` — whichever is present — creates `config.json` from `config.example.json` if you don't already have one, and symlinks `wallpaper.sh` to `~/.local/bin/wp`.

## Usage

```bash
wp p1                    # sets background to config.json's "p1" path
wp                        # lists available keys
wp sunset.jpg             # not a key -> sets background to <config.json's "dir">/sunset.jpg
wp /any/full/path.jpg     # not a key -> used as the path directly
```

On GNOME, sets both `picture-uri` and `picture-uri-dark` via `gsettings`, so it applies in both light and dark mode. On niri/sway/other wlroots compositors, it restarts `swaybg` with the new image (mode `fill`).

### Filename fallback

If `wp <arg>` isn't a known key, it's treated as a file instead — handy for one-offs or a folder you drop new images into without adding them to `config.json`. A bare filename (no `/`) is resolved against `config.json`'s `dir`; anything containing a `/` (or starting with `~`) is used as the path as-is.
