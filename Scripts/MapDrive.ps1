# Resources Drive Setup
# Maps R: to \\DBC-00\Resources

$Server = "DBC-00"
$Share = "Resources"
$Drive = "R"

$Path = "\\$Server\$Share"

# Wait for network
$Attempts = 10

while ($Attempts -gt 0)
{
    if (Test-Connection $Server -Quiet -Count 1)
    {
        break
    }

    Start-Sleep -Seconds 3
    $Attempts--
}

if ($Attempts -eq 0)
{
    exit 1
}

# Already mapped correctly?
$current = Get-CimInstance Win32_LogicalDisk |
Where-Object {$_.DeviceID -eq "$Drive:"}

if($current)
{
    if($current.ProviderName -eq $Path)
    {
        exit 0
    }

    net use "$Drive:" /delete /yes
}

net use "$Drive:" $Path /persistent:yes