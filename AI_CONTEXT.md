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
| 4 — Style engine (schema v7) | ✅ done. Schema v7 (`c0a2150`), StyleRepository & snapshots (`7aad4c7`), PdfStyle builders (`12bc577`), preset goldens (`92ed4ea`), ADR-0012; follow-ups: VAT row correctness, 24h asset grace period & trash retention, preset refinements (Modern sans, Bold naskh, Minimal light totals & no card backgrounds) |
| 5 — Style editor UI | ⏳ starting (settings/editor style management, live preview, logo upload) |
| 6 — Settings redesign | — |
| 7 — Contracts in English + styles | — |
| 8 — UX polish | — |

## Next (Phase 5 — Style editor UI: STY-02)

1. **Style editor UI:** Settings card for document styles with preset duplication, color/font/geometry pickers, and live PDF preview.
2. **Logo upload:** Logo import with validation ($\le$ 1 MB, PNG/JPG) stored in `document_assets`.
3. **Document style selector:** Style picker in invoice editor (and later contract editor), falling back to client preferred or global setting.

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

0001 Flutter desktop · 0002 drift/SQLite · 0003 integer money · 0004 30-day soft delete · 0005 clause snapshots · 0006 `$ORIGIN` runpath · 0007 RPM in /opt · 0008 offline first · 0009 free desktop / paid encrypted sync · 0010 E2E-encrypted sync · 0011 document language model · 0012 document styles · 0013 vendored `pdf` RTL fix
