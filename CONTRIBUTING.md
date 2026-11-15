# Contributing

Thanks for helping. Invoice Desk is a small, offline Flutter desktop app; please keep it that way.

## Setup

You need Flutter 3.44 / Dart 3.12 and the Linux desktop toolchain.

```bash
flutter pub get
```

```bash
flutter run -d linux
```

To work on a throwaway database, set `INVOICE_DESK_DATA_DIR=$(mktemp -d)`.

## Before you open a PR

```bash
./scripts/ci_local.sh
```

It runs:
- formatting, `flutter analyze --fatal-infos`, the layering test and the size check;
- codegen and l10n freshness, the schema guard, and the data-model doc check;
- tests with coverage, then goldens;
- the secret scan, OSV scan and licence report, when those tools are installed.

## Rules of the codebase

- **Layers.** UI goes through repositories (`lib/data/repositories`, read via `lib/data/providers.dart`) and never imports DAOs, `db.dart`, `tables.dart` or drift. `lib/core` and `lib/domain` are pure Dart. See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).
- **Sizes.** Hand-written files stay at 500 lines or fewer, and `build` methods at 80 or fewer. Split into named widget classes, not `_buildX()` methods.
- **Money** is integer minor units. Dates are `CalendarDate`. Time comes from the injected `Clock`, never `DateTime.now()`.
- **Schema changes** need a drift migration, a snapshot (`make-migrations`), a migration test with data, and a regenerated `docs/DATA_MODEL.md`.
- **Strings** go in `lib/l10n/arb/app_ar.arb`; run `flutter gen-l10n`.
- **Public API** in `lib/core`, `lib/domain`, `lib/data/repositories`, `lib/account` and `lib/sync` has doc comments. They say why, give units and edge cases, and don't repeat the name.
- **Commits** are [Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `build:`, `ci:`, `chore:`.
- **Data.** Never commit databases, backups or anything from a real data folder. Fixtures use fake names, such as "Acme Studio".

## Decisions

Significant choices get an ADR in [docs/adr/](docs/adr/). Copy `0000-template.md`.
