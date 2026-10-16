# SkylineGlass

A fixed city wallpaper behind Spotify’s glass panels, with readable lyrics and a background that stays still in fullscreen.

SkylineGlass is a companion extension for [LiquidMusic by fraustiz](https://github.com/fraustiz/LiquidMusic). The installer downloads LiquidMusic directly from its upstream repository at a fixed revision; its source is not bundled or claimed as SkylineGlass’s work.

## What you get

- The included city wallpaper in normal and fullscreen song views.
- An in-app settings panel with a custom wallpaper picker, darkness and blur sliders, fixed accent colors, lyric brightness, and clock controls.
- A saved Slide or Fade song transition setting for fullscreen playback.
- A local 12-hour clock centered in the fullscreen top row, without seconds.
- A stationary backdrop while synchronized lyrics scroll.
- Upcoming lyrics at 70% white, the current line in full white, and past lines at 50% white.
- A subtle text shadow and darker wallpaper for contrast.
- LiquidMusic’s glass panels and floating player. Its accent colors still follow album artwork.

The default city wallpaper is embedded in `skylineglass.js`. Use the **gear icon** at the bottom right of Spotify (including fullscreen) to open SkylineGlass settings. Appearance controls apply live and save locally across restarts. Changing or resetting the wallpaper automatically refreshes the Spotify view after saving, to avoid a stale backdrop. You can select a JPG, PNG, or WebP wallpaper up to 10 MB, restore the included city image, adjust darkness and blur, choose an album-based or fixed accent, brighten upcoming lyrics, and hide the clock or use 24-hour time. **Reset settings** restores the original look. Custom wallpapers are stored locally in Spotify’s browser storage; they are not uploaded or synced. Clearing Spotify browser data may reset these preferences. Wallpapers do not automatically follow the desktop.

## Install

Install [Spotify desktop and Spicetify](https://spicetify.app/docs/getting-started) first, with a working Spicetify backup. Marketplace is optional for this installer.

### macOS / Linux

```sh
curl -fsSL https://raw.githubusercontent.com/iEli/SkylineGlass/main/install.sh | sh
```

### Windows PowerShell

```powershell
& ([scriptblock]::Create((Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/iEli/SkylineGlass/main/install.ps1).Content))
```

You can also download and inspect the installer before running it. The installers select LiquidMusic’s dark scheme, enable the theme’s CSS and JavaScript, disable sidebar configuration, add `skylineglass.js` alongside existing extensions, and apply/restart Spotify. Previous config and overwritten files are saved under `SkylineGlass-backups` in Spicetify’s config directory.

Spicetify has no native `pull` command: the installer downloads the files, then uses `spicetify config` and `spicetify apply restart` to enable them. Run the same installer to update.

## Manual installation

1. Install LiquidMusic using its upstream instructions or Marketplace.
2. Download [`skylineglass.js`](https://raw.githubusercontent.com/iEli/SkylineGlass/main/skylineglass.js).
3. Run `spicetify path userdata` and put the downloaded file into the `Extensions` folder there.
4. Run:

```sh
spicetify config extensions skylineglass.js
spicetify apply restart
```

If upgrading from the earlier private `desktop-wallpaper.js` pack, disable that extension first with `spicetify config extensions desktop-wallpaper.js-` so the two overrides do not compete.

## Remove

```sh
spicetify config extensions skylineglass.js-
spicetify apply restart
```

This removes the wallpaper and lyrics overrides; LiquidMusic remains active. To restore your previous setup, copy your saved config back to the path printed by `spicetify -c`, then run `spicetify apply restart`. Optionally re-enable sidebar configuration with `spicetify config sidebar_config 1`.

## Compatibility

The extension was verified on macOS with Spotify 1.3.5.3058, Spicetify 2.45.3, and LiquidMusic. The macOS/Linux installer is tested with a simulated Spicetify installation; Windows installation is supplied but has not been run on Windows. Spotify or LiquidMusic updates may require selector adjustments.

LiquidMusic dependency revision: `457dbc8c709e9f020abe18666cfdd1a8bc35c19a`.

No account data, credentials, or personal machine paths are included. The city wallpaper is included; no separate image license or authorship claim is supplied.
