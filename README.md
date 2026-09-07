# wallpaper

Terminal command to switch the desktop background: `wp <key>`. Works on GNOME (via `gsettings`) and on other Wayland compositors like niri/sway (via `swaybg`), auto-detected at run time.

Keys are defined in `config.json` (gitignored — it's personal, not shipped) as a flat map of `key -> image path`. See `config.example.json` for the format:

```json
{
  "p1": "/usr/share/backgrounds/Monument_valley_by_orbitelambda.jpg",
  "p2": "/usr/share/backgrounds/Clouds_by_Tibor_Mokanszki.jpg"
}
```

Add more wallpapers by adding more keys — no script changes needed.

## Setup

```bash
git clone https://github.com/cjpsms/wallpaper.git
cd wallpaper
./install.sh
```

`install.sh` installs `jq` if missing (and `swaybg` too, if you're not on GNOME) via `pacman` or `apt` — whichever is present — creates `config.json` from `config.example.json` if you don't already have one, and symlinks `wallpaper.sh` to `~/.local/bin/wp`.

## Usage

```bash
wp p1     # sets background to config.json's "p1" path
wp        # lists available keys
```

On GNOME, sets both `picture-uri` and `picture-uri-dark` via `gsettings`, so it applies in both light and dark mode. On niri/sway/other wlroots compositors, it restarts `swaybg` with the new image (mode `fill`).
