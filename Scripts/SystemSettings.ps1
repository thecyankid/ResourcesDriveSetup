# =====================================
# Resources Drive Setup
# System Configuration Script
# =====================================

$ErrorActionPreference = "Stop"

# Load configuration
$ConfigPath = "$PSScriptRoot\..\Config\config.json"

if (!(Test-Path $ConfigPath))
{
    Write-Host "Configuration file not found."
    exit 1
}

$config = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json

Write-Host ""
Write-Host "Applying Lab System Settings..."
Write-Host "Version: $($config.version)"
Write-Host ""

# -------------------------------------------------------
# High Performance Power Plan
# -------------------------------------------------------

if ($config.power.enableHighPerformance)
{
    Write-Host "Setting High Performance Power Plan..."

    powercfg.exe /setactive SCHEME_MIN
}

# -------------------------------------------------------
# Display Timeout
# -------------------------------------------------------

Write-Host "Setting Display Timeout..."

powercfg.exe /change monitor-timeout-ac $config.power.monitorTimeout
powercfg.exe /change monitor-timeout-dc $config.power.monitorTimeout

# -------------------------------------------------------
# Sleep
# -------------------------------------------------------

Write-Host "Setting Sleep Timeout..."

powercfg.exe /change standby-timeout-ac $config.power.sleepTimeout
powercfg.exe /change standby-timeout-dc $config.power.sleepTimeout

# -------------------------------------------------------
# Hibernate
# -------------------------------------------------------

Write-Host "Setting Hibernate Timeout..."

powercfg.exe /change hibernate-timeout-ac $config.power.hibernateTimeout
powercfg.exe /change hibernate-timeout-dc $config.power.hibernateTimeout

# -------------------------------------------------------
# Disable Wallpaper Changes
# -------------------------------------------------------

if ($config.restrictions.disableWallpaper)
{
    Write-Host "Disabling Wallpaper Changes..."

    New-Item `
        -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" `
        -Force | Out-Null

    Set-ItemProperty `
        -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" `
        -Name "NoChangingWallPaper" `
        -Value 1 `
        -Type DWord
}

# -------------------------------------------------------
# Disable Lock Screen Changes
# -------------------------------------------------------

if ($config.restrictions.disableLockScreen)
{
    Write-Host "Disabling Lock Screen Changes..."

    New-Item `
        -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" `
        -Force | Out-Null

    Set-ItemProperty `
        -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" `
        -Name "NoChangingLockScreen" `
        -Value 1 `
        -Type DWord
}

Write-Host ""
Write-Host "System configuration completed successfully."
Write-Host ""
exit 0