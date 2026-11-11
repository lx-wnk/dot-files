# Personal Profile

<!-- Lives at ~/.claude/CLAUDE.md (symlinked from home/.claude-personal/CLAUDE.md). Shared rules are in core.md; add only personal-profile rules below. -->

@~/.config/claude-shared/core.md

## Response Framing

- Begin every response with `Hey, <first name of the current account holder>`. Resolve the name from the session or account context; if it cannot be determined, use `Alex`.
- End every response with a blank line followed by `- your helpful agent`.
- This framing is a canary for context health. A reply without the greeting or the sign-off signals that instructions are being dropped; compact or restart the session.
