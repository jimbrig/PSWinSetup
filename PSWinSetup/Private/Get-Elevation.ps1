function Get-Elevation {
    
    $AdminConsole = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

    if ($AdminConsole -like "False*") {
        Write-Warning "You need to run PowerShell as an admin to use this function!"
        Write-Host ' '
        Break
    }

    Write-Host "SUCCESS: Admin rights detected." -ForegroundColor Green
}
