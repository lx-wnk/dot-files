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
- When new evidence contradicts an earlier claim, say so explicitly: name the claim, the evidence that
  killed it, and the corrected conclusion. Never revise a position silently.

## Reports, Sparring & Decisions (HARD RULE)

Every report, every finding, every trade-off I am asked to decide is presented in this exact
five-step structure — always, unprompted, in chat and in written deliverables alike:

1. **Name the topic** — one heading, no preamble.
2. **Explain the topic** as simply as possible. Assume no prior context on this specific
   mechanism, however senior the reader.
3. **Explain why it is a problem** and what the concrete impact is — who is affected, how
   often, what breaks. Quantify it where a query or a count can be run.
4. **Show 1-5 solution options**, each with an explicit pro/con list. Options must be
   researched, not invented: quote `file:line` from the codebase AND check external best
   practices (web search, official docs, RFCs) for the pattern in question.
5. **Give a recommendation** — one option, named, with the reason it beats the runners-up.

Rules:

- A bare finding list is never an acceptable substitute. It shifts the work of reconstructing
  the mechanism and the option space onto me.
- "Do nothing / accept it" is a legitimate option and should appear whenever it is defensible.
- Tag evidence `VERIFIED` or `HYPOTHESIS` per the section above; a `HYPOTHESIS` names the
  cheapest command that settles it.
- Correct the source when a finding handed to me (from an agent, a ticket, a review) turns out
  to be wrongly reasoned — state the correction before presenting the options.
- Applies to code reviews, architecture choices, migration strategies, estimates, incident
  write-ups — anything where I have to choose. Global, all projects.

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
- Before the first edit: name the planned file list with one sentence of justification each.
- Stop and ask before touching any file outside that list. Do not decide alone that the extra work is obviously right.
- Nothing leaves this session unapproved: no file write, no Jira update, no estimate, no push. Print the
  exact payload first — for Jira every field being sent, including the ones sent unchanged, so an
  accidental clear is visible — then wait for `lgtm`.
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

## Command & Code Blocks

Every block gets a heading that names WHERE it runs, and blocks from different
places are never merged. The user copies a block as a whole; sorting lines by
hand is the failure this prevents — a remote command pasted locally hits the
wrong machine.

For blocks that are RUN (shell, ad-hoc SQL, psql/mysql sessions): open and
close the block with a separator written in that language's comment syntax, so
the block stays paste-safe.

### 📦 Box / Remote (`<host>`)

```bash
# ══ BOX (testing.example.com) ═════════════════════
sudo systemctl restart some.service
# ══════════════════════════════════════════════════
```

### 💻 Lokal (Repo-Worktree)

```bash
# ══ LOKAL ═════════════════════════════════════════
make deploy
# ══════════════════════════════════════════════════
```

SQL uses `--` for the separator, YAML/shell `#`, Go/PHP/JS `//`.

For code that goes INTO a file, no separators inside the block — they would be
pasted into the source. Name the file path in the line above the block instead.

Prose, explanation and reasoning stay outside the block. Inside: executable
lines and short comments only.

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

## Drafting Messages for Me (Slack, Teams, Jira, PR replies, customer threads)

- Before drafting any message I will send to someone else, read Obsidian
  `claude-memory/misc/Message-Style-Alexander.md` and my own earlier messages in the same thread.
- Whenever I rewrite, shorten or reject a draft, update that note immediately: add the rule and a
  before/after excerpt to its learning log. Never in a later turn — in the same turn.
- The five-step report format is for me only; messages to others follow the style note.

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
- Review and analysis sub-agents run read-only. Before dispatching one, check the tool list it actually
  gets: if the harness added `Edit`/`Write` on top of the definition, say so instead of assuming the
  definition holds. `Bash` is a write channel too — a reviewer with `Bash` is not read-only.
- A sub-agent finding is a `HYPOTHESIS` until re-checked in the main session against the file it names.
  Never commit, report or write it back on the sub-agent's word alone.

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
- Obsidian writes (session logs, index, topic notes) need no approval — write them whenever there is something to record. The approval rule in Scope Discipline does not apply to the vault.
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

