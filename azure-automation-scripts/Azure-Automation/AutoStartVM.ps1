#==============================================================================
# Script: AutoStartVM.ps1
# Author: Deekshat Manhotra
# Version: 1.0
# Description:
#   Automatically starts Azure virtual machines tagged with:
#   AutoShutdown = true
#
# Features:
#   - Detects tagged VMs
#   - Checks VM power state
#   - Starts only deallocated VMs
#   - Runs startup operations as background jobs
#   - Supports Azure Automation Runbooks
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


# Retrieve all virtual machines with the required tag
$startupVMCollection = Get-AzResource `
    -TagName "AutoShutdown" `
    -TagValue "true" `
    -ResourceType "Microsoft.Compute/virtualMachines"


Write-Output "Total tagged virtual machines found: $($startupVMCollection.Count)"


# Array to store background startup jobs
$startupTasks = @()


# Loop through each tagged virtual machine
foreach ($resourceItem in $startupVMCollection) {


    # Fetch VM details along with current runtime status
    $virtualMachine = Get-AzVM `
        -ResourceGroupName $resourceItem.ResourceGroupName `
        -Name $resourceItem.Name `
        -Status


    # Retrieve current VM power state
    $vmState = (
        $virtualMachine.Statuses | Where-Object {
            $_.Code -like 'PowerState/*'
        }
    ).DisplayStatus


    # Start VM only if it is currently deallocated
    if ($vmState -eq 'VM deallocated') {

        Write-Output "Starting virtual machine: $($virtualMachine.Name)"


        # Start VM as a background job
        $startupJob = Start-AzVM `
            -ResourceGroupName $resourceItem.ResourceGroupName `
            -Name $virtualMachine.Name `
            -AsJob


        # Store job reference for monitoring
        $startupTasks += $startupJob

    }
    else {

        # Skip VMs that are already running or transitioning
        Write-Output "Skipping VM: $($virtualMachine.Name) | Current State: $vmState"

    }
}


# Continue only if startup jobs were created
if ($startupTasks.Count -gt 0) {

    Write-Output ""
    Write-Output "Waiting for all VM startup operations to complete..."


    # Wait for all background jobs to finish
    $startupTasks | Wait-Job | Receive-Job


    Write-Output ""
    Write-Output "All virtual machines started successfully."

}
else {

    Write-Output ""
    Write-Output "No deallocated virtual machines were found for startup."

}

