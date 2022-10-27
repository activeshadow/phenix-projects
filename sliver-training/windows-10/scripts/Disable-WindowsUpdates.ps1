$WindowsUpdatePath = "HKLM:SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$AutoUpdatePath    = "HKLM:SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"

If (Test-Path -Path $WindowsUpdatePath) {
  Remove-Item -Path $WindowsUpdatePath -Recurse
}

New-Item -Path $WindowsUpdatePath
New-Item -Path $AutoUpdatePath

Set-ItemProperty -Path $AutoUpdatePath -Name NoAutoUpdate -Value 1

Stop-Service wuauserv
Set-Service  wuauserv -StartupType Disabled
