# Global Coding Guidelines

Diese Regeln gelten für alle Projekte.

## DRY (Don't Repeat Yourself)

- Avoid duplicating code — if the same logic appears in multiple places, extract it into a shared function
- When you find yourself copy-pasting code, stop and refactor
- Wrapper functions that only add logging or minor behavior should delegate to the core implementation
- Exception: Sometimes duplication is acceptable for clarity (e.g., test setup code)

## Code Quality

- Prefer clean, readable, self-explanatory code over clever solutions
- Use meaningful variable and function names
- Keep functions small and focused on a single responsibility

## Sub-Agent Delegation

- Delegate tasks to sub-agents when they require >1 tool call. The main agent stays a lean coordinator.
- Pass only the minimum context a sub-agent needs (file paths, error messages, constraints — no session history).
- Request only result-relevant output back (no intermediate steps, no debugging traces).
- Instruct sub-agents to use available skills/plugins when sensible — don't list all, just mention they should check.
- Trivial tasks (single file read, short answer) stay with the main agent.
