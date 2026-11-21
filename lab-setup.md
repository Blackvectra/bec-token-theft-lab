# Lab setup

Status: **Proposed**. Fill in the Completed column as each step is done.

## Trial constraints (checked 2026-11-21)

| Item | Term | Source | Verified |
|---|---|---|---|
| Sentinel free trial | 31 days, first 10 GB/day on the Analytics tier free; automation and data lake charges still apply | [Sentinel billing](https://learn.microsoft.com/azure/sentinel/billing#free-trial) | Yes |
| Defender XDR advanced hunting retention | 30 days, included with the XDR licence | [Table tiers and retention](https://learn.microsoft.com/azure/sentinel/manage-table-tiers-retention) | Yes |
| M365 / Office 365 E5 trial | Reported 30 days, 25 licences | Third-party sources only | **No: confirm at sign-up** |
| Card required, auto-converts to paid | True for Business trials per Microsoft FAQ | Microsoft business FAQ | **No: confirm for E5 at sign-up** |

Both trials run ~30 days, so the attack and investigation must fit in one
window. Do all planning before sign-up.

## Steps

| # | Step | Completed |
|---|---|---|
| 1 | Sign up for the E5 trial as a new tenant (new `*.onmicrosoft.com`). Record sign-up date and trial end date. | |
| 2 | Add `nextlayersec.co` as a custom domain. Publish SPF (`-all`), DKIM, DMARC `p=reject`. | |
| 3 | Create a break-glass Global Admin (excluded from lab CA policies) and a separate admin for daily work. | |
| 4 | Create fake users: `ceo`, `finance`, `victim` (the phishing target), `helpdesk`, and `collector` (attacker forwarding target, D6). | |
| 4a | Turn security defaults off; create one CA policy requiring MFA for all users, excluding break-glass (D5). | |
| 4b | Onboard the local Windows 11 VM to Defender for Endpoint; `victim` signs in only there (D2). | |
| 5 | Enable unified audit logging; confirm mailbox auditing is on. | |
| 6 | Create Azure subscription in the lab tenant. Set a **budget alert at $25/month** with email to the admin. | |
| 7 | Create a Log Analytics workspace + Sentinel. Confirm the free-trial banner and its end date. | |
| 8 | Connect data: Microsoft Defender XDR connector (incidents + raw events), Microsoft Entra ID (SigninLogs, AADNonInteractiveUserSignInLogs, AuditLogs), Microsoft 365 (OfficeActivity). | |
| 9 | Generate 3-5 days of baseline activity for every user (normal sign-ins, mail, file access) before the attack. | |

## Teardown (before the trial ends)

1. Export all evidence to `evidence/` (sanitized).
2. Delete the Sentinel workspace / resource group.
3. Remove `nextlayersec.co` from the tenant and set its DNS back to parked
   (keep SPF `-all` and DMARC `p=reject` so it can't be spoofed).
4. Cancel the E5 trial and the Azure subscription so neither converts to paid.
