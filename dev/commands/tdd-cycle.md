---
allowed-tools: Task
description: Complete TDD cycle - tests, implementation, review, refactor
argument-hint: "<feature-description> (e.g., 'user authentication with JWT tokens')"
---

# TDD Cycle

Execute complete Test-Driven Development workflow for: `$ARGUMENTS`

## Workflow

1. Use `tdd-test-specialist` agent to create failing tests
2. Use `tdd-green-specialist` agent to implement minimal solution
3. Use `code-reviewer` agent to review implementation
4. Use `tdd-refactor-specialist` agent to improve code quality

Each agent handles its specific phase. Proceed sequentially.