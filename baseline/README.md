# Baseline activity

Generates normal mail activity so the attack is not the only signal in the
tenant (PLAN.md D4, days 4-8).

**Status: untested.** Written before the lab exists. The Pester tests cover
the offline safety guards and have not yet been run.

## Prerequisites

- PowerShell 7.2+
- `Install-Module Microsoft.Graph.Authentication, Microsoft.Graph.Users.Actions, Microsoft.Graph.Mail -Scope CurrentUser`
- `Install-Module Pester -MinimumVersion 5.0 -Scope CurrentUser` (tests only)

## Run the tests first

```powershell
Invoke-Pester ./tests
```

## Daily routine (days 4-8)

For each of `ceo`, `finance`, `helpdesk`, `victim`, from the device that user
normally uses (the VM for `victim`):

```powershell
./Invoke-LabBaseline.ps1 -LabTenantId <lab tenant id> -AllowedDomains nextlayersec.co `
  -Recipients ceo@nextlayersec.co,finance@nextlayersec.co,helpdesk@nextlayersec.co,victim@nextlayersec.co |
  Export-Csv ../evidence/raw/baseline-log.csv -Append -NoTypeInformation
```

Run once with `-WhatIf` first. The first run per user asks for consent to
`Mail.Send` and `Mail.Read` (delegated) for Microsoft Graph PowerShell. That
consent is itself an audit event; note it in the baseline log.

## What it does and does not generate

| Generates | Does not generate |
|---|---|
| Interactive sign-ins (browser) per user | SharePoint/OneDrive or Teams activity: do some manually |
| Sent mail between lab users | Mail from outside the tenant |
| Inbox reads (MailItemsAccessed, if audited) | Varied devices: vary them by hand (VM, phone) |
