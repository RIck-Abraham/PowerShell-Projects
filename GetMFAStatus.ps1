# Connect to Office 365
Connect-MsolService

# Get all users in your tenant
$users = Get-MsolUser -All

# Initialize an array to hold the results
$results = @()

# Iterate through each user
foreach ($user in $users) {
    # Get the user's MFA status
    $mfaStatus = Get-MsolUser -UserPrincipalName $user.UserPrincipalName | select -ExpandProperty StrongAuthenticationRequirements

    if ($mfaStatus) {
        # Check if MFA is enforced for the user
        $mfaEnforced = $mfaStatus.IsDefault -or ($mfaStatus.State -eq "Enforced")
        if ($mfaEnforced) {
            $mfaEnabled = "Enabled (Enforced)"
        } else {
            $mfaEnabled = "Enabled (Not Enforced)"
        }
    } else {
        $mfaEnabled = "Disabled"
        $mfaEnforced = $false
    }

    # Add the user's MFA status to the results array
    $results += [pscustomobject]@{
        UserPrincipalName = $user.UserPrincipalName
        MFAEnabled = $mfaEnabled
        MFAEnforced = $mfaEnforced
    }
}

# Export the results to a CSV file
$results | Export-Csv -Path "C:\MFAStatus.csv" -NoTypeInformation
