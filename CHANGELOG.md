# Changelog

All notable changes to Invoice Desk. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Changed
- **Invoice Desk is free software under the GNU GPL v3 or later** (`LICENSE`, ADR-0015). The Linux packages declare it and ship the licence text.

## [0.5.0] - 2026-11-19

### Added
- **Windows and macOS downloads, and more Linux packages.** Every release now ships a Windows installer (`InvoiceDesk-Setup-x64.exe`, per-user, no admin) and portable zip, a universal macOS dmg, a Debian/Ubuntu `.deb`, an Arch package, plus the RPM, AppImage and tarball. File names no longer carry the version, so `releases/latest/download/<name>` always works; `latest.json` describes each release. Releases are published automatically from a tag, with checksums and build-provenance attestations (docs/RELEASING.md).
- **Settings, redesigned.** Settings is now ten sections in a list with search (it also finds control names, e.g. "IBAN" finds Payment), and remembers the last section. Other screens open the right section.
  - **Invoices:** a numbering pattern (`{PREFIX}-{YYYY}-{SEQ:4}` by default) with yearly reset and a "next number" preview; VAT on/off and rate for new invoices; tax registration number (printed with your details when set); date format (`14 Sep 2026` or `14/09/2026`); default currency; currency display (code, Arabic symbols in Arabic documents, or symbol).
  - **This computer:** density, accent colour and start-up view; PDF file-name pattern, export folder and "open after export"; a keyboard shortcuts reference.
  - **Clients** can have a preferred document style.
- **Sent, paid and signed documents keep what they printed** (ADR-0014). Your details, payment methods, the client's details and the document formats are frozen when a document is committed, so a new IBAN or address never changes an invoice that was already sent. Drafts follow every change; documents committed before this version keep following Settings, as before.
- **Document style editor «تصميم المستندات».** A new page, opened from Settings or from the style picker in either document editor:
  - the ready-made styles and your own, each with a small thumbnail; Duplicate, Rename, Reset to preset, Delete (to the trash, with Undo), and Export/Import as a `.json` file that carries the logo with it;
  - a live PDF preview on the open invoice or contract, or on a fictional sample, in any document language;
  - an inspector for colours (with a warning when text falls below 4.5:1 contrast), font and page, header and logo (PNG/JPG up to 1 MB), table, totals, which blocks print and in what order (drag to reorder), and footer text. Changes save themselves.
  - Deleting a style that drafts or clients use says how many first; they fall back to the client's style, then the default, then Classic.
  - Each invoice and contract now has a "Document style" picker. Once a document is sent, paid or signed its look is fixed and the picker says so. Settings has the default invoice and contract styles.
- **Document style engine (ADR-0012).** Complete styling engine for invoices and contracts with 6 built-in presets (`Classic`, `Modern`, `Minimal`, `Bold`, `Formal`, `Blank`).
  - `DocumentStyle` immutable value object supporting primary/accent colors, custom margins, typography selection, header bands, table layout styles (plain, striped, bordered), solid totals bars, and modular block visibility.
  - Dedicated `document_assets` table (schema v7) for content-addressed, deduplicated image storage (logos ≤ 1 MB with PNG/JPEG validation).
  - Style resolution hierarchy: snapshot → document style → client preferred style → settings default → Classic.
  - Automatic style snapshots: sent and paid invoices, and signed contracts, freeze their resolved style and logo in the exact same transaction, guaranteeing that historical documents never change appearance.
  - Bundled Noto Naskh Arabic font with automatic IBM Plex Sans Arabic Latin fallback.
  - 100% byte-identical Classic preservation backed by PDF goldens.
- **Invoice document language (Arabic, English, Bilingual).** Invoices can now be rendered in single-language Arabic (full RTL layout, mirrored tables, Arabic labels and dates, configurable digits), single-language English, or bilingual (Arabic / English, byte-identical to previous releases).
  - Scope/handover page follows the chosen document language.
  - Document language selector in the invoice editor Details card, hiding irrelevant language fields for notes and section titles when a single language is chosen.
  - Client preferred document language: each client can declare a preferred document language, automatically adopted by new invoices and milestones (D7).
  - Global default document language and Arabic digit style (Western 123 vs Arabic-Indic ١٢٣) in Settings → Invoicing.
  - Empty payment details card is hidden from invoice PDFs (B3), and an editor warning banner prompts the user to configure payment methods in Settings.
- **English interface.** The whole app can be read in English. Settings → General picks Arabic, English or the system language, and the choice takes effect at once — text, reading direction (right-to-left in Arabic, left-to-right in English), dates and icons. It is remembered per machine.
  - A full English translation (`lib/l10n/arb/app_en.arb`), checked against the Arabic one by a parity test: a missing key, a changed placeholder or a missing plural branch fails the build.
  - The English screens are locked by their own goldens (sidebar and invoice editor, contract editor, calendar month view, settings), and every screen is checked at the largest text scale so no row overflows.
  - The interface language is independent of the language of a document: an Arabic invoice can be edited in an English app (ADR-0011).

