param (
    [string]$ip
)

$interfaceName = "Ethernet1"
$subnetPrefixLength = 24

Write-Host "Using interface: $interfaceName"

# Validate IP format
if (-not $ip -or $ip -notmatch '^(?:\d{1,3}\.){3}\d{1,3}$') {
    Write-Host "Invalid or missing IP address. Usage: fix_ip.ps1 <IPv4 address>"
    exit 1
}

# Confirm the interface exists and is up
$interface = Get-NetAdapter | Where-Object { $_.Name -eq $interfaceName -and $_.Status -eq "Up" }
if (-not $interface) {
    Write-Host "Network interface '$interfaceName' not found or not active."
    exit 1
}

# Disable DHCP
try {
    Set-NetIPInterface -InterfaceAlias $interfaceName -Dhcp Disabled -ErrorAction Stop
    Write-Host "DHCP disabled on $interfaceName"
} catch {
    Write-Host "Warning: Failed to disable DHCP. Continuing..."
}

# Remove existing IPv4 addresses (not sure this is needed)
try {
    Remove-NetIPAddress -InterfaceAlias $interfaceName -IPAddress $ipEntry.IPAddress -Confirm:$false -ErrorAction SilentlyContinue
    Write-Host "Removed existing IP addresses from $interfaceName"
} catch {
    Write-Host "Warning: Failed to remove existing IP address. Continuing..."
}

# Set the new static IP
try {
    New-NetIPAddress -InterfaceAlias $interfaceName -IPAddress $ip -PrefixLength $subnetPrefixLength -ErrorAction Stop
    Write-Host "IP address successfully set to $ip on '$interfaceName'."
} catch {
    Write-Host "Failed to set IP address: $_"
    exit 1
}
