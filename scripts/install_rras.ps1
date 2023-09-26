#!/usr/bin/pwsh

#
# PowerShell Script
# - Enable ICMP on Windows Defender Firewall with Advanced Security
# - Enable and configure RRAS on Windows Server
#

param ()

$ErrorActionPreference = "Stop"

Write-Information "==> Enabling firewall rules..." -InformationAction Continue

Get-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" | Enable-NetFirewallRule
$config = Get-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)"

Write-Information " - File and Printer Sharing (Echo Request - ICMPv4-In) [Enabled = $($config.Enabled)]" -InformationAction Continue

Write-Information "==> Enabling routing and remote access..." -InformationAction Continue

Install-WindowsFeature RemoteAccess -ErrorAction Continue
Install-WindowsFeature RSAT-RemoteAccess-PowerShell -ErrorAction Continue
Install-WindowsFeature Routing -ErrorAction Continue
Install-RemoteAccess -VpnType RoutingOnly -ErrorAction Continue

$ethernetIpAddress = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Ethernet").IPAddress
$thirdOctet = $ethernetIpAddress.Split(".")[2]
$fourthOctet = $ethernetIpAddress.Split(".")[3]
$localASN = 65000 + $thirdOctet

Add-BgpRouter -BgpIdentifier $ethernetIpAddress -LocalASN $localASN -ErrorAction Continue

switch ($thirdOctet)
{
    {@(0,4,8) -contains $_ } {
        # Add BGP peer to ars_hub Azure route server
        Add-BgpPeer -Name "r-hub-routerserver-1" -LocalIPAddress $ethernetIpAddress -PeerASN "65515" -PeerIPAddress "10.100.0.132" -ErrorAction Continue
        Add-BgpPeer -Name "r-hub-routerserver-2" -LocalIPAddress $ethernetIpAddress -PeerASN "65515" -PeerIPAddress "10.100.0.133" -ErrorAction Continue
        # Add BGP peer to non-prod hub Azure route server
        # Add-BgpPeer -Name "n-hub-routerserver-1" -LocalIPAddress $ethernetIpAddress -PeerASN "65515" -PeerIPAddress "10.47.0.132" -ErrorAction Continue
        # Add-BgpPeer -Name "n-hub-routerserver-2" -LocalIPAddress $ethernetIpAddress -PeerASN "65515" -PeerIPAddress "10.47.0.133" -ErrorAction Continue
        # Add BGP peer to internet hub Azure route server
        # Add-BgpPeer -Name "i-hub-routerserver-1" -LocalIPAddress $ethernetIpAddress -PeerASN "65515" -PeerIPAddress "10.47.4.132" -ErrorAction Continue
        # Add-BgpPeer -Name "i-hub-routerserver-2" -LocalIPAddress $ethernetIpAddress -PeerASN "65515" -PeerIPAddress "10.47.4.133" -ErrorAction Continue
        # Add BGP peer to management hub Azure route server
        # Add-BgpPeer -Name "m-hub-routerserver-1" -LocalIPAddress $ethernetIpAddress -PeerASN "65515" -PeerIPAddress "10.47.8.132" -ErrorAction Continue
        # Add-BgpPeer -Name "m-hub-routerserver-2" -LocalIPAddress $ethernetIpAddress -PeerASN "65515" -PeerIPAddress "10.47.8.133" -ErrorAction Continue
    }
    0 {
        # Add BGP peer to internet rras server
        # Add-BgpPeer -Name "i-h-rras-vm001" -LocalIPAddress $ethernetIpAddress -PeerASN "65004" -PeerIPAddress "10.47.4.$fourthOctet" -ErrorAction Continue
        # Add BGP peer to management rras server
        # Add-BgpPeer -Name "m-h-rras-vm001" -LocalIPAddress $ethernetIpAddress -PeerASN "65008" -PeerIPAddress "10.47.8.$fourthOctet" -ErrorAction Continue
        # Add non-prod hub injected routes
        Add-BgpCustomRoute -Network "10.0.0.0/8" -ErrorAction Continue
        Add-BgpCustomRoute -Network "172.16.0.0/12" -ErrorAction Continue
        Add-BgpCustomRoute -Network "192.168.0.0/16" -ErrorAction Continue
    }
    4 {
        # Add BGP peer to non-prod rras server
        # Add-BgpPeer -Name "n-h-rras-vm001" -LocalIPAddress $ethernetIpAddress -PeerASN "65000" -PeerIPAddress "10.47.0.$fourthOctet" -ErrorAction Continue
        # Add BGP peer to management rras server
        # Add-BgpPeer -Name "m-h-rras-vm001" -LocalIPAddress $ethernetIpAddress -PeerASN "65008" -PeerIPAddress "10.47.8.$fourthOctet" -ErrorAction Continue
        # Add internet hub injected routes
        Add-BgpCustomRoute -Network "0.0.0.0/0" -ErrorAction Continue
    }
    8 {
        # Add BGP peer to non-prod rras server
        # Add-BgpPeer -Name "n-h-rras-vm001" -LocalIPAddress $ethernetIpAddress -PeerASN "65000" -PeerIPAddress "10.47.0.$fourthOctet" -ErrorAction Continue
        # Add BGP peer to internet rras server
        # Add-BgpPeer -Name "i-h-rras-vm001" -LocalIPAddress $ethernetIpAddress -PeerASN "65004" -PeerIPAddress "10.47.4.$fourthOctet" -ErrorAction Continue
        # Add management hub injected routes
        Add-BgpCustomRoute -Network "10.12.0.0/16" -ErrorAction Continue
        Add-BgpCustomRoute -Network "10.49.0.0/16" -ErrorAction Continue
        Add-BgpCustomRoute -Network "10.50.0.0/16" -ErrorAction Continue
        # Represent internet injected route
        # Add-BgpCustomRoute -Network "0.0.0.0/0" -ErrorAction Continue
    }
}
