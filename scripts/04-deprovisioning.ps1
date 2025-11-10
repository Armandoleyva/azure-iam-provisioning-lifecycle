# 04-deprovision.ps1
# Offboarding Simulation in Microsoft Entra ID

$offboardUsers = Import-Csv "$PSScriptRoot/../data/offboard-users.txt"

$processed = 0
$total = $offboardUsers.Count

Write-Host "========== Starting Deprovisioning Process ==========" -ForegroundColor Cyan
Write-Host "Total users to process: $total" -ForegroundColor Yellow
Write-Host ""

foreach ($u in $offboardUsers) {
    Write-Host "Processing deprovisioning for user: $($u.UserPrincipalName)" -ForegroundColor White

    try {
        $user = Get-MgUser -Filter "UserPrincipalName eq '$($u.UserPrincipalName)'" -ErrorAction Stop
        
        # Disable account
        Update-MgUser -UserId $user.Id -AccountEnabled:$false
        Write-Host " - Account disabled" -ForegroundColor DarkYellow

        # Remove from groups
        $groups = Get-MgUserMemberOf -UserId $user.Id | Where-Object { $_.AdditionalProperties['@odata.type'] -eq "#microsoft.graph.group" }
        foreach ($g in $groups) {
            Remove-MgGroupMemberByRef -GroupId $g.Id -DirectoryObjectId $user.Id -ErrorAction SilentlyContinue
        }
        Write-Host " - Removed from all groups" -ForegroundColor DarkYellow

        # Remove assigned licenses (if any)
        if ($user.AssignedLicenses.Count -gt 0) {
            Set-MgUserLicense -UserId $user.Id -AddLicenses @() -RemoveLicenses $user.AssignedLicenses.SkuId
            Write-Host " - Licenses removed" -ForegroundColor DarkYellow
        }

        Write-Host " Deprovisioning completed for $($u.UserPrincipalName)" -ForegroundColor Green
        Write-Host "------------------------------------------------------"
        $processed++
    }
    catch {
        Write-Host " Error processing $($u.UserPrincipalName)" -ForegroundColor Red
        Write-Host " Message: $($_.Exception.Message)"
        Write-Host "------------------------------------------------------"
    }
}

Write-Host ""
Write-Host "========== Deprovisioning Summary ==========" -ForegroundColor Cyan
Write-Host "Users processed successfully: $processed / $total" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Cyan

