# AI_CONTEXT — Invoice Desk

> The **current** state only. It is rewritten in place, never appended to: replace stale lines, don't add dated amendments. History goes in `CHANGELOG.md`, git log and the worklogs. Keep this file under ~120 lines.
> Agents update the "State" and "Next" sections in the same commit that changes them.

## State (as of 2026-11-19)

- **Released:** `v0.1.0`–`v0.4.0` are tagged (`v0.2.0`–`v0.4.0` pushed 2026-11-19 with no GitHub release; the old drafts were deleted). No GitHub release is published yet. **0.5.0 is prepared** on `feat/release-green` (`chore(release): 0.5.0`, `pubspec.yaml` `0.5.0+6`, CHANGELOG `## [0.5.0] - 2026-11-19`) and **not tagged**. Schema **v8**.
- **Pipeline:** `main` CI 44495539215 and the release dry run 44495540370 are fully green (all 8 assets, `SHA256SUMS.txt`, `latest.json`, attestations). `package.yml` runs by hand on any branch; `install ubuntu:22.04` is non-blocking (Ubuntu mirror stalls, `docs/RELEASING.md` §1). Windows and macOS ship unsigned (D6).
- **Active branch:** `feat/release-green` (off `main` = `dev` = `e9f3a72`). `dev` is the integration branch; `main` only fast-forwards to a green `dev` commit, never by PR merge (RELEASING "Never merge into `main`").
- **Active brief:** `docs/briefs/2026-11-19-release-green.md`. Phases 0–3 done (WF-04, REL-02); Phase 4 / REL-03 is at "release commit ready, owner tags". Worklogs: `docs/worklog/WF-04.md`, `REL-02.md`. `docs/briefs/2026-11-16-bilingual-styles.md` stays open for phases 7–8 (0.6.0, D5).

| Phase | Status |
|---|---|
| 0 — Arabic PDF word gaps (B1) | ✅ done. `pdf` vendored + patched (ADR-0013); gap regression test; samples regenerated from fictional data |
| 1 — Foundations | ✅ done. `DocLanguage`, `doc_format`, `DocLabels`, `PdfStyle.classic` (pixel-identical), `localeProvider` (ADR-0011) |
| 2 — English UI + follow-ups | ✅ done. `app_en.arb`, ICU plurals (`0a67998`), auto-direction inputs (`c28ffd7`), fallback to English (`e1965fe`) |
| 3 — Document language: invoices | ✅ done. Schema v6 (`627e6a0`), PDF builder (`baf5940`), UI/repos/settings (`d232ee4`), goldens (`fd8bd76`), Arabic PDF bug fixes (`96dc046`, `f4f0bd2`) |
| 4 — Style engine (schema v7) | ✅ done. Schema v7 (`c0a2150`), StyleRepository & snapshots (`7aad4c7`), PdfStyle builders (`12bc577`), ADR-0012; follow-ups: VAT row correctness, 24h asset grace period & trash retention, 6 distinct presets (Formal with Naskh, Bold/Modern with Plex), word-level font fallback and bidi paragraph context preservation in vendored pdf (`9f8d21c`), text bidi guard test (`e86c606`), updated preset goldens |
| 5 — Style editor UI | ✅ done (owner review 2026-11-17). Editor page, pickers + lock, styles in previews/exports, legacy lock, JSON import/export, trash; review fixes: Modern contrast (`98d6483`), preview language, «بارز», delete usage count |
| 6 — Settings redesign | ✅ ships in 0.5.0 (D5, owner 2026-11-19); review questions in `docs/worklog/SET-01.md`. Sectioned navigation + search, schema v8 (`3022ebd`), issue snapshots (ADR-0014, `5b508df`), numbering pattern / VAT / currency / formats (`79e7ab5`), client preferred style (`5ad2449`), per-machine settings + shortcuts (`a99273f`) |
| 7 — Contracts in English + styles | — (0.6.0, D5) |
| 8 — UX polish | — (0.6.0, D5) |

## Next

1. **Owner: release 0.5.0** (`docs/RELEASING.md` §4, brief Phase 4). Push `feat/release-green` and land it on `dev`, run `package.yml` on `dev`, fast-forward `main`, wait for green, then push `v0.5.0`. Then check the brief's Phase 4 "Done when" (downloads, `latest.json`, `sha256sum -c`, `gh attestation verify` per platform).
2. **D4:** the owner is enabling "Require linear history" on `protect-main` (2026-11-19). `dev` must stay merge-free: branches land on it by fast-forward.
3. **0.5.1: English UI wording fixes** from a native read of the English strings (owner ruling 2026-11-19: 0.5.0 ships without it).
4. **Phase 7 — Contracts in English + styles (CON-01)** for 0.6.0. Owner note (2026-11-17): Arabic values with numbers must not wrap with the number alone on a line in English contracts.
5. **Flutter SDK bump** (separate task): lifts the Dependabot ignores for `window_manager >=0.7` and `very_good_analysis >=11` (D3).
6. **PERF-01** (release-pipeline brief §7).

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

- Whether to file the upstream `jni` bug (`/DELAYLOAD:jvm.dll` on an undefined `${TARGET_NAME}`; `docs/worklog/REL-02.md`).
- Whether to purge the old real-data sample PDFs from git history (they were deleted from the tree only).

## ADR index

0001 Flutter desktop · 0002 drift/SQLite · 0003 integer money · 0004 30-day soft delete · 0005 clause snapshots · 0006 `$ORIGIN` runpath · 0007 RPM in /opt · 0008 offline first · 0009 free desktop / paid encrypted sync · 0010 E2E-encrypted sync · 0011 document language model · 0012 document styles · 0013 vendored `pdf` RTL fix · 0014 issue snapshots · 0015 GPL-3.0-or-later licence
