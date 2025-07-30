---
description: Launch parallel research agents on a topic
argument-hint: <research topic>
allowed-tools: Task, Read, Write, Bash
---

# Parallel Research: $ARGUMENTS

Deploy specialized research agents in parallel to comprehensively analyze: **$ARGUMENTS**

## Research Execution Plan

Launch ALL of the following research tasks simultaneously using the Task tool:

1. **Industry Analysis**
   - Use the industry-researcher agent to understand the industry/sector
   - Focus on core processes, pain points, and operational challenges
   - Identify areas where AI assistance would be most valuable

2. **Technical Solutions Research**  
   - Use the technology-researcher agent to identify AI/Claude Code capabilities
   - Research specific tools, integrations, and implementation patterns
   - Map technical solutions to identified business problems

3. **Use Case Development**
   - Use the use-case-researcher agent to create concrete implementation scenarios
   - Develop 3-5 detailed use cases with implementation blueprints
   - Include ROI estimates and success metrics

4. **Workflow Analysis**
   - Use the workflow-researcher agent to analyze current vs AI-enhanced workflows
   - Design optimized processes showing efficiency gains
   - Identify quick wins and transformation opportunities

5. **Market Intelligence**
   - Use the market-researcher agent to research existing solutions
   - Identify market gaps and differentiation opportunities
   - Analyze competitive landscape and trends

## Important Instructions

- Deploy all agents SIMULTANEOUSLY for maximum efficiency
- Each agent should focus specifically on aspects of: $ARGUMENTS
- Create output files in `./research-output/` directory
- After all agents complete, synthesize findings into a consolidated report

## Final Deliverable

Create `./research-output/$ARGUMENTS-synthesis.md` with:
- Executive summary of key findings
- Top 5 actionable opportunities
- Implementation roadmap
- Resource requirements
- Success metrics framework