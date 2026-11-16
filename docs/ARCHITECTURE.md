# Architecture

Invoice Desk is a Flutter desktop app, offline-first. It has one SQLite database, no network code, and a UI in Arabic (RTL) that produces bilingual PDFs. This page explains how the code is laid out and why. The decisions behind it are recorded in [docs/adr/](adr/).

## Layers and the dependency rule

```mermaid
flowchart TB
  subgraph UI["UI — lib/app, lib/features, lib/widgets, lib/theme"]
    W[Widgets] --> C[Controllers / ViewModels<br/>Riverpod Notifiers]
  end
  subgraph DATA["Data — lib/data"]
    R[Repositories<br/>lib/data/repositories] --> D[DAOs] --> DB[(SQLite via drift)]
    B[BackupService]
  end
  subgraph CORE["Pure Dart — lib/domain, lib/core"]
    M[Models, rules, results<br/>money, dates]
  end
  PDF[lib/pdf<br/>data → bytes]
  SEAMS[lib/account, lib/sync<br/>interfaces + local/no-op]

  C --> R
  C --> B
  W --> PDF
  C --> M
  R --> M
  PDF --> M
  C --> SEAMS
```

Dependencies point down and inward only:

- **UI** (`lib/app`, `lib/features`, `lib/widgets`) talks to the data layer only through repositories and services, read via the providers in `lib/data/providers.dart`. It never imports `data/daos`, `data/db.dart`, `data/tables.dart` or `package:drift`.
- **Repositories** (`lib/data/repositories/`) wrap the DAOs.
  - They return domain models and typed results (`SaveResult`, `DeleteResult`, `RestoreResult`) instead of DAO exceptions.
  - They run every write under the injected `Clock`.
- **Domain and core** (`lib/domain`, `lib/core`) are pure Dart: no Flutter, no drift. `@immutable` comes from `package:meta`. All the business rules live here (totals, numbering, milestones, variables, validation), so they are unit-tested without a widget tree.
- **PDF** (`lib/pdf`) is a pure function from data to PDF bytes.

The rule is enforced by `test/architecture/layering_test.dart`. Size limits (no hand-written file over 500 lines, no `build` method over 80) are enforced by `tool/check_sizes.dart`. Both run in CI and in `scripts/ci_local.sh`.

## Folder map

```
lib/
  main.dart, bootstrap.dart   window setup, data folder, DB open/migrate, provider overrides,
                              start-up housekeeping (purge + daily backup), DB-error screen
  app/                        app widget, shell (sidebar + workspace, shortcuts), UI providers, ui_prefs
  core/                       Money/MoneyBag (minor units), CalendarDate, digit folding
  domain/                     models, invoice/contract rules, results, trash, contract_ops
  data/
    tables.dart, triggers.drift, db.dart, db.steps.dart   schema + migrations
    daos/                     drift queries per aggregate
    repositories/             what the UI uses
    providers.dart            DB seam, repositories, live read models
    backup.dart               VACUUM INTO backups, restore, start-up housekeeping
    library_seed.dart, seed.dart   clause library seed, fresh-install seed
    demo_seed.dart            the fictional demo set (dated from the clock, flagged is_demo)
  features/
    sidebar/                  search, filters, client groups, document rows
    editor/                   invoice editor (controller, cards, sections table)
    contracts/                contract editor (controller, cards, actions, preview)
    library/                  clause library editor
    trash/                    المحذوفات
    calendar/                 التقويم: controller, month/week/agenda views, day panel, banners, actions
    settings/, clients/       settings page, client dialogs
  pdf/                        invoice_pdf + parts, contract_pdf + parts
  account/, sync/             future subscription and sync seams (local/no-op today)
  widgets/, theme/, l10n/     shared widgets, tokens, Arabic strings (keys ready for English)
drift_schemas/                committed schema snapshots, one per version
tool/                         check_sizes, gen_data_model (+ dev helpers)
scripts/                      package_linux.sh, ci_local.sh
```

Large feature UIs are split into `part` files per card (for example `features/contracts/cards/`) so private widgets stay private to their feature.

## State management (Riverpod 3)

| Provider | Owns | Kind |
|---|---|---|
| `databaseProvider`, `appPathsProvider`, `uiPrefsProvider` | Seams overridden in bootstrap and tests | `Provider` (throws unless overridden) |
| `clockProvider` | The one clock for UI dates and data timestamps | `Provider<Clock>` |
| `*RepositoryProvider`, `backupServiceProvider` | Data access | `Provider` |
| `clientsProvider`, `invoicesProvider`, `contractsProvider`, `libraryProvider`, `settingsProvider`, `trashProvider` | Live read models (drift watch streams) | `StreamProvider` |
| `editorProvider` | The open invoice's edit buffer, save status, validation issues, revision | `Notifier<EditorState>` |
| `contractProvider` | The open contract's buffer, lock, missing-variable focus | `Notifier<ContractEditorState>` |
| `openResolverProvider`, `openMissingProvider` | Variable resolution for the open contract | derived `Provider` |
| `sidebarDataProvider` | Filtered, grouped sidebar (pure `buildSidebar`) | derived `Provider` |
| `workspaceProvider`, `previewTabProvider`, `searchQueryProvider`, `sidebarFilterProvider`, `themeModeProvider` | UI state | small `Notifier`s |
| `accountServiceProvider`, `syncServiceProvider` | Future subscription/sync; local and no-op today | `Provider` |

