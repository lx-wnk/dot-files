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
