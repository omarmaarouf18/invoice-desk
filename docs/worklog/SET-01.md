# SET-01 — Settings redesign

**Brief:** docs/briefs/2026-11-16-bilingual-styles.md, Phase 6 · **Branch:** feat/bilingual-styles

## Findings before planning (2026-11-17)

- Settings is one scroll of 13 `PanelCard`s (`settings_page.dart`, max width 860) with one `_draft` and a 600 ms autosave. The redesign keeps that single draft and autosave; only the layout changes.
- **Rule 8 gap (stop-and-ask, Q1).** Three of the brief's new DB settings print on documents: the date format, the currency display and the tax registration number. A sent invoice re-renders from live settings, so changing any of them later would change how an invoice that was already sent looks when it is exported again. The style snapshot (ADR-0012) does not cover them. The commits that print them wait for the answer.
- Numbers are unique per `number` and per (year, seq). `nextSeq` takes the max seq **of the year**. `parseInvoiceNumber` assumes `…-YYYY-N`; the editor parses the number it has just formatted, so a pattern changes that call site too.

## Screen layout

```
┌ Settings ─────────────────────────────────────── saved ✓ ┐
│ START (240)            │ CONTENT (max 860, scrolls)        │
│ [🔍 search settings ]  │ Section title                     │
│ ▸ General              │  card                             │
│ ▸ Profile              │  card                             │
│ ▸ Invoices             │  …                                │
│ ▸ Contracts            │                                   │
│ ▸ Payment              │                                   │
│ ▸ Document styles      │                                   │
│ ▸ Calendar             │                                   │
│ ▸ Data & backups       │                                   │
│ ▸ Sync                 │                                   │
│ ▸ About                │                                   │
└────────────────────────┴───────────────────────────────────┘
```

- A `NavigationDrawer`-style list on the start side, Directional. The selected section is remembered per machine (`UiPrefs.settingsSection`).
- **Search:** each section declares its keywords: its title and the labels of its controls, in the UI language, from ARB. Typing filters the list to matching sections, Enter opens the first one, and the matching words are highlighted (`HighlightText`). An empty result shows a "no settings match" line.
- Other screens that open Settings ("Open settings" in the payment warning, the variables card, banners) open the right section: `openSettings(SettingsSection)`.

## Sections and controls

| Section | Existing cards | New controls (storage) |
|---|---|---|
| General | UI language, Appearance (theme) | Density comfortable/compact, accent colour (6 seeds), start-up view last document/calendar (`UiPrefs`) |
| Profile | Profile | — |
| Invoices | Invoicing (prefix, due days, document language, digits), default notes | Numbering pattern `{PREFIX}-{YYYY}-{SEQ:4}` with a yearly-reset toggle and a "next number" preview; default VAT on/off + rate; tax registration number; date format `14 Sep 2026` / `14/09/2026`; default currency + display `EGP` / `ج.م` / symbol (DB, v8) |
| Contracts | Contracts (+ "Open library") | — |
| Payment | Payment | — |
| Document styles | Document styles (STY-02) | — |
| Calendar | Calendar | — |
| Data & backups | Backup, Demo data | PDF file-name pattern, export folder, open after export (`UiPrefs`) |
| Sync | Sync | — |
| About | About | Keyboard shortcuts reference (read-only, from one shortcut table the shell also uses) |

## Schema v8 (all on `settings`, defaults keep today's behaviour)

`invoice_number_pattern` TEXT `'{PREFIX}-{YYYY}-{SEQ:4}'` · `number_yearly_reset` BOOL `true` · `default_vat_on` BOOL `false` · `default_vat_rate_bp` INT `1400` · `tax_registration_no` TEXT `''` · `date_format` TEXT `'long'` · `default_currency` TEXT `'EGP'` · `currency_display` TEXT `'code'`. Q1 added one nullable `issue_snapshot` TEXT column to `invoices` and `contracts`.

The full ritual applies: a drift step, `make-migrations` with the snapshot, a v7→v8 migration test, a regenerated DATA_MODEL.md, and backups from v1–v7 must still restore.

**Numbering rules:** the pattern must contain `{SEQ` (with optional `:n`). With yearly reset it must also contain `{YYYY}` or `{YY}`; otherwise two years would produce the same number. Without yearly reset, the next seq is the max over **all** years. Existing numbers are never rewritten. The DB's `UNIQUE(number)` remains the last guard, and the editor's duplicate-number check already handles it.

## Commit order

1. `feat(SET-01)`: sectioned navigation with search; the existing cards move into their sections unchanged; the section is remembered; `openSettings(section)`. Goldens re-baselined separately.
2. `feat(SET-01)`: per-machine controls: density, accent colour, start-up view, PDF file-name pattern, export folder, open after export; keyboard shortcuts reference.
3. `feat(SET-01)`: schema v8 and migration (+ tests, DATA_MODEL, backup compatibility). **Waits for Q1** (the snapshot column).
4. `feat(SET-01)`: numbering pattern and yearly reset with the next-number preview.
5. `feat(SET-01)`: default VAT and default currency for new invoices.
6. `feat(SET-01)`: date format, currency display and tax number on documents. **Waits for Q1/Q2.**
7. `test(SET-01)`: goldens (settings sections ar/en), and the flow test: search → section → change → autosave.
8. `docs(SET-01)`: CHANGELOG, ARCHITECTURE, AI_CONTEXT, this worklog.

## Progress

- 2026-11-17 — Commit 1 done: `689145f` navigation + search, `489def5` header/label/My details fixes, `e1542cf` golden. Stopped before commit 2 to get Q1–Q3 answered, since schema v8 (commit 3) depends on Q1.

## Commits as built (2026-11-18)

`689145f` navigation · `489def5` header fixes · `e1542cf` golden · `6e6ebf0` date/currency formats · `3022ebd` schema v8 · `5b508df` issue snapshots + ADR-0014 · `6003f4a` settings table split · `79e7ab5` numbering/VAT/currency/formats UI · `5ad2449` client style · `a99273f` per-machine settings + shortcuts · `8d4b15b` goldens.

## Findings (build)

- 2026-11-18 — A stale editor copy (taken before the save that froze the document) used to write `style_snapshot = NULL` back, and the next save re-froze the **live** style. `DocumentSnapshots` now keeps stored snapshots, for both kinds.
- 2026-11-18 — `currency display = code` (today) already prints USD and EUR with their symbol (`$255.50`). Under the owner's definitions, `code` and `symbol` therefore print the same thing for every currency we support. Both are kept as specified; see open question 4.
- 2026-11-18 — Moving a table into its own file needs it imported by `sync_triggers.drift`, or drift_dev's `make-migrations` crashes with a null check.
- 2026-11-18 — The backup compatibility test stopped at v5; it now restores v6 and v7 backups too.

## Open questions

1. **Document-format settings vs rule 8.** Date format, currency display and tax registration number print on documents but live in settings, so changing one would re-render already-sent invoices differently. Recommended: freeze them at the same moment as the style. Add one nullable `format_snapshot` TEXT (JSON: date format, currency display, tax number, digit style) on `invoices` and `contracts`, written in the same transaction as `style_snapshot`. Committed documents without one render as today (long date, currency code, no tax number). The alternative is to accept that these three follow live settings, like the profile and payment details do today. — answered 2026-11-18: freeze, widened to provider + payment + client block + formats, one versioned `issue_snapshot` (ADR-0014). Built.
2. **Currency display options.** Recommended meaning: `code` = `22,000 EGP` (today); `local` = `22,000 ج.م` in Arabic documents and the code in English ones; `symbol` = `$255.50` where a symbol exists, else the code. — answered 2026-11-18 (bilingual uses the English rule). Built.
3. Digit style (D6) is already a DB setting that prints on documents and has the same rule-8 exposure. — answered 2026-11-18: in the same snapshot. Built.

4. **`code` vs `symbol` currency display.** As defined, both print `22,000 EGP` and `$255.50`, so the choice does nothing today. Recommended: make `code` strictly ISO everywhere (`255.50 USD`) for new documents only; committed ones keep their snapshot. That changes how USD/EUR drafts look, so it needs your ruling. Alternatively drop `symbol`. — open.
5. Density: the app was already compact, so "compact" is the default and "comfortable" is the new option. — FYI.

## Leftovers

- ~~Client preferred style~~ done in `5ad2449` (owner, 2026-11-18).
