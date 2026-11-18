# 0014. Issue snapshots: freeze what a committed document printed

- Status: accepted
- Date: 2026-11-18

## Context

AGENTS rule 8: a document that was sent, paid or signed never changes appearance or content because of a later edit elsewhere. ADR-0005 freezes contract clauses and ADR-0012 freezes the look (`style_snapshot`). Everything else a document prints came from live data at render time:

- the provider block (name, legal name, role, city, address, email, phone, website, national ID / registry);
- the payment methods (InstaPay, wallet, IBAN);
- the client block;
- the formats added in Settings by SET-01 (date format, currency display, tax registration number) and the digit style (D6).

So an invoice sent with an old IBAN or address re-exported with the new one. The owner ruled on 2026-11-18 to freeze all of it, with the formats.

## Decision

- **One nullable `issue_snapshot` TEXT** on `invoices` and `contracts` (schema v8). It holds versioned JSON (`{"v": 1, "provider": {…}, "payment": {…}, "client": {…}, "format": {"date", "currency", "digits"}}`), modelled by `IssueSnapshot` in `lib/domain/issue_snapshot.dart`.
- **Taken in the single write path** by `DocumentSnapshots` (`lib/data/repositories/document_snapshots.dart`), together with the style snapshot, when a document becomes committed: an invoice sent or paid (`save`, `markPaid`), a contract signed, active or completed. It captures the settings and the client as they are at that moment.
- **Stored snapshots are never lost.** An editor copy taken before the save that froze the document carries no snapshot. `DocumentSnapshots` keeps the stored ones instead of writing nulls back, for both snapshots.
- **Rendering overlays, never forks.** `lib/features/pdf_render.dart` turns `Settings` and `Client` into what was printed (`IssueSnapshot.applyTo` / `applyToClient`). Then the same builders run. A key the snapshot lacks stays live, so a newer JSON version still renders what this build understands. A client deleted since commit still prints from the snapshot.
- **Documents committed before v8 have no issue snapshot and keep rendering from live data, as they always did.** Re-saving one does not freeze today's data. Freezing at upgrade time would pin data the document may never have printed. This is the accepted limit: their provider, payment, client and format details still follow Settings. Their **look** is frozen anyway (ADR-0012 and its legacy-lock amendment).
- Prefixes, defaults, numbering, notes templates, backups and every other setting are not printed details and stay live.

## Consequences

- Changing the profile, the payment details, a client, the date format, the currency display or the digit style never changes a document committed on v8 or later (`test/pdf/issue_snapshot_render_test.dart`). Drafts follow every change.
- One more JSON column to carry through backups and, later, sync. It is an ordinary nullable column on synced tables, so the existing triggers already cover it.
- Old backups (v1–v7) restore with no issue snapshots, which is the pre-v8 behaviour above.
- Document text that comes from the document itself (lines, notes, clauses, variables) is unaffected: it was already part of the document.
