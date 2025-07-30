---
description: Analyze AI competition in a specific industry
argument-hint: <industry>
allowed-tools: Task, Write
---

# Competitive Analysis: $ARGUMENTS

Research existing AI/automation solutions in **$ARGUMENTS** to identify opportunities.

Execute in parallel:

1. Use the market-researcher agent to find existing AI solutions for $ARGUMENTS
2. Use the industry-researcher agent to identify unmet needs in $ARGUMENTS
3. Use the use-case-researcher agent to develop differentiated solutions

Output: `./competitive-analysis-$ARGUMENTS.md` with market gaps and opportunities.