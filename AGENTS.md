# AGENTS.md — rules for AI coding agents

> **Canonical** instruction file for every AI model working in this repo (Claude, Gemini, Codex, Cursor…).
> `CLAUDE.md` and `GEMINI.md` only point here. Edit this file, never those. Any new agent file (`CODEX.md`, `.cursorrules`, …) must be a short pointer to this file, never a copy.
> Humans: this is also the fastest onboarding read.

## 1. What this project is

**Invoice Desk** («سجل الفواتير») is an offline Flutter desktop app for a freelancer who invoices in Arabic and English. It covers clients, invoices, contracts and quotes, a calendar, backups, and vector A4 PDFs.

- Linux first; Windows and macOS build in CI.
- One SQLite file (drift).
- No account, no cloud, no network at runtime.
- Sync is designed but not built (ADR-0009, ADR-0010).
- Owner: Omar. Private repo `omarmaarouf18/invoice-desk`.

## 2. Read before you code

| Doc | When |
|---|---|
| `AI_CONTEXT.md` | **First, every session.** Current state, active brief, next task |
| `docs/briefs/<active brief>.md` | The work you were given (phases, decisions, stop rules) |
| `CONTRIBUTING.md` | Always. Codebase rules (layers, sizes, money, schema, commits) |
| `docs/ai/WORKFLOW.md` | Branches, task IDs, commits, gate, report format |
| `docs/ARCHITECTURE.md` | Any change that crosses a layer or adds a module |
| `docs/DATA_MODEL.md` + `docs/adr/0002`, `0004`, `0005` | Any schema, repository or backup change |
| `docs/adr/` | Before proposing a design change: check whether it is already decided |
| `docs/TESTING.md` | Before adding or re-baselining tests or goldens |

If a doc and the code disagree, **stop and ask** rather than guessing which one is right.

## 3. Golden rules (non-negotiable)

### 3.1 Layers
1. UI → repositories (`lib/data/repositories`, read via `lib/data/providers.dart`). The UI never imports DAOs, `db.dart`, `tables.dart` or drift.
2. `lib/core` and `lib/domain` are **pure Dart**: no Flutter imports. `test/architecture/layering_test.dart` enforces this.
3. Everything the PDF builders need comes in as plain data. `lib/pdf` never reads providers or the DB.

### 3.2 Data
4. Money is **integer minor units**; dates are `CalendarDate`; time comes from the injected `Clock`, never `DateTime.now()`.
5. Schema changes are **forward-only**. Each one needs:
   - a drift step;
   - `dart run drift_dev make-migrations`, with the committed snapshot;
   - a migration test that writes data at v(n) and reads it at v(n+1);
   - a regenerated `docs/DATA_MODEL.md`.
   - Backups from every earlier version must still restore (`test/data/backup_compat_test.dart`).
6. New syncable tables use `SyncRev` (and `ChildSync` for children) and write to `outbox` in the **same transaction**, like every existing table.
7. Deletes are soft (30-day trash, ADR-0004). A permanent delete writes a backup first.
8. Documents that were sent, paid or signed **never change appearance or content** because of a later edit elsewhere: clauses are snapshotted (ADR-0005) and styles are snapshotted (ADR-0012).

### 3.3 Language and direction
9. Every UI string goes in **both** `lib/l10n/arb/app_ar.arb` (template) and `app_en.arb`, then `flutter gen-l10n`. Use ICU plurals for counts. The parity test must pass.
10. Document text (PDF labels, dates, ordinals, currency names) comes from `lib/pdf/labels.dart` and `lib/domain/doc_format.dart`, **not ARB**. The document language is independent of the UI language (ADR-0011).
11. Geometry is Directional only: `EdgeInsetsDirectional`, `AlignmentDirectional`, `TextAlign.start/end`. Direction-specific icons go through `directionalIcon`/`Icons.adaptive`.
12. Explicit `TextDirection.ltr` is correct on numbers, emails, phones, IBANs and invoice numbers. Keep it. Free-text fields take their direction from their content.

### 3.4 PDFs
13. `pdf` is **vendored and patched** in `third_party/pdf` (ADR-0013). Never bump it or drop the override without re-applying `rtl-advance-width.patch`. `test/pdf/rtl_word_gap_test.dart` and `test/architecture/vendored_pdf_test.dart` must stay green.
14. Fonts are **bundled only**, with their licence file next to them. No runtime downloads (`google_fonts` is banned).

