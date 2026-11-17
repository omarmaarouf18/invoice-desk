# STY-02 — Style editor UI

**Brief:** docs/briefs/2026-11-16-bilingual-styles.md, Phase 5 · **Branch:** feat/bilingual-styles

## Findings before planning (2026-11-17)

- **Styles reach no PDF yet.** `PreviewPane`, the contract preview, `AppActions.exportPdf` and `ContractActions.exportPdf` all call the builders without a `style`, so everything renders Classic whatever the document says. The editor is pointless until this is wired, so it is commit 1.
- **Legacy lock gap (rule 8).** Invoices sent/paid and contracts signed **before v7** have no `style_snapshot`. Restored v1–v6 backups and demo rows are the same. Under the live chain, the first time the user picks a default style, those documents would change look. Fix, with no migration and no data rewrite: when the **stored** row is sent/paid/signed and has no snapshot, it resolves to Classic and counts as locked. Every v7 write path that commits a document already snapshots, so this only ever hits legacy rows. It matches ADR-0012's promise ("zero impact on sent, paid or signed documents"). It does not change what any existing document looks like today: they are all Classic now.
- **`StyleRepository._isPresetId` misses `formal`.** A `style_id` of `preset_formal` falls through to the DB lookup, finds nothing, and resolves to the next fallback. Fix: delegate to `DocPreset`.
- Document styles are not in «المحذوفات». "Delete (soft, like other entities)" means they must be: a new `TrashKind.style`.

## Screen layout — «تصميم المستندات» / "Document styles"

A new `Workspace.styles`, shown in the main pane like the clause library. Three columns, all Directional, so the layout mirrors in English:

```
┌ header: title · subtitle · [Back] ─────────────────────────────────────────┐
│ START (260)        │ MIDDLE (flex)                  │ END (340, scrolls)    │
│ Presets            │ preview toolbar:               │ name + lock note      │
│  ▣ Classic         │  [Invoice|Contract] [ar|en|bi] │ ▸ Colours             │
│  ▣ Modern …        │ ┌────────────────────────────┐ │ ▸ Font                │
│ My styles          │ │  live PDF (PdfPreview,     │ │ ▸ Header & logo       │
│  ▣ Acme brand  ⋮   │ │  300 ms debounce)          │ │ ▸ Table               │
│  ▣ …               │ └────────────────────────────┘ │ ▸ Totals              │
│ [+ New from Blank] │                                │ ▸ Visible blocks      │
│ [Import .json]     │                                │ ▸ Footer              │
└────────────────────┴────────────────────────────────┴───────────────────────┘
```

- **Start: style list.** Each row shows a thumbnail (a small Flutter-drawn page: header band/rule, accent, table style, totals style; no PDF raster) and the name.
  - Presets come first and are read-only. Selecting one shows the inspector disabled, with a "Duplicate to customise" button.
  - User styles follow. Each row's ⋮ menu has Duplicate, Rename, Reset to preset, Export .json and Delete.
  - At the bottom: "New from Blank" (duplicates Blank) and "Import .json".
- **Middle: live preview.**
  - Document: the open invoice if there is one, otherwise a fictional sample invoice («Acme Studio», built in pure Dart). "Contract" is enabled only when a contract is open.
  - Language: defaults to the open document's language and can be switched (ar / en / bilingual; bilingual is invoice only).
  - Reuses the PreviewPane mechanism. The `PdfPreview` chrome is extracted into a shared `PdfPagesView`, and the 300 ms debounce runs on each style edit.
- **End: inspector.** Edits autosave after 600 ms, like Settings, through `StyleRepository.saveUserStyle`. A contrast warning sits under any colour pair that fails.

At widths below about 1180 px the inspector moves under the list as a tab, so the preview keeps at least 380 px. Pixel tuning is timeboxed (Phase 8).

## Controls per inspector group

