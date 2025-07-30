# Agentic Software Engineering Workflow

Specialized AI agents for modern development workflows. Each agent handles specific phases of the software engineering lifecycle, from planning to production deployment.

## Workflow Stages

### 🎯 **Planning & Architecture**
- **`tdd-test-specialist`** - Requirements → failing tests, comprehensive test cases

### 🔧 **Implementation** `[BLUE]`
- **`tdd-green-specialist`** - Minimal implementations to pass tests
- **`frontend-designer-nextjs-shadcn`** `[PURPLE]` - Next.js + shadcn/ui components  
- **`fastapi-backend-architect`** `[BLUE]` - Async FastAPI APIs, Pydantic validation
- **`flask-backend-architect`** `[GREEN]` - Flask REST APIs, SQLAlchemy, Redis
- **`fullstack-api-integrator`** `[YELLOW]` - Frontend-backend integration, type-safe data flow
- **`crewai-system-architect`** `[CYAN]` - Multi-agent systems with CrewAI
- **`langchain-graph-architect`** `[ORANGE]` - LangChain/LangGraph workflows

### 🔍 **Quality Assurance** `[GREEN]`
- **`code-reviewer`** - Immediate post-implementation review
- **`tdd-refactor-specialist`** - Code quality improvements while keeping tests green
- **`ux-design-analyzer`** `[ORANGE]` - Design system compliance, accessibility  
- **`e2e-visual-regression-tester`** `[PINK]` - Visual testing with Playwright
- **`debugger`** - Root cause analysis, bug fixes

### 📊 **Analysis & Optimization**
- **`data-scientist`** - SQL queries, BigQuery analysis, data insights
- **`code-quality-auditor`** `[GREEN]` - Technical debt, deprecated code cleanup
- **`production-code-auditor`** `[PURPLE]` - Pre-deployment security & performance review

### 🚀 **Deployment & Operations** `[GREEN]`
- **`devops-automation-engineer`** - CI/CD, containerization, monitoring

## Visual Workflow Patterns

### 🔄 **TDD Development Cycle**
```
📋 Requirements → 🧪 Tests → ✅ Green → ♻️ Refactor
     ↓              ↓         ↓         ↓
tdd-test-spec → tdd-green → code-rev → tdd-refactor
```

### 🎨 **Frontend Development Flow**
```
🎯 Requirements → 🎨 Components → 🔍 UX Review → 📸 Visual Test
                      ↓              ↓             ↓
              frontend-designer → ux-analyzer → e2e-tester
```

### 🚀 **Full-Stack Feature Pipeline**
```
📊 Data Layer → 🔗 API Layer → 🌐 Frontend → 🔒 Security → 📦 Deploy
      ↓             ↓           ↓           ↓          ↓
  fastapi-arch → api-integr → frontend → prod-audit → devops
```

### 🤖 **AI System Architecture**
```
🧠 Multi-Agent → 📊 Data Flow → 🔧 Integration → ✅ Testing
      ↓              ↓             ↓            ↓
  crewai-arch    langchain    fullstack    debugger
```

### ⚡ **Quick Quality Gates**
```
💻 Code Change → 👀 Review → 🔍 Quality → 🚀 Production
      ↓            ↓          ↓           ↓
  (automatic)  code-rev → code-audit → prod-audit
```

Each agent is designed to work autonomously but integrates seamlessly into collaborative workflows. Use proactively based on development phase and requirements.

## Delegation Cheat Sheet

### Proactive Triggers (Use Without Being Asked)
- **`code-reviewer`**: Use immediately after writing/modifying code
- **`e2e-visual-regression-tester`**: MUST BE USED after UI changes, styling, or new components
- **`debugger`**: Use proactively when encountering errors/failures
- **`data-scientist`**: Use proactively for data analysis tasks
- **`tdd-test-specialist`**: Use proactively when starting new features

### Conditional Triggers (Use When...)
- **`tdd-green-specialist`**: Use when you have failing tests
- **`tdd-refactor-specialist`**: Use after tests pass to clean up implementation
- **`production-code-auditor`**: Use before production deployment for security/quality review
- **`ux-design-analyzer`**: Use after frontend-designer completes work or for design audits

### Integration Patterns
- **FastAPI + Frontend**: `fastapi-backend-architect` → `fullstack-api-integrator` → frontend
- **UI Development**: `frontend-designer-nextjs-shadcn` → `ux-design-analyzer` → `e2e-visual-regression-tester`
- **Quality Workflow**: `code-reviewer` → `code-quality-auditor` → `production-code-auditor`

### Effective Delegation Phrases
- "Use the [agent] to..." (explicit invocation)
- "I'll use the [agent] agent to..." (clear delegation)
- Context-based: Mention specific tasks that match agent descriptions
- Chain agents: "after [agent] completes" for sequential workflows

## 🎭 Multi-Agent Orchestration Commands

**Slash Commands for Automated Workflows:**

- **`/tdd-cycle`** - Complete TDD: tests → implementation → review → refactor
- **`/frontend-flow`** - UI development: design → UX review → visual testing  
- **`/fullstack-feature`** - End-to-end: backend → integration → frontend → security → deploy
- **`/ai-system`** - AI workflows: architecture → implementation → testing → integration
- **`/quality-gate`** - Quality pipeline: review → audit → production readiness
- **`/workflows`** - Show all available orchestration commands

**Installation:** Place `slash-commands/*.md` files in `.claude/commands/` directory

**Benefits:**
- Orchestrates multiple agents in single command
- Eliminates manual agent chaining
- Ensures complete workflow execution
- Includes proper error handling and validation
- Provides consistent, repeatable processes