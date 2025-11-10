# 01-connect-entra.ps1
# Connect to Microsoft Entra ID using Microsoft Graph PowerShell

Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "User.ReadWrite.All","Group.ReadWrite.All","Directory.ReadWrite.All"

$context = Get-MgContext
if ($context) {
    Write-Host "Connected as $($context.Account)" -ForegroundColor Green
} else {
    Write-Host "Connection failed. Check your permissions." -ForegroundColor Red
}
