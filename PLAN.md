# Lab runbook

Decided 2026-11-21. Start date: **not yet set** (day 1 = E5 trial sign-up).
Time budget: ~6-8 hours/week.

## Decisions

| # | Decision |
|---|---|
| D1 | 30-day window, schedule below. If behind, cut the buffer, never the investigation. |
| D2 | Victim works from a local Windows 11 VM onboarded to Defender for Endpoint. Attacker is the host machine on a phone hotspot or VPN exit. No Azure VMs. |
| D3 | Self-run attack, so investigation is not blind. The action log is sealed until the timeline is written. Investigation starts only from what the platform surfaced. Anything found only because the outcome was known is reported as a visibility gap, not a detection. |
| D4 | Baseline activity from a small Graph PowerShell script (`baseline/`) sending mail between fake users daily, plus manual sign-ins from the VM and a phone. Lab tenant only. |
| D5 | Security baseline: security defaults off; one CA policy requiring MFA for all users, break-glass excluded; no token protection, no risk-based policies. Shows MFA alone does not stop replay and gives the CA/PIM project a measured "before". |
| D6 | Forwarding target is an internal lab mailbox (`collector@`). The write-up notes the Exchange Online default external-forwarding block as a control that would have stopped this step. |
| D7 | Containment is executed in the lab (about day 18) after findings are written, and the replayed session is confirmed dead. Time to effective containment is recorded. |
| D8 | Published as a portfolio card under Detection & Response plus a write-up, only after the investigation is complete. |

## Schedule

| Days | Phase | Done when |
|---|---|---|
| Before day 1 | Finish this plan, build Windows 11 VM, write and dry-read the baseline script | VM ready, script reviewed |
| 1-3 | Provision (`lab-setup.md` steps 1-8, plus D5 baseline CA and `collector@`) | Sentinel shows trial banner; data connectors green |
| 4-8 | Baseline activity (minutes/day) | 5 days of sign-ins and mail for every user |
| 9 | Attack (~2 h), logging every action in `attack-plan.md` | Action log complete, then sealed |
| 10 | Wait | Telemetry settles |
| 11-17 | Investigate from incidents/alerts outward | Timeline and visibility gaps written |
| 18 | Contain (D7) and verify | Replayed session fails; timings recorded |
| 19-20 | Compare against the sealed action log | Detected / missed table |
| 21-24 | Playbook revision, write-up, sanitized evidence export | All `(untested)` tags resolved or explained |
| 25 | Cancel E5 trial and Azure subscription | Cancellation confirmed in both portals |
| 26-29 | Buffer, then teardown (`lab-setup.md`) | `.co` removed and parked with SPF -all / DMARC reject |

## Reminders

To schedule once the start date is known: day 25 (export + cancel) and
day 29 (teardown).
