$tenantInfo = Get-MgOrganization 

Write-Host "==============================" -ForegroundColor Cyan
Write-Host "      Tenant Dashboard"
Write-Host "==============================" -ForegroundColor Cyan

 [PSCustomObject]@{

    "Tenant Name" = $tenantInfo.DisplayName
    "Tenant Id" = $tenantInfo.Id
    "Verified Domains" = $tenantInfo.VerifiedDomains.Name -join ", "
    "Country" = $tenantInfo.Country

} | Format-List