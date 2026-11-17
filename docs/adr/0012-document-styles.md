# 0012. Document styles and snapshots

- Status: accepted
- Date: 2026-11-17

## Context

Documents generated in Invoice Desk (invoices and contracts) originally shared a single hard-coded appearance: teal accent, navy ink, slate borders, and IBM Plex Sans Arabic typography. Users need distinct visual presentations—ranging from modern and minimal looks to bold or stripped-down styles—as well as the ability to customize brand colors, typography, header styles, and logos.

However, a fundamental invariant of Invoice Desk is that documents that were sent, paid, or signed must never alter their appearance or layout due to later edits elsewhere (preserving the same immutability guarantee established for clauses in ADR-0005).

## Decision

- **Pure value object.** `DocumentStyle` in `lib/domain/document_style.dart` is an immutable pure-Dart value object representing colors, margins, base font size, header style, logo sizing/positioning, table styling, totals box treatment, and block visibility flags. It serializes to and from versioned JSON (`schemaVersion: 1`).
- **Built-in presets.** 5 immutable presets (`classic`, `modern`, `minimal`, `bold`, `blank`) in `lib/domain/document_style_presets.dart`. `DocPreset.classic` reproduces the pre-styles 0.4 layout and palette byte-identically, guaranteed by PDF golden tests. Presets cannot be overwritten or deleted; users can duplicate them into custom styles.
- **Separate asset storage.** Image binaries (logos) are never stored inside the style JSON string. A dedicated `document_assets` table (schema v7) stores images keyed by the SHA-256 digest of their bytes (`id`), along with MIME type and byte payload. Assets are validated on import (PNG or JPEG magic bytes only, $\le$ 1 MB). Style objects reference assets by `logoAssetId`.
- **Resolution hierarchy.** When building a document PDF, the style is resolved in strict priority order via `StyleRepository.resolveStyle`:
  1. `snapshotJson` (if the document was already sent, paid, or signed);
  2. `styleId` on the document itself;
  3. `styleId` on the client record;
  4. Global default in settings (`defaultInvoiceStyleId` or `defaultContractStyleId`);
  5. Ultimate fallback: `DocPreset.classic.style`.
- **Snapshots on commitment.** When an invoice is transitioned to `sent` or `paid`, or a contract is marked `signed`, the repository freezes the resolved `DocumentStyle` JSON into `invoices.style_snapshot` or `contracts.style_snapshot` in the exact same SQLite transaction.
- **Logo freezing & garbage collection.** Snapshots freeze the style JSON including `logoAssetId`. An asset referenced by any document snapshot (even on soft-deleted documents) or custom style (including soft-deleted styles in the trash) is immune to garbage collection (`StyleRepository.purgeUnusedAssets`). Furthermore, unattached assets enjoy a 24-hour grace period from creation before becoming eligible for purge. Asset purge is a hard delete without a sync tombstone because assets are content-addressed by SHA-256: any peer requiring the binary can re-derive its identity or re-upload it deterministically, and unreferenced blobs generate no synchronization tombstones. Replacing a company logo later never alters the visual output or byte content of past sent or paid documents.
- **Typography & Latin fallback.** Alongside IBM Plex Sans Arabic, Noto Naskh Arabic is bundled with its OFL licence. Because Noto Naskh Arabic lacks Latin glyphs, PDF builders configure IBM Plex Sans Arabic as an automatic `fontFallback` for Naskh styles, ensuring mixed Arabic and Latin text renders cleanly without missing glyphs.
- **Decoupled rendering.** PDF builders (`buildInvoicePdf`, `buildContractPdf`) take a resolved `PdfStyle` and plain font data, maintaining zero runtime dependency on drift or repositories.

## Consequences

- Existing documents and future documents using `DocPreset.classic` remain 100% byte-identical to previous releases.
- Any change to global settings, client preferences, or custom style presets has zero impact on sent, paid, or signed documents.
- Asset storage is content-addressed and deduplicated: identical logos share storage and are purged only when all referencing documents and styles (including trashed records) are permanently deleted, after a 24-hour upload grace period. Asset purge is a hard delete with no sync tombstones.
- UI layer for style creation and editing (Phase 5) will build directly on top of `StyleRepository` without requiring schema or PDF engine alterations.