Widgets read with `ref.watch(x.select(...))` for display and `ref.read(x.notifier)` in callbacks. Each editor has one write path: the controller edits an immutable buffer, and a debounced save goes through a repository.

## Data flow: edit invoice → autosave → PDF preview

```mermaid
sequenceDiagram
  participant U as User
  participant W as Card widget
  participant E as EditorController
  participant R as InvoiceRepository
  participant DB as SQLite
  participant P as PreviewPane
  U->>W: types a price
  W->>E: edit(inv => inv.copyWith(...))
  E->>E: new immutable buffer, status=dirty, revision++
  E-->>P: revision changed
  P->>P: debounce 300 ms, buildInvoicePdf(snapshot) → PdfPreview
  E->>E: debounce 1.5 s
  E->>R: save(invoice)
  R->>DB: one transaction: invoice row + replace sections/items
  DB-->>R: Saved | DuplicateNumber
  R-->>E: SaveResult
  E->>E: status=saved (or invalid with issues)
  DB-->>W: watch streams re-emit → sidebar updates
```

Switching documents, exporting and closing the window all flush the buffer first. Edits that arrive during a save stay dirty and get their own save.

## Money

Amounts are integer **minor units** (hundredths). Rates are **basis points** (1400 = 14%) with half-up rounding (`applyBasisPoints`). `MoneyBag` keeps totals per currency and never adds across currencies: an invoice with EGP and USD sections shows `22,000 EGP + $255.50`.

Contract milestones split the total by **largest remainder**, so percentages that add up to 100% always add up to the total exactly (`milestoneAmounts`).

## Numbering

- Invoices are `<prefix>-<year>-<seq:0000>`. The next sequence is the year's maximum plus one, deleted invoices included, so a number is never reused. A hand-typed free-form number keeps its text and gets an unused sequence.
- Contracts are `CT-…` and quotes `QT-…`, with separate sequences. Amendments reuse the original's series, year and sequence with an `-A<n>` suffix.
- Uniqueness is enforced by the database (`UNIQUE(number)` and composite keys), not only by the UI.

## Soft delete, trash and purge

Deleting sets `deleted_at` (UTC ms) and the row moves to "المحذوفات".

- **Batches.** Rows deleted together share the stamp. Undo, and restore from the trash, bring back exactly that batch.
- **Guards.** Triggers refuse to leave a live document under a deleted client. Hard-deleting a client with any document rows is refused by `ON DELETE RESTRICT`.
- **Purge at start-up.** Housekeeping removes rows deleted more than 30 days ago: contracts, then invoices, then clients nothing references.
- **Manual purge.** "حذف نهائي" and "إفراغ المحذوفات" do the same immediately, after a typed confirmation and a `before-purge-…` backup.

## Backups

`BackupService` checkpoints the WAL, then runs `VACUUM INTO` to a temp file, reopens it to verify the invoice count, and only then renames it into place. A live WAL database is never copied with a file copy.

- **Daily.** At start-up when the last backup is over 24 h old, the last 30 are kept.
- **Before risky actions.** `before-delete-client-…` and `before-purge-…` files are written before those actions and never pruned.
- **Restore.** Restore writes a safety copy first, then replaces the data in one transaction with named columns. That way, backups from older schema versions load into the current one, and a backup without a clause library keeps the current library.

## Migrations

The schema lives in `lib/data/tables.dart` and `lib/data/triggers.drift`, and `currentSchemaVersion` is in `AppDatabase`. A schema change takes these steps:

1. Bump the version.
2. Run `dart run drift_dev make-migrations`. It writes `drift_schemas/app_db/drift_schema_vN.json`, `lib/data/db.steps.dart` and the test helpers.
3. Write the `fromXToY` step.
4. Extend `test/drift/app_db/migration_test.dart` with data.
5. Rehearse on a database created by the previous release (see [TESTING.md](TESTING.md)).

CI fails if the schema changed without a new snapshot. Migrations run inside the app on first open. Nobody backs up by hand: the daily backup and restore's support for older versions are the safety net.

## PDF pipeline

`buildInvoicePdf(InvoicePdfData, PdfFonts)` and `buildContractPdf(ContractPdfData, PdfFonts)` are pure: data in, bytes out.

