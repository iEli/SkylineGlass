$ErrorActionPreference = 'Stop'
if (-not (Get-Command spicetify -ErrorAction SilentlyContinue)) { throw 'Install Spicetify first: https://spicetify.app/docs/getting-started' }
$config = (spicetify -c | Out-String).Trim()
if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $config)) { throw 'Spicetify config not found' }
$root = Split-Path -Parent $config
$temp = Join-Path ([IO.Path]::GetTempPath()) ([Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $temp | Out-Null
try {
 $upstream = 'https://raw.githubusercontent.com/fraustiz/LiquidMusic/457dbc8c709e9f020abe18666cfdd1a8bc35c19a'
 foreach ($file in @('color.ini', 'user.css', 'theme.js')) {
  Invoke-WebRequest -UseBasicParsing -Uri "$upstream/$file" -OutFile (Join-Path $temp $file)
 }
 Invoke-WebRequest -UseBasicParsing -Uri 'https://raw.githubusercontent.com/iEli/SkylineGlass/main/skylineglass.js' -OutFile (Join-Path $temp 'skylineglass.js')
 $backup = Join-Path $root ('SkylineGlass-backups/' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [Guid]::NewGuid().ToString())
 $theme = Join-Path $root 'Themes/LiquidMusic'
 $extensions = Join-Path $root 'Extensions'
 New-Item -ItemType Directory -Force -Path $backup, $theme, $extensions | Out-Null
 Copy-Item -LiteralPath $config -Destination (Join-Path $backup 'config-xpui.ini')
 foreach ($file in @('color.ini', 'user.css', 'theme.js')) {
  $target = Join-Path $theme $file
  if (Test-Path -LiteralPath $target) { Copy-Item -LiteralPath $target -Destination (Join-Path $backup $file) }
  Copy-Item -LiteralPath (Join-Path $temp $file) -Destination $target
 }
 $target = Join-Path $extensions 'skylineglass.js'
 if (Test-Path -LiteralPath $target) { Copy-Item -LiteralPath $target -Destination (Join-Path $backup 'skylineglass.js') }
 Copy-Item -LiteralPath (Join-Path $temp 'skylineglass.js') -Destination $target
 spicetify config current_theme LiquidMusic color_scheme dark inject_css 1 replace_colors 1 inject_theme_js 1 sidebar_config 0
 if ($LASTEXITCODE -ne 0) { throw 'Could not configure theme' }
 spicetify config extensions skylineglass.js
 if ($LASTEXITCODE -ne 0) { throw 'Could not enable SkylineGlass' }
 spicetify apply restart
 if ($LASTEXITCODE -ne 0) { throw 'Spicetify apply failed; check your Spotify backup and permissions' }
 Write-Host "SkylineGlass installed. Previous configuration saved in $backup"
} finally { Remove-Item -LiteralPath $temp -Recurse -Force }
