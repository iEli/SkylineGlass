#!/bin/sh
set -eu
command -v spicetify >/dev/null 2>&1 || { echo "Install Spicetify first: https://spicetify.app/docs/getting-started" >&2; exit 1; }
command -v curl >/dev/null 2>&1 || { echo "curl is required" >&2; exit 1; }
skyline_config=$(spicetify -c)
[ -f "$skyline_config" ] || { echo "Spicetify config not found" >&2; exit 1; }
skyline_root=$(dirname "$skyline_config")
skyline_tmp=$(mktemp -d)
trap 'rm -rf "$skyline_tmp"' EXIT HUP INT TERM
skyline_base=https://raw.githubusercontent.com/iEli/SkylineGlass/main
skyline_upstream=https://raw.githubusercontent.com/fraustiz/LiquidMusic/457dbc8c709e9f020abe18666cfdd1a8bc35c19a
# Download everything before changing the installation.
for skyline_file in color.ini user.css theme.js; do
 curl -fLsS "$skyline_upstream/$skyline_file" -o "$skyline_tmp/$skyline_file"
 test -s "$skyline_tmp/$skyline_file"
done
curl -fLsS "$skyline_base/skylineglass.js" -o "$skyline_tmp/skylineglass.js"
test -s "$skyline_tmp/skylineglass.js"
skyline_backup="$skyline_root/SkylineGlass-backups/$(date +%Y%m%d-%H%M%S)-$$"
mkdir -p "$skyline_backup" "$skyline_root/Themes/LiquidMusic" "$skyline_root/Extensions"
cp "$skyline_config" "$skyline_backup/config-xpui.ini"
for skyline_file in color.ini user.css theme.js; do
 if [ -f "$skyline_root/Themes/LiquidMusic/$skyline_file" ]; then
  cp "$skyline_root/Themes/LiquidMusic/$skyline_file" "$skyline_backup/$skyline_file"
 fi
 cp "$skyline_tmp/$skyline_file" "$skyline_root/Themes/LiquidMusic/$skyline_file"
done
if [ -f "$skyline_root/Extensions/skylineglass.js" ]; then
 cp "$skyline_root/Extensions/skylineglass.js" "$skyline_backup/skylineglass.js"
fi
cp "$skyline_tmp/skylineglass.js" "$skyline_root/Extensions/skylineglass.js"
spicetify config current_theme LiquidMusic color_scheme dark inject_css 1 replace_colors 1 inject_theme_js 1 sidebar_config 0
spicetify config extensions skylineglass.js
spicetify apply restart
printf 'SkylineGlass installed. Previous configuration saved in %s\n' "$skyline_backup"
