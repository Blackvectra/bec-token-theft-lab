# BEC and token-theft investigation lab

A simulated business email compromise (BEC) with session-token replay, run in
an isolated Microsoft 365 trial tenant and investigated with Microsoft
Defender XDR and Microsoft Sentinel.

**Status: in progress.** Nothing in `investigation/` is a finding until it is
backed by evidence in `evidence/` and marked Completed.

## Why

Token theft defeats MFA: the attacker replays a session the user already
authenticated. BEC is the most common incident an M365-focused MSP handles.
This lab produces a ground-truth attack, then investigates it blind against
that ground truth, so every detection and playbook step is tested rather than
assumed.

## Layout

| Path | Contents |
|---|---|
| [`PLAN.md`](PLAN.md) | Decisions and 30-day schedule |
| [`lab-setup.md`](lab-setup.md) | Tenant, licensing, Sentinel, budget guardrails, teardown |
| [`attack-plan.md`](attack-plan.md) | Scenario, ATT&CK mapping, the ground-truth action log |
| [`investigation/`](investigation/) | Timeline, findings with evidence, visibility gaps |
| [`hunting/`](hunting/) | KQL hunting queries (feed the detections-as-code project) |
| [`playbook.md`](playbook.md) | Investigate, contain, eradicate, recover |
| `evidence/` | Exported query results and screenshots (sanitized) |

## Scope and safety

- Lab tenant only, on its `onmicrosoft.com` domain plus `nextlayersec.co`.
  No production tenant, no real users, no real mailboxes.
- All phishing stays inside the tenant. No public phishing infrastructure.
- Evidence is sanitized: tenant IDs, object IDs and home IP addresses are
  redacted before commit.

## Limitations

- A simulated attack in a near-empty tenant has far less noise than a real
  one. Query precision here says little about precision in production.
- Trial licensing: features and retention are those of an E5 trial at the
  time of the run.
