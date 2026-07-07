# wallpaper

Terminal command to switch the GNOME desktop background: `wallpaper <key>`.

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

`install.sh` installs `jq` if missing, creates `config.json` from `config.example.json` if you don't already have one, and symlinks `wallpaper.sh` to `~/.local/bin/wallpaper`.

## Usage

```bash
wallpaper p1     # sets background to config.json's "p1" path
wallpaper        # lists available keys
```

Sets both `picture-uri` and `picture-uri-dark` via `gsettings`, so it applies in both GNOME light and dark mode.
