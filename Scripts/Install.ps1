# Resources Drive Setup
# Install.ps1

$ConfigPath = "$PSScriptRoot\..\Config\config.json"

if (!(Test-Path $ConfigPath))
{
    Write-Host "Configuration file not found."
    exit 1
}

$config = Get-Content $ConfigPath | ConvertFrom-Json

# Create log folder
if (!(Test-Path $config.logPath))
{
    New-Item `
        -ItemType Directory `
        -Force `
        -Path $config.logPath | Out-Null
}

Write-Host "Running drive mapping..."

powershell.exe `
    -ExecutionPolicy Bypass `
    -File "$PSScriptRoot\MapDrive.ps1"

Write-Host "Installation Complete."

exit 0