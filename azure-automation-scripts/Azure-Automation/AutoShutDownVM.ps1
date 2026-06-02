#==============================================================================
# Script: AutoShutdownVM.ps1
# Author: Deekshat Manhotra
# Version: 1.0
# Description:
#   Automatically stops Azure virtual machines tagged with:
#   AutoShutdown = true
#
# Features:
#   - Detects tagged VMs
#   - Checks VM power state
#   - Stops only running VMs
#   - Runs shutdown operations as background jobs
#   - Sends notification using Azure Logic App webhook
#
# Requirements:
#   - Az.Accounts module
#   - Az.Compute module
#   - Az.Resources module
#   - Azure Automation Account / PowerShell environment
#
# Permissions Required:
#   - Virtual Machine Contributor OR Contributor role
#
# Usage:
#   Run manually or schedule using Azure Automation Runbook
#
#==============================================================================

# Authenticate using Managed Identity
Connect-AzAccount -Identity

# Fetch all virtual machines having the required tag
$shutdownVMList = Get-AzResource `
    -TagName "AutoShutdown" `
    -TagValue "true" `
    -ResourceType "Microsoft.Compute/virtualMachines"

Write-Output "Total tagged virtual machines found: $($shutdownVMList.Count)"


# Array to store background shutdown jobs
$stopTasks = @()


# Loop through each tagged VM
foreach ($vmItem in $shutdownVMList) {

    # Get VM details along with runtime status
    $vmDetails = Get-AzVM `
        -ResourceGroupName $vmItem.ResourceGroupName `
        -Name $vmItem.Name `
        -Status


    # Extract current power state of the VM
    $currentState = (
        $vmDetails.Statuses | Where-Object {
            $_.Code -like 'PowerState/*'
        }
    ).DisplayStatus


    # Stop VM only if it is currently running
    if ($currentState -eq "VM Running") {

        Write-Output "Initiating shutdown for VM: $($vmDetails.Name)"


        # Start VM shutdown as a background job
        $task = Stop-AzVM `
            -ResourceGroupName $vmDetails.ResourceGroupName `
            -Name $vmDetails.Name `
            -Force `
            -AsJob


        # Store job reference for tracking
        $stopTasks += $task

    }
    else {

        # Skip VMs that are already stopped/deallocated
        Write-Output "Skipping VM: $($vmDetails.Name) | Current State: $currentState"

    }
}


# Proceed only if at least one shutdown job was created
if ($stopTasks.Count -gt 0) {

    Write-Output ""
    Write-Output "Waiting for all VM shutdown operations to complete..."


    # Wait for all background jobs to finish
    $stopTasks | Wait-Job | Receive-Job


    # Trigger Logic App webhook after successful shutdown
    Invoke-RestMethod `
        -Method POST `
        -Uri "YOUR_LOGIC_APP_WEBHOOK_URL"


    Write-Output ""
    Write-Output "All running virtual machines have been stopped successfully."

}
else {

    Write-Output ""
    Write-Output "No running virtual machines were found for shutdown."

}
