# bec-token-theft-lab

Public BEC / token-theft investigation lab. Plan and decisions: `PLAN.md`. Exam and role mapping: `SKILLS-MAP.md`.

- Lab tenant only: the `onmicrosoft.com` domain plus `nextlayersec.co`. Never the `.dev` or `.io` tenants.
- Evidence is sanitized before commit; raw exports stay in the gitignored `evidence/raw/`. See `evidence/README.md`.
- CI (`.github/workflows/ci.yml`) fails on private IPs and on strings in the `REDACTION_DENYLIST` Actions secret, and runs PSScriptAnalyzer and the `baseline/tests` Pester suite.
- Results are labelled Completed or Proposed; KQL stays marked UNTESTED until it returns the expected rows against the ground truth.
