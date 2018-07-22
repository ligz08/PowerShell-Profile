# Guozhen's PowerShell Profile

## What Is This
A [PowerShell profile](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles) is a script that runs every time you start a PowerShell session, such as a PowerShell console, or an integrated scripting environment (ISE). It is PowerShell's equivalent to `.bash_profile` and `.bashrc` files of the Bash shell. It's a place where you can customize your shell environment and pre-load frequently used functions/commands/variables.

This repository includes my PowerShell profile scripts, including customizing the command line prompt, and useful functions like `Test-Administrator`.

## How To Use
__Step 1:__ Clone or download this repository to your local machine.

__Step 2:__ Copy `profile.ps1` to an your choice of PowerShell profile location. 
For exmaple in a PowerShell console:

To overwrite profile for current user, all hosts:
```powershell
Copy-Item -Path .\profile.ps1 -Destination $PROFILE.CurrentUserAllHosts -Confirm
```

To overwrite profile for all users, and all hosts (requires Administrator privilege):
```powershell
Copy-Item -Path .\profile.ps1 -Destination $PROFILE.AllUsersAllHosts -Confirm
```

## More Explanations
### Current user vs. all users
A profile script for "current user" is effective only for you. Not for anyone else who use a different account to log into the same machine. It is recommended to apply a profile script only for yourself (current user).

### Current host vs. all hosts
A host is an application that makes calls to the PowerShell engine, and shows outputs to you. Your Windows typically has only one PowerShell core, but can have muliple hosts, for example, the PowerShell console is one, the PowerShell ISE (integrated scripting environment) is another, and the PowrShell Integrated Console in your Visual Studio Code is yet another different host. 
If you run `Get-Host` you can see what host you're running PowerShell from.

To make different hosts behave differently, you may want to specify different profile scripts for them. Run `$PROFILE.CurretUserCurrentHost` to see where PowerShell looks for profile script for your current host.


## References & Links
- About PowerShell Profiles: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles
- `Test-Administrator` function: https://serverfault.com/a/97599
