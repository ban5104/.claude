---
allowed-tools: Task
description: Complete quality assurance pipeline - review, audit, production readiness
argument-hint: "[optional: specific files to check] (e.g., 'index.js' or 'components/' or leave empty for all changes)"
---

# Quality Gate

Run comprehensive quality checks on: `$ARGUMENTS` (or recent changes if not specified)

## Workflow

1. Use `code-reviewer` agent for immediate code review
2. Use `code-quality-auditor` agent for technical debt analysis
3. Use `production-code-auditor` agent for deployment readiness

Final phase provides GO/NO-GO decision. Address critical issues before proceeding.