# 03-assign-groups.ps1
# Assign users to groups in Microsoft Entra ID

# Import CSV data
$users = Import-Csv "$PSScriptRoot/../data/users.txt"
$groups = Import-Csv "$PSScriptRoot/../data/groups.txt"

foreach ($group in $groups) {
    try {
        # Check if group exists
        $existingGroup = Get-MgGroup -Filter "DisplayName eq '$($group.GroupName)'" -ErrorAction SilentlyContinue
        
        if (-not $existingGroup) {
            # Create group if it does not exist
            $existingGroup = New-MgGroup `
                -DisplayName $group.GroupName `
                -MailEnabled:$false `
                -MailNickname $group.GroupName.Replace(" ", "").ToLower() `
                -SecurityEnabled:$true
            Write-Host "Created group: $($group.GroupName)"
        } else {
            Write-Host "Group already exists: $($group.GroupName)"
        }

        # Skip if group is mail-enabled
        if ($existingGroup.MailEnabled -eq $true) {
            Write-Host "Skipping mail-enabled group: $($existingGroup.DisplayName)"
            continue
        }

        # Filter users by Department
        $members = $users | Where-Object { $_.Department -eq $group.Department }

        foreach ($member in $members) {
            try {
                $user = Get-MgUser -Filter "UserPrincipalName eq '$($member.UserPrincipalName)'" -ErrorAction Stop
                New-MgGroupMember -GroupId $existingGroup.Id -DirectoryObjectId $user.Id -ErrorAction Stop
                Write-Host "Added user $($member.DisplayName) to group $($group.GroupName)"
            }
            catch {
                Write-Host "Error adding user $($member.DisplayName) to group $($group.GroupName)"
                Write-Host "Message: $($_.Exception.Message)"
            }
        }
    }
    catch {
        Write-Host "Error processing group: $($group.GroupName)"
        Write-Host "Message: $($_.Exception.Message)"
    }
}
