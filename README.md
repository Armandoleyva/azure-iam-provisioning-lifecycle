# Azure AD (Entra ID) — IAM Lifecycle Lab: Provisioning & Deprovisioning Automation

This repository demonstrates a simple **Identity Lifecycle Management** lab focused on user provisioning and deprovisioning using **Microsoft Entra ID (Azure AD)**.

It showcases how IAM engineers can automate joiner, mover, and leaver processes by leveraging Azure automation and PowerShell scripting, simulating realistic enterprise IAM workflows.

---

## 🚀 Project Overview

This lab is designed to demonstrate:

- ✅ **Provisioning**: Automatically create a new user in Azure AD and assign them to the correct security groups.
- 🔁 **Role Updates**: Simulate “mover” scenarios by changing department or group membership.
- ❌ **Deprovisioning**: Disable a user and remove their access from all associated groups and resources.
- 📊 **Auditing**: Produce logs for compliance and review (basic version included).

---

## 🧩 Tech Stack

| Component | Description |
|------------|-------------|
| **Azure AD / Entra ID** | Identity directory for user lifecycle operations |
| **PowerShell** | Main automation language |
| **Microsoft Graph API** | Backend interface for directory operations |
| **Azure Automation Account (optional)** | To run scripts on a schedule or event trigger |

---

## 🧠 Lab Scenarios

### 1. **User Provisioning**
Creates a new user account in Entra ID and assigns it to one or more security groups (for example: `sg-IT`, `sg-HR`).

```powershell
.\Provision-User.ps1 -UserPrincipalName "newhire@yourtenant.onmicrosoft.com" `
                     -DisplayName "New Hire" `
                     -Department "IT"

### 2. **Group Assignment**

This step assigns existing users to their appropriate groups based on department data from a CSV file (`groups.txt`).

**Example CSV:**
```csv
Department,GroupName
Human Resources,HR-Team
IT,IT-Team
Sales,Sales-Team
Finance,Finance-Team
Operations,Operations-Team
Legal,Legal-Team
```

**Run the script:**
```powershell
.\scripts\03-assign-groups.ps1 | Tee-Object -FilePath ./screenshots/group-assignment-output.txt
```

**Expected output:**
```
Group already exists: sg-HR
Added user Ana Torres to group sg-HR
Added user Luis Pineda to group sg-HR
Group already exists: sg-IT
Added user Carlos Reyes to group sg-IT
Added user Daniela López to group sg-IT
...
```

If a group is *mail-enabled*, the script automatically skips it to prevent write conflicts:
```
Skipping mail-enabled group: Sales and Marketing
```

---

### 3. **Audit and Verification**

Once users are provisioned and groups assigned, you can verify group memberships in Entra ID using:

```powershell
Get-MgGroupMember -GroupId (Get-MgGroup -Filter "DisplayName eq 'sg-IT'").Id | Select-Object DisplayName,UserPrincipalName
```

This ensures each user has been correctly assigned according to their department.

Optionally, logs are stored under the `./screenshots` directory for each execution step.

---

### 4. **Deprovisioning**

This step simulates a **leaver process**, where selected users are offboarded from Entra ID.  
The script disables user accounts and removes them from all assigned groups.

**Example CSV:**
```csv
UserPrincipalName
camila.torres@yourtenant.onmicrosoft.com
daniela.lopez@yourtenant.onmicrosoft.com
pablo.torres@yourtenant.onmicrosoft.com
isabel.duarte@yourtenant.onmicrosoft.com
diego.flores@yourtenant.onmicrosoft.com
```

**Run the script:**
```powershell
.\scripts\04-deprovision.ps1 | Tee-Object -FilePath ./screenshots/deprovision-output.txt
```

**Expected output:**
```
Processing deprovisioning for camila.torres@yourtenant.onmicrosoft.com...
User disabled successfully and removed from all groups.

Processing deprovisioning for daniela.lopez@yourtenant.onmicrosoft.com...
User disabled successfully and removed from all groups.
```

All deprovisioning logs are stored under:
```
./screenshots/deprovision-output.txt
```

---

## 📁 Repository Structure

```
IAM-Lifecycle-Lab/
│
├── README.md
├── scripts/
│   ├── 01-provision-user.ps1
│   ├── 02-group-creation.ps1
│   ├── 03-assign-groups.ps1
│   └── 04-deprovision.ps1
│
└── screenshots/
    ├── provisioning-output.txt
    ├── group-assignment-output.txt
    └── deprovision-output.txt
```

---

## 👤 Author

**Armando Leyva**  
Cloud & IAM Engineer | Microsoft Entra ID | PowerShell | Azure Identity Governance  
[LinkedIn](https://www.linkedin.com/in/armandoleyva01/)  


