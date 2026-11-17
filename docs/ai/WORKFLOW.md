# Workflow — briefs, branches, task IDs, commits, gate, reports

Invoice Desk is built by one owner with AI agents. The work moves in this loop:

**brief → phases/tasks → commits → gate → report → owner/reviewer check → next.**

## 1. Roles

| Role | Who | Does |
|---|---|---|
| Owner | Omar | Decides, approves, pushes, merges, releases |
| Planner/Reviewer | an AI model in chat | Reviews the code, writes the brief, reviews each report against `docs/ai/REVIEW.md`, drafts the owner's reply |
| Builder | an AI coding agent | Implements one brief, phase by phase, following `AGENTS.md` |

The Builder never reviews its own work as the final check: the Reviewer re-reads the diff, screenshots and goldens.

## 2. Briefs

- One brief per body of work: `docs/briefs/YYYY-MM-DD-<slug>.md`, from `docs/ai/BRIEF_TEMPLATE.md`.
- The brief holds the goal, the verified current state, a decisions table, phases with a "Done when" for each, stop rules and the report format.
- The brief has one branch, `feat/<slug>`, named in the brief. Each phase ends with a green gate and a report.
- Owner rulings during the work are added to the brief's **Decisions** table as a dated row. Rows are never deleted; a reversed ruling gets a new row.

## 3. Task IDs

Every phase or standalone task has an ID, `<AREA>-<NN>`:

| Area | Scope |
|---|---|
| `WF` | workflow, agent docs, CI, scripts |
| `DOC` | docs only |
| `L10N` | UI languages, ARB, direction |
| `PDF` | PDF builders, labels, vendored `pdf` |
| `STY` | document styles (engine, presets, editor) |
| `INV` | invoices (model, editor) |
| `CON` | contracts, quotes, clause library |
| `CAL` | calendar |
| `SET` | settings |
| `DATA` | schema, migrations, repositories, backup |
| `UX` | UX polish across screens |
| `TST` | test infrastructure, goldens |
| `REL` | packaging, release |

A brief maps each phase to an ID (e.g. Phase 3 = `INV-01`).

## 4. Commits and branches

- **Format:** Conventional Commits with the task ID as scope: `feat(INV-01): Arabic RTL invoice page`, `test(INV-01): re-baseline invoice goldens for the RTL layout`.
- **One logical change per commit.** Golden or sample re-baselines always get their own commit, with the reason.
- **A change outside the task's scope** (a shared widget, a doc fix) is called out in its own paragraph of the commit message and in the report.
- **No full 40-character SHAs in docs on feature branches.** Short SHAs go in reports. Never `--amend` a commit whose hash appears anywhere.
- **Agents never push, merge, rebase, force-push, or use `--no-verify`.** `main` moves only when the owner merges a branch whose gate is green.
- **Parallel agents** each work in their own worktree (`git worktree add ../invoice-desk-wt/<ID> -b feat/<slug>`), never in a shared directory. Two agents never own the same file in the same period. The brief or the owner assigns the lanes.

## 5. Report format (end of every phase or task)

```
## <TASK-ID> — <title>
**What changed** — 3–6 bullets, user-visible first.
**Files touched** — grouped by layer (domain / data / pdf / features / l10n / tests / docs).
**Gate** — the summary block of ./scripts/ci_local.sh --no-package, pasted literally; failures fixed on the way in.
**Commits** — literal `git log --oneline <base>..HEAD` for this phase.
**Samples** — paths of new/changed goldens, PDFs, screenshots.
**Docs corrected** — doc sentences fixed because the change made them false.
**Unverified** — anything not run or skipped, by name. "None" only if every gate ran.
**Open questions** — numbered, each with your recommended answer.
```

Never write illustrative or reconstructed output. Paste what was captured, or say it wasn't captured.

## 6. Worklogs and shared state

- Long-running notes, plans and half-findings go in `docs/worklog/<TASK-ID>.md` (template: `docs/worklog/README.md`), not in chat-only notes.
- `AI_CONTEXT.md` is updated **in place** when a phase finishes (State + Next). Never append history there.
- `CHANGELOG.md` gets an `[Unreleased]` entry per user-visible change.
- `Claude outputs/` and other agent scratch folders are git-ignored and never committed.

## 7. Speed rules

- Iterate with targeted `flutter test <file>`. Run the full gate once at the end of each phase.
- Timebox polish work (overflow at large text scales, pixel nudges) to 30 minutes per phase. List what's left in the report instead.
- Ask early. A stop at the right moment is cheaper than a wrong phase.
