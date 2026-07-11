;=========================================================
; Resources Drive Setup
; Version 1.0
;=========================================================

#define MyAppName "Resources Drive Setup"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "DBC Computer Lab"
#define MyAppExeName "Install.ps1"

[Setup]

AppId={{C5A8A26E-1B7E-4E51-9D46-0F8D3E22B101}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}

AppPublisherURL=https://github.com/thecyankid/ResourcesDriveSetup
AppSupportURL=https://github.com/thecyankid/ResourcesDriveSetup
AppUpdatesURL=https://github.com/thecyankid/ResourcesDriveSetup/releases

DefaultDirName={autopf}\Resources Drive Setup
DefaultGroupName=Resources Drive Setup

CreateUninstallRegKey=yes
Uninstallable=yes

PrivilegesRequired=admin

Compression=lzma2
SolidCompression=yes
WizardStyle=modern

ArchitecturesInstallIn64BitMode=x64

OutputDir=Output
OutputBaseFilename=ResourcesDriveSetup

SetupLogging=yes

SetupIconFile=Setup.ico
WizardImageFile=WizardLarge.bmp
WizardSmallImageFile=WizardSmall.bmp

[Files]

Source: "..\Scripts\*"; DestDir: "{app}\Scripts"; Flags: ignoreversion recursesubdirs createallsubdirs

Source: "..\Config\*"; DestDir: "{app}\Config"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]

Name: "{group}\Resources Drive Setup"; Filename: "{app}\Scripts\Install.ps1"

[Run]

Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; \
Parameters: "-ExecutionPolicy Bypass -File ""{app}\Scripts\Install.ps1"""; \
Flags: runhidden waituntilterminated

[UninstallRun]

Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; \
Parameters: "-ExecutionPolicy Bypass -File ""{app}\Scripts\Uninstall.ps1"""; \
Flags: runhidden waituntilterminated