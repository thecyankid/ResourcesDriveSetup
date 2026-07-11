;=========================================================
; Resources Drive Setup
; Version 1.0
;=========================================================

#define MyAppName "Resources Drive Setup"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "DBC Computer Lab"
#define MyAppExeName "Install.ps1"

[Setup]
VersionInfoVersion=1.0.0
VersionInfoCompany=DBC Computer Lab
VersionInfoDescription=Resources Drive Setup
VersionInfoCopyright=DBC Computer Lab

DefaultDirName={autopf}\Resources Drive Setup
DefaultGroupName=Resources Drive Setup

PrivilegesRequired=admin

OutputDir=Output
OutputBaseFilename=ResourcesDriveSetup

Compression=lzma2
SolidCompression=yes
WizardStyle=modern

UninstallDisplayIcon={app}\Install.ps1

DisableProgramGroupPage=yes

ArchitecturesInstallIn64BitMode=x64

SetupLogging=yes

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