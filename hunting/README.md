# Hunting queries

Status: **Untested**. These are starting points written before the lab ran.
Each is marked tested only after it returns the expected rows against the
lab's ground truth. Table and column names follow the Sentinel / Defender XDR
schemas; verify against the workspace before relying on them.

| File | Looks for | Tables |
|---|---|---|
| `session-replay.kql` | One session ID used from more than one IP | SigninLogs, AADNonInteractiveUserSignInLogs |
| `inbox-rules.kql` | New or changed inbox rules, especially hide/forward | OfficeActivity, CloudAppEvents |
| `mfa-method-added.kql` | Security info registered by the user | AuditLogs |
