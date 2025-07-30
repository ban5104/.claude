# Master Claude Code Settings Repository

This repository serves as the central hub for all Claude Code configurations, agents, and commands. It contains the master copies of all Claude-related settings that can be referenced or deployed to individual projects.

## 📁 Repository Structure

```
master-.claude/
├── CLAUDE.md                 # Master Claude instructions and workflow configurations
├── settings.json             # Claude Code project settings
├── dev/                      # Development-focused agents and commands
│   ├── agents/              # Specialized AI agents for various development tasks
│   └── commands/            # Custom commands for development workflows
├── marketing/               # Marketing-focused agents
│   └── agents/              # Marketing and branding specialists
│   └── commands/            # Custom commands for marketing workflows
└── research-automation-suggestions/  # Research automation tools
    ├── agents/              # Research-focused agents
    └── commands/            # Research workflow commands
```

## 🤖 Available Agents

### Development Agents (`dev/agents/`)
- **api-integration-expert** - Specializes in API integrations and service connections
- **code-quality-auditor** - Ensures code meets quality standards
- **code-reviewer** - Performs thorough code reviews
- **crewai-system-architect** - Designs CrewAI system architectures
- **data-scientist** - Handles data analysis and ML tasks
- **debugger** - Expert at debugging complex issues
- **devops-automation-engineer** - Automates DevOps workflows
- **e2e-visual-regression-tester** - End-to-end and visual testing specialist
- **fastapi-backend-architect** - FastAPI backend design expert
- **flask-backend-architect** - Flask backend design expert
- **frontend-designer-nextjs-shadcn** - Next.js and shadcn/ui specialist
- **fullstack-api-integrator** - Full-stack API integration expert
- **langchain-graph-architect** - LangChain and graph database architect
- **production-code-auditor** - Reviews code for production readiness
- **tdd-green-specialist** - TDD implementation phase expert
- **tdd-refactor-specialist** - TDD refactoring phase expert
- **tdd-test-specialist** - TDD test writing expert
- **ux-design-analyzer** - Analyzes UX design patterns
- **visual-brand-auditor** - Ensures visual brand consistency
- **web-design-visual-consultant** - Web design and visual consulting
- **xero-api-specialist** - Xero API integration expert

### Marketing Agents (`marketing/agents/`)
- **brand-identity-consultant** - Brand identity and strategy specialist

### Research Agents (`research-automation-suggestions/agents/`)
- **industry-researcher** - Industry trends and analysis
- **market-researcher** - Market research and competitive analysis
- **technology-researcher** - Technology stack and tool research
- **use-case-researcher** - Use case identification and analysis
- **workflow-researcher** - Workflow optimization research

## 🛠️ Available Commands

### Development Commands (`dev/commands/`)
- **ai-system** - AI system development workflows
- **frontend-flow** - Frontend development workflows
- **fullstack-feature** - Full-stack feature development
- **quality-gate** - Code quality verification processes
- **recommendations** - Development recommendations
- **tdd-cycle** - Test-Driven Development cycle management
- **workflows** - General development workflows

### Research Commands (`research-automation-suggestions/commands/`)
- **competitive-analysis** - Competitive analysis workflows
- **parallel-research** - Parallel research execution
- **quick-research** - Quick research sprints

## 📋 Usage

### In Your Projects

1. **Copy the CLAUDE.md file** to your project root to inherit the master workflow configurations
2. **Reference specific agents** by copying them from the appropriate directory
3. **Use commands** to execute predefined workflows

### Updating Master Settings

1. Make changes to agents/commands in this repository
2. Commit and push changes to maintain version control
3. Pull updates in projects that reference these settings

### Example Integration

```bash
# Copy master CLAUDE.md to a new project
cp /path/to/master-.claude/CLAUDE.md ./

# Copy specific agents
cp /path/to/master-.claude/dev/agents/frontend-designer-nextjs-shadcn.md ./agents/

# Copy workflow commands
cp /path/to/master-.claude/dev/commands/tdd-cycle.md ./commands/
```

## 🔧 Core Tools & Workflow (from CLAUDE.md)

- **Context7** - Documentation lookup
- **Supabase** - Auth and database
- **MCP Code Sandbox** - Python testing
- **Playwright MCP** - E2E testing
- **ESLint MCP** - Code quality
- **Puppeteer** - UI/UX debugging

## 🚀 Best Practices

1. **Keep this repository updated** - This is your single source of truth
2. **Version control everything** - Track changes to agents and commands
3. **Test before deploying** - Verify agents/commands work before copying to projects
4. **Document changes** - Update this README when adding new agents/commands
5. **Follow the workflow** - Stick to the established workflow in CLAUDE.md

## 📝 Notes

- This is a living repository - continuously update and improve agents/commands
- Each agent is specialized for specific tasks - use the right agent for the job
- Commands can be chained together for complex workflows
- The CLAUDE.md file contains critical workflow information that should be followed

## 🔗 Repository

- **GitHub**: `git@github.com:ban5104/.claude.git`
- **Branch**: `main`