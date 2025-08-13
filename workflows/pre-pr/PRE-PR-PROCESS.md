# Pre-PR Process Documentation

This document explains the complete pre-PR validation workflow using acceptance specs and automated testing.

## Overview

The pre-PR process validates code changes through:
1. **Spec generation** - AI agent converts feature requests into executable test specs
2. **Validation** - Run unit tests, linting, security checks, and acceptance tests
3. **Branch automation** - Create branches, commit specs, and open PRs

## Quick Start

```bash
# 1. Ask the spec-generator agent in Claude Code:
"Create a spec for user login endpoint that accepts email/password and returns JWT"

# 2. Agent saves spec and tells you:
"Spec saved to specs/user-login-endpoint.json - run ./scripts/prepare_pr.sh specs/user-login-endpoint.json to validate and create PR"

# 3. Run the validation and PR creation:
./scripts/prepare_pr.sh specs/user-login-endpoint.json

# 4. Review output and decide whether to proceed with the PR
```

## Directory Structure

```
├── specs/                    # Acceptance spec JSON files
├── scripts/
│   ├── prepare_pr.sh        # Main workflow orchestrator
│   ├── spec-check.js        # Simple spec runner
│   └── test-harness.js      # HTTP testing utility
└── .claude/agents/
    └── spec-generator.md    # AI agent for spec generation
```

## Workflow Steps

### 1. Spec Generation (AI Agent)

Ask the `spec-generator` subagent in Claude Code to create your spec:

```
"Create a spec for user login endpoint:
- POST /api/auth/login 
- Accepts {email, password}
- Returns JWT token and user info
- Should validate credentials and return 200 with {token, user: {id, email}}"
```

The agent will:
- Analyze your repo structure and existing scripts
- Generate valid JSON following the acceptance-spec v1 schema  
- Save to `specs/{feature-name}.json`
- Tell you the exact command to run next

### 2. Spec Validation & PR Creation

Run the script with your generated spec:

```bash
./scripts/prepare_pr.sh specs/user-login-endpoint.json
```

This will:
1. **Fast tests** - Run `pnpm lint` and unit tests
2. **Spec validation** - Execute all acceptance criteria  
3. **Branch creation** - Create feature branch and commit spec
4. **PR creation** - Push and open PR (if tests pass)

**Generated spec example:**
```json
{
  "version": "1.0",
  "name": "create-post-endpoint",
  "description": "POST /api/posts should create a post and return id and createdAt",
  "generated_by": "spec-generator",
  "generated_at": "2025-08-13T12:00:00Z",
  "acceptance": [
    {
      "id": "unit-tests",
      "type": "unit",
      "description": "Run unit tests for posts functionality",
      "command": "pnpm test -- --testPathPattern=posts",
      "expect": {"exitCode": 0}
    },
    {
      "id": "happy-post-http",
      "type": "http",
      "description": "Test POST /api/posts endpoint with valid input",
      "command": "node ./scripts/test-harness.js --method POST --path /api/posts --body '{\"title\":\"Hello\",\"body\":\"x\"}'",
      "expect": {"status": 201, "bodyContains": ["id", "title", "createdAt"]}
    },
    {
      "id": "secrets-check",
      "type": "static",
      "description": "Scan for hardcoded secrets and credentials",
      "command": "node ./scripts/check-secrets.js",
      "expect": {"exitCode": 0},
      "critical": true
    }
  ],
  "policy": {
    "risk_level": "low",
    "auto_merge_if_low_risk": false,
    "migration_requires_manual_approval": true
  }
}
```

### 3. Review and Decide

After running the script, you'll see output like:

```
✅ Fast tests passed
✅ Spec validation passed  
✅ Branch created: feat/user-login-endpoint
✅ PR created/updated. CI will run checks. Ready for review!
```

**You decide whether to:**
- ✅ Proceed with the PR if everything looks good
- ❌ Fix issues and re-run if tests failed
- 🔄 Iterate on the spec and try again

## Acceptance Spec Schema

### Required Fields

- `version`: Must be "1.0"
- `name`: kebab-case identifier
- `description`: One-line summary
- `generated_by`: Tool/agent that created the spec
- `generated_at`: ISO8601 UTC timestamp
- `acceptance`: Array of test items (minimum 1)
- `policy`: Risk and merge policies

### Acceptance Item Types

| Type | Purpose | Example Command |
|------|---------|----------------|
| `unit` | Unit tests | `pnpm test -- --testPathPattern=users` |
| `http` | API testing | `node ./scripts/test-harness.js --method POST --path /api/users` |
| `lint` | Code quality | `pnpm lint` |
| `static` | Static analysis | `node ./scripts/check-secrets.js` |
| `openapi` | API schema validation | `swagger-codegen validate spec.yaml` |
| `perf` | Performance testing | `node ./scripts/perf-test.js` |

### Expectation Formats

