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

# ==========================================================
# Restore Windows System Settings
# ==========================================================

Write-Host ""
Write-Host "Restoring Windows configuration..."

# ----------------------------------------------------------
# Restore Balanced Power Plan
# ----------------------------------------------------------

powercfg /setactive SCHEME_BALANCED

# ----------------------------------------------------------
# Restore Power Defaults
# ----------------------------------------------------------

powercfg /change monitor-timeout-ac 10
powercfg /change monitor-timeout-dc 5

powercfg /change standby-timeout-ac 30
powercfg /change standby-timeout-dc 15

powercfg /change hibernate-timeout-ac 180
powercfg /change hibernate-timeout-dc 180

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
Write-Host "Windows configuration restored."

exit 0