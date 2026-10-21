Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False
Set-NetConnectionProfile -InterfaceIndex 2 -NetworkCategory Private
