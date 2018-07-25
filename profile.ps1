function Test-Administrator {
    <#
    .Synopsis
    Return True if you are currently running as an administrator, False otherwise.
    #>
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Get-ShortPath {
    [CmdletBinding()]
    Param (
        [Parameter(Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Path=(Get-Location)
    )
    Begin {}
    Process {
        Write-Verbose "Make short path from: $Path"
        if ($Path -and (Test-Path $Path)) {
            $fso = New-Object -ComObject Scripting.FileSystemObject
            $short = if ((Get-item $Path).PSIsContainer) {
                $fso.GetFolder($Path).ShortPath
            } else {
                $fso.GetFile($Path).ShortPath
            }
            Write-Output $short
        } else {
            Write-Verbose "Ignoring $Path"
            Write-Output $null
        }
    }
    End {}
}

function Get-PathEnvironmentVariable {
    param (
        [ValidateSet('User','Machine','All')]$Scope='All'
    )
    <#
    .Synopsis
    Get a list of environment variables.
    Return object has two fields: Path and Scope.
    Scope is either 'User' or 'Machine', suggesting whether this environment variable is available for the current user only or for all users on this machine.

    .Parameter Scope
    One of 'User', 'Machine', or 'All'. Default value 'All'.

    .Notes
    For PATH environment variable available for the current process, it is more convenient to use the $env:PATH variable. So it is not included here.
    This command is useful only when a path's scope (User vs. Machine) matters to you.
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
        [ValidateSet('Process','User','Machine')] $Scope='Process'
    )

    switch ($PSCmdlet.ParameterSetName) {
        'ByList' { $paths_str = $Path -join ';' }
        'ByString' {$paths_str = $PathString}
        Default {return}
    }

    switch ($Scope) {
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
        [ValidateSet('Process','User','Machine')]$Scope='Process',
        [Parameter(ParameterSetName='Append')][switch]$Append,
        [Parameter(ParameterSetName='Prepend')][switch]$Prepend,
        [switch]$MakeShort
    )

    $machine_paths = [System.Environment]::GetEnvironmentVariable('Path', 'Machine').Split(';')
    $user_paths = [System.Environment]::GetEnvironmentVariable('Path', 'User').Split(';')

    if ($MakeShort) {
        $Path = $Path | Get-ShortPath
    }

    switch ($Scope) {
        'User' {
            if ($Prepend) {
                $user_paths = $Path + $user_paths
            } else {
                $user_paths = $user_paths + $Path
            }
            Set-PathEnvironmentVariable -Path $user_paths -Scope 'User'
            Reload-PathEnvironmentVariable
        }
        'Machine' {
            if ($Prepend) {
                $machine_paths = $Path + $machine_paths
            } else {
                $machine_paths = $machine_paths + $Path
            }
            Set-PathEnvironmentVariable -Path $machine_paths -Scope 'Machine'
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
    Write-Host "The following paths are added to your $Scope PATH environment variable."
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