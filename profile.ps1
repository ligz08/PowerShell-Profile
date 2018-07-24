function Test-Administrator {
    <#
    .Synopsis
    Return True if you are currently running as an administrator, False otherwise.
    #>
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Get-PathEnvironmentVariable {
    param (
        [ValidateSet('User','Machine','All')]$Type='All'
    )
    <#
    .Synopsis
    Get a list of environment variables.
    Return object has two fields: Path and Type.
    Type is either 'User' or 'Machine', suggesting whether this environment variable is available for the current user only or for all users on this machine.

    .Parameter Type
    One of 'User', 'Machine', or 'All'. Default value 'All'.

    .Notes
    For PATH environment variable available for the current process, it is more convenient to use the $env:PATH variable. So it is not included here.
    This command is useful only when a path's type (User vs. Machine) matters to you.
    #>

    $machine_paths = try {
        [System.Environment]::GetEnvironmentVariable('Path', 'Machine').Split(';') | Select-Object @{name='Path';exp={$_}},@{name='Type';exp={'Machine'}}
    } catch { $null }
    $user_paths = try {
        [System.Environment]::GetEnvironmentVariable('Path', 'User').Split(';') | Select-Object @{name='Path';exp={$_}},@{name='Type';exp={'User'}}
    } catch { $null }

    switch ($Type) {
        'User' { return $user_paths }
        'Machine' { return $machine_paths }
        Default { return $machine_paths + $user_paths }
    }
}

function Reload-PathEnvironmentVariable {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

function Set-PathEnvironmentVariable {
    param (
        [Parameter(ParameterSetName='ByList', Position=0)][string[]] $Path,
        [Parameter(ParameterSetName='ByString', Position=0)][string] $PathString,
        [ValidateSet('Process','User','Machine')] $Type='Process'
    )

    switch ($PSCmdlet.ParameterSetName) {
        'ByList' { $paths_str = $Path -join ';' }
        'ByString' {$paths_str = $PathString}
        Default {return}
    }

    switch ($Type) {
        'User' {
            [System.Environment]::SetEnvironmentVariable('PATH', $paths_str, 'User')
        }
        'Machine' {
            [System.Environment]::SetEnvironmentVariable('PATH', $paths_str, 'Machine')
        }
        Default {$env:Path = $paths_str}
    }
}

function Add-PathEnvironmentVariable {
    [CmdletBinding(DefaultParameterSetName='Append')]
    param (
        [Parameter(Position=0)][string[]]$Path,
        [ValidateSet('Process','User','Machine')]$Type='Process',
        [Parameter(ParameterSetName='Append')][switch]$Append,
        [Parameter(ParameterSetName='Prepend')][switch]$Prepend
    )

    $machine_paths = [System.Environment]::GetEnvironmentVariable('Path', 'Machine').Split(';')
    $user_paths = [System.Environment]::GetEnvironmentVariable('Path', 'User').Split(';')

    switch ($Type) {
        'User' {
            if ($Prepend) {
                $user_paths = $Path + $user_paths
            } else {
                $user_paths = $user_paths + $Path
            }
            Set-PathEnvironmentVariable -Path $user_paths -Type 'User'
            Reload-PathEnvironmentVariable
        }
        'Machine' {
            if ($Prepend) {
                $machine_paths = $Path + $machine_paths
            } else {
                $machine_paths = $machine_paths + $Path
            }
            Set-PathEnvironmentVariable -Path $machine_paths -Type 'Machine'
            Reload-PathEnvironmentVariable
        }
        Default {
            if ($Prepend) {
                $env:Path = ($Path + $env:Path.Split(';') ) -join ';'
            } else {
                $env:Path = ($env:Path.Split(';') + $Path) -join ';'
            }
        }
    }
    Write-Host "The following paths are added to your $Type PATH environment variable."
    Write-Host "`t" -NoNewline
    Write-Host $Path -Separator "`n`t"
}

# TODO
# function Remove-PathEnvironmentVariable {}
# function Replace-PathEnvironmentVariable {}

function prompt {
    Write-Host "`n$env:USERNAME" -ForegroundColor Green -NoNewline
    if (Test-Administrator) {
        Write-Host " as " -NoNewline
        Write-Host "Administrator" -ForegroundColor Red -NoNewline
    }
    Write-Host " at " -NoNewline
    Write-Host $env:COMPUTERNAME -ForegroundColor Magenta -NoNewline
    Write-Host " in " -NoNewline
    Write-Host $ExecutionContext.SessionState.Path.CurrentLocation -ForegroundColor Cyan
    return "PS $('>' * ($NestedPromptLevel + 1)) "
}