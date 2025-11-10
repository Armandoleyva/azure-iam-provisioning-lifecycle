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