### 3.5 Code quality
15. Hand-written files ≤ 500 lines; `build` methods ≤ 80 lines (`tool/check_sizes.dart`). Split into named widget classes, never `_buildX()` methods.
16. Public API in `lib/core`, `lib/domain`, `lib/data/repositories`, `lib/account` and `lib/sync` has doc comments that say *why* and give units and edge cases.
17. No new runtime network access, telemetry, analytics or heavy dependencies. A new package needs a sentence of justification in an ADR or the brief's report.
18. Fixtures and samples use **fictional data only** («Acme Studio», «Sample Academy»). Never commit real names, phones, databases or backups.

## 4. Repo map

```
lib/
  app/          shell, providers, locale, UiPrefs (per-machine prefs)
  core/         pure Dart: money, dates, digits
  domain/       pure Dart: models, invoice/contract logic, calendar, doc_format
  data/         drift tables, DAOs, repositories (UI entry point), backup, seeds
  features/     one folder per screen: sidebar, editor, contracts, calendar, settings, library, trash…
  pdf/          invoice + contract builders, PdfStyle, DocLabels
  l10n/         arb/ (ar template, en) and gen/ (generated, never edit)
  widgets/      shared widgets
third_party/pdf vendored pdf 3.13.1 + RTL patch (ADR-0013)
test/           architecture, core, domain, data, drift, pdf, l10n, ui (+ goldens/)
docs/           ARCHITECTURE, DATA_MODEL, TESTING, RELEASING, adr/, briefs/, worklog/, ai/
scripts/        ci_local.sh (the gate), package_linux.sh
tool/           check_sizes, gen_data_model, coverage_report, check_licenses
```

## 5. Build, run, gate

- Toolchain: Flutter 3.44 / Dart 3.12, Linux desktop toolchain.
- Run on a throwaway DB: `INVOICE_DESK_DATA_DIR=$(mktemp -d) flutter run -d linux`.
- While iterating: `flutter test <file>` and `flutter analyze` on what you touched.
- **The gate, before every phase-end commit:** `./scripts/ci_local.sh --no-package`. It runs format, analyze, layering, sizes, codegen and l10n freshness, the schema guard, tests + coverage, goldens and the secret scan.
- Goldens are re-baselined **only deliberately**:
  - `flutter test --update-goldens --tags golden`;
  - look at every changed PNG and PDF dump;
  - commit them separately with the reason in the message.
  - Never update goldens just to turn a red gate green.

## 6. How agents work here (details: `docs/ai/WORKFLOW.md`)

- **Session start:** read `AI_CONTEXT.md`, then check that `git status --short` is clean or only holds your own changes. If another agent's changes or commits you can't account for are present, stop and ask.
- **Work only on the branch the task names.** Never push, merge, rebase, force-push, or use `--no-verify`. The owner pushes and merges.
- **Plan first** for anything that touches the schema, more than ~5 files, or a locked decision: write the plan in the worklog and wait for "go" if the brief says so.
- **Commits:** Conventional Commits with the task ID in the scope, e.g. `feat(STY-04): document_styles table and migration`. One logical change per commit. Golden re-baselines get their own commit.
- **Stop and ask when:**
  - a decision is needed that the brief or an ADR doesn't cover;
  - a change would alter the look or content of **existing** documents;
  - a migration would drop or rewrite user data;
  - a gate fails and you can't fix it within scope;
  - you want to deviate from the brief.
  - Write the question in the worklog and in your report, then stop.
- **Record decisions:** new ones as an ADR (`docs/adr/0000-template.md`); owner rulings as a dated line in the brief's "Decisions" table. Never silently change a decided default.
- **Keep docs true:** a doc sentence your change makes false is in scope. Fix it and list it under "Docs corrected" in the report.
- **Report** at the end of every phase or task in the format of `docs/ai/WORKFLOW.md` §5: literal command output, never reconstructed. Anything not run is listed as **unverified**.
- **Language:** code, comments, commits and docs in **English**. User-facing Arabic copy is natural Modern Standard Arabic. Chat with Omar in **Egyptian Arabic** unless he writes otherwise.
