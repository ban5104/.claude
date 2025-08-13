---
description: Run unit tests and spec validation for pre-PR workflow
argument-hint: "spec-name (without .json extension)"
---

Run the complete pre-PR test workflow:

1. Execute unit tests with ./test-unit.sh
2. Validate the acceptance spec with spec-check.js

Usage: `/test-spec user-login-endpoint`

!bash scripts/test-unit.sh && node scripts/spec-check.js specs/$ARGUMENTS.json