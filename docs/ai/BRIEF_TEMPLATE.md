# Brief — <title>

> Copy to `docs/briefs/YYYY-MM-DD-<slug>.md`. Written by the Planner after reading the code, approved by the owner, then handed to the Builder together with `AGENTS.md`.

**Branch:** `feat/<slug>` · **Base:** `<branch>@<short sha>` · **Task IDs:** `<AREA>-NN` … · **Status:** draft | approved | in progress | done

## 1. Goal

What the user gets when this is done, in 3–5 bullets. No implementation detail.

## 2. Current state (verified)

What exists today, with file paths and the facts the work depends on. Every row must have been checked in the code, not assumed.

| Area | Where | State |
|---|---|---|

### Known bugs in scope

- **B1** — symptom, where it shows, suspected cause (or "unknown").

## 3. Decisions

Defaults the Builder implements. The owner can change a row at any time; changes are added as new dated rows.

| # | Decision | Default | Date / by |
|---|---|---|---|
| D1 | | | |

## 4. Phases

### Phase N — <name> (`<TASK-ID>`)

- What to build, in order.
- Tests to add.
- **Done when:** observable conditions, e.g. "goldens X pass unchanged" or "sample PDF Y regenerated".

## 5. Definition of done (whole brief)

- `./scripts/ci_local.sh` passes, including goldens.
- The listed docs, ADRs and CHANGELOG entries are written.
- Old databases and backups open; existing documents look the same unless D# says otherwise.

## 6. Stop and ask

Brief-specific stop conditions, on top of `AGENTS.md` §6.

## 7. Out of scope

What is explicitly not part of this brief, so the Builder doesn't drift into it.
