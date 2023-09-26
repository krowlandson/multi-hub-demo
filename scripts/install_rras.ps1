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
Install-RemoteAccess -MultiTenancy -ErrorAction Continue
# Install-RemoteAccess -VpnType RoutingOnly -ErrorAction Continue

$ethernetIpAddress = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Ethernet").IPAddress
$thirdOctet = $ethernetIpAddress.Split(".")[2]
$fourthOctet = $ethernetIpAddress.Split(".")[3]
$nonProdASN = 65000 + $thirdOctet
$mgmtASN = 66000 + $thirdOctet

$nonProdRoutingDomain = "nonprod_RD0"
$mgmtRoutingDomain = "mgmt_RD0"

Enable-RemoteAccessRoutingDomain -Name $nonProdRoutingDomain -Type RoutingOnly -ErrorAction Continue
Enable-RemoteAccessRoutingDomain -Name $mgmtRoutingDomain -Type RoutingOnly -ErrorAction Continue

Add-BgpRouter -RoutingDomain $nonProdRoutingDomain -BgpIdentifier $ethernetIpAddress -LocalASN $nonProdASN -ErrorAction Continue
Add-BgpRouter -RoutingDomain $mgmtRoutingDomain -BgpIdentifier $ethernetIpAddress -LocalASN $mgmtASN -ErrorAction Continue

switch ($thirdOctet)
{
    {@(0,4,8) -contains $_ } {
        # Add BGP peer to non-prod ARS hub Azure route server
        Add-BgpPeer -RoutingDomain $nonProdRoutingDomain -Name "n-r-routerserver-1" -LocalIPAddress $ethernetIpAddress -PeerASN "65515" -PeerIPAddress "10.100.0.132" -ErrorAction Continue
        Add-BgpPeer -RoutingDomain $nonProdRoutingDomain -Name "n-r-routerserver-2" -LocalIPAddress $ethernetIpAddress -PeerASN "65515" -PeerIPAddress "10.100.0.133" -ErrorAction Continue
        # Add BGP peer to management ARS hub Azure route server
        Add-BgpPeer -RoutingDomain $mgmtRoutingDomain -Name "m-r-routerserver-1" -LocalIPAddress $ethernetIpAddress -PeerASN "65515" -PeerIPAddress "10.100.1.132" -ErrorAction Continue
        Add-BgpPeer -RoutingDomain $mgmtRoutingDomain -Name "m-r-routerserver-2" -LocalIPAddress $ethernetIpAddress -PeerASN "65515" -PeerIPAddress "10.100.1.133" -ErrorAction Continue
    }
    0 {
        # Add non-prod hub injected routes for non-prod routing domain
        Add-BgpCustomRoute -RoutingDomain $nonProdRoutingDomain -Network "10.0.0.0/8" -ErrorAction Continue
        Add-BgpCustomRoute -RoutingDomain $nonProdRoutingDomain -Network "172.16.0.0/12" -ErrorAction Continue
        Add-BgpCustomRoute -RoutingDomain $nonProdRoutingDomain -Network "192.168.0.0/16" -ErrorAction Continue
    }
    4 {
        # Add internet hub injected routes for non-prod routing domain
        Add-BgpCustomRoute -RoutingDomain $nonProdRoutingDomain -Network "0.0.0.0/0" -ErrorAction Continue
        # Add internet hub injected routes for management routing domain
        Add-BgpCustomRoute -RoutingDomain $mgmtRoutingDomain -Network "0.0.0.0/0" -ErrorAction Continue
    }
    8 {
        # Add management hub injected routes for non-prod routing domain
        Add-BgpCustomRoute -RoutingDomain $nonProdRoutingDomain -Network "10.12.0.0/16" -ErrorAction Continue
        Add-BgpCustomRoute -RoutingDomain $nonProdRoutingDomain -Network "10.49.0.0/16" -ErrorAction Continue
        Add-BgpCustomRoute -RoutingDomain $nonProdRoutingDomain -Network "10.50.0.0/16" -ErrorAction Continue
        # Add management hub injected routes for management routing domain
        Add-BgpCustomRoute -RoutingDomain $mgmtRoutingDomain -Network "10.0.0.0/8" -ErrorAction Continue
        Add-BgpCustomRoute -RoutingDomain $mgmtRoutingDomain -Network "172.16.0.0/12" -ErrorAction Continue
        Add-BgpCustomRoute -RoutingDomain $mgmtRoutingDomain -Network "192.168.0.0/16" -ErrorAction Continue
    }
}
