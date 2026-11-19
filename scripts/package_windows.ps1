<#
Builds the Windows release once and packages it into dist\ (windows-2022 runner):
  InvoiceDesk-Setup-x64.exe     Inno Setup, per-user by default
  InvoiceDesk-Windows-x64.zip   portable folder
  InvoiceDesk-x64.msix          unsigned, for a Microsoft Store submission only
The VC++ runtime DLLs are copied next to invoice_desk.exe (app-local) and every
DLL the bundle imports is checked to be either in the bundle or part of Windows,
so the app starts on a clean Windows.

  pwsh scripts/package_windows.ps1 [-SkipBuild] [-NoInstaller] [-NoMsix]

Version comes from pubspec.yaml unless $env:VERSION / $env:BUILD_NUMBER are set.
MSIX identity: $env:MSIX_IDENTITY_NAME, $env:MSIX_PUBLISHER, $env:MSIX_PUBLISHER_DISPLAY_NAME
(placeholders with a warning when unset).
#>
param([switch]$SkipBuild, [switch]$NoInstaller, [switch]$NoMsix)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$root = Resolve-Path (Join-Path $PSScriptRoot '..')
Set-Location $root

$pub = (Select-String -Path pubspec.yaml -Pattern '^version:\s*(\S+)').Matches[0].Groups[1].Value
$version = if ($env:VERSION) { $env:VERSION } else { $pub.Split('+')[0] }
$build = if ($env:BUILD_NUMBER) { $env:BUILD_NUMBER } elseif ($pub.Contains('+')) { $pub.Split('+')[1] } else { '1' }
if ($version -notmatch '^\d+\.\d+\.\d+$') { throw "bad version '$version'" }
Write-Host "==> Invoice Desk $version (build $build)"

if (-not $SkipBuild) {
  flutter build windows --release --build-name=$version --build-number=$build
  if ($LASTEXITCODE -ne 0) { throw 'flutter build windows failed' }
}
$bundle = Join-Path $root 'build\windows\x64\runner\Release'
if (-not (Test-Path (Join-Path $bundle 'invoice_desk.exe'))) { throw "no bundle at $bundle" }

$dist = Join-Path $root 'dist'
Remove-Item -Recurse -Force $dist -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force $dist | Out-Null

# ── Visual Studio tools ────────────────────────────────────────────────
$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$vs = & $vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
if (-not $vs) { throw 'Visual Studio C++ tools not found' }
$crt = Get-ChildItem "$vs\VC\Redist\MSVC\*\x64\Microsoft.VC14*.CRT" -Directory | Sort-Object FullName | Select-Object -Last 1
if (-not $crt) { throw 'VC++ redistributable folder not found' }
$dumpbin = Get-ChildItem "$vs\VC\Tools\MSVC\*\bin\Hostx64\x64\dumpbin.exe" | Sort-Object FullName | Select-Object -Last 1
if (-not $dumpbin) { throw 'dumpbin.exe not found' }

# ── no JVM ─────────────────────────────────────────────────────────────
# Transitive `jni` (Android-only use, via path_provider_android) builds
# dartjni.dll whenever CMake finds a JDK (the runner has one). Its
# /DELAYLOAD:jvm.dll never applies, so it hard-imports jvm.dll, and nothing
# opens it on desktop. Removed from every package (owner ruling 2026-11-19,
# docs/worklog/REL-02.md). The DLL check below fails on any jvm.dll import.
Remove-Item (Join-Path $bundle 'dartjni.dll') -Force -ErrorAction SilentlyContinue

# ── app-local VC++ runtime ─────────────────────────────────────────────
Copy-Item "$($crt.FullName)\*.dll" $bundle -Force
Write-Host "==> VC++ runtime from $($crt.FullName)"
if (-not (Test-Path (Join-Path $bundle 'sqlite3.dll'))) {
  Get-ChildItem $bundle -Recurse -Filter *.dll | ForEach-Object { Write-Host "bundle: $($_.FullName.Substring($bundle.Length))" }
  throw 'sqlite3.dll is missing from the bundle (native assets not installed? see windows/CMakeLists.txt)'
}