```json
{
  "expect": {
    "exitCode": 0                    // For unit/lint/static tests
  }
}

{
  "expect": {
    "status": 201,                   // For HTTP tests  
    "bodyContains": ["id", "email"]  // Required keys in response
  }
}

{
  "expect": {
    "p95_ms": 500                    // For performance tests
  }
}
```

**Important:** `exitCode` and `status` are mutually exclusive.

### Policy Options

```json
{
  "policy": {
    "risk_level": "low|medium|high",              // Default: "low"
    "auto_merge_if_low_risk": false,              // Default: false
    "migration_requires_manual_approval": true    // Default: true
  }
}
```

## Tools

### HTTP Test Harness

```bash
# Basic usage
node ./scripts/test-harness.js --method POST --path /api/posts --body '{"title":"Hello"}'

# With custom headers
node ./scripts/test-harness.js --method GET --path /api/users --header "Authorization: Bearer token"

# Custom base URL and timeout
node ./scripts/test-harness.js --method GET --path /health --base-url http://localhost:8080 --timeout 5000
```

Outputs structured JSON for spec validation:
```json
{
  "status": 201,
  "headers": {...},
  "body": {...},
  "timestamp": "2025-08-13T12:00:00Z"
}
```

### Secrets Scanner

```bash
node ./scripts/check-secrets.js
```

Scans for common secret patterns:
- `password = "..."`
- `api_key = "..."`
- `-----BEGIN PRIVATE KEY-----`
- Stripe keys (`sk_live_`, `pk_live_`)

### Spec Runner (Direct Usage)

```bash
# Run specific spec
node scripts/spec-check.js specs/my-feature.json

# View evidence after run
cat evidence/my-feature.results.json
```

## AI Agent Configuration

The `spec-generator` subagent is configured at `.claude/agents/spec-generator.md`:

**Key capabilities:**
- Reads acceptance-spec v1 schema for validation
- Examines repo structure for existing scripts
- Generates kebab-case names and IDs
- Ensures descriptions for all acceptance items
- Prevents exitCode/status conflicts
- Saves directly to `specs/{feature-name}.json`

**Usage in Claude Code:**
```
Use the spec-generator subagent to create a spec for this feature:

Feature: user registration
Goal: POST /api/auth/register creates new user account
Example: {"email":"user@test.com","password":"secret123","name":"John"}
Expected: 201 JSON with {id, email, createdAt}
```

## Common Workflows

### Standard Feature Development (Recommended)
```bash
# 1. Ask AI agent to generate spec
"Create a spec for my new feature..."

# 2. Run validation and create PR
./scripts/prepare_pr.sh specs/my-feature.json
```

### Quick Testing
```bash
# Run just the spec validation
node scripts/spec-check.js specs/existing-feature.json
```

### Manual Spec Creation
```bash
# Copy and modify existing spec
cp specs/example-post-api.json specs/my-new-feature.json
# Edit the JSON file manually
./scripts/prepare_pr.sh specs/my-new-feature.json
```

### Legacy Feature File Workflow
```bash
# If you have an existing feature.md file
./scripts/prepare_pr.sh feature.md
```

### CI Integration
```bash
# In .github/workflows/ci.yml
- name: Run acceptance specs
  run: |
    for spec in specs/*.json; do
      node scripts/spec-check.js "$spec" || exit 1
    done
```

## Troubleshooting

### Schema Validation Errors
- Check `schemas/acceptance-spec-v1.json` for exact format requirements
- Ensure `version: "1.0"` is present
- Verify all acceptance items have required fields: `id`, `type`, `command`, `description`
- Don't mix `exitCode` and `status` in `expect` objects

### Test Failures
- Check `evidence/{spec-name}.results.json` for detailed execution logs
- Verify commands work manually: `pnpm test -- --testPathPattern=posts`
- For HTTP tests, ensure service is running on expected port

### Spec Generation Issues
- Ensure feature.md has clear goal and example
- Check that Claude Code subagent has proper tool access
- Fallback generator uses frontmatter patterns like `testPattern: posts`

## Environment Variables

```bash
# Optional: specify different branch naming
BRANCH=feat/my-custom-name ./scripts/prepare_pr.sh feature.md

# Optional: custom spec directory
SPEC_DIR=acceptance-tests ./scripts/prepare_pr.sh feature.md
```

## Evidence & Artifacts

All test runs generate evidence files in `evidence/`:
- `{spec-name}.results.json`: Detailed execution results
- Includes spec content, command outputs, timestamps
- Used for debugging and CI artifact collection
- Automatically created by `spec-check.js`

## Next Steps

1. **Ask the spec-generator agent**: "Create a spec for [your feature]"
2. **Run the validation**: `./scripts/prepare_pr.sh specs/your-feature.json`
3. **Review the output and decide** whether to proceed with the PR
4. **Merge when CI passes**

The system keeps you in control while providing AI assistance for spec generation and automated validation.