| Group | Controls (→ `DocumentStyle` field) |
|---|---|
| **Colours** | Seven colour fields: primary, accent, ink, muted, surface, tableHeaderBg, border. Each has a swatch, a hex text field (LTR) and a palette popup of 12 curated colours. **Contrast warnings (< 4.5:1):** ink on white, muted on white, ink on surface, ink on tableHeaderBg, white on ink (total band), white on primary (band header) |
| **Font** | Family: IBM Plex Sans Arabic / Noto Naskh Arabic, as a segmented control with a sample line in each font → `fontFamily`. Base size slider 8–14 pt, step 0.5 → `baseSize`. Scale slider 0.8–1.5 → `scale`. Paper A4/Letter → `paper`. Margins: three sliders 15–80 pt → `marginHorizontal/Top/Bottom` |
| **Header & logo** | Header style band / rule / none → `headerStyle`. Logo: Choose… (`file_selector`, PNG/JPG; the repository enforces ≤ 1 MB and the magic bytes, with an error snack on reject), a preview chip and Remove → `logoAssetId`. Logo size slider 20–120 → `logoSize`. Position start / centre / end → `logoPosition`. Toggles: role, city, contacts → `showRole/showCity/showContacts` |
| **Table** | Style plain / striped / bordered → `tableStyle` |
| **Totals** | Style outlined / solid / plain → `totalsStyle`. Toggles: VAT row, paid stamp → `showVatRow/showPaidStamp` |
| **Visible blocks** | A reorderable list of the 6 `DocBlock`s, each with a checkbox (in `blockOrder` or not) and a drag handle. Header, items and totals stay checked (Blank's essentials). Toggles: payment card, "please quote", notes, page numbers, signature boxes → `showPaymentCard/showPleaseQuote/showNotes/showPageNumbers/showSignatureBoxes` |
| **Footer** | Two multi-line fields, footer text Arabic (RTL) and English (LTR) → `footerTextAr/En` |

## Actions

- **Duplicate:** a new user row named «<name> (نسخة)» / "<name> (copy)", same `basePreset`. A preset's duplicate keeps the preset as its base.
- **Rename:** a dialog. The name must not be empty; it is trimmed.
- **Reset to preset:** confirm, then replace `style` with the `basePreset` style. Name and logo are kept.
- **Delete:** soft delete, an undo snack, and the style appears in «المحذوفات» (`TrashKind.style`). Restore and purge go through `TrashRepository`; a purge writes a backup first (rule 7). Documents or clients that pointed at a deleted style fall through the chain, as resolution already does.
- **Export .json:** `{ "format": "invoice-desk-style", "version": 1, "name", "basePreset", "style": {…}, "logo": { "mime", "base64" }? }`. The logo is embedded so a style moves between machines.
- **Import .json:** parse it. A wrong `format`, a bad version or non-JSON gives an error snack. `style` goes through `DocumentStyle.fromJson` (clamps, ignores unknown keys). A logo goes through `saveAsset` (same validation as upload). The name gets " (2)" if it is taken. The parser is pure Dart in `lib/domain/style_file.dart` and is fuzz-tested.

## Document editors

- **Invoice Details card and contract card:** a "Document style" picker, a dropdown whose items carry the same thumbnail. "Follows client / default" is `styleId = null`. An "Edit styles…" entry opens the page.
- **Locked:** when the look is frozen (stored snapshot, or legacy committed), the picker is disabled and shows «التصميم مثبّت لأن الفاتورة أُرسلت» (contract: «…لأن العقد وُقِّع»).
- **Settings:** a small "Document styles" card with default invoice style, default contract style and "Open style editor". Phase 6 moves it into its section.

## Data/repository additions (no schema change)

- `StyleRepository.lookForInvoice(Invoice)` / `lookForContract(Contract)` → `ResolvedLook { DocumentStyle style; Uint8List? logo; bool locked; }`. The snapshot is the in-memory one, else the stored row's. Legacy committed rows resolve to Classic and `locked`.
- `duplicateStyle`, `renameStyle` and `resetStyle` are thin wrappers on `saveUserStyle`.
- `exportStyleFile(id)` / `importStyleFile(String)`.
- Trash: `TrashKind.style` in entries, restore and purge.
- One UI helper, `invoicePdfBytes` / `contractPdfBytes` (`lib/features/pdf_render.dart`), used by both previews and both exports, so they can't drift apart.

## Commit order

1. `fix(STY-02)`: formal preset id in style resolution, and the legacy lock for committed documents without a snapshot (+ repository tests).
2. `feat(STY-02)`: resolved looks (style + logo) in both previews and both PDF exports (+ test: an invoice whose style is Modern exports Modern bytes; existing Classic goldens unchanged).
3. `feat(STY-02)`: pure-Dart contrast ratio, style file format and sample invoice (+ unit/fuzz tests).
4. `feat(STY-02)`: style repository actions and document styles in the trash (+ tests).
5. `feat(STY-02)`: style editor page: list, preview, inspector (+ ARB ar/en).
6. `feat(STY-02)`: logo upload, JSON export/import in the editor.
7. `feat(STY-02)`: style picker and lock notice in the invoice and contract editors; Settings card.
8. `test(STY-02)`: flow test: duplicate Blank, enable notes, assign to an invoice, render the export bytes and check Blank's look (no payment card text) plus the notes text.
9. `test(STY-02)`: style editor goldens (ar light, en light), as their own commit.
10. `docs(STY-02)`: CHANGELOG, ARCHITECTURE, ADR-0012 (legacy lock), AI_CONTEXT, this worklog.

## Commits as built (2026-11-17)

The plan's commits 5 and 6 landed as one (`bd2767e`): the logo and JSON actions share `style_actions.dart` with the rest of the page. Two fixes were found on the way and got their own commits: `c5f983c` (`DocumentStyle.fromJson` threw on wrong-typed fields, found by the style file fuzz test) and `c07ea4f` (PdfPreview's red error box, which the goldens would otherwise have locked).

## Findings (build)

- 2026-11-17 — Trashed styles were never purged and `purgeUnusedAssets` was never called. Both now run in start-up housekeeping.
- 2026-11-17 — `ensureVisible` stops at the nearest Scrollable. Inside the inspector that is the non-scrolling reorderable block list, so the flow test drags the outer list itself.
- 2026-11-17 — The flow test drives the Details-card picker through its `onChanged` and checks the export **bytes** from `renderInvoicePdf` (the function the Export button calls), not a file written through the save dialog: tests have no file-selector platform.

## Open questions

1. Legacy committed documents with no snapshot: lock them to Classic (recommended, implemented), or backfill snapshots in a migration (a data rewrite, so a stop-and-ask)? — answered 2026-11-17: approved.
2. The default-style controls land in Settings now, before Phase 6, because without them there is no way to set a default. Phase 6 moves them. — answered 2026-11-17: approved.
3. The shipped **Modern** preset fails one contrast pair: muted #64748B on its table-header #EFF6FF is 4.37:1 (needs 4.5). So a copy of Modern shows a warning. Recommended: darken Modern's muted to #607089 (4.62:1 on the header, 5.03:1 on white; visually almost the same). This changes how existing Modern **drafts** look (sent ones are snapshotted), so it waits for the owner. — answered 2026-11-17: fix the preset, no exception. Modern's muted is now #475569 (`98d6483`, goldens `e6e69e6`).

## Review fixes (2026-11-17)

- Preview language dropdown shows the language in use (`b44dc24`).
- Bold is «بارز» in the UI, guarded by a name-parity test (`9c39f13`).
- Deleting a style in use says how many drafts and clients fall back; fallback documented in ADR-0012 and tested (`9ed8367`).

## Leftovers

- Client preferred style (`clients.style_id`) has no UI yet. Natural home: the client sheet, Phase 6 or 8.
