$user = "KioskUser"
$userDesc = "Kiosk account with assigned Access"
$website = "examx.at"
New-LocalUser -Name $user -NoPassword -AccountNeverExpires -UserMayNotChangePassword -Description $userDesc | Set-LocalUser -PasswordNeverExpires $true
Add-LocalGroupMember -SID S-1-5-32-545 -Member $user
$Sid = (Get-LocalUser -Name $user).SID.Value

$version = (Get-ComputerInfo | Select-Object OsBuildNumber).OsBuildNumber

if ($version -gt 19041)
{
    $AUMID = "Microsoft.MicrosoftEdge.Stable_8wekyb3d8bbwe!App"
    Set-AssignedAccess -UserName $user -AppUserModelId $AUMID
    $profile = Get-ItemPropertyValue "HKLM:\SOFTWARE\Microsoft\Windows\AssignedAccessConfiguration\Configs\$Sid" -Name DefaultProfileId
    #New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\AssignedAccessConfiguration\Profiles\$profile\AllowedApps\App0" -ItemType Directory -Force
    $regpath = "HKLM:\SOFTWARE\Microsoft\Windows\AssignedAccessConfiguration\Profiles\$profile\AllowedApps\App0"
    Set-ItemProperty -Path $regpath -Name "AppId" -Value "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    Set-ItemProperty -Path $regpath -Name "Arguments" -Value "--no-first-run --kiosk $website --kiosk-idle-timeout-minutes=0 --edge-kiosk-type=fullscreen"
    Set-ItemProperty -Path $regpath -Name "AppType" -Value 0x00000003
    Set-ItemProperty -Path $regpath -Name "AutoLaunch" -Value 0x00000001
}
else
{
    $AUMID = "Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge"

    Set-AssignedAccess -UserName $user -AppUserModelId $AUMID

    New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\" -Name $Sid
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\$Sid" -Name "Browser"
    $regpath = "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\$Sid\Browser"
    New-ItemProperty -Path $regpath -PropertyType "DWord" -Name "ConfigureHomeButton" -Value 2
    New-ItemProperty -Path $regpath -PropertyType "DWord" -Name "ConfigureHomeButton_ProviderSet" -Value 1
    New-ItemProperty -Path $regpath -PropertyType "String" -Name "ConfigureHomeButton_WinningProvider" -Value "476830E9-5AE5-4794-A472-DF53C27AC1BC"
    New-ItemProperty -Path $regpath -PropertyType "DWord" -Name "ConfigureKioskMode" -Value 0
    New-ItemProperty -Path $regpath -PropertyType "DWord" -Name "ConfigureKioskMode_ProviderSet" -Value 1
    New-ItemProperty -Path $regpath -PropertyType "String" -Name "ConfigureKioskMode_WinningProvider" -Value "476830E9-5AE5-4794-A472-DF53C27AC1BC"
    New-ItemProperty -Path $regpath -PropertyType "DWord" -Name "ConfigureKioskResetAfterIdleTimeout" -Value 5
    New-ItemProperty -Path $regpath -PropertyType "DWord" -Name "ConfigureKioskResetAfterIdleTimeout_ProviderSet" -Value 1
    New-ItemProperty -Path $regpath -PropertyType "String" -Name "ConfigureKioskResetAfterIdleTimeout_WinningProvider" -Value "476830E9-5AE5-4794-A472-DF53C27AC1BC"

    New-ItemProperty -Path $regpath -PropertyType "String" -Name "Homepages" -Value "<$website>"
    New-ItemProperty -Path $regpath -PropertyType "DWord" -Name "Homepages_ProviderSet" -Value 1
    New-ItemProperty -Path $regpath -PropertyType "String" -Name "Homepages_WinningProvider" -Value "476830E9-5AE5-4794-A472-DF53C27AC1BC"
    New-ItemProperty -Path $regpath -PropertyType "String" -Name "SetHomeButtonURL" -Value $website
    New-ItemProperty -Path $regpath -PropertyType "DWord" -Name "SetHomeButtonURL_ProviderSet" -Value 1
    New-ItemProperty -Path $regpath -PropertyType "String" -Name "SetHomeButtonURL_WinningProvider" -Value "476830E9-5AE5-4794-A472-DF53C27AC1BC"
    New-ItemProperty -Path $regpath -PropertyType "String" -Name "SetNewTabPageURL" -Value $website
    New-ItemProperty -Path $regpath -PropertyType "DWord" -Name "SetNewTabPageURL_ProviderSet" -Value 1
    New-ItemProperty -Path $regpath -PropertyType "String" -Name "SetNewTabPageURL_WinningProvider" -Value "476830E9-5AE5-4794-A472-DF53C27AC1BC"

    #Create a new settings provider
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\Providers\" -Name "476830E9-5AE5-4794-A472-DF53C27AC1BC"
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\Providers\476830E9-5AE5-4794-A472-DF53C27AC1BC\" -Name "default"
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\Providers\476830E9-5AE5-4794-A472-DF53C27AC1BC\default\" -Name $Sid
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\Providers\476830E9-5AE5-4794-A472-DF53C27AC1BC\default\$Sid\" -Name "Browser"

    $regpath = "HKLM:\SOFTWARE\Microsoft\PolicyManager\Providers\476830E9-5AE5-4794-A472-DF53C27AC1BC\default\$Sid\Browser"
    New-ItemProperty -Path $regpath -PropertyType "DWord" -Name "ConfigureHomeButton" -Value 2
    New-ItemProperty -Path $regpath -PropertyType "DWord" -Name "ConfigureHomeButton_LastWrite" -Value 1
    New-ItemProperty -Path $regpath -PropertyType "DWord" -Name "ConfigureKioskMode" -Value 0
    New-ItemProperty -Path $regpath -PropertyType "DWord" -Name "ConfigureKioskMode_LastWrite" -Value 1
    New-ItemProperty -Path $regpath -PropertyType "DWord" -Name "ConfigureKioskResetAfterIdleTimeout" -Value 5
    New-ItemProperty -Path $regpath -PropertyType "DWord" -Name "ConfigureKioskResetAfterIdleTimeout_LastWrite" -Value 1

    New-ItemProperty -Path $regpath -PropertyType "String" -Name "Homepages" -Value "<$website>"
    New-ItemProperty -Path $regpath -PropertyType "DWord" -Name "Homepages_LastWrite" -Value 1
    New-ItemProperty -Path $regpath -PropertyType "String" -Name "SetHomeButtonURL" -Value $website
    New-ItemProperty -Path $regpath -PropertyType "DWord" -Name "SetHomeButtonURL_LastWrite" -Value 1
    New-ItemProperty -Path $regpath -PropertyType "String" -Name "SetNewTabPageURL" -Value $website
    New-ItemProperty -Path $regpath -PropertyType "DWord" -Name "SetNewTabPageURL_LastWrite" -Value 1

}
