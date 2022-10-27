# Add RegKey Path as it does not exist on the DC
New-Item         -Path "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\" -Name "Windows Defender" -ErrorAction Ignore
Set-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" 1

New-Item         -Path 'HKLM:\SOFTWARE\Policies\Microsoft'                         -Name "Windows Defender"               -Force -ea 0
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"        -Name "DisableAntiSpyware"             -Force -ea 0 -Value 1 -PropertyType DWORD
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"        -Name "DisableRoutinelyTakingAction"   -Force -ea 0 -Value 1 -PropertyType DWORD
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SpyNetReporting"                -Force -ea 0 -Value 0 -PropertyType DWORD
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SubmitSamplesConsent"           -Force -ea 0 -Value 0 -PropertyType DWORD
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT"                     -Name "DontReportInfectionInformation" -Force -ea 0 -Value 1 -PropertyType DWORD


Set-MpPreference -ErrorAction SilentlyContinue -DisableRealtimeMonitoring $true
Set-MpPreference -ErrorAction SilentlyContinue -DisableBehaviorMonitoring $true
Set-MpPreference -ErrorAction SilentlyContinue -DisableIntrusionPreventionSystem $true
Set-MpPreference -ErrorAction SilentlyContinue -DisableIOAVProtection $true
Set-MpPreference -ErrorAction SilentlyContinue -DisableScriptScanning $true
Set-MpPreference -ErrorAction SilentlyContinue -DisableArchiveScanning $true
Set-MpPreference -ErrorAction SilentlyContinue -DisableCatchupFullScan $true
Set-MpPreference -ErrorAction SilentlyContinue -DisableCatchupQuickScan $true
Set-MpPreference -ErrorAction SilentlyContinue -DisableEmailScanning $true
Set-MpPreference -ErrorAction SilentlyContinue -DisableRemovableDriveScanning $true
Set-MpPreference -ErrorAction SilentlyContinue -DisableScanningMappedNetworkDrivesForFullScan $true
Set-MpPreference -ErrorAction SilentlyContinue -DisableScanningNetworkFiles $true
Set-MpPreference -ErrorAction SilentlyContinue -SignatureDisableUpdateOnStartupWithoutEngine $true
Set-MpPreference -ErrorAction SilentlyContinue -DisableBlockAtFirstSeen $true
Set-MpPreference -ErrorAction SilentlyContinue -SevereThreatDefaultAction 6
Set-MpPreference -ErrorAction SilentlyContinue -MAPSReporting 0
Set-MpPreference -ErrorAction SilentlyContinue -HighThreatDefaultAction 6
Set-MpPreference -ErrorAction SilentlyContinue -ModerateThreatDefaultAction 6
Set-MpPreference -ErrorAction SilentlyContinue -LowThreatDefaultAction 6
Set-MpPreference -ErrorAction SilentlyContinue -SubmitSamplesConsent 2

# exclude C drive from A/V scans
Add-MpPreference -ExclusionPath "C:\"
