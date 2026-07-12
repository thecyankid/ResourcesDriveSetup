# Resources Drive Setup
# Install.ps1

$ErrorActionPreference = "Stop"

$ConfigPath = "$PSScriptRoot\..\Config\config.json"

if (!(Test-Path $ConfigPath))
{
    Write-Host "Configuration file not found."
    exit 1
}

$config = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json

# Create log folder
if (!(Test-Path $config.logPath))
{
    New-Item `
        -ItemType Directory `
        -Force `
        -Path $config.logPath | Out-Null
}

Write-Host "Mapping network drive..."

& powershell.exe `
    -ExecutionPolicy Bypass `
    -File "$PSScriptRoot\MapDrive.ps1"

if ($LASTEXITCODE -ne 0)
{
    Write-Error "Drive mapping failed. Installation aborted."
    exit $LASTEXITCODE
}

Write-Host "Network drive mapped successfully."

$TaskName = $config.taskName

$Action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-ExecutionPolicy Bypass -File `"$PSScriptRoot\MapDrive.ps1`""

$Trigger = New-ScheduledTaskTrigger -AtLogOn

Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $Action `
    -Trigger $Trigger `
    -RunLevel Highest `
    -Force | Out-Null

Write-Host "Scheduled Task created successfully."

# ==========================================================
# Apply Windows System Settings
# ==========================================================

Write-Host ""
Write-Host "Applying system configuration..."

$SystemSettings = Join-Path $PSScriptRoot "SystemSettings.ps1"

if (Test-Path $SystemSettings)
{
    & powershell.exe `
        -ExecutionPolicy Bypass `
        -File $SystemSettings

   if ($LASTEXITCODE -ne 0)
{
    Write-Error "System configuration failed."
    exit $LASTEXITCODE
}     
}
else
{
    Write-Warning "SystemSettings.ps1 not found."
}

Write-Host ""
Write-Host "Resources Drive Setup completed successfully."
Write-Host ""

exit 0