# Skills map

What each part of this lab exercises, mapped to:

- **Held certs** the work builds on: SC-900, CySA+, PenTest+, Security+.
  These are mapped by topic, not by exam objective number.
- **SC-300** (Identity and Access Administrator), skills measured as of
  2026-10-28: [study guide](https://learn.microsoft.com/credentials/certifications/resources/study-guides/sc-300).
- **SC-100** (Cybersecurity Architect), skills measured as of 2026-10-21:
  [study guide](https://learn.microsoft.com/credentials/certifications/resources/study-guides/sc-100).
- **Engineering work**: NICE Framework v2.2.0 work roles from
  `portfolio/docs/research/security-engineer-portfolio-gaps.md`, and the
  matching NRG task.

Objective text is quoted from the study guides (checked 2026-11-21). Exams are
revised often, so re-check before studying. "Exercised" means the lab makes
you do it hands-on; it is not a claim of exam coverage.

## Lab step → skills

| Lab step | SC-300 objective exercised | SC-100 objective exercised | Held cert it builds on | Engineering / NRG |
|---|---|---|---|---|
| Provision tenant, domain, roles, break-glass (`lab-setup.md` 1-4) | Configure and manage domains in Microsoft Entra ID and Microsoft 365; Configure and manage built-in and custom Microsoft Entra roles; Create and manage emergency access accounts | Design a solution for securing the administration of cloud tenants | SC-900 (Entra concepts) | Tenant onboarding at NRG |
| Fake users, license assignment | Create, configure, and manage users; Assign, modify, and report on licenses | — | — | User lifecycle |
| Security defaults off, MFA-only CA baseline (D5) | Plan Conditional Access policies; Implement Conditional Access policy assignments; Implement Conditional Access policy controls; Implement and manage tenant-wide MFA settings | Validate the alignment of Conditional Access policies with a Zero Trust strategy | Security+ (AAA, MFA) | CA reviews in TenantPosture |
| Onboard VM to Defender for Endpoint (D2) | Manage device join and device registration in Microsoft Entra ID | Specify security requirements for mobile devices and clients, including endpoint protection, hardening, and configuration | CySA+ (endpoint telemetry) | Defender XDR at NRG |
| Baseline script consent and Graph scopes (`baseline/`) | Configure and manage user and admin consent; Automate bulk operations by using the Microsoft Entra admin center and PowerShell | — | — | Read-scope Graph tooling (TenantPosture) |
| Sentinel workspace, Entra/M365/XDR connectors (steps 6-8) | Configure diagnostic settings, including configuring destinations such as Log Analytics workspaces | Design a solution for detection and response that includes XDR and SIEM; Design a solution for centralized logging and auditing, including Microsoft Purview Audit | CySA+ (SIEM, log sources) | PD-WRL-001 Defensive Cybersecurity |
| Attack: phish, cookie theft, replay, MFA method add, inbox rules (day 9) | — (attacker side) | Design and evaluate threat detection coverage by using MITRE ATT&CK matrices | PenTest+ (attack planning, rules of engagement, cloud attacks) | Threat-informed defense |
| Investigate sign-ins, audit logs, mailbox rules with KQL (days 11-17) | Review and analyze sign-in, audit, and provisioning logs; Monitor Microsoft Entra ID by using KQL queries in Log Analytics; Monitor, investigate and remediate risky users and risky sign-ins | Design and evaluate security workflows, including incident response, threat hunting, and incident management | CySA+ (incident response, threat hunting, log analysis) | PD-WRL-003 Incident Response; BEC cases at NRG |
| Identity Protection risk detections | Implement and manage user risk / sign-in risk by using Microsoft Entra ID Protection or Conditional Access policies | Design a modern authentication and authorization strategy, including Conditional Access, continuous access evaluation, risk scoring, and protected actions | — | Risk-based CA recommendations |
| Contain: revoke sessions, reset, remove MFA methods and rules (day 18) | Disable accounts and revoke user sessions; Implement and manage authentication methods | — | CySA+ (containment, eradication) | IR containment runbook |
| Playbook and lessons (days 21-24) | Implement continuous access evaluation; Configure authentication context *(as recommendations; implemented in Project 3)* | Design a resiliency strategy for ransomware and other attacks; Design a solution for SOAR, including Microsoft Sentinel and Microsoft Defender XDR *(design only)* | Security+ (IR process) | Client-facing IR guidance |
| Defender for Office 365 attack simulation | — | Evaluate solutions that include Microsoft Defender for Office 365 and Microsoft Defender for Cloud Apps | — | User awareness at MSP clients |

## Where this lab leaves gaps

The lab is a SOC/identity investigation, so these exam areas stay
untouched here. Projects that cover them:

| Exam area | Gap | Covered by |
|---|---|---|
| SC-300: Plan and implement privileged access (PIM for roles, groups, Azure resources; approvals; audit history) | Not used | Project 3 (CA and PIM as code) |
| SC-300: Token protection, session management, CAE, authentication context, protected actions | Recommended only | Project 3, rerunning this attack as the "after" test |
| SC-300: Entitlement management, access reviews, terms of use | Not used | Project 3 stretch, or a small governance lab |
| SC-300: Workload identities, app registrations, managed identities, Defender for Cloud Apps policies | Only Graph consent | Project 2 (CI service principal), drift monitor backlog item |
| SC-300: Hybrid identity (Connect Sync, Cloud Sync, PTA, AD FS migration) | Not used here | Already built in a separate hybrid identity lab (link to add) |
| SC-300: External identities, cross-tenant access, Global Secure Access | Not used | Backlog |
| SC-100: Infrastructure, posture management (Defender for Cloud, MCSB, Azure Policy, landing zones) | Not used | Azure landing zone backlog item |
| SC-100: Data and application security (Purview, Key Vault, WAF, AI) | Not used | Backlog |
| SC-100: Architecture documents (MCRA, Zero Trust, CAF/WAF alignment) | Not produced | Project 3 decision record should cite MCRA and Zero Trust explicitly |

## How to use this while studying

- After each phase, read the matching SC-300 Microsoft Learn module and note
  where the docs and the lab disagree. Those notes go in the write-up.
- For SC-100, write the playbook's "Lessons and prevention" section as an
  architect would: requirement, recommended control, trade-off, and how you
  would validate it.
