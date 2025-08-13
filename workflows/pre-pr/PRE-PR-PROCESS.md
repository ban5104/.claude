# Pre-PR Process Documentation

Simple workflow for validating features using acceptance specs.

## Overview

The process is:
1. **Spec generation** - Use spec-generator agent to create specs
2. **Run tests** - test-unit.sh + spec-check.js
3. **Done** - Create PR when tests pass

## Quick Start

```bash
# 1. Ask the spec-generator agent in Claude Code:
"Create a spec for user login endpoint that accepts email/password and returns JWT"

# 2. Run your tests using the slash command:
/test-spec user-login-endpoint

# Or run manually:
bash scripts/test-unit.sh
node scripts/spec-check.js specs/user-login-endpoint.json

# 3. Create PR when tests pass
```

## Directory Structure

```
your-project/
├── specs/                    # Acceptance spec JSON files
│   └── example-post-api.json # Example spec file
├── scripts/
│   ├── test-unit.sh         # Unit test runner
│   ├── spec-check.js        # Spec runner and validator
│   └── test-harness.js      # HTTP testing utility
└── ... your project files
```

**Agent location:** `/Users/ben/.claude/agents/spec-generator.md`

## Workflow

### 1. Generate Spec

Ask the spec-generator agent to create your spec:

```
"Create a spec for user login endpoint that accepts email/password and returns JWT"
```

### 2. Run Tests

```bash
# Using the slash command (recommended):
/test-spec user-login-endpoint

# Or manually:
bash scripts/test-unit.sh
node scripts/spec-check.js specs/user-login-endpoint.json
```

### 3. Create PR

When tests pass, create your PR manually.

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

That's it! Simple workflow:
1. Spec-generator agent creates the spec
2. You run test-unit.sh + spec-check.js  
3. Create PR when tests pass

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

### Spec Runner

```bash
# Run specific spec
node scripts/spec-check.js specs/my-feature.json

# The runner will:
# - Validate the JSON schema
# - Execute each acceptance test command
# - Report results to console
# - Generate evidence files (if evidence/ directory exists)
```

## AI Agent Configuration

The `spec-generator` subagent is configured at `/Users/ben/.claude/agents/spec-generator.md`:

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

## Slash Command

A `/test-spec` command is available in Claude Code:

```bash
# Run both test-unit.sh and spec-check.js with one command:
/test-spec your-spec-name
```

This runs:
1. `bash scripts/test-unit.sh` - Unit tests for your project
2. `node scripts/spec-check.js specs/your-spec-name.json` - Spec validation

## That's It!

The workflow is intentionally simple:

1. **Ask spec-generator agent** to create your spec
2. **Run tests**: `/test-spec your-spec-name`
3. **Create PR** when tests pass

