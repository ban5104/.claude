# Development Tools & Workflow

## Core Tools
- Use context7 before writing code and when fixing errors **+ check for latest version changes**
- Use Supabase for auth and database
- Use MCP Code Sandbox for Python testing and prototyping **+ run ALL Python code here first**
- Use Playwright MCP for E2E testing: 
- Use ESLint MCP for code quality: 
- Use Puppeteer for UI/UX debugging **+ take screenshots to verify UI works**

## Development Workflow
note - Run tasks in parallel, wherever possible, but only if they are independent. Avoid race conditions or resource conflicts.

1. **Research and Setup**
```
Research → Context7 docs → **Verify package versions** → Create sandbox → Install dependencies
```

2. **Implementation**
```
Write code → **Test every function** → Test in sandbox → Fix issues → Re-test → Document
```

3. **Integration**
```
Integrate → Run full tests → UI testing with Puppeteer → **Check browser console** → Deploy
```

4. **Debugging Process**
```
Reproduce in sandbox → Isolate issue → Check latest docs → **Verify not deprecated** → Fix → Verify
```

## Code Quality Process
1. Write code → 2. Run ESLint → 3. Fix violations → 4. Explain fixes → **5. Test in actual environment**

## Tool Usage Guide
- **ESLint MCP**: All JavaScript/TypeScript code quality and security
  - **IMPORTANT**: Requires `eslint.config.js` (flat config format) in project root
  - Won't work with only `.eslintrc.json` - must have the new config format
  - Install ESLint locally: `npm install --save-dev eslint`
- **Playwright MCP**: Browser automation, E2E testing, UI workflows
- **MCP Code Sandbox**: Python code, risky experiments, package testing **- MANDATORY for Python**
- **Puppeteer**: Quick UI debugging, screenshots, manual testing **- verify functionality visually**
- **Context7**: Documentation lookup before coding or when stuck **- check publication dates**

## Extended Thinking
- any mention of "think" use extended thinking

## **NEW: Python Testing Protocol**
1. Run in MCP Sandbox first - no exceptions
2. Check all imports work
3. Test with actual data/API calls
4. Verify error handling

## **NEW: UI/UX Verification Steps**
1. Open in actual browser (not just assume it works)
2. Check browser console for errors
3. Test all click handlers and interactions
4. Verify API responses in Network tab

## Coding Principles
- DRY principle (Don't Repeat Yourself)

## Git Worktree Workflow for Parallel Development

### Quick Commands
- Create feature worktree: `wt feature-name`
- Switch worktrees: `wts branch-name`
- Save work: `git add . && git commit -m "WIP: description"`
- Push when ready: `git push -u origin branch-name`
- Clean up: `wtr branch-name`

### Parallel Claude Code Workflow
1. **Feature isolation**: Each Claude instance gets own worktree
2. **Independent commits**: Commit frequently in each worktree
3. **No conflicts**: Worktrees share git history but isolated working dirs
4. **Safe operations**: All git commands work normally in worktrees

### Worktree Best Practices
- Always commit locally before switching contexts
- Use descriptive branch names: `feature-auth`, `fix-memory-leak`
- Push only when feature is stable
- Each worktree has `.git` file (not directory) - this is normal
- Sync with main before pushing: `git fetch && git rebase origin/main`

### Common Patterns
```bash
# Start new feature in parallel
wt feature-payments
wtsave "Initial payment setup"

# Switch between active features
wts feature-auth
wts feature-payments
wts experiment-redis
```

## Project: UI Test - Xero Financial Dashboard Integration

### Architecture Overview
- **Xero Integration**: Custom OAuth2 implementation in `/api/routes/xero.py`
- **Financial Data**: Endpoints in `/api/routes/financial.py` 
- **Dashboard Components**: Financial pages in `/app/` directory
- **Mock System**: Development mode via `MOCK_XERO_API=true`

### Key File Locations
#### Xero Integration Core
- `/api/utils/xero_integration.py` - Main API client
- `/api/models/xero_token.py` - Token storage
- `/api/utils/xero_mock.py` - Mock data for development

#### Dashboard Components  
- `/app/cash-flow/page.tsx` - Cash flow analysis
- `/app/profitability/page.tsx` - P&L analysis
- `/app/financial-health/page.tsx` - Financial ratios
- `/components/ai/` - AI-powered financial insights

#### Configuration
- `.env.example` - Xero API credentials setup
- `/config/api_config.py` - API configuration

### Data Requirements by Component
- **Cash Flow**: Bank transactions, cash flow statements
- **Profitability**: P&L reports, invoice data, COGS
- **Financial Health**: Balance sheet, receivables/payables aging

### Development Commands
- Enable mock mode: `export MOCK_XERO_API=true`
- Test connection: `python scripts/test_xero_connection.py`
- Run dashboard: `npm run dev`

### Important Context
- Currently using custom HTTP client (not official Xero SDK)
- Has comprehensive mock system for API-free development
- OAuth tokens encrypted and stored in PostgreSQL
- Rate limiting and caching implemented via Redis

## AGI Dashboard Development Plan

### Project: Claude Improvement Dashboard
Location: ~/projects/agi-dash

### Architecture Overview
- Frontend: Next.js with shadcn/ui components
- Backend: Next.js API routes
- Data Sources: Three improver systems (hook, command, claude.md)
- Data Format: JSONL files from improver analysis

### Development Phases
1. Data Generation & Pipeline ✅
2. Frontend-Backend Integration ✅
3. Enhanced Data Processing ✅
4. Authentication & Multi-tenancy ✅
5. Advanced Features ✅
6. Testing & Quality Assurance (current)

### Key Commands
- Generate data: `./generate_improvement_data.sh`
- Run dashboard: `cd ~/projects/agi-dash && npm run dev`
- Test aggregators: `ts-node test-unified-aggregator.ts`
- Run unit tests: `npm test`
- Run E2E tests: `npm run test:e2e`
- Build production: `npm run build`
- Lint code: `npm run lint`
- Type check: `npm run type-check`

### Testing Protocol
1. **Unit Testing**: Test all utilities, components, and services in isolation
2. **Integration Testing**: Test API routes, database operations, and auth flows
3. **E2E Testing**: Test complete user journeys with Playwright
4. **Security Testing**: Validate input sanitization and auth security
5. **Performance Testing**: Ensure responsive loading and efficient data handling
6. **Cross-browser Testing**: Verify compatibility across modern browsers

### Quality Gates
- All tests must pass before merging
- Code coverage target: 80%+ for critical paths
- No ESLint errors or TypeScript warnings
- Successful production build required
- Manual UI verification for new features

### Important Notes
- Always run improvers first to generate data
- Dashboard expects JSONL files in specific format
- Use main branch for development, feature branches for major changes
- Run full test suite before production deployment