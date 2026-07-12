# =====================================
# Resources Drive Setup v1.1
# System Configuration Script
# =====================================

Write-Host ""
Write-Host "Applying Lab System Settings..."
Write-Host ""

# -------------------------------------------------------
# High Performance Power Plan
# -------------------------------------------------------

Write-Host "Setting High Performance Power Plan..."

$HighPerformance = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"

powercfg /setactive $HighPerformance

# -------------------------------------------------------
# Display Timeout
# -------------------------------------------------------

Write-Host "Setting Display Timeout..."

powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0

# -------------------------------------------------------
# Sleep
# -------------------------------------------------------

Write-Host "Disabling Sleep..."

powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0

# -------------------------------------------------------
# Hibernate
# -------------------------------------------------------

Write-Host "Disabling Hibernate..."

powercfg /change hibernate-timeout-ac 0
powercfg /change hibernate-timeout-dc 0

# -------------------------------------------------------
# Disable Wallpaper Changes
# -------------------------------------------------------

Write-Host "Disabling Wallpaper Changes..."

New-Item `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" `
    -Force | Out-Null

Set-ItemProperty `
    -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" `
    -Name "NoChangingWallPaper" `
    -Value 1 `
    -Type DWord

# -------------------------------------------------------
# Disable Lock Screen Changes
# -------------------------------------------------------

Write-Host "Disabling Lock Screen Changes..."

New-Item `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" `
    -Force | Out-Null

Set-ItemProperty `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" `
    -Name "NoChangingLockScreen" `
    -Value 1 `
    -Type DWord

Write-Host ""
Write-Host "System configuration complete."
Write-Host ""