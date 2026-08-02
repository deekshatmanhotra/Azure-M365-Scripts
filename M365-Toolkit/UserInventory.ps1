$UserInfo = Get-MgUser -all -Property DisplayName, UserPrincipalName, Accountenabled, JobTitle, Country, userType

$result = foreach($user in $UserInfo){

[PSCustomObject]@{
    "Display Name" = $User.DisplayName
    "UPN" = $User.UserPrincipalName
    "Account Enabled" = $User.AccountEnabled
    "Job Title" = $User.JobTitle
    "Country" = $user.Country
    "UserType" = $user.UserType
 } 
}

$result | Export-Csv UserInventory.csv -notypeInformation

Write-Host "Report Exported!!"