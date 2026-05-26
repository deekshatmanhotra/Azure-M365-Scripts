# Bulk User Invitation Script

## 📌 Overview
Automates the process of inviting multiple guest users to your Azure AD tenant using Microsoft Graph API.

## ✨ Features
- Bulk invite users from CSV
- Error handling and logging
- Progress tracking
- Customizable invitation message

## Usage
1. **Prepare your CSV file** with guest user details
2. **Update the script** with your file path and customizations
3. **Connect to Microsoft Graph**:
```powershell
   Connect-MgGraph -Scopes "User.Invite.All","User.ReadWrite.All"
```
4. **Run the script**:
```powershell
   .\InviteGuestUser.ps1
```
## Output

The script provides color-coded console output:
- 🟢 **Green**: Successful operations (invitation sent, profile updated, manager assigned)
- 🔴 **Red**: Errors with detailed error messages

### Example Output
Invitation sent. User Id: a1b2c3d4-e5f6-7890-abcd-ef1234567890  
User profile updated  
Manager Assigned

## 📋 Prerequisites
- Microsoft Graph PowerShell SDK
- Appropriate permissions (User.Invite.All) ("User.ReadWrite.All")

### 📋 Sample CSV (`GuestUsers.csv`)
```csv
DisplayName,EmailAddress,Manager,Country,JobTitle,CompanyName
John Smith,john.smith@partner.com,Mike Merchant,United States,Project Manager,Partner Corp
Jane Doe,jane.doe@vendor.com,Mike Merchant,United Kingdom,Business Analyst,Vendor Ltd
```
## Important Notes

⚠️ **Best Practices:**
- Test with a small batch first (1-2 users)
- Verify manager display name exists in your tenant
- Ensure the CSV file is properly formatted with no extra spaces
- Check that invited users don't already exist as guests
- Review Microsoft Graph API rate limits for bulk operations

## Author

**Deekshat Manhotra**  
O365 Engineer | Azure Enthusiast

## License

This script is provided as-is for educational and production use. Feel free to modify and distribute.

## Contributing

Suggestions and improvements are welcome! Feel free to fork and submit pull requests.


