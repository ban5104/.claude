# Claude Commands: Multi-Agent Orchestration System

A sophisticated command system that orchestrates specialized agents for complex development workflows.

## Architecture Overview

**Commands = Directors | Agents = Specialists**

- **Commands**: Orchestrate workflows, chain agents, handle complex multi-step processes
- **Agents**: Deep domain expertise, single responsibility, no inter-agent communication
- **Result**: Clean separation, composable workflows, scalable development patterns

## Core Development Workflows

### `/tdd-cycle <feature-description>`
**Complete Test-Driven Development pipeline**
```
tdd-test-specialist → tdd-green-specialist → code-reviewer → tdd-refactor-specialist
```
- Creates failing tests first
- Implements minimal solution
- Reviews implementation quality
- Refactors for maintainability

### `/fullstack-feature <feature-specification>`
**End-to-end feature development**
```
[fastapi|flask]-backend-architect → fullstack-api-integrator → frontend-designer-nextjs-shadcn → production-code-auditor → devops-automation-engineer
```
- Backend API implementation
- Frontend-backend integration
- UI component development
- Security and deployment readiness

### `/frontend-flow <component-requirements>`
**Production-ready UI development**
```
frontend-designer-nextjs-shadcn → ux-design-analyzer → e2e-visual-regression-tester
```
- Component implementation with shadcn/ui
- UX compliance review
- Visual regression baselines

### `/quality-gate [files-or-commit]`
**Comprehensive quality assurance**
```
code-reviewer → code-quality-auditor → production-code-auditor
```
- Immediate code review
- Technical debt analysis
- Production readiness assessment

### `/ai-system <ai-system-requirements>`
**AI system development pipeline**
```
[langchain-graph-architect|crewai-system-architect] → [backend-architect] → [integration] → [testing]
```
- Multi-agent system design
- Framework-specific implementation
- Integration with existing systems

## Utility Commands

### `/plan <requirements>`
**Strategic implementation planning**
- Requirement analysis
- Task breakdown with phases
- Risk assessment and mitigation
- Testing and deployment strategy

### `/security-review <target>`
**Security vulnerability assessment**
- OWASP compliance checking
- Code security analysis
- Infrastructure security review

### `/ui`
**UI/UX design framework reference**
- Design system guidelines
- Component standards
- Accessibility requirements
- Performance benchmarks

### `/workflows`
**Available workflow documentation**
- Lists all orchestration commands
- Usage examples and patterns
- Agent combination strategies

## Export Commands

### `/export [timeframe]`
**Data export utilities**
- `/export-day`: Daily data export
- `/export-week`: Weekly summaries
- `/export-hours`: Hourly breakdowns
- `/export`: General export functionality

## Testing Commands

### `/write-tests <target>`
**Comprehensive test creation**
- Unit test generation
- Integration test scaffolding
- Edge case identification

### `/write-code-to-pass-tests`
**Implementation from tests**
- TDD green phase implementation
- Minimal viable solutions
- Test-driven architecture

## Maintenance Commands

### `/undo`
**Safe rollback operations**
- Git-based reversions
- State restoration
- Conflict resolution

## Command Chaining Patterns

### Sequential Chaining
Commands that must run in order:
```bash
/plan "user authentication" → /tdd-cycle "JWT authentication" → /security-review "auth endpoints" → /quality-gate
```

### Parallel Processing
Commands that can run simultaneously:
```bash
/security-review "api/" & /quality-gate "frontend/" & /write-tests "utils/"
```

### Iterative Refinement
Commands that build on each other:
```bash
/frontend-flow "dashboard" → /ui → /frontend-flow "dashboard v2" → /quality-gate
```

### Cross-Domain Integration
Commands that bridge different domains:
```bash
/fullstack-feature "payments" → /ai-system "fraud detection" → /security-review "payment flow"
```

## Agent Specialization Matrix

| Domain | Specialist Agents | Command Orchestration |
|--------|------------------|----------------------|
| **Backend** | fastapi-backend-architect, flask-backend-architect | /fullstack-feature, /ai-system |
| **Frontend** | frontend-designer-nextjs-shadcn, ux-design-analyzer | /frontend-flow, /ui |
| **Testing** | tdd-test-specialist, tdd-green-specialist, tdd-refactor-specialist | /tdd-cycle, /write-tests |
| **Quality** | code-reviewer, code-quality-auditor, production-code-auditor | /quality-gate, /security-review |
| **DevOps** | devops-automation-engineer, e2e-visual-regression-tester | /fullstack-feature, deployment flows |
| **Integration** | fullstack-api-integrator, data-scientist | Cross-domain workflows |
| **AI Systems** | langchain-graph-architect, crewai-system-architect | /ai-system, agent orchestration |

## Best Practices

### Command Selection
- **Single feature**: Use `/tdd-cycle` or `/frontend-flow`
- **Full feature**: Use `/fullstack-feature`
- **Quality assurance**: Use `/quality-gate` before deployment
- **Planning**: Use `/plan` for complex requirements

### Agent Utilization
- Agents focus on single responsibility
- Commands handle coordination and handoffs
- No direct agent-to-agent communication
- Clean interfaces enforced by command layer

### Workflow Optimization
- Start with `/plan` for complex features
- Use progressive refinement patterns
- Chain quality gates throughout development
- Leverage parallel processing where possible

## Future Enhancements

See `/recommendations` for advanced patterns:
- Parallel processing workflows
- Intelligence amplification
- Cross-pollination patterns
- Dynamic agent selection

---

**Key Principle**: Commands orchestrate the symphony, agents are world-class specialists. This separation enables scalable, maintainable, and composable development workflows.