$computerInfo = Get-ComputerInfo
Write-Host "Operating system: $($computerInfo.OsArchitecture) $($computerInfo.OsName) version $($computerInfo.OsVersion)"
Write-Host "PowerShell version: $($PSVersionTable.PSVersion)"

Push-Location $PSScriptRoot

Get-ChildItem ps*.ps1 | ForEach-Object {. $_.FullName}

function prompt {
    $uiTitle = $PWD | Convert-Path | Split-Path -Leaf
    $Host.UI.RawUI.WindowTitle = $uiTitle
    Write-Host "`n$env:USERNAME" -ForegroundColor Green -NoNewline
    if (Test-Administrator) {
        Write-Host " as " -NoNewline
        Write-Host "Administrator" -ForegroundColor Red -NoNewline
        $Host.UI.RawUI.WindowTitle = $uiTitle + " (Administrator)"
    }
    Write-Host " at " -NoNewline
    Write-Host $env:COMPUTERNAME -ForegroundColor Magenta -NoNewline
    Write-Host " in " -NoNewline
    Write-Host $ExecutionContext.SessionState.Path.CurrentLocation -ForegroundColor Cyan
    return "PS $('>' * ($NestedPromptLevel + 1)) "
}

Pop-Location