- **Fonts.** IBM Plex Sans Arabic is bundled and embedded, so all text is vector.
- **Builders.** Each document is assembled by small builder extensions in `lib/pdf/invoice/` and `lib/pdf/contract/` (header, parties, tables, totals, signatures, footer).
- **Arabic text.** Direction is chosen per run, with the font's normal word spacing. The `pdf` package is vendored with a one-line RTL fix (`third_party/pdf`, [ADR 0013](adr/0013-vendored-pdf-rtl-fix.md)): upstream mirrored words by their ink box, so words ending in ر or ز ran into the next word. `test/pdf/rtl_word_gap_test.dart` measures the gaps. A date ending in digits is laid out as two runs so its space survives bidi reordering.
- **Contract variables.** Resolved at render time by `VariableResolver` and never stored resolved; unresolved ones are drawn on an amber background.
- **Preview.** The preview pane re-renders the real PDF 300 ms after the last edit.

## Calendar

The calendar is a **derived view plus two stored tables**.

- **Derived.** `calendarEvents(range, data, clock)` in `lib/domain/calendar/events.dart` is a pure function: invoices, contracts, clients, postponements and reminders in, a sorted list of events out. Nothing it returns is stored; due, overdue, paid, milestone, renewal, contract and warranty events are recomputed from the documents on every change. Dates are civil dates (`CalendarDate`), so time zones and DST never move an event.
- **Stored.** Only what the documents can't express:
  - `postponements`: a history of moved due dates for invoices and milestones. The latest row is the effective due date, and overdue is measured against it everywhere (sidebar, PDF, calendar). The original due date is never overwritten.
  - `reminders`: manual entries, optionally timed and linked to a client or document.
  Both are sync-ready like every other table (UUID, `rev`, `updated_at`, `deleted_at`, outbox triggers).
- **Rules worth knowing.**
  - A milestone shows until a sent or paid invoice covers it; then the invoice's own event takes over.
  - Recurring items of a paid invoice renew monthly/annually from its issue date until a later invoice of the same client bills the same service as a recurring item.
  - The overdue rollup on today counts every overdue invoice, wherever its date is.
- **Actions** in the day panel go through the same controllers and repositories as the editors (autosave, undo, validation); the calendar never writes to the database itself.
- **Export.** `buildIcs` writes RFC 5545 with stable UIDs (`invoice-due-<id>@invoice-desk.local`, …), so a re-import updates events.

```mermaid
flowchart LR
  D[(invoices · contracts · clients)] --> F["calendarEvents(range, data, clock)"]
  P[(postponements)] --> F
  R[(reminders)] --> F
  F --> V[month / week / agenda] --> A[day panel actions] --> Repo[repositories]
  Repo --> D & P & R
```

## Demo data

A fresh install gets an empty profile and the demo set from `seedDemo`: five fictional clients (example.com / example.eg addresses, `0100 000 00xx` numbers), fourteen invoices in every state and both currencies, three contracts and reminders, all dated relative to the injected clock. Every demo row has `is_demo = 1` and numbers in a separate `DEMO-…` series (seq 9001+) that real numbering ignores. A user save through a repository clears the flag (the row is adopted). "حذف البيانات التجريبية" writes a `before-remove-demo-…` backup and hard-deletes only `is_demo` rows and what hangs off them; a demo client still used by an adopted document is kept and becomes real.

## Future: encrypted sync

The desktop app is free and complete. A paid subscription will later add **end-to-end encrypted** sync across devices. This release prepares the seams; there is no network code.

```mermaid
flowchart LR
  subgraph Device
    REPO[Repositories] -- same transaction --> OUT[(outbox table)]
    REPO --> TABLES[(tables: id, rev, updated_at, deleted_at)]
    SYNC[SyncService<br/>today: NoopSyncService] -- reads --> OUT
    ACC[AccountService<br/>today: LocalAccountService → localOnly]
    ENC[client-side encryption<br/>Argon2id + XChaCha20-Poly1305]
  end
  SYNC --> ENC --> API[(future Go API<br/>stores ciphertext + opaque ids)]
```

- `lib/account/`: `AccountService` with a sealed `AccountState` (`localOnly` today; later `signedIn`, `subscribed`, `expired`). It is wired in bootstrap with `LocalAccountService`. **No feature is ever gated on it.**
- `lib/sync/`: `SyncService` (`push`, `pull`, `status` stream) and `NoopSyncService`. Settings shows "المزامنة السحابية: غير مفعّلة — قريبًا".
- **Sync-ready data** (schema v4):
  - Every syncable row has a UUID id, `updated_at` (UTC ms), a `rev` that increments on every write, and a `deleted_at` tombstone.
  - Settings stores a `device_id`.
  - Each change writes an `outbox` row (`entity`, `row_id`, `rev`, `changed_at`) **in the same transaction**, so a sync engine only has to read the outbox.
- **Encryption design**: [ADR 0010](adr/0010-end-to-end-encrypted-sync.md) (proposed).
- **The rule.** The app is offline-first, and sync is an optional add-on. Sync must never block local use, export or backup. Losing the account or the network never affects local data.
