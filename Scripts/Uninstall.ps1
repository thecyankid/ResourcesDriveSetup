# ============================================
# Resources Drive Setup
# Uninstall.ps1
# ============================================

$ConfigPath = "$PSScriptRoot\..\Config\config.json"

if (!(Test-Path $ConfigPath))
{
    Write-Host "Configuration file not found."
    exit 1
}

$config = Get-Content $ConfigPath | ConvertFrom-Json

$Drive = $config.driveLetter
$Server = $config.server
$Share = $config.share
$TaskName = $config.taskName
$LogPath = $config.logPath

$Target = "\\$Server\$Share"

Write-Host "Checking mapped drive..."

$current = Get-CimInstance Win32_LogicalDisk |
    Where-Object {$_.DeviceID -eq "$Drive:"}

if ($current)
{
    if ($current.ProviderName -eq $Target)
    {
        Write-Host "Removing mapped drive..."

        net use "$Drive:" /delete /yes | Out-Null
    }
}

Write-Host "Removing Scheduled Task..."

schtasks /Delete /TN "$TaskName" /F | Out-Null 2>&1

if (Test-Path $LogPath)
{
    Write-Host "Removing logs..."

    Remove-Item `
        $LogPath `
        -Recurse `
        -Force
}

Write-Host "Uninstall complete."

exit 0