# Global Coding Guidelines

Diese Regeln gelten für alle Projekte.

## Definition of Done

A task is finished only when every point below is satisfied AND evidenced:

1. All quality gates green — paste the raw output of the gate command, never a summary of it.
2. Changes committed AND the branch pushed (`git log origin/<branch>..HEAD` comes back empty).
3. For environment-facing features: behaviour verified in the target system (dev shop, preview URL, live PDP), not merely reasoned about from the code.

If any point is open, report it explicitly as `NOT DONE, open: …` instead of framing the current state as success.

## Evidence Before Claims

- Tag every conclusion `VERIFIED` (with the evidence inline — test output, SQL result, log line, quoted `file:line`) or `HYPOTHESIS`.
- For every `HYPOTHESIS`, name the cheapest command that would confirm or refute it.
- Never call a mitigation (masking, gate, cooldown) a "fix" — state what it prevents and what it does not.

## Delegation Contract

Hard rules on top of `## Sub-Agent Delegation` below.

- Before delegating: cut the work into units of at most ~3 files and show the list. Anything that would be an "L" unit gets split BEFORE delegation — every stall so far happened on an L unit.
- Every unit gets an acceptance criterion plus the exact verify command that must come back green.
- Every agent must end with the pasted gate output — real output, not a claim.
- After EVERY agent returns, before the next unit starts:
  1. Run `git status --short` and the gate yourself; do not trust the agent report.
  2. Diff the files actually changed against the files the agent claimed to change.
  3. Report any discrepancy before continuing.
- Agent with no commit after ~50k tokens: kill it and re-dispatch with a narrower scope.

## Scope Discipline

- Fix only what was asked for. No neighbouring code paths, no unrequested refactors.
- Before the first edit: name the planned file list with one sentence of justification each. More than 10 files: wait for confirmation.
- Findings outside the assignment go into a `FOLLOW-UPS` list at the end — do not fix them.

## Review Agent Budget

Scaled by diff size:

- `< 300 LOC` — 1 generalist
- `300–1000 LOC` — 2–3 agents (correctness, security, style)
- `1000–3000 LOC` — 5 (adds performance, tests)
- `> 3000 LOC` — up to 7, split by domain

ALWAYS state the planned agent count and the reason before spawning. From 5 agents upwards, wait for approval.

## Git & PR Workflow

- Never push directly to `main` (branch protection) — always a feature branch plus PR.
- NEVER `gh pr merge --delete-branch`. It has already closed a PR unmerged. Merge first, delete the branch as a separate step after verifying the merge.
- After every merge, paste `gh pr view <n> --json state,mergedAt` before reporting success.
- `gh pr merge --squash --admin` only when I explicitly allow it for that PR or that session. Without that, hand the merge back to me. If it is refused, do not retry.
- Before any merge series: show the merge plan (PR order, exact commands, expected blockers, verification command per merge) and wait for approval.

## MCP Fallbacks

- Atlassian: one ticket per call, never batched. On timeout retry exactly once; on the second timeout stop and ask me to paste the ticket text.
- Figma: request only the specific frame needed. On hitting the call limit, ask me for a screenshot.
- General: after the second failure of an external integration, switch to CLI/API or ask me for the input. A flaky integration degrades a session, it does not end it.

## Shell Safety (zsh)

- Single-quote git refspecs and search patterns — `!` triggers history expansion.
- Prefer `find … -print0 | xargs -0` over globs; no unquoted `$(…)` inside loops.
- Before any multi-file mutation: echo the file list and confirm the count is greater than zero. A rewrite pass has already run silently without matching anything.

## Env & Secrets

- Reading `.env` is blocked. Read config values through the container or framework instead: `docker compose exec php bin/console debug:container --env-vars | grep KEY`
- In `.gitignore`, never re-include a file out of a secret-bearing directory via a negation pattern (`!path`) — that has already re-exposed real secrets. Ignore each directory's contents explicitly and allow only named, verified-secret-free files, then confirm with `git check-ignore`.

## DRY (Don't Repeat Yourself)

- Avoid duplicating code — if the same logic appears in multiple places, extract it into a shared function
- When you find yourself copy-pasting code, stop and refactor
- Wrapper functions that only add logging or minor behavior should delegate to the core implementation
- Exception: Sometimes duplication is acceptable for clarity (e.g., test setup code)

## Language

- **Everything that ships is English**, without exception: code, identifiers, comments, commit messages (subject, body, trailers), PR titles and bodies, branch names, docs
- This holds regardless of the language of the conversation — a German chat still produces English artifacts
- Only the chat reply itself follows the language the user writes in

