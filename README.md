# Guozhen's PowerShell Profile

## What Is This
A [PowerShell profile](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles) is a script that runs every time you start a PowerShell session, such as a PowerShell console, or an integrated scripting environment (ISE). It is PowerShell's equivalent to `.bash_profile` and `.bashrc` files of the Bash shell. It's a place where you can customize your shell environment and pre-load frequently used functions/commands/variables.

This repository includes my PowerShell profile scripts, including customizing the command line prompt, and useful functions like `Test-Administrator`.

## How To Use
### Option 1: Direct to your local PowerShell profile
You can stream my `profile.ps1` directly to your local machine's PowerShell profile file. 
Run the following script In a PowerShell console:
```powershell
Invoke-WebRequest https://raw.githubusercontent.com/ligz08/PowerShell-Profile/master/profile.ps1 `
| Select-Object -ExpandProperty Content `
| Out-File $PROFILE.CurrentUserAllHosts

. $PROFILE.CurrentUserAllHosts
```
Note that there had never been a profile script before, this may produce an error, because `$PROFILE.CurrentUserAllHosts` resolves to a path that does not exist.
Solve this by creating that file with `New-Item` command (like below), and then run the above `Invoke-WebRequest` script again.
```powershell
New-Item $PROFILE.CurrentUserAllHosts -Force
```

### Option 2: Clone/download repository to local machine
Or, fork, clone or download this repository if you want more tweaking and customization.
When on a local machine, copy the `profile.ps` file to your PowerShell profile. For example:
```powershell
Copy-Item .\profile.ps1 $PROFILE.CurrentUserAllHosts
```

## More Explanations
### Current user vs. all users
A profile script for "current user" is effective only for you. Not for anyone else who use a different account to log into the same machine. It is recommended to apply a profile script only for yourself (current user).

### Current host vs. all hosts
A host is an application that makes calls to the PowerShell engine, and shows outputs to you. Your Windows typically has only one PowerShell core, but can have muliple hosts, for example, the PowerShell console is one, the PowerShell ISE (integrated scripting environment) is another, and the PowrShell Integrated Console in your Visual Studio Code is yet another different host. 
If you run `Get-Host` you can see what host you're running PowerShell from.

To make different hosts behave differently, you may want to specify different profile scripts for them. Run `$PROFILE.CurretUserCurrentHost` to see where PowerShell looks for profile script for your current host.

## TODOs
- [ ] Git repository status in prompt
- [ ] Help blocks & documentations for functions

## References & Links
- This work is inspired by and borrows a lot of insights from [Mathias Bynens](https://mathiasbynens.be/)' dotfiles for macOS: https://github.com/mathiasbynens/dotfiles
- About PowerShell Profiles: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles
- `Test-Administrator` function: https://serverfault.com/a/97599
