<#
.SYNOPSIS
    Builds the Flutter web app and publishes it to the GitHub Pages hosting repo.

.DESCRIPTION
    This project is split across two repositories:

      * source  - muhammed-shadil/flutter-portfolio  (this repo)
      * hosting - muhammed-shadil/Shadil-Portfolio   (build/web committed at root)

    GitHub Pages serves the hosting repo from a sub-path, so the build must be
    made with --base-href /Shadil-Portfolio/ or every asset URL resolves against
    the domain root and the page loads to a blank screen.

.PARAMETER Message
    Commit message for the deploy. Defaults to "web updated <timestamp>".

.PARAMETER DryRun
    Build, stage and show what would change, but do not commit or push.

.EXAMPLE
    .\deploy.ps1
    .\deploy.ps1 -Message "fix dark mode"
    .\deploy.ps1 -DryRun
#>

[CmdletBinding()]
param(
    [string]$Message,
    [switch]$DryRun
)

# NOTE: deliberately not 'Stop'. In Windows PowerShell 5.1 anything a native exe
# writes to stderr becomes a NativeCommandError, and with 'Stop' that aborts the
# script - flutter's harmless "Wasm dry run findings" notice would kill the deploy.
# Native commands are checked explicitly via $LASTEXITCODE instead; cmdlets that
# must not fail silently carry their own -ErrorAction Stop.
$ErrorActionPreference = 'Continue'

# ---------------------------------------------------------------- configuration
$HostingRepo = 'https://github.com/muhammed-shadil/Shadil-Portfolio.git'
$Branch      = 'master'
# Must match the repo name exactly, with leading and trailing slashes.
$BaseHref    = '/Shadil-Portfolio/'
$LiveUrl     = 'https://muhammed-shadil.github.io/Shadil-Portfolio/'

$ProjectDir = $PSScriptRoot
$BuildDir   = Join-Path $ProjectDir 'build\web'
$CloneDir   = Join-Path ([System.IO.Path]::GetTempPath()) 'shadil-portfolio-deploy'

function Write-Step($text) { Write-Host "`n==> $text" -ForegroundColor Cyan }
function Fail($text) { Write-Host "ERROR: $text" -ForegroundColor Red; exit 1 }

if (-not $Message) {
    $Message = "web updated " + (Get-Date -Format 'yyyy-MM-dd HH:mm')
}

# ---------------------------------------------------------------- sanity checks
foreach ($tool in @('flutter', 'git')) {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        Fail "'$tool' was not found on PATH."
    }
}

# ---------------------------------------------------------------- 1. build
Write-Step "Building web release (base-href $BaseHref)"
Push-Location $ProjectDir
try {
    flutter build web --base-href $BaseHref
    if ($LASTEXITCODE -ne 0) { Fail 'flutter build web failed.' }
}
finally {
    Pop-Location
}

if (-not (Test-Path (Join-Path $BuildDir 'index.html'))) {
    Fail "Build finished but $BuildDir\index.html is missing."
}

# Guard against publishing a build made for the wrong path.
$indexHtml = Get-Content (Join-Path $BuildDir 'index.html') -Raw
if ($indexHtml -notmatch [regex]::Escape("<base href=""$BaseHref"">")) {
    Fail "index.html does not contain <base href=""$BaseHref"">. Refusing to publish a build that would 404 on GitHub Pages."
}

# ---------------------------------------------------------------- 2. get hosting repo
Write-Step 'Fetching hosting repo'
if (Test-Path $CloneDir) { Remove-Item $CloneDir -Recurse -Force -ErrorAction Stop }
git clone --quiet --depth 1 --branch $Branch $HostingRepo $CloneDir
if ($LASTEXITCODE -ne 0) { Fail 'git clone failed.' }
if (-not (Test-Path (Join-Path $CloneDir '.git'))) { Fail 'Clone produced no .git directory.' }

# ---------------------------------------------------------------- 3. swap contents
Write-Step 'Replacing site contents with the new build'
Get-ChildItem -Path $CloneDir -Force |
    Where-Object { $_.Name -ne '.git' } |
    Remove-Item -Recurse -Force -ErrorAction Stop

Get-ChildItem -Path $BuildDir -Force |
    Copy-Item -Destination $CloneDir -Recurse -Force -ErrorAction Stop

if (-not (Test-Path (Join-Path $CloneDir 'index.html'))) {
    Fail 'Copy did not produce an index.html in the clone.'
}

# ---------------------------------------------------------------- 4. publish
git -C $CloneDir add -A
if ($LASTEXITCODE -ne 0) { Fail 'git add failed.' }

$pending = git -C $CloneDir status --porcelain
if ([string]::IsNullOrWhiteSpace($pending)) {
    Write-Host "`nSite is already up to date - nothing to deploy." -ForegroundColor Yellow
    Remove-Item $CloneDir -Recurse -Force
    exit 0
}

$changedCount = ($pending -split "`n" | Where-Object { $_.Trim() }).Count
Write-Host "$changedCount path(s) changed:"
git -C $CloneDir status --short | Select-Object -First 15

if ($DryRun) {
    Write-Host "`n[DryRun] Skipping commit and push. Staged clone left at:" -ForegroundColor Yellow
    Write-Host "  $CloneDir"
    exit 0
}

Write-Step 'Committing and pushing'
git -C $CloneDir commit --quiet -m $Message
if ($LASTEXITCODE -ne 0) { Fail 'git commit failed.' }

git -C $CloneDir push origin $Branch
if ($LASTEXITCODE -ne 0) { Fail 'git push failed - check your GitHub credentials.' }

Remove-Item $CloneDir -Recurse -Force

Write-Host "`nDeployed. GitHub Pages usually refreshes within a minute:" -ForegroundColor Green
Write-Host "  $LiveUrl"
