# BEC / token-theft response playbook

Status: **Draft outline**. Based on Microsoft's
[token theft playbook](https://learn.microsoft.com/security/zero-trust/security-operations-playbook-token-theft),
to be revised against what the lab actually showed. Steps marked *(untested)*
have not yet been exercised in the lab.

## 1. Triage

- Trigger sources: user report, Entra ID Protection (anomalous token,
  unfamiliar sign-in properties), Defender XDR incident, suspicious inbox rule
  alert. *(untested)*
- Scope question: one user or several? Pivot on the attacker IP and session
  ID across all users. *(untested)*

## 2. Investigate

- Sign-ins: interactive and non-interactive for the user, by IP, device,
  user agent, and session ID. A session ID seen from two IPs/devices is the
  core replay signal. *(untested)*
- Audit: new MFA methods, device registrations, app consents. *(untested)*
- Mailbox: inbox rules, forwarding, sent items, MailItemsAccessed. *(untested)*

## 3. Contain

Order matters: revoking sessions before resetting credentials lets the
attacker re-authenticate if they hold the password.

1. Disable the account or block sign-in. *(untested)*
2. Reset the password, then revoke refresh tokens / sign-in sessions. *(untested)*
3. Remove attacker-registered MFA methods and devices. *(untested)*
4. Remove malicious inbox and forwarding rules. *(untested)*
5. Block attacker IPs where it helps (VPN exits rotate). *(untested)*

## 4. Eradicate and recover

- Confirm no further sign-ins from the attacker session after revocation. *(untested)*
- Notify `finance`; recall or warn on the fraudulent email. *(untested)*
- Re-enable the user with phishing-resistant MFA. *(untested)*

## 5. Lessons and prevention

Feeds the Conditional Access / PIM project: token protection, risk-based CA,
sign-in frequency for sensitive actions, CAE strict location enforcement.
