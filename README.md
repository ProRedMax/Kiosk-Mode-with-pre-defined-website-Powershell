# Boot-To-Kiosk-In-Powershell with a pre defined website

This script enables automation of the Windows Assigned Access (Kiosk Mode) with Microsoft Edge and a pre defined website.

I never found any suitable solution for me, this is why I reverse engineered the Assigned Access creation. The result is this script.

## Note

As for now, this only works 100% for Windows 10 (Versions below 21H2). Versions above 21H2 only have a "fake" kiosk environment -> It looks like a kiosk but with a few windows shortcuts you have access to the "regular" MSEdge.

## Usage

This works out of the box, just change the 3 variables at the beginning of the script and you are good to go
