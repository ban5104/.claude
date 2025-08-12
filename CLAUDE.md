CLAUDE.md - Project Guidelines
This file provides general guidance for working on this repository. The goal is to maintain a high-quality, consistent, and maintainable codebase.

Core Principles
Clarity and Simplicity (KISS): Write code that is easy to understand. Avoid unnecessary complexity.

Don't Repeat Yourself (DRY): Abstract and reuse code where possible. Avoid duplication.

Testability: All new logic should be written with testing in mind and must be covered by unit or integration tests.

Development Workflow
Follow this sequence for all changes:

Plan: Before writing code, outline your approach. If the task is complex, create a small plan or checklist first.

Implement: Write the code to solve the problem, following the core principles above.

Test: Run all relevant tests to verify your changes and ensure you haven't introduced any regressions.

Lint & Format: Run the project's linter and formatter to ensure code style and quality are consistent.

Commit & Push: Use the version control guidelines below to commit your work and open a pull request for review.

Code Quality Commands
make lint: Run the linter and code formatter across the project. This should be run before every commit.

Pull Requests: All code must be reviewed and approved via a pull request before being merged. Ensure all status checks (CI tests, linting) are passing.

make test: Run the entire test suite. This must pass before a pull request can be merged.

make test-watch: Run tests in watch mode for real-time feedback during development.

Version Control (Git) Guidelines
Branches: All work must be done in a feature branch (e.g., feat/add-user-auth). Do not push directly to main or develop.

Commits: Use the Conventional Commits specification for commit messages (e.g., feat:, fix:, docs:, chore:).

Git Worktrees
Use worktrees for parallel development to avoid branch switching and enable multiple Claude sessions.

Structure: Create worktrees as sibling directories to main repo (e.g., ../project-feature-name).

Commands:
- git worktree add ../project-feature-x -b feature-x: Create new worktree with branch
- git worktree list: Show all worktrees
- git worktree remove ../project-feature-x: Clean up when done

Workflow: Create worktree → Setup dependencies → Develop with commits → Push regularly → Create PR → Cleanup

Push regularly: End of day, major milestones, before risky changes. Each worktree needs separate npm install/pip install.

Naming: feature-*, bugfix-*, refactor-*, experiment-*