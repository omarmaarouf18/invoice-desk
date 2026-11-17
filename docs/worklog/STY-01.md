# STY-01 — Document style engine

**Brief:** docs/briefs/2026-11-16-bilingual-styles.md, Phase 4 · **Branch:** feat/bilingual-styles

## Plan
1. **Noto Naskh Arabic:** Download Regular, SemiBold, Bold TTFs from the official Google Fonts / Noto repo to `assets/fonts/` with its OFL license, declare in `pubspec.yaml`, and extend `test/pdf/rtl_word_gap_test.dart` to verify RTL word spacing.
2. **`DocumentStyle` model:** Value object in `lib/domain/document_style.dart`: immutable, colors, typography (IBM Plex Sans Arabic vs Noto Naskh Arabic), page geometry, header style, logo, table style, totals style, block visibility toggles, block ordering, footer text. Fuzz-safe `fromJson` / `toJson` that clamps out-of-range values and ignores unknown keys.
3. **Presets:** Five distinct presets with stable IDs (`classic`, `modern`, `minimal`, `bold`, `blank`).
4. **Schema v7 (Drift):**
   - New table `document_styles` (with `SyncRev`, `isDemo`, `id`, `name`, `kind`, `base_preset`, `json`, `schema_version`, `archived`, timestamps).
   - Add columns: `invoices.style_id`, `contracts.style_id`, `clients.style_id`, `invoices.style_snapshot`, `contracts.style_snapshot`, `app_settings.default_invoice_style_id`, `app_settings.default_contract_style_id`.
   - Forward migration step in `lib/data/db.dart` (v6 -> v7).
   - `dart run drift_dev make-migrations`, migration test v6 -> v7, update schema snapshot & `docs/DATA_MODEL.md`.
5. **Resolution & Snapshot:**
   - Single repository write path captures snapshot on sent/paid/signed in the same transaction.
   - Resolution order: snapshot -> document `style_id` -> client `style_id` -> settings default -> `Classic`.
6. **PDF Builders:**
   - Deconstruct invoice and contract builders into modular block builders styled by `PdfStyle`.
7. **Verification & Goldens:**
   - Migration tests, snapshot immutability test, resolution tests, overlap guard test, and new PDF goldens.

## Findings
- 2026-11-17 — Arabic layout bugs from Phase 3 were fixed (`96dc046`):
  - Inverted flex alignment in Arabic RTL footer separated runs to opposite ends.
  - Distinct widgets for Arabic section numbers prevent `arabic.convert` tokenization reversal.
  - Payment details row mirrored with start column and 8pt gap.
  - Arabic-Indic digit separators use `٬` (U+066C) and `٫` (U+066B).
  - Overlap guard test (`test/pdf/text_overlap_test.dart`) verified 0 overlaps across all permutations.
- 2026-11-17 — Noto Naskh Arabic was approved by the owner for Phase 4.

## Open questions
None at start of Phase 4.

## Leftovers
None.
