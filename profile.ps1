$os = Get-WmiObject Win32_OperatingSystem
Write-Host "Operating system: $($os.OSArchitecture) $($os.Caption) version $($os.Version)"
Write-Host "PowerShell version: $($PSVersionTable.PSVersion)"

Push-Location $PSScriptRoot

Get-ChildItem ps*.ps1 | ForEach-Object {. $_.FullName}

function prompt {
    $Host.UI.RawUI.WindowTitle = ($PWD | Convert-Path | Split-Path -Leaf)
    Write-Host "`n$env:USERNAME" -ForegroundColor Green -NoNewline
    if (Test-Administrator) {
        Write-Host " as " -NoNewline
        Write-Host "Administrator" -ForegroundColor Red -NoNewline
        $Host.UI.RawUI.WindowTitle = ($PWD | Convert-Path) + " (Administrator)"
    }
    Write-Host " at " -NoNewline
    Write-Host $env:COMPUTERNAME -ForegroundColor Magenta -NoNewline
    Write-Host " in " -NoNewline
    Write-Host $ExecutionContext.SessionState.Path.CurrentLocation -ForegroundColor Cyan
    return "PS $('>' * ($NestedPromptLevel + 1)) "
}

Pop-Location