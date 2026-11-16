# Changelog

All notable changes to Invoice Desk. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow [Semantic Versioning](https://semver.org/).

## [0.4.0] - 2026-11-16

### Added
- **Calendar ("التقويم").** A top-level switch beside invoices & contracts (Ctrl+Shift+C), remembered across launches.
  - Month view (6×7, week starting Saturday, Sunday or Monday), week view and an agenda list; up to three chips per day with "+N" and the day's total per currency.
  - Events are derived from your data, never copied: due, overdue (plus a rollup on today), paid, postponed, contract payment milestones, renewals of paid monthly/annual items, contract start/end, warranty ends and manual reminders.
  - Month header: expected, collected and overdue per currency; click one to filter. Filters by client, event type and currency, plus the sidebar's search box.
  - Day panel: open, mark paid on that day (with Undo), postpone with a reason, copy a short Arabic/English payment reminder, create the milestone or renewal invoice, and add/edit/complete/delete reminders. Drag a chip to another day to postpone it (Esc cancels).
  - Keyboard: arrows, PageUp/PageDown, T, M/W/A, Enter, Esc.
  - "في التقويم" in the invoice and contract editors opens the calendar on that event.
  - Export to `.ics` (visible range or every future event) with stable UIDs, so re-importing updates instead of duplicating.
- **Postponements.** A kept history of moved due dates. Overdue status, the sidebar and the invoice PDF use the effective (latest) due date; the editor shows "مؤجَّلة من … إلى … — السبب".
- **"Today" banner** ("اليوم: 2 مستحق · 1 متأخر — عرض في التقويم"), dismissable for the day, and an optional desktop notification at start-up (Settings → التقويم; uses `notify-send` when installed).
- **Demo data.** Fresh installs start with a fictional demo set dated around today, an empty profile and a "أكمل بياناتك" banner. Settings → البيانات التجريبية adds it again or removes it (after a `before-remove-demo-…` backup); editing a demo row makes it yours.
- **Schema v5:** `is_demo` flags, `postponements` and `reminders` tables (sync-ready) and date indexes. Backups from v1–v4 still restore.

### Changed
- The old single-invoice seed (a real client and phone number) is gone; tests use a scrubbed fixture.
- Renewal invoices and "mark as paid" can be dated (the calendar passes the selected day).

## [0.3.0] - 2026-11-15

### Added
- **"المحذوفات" (trash).** Lists deleted clients, invoices and contracts with the deletion date and the days left before they are purged.
  - "استعادة" respects the database guards: restoring a document whose client is deleted offers to restore the client too, and a client comes back with the batch it was deleted with.
  - "حذف نهائي" (type the name or number) and "إفراغ المحذوفات" (type "إفراغ") write a `before-purge-…` backup first.
- **Undo snackbars** now say the item can also be restored from "المحذوفات".
- **Settings → "المزامنة السحابية"** card ("غير مفعّلة — قريبًا"). It does nothing yet.
- **Sync-ready data (schema v4):**
  - a device id in settings;
  - a `rev` on every syncable row, incremented on each write;
  - an `outbox` table written in the same transaction as each change.
  - No network code.
- **Documentation:**
  - README rewrite, architecture, data model (generated from the schema snapshot), ADRs 0001–0010;
  - releasing and testing guides, contributing, security policy, this changelog.
- **CI:**
  - quality, codegen and schema guards, tests with per-layer coverage, goldens, security scans, Linux build and package with a smoke run, Windows and macOS builds;
  - Dependabot, actions pinned to commit SHAs;
  - `scripts/ci_local.sh` runs the same gates locally.

### Changed
- **Repositories.** The UI reads and writes through repositories with typed results. It no longer touches the database or drift directly; a layering test enforces this.
- **Pure domain.** `lib/core` and `lib/domain` no longer depend on Flutter.
- **One clock.** A single injected clock dates everything the app writes.
- **Code size.** Large widgets and both PDF builders are split into smaller named pieces: every file is 500 lines or fewer, and every `build` 80 lines or fewer. The visuals are unchanged.

## [0.2.0] - 2026-11-15

### Added
- **Contracts and quotes** from a clause library (Settings → مكتبة البنود), with two seeded templates. Clauses are copied into each contract, so library edits never change existing contracts.
- **Variables.** `{{variables}}` are filled from the profile, the client and the contract. Missing ones are highlighted and block sending or signing.
- **Annexes.** Annex 1 is the scope of work. Annex 2 is payments, by percentage or fixed amount, always summing exactly to the total.
- **Milestone invoices.** A payment milestone becomes a draft invoice with one click, linked back to the contract.
- **Locking and amendments.** Signed contracts are read-only. Changes go through an amendment (`CT-2026-0003-A1`) or a confirmed, logged unlock.
- **Contract PDF:**
  - cover with both parties, preamble, clauses numbered "البند الأول …" with sub-items;
  - annexes with repeating table headers, signatures, and initials on every page;
  - a "مسودة" watermark on drafts.
- **Sidebar.** Contracts and invoices grouped per client, contract search, an "عقود سارية" filter, and "عقد جديد" (Ctrl+Shift+K).
- **Legal details.** Legal fields for clients and the provider; contract and quote prefixes.
- **Schema v3**, migrated automatically. v1 and v2 backups still restore.

### Fixed
- Contract and library changes now refresh the screen immediately.
- Arabic words no longer run together in exported PDFs (invoices too).

## [0.1.1] - 2026-11-15

### Added
- **Client deletion:**
  - a client without invoices is soft-deleted with Undo;
  - a client with invoices offers archive (the default) or, after typing their name and a backup, deletion of everything with Undo.
- **Archive filter.** The "مؤرشف" filter and "إلغاء الأرشفة".
- **Schema v2** guards: no live invoice under a deleted client. Hard deletes are blocked by `ON DELETE RESTRICT`.

### Changed
- **Filter chips** wrap instead of scrolling.

## [0.1.0] - 2026-11-15

### Added
- **The app.** An Arabic RTL desktop app with bilingual A4 invoice PDFs.
- **Invoices.** Multi-currency sections, one-time/monthly/annual lines, VAT, and an optional scope page.
- **Editing.** Live PDF preview, autosave, duplicate, renewal, mark as paid, CSV export.
- **Search and sidebar.** Search across clients, phones, numbers and contract references. The summary shows unpaid totals and overdue counts.
- **Backups.** Daily `VACUUM INTO` backups (last 30 kept), plus manual backup and restore. `INVOICE_DESK_DATA_DIR` overrides the data folder.
- **Linux packages.** Tarball with install/uninstall scripts, AppImage, and an RPM in `/opt/invoice-desk`, all with RUNPATHs rewritten to `$ORIGIN`.

[0.4.0]: https://github.com/omarmaarouf18/invoice-desk/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/omarmaarouf18/invoice-desk/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/omarmaarouf18/invoice-desk/compare/v0.1.0...v0.2.0
[0.1.1]: https://github.com/omarmaarouf18/invoice-desk/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/omarmaarouf18/invoice-desk/releases/tag/v0.1.0
