function Test-Administrator
{
    <#
    .Synopsis
    Return True if you are currently running as an administrator, False otherwise.#>
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function prompt {
    Write-Host "`n$env:USERNAME" -ForegroundColor Green -NoNewline
    if (Test-Administrator) {
        Write-Host " as " -NoNewline
        Write-Host "Administrator" -ForegroundColor Red -NoNewline
    }
    Write-Host " at " -NoNewline
    Write-Host $env:COMPUTERNAME -ForegroundColor Magenta -NoNewline
    Write-Host " in " -NoNewline
    Write-Host $executionContext.SessionState.Path.CurrentLocation -ForegroundColor Cyan
    return "PS > "
}