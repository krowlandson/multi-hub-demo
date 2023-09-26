#!/usr/bin/pwsh

#
# PowerShell Script
# - Enable ICMP on Windows Defender Firewall with Advanced Security
#

param ()

$ErrorActionPreference = "Stop"

Write-Information "==> Enabling firewall rules..." -InformationAction Continue

Get-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" | Enable-NetFirewallRule
$config = Get-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)"

Write-Information " - File and Printer Sharing (Echo Request - ICMPv4-In) [Enabled = $($config.Enabled)]" -InformationAction Continue
