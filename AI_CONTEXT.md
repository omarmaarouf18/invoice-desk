# AI_CONTEXT — Invoice Desk

> The **current** state only. It is rewritten in place, never appended to: replace stale lines, don't add dated amendments. History goes in `CHANGELOG.md`, git log and the worklogs. Keep this file under ~120 lines.
> Agents update the "State" and "Next" sections in the same commit that changes them.

## State (as of 2026-11-17)

- **Released:** 0.4.0 on `main` (calendar, postponements, demo data, schema v5).
- **Active branch:** `feat/bilingual-styles`. Nothing on it is pushed; the owner pushes.
- **Active brief:** `docs/briefs/2026-11-16-bilingual-styles.md`, with phases 0–8 (bilingual UI, bilingual documents, document styles, settings, UX).

| Phase | Status |
|---|---|
| 0 — Arabic PDF word gaps (B1) | ✅ done. `pdf` vendored + patched (ADR-0013); gap regression test; samples regenerated from fictional data |
| 1 — Foundations | ✅ done. `DocLanguage`, `doc_format`, `DocLabels`, `PdfStyle.classic` (pixel-identical), `localeProvider` (ADR-0011) |
| 2 — English UI + follow-ups | ✅ done. `app_en.arb`, ICU plurals (`0a67998`), auto-direction inputs (`c28ffd7`), fallback to English (`e1965fe`) |
| 3 — Document language: invoices | ✅ done. Schema v6 (`627e6a0`), PDF builder (`baf5940`), UI/repos/settings (`d232ee4`), goldens (`fd8bd76`), Arabic PDF bug fixes (`96dc046`, `f4f0bd2`) |
| 4 — Style engine (schema v7) | ⏳ starting (Noto Naskh approved; schema v7, PdfStyle, repositories) |
| 5 — Style editor UI | — |
| 6 — Settings redesign | — |
| 7 — Contracts in English + styles | — |
| 8 — UX polish | — |

## Next (Phase 4 — Document style engine: STY-01)

1. **Noto Naskh Arabic:** Download Regular, SemiBold, Bold from official Google Fonts repo to `assets/fonts/` with `OFL.txt`, and extend `rtl_word_gap_test.dart`.
2. **Schema v7:** `document_styles` table, snapshotting styles on documents (ADR-0012). Write forward migration step from v6 to v7.
3. **Style engine:** Extend `PdfStyle` with fonts, primary/secondary colors, logo image, geometry adjustments.
4. **Style tests:** Migration test v6→v7, style repository tests, backwards compatibility.

## Decided (do not reopen without the owner)

- **D1:** line items stay one field, written in the document's language.
- **D2:** no bilingual (two-column) contracts in this brief.
- **D3:** style snapshot when a document becomes sent, paid or signed.
- **D4:** fonts are bundled only. Noto Naskh Arabic is **asked for again at Phase 4**.
- **D5:** logo is PNG/JPG ≤ 1 MB, stored in the DB.
- **D6:** digits default to Western; `contractWesternDigits` migrates into a digit-style setting.
- **D7:** document language resolution: document → client → global (`ar`).
- **D8:** UI language lives in `UiPrefs`: system / ar / en; unsupported OS language falls back to English.
- **Arabic invoice labels:** reviewed by the owner on 2026-11-16 (`DocLabels.ar`).
- **The visual feature is named «تصميم المستند» / `DocumentStyle`.** «Template» stays reserved for clause templates.

## Open (owner)

- Whether to purge the old real-data sample PDFs from git history (they were deleted from the tree only).
- A native read of the English UI strings before 0.5.

## ADR index

0001 Flutter desktop · 0002 drift/SQLite · 0003 integer money · 0004 30-day soft delete · 0005 clause snapshots · 0006 `$ORIGIN` runpath · 0007 RPM in /opt · 0008 offline first · 0009 free desktop / paid encrypted sync · 0010 E2E-encrypted sync · 0011 document language model · 0012 document styles *(reserved, Phase 4)* · 0013 vendored `pdf` RTL fix