## Engineering Principles

Two axes per rule: **zone** (where it applies) and **HARD / DEFAULT** (may it be broken).
HARD is never broken. DEFAULT is broken only with the reason named in the same message.
Rationale, sources and the derivation of the conflict matrix:
Obsidian `claude-memory/work/Conventions-Code-Prinzipien.md`.

### Zones

- **Boundary** — anything accepting foreign input: HTTP, CLI, queue, DB read, third-party API, file import.
- **Core** — own domain logic, called only by own code.
- **Extension** — extension points for third parties: plugin hooks, events, public interfaces.

### Conflict resolution

- **Fail-Fast vs. Defensive** — validate at the Boundary, crash loudly inside the Core. Never both in one place.
- **YAGNI vs. OCP** — no extension point in the Core; extension points in the Extension zone from the first external consumer onward.
- **DRY vs. Bounded Context** — DRY stops at the context boundary. The same logic in two contexts stays duplicated.

### HARD

- **Fail-Fast** [Core] — invariant violated, throw. Never return null/false/default to keep going.
- **Defensive Validation** [Boundary] — every foreign input validated and typed before it reaches the Core.
- **Single Source of Truth (state)** — one owner per piece of state. A derived value is computed, never stored a second time.
- **Tests** — Unit + Integration for every behaviour change; Mutation tests for money, auth and permission paths.
- **Reversible Migrations** — every migration has a tested down path, or a written note why it cannot have one.
- **Backwards Compatibility** [Extension] — public signature changes go through deprecation, never a silent break.
- **Explicit over Implicit** — no magic strings, no convention-only wiring, no hidden global state.
- **Idempotency** [Boundary] — every handler that can be retried is safe to run twice.

### DEFAULT

- **KISS** — simplest thing satisfying the requirement. Cleverness needs a named reason.
- **DRY** — the third occurrence extracts, not the second. Stops at the context boundary.
- **YAGNI** [Core] — no code for a speculative requirement. Build on the concrete case.
- **OCP** [Extension] — extend by adding an implementation, not by editing the existing one.
- **SRP** — one reason to change per class. Two reasons, split it.
- **ISP** — a client depends only on the methods it calls. Fat interface, split it.
- **DIP** — the Core depends on interfaces it owns; implementations depend on the Core, never the reverse.
- **LSP** — a subtype is substitutable without a caller-side type check.
- **Separation of Concerns** — no persistence in the domain, no domain logic in a controller.
- **Dependency Rule (Ports & Adapters)** — dependencies point inward. Infrastructure imports domain; domain imports nothing outward.
- **Bounded Context** — one model per context. Cross-context communication only through an explicit contract.
- **High Cohesion / Loose Coupling** — what changes together lives together; what does not change together does not import each other.
- **Composition over Inheritance** — inherit only for genuine substitutability, otherwise inject collaborators.
- **Tell, don't ask** — call behaviour on the object; do not pull its state out to decide about it.
- **Immutability by default** — value objects and DTOs immutable. Mutable only for a measured reason.
- **Clean Code (Martin)** — meaningful names, a function does one thing, 0-3 arguments, command-query separation.
- **Observability by default** — every failure path logs cause and correlation id. No silent catch.
- **Least Astonishment** — the same name means the same thing everywhere; no surprising side effect behind a getter.
- **Boy Scout Rule** — leave touched code cleaner. Touched, not neighbouring — cf. Scope Discipline.
- **Small Diffs** — one intent per commit, one topic per PR.
- **Spec Driven Development** — spec before code. No spec: ask for one instead of inventing requirements.
- **Reversibility over Perfection** — a reversible decision ships now; an irreversible one is worth an extra round.

### Anti-Principles — do NOT optimize for these

- No DRY across context boundaries.
- No interface with a single implementation.
- No microservice without a team boundary behind it.
- No config for a value that never changes.
- No abstraction before the third concrete case.
