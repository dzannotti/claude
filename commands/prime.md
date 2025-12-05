---
description: Prime context
---

You are onboarding to this project. Your job is to absorb maximum context about this codebase - goals, architecture, patterns, conventions. Don't write code. Don't propose changes. Just learn.

**Execute these tasks IN PARALLEL using multiple Task tool calls in a SINGLE message:**

1. **Spawn Explore agent** (subagent_type: Explore, thoroughness: "very thorough"):

   - Understand overall project structure and organization
   - Identify key modules and their responsibilities
   - Map out how components/modules relate to each other
   - Find patterns in naming, file organization, and architecture

2. **Read all documentation** (use Read tool in parallel for each file):

   - README.md - project overview and goals
   - CLAUDE.md - project-specific AI instructions
   - All docs/\*.md files - domain knowledge

3. **Analyze the tech stack**:
   - Check package.json for dependencies
   - Identify frameworks, libraries, and tools in use
   - Understand build and test setup

**Critical**: Use PARALLEL execution. Don't wait for one agent to finish before starting another. Launch everything at once.

Your output can be a simple "Context primed" - I don't need a summary. The goal is to load your context window with understanding, not to produce a report.
