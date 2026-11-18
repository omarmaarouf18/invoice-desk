<#
Smoke test for the Windows packages (windows-2022 runner):
  pwsh scripts/smoke_windows.ps1 -Installer dist\InvoiceDesk-Setup-x64.exe -Zip dist\InvoiceDesk-Windows-x64.zip
Installer: silent per-user install → Start-menu shortcut exists → launch on a
throwaway INVOICE_DESK_DATA_DIR → alive after $Seconds, database created →
close → silent uninstall → program folder gone, data folder kept.
Zip: unpack → the same launch check.
#>
param([string]$Installer, [string]$Zip, [int]$Seconds = 15)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Test-Launch([string]$exe) {
  $data = Join-Path ([IO.Path]::GetTempPath()) ("invoice-desk-smoke-" + [guid]::NewGuid())
  New-Item -ItemType Directory $data | Out-Null
  $env:INVOICE_DESK_DATA_DIR = $data
  $out = Join-Path $data 'stdout.log'; $err = Join-Path $data 'stderr.log'
  $p = Start-Process -FilePath $exe -PassThru -RedirectStandardOutput $out -RedirectStandardError $err
  Start-Sleep -Seconds $Seconds
  $alive = -not $p.HasExited
  if ($alive) {
    $null = $p.CloseMainWindow()
    if (-not $p.WaitForExit(10000)) { Stop-Process -Id $p.Id -Force }
  }
  Remove-Item Env:\INVOICE_DESK_DATA_DIR
  Get-Content $out, $err -ErrorAction SilentlyContinue
  if (-not $alive) { throw "app exited early (exit code $($p.ExitCode))" }
  if (-not (Test-Path (Join-Path $data 'invoice_desk.sqlite'))) { throw 'database was not created' }
  if (Select-String -Path $out, $err -Pattern 'Unhandled Exception|\[ERROR:flutter|Exception caught by' -Quiet -ErrorAction SilentlyContinue) {
    throw 'Dart exception during smoke run'
  }
  return $data
}

if ($Installer) {
  $log = Join-Path ([IO.Path]::GetTempPath()) 'invoice-desk-setup.log'
  $p = Start-Process -FilePath (Resolve-Path $Installer) -Wait -PassThru `
    -ArgumentList '/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART', '/CURRENTUSER', "/LOG=$log"
  if ($p.ExitCode -ne 0) { Get-Content $log; throw "installer exit code $($p.ExitCode)" }
  $dir = Join-Path $env:LOCALAPPDATA 'Programs\Invoice Desk'
  $exe = Join-Path $dir 'invoice_desk.exe'
  if (-not (Test-Path $exe)) { Get-Content $log; throw "not installed at $exe" }
  $lnk = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Invoice Desk.lnk'
  if (-not (Test-Path $lnk)) { throw "no Start-menu shortcut at $lnk" }
  $version = (Get-Item $exe).VersionInfo
  Write-Host "installed $($version.ProductName) $($version.ProductVersion)"

  $data = Test-Launch $exe

  $unins = Get-ChildItem $dir -Filter 'unins*.exe' | Select-Object -First 1
  if (-not $unins) { throw 'no uninstaller' }
  Start-Process -FilePath $unins.FullName -Wait -ArgumentList '/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART'
  # The uninstaller re-launches itself from %TEMP%; wait for the files to go.
  for ($i = 0; $i -lt 60 -and (Test-Path $exe); $i++) { Start-Sleep -Seconds 1 }
  if (Test-Path $exe) { throw 'uninstall left the program behind' }
  if (Test-Path $lnk) { throw 'uninstall left the Start-menu shortcut' }
  if (-not (Test-Path (Join-Path $data 'invoice_desk.sqlite'))) { throw 'uninstall touched the data folder' }
  Write-Host "smoke OK: $(Split-Path $Installer -Leaf)"
}

if ($Zip) {
  $dest = Join-Path ([IO.Path]::GetTempPath()) ("invoice-desk-zip-" + [guid]::NewGuid())
  Expand-Archive -Path $Zip -DestinationPath $dest
  $null = Test-Launch (Join-Path $dest 'InvoiceDesk\invoice_desk.exe')
  Write-Host "smoke OK: $(Split-Path $Zip -Leaf)"
}
