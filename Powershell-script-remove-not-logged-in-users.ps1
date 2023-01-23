# Define the search criteria for inactive users
$inactiveUsers = Get-ADUser -Filter { (lastlogontimestamp -notlike "*") -and (Name -notlike "$") }

# Count how many inactive users were found
$inactiveCount = $inactiveUsers.Count

# Display the list of inactive users that will be deleted
Write-Host "The following $inactiveCount inactive accounts will be deleted:"

# Confirm with the user if they want to proceed with deletion
$continue = Read-Host "Do you want to proceed with deletion? (yes/no)"

# Check the user's response
if ($continue -eq "yes") {
    # Create arrays to store deleted and not deleted accounts
    $deletedAccounts = @()
    $notDeletedAccounts = @()

    # Iterate through the list of inactive users and delete them
    foreach ($user in $inactiveUsers) {
        try {
            Remove-ADUser -Identity $user.DistinguishedName -Confirm:$false
            $deletedAccounts += $user.Name
        }
        catch {
            $notDeletedAccounts += $user.Name
        }
    }

    # Print the list of deleted accounts
    Write-Host "The following accounts were deleted:"
    $deletedAccounts | Write-Host

    # Print the list of accounts that were not deleted
    if ($notDeletedAccounts.Count -gt 0) {
        Write-Host "The following accounts could not be deleted:"
        $notDeletedAccounts | Write-Host
    }
}
else {
    # Exit the script if the user does not want to proceed
    Write-Host "Script terminated. No accounts were deleted."
}
