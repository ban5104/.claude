---
allowed-tools: Task
description: Complete full-stack feature development - backend, integration, frontend, security, deploy
argument-hint: "<feature-specification> (e.g., 'payment processing with Stripe webhooks')"
---

# Full-Stack Feature

Implement complete feature from backend to deployment for: `$ARGUMENTS`

## Workflow

1. Use `fastapi-backend-architect` or `flask-backend-architect` agent for API
2. Use `fullstack-api-integrator` agent to connect frontend and backend
3. Use `frontend-designer-nextjs-shadcn` agent for UI implementation
4. Use `production-code-auditor` agent for security review
5. Use `devops-automation-engineer` agent for deployment setup

Choose backend architect based on existing codebase. Each phase must pass before proceeding.