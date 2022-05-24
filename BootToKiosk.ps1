$user = "ExamX"
$userDesc = "ExamX exam account with assigned Access"
$website = "examx.at"
New-LocalUser -Name $user -NoPassword -AccountNeverExpires -UserMayNotChangePassword -Description $userDesc | Set-LocalUser -PasswordNeverExpires $true
Add-LocalGroupMember -SID S-1-5-32-545 -Member $user
Set-AssignedAccess -UserName $user -AppUserModelId Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge 
$examxSid = (Get-LocalUser -Name $user).SID.Value

New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\" -Name $examxSid
New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\$examxSid" -Name "Browser"
$regpath = "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\$examxSid\Browser"
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
New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\Providers\476830E9-5AE5-4794-A472-DF53C27AC1BC\default\" -Name $examxSid
New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\Providers\476830E9-5AE5-4794-A472-DF53C27AC1BC\default\$examxSid\" -Name "Browser"

$regpath = "HKLM:\SOFTWARE\Microsoft\PolicyManager\Providers\476830E9-5AE5-4794-A472-DF53C27AC1BC\default\$examxSid\Browser"
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