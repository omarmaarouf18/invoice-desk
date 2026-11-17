# STY-01 — Document style engine

**Brief:** docs/briefs/2026-11-16-bilingual-styles.md, Phase 4 · **Branch:** feat/bilingual-styles

## Plan & Commit Order
1. **Fonts & En Dash (Done):**
   - Noto Naskh Arabic bundled with OFL license & tested (`3f756ac`).
   - En dash separator (`–`) next to Arabic-Indic section digits (`2a0f9ba`, `4e01b13`).
2. **Commit (a): `DocumentStyle` value object (pure domain):**
   - Value object in `lib/domain/document_style.dart`: immutable, colors, typography (fontFamily `ibmPlexSansArabic` | `notoNaskhArabic`, baseSize, scale), page geometry, header style, logo asset reference, table style, totals style, block visibility toggles, block ordering, footer text.
   - Fuzz-safe `fromJson` / `toJson` that clamps out-of-range values and ignores unknown keys.
   - Unit tests: JSON round-trip and fuzz tests (pure Dart in `test/domain/document_style_test.dart`).
3. **Commit (b): Presets as const data:**
   - Five distinct presets with stable IDs (`classic`, `modern`, `minimal`, `bold`, `blank`) in `lib/domain/document_style_presets.dart`.
4. **Commit (c): Schema v7 + migration v6→v7 + DATA_MODEL.md:**
   - Table `document_assets` (`id` = sha256, `mime`, `bytes`, `created_at`, `SyncRev`, `outbox`). Validated on import: PNG/JPG only, ≤ 1 MB.
   - Table `document_styles` (`SyncRev`, `isDemo`, `id`, `name`, `kind`, `base_preset`, `json`, `schema_version`, `archived`, timestamps).
   - Columns: `invoices.style_id`, `contracts.style_id`, `clients.style_id`, `invoices.style_snapshot`, `contracts.style_snapshot`, `settings.default_invoice_style_id`, `settings.default_contract_style_id`.
   - Forward migration step in `lib/data/db.dart` (`from6To7`).
   - Run `dart run drift_dev make-migrations`, write migration tests in `test/drift/app_db/migration_test.dart`, regenerate `docs/DATA_MODEL.md`.
5. **Commit (d): Repository & snapshot logic:**
   - `StyleRepository` with resolution order: document snapshot -> document `style_id` -> client `style_id` -> settings default -> Classic.
   - Single write transaction captures snapshot on sent/paid (invoice) or signed (contract). Snapshot stores resolved style JSON including asset id.
   - Logo assets are never purged while referenced by any style or document snapshot.
   - Repository tests: resolution order, snapshot immutability (changing logo after "paid" keeps PDF bytes identical).
6. **Commit (e): PDF builders refactored into block builders:**
   - Modular block builders reading `PdfStyle` and composing in `blockOrder`.
   - Noto Naskh Latin fallback (IBM Plex) via `fontFallback`. Test rendering `"Acme Studio · hello@acme.example · 22,000.00"` with no missing glyphs.
   - Verify Classic preset produces byte-identical PDFs (all existing goldens pass unchanged).
7. **Commit (f): Modern / Minimal / Bold / Blank rendering + goldens:**
   - Render each preset across languages (invoice: 5 presets × 3 languages; contract: 5 presets × 2 languages).
   - Overlap guard test on all combinations.
   - Re-baseline new goldens.
8. **Commit (g): ADR-0012, CHANGELOG, AI_CONTEXT:**
   - Document ADR-0012, update CHANGELOG `[Unreleased]`, update `AI_CONTEXT.md`.
   - Run full gate `./scripts/ci_local.sh --no-package`.

## Findings
- 2026-11-17 — Middle dot `·` next to Arabic-Indic digits looks like Arabic zero `٠` (`١٠`). Switched to en dash `–` with spaces (`١ – التطوير والتنفيذ`) in table headers and totals box (`2a0f9ba`, `4e01b13`).
- 2026-11-17 — Noto Naskh Arabic lacks Latin glyphs (contains only Arabic + common punctuation/digits). Configured `fontFallback: [plexFont]` in `pw.TextStyle`, which cleanly renders mixed text like `"Acme Studio · hello@acme.example · 22,000.00"` without missing glyphs.

## Open questions
None.
