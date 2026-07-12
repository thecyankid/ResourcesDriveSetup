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

Write-Host "Scheduled Task created."

# ==========================================================
# Apply Windows System Settings
# ==========================================================

Write-Host ""
Write-Host "Applying Windows configuration..."

$SystemSettings = Join-Path $PSScriptRoot "SystemSettings.ps1"

if (Test-Path $SystemSettings)
{
    & powershell.exe `
        -ExecutionPolicy Bypass `
        -File $SystemSettings
}
else
{
    Write-Warning "SystemSettings.ps1 not found."
}

exit 0