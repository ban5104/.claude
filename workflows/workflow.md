# Development Workflow

## Plain-English workflow (what most web teams actually do)

1. **Work on a feature in a branch** — you write code and run local tests. Good start.

2. **Run local pre-flight checks** — lint, tests, and spec-check (the tool we made). This gives you instant feedback: PASS/FAIL.
   - Uses `scripts/spec-check.js` to validate acceptance specs
   - Runs unit tests and linting before pushing

3. **Push branch & open a PR** — that creates a review request and triggers CI automatically.
   - Uses `scripts/prepare_pr.sh` to automate PR preparation

4. **CI runs the same checks remotely** — lint, unit tests, integration/e2e tests, security scans, the spec-check harness, and anything else the repo requires. CI produces logs and an "evidence bundle."
   - Evidence logs stored in `/evidence/` directory with timestamps
   - Includes unit-tests, secrets-check, and happy-path-http test results

5. **Code review** — humans review the PR (read tests, read important files, run quick manual checks if needed). Reviewers ask for changes or approve.

6. **Merge (automatic or manual)** — if CI is green and approvals match your policy, the PR gets merged. For low-risk leaf-node changes some teams auto-merge; high-risk changes (DB migrations, infra) require human sign-off.

7. **Post-merge pipeline / deployment** — additional CI/CD jobs may run (build, deploy to staging, run smoke tests, then optionally promote to production). Monitoring and rollback plans are in place.