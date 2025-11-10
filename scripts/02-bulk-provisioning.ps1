# 02-bulk-provisioning.ps1
# Bulk user provisioning in Microsoft Entra ID (Azure AD)

# Import users list 
$users = Import-Csv "$PSScriptRoot/../data/users.txt"
$defaultPassword = "TestPassword!"

Write-Host "========== Starting Bulk User Provisioning ==========" -ForegroundColor Cyan
foreach ($user in $users) {
    try {
        # Crear usuario en Entra ID
        New-MgUser `
            -AccountEnabled:$true `
            -DisplayName $user.DisplayName `
            -MailNickname ($user.UserPrincipalName.Split("@")[0]) `
            -UserPrincipalName $user.UserPrincipalName `
            -PasswordProfile @{ ForceChangePasswordNextSignIn = $true; Password = $defaultPassword } `
            -JobTitle $user.JobTitle `
            -Department $user.Department | Out-Null

        Write-Host "Created user: $($user.DisplayName)" -ForegroundColor Green
    }
    catch {
        Write-Host " Error creating user: $($user.DisplayName)" -ForegroundColor Yellow
        Write-Host "   Exception.Message: $($_.Exception.Message)" -ForegroundColor DarkYellow
    }
}
