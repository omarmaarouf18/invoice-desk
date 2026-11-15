# Invoice Desk

Offline desktop invoicing for a solo freelancer. Arabic RTL shell, bilingual
invoices, vector PDF export. Flutter (Material 3) · Riverpod 3 · drift/SQLite ·
`pdf` + `printing`.

## Run

```bash
flutter pub get
flutter run -d linux
```

Release build: `flutter build linux --release` → `build/linux/x64/release/bundle/invoice_desk`.

## Where data lives

| What | Where |
|---|---|
| Database | app support dir, `invoice_desk.sqlite` (Linux: `~/.local/share/me.omarmaarouf.invoice_desk/`) |
| Window size, last invoice, theme, last export folder | `ui_state.json` next to the database |
| Daily backups (`VACUUM INTO`, last 30 kept) | `~/Documents/Invoice Desk Backups` unless changed in بياناتي |

First launch seeds Omar's profile, the EL METR Academy client and invoice
OM-2026-0001.

## Keyboard

Ctrl+N new invoice · Ctrl+Shift+N new client · Ctrl+K / Ctrl+F search ·
Ctrl+S save · Ctrl+E export PDF · Ctrl+D duplicate · Ctrl+R renewal ·
Ctrl+1 / Ctrl+2 edit / preview · Esc clears search / closes dialogs.
In the items table Tab moves across cells and Enter in the last price cell adds a row.

## Layout

```
lib/
  main.dart, bootstrap.dart      window, DB open, ProviderScope, DB-error screen
  core/                          Money/MoneyBag (integer minor units), CalendarDate, digit folding
  domain/                        immutable models + pure rules (totals, numbering, renewal, overdue)
  data/                          drift tables, DAOs, seed, backup/restore (only layer importing drift)
  features/sidebar|editor|preview|settings|clients
  pdf/invoice_pdf.dart           pure (invoice, client, settings) → PDF bytes
  theme/                         tokens, light/dark ThemeData
  l10n/arb/app_ar.arb            all UI strings (Arabic; keys ready for English)
drift_schemas/                   committed schema snapshots for migrations
```

## Development

```bash
dart run build_runner build          # after changing drift tables
dart run drift_dev make-migrations   # after bumping schemaVersion
flutter gen-l10n                     # after editing the ARB file
flutter test                         # unit, DAO, PDF, flow and golden tests
flutter test --update-goldens        # refresh goldens after intended UI changes
```

Fonts: IBM Plex Sans Arabic (SIL OFL, `assets/fonts/OFL.txt`).
