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

## Install (Linux x86_64)

Download from the release page, check the file against `SHA256SUMS.txt`
(`sha256sum -c SHA256SUMS.txt --ignore-missing`), then pick one:

**Fedora / RHEL (RPM)** — system-wide, in `/opt/invoice-desk`:

```bash
sudo dnf install ./invoice-desk-0.2.0-1.x86_64.rpm
sudo dnf remove invoice-desk   # removes the app only; your data and backups stay
```

**Any distro (tarball)** — per user, no root, in `~/.local/opt/invoice-desk`:

```bash
tar xzf invoice-desk-0.2.0-linux-x64.tar.gz
./invoice-desk-0.2.0-linux-x64/install.sh     # later: ./uninstall.sh
```

**Any distro (AppImage)** — single file, nothing installed:

```bash
chmod +x InvoiceDesk-0.2.0-x86_64.AppImage && ./InvoiceDesk-0.2.0-x86_64.AppImage
```

All three need GTK 3 (present on every mainstream desktop). Uninstalling never
touches your invoices: they live in your data folder (see below).

Build the same packages locally: `./scripts/package_linux.sh` → `dist/`
(needs `rpmbuild` for the RPM; the AppImage step downloads `appimagetool`).

## Where data lives

| What | Where |
|---|---|
| Database | app support dir, `invoice_desk.sqlite` (Linux: `~/.local/share/me.omarmaarouf.invoice_desk/`) |
| Window size, last invoice, theme, last export folder | `ui_state.json` next to the database |
| Daily backups (`VACUUM INTO`, last 30 kept) | `backups/` inside the data folder, unless changed in بياناتي |
| Override everything above | set `INVOICE_DESK_DATA_DIR=/some/folder` |

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