### Fixed
- **No package ships a library that cannot load.** The Linux and Windows builds no longer include `dartjni` (pulled in by an Android-only dependency), which needed a Java runtime that a desktop doesn't have; every package build now fails if a bundled file needs one.
- **Linux packages declare EGL/GLES.** On a minimal Ubuntu 22.04 the app aborted at launch because `libGLESv2` was missing; the deb, RPM and Arch packages now depend on it.
- **Windows and macOS show the Invoice Desk icon** instead of Flutter's default, and the macOS app is named "Invoice Desk".
- **Previews and exported PDFs now use the document's style.** Until now every document printed in Classic whatever style it was given.
- **Documents sent before styles existed keep their look.** An invoice sent or paid, or a contract signed, before this version (or restored from an older backup) stays Classic, whatever default style is chosen later.
- **The Arabic title «فاتورة» is no longer spaced out.** Letter spacing pulled the joined Arabic letters apart in the title, the table headers and the paid stamp of Arabic invoices; it now applies to English text only.
- **Deleted document styles are purged after 30 days, and unused logos after a day**, like the rest of the trash.
- **A text field is now read in the direction of its text.** An Arabic line in an English screen — a description, a client name, a jurisdiction — used to be cut at its first word, because the paragraph was laid out from the left. Every free-text field now takes its direction from its first strong character and follows the interface only while it is empty; numbers, codes, dates and e-mail addresses keep their own direction. The field is also scrolled to the start of its text, so a long line written in the other direction is shown from its beginning.
- **"1 invoices" in the English interface.** Every count is now written with its plural form: the sidebar says "1 invoice · 1 unpaid" instead of "1 invoices · 1 unpaid". The Arabic counts got the same treatment («فاتورة واحدة» instead of «1 فاتورة»), and a test fails the build when a count is written as a bare number.
- **The calendar's month arrows point the wrong way.** "Previous" and "next" now follow the reading direction, so they are the right way round in Arabic and in English.
- **A row of the interface can overflow with large text.** The billing-cycle and currency drop-downs, the sidebar rows, the card headers and the calendar toolbar now give way instead of spilling out of the screen at the largest text scale.
- **Arabic words no longer run together in PDFs** (for example «وتطويرالتطبيق», «يجوزسداد»). The `pdf` package placed right-to-left words by their ink width, so words ending in ر or ز ate the following space. It is now vendored with a one-line fix (`third_party/pdf`, ADR-0013). Word spacing is back to the font's normal width, so English text in PDFs is no longer double-spaced either. Only re-exported documents change.
- **A contract page no longer ends with a clause heading.** A heading is now kept with its first paragraph (or first sub-item); a long first block is left splittable so it still fits on a page. The page count of the sample contract is unchanged.

### Changed
- **A system language the app does not have now falls back to English**, not to Arabic. A French or German machine opens Invoice Desk in English; Arabic is still followed when the machine asks for it, and an explicit choice the app cannot show still falls back to Arabic (ADR-0011).
- The Arabic invoice labels are reworded: «لعناية: …», «يُرجى ذكر رقم الفاتورة عند الدفع: …», «المبالغ بالجنيه المصري», «التكرار», «المجموع الفرعي», «غير مطبَّقة», «محفظة إلكترونية» and «حساب بنكي (IBAN)». They are printed on Arabic documents, which arrive with the bilingual documents; the contract labels are unchanged.
- The calendar's keyboard hint is translated, so it reads correctly in English; the app name stays «Invoice Desk» in every language.
- Dates in the interface follow the interface language ("14 Nov 2026" in English), while the documents keep their own language.
- The sample PDFs in `docs/` use fictional data (Sample Studio → Acme Studio).
- Groundwork for bilingual documents and document styles. The documents still look the same (ADR-0011):
  - a document language model (`ar` / `en` / `bilingual`) and a digit style;
  - language-aware dates, clause headings, currency names, default milestones and payment reminders;
  - one table of PDF labels in Arabic and English;
  - the PDF palette and page geometry in one `PdfStyle` (Classic reproduces 0.4 exactly);
  - a per-machine UI-language preference, wired into the app's locale.

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

[Unreleased]: https://github.com/omarmaarouf18/invoice-desk/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/omarmaarouf18/invoice-desk/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/omarmaarouf18/invoice-desk/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/omarmaarouf18/invoice-desk/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/omarmaarouf18/invoice-desk/compare/v0.1.0...v0.2.0
[0.1.1]: https://github.com/omarmaarouf18/invoice-desk/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/omarmaarouf18/invoice-desk/releases/tag/v0.1.0
