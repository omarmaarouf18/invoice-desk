; Inno Setup script for InvoiceDesk-Setup-x64.exe (Inno Setup 6, preinstalled
; on the windows-2022 runner). scripts/package_windows.ps1 passes:
;   /DAppVersion=X.Y.Z /DBuildNumber=N /DBundleDir=<Release folder> /DOutputDir=<dist>
; Per-user install by default (no admin prompt); an admin can still choose
; "install for all users". User data lives in %APPDATA% and is never touched
; by install, upgrade or uninstall.
#ifndef AppVersion
  #error AppVersion is required
#endif
#ifndef BuildNumber
  #define BuildNumber "0"
#endif

[Setup]
; Never change AppId: it ties upgrades and the uninstaller together.
AppId={{E2B4E153-77EE-42D9-A167-BB54A1AE7C8F}
AppName=Invoice Desk
AppVersion={#AppVersion}
AppVerName=Invoice Desk {#AppVersion}
AppPublisher=Omar Maarouf
AppPublisherURL=https://github.com/omarmaarouf18/invoice-desk
AppSupportURL=https://github.com/omarmaarouf18/invoice-desk/issues
AppUpdatesURL=https://github.com/omarmaarouf18/invoice-desk/releases/latest
AppCopyright=Copyright (C) 2026 Omar Maarouf
VersionInfoVersion={#AppVersion}.{#BuildNumber}
VersionInfoProductName=Invoice Desk
VersionInfoProductVersion={#AppVersion}
VersionInfoCompany=Omar Maarouf
VersionInfoDescription=Invoice Desk installer
DefaultDirName={autopf}\Invoice Desk
DefaultGroupName=Invoice Desk
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog commandline
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
MinVersion=10.0.17763
OutputDir={#OutputDir}
OutputBaseFilename=InvoiceDesk-Setup-x64
SetupIconFile=..\..\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\invoice_desk.exe
UninstallDisplayName=Invoice Desk
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
CloseApplications=yes
RestartApplications=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
#if FileExists(AddBackslash(CompilerPath) + "Languages\Arabic.isl")
Name: "arabic"; MessagesFile: "compiler:Languages\Arabic.isl"
#endif

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#BundleDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\Invoice Desk"; Filename: "{app}\invoice_desk.exe"
Name: "{autodesktop}\Invoice Desk"; Filename: "{app}\invoice_desk.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\invoice_desk.exe"; Description: "{cm:LaunchProgram,Invoice Desk}"; Flags: nowait postinstall skipifsilent