## Code Quality

- Prefer clean, readable, self-explanatory code over clever solutions
- Use meaningful variable and function names
- Keep functions small and focused on a single responsibility

## Comments

**Default to NO comment.** Before writing one, name which category justifies it:

1. Event or lifecycle timing the code cannot show
2. An HTTP, callback, or API contract imposed from outside
3. A non-obvious edge case
4. A mapping from case to effect

No category fits → delete it, improve names/structure instead.

- **Never** background, motivation, or history — that lives in the ticket.
- **Never** restate what the code does. No narrative docblock per class/method.
- Justified → one short line.
- Urge to comment comes from a chat explanation just given → it belongs in the PR description, not the source.

## Sub-Agent Delegation

- Always delegate tasks to sub-agents when they require >1 tool call. The main agent stays a lean coordinator.
- If working on a task, always work with an "agent-team" from various perspectives to ensure the best possible outcome. The main agent should work as an orchestrator / manager to those agents.
- Pass only the minimum context a sub-agent needs (file paths, error messages, constraints — no session history).
- Request only result-relevant output back (no intermediate steps, no debugging traces).
- Instruct sub-agents to use available skills/plugins when sensible — don't list all, just mention they should check.
- Trivial tasks (single file read, short answer) stay with the main agent.

## Obsidian Knowledge Base (MANDATORY – applies to every task)

The Obsidian vault is the central knowledge base. Access via Local REST API using curl (not MCP).
Env vars: `$OBSIDIAN_API_KEY`, `$OBSIDIAN_BASE_URL`, `$OBSIDIAN_ROOT` (default: `claude-memory`). Full curl reference: invoke skill `obsidian`.

### Before every task
Search for relevant notes:
```bash
curl -sk -X POST -H "Authorization: Bearer $OBSIDIAN_API_KEY" \
  "$OBSIDIAN_BASE_URL/search/simple/?query=KEYWORD" | python3 -c "import sys,json; [print(r['filename']) for r in json.load(sys.stdin)]"
```
Then read relevant files: `curl -sk -H "Authorization: Bearer $OBSIDIAN_API_KEY" "$OBSIDIAN_BASE_URL/vault/${OBSIDIAN_ROOT:-claude-memory}/PATH/TO/NOTE.md"`

### After every task / when new knowledge is gained
- Create or update notes via `PUT` (upsert) to `${OBSIDIAN_ROOT:-claude-memory}/{private|work|misc}/`
- Each note covers **one** topic only — keep notes granular, no catch-all notes
- If project-relevant: also persist to project memory at `~/.claude/projects/*/memory/`

### Session changelog (MANDATORY after every meaningful session)

After every session where real work was done (feature, bugfix, refactor, architecture decision), append an entry to the **scope-specific** session file:

**Path:** `${OBSIDIAN_ROOT:-claude-memory}/{category}/{project-name}/sessions/{scope}.md`

- `{category}` = `work` for client/employer projects, `private` for personal projects
- `{scope}` = Jira ticket (e.g. `ABC-123`), feature name (e.g. `checkout-tracking`), or module name — whichever best identifies the work area. Use the same scope file across multiple sessions on the same topic so history accumulates in one place.

**Append** a new entry at the **top** of the file (newest first):

```markdown
## YYYY-MM-DD – {Short description of this session's work}
**What changed:** {1–3 bullet points — what was implemented, fixed, or decided}
**Where:** {Key files or modules touched}
```

**Rules:**
- Skip trivial sessions (config tweaks, single-line fixes, exploration only)
- One entry per session, not per commit
- Keep bullets factual and terse — rationale belongs in a topic note, not here
- If a topic note also exists, link it once in the file header: `> Reference: [[{category}/{project}/{note}]]`
- After creating/updating a scope file, ensure `${OBSIDIAN_ROOT:-claude-memory}/{category}/{project-name}/sessions/_index.md` lists it: one line per scope file with a one-sentence description

### What to store in Obsidian (examples)
- Work project notes, tickets, status changes → `work/`
- New tools, plugins, MCP servers → `misc/`
- Personal projects or private insights → `private/`
- Conventions, architecture decisions, bugs → topic-specific note in `work/`
- Session changelogs (work projects) → `${OBSIDIAN_ROOT:-claude-memory}/work/{project-name}/sessions/{scope}.md`
- Session changelogs (private projects) → `${OBSIDIAN_ROOT:-claude-memory}/private/{project-name}/sessions/{scope}.md`
