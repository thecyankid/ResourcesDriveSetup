# ============================================
# Resources Drive Setup
# Uninstall.ps1
# ============================================

$ErrorActionPreference = "Stop"

$ConfigPath = "$PSScriptRoot\..\Config\config.json"

if (!(Test-Path $ConfigPath))
{
    Write-Host "Configuration file not found."
    exit 1
}

$config = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json

$Drive = $config.driveLetter
$Server = $config.server
$Share = $config.share
$TaskName = $config.taskName
$LogPath = $config.logPath

$Target = "\\$Server\$Share"

Write-Host "Checking mapped drive..."

$current = Get-CimInstance `
    -ClassName Win32_LogicalDisk `
    -Filter "DeviceID='$Drive:'"

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

# ==========================================================
# Restore Windows System Settings
# ==========================================================

Write-Host ""
Write-Host "Restoring system configuration..."

# ----------------------------------------------------------
# Restore Balanced Power Plan
# ----------------------------------------------------------

powercfg.exe /setactive SCHEME_BALANCED

# ----------------------------------------------------------
# Restore Power Defaults
# ----------------------------------------------------------

powercfg.exe /change monitor-timeout-ac 10
powercfg.exe /change monitor-timeout-dc 5

powercfg.exe /change standby-timeout-ac 30
powercfg.exe /change standby-timeout-dc 15

powercfg.exe /change hibernate-timeout-ac 180
powercfg.exe /change hibernate-timeout-dc 180

# ----------------------------------------------------------
# Enable Wallpaper Changes
# ----------------------------------------------------------

Remove-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" `
    -Name "NoChangingWallPaper" `
    -ErrorAction SilentlyContinue

# ----------------------------------------------------------
# Enable Lock Screen Changes
# ----------------------------------------------------------

Remove-ItemProperty `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" `
    -Name "NoChangingLockScreen" `
    -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "System configuration restored."
Write-Host ""
Write-Host "Resources Drive Setup removed successfully."

exit 0