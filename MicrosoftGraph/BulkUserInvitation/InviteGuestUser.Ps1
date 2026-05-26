#==============================================================================
# Script: InviteGuestUser.ps1
# Author: Deekshat Manhotra
# Version: 1.0
# Date: 25-05-2026
# Description: Bulk invite guest users to Entra ID with profile updates
# 
# Requirements:
#   - Microsoft.Graph module
#   - Permissions: User.Invite.All, User.ReadWrite.All
#
# Usage:
#   .\InviteGuestUser.ps1
#==============================================================================

$User_mails = Import-Csv "Your file path"

$message = New-Object Microsoft.Graph.PowerShell.Models.MicrosoftGraphInvitedUserMessageInfo
$message.CustomizedMessageBody = "Type your message here"

foreach ($user in $User_mails) {

    try{

        $Invitation  = New-MgInvitation `
        -InvitedUserDisplayName $user.DisplayName `
        -InvitedUserEmailAddress $user.EmailAddress `
        -InviteRedirectUrl "https://myapplications.microsoft.com" `
        -InvitedUserMessageInfo $message `
        -SendInvitationMessage

        $userId = $Invitation.InvitedUser.Id

        Write-Host "Invitation sent. User Id: $UserId" -ForegroundColor Green

        Update-MgUser -UserId $userId -BodyParameter @{
            country  = $user.Country
            jobTitle = $user.JobTitle
            companyName = $user.CompanyName
        }

        Write-Host "User porfile updated" -ForegroundColor Green

        $manager = Get-MgUser -Filter "displayName eq 'Deekshat Manhotra'"
        Set-MgUserManagerByRef -UserId $userId `
        -OdataId "https://graph.microsoft.com/v1.0/users/$($manager.Id)"

        Write-Host "Manager Assigned" -ForegroundColor Green

    } catch {

        Write-Host "Error : $_" -ForegroundColor Red

    }

}


