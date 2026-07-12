# Resources Drive Setup
# Maps R: to \\DBC-00\Resources

$ErrorActionPreference = "Stop"

$ConfigPath = "$PSScriptRoot\..\Config\config.json"

if (!(Test-Path $ConfigPath))
{
    Write-Host "Configuration file not found."
    exit 1
}

$config = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Json

$Drive  = $config.driveLetter
$Server = $config.server
$Share  = $config.share

$Target = "\\$Server\$Share"

# Wait up to 30 seconds for the server
$connected = $false

for ($i = 0; $i -lt 10; $i++)
{
    if (Test-Connection -ComputerName $Server -Quiet -Count 1) {
        $connected = $true
        break
    }
    Start-Sleep -Seconds 3
}

if (-not $connected) {
    Write-Host "Server unavailable."
    exit 1
}

$current = Get-CimInstance `
    -ClassName Win32_LogicalDisk `
    -Filter "DeviceID='$Drive:'"

if ($current) 
{

    if ($current.ProviderName -eq $Target) {
        Write-Host "Drive already mapped."
        exit 0
    }

    Write-Host "Drive $Drive: already in use."
    exit 2
}

New-PSDrive `
    -Name $Drive `
    -PSProvider FileSystem `
    -Root $Target `
    -Persist | Out-Null

if (Get-PSDrive -Name $Drive -ErrorAction SilentlyContinue)
{
    Write-Host "Drive mapped successfully."
    exit 0
}

Write-Error "Drive mapping failed."
exit 3