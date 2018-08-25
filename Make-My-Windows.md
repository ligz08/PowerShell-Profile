# Make My Windows

## Config Windows

### My PowerShell profile

```powershell
$dest = $PROFILE.CurrentUserAllHosts
if (-not (Test-Path $dest)) {New-Item $dest -Type File -Force }
Split-Path $dest | Push-Location
Start-BitsTransfer https://raw.githubusercontent.com/ligz08/PowerShell-Profile/master/psfunctions.ps1
Start-BitsTransfer https://raw.githubusercontent.com/ligz08/PowerShell-Profile/master/profile.ps1
Pop-Location
. $dest
```

## Install Software

### Visual Studio Code
Download: https://code.visualstudio.com/Download

### Sublime Text 3
```powershell
Start-BitsTransfer https://download.sublimetext.com/Sublime%20Text%20Build%203176%20x64%20Setup.exe
& sublime*setup.exe /silent
```

### Typora
```powershell
Start-BitsTransfer https://typora.io/windows/typora-setup-x64.exe
& typora-setup-x64.exe /silent
```

### PuTTY
```powershell
Start-BitsTransfer https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.70-installer.msi
msiexec /i 'putty-64bit-0.70-installer.msi' /passive
```

### VirtualBox
```powershell
Start-BitsTransfer https://download.virtualbox.org/virtualbox/5.2.18/VirtualBox-5.2.18-124319-Win.exe
& VirtualBox-5.2.18-124319-Win.exe --silent
```



