# Brief — Invoice Desk: bilingual app, bilingual documents, document styles, settings, UX

**Branch:** `feat/bilingual-styles` · **Base:** `main` (0.4.0) · **Status:** in progress (phases 0–2 done)

**Task IDs:** Phase 0 = `PDF-01` · 1 = `L10N-01` · 2 = `L10N-02` · 3 = `INV-01` · 4 = `STY-01` · 5 = `STY-02` · 6 = `SET-01` · 7 = `CON-01` · 8 = `UX-01`

You are working on **Invoice Desk**, an offline Flutter desktop app (Linux first) for freelancers who invoice in Arabic and English. The repo is at the project root (current version 0.4.0, schema v5). Read this brief end to end before touching code, then read `CONTRIBUTING.md`, `docs/ARCHITECTURE.md`, `docs/DATA_MODEL.md` and `docs/adr/0005-clause-snapshots.md`.

## 1. What to build

1. **Bilingual UI.** The user chooses Arabic, English or the system language. The whole app follows that choice, including RTL/LTR. Today the UI is Arabic-only.
2. **Bilingual documents.** Each invoice and each contract has a language: Arabic (full RTL), English (LTR) or bilingual. The PDF follows that language.
3. **Document styles.** In the UI these are called «تصميم المستند» / "Document style", and in code `DocumentStyle`.
   - Ship 4 ready-made styles: Classic (today's look), Modern, Minimal and Bold.
   - Ship a Blank style that the user builds up.
   - Users can customize a style, save it under a name, and pick a style per document.
   - Styles apply to invoices **and** contracts.
4. **Settings redesign.** Settings move from one long page to sectioned navigation, with more controls (listed in §5).
5. **UX fixes.** These are listed in §6.

> ⚠️ **Naming collision.** "Templates" already means *contract content templates* (`ClauseTemplates`, «مكتبة البنود»). Never call the new visual feature "template" in code or UI. Use `DocumentStyle` / «تصميم المستند».

## 2. Current state (verified)

| Area | Where | State |
|---|---|---|
| UI strings | `lib/l10n/arb/app_ar.arb` (template), 459 keys, `context.l10n` | Ready to translate. One hard-coded string: `'Invoice Desk'` in `features/settings/settings/about_card.dart` |
| Locale | `lib/app/app.dart` | Hard-coded: `appLocale = Locale('ar')`, `supportedLocales: [appLocale]` |
| Layout direction | features/app/widgets | Uses Directional geometry throughout. Explicit `TextDirection.ltr` on numbers, emails and IBANs is **correct, keep it** |
| Arabic text in pure-Dart layers | `core/dates.dart` (Arabic month names; `formatInvoiceDate` is English-only), `domain/contract_logic.dart` (currency names, ordinal clause headings «الأول…الثلاثون», `toArabicDigits`), `domain/contract_ops.dart` (default milestone labels), `domain/calendar/reminder_message.dart`, `domain/calendar/events.dart` | Must become language-parameterised |
| Invoice PDF | `lib/pdf/invoice_pdf.dart` + `pdf/invoice/*.dart` (`part` files, `_Builder` extensions) | LTR, English labels hard-coded with small Arabic secondaries (`'INVOICE'`, `'Invoice No.'`, `bilingualLabel('BILLED TO','العميل')`). The scope page is Arabic-only |
| Contract PDF | `lib/pdf/contract_pdf.dart` + `pdf/contract/*.dart` | Arabic-only RTL |
| PDF colours | `const _ink, _teal, _muted…` in **both** `invoice_pdf.dart` and `contract_pdf.dart` | Duplicated constants; to be replaced by a style object |
| Invoice content model | `domain/models/invoice.dart` | `InvoiceSection.titleEn/titleAr` and `notesEn/notesAr` are bilingual; `LineItem.service/description` are single fields |
| Clause library | `ClauseTemplates`, `LibraryClauses` tables | Single language (`title`, `body`) |
| Settings | `features/settings/settings_page.dart` | 12 `PanelCard`s in one scroll view (max width 860), autosave debounce 600 ms. Appearance = theme mode only |
| Per-machine prefs | `lib/app/ui_prefs.dart` (JSON beside DB) | Theme, calendar view, week start, window bounds… |
| DB | `lib/data/tables.dart`, `db.dart` | `currentSchemaVersion = 5`; every syncable table uses `SyncRev` (+ `ChildSync` for children) and writes to `outbox` in the same transaction |

### Known bugs to fix along the way

- **B1 — Arabic words glued in PDFs.** In `docs/sample OM-2026-0001.pdf`, spaces vanish after non-joining letters (ر ز و د): «وتطويرالتطبيق», «تظهرفي», «يجوزسداد». The current workaround is `wordSpacing: 2` in `_Builder.theme`. The sample may predate the latest build, so **reproduce it first**.
- **B2 — Calendar arrows are hard-wired for RTL.** In `features/calendar/calendar_header.dart`, "previous" uses `Icons.chevron_right` and "next" uses `chevron_left`, which is wrong in LTR. The title also calls `formatArabicMonthYear` directly.
- **B3 — Empty payment card.** The invoice PDF's "Payment details" card renders almost empty (only "Please quote …") when no payment method is set.
- **B4 — Preview rarely beside the editor.** The live preview sits beside the editor only at ≥1500 px (`sideBySideWidth` in `editor_page.dart`), so on 1366/1440 laptops it is always a tab.
- **B5 — Calendar chips truncate badly.** Chips truncate mixed-direction text from the wrong end (`…DEMO-2026-9003 · م…`).

## 3. Non-negotiable codebase rules (from CONTRIBUTING.md)

- **Layers.** UI → repositories (`lib/data/repositories`, via `lib/data/providers.dart`). The UI never imports DAOs, `db.dart`, `tables.dart` or drift. `lib/core` and `lib/domain` stay **pure Dart, with no Flutter imports**. `test/architecture/layering_test.dart` enforces this.
- **Sizes.** Hand-written files ≤ 500 lines and `build` methods ≤ 80 lines (`tool/check_sizes.dart`). Split into named widget classes, never `_buildX()` methods.
- **Values.**
  - Money is integer minor units.
  - Dates are `CalendarDate`.
  - Time comes from the injected `Clock`, never `DateTime.now()`.
- **Strings.** All UI strings go in ARB files; run `flutter gen-l10n`. `app_ar.arb` stays the template.
- **Schema changes.** Each one needs:
  - a forward-only drift step;
  - `dart run drift_dev make-migrations`, with the committed snapshot;
  - a migration test that writes data at v5 and reads it at v6;
  - a regenerated `docs/DATA_MODEL.md` (`dart run tool/gen_data_model.dart`).
  - Backups from v1–v5 must still restore (`test/data/backup_compat_test.dart`).
- **Sync.** New syncable tables use `SyncRev` and write to `outbox` in the same transaction, like the existing tables.
- **Public API docs.** Public API in core, domain and repositories gets doc comments that explain *why* and give units and edge cases.
- **Commits.** Use Conventional Commits. Fixtures use fake names (e.g. "Acme Studio"); never commit real data.
- **ADRs.** Significant decisions get one (copy `docs/adr/0000-template.md`). You will need at least:
  - ADR-0011 "Document language model";
  - ADR-0012 "Document styles as data + snapshot on send".
- **CHANGELOG.** Update `CHANGELOG.md` under `[Unreleased]`.
- **Gate.** `./scripts/ci_local.sh --no-package` must pass at the end of **every** phase.

## 4. Design decisions (use these defaults)

These are the recommended defaults; the owner has not confirmed them yet. **Implement them as stated, and keep each one easy to change.**

| # | Decision | Default |
|---|---|---|
| D1 | Line items (`service`, `description`) | Stay **one field**, written in the document's language. No `serviceAr` |
| D2 | Bilingual contracts (two parallel columns) | **Out of scope.** Contracts support `ar` and `en` only |
| D3 | Style changes after sending | **Snapshot.** Drafts reference a style by id. When an invoice becomes sent/paid, or a contract becomes signed, copy the resolved style JSON into the document, the same idea as ADR-0005 |
| D4 | Fonts | Bundle only. Keep IBM Plex Sans Arabic and add **Noto Naskh Arabic** (OFL). No runtime font downloads (no `google_fonts`) |
| D5 | Logo | PNG/JPG, ≤ 1 MB, stored in the DB. SVG later |
| D6 | Digits in Arabic documents | Setting; default **Western (123)**. The existing `contractWesternDigits` setting migrates into it |
| D7 | Document language resolution | Document → client default → global default (`ar`) |
| D8 | UI language persistence | `UiPrefs` (per machine), values `system` / `ar` / `en`, default `system` falling back to `ar` |

**Owner rulings (dated, newest last):**

| Date | Ruling |
|---|---|
| 2026-11-16 | Phase 0: vendor `pdf` 3.13.1 + RTL patch (ADR-0013); word spacing back to default for all documents |
| 2026-11-16 | Keep each clause heading with its first paragraph (fixed in Phase 0 follow-up, not Phase 7) |
| 2026-11-16 | Arabic invoice labels reworded (لعناية، يُرجى ذكر رقم الفاتورة عند الدفع، المجموع الفرعي، التكرار، غير مطبَّقة، محفظة إلكترونية، حساب بنكي (IBAN)، currency name in «المبالغ بـ…») |
| 2026-11-16 | D8 amended: system language that is neither Arabic nor English falls back to **English** |
| 2026-11-16 | Speed rules: full gate once per phase; timebox overflow polish to 30 min, leftovers go to Phase 8 |
| 2026-11-17 | Phase 4 approved. Letter spacing applies to Latin runs only; every Arabic run uses 0 (fix before Phase 5, own commit) |
| 2026-11-17 | Phase 7: in English contracts, Arabic values that contain numbers («سجل تجاري رقم 123456 القاهرة») must not wrap with the number alone on a line |
| 2026-11-17 | Upstream `pdf` issue/PR: keep the text in ADR-0013 current with the patch; do not file it (owner decides) |
| 2026-11-17 | STY-02 approved. Committed documents without a snapshot resolve to Classic and count as locked. Default styles live in Settings ahead of Phase 6 |
| 2026-11-17 | Modern preset: darken its secondary text so every text/background pair passes 4.5:1; no pinned exception |
| 2026-11-17 | Bold's Arabic name is «بارز». Deleting a style that drafts or clients use says how many in the confirm/undo message |
| 2026-11-17 | Phase 8: add a colour palette/picker next to the hex fields in the style inspector |

## 5. Phased plan

Work phase by phase. At the end of each phase:

- the gate passes;
- commit on a feature branch (`feat/bilingual-styles`);
- add a short note to the CHANGELOG;
- **stop and report** before starting the next phase if anything in "Stop and ask" (§7) applies.

### Phase 0 — Arabic PDF spike (B1)

- Write a test PDF with the problem phrases (both fonts, sizes 8–26) and inspect it.
- Find the cause: the `pdf` package's shaping of spaces after non-joining letters, font metrics, or `wordSpacing`.
- Fix it, or pick the font/approach that renders correctly.
- **Done when:** a committed sample PDF in `docs/` shows correct Arabic spacing, and a golden locks it.
- **If no fix exists within the `pdf` package, stop and report the options.**

### Phase 1 — Foundations (no visible change)

1. Add a pure-Dart `DocLanguage { ar, en, bilingual }` in `lib/domain`.
2. Make the domain strings language-aware.
   - Replace the Arabic literals in the files listed in §2 with functions that take a language, or with enums the UI maps to l10n.
   - Dates: `formatDocDate(CalendarDate, DocLanguage, {DigitStyle})` and its siblings.
   - Ordinals: `clauseHeading(n, lang)`.
   - Currency names: a per-language table.
3. Add `DocLabels` in `lib/pdf/labels.dart`.
   - It is a pure-Dart `ar`/`en` table of every PDF label (INVOICE, Invoice No., Billed to, Subtotal, Total due, Annex…).
   - It is **not** ARB, because the document language is independent of the UI language.
4. Add `PdfStyle`, the resolved style the PDF builders read.
   - It holds colours, fonts, sizes, margins, block toggles and block order.
   - Replace every `const _ink…` in both PDF builders with `style.*`.
   - The Classic style must reproduce today's output **pixel-for-pixel**.
5. Add a `localeProvider` backed by `UiPrefs`, and set `MaterialApp.supportedLocales: [ar, en]`. English strings may still be missing at this point.
- **Done when:** all existing goldens and PDF tests pass **unchanged**.

### Phase 2 — English UI

- Add `app_en.arb` with all 459 keys translated: concise, natural product English, not literal. Keep placeholders and ICU plurals identical.
- Add an ARB parity test: same keys, same placeholders.
- Fix B2. Replace remaining direction-specific icons with `Icons.adaptive` or direction-aware equivalents.
- Fix the hard-coded `'Invoice Desk'` and the calendar shortcut hint line.
- Put a language selector in Settings → General.
- Goldens: add LTR variants for the main screens (sidebar + editor, contract editor, calendar month, settings), plus an overflow test at the largest text scale in English.
- Update the README sentence "The interface is right-to-left throughout, in Arabic".

### Phase 3 — Document language: invoices

- **Schema v6, part A:**
  - `invoices.language` (`ar|en|bilingual`; existing rows get `bilingual` to preserve today's look);
  - `clients.preferred_language` (nullable);
  - `app_settings.default_doc_language` and `app_settings.doc_digit_style`.
  - Migrate `contractWesternDigits` into `doc_digit_style`.
- **Invoice PDF:**
  - `ar` → a full RTL page with mirrored layout, Arabic labels, Arabic dates and the configured digits.
  - `en` → today's layout without the Arabic secondaries.
  - `bilingual` → today's layout.
  - The scope page follows the language.
- Wrap numbers, emails, IBANs and invoice numbers inside Arabic runs with bidi isolation (FSI/PDI or explicit `textDirection`).
- **Editor:**
  - add a language picker in the Details card;
  - hide the irrelevant `titleEn/titleAr` and `notesEn/notesAr` fields when the language is single;
  - new invoices inherit the language per D7.
- Fix B3: hide the payment card when it is empty, and show an editor warning «أضف وسيلة دفع في الإعدادات».
- PDF goldens: 3 languages × paid/unpaid × with/without the scope page.

### Phase 4 — Document style engine

- **Schema v6, part B** (same migration as part A if not yet shipped):
  - Table `document_styles` (`SyncRev`, `isDemo`), with columns:
    - `id`
    - `name`
    - `kind` (`invoice|contract|any`)
    - `base_preset` (`classic|modern|minimal|bold|blank`)
    - `json` (TEXT)
    - `schema_version` (int)
    - `archived`
    - timestamps
  - `invoices.style_id`, `contracts.style_id` and `clients.style_id` (all nullable).
  - `invoices.style_snapshot` and `contracts.style_snapshot` (nullable TEXT; see D3).
  - `app_settings.default_invoice_style_id` and `app_settings.default_contract_style_id`.
- **`DocumentStyle` value object** in `lib/domain`: immutable, with `toJson`/`fromJson` that ignore unknown fields and clamp out-of-range values. Fields:
  - **Colours:** primary, accent, ink, muted, surface, tableHeaderBg, border.
  - **Typography:** fontFamily (bundled only), baseSize, scale.
  - **Page:** paper (A4/Letter) and margins.
  - **Header:** style `band|rule|none`.
  - **Logo:** bytes ref, size, position `start|end|center`.
  - **Table:** style `striped|bordered|plain`.
  - **Totals:** style `solid|outlined`.
  - **Visibility toggles:** role, city, contacts, payment card, notes, VAT row, "please quote", page numbers, signature boxes, paid stamp.
  - **Block order** for: header, parties, items, totals, notes, footer.
  - **Footer text:** ar/en.
- **Presets:** const `DocumentStyle`s with stable ids, read-only. "Duplicate to customize" creates a user row.
  - **Classic** = today's look.
  - **Modern**, **Minimal** and **Bold** must be clearly distinct, not recolours.
  - **Blank** = only the essential blocks (header with name/number, items, totals).
- **Resolution:** document snapshot → document `style_id` → client `style_id` → settings default → Classic.
- **Snapshot:** take it in the repository's single write path when the status changes to sent/paid (invoice) or signed (contract), in the **same transaction**. Duplicate, renewal and amendment start from the reference, not the snapshot.
- **Builders:** refactor each PDF block into its own builder that reads `PdfStyle`, and compose them in `blockOrder`.
- **Backups and restore:** cover the new table. Old backups restore with no styles (everything falls back to Classic).
- **Tests:**
  - JSON round-trip and fuzz (random/invalid JSON never throws);
  - resolution order;
  - snapshot immutability (editing the style after "paid" leaves the PDF bytes unchanged);
  - goldens: each preset × 3 languages for the invoice, and each preset × ar/en for the contract.

### Phase 5 — Style editor UI

- Add a new page «تصميم المستندات», reachable from Settings and from a style picker in both document editors. It has:
  - on the start side, a list of presets and user styles;
  - in the middle, a live PDF preview, using the current document if one is open, otherwise demo data;
  - on the end side, an inspector grouped as: Colours · Font · Header & logo · Table · Totals · Visible blocks (toggles + reorderable list) · Footer.
- Actions: Duplicate, Rename, Reset to preset, Delete (soft, like other entities), and Export/Import `.json` through `file_selector`.
- Warn on low colour contrast (text vs background < 4.5:1).
- In each document editor, the style picker shows thumbnails. When a document's look is locked by a snapshot, show «التصميم مثبّت لأن الفاتورة أُرسلت».
- The preview reuses the existing debounced `PreviewPane` mechanism.
- Add a flow test: create from Blank, enable blocks, assign to an invoice, export the PDF.

### Phase 6 — Settings redesign

- Navigation rail/list on the start side with search. Sections:
  - General
  - Profile
  - Invoices
  - Contracts
  - Payment
  - Document styles
  - Calendar
  - Data & backups
  - Sync
  - About
- Keep the existing autosave behaviour.
- New controls:

| Control | Storage |
|---|---|
| UI language, theme, density (comfortable/compact), accent colour | `UiPrefs` |
| Default document language, digit style, date format (`14 Sep 2026` / `14/09/2026`) | DB settings |
| Default currency + display (`EGP` / `ج.م` / symbol) | DB settings |
| Default VAT on/off + rate, tax registration number (printed when set) | DB settings |
| Numbering pattern with tokens `{PREFIX}-{YYYY}-{SEQ:4}`, yearly reset, "next number" preview | DB settings; must not break existing numbers or uniqueness |
| Default invoice style and default contract style | DB settings |
| PDF file-name pattern, export folder, open after export | `UiPrefs` |
| Start-up view (last document / calendar) | `UiPrefs` |
| Keyboard shortcuts reference (read-only) | — |

- Add any extra DB columns in the same v6 migration if it has not shipped yet; otherwise in v7, following the full migration ritual.

### Phase 7 — Contracts in English + styles

- Add `ClauseTemplates.language` (`ar|en`; existing rows get `ar`). A contract takes its language from its template.
- Seed English versions of the two seeded templates (contract + quote) in `lib/data/library_seed.dart`. **Mark them in the UI as "draft wording — have it reviewed by a lawyer".**
- **Contract PDF:**
  - honours the language: LTR for `en`, English headings («Article 1» style via `clauseHeading`), English annex tables and signature labels;
  - honours `PdfStyle` via the same block builders where applicable (cover, parties, body, annexes, signatures, footer).
- Contract `{{variables}}` keep working in both languages.

### Phase 8 — UX polish

- **B4:** replace the 1500 px threshold with a draggable split pane (min editor 560 px, min preview 380 px). Remember the ratio in `UiPrefs`. Side by side from ~1200 px.
- **B5:** in calendar chips, put the number first inside a bidi isolate and use end-truncation.
- **Colour picker (owner, 2026-11-17):** in the style inspector, a real colour picker next to each hex field. Today there is only a small swatch that opens a fixed 12-colour palette.
- **Banners:** merge the two stacked ones («أكمل بياناتك», «اليوم: …») into one notification strip with an item count.
- **First-run onboarding.** Steps:
  1. language;
  2. name + logo;
  3. pick a style (thumbnails);
  4. payment details;
  5. preview of a sample invoice.
- Run the full design review in both directions, light and dark, at the largest text scale. Fix what blocks release.

## 6. Definition of done (whole project)

- `./scripts/ci_local.sh` passes, including goldens, the size check and the layering test.
- The app switches language live with no restart; every screen is usable in both directions.
- An invoice and a contract each export correctly in every supported language and every preset. The sample PDFs in `docs/` are regenerated: one Arabic invoice, one English invoice, one bilingual invoice, and one English contract.
- Old databases (v1–v5) and old backups open and restore; existing invoices look exactly as before (bilingual + Classic).
- The paths below are documented:
  - `CHANGELOG.md` (`[Unreleased]`, Keep a Changelog style);
  - the README feature list;
  - `docs/ARCHITECTURE.md`;
  - `docs/DATA_MODEL.md`;
  - ADR-0011 and ADR-0012.
- No new runtime network access and no new heavy dependencies. Justify any new package in the ADR.

## 7. Stop and ask (do not guess)

- Phase 0 cannot fix Arabic spacing within the current PDF stack.
- Any change would alter the look of **existing** invoices or contracts.
- A migration would have to rewrite or drop existing user data beyond adding columns or tables with defaults.
- English legal wording for contract clauses goes beyond a faithful translation of the Arabic seed.
- You want to deviate from D1–D8.

## 8. Report format (end of each phase)

- **What changed:** 3–6 bullets.
- **Files touched:** grouped by layer.
- **Gate result:** pass, or the failing step.
- **Screenshots or PDF samples:** paths.
- **Open questions:** if any.