# ── every imported DLL is bundled or part of Windows ───────────────────
$bundled = @{}
Get-ChildItem $bundle -Recurse -Include *.dll, *.exe | ForEach-Object { $bundled[$_.Name.ToLower()] = $true }
$system32 = Join-Path $env:WINDIR 'System32'
$missing = @()
foreach ($bin in Get-ChildItem $bundle -Recurse -Include *.dll, *.exe) {
  $deps = & $dumpbin.FullName /nologo /dependents $bin.FullName |
    Where-Object { $_ -match '^\s+(\S+\.dll)\s*$' } | ForEach-Object { $Matches[1].ToLower() }
  foreach ($d in $deps) {
    if ($d -eq 'jvm.dll') { $missing += "$($bin.Name) -> $d (needs a JVM)"; continue }
    if ($bundled.ContainsKey($d)) { continue }
    # Redistributable runtimes are on the runner but not on a clean Windows.
    $redist = $d -match '^(msvcp|vcruntime|concrt|vccorlib|vcomp|ucrtbased)'
    $os = $d -like 'api-ms-win-*' -or $d -like 'ext-ms-*' -or (Test-Path (Join-Path $system32 $d))
    if ($redist -or -not $os) { $missing += "$($bin.Name) -> $d" }
  }
}
if ($missing) { $missing | ForEach-Object { Write-Host "missing: $_" }; throw 'bundle imports DLLs a clean Windows does not have' }
Write-Host '==> every imported DLL is bundled or part of Windows'

# ── portable zip ───────────────────────────────────────────────────────
$stage = Join-Path $dist 'stage'
$portable = Join-Path $stage 'InvoiceDesk'
New-Item -ItemType Directory -Force $portable | Out-Null
Copy-Item "$bundle\*" $portable -Recurse
Set-Content -Path (Join-Path $portable 'VERSION.txt') -Value $version -Encoding ascii
Compress-Archive -Path $portable -DestinationPath (Join-Path $dist 'InvoiceDesk-Windows-x64.zip') -CompressionLevel Optimal
Write-Host '==> InvoiceDesk-Windows-x64.zip'

# ── installer ──────────────────────────────────────────────────────────
if (-not $NoInstaller) {
  $iscc = "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe"
  if (-not (Test-Path $iscc)) { throw "Inno Setup not found at $iscc" }
  & $iscc /Q "/DAppVersion=$version" "/DBuildNumber=$build" "/DBundleDir=$bundle" "/DOutputDir=$dist" packaging\windows\invoice-desk.iss
  if ($LASTEXITCODE -ne 0) { throw 'ISCC failed' }
  Write-Host '==> InvoiceDesk-Setup-x64.exe'
}

# ── MSIX (Store submission only, never a release asset) ────────────────
if (-not $NoMsix) {
  $name = $env:MSIX_IDENTITY_NAME; $publisher = $env:MSIX_PUBLISHER; $display = $env:MSIX_PUBLISHER_DISPLAY_NAME
  if (-not ($name -and $publisher -and $display)) {
    Write-Host '::warning::MSIX identity variables are not set; using placeholders (not submittable to the Store)'
    $name = 'InvoiceDesk.Placeholder'; $publisher = 'CN=InvoiceDesk-Placeholder'; $display = 'Omar Maarouf'
  }
  $msixDir = Join-Path $stage 'msix'
  New-Item -ItemType Directory -Force $msixDir | Out-Null
  Copy-Item "$bundle\*" $msixDir -Recurse
  Copy-Item packaging\windows\msix\Assets (Join-Path $msixDir 'Assets') -Recurse
  $esc = { param($s) [System.Security.SecurityElement]::Escape($s) }
  (Get-Content packaging\windows\msix\AppxManifest.xml -Raw) `
    -replace '@IDENTITY_NAME@', (& $esc $name) `
    -replace '@PUBLISHER@', (& $esc $publisher) `
    -replace '@PUBLISHER_DISPLAY_NAME@', (& $esc $display) `
    -replace '@VERSION@', $version |
    Set-Content -Path (Join-Path $msixDir 'AppxManifest.xml') -Encoding utf8
  $makeappx = Get-ChildItem "${env:ProgramFiles(x86)}\Windows Kits\10\bin\*\x64\makeappx.exe" | Sort-Object FullName | Select-Object -Last 1
  if (-not $makeappx) { throw 'makeappx.exe not found' }
  & $makeappx.FullName pack /o /d $msixDir /p (Join-Path $dist 'InvoiceDesk-x64.msix')
  if ($LASTEXITCODE -ne 0) { throw 'makeappx failed' }
  Write-Host '==> InvoiceDesk-x64.msix'
}

Remove-Item -Recurse -Force $stage
Get-ChildItem $dist | Format-Table Name, Length
