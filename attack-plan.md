# Attack plan

Status: **Proposed**. The action log is the ground truth the investigation is
checked against. Record exact UTC times, source IPs and user agents as each
step is run, and do not read this file while investigating.

## Scenario

An attacker phishes the `victim` user, captures their authenticated session,
replays it from a different network and device, establishes persistence, and
uses the mailbox to send a payment-change request to `finance`.

## Method

| Stage | How it is simulated | ATT&CK |
|---|---|---|
| Initial access | Attack simulation training (Defender for Office 365 P2) credential-harvest lure sent to `victim` | T1566.002 Phishing: Spearphishing Link |
| Session theft | Sign in as `victim` in browser A, export the session cookies | T1539 Steal Web Session Cookie |
| Session replay | Import cookies into browser B on a different network (hotspot or VPN exit) and access Outlook on the web | T1550.004 Use Alternate Authentication Material: Web Session Cookie; T1078.004 Valid Accounts: Cloud Accounts |
| Persistence | Register an additional MFA method from the replayed session | T1556.006 Modify Authentication Process: Multi-Factor Authentication |
| Defense evasion / collection | Inbox rule that moves messages containing "invoice", "payment", "wire" to RSS Feeds and marks them read | T1564.008 Hide Artifacts: Email Hiding Rules |
| Collection | Forwarding rule to the internal `collector@` lab mailbox (external auto-forwarding is blocked by default in Exchange Online; noted as a control) | T1114.003 Email Collection: Email Forwarding Rule |
| Impact | Internal email to `finance` requesting a change of bank details | T1534 Internal Spearphishing |

Not simulated: public adversary-in-the-middle phishing kits. They require
hosting phishing infrastructure on the internet and add nothing to the
investigation that cookie replay does not already produce.

Technique IDs should be re-checked against attack.mitre.org before publishing.

## Ground-truth action log

| UTC time | Actor | Network / device | Action | Expected telemetry |
|---|---|---|---|---|
| | | | | |
