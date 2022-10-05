$tmp = $ProgressPreference
$ProgressPreference = "SilentlyContinue"
$computerInfo = Get-ComputerInfo
$ProgressPreference = $tmp
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
    Write-Host $ExecutionContext.SessionState.Path.CurrentLocation -ForegroundColor Cyan -NoNewline
    $branch = try { git rev-parse --abbrev-ref HEAD 2>$null} catch {$null}
    if ($branch){
        Write-Host " on " -NoNewline
        Write-Host $branch -ForegroundColor Yellow -NoNewline
    }
    return "`nPS $('>' * ($NestedPromptLevel + 1)) "
}

Pop-Location