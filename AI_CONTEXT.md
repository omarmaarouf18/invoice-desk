# AI_CONTEXT — Invoice Desk

> The **current** state only. It is rewritten in place, never appended to: replace stale lines, don't add dated amendments. History goes in `CHANGELOG.md`, git log and the worklogs. Keep this file under ~120 lines.
> Agents update the "State" and "Next" sections in the same commit that changes them.

## State (as of 2026-11-17)

- **Released:** nothing is published yet. Only `v0.1.0` is tagged; `main` (`e4f63fa`) is from before 0.1.0. The 0.2.0–0.4.0 release commits (`98a7cb9`, `df865df`, `e120ecb`; 0.4.0 = calendar, demo data, schema v5) are untagged on the branch chain. This branch is at **schema v8**.
- **Active branch:** `feat/release-pipeline` (off `feat/bilingual-styles` at SET-01). Nothing is pushed; the owner pushes.
- **Active brief:** `docs/briefs/2026-11-18-release-pipeline.md` (REL-01 + WF-03 built, awaiting the owner sequence in `docs/RELEASING.md` §3; PERF-01 deferred). `docs/briefs/2026-11-16-bilingual-styles.md` stays open for phases 7–8 below.

| Phase | Status |
|---|---|
| 0 — Arabic PDF word gaps (B1) | ✅ done. `pdf` vendored + patched (ADR-0013); gap regression test; samples regenerated from fictional data |
| 1 — Foundations | ✅ done. `DocLanguage`, `doc_format`, `DocLabels`, `PdfStyle.classic` (pixel-identical), `localeProvider` (ADR-0011) |
| 2 — English UI + follow-ups | ✅ done. `app_en.arb`, ICU plurals (`0a67998`), auto-direction inputs (`c28ffd7`), fallback to English (`e1965fe`) |
| 3 — Document language: invoices | ✅ done. Schema v6 (`627e6a0`), PDF builder (`baf5940`), UI/repos/settings (`d232ee4`), goldens (`fd8bd76`), Arabic PDF bug fixes (`96dc046`, `f4f0bd2`) |
| 4 — Style engine (schema v7) | ✅ done. Schema v7 (`c0a2150`), StyleRepository & snapshots (`7aad4c7`), PdfStyle builders (`12bc577`), ADR-0012; follow-ups: VAT row correctness, 24h asset grace period & trash retention, 6 distinct presets (Formal with Naskh, Bold/Modern with Plex), word-level font fallback and bidi paragraph context preservation in vendored pdf (`9f8d21c`), text bidi guard test (`e86c606`), updated preset goldens |
| 5 — Style editor UI | ✅ done (owner review 2026-11-17). Editor page, pickers + lock, styles in previews/exports, legacy lock, JSON import/export, trash; review fixes: Modern contrast (`98d6483`), preview language, «بارز», delete usage count |
| 6 — Settings redesign | ⏸ built, awaiting review. Sectioned navigation + search, schema v8 (`3022ebd`), issue snapshots (ADR-0014, `5b508df`), numbering pattern / VAT / currency / formats (`79e7ab5`), client preferred style (`5ad2449`), per-machine settings + shortcuts (`a99273f`) |
| 7 — Contracts in English + styles | — |
| 8 — UX polish | — |

## Next

1. **Owner: release pipeline (REL-01).** Push, fast-forward `main`, run the release dry run, tag the old versions: `docs/RELEASING.md` §3. Send failing run links to the agent. Report and open questions in `docs/worklog/REL-01.md`.
2. **Owner review of Phase 6 (SET-01).** Report and open questions in `docs/worklog/SET-01.md`.
3. **Phase 7 — Contracts in English + styles (CON-01).** Owner note (2026-11-17): Arabic values with numbers must not wrap with the number alone on a line in English contracts.
4. **PERF-01** after the pipeline is merged (brief §7).

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

0001 Flutter desktop · 0002 drift/SQLite · 0003 integer money · 0004 30-day soft delete · 0005 clause snapshots · 0006 `$ORIGIN` runpath · 0007 RPM in /opt · 0008 offline first · 0009 free desktop / paid encrypted sync · 0010 E2E-encrypted sync · 0011 document language model · 0012 document styles · 0013 vendored `pdf` RTL fix · 0014 issue snapshots
