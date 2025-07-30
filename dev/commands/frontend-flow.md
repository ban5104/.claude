---
allowed-tools: Task
description: Complete frontend development flow - design, UX review, visual testing
argument-hint: "<component-requirements> (e.g., 'responsive dashboard with charts and filters')"
---

# Frontend Flow

Build production-ready UI component for: `$ARGUMENTS`

## Workflow

1. Use `frontend-designer-nextjs-shadcn` agent to implement component
2. Use `ux-design-analyzer` agent to review design compliance
3. Use `e2e-visual-regression-tester` agent to establish visual baselines

Each agent builds on the previous work. Proceed sequentially.