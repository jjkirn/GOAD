# Ensure script runs with admin privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script must be run as Administrator."
    exit 1
}

# Define rule name
$ruleName = "ICMP Allow incoming V4 echo request"

# Check if rule already exists
$existingRule = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue

if ($existingRule) {
    Write-Host "Firewall rule '$ruleName' already exists."
} else {
    Write-Host "Adding firewall rule '$ruleName'..."

    try {
        New-NetFirewallRule `
            -DisplayName $ruleName `
            -Direction Inbound `
            -Protocol ICMPv4 `
            -IcmpType 8 `
            -Action Allow `
            -Profile Any `
            -Enabled True `
            -Group "Custom ICMP Rules" `
            -Description "Allow incoming ICMPv4 echo requests (ping)" `
            -Program "System"

        Write-Host "Firewall rule added successfully."
    } catch {
        Write-Host "Failed to add firewall rule: $_"
        exit 1
    }
}
