````md
# Azure VM Start/Stop Automation

Automated Azure VM start and shutdown solution using PowerShell Runbooks, Azure Automation Account, and Azure Logic Apps.

---

## Features

- Automatically starts/stops Azure VMs
- Uses Azure VM Tags for filtering
- Checks VM power state before operation
- Runs operations as background jobs
- Sends email notifications using Azure Logic Apps
- Schedule automation using Azure Automation Runbooks

---

## Technologies Used

- PowerShell
- Azure Automation Account
- Azure Runbooks
- Azure Logic Apps
- Azure Virtual Machines

---

## Project Structure

```text
Azure-Automation/
│
├── AutoShutdownVM.ps1
├── AutoStartVM.ps1
└── README.md
````

---

## Tag Configuration

VMs should contain the following tag:

```text
AutoShutdown = true
```

---

## Required PowerShell Modules

```powershell
Az.Accounts
Az.Compute
Az.Resources
```

---

## Setup

1. Create an Azure Automation Account
2. Import required Az modules
3. Create PowerShell Runbooks
4. Upload Start/Stop scripts
5. Configure schedules
6. Create Logic App for email notifications
7. Add Logic App webhook URL in script

---

## Workflow

```text
Schedule → Runbook → VM Operation → Logic App → Email Notification
```

---

## Sample Output

```text
Found 1 Vms tagged for auto shutdown: 1
Initiating shutdown for VM: VM-01

Waiting for all VM shutdown operations to complete...

OperationId : aa9347f1-1a65-4729-878e-4c1d7dbcb105
Status      : Succeeded
StartTime   : 02-06-2026 15:21:16
EndTime     : 02-06-2026 15:21:57
Error       : 


All running virtual machines have been stopped successfully.
```

---

## Future Improvements

* Teams/Slack notifications
* Logging and monitoring
* Weekend scheduling
* Auto scaling support

---

## Author

Deekshat Manhotra

O365 Engineer | Aspiring Azure Cloud Architect |
PowerShell | Azure | Automation

```
```

