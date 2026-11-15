# 0007. RPM installs into /opt/invoice-desk

- Status: accepted
- Date: 2026-11-15

## Context

The Flutter bundle is a self-contained folder: a binary, `lib/` and `data/`. Splitting it across `/usr/bin`, `/usr/lib64` and `/usr/share` would break its relative lookups and gain nothing.

## Decision

- The RPM installs the bundle unchanged under `/opt/invoice-desk`.
- It adds `/usr/bin/invoice-desk`, a desktop file and an icon.
- It is prebuilt: no `%build`, no debuginfo, no strip, and automatic requires/provides disabled except `gtk3`.
- `%post` and `%postun` refresh the desktop and icon caches.
- The data folder in the user's home is never touched by install or remove.

## Consequences

- Simple, predictable layout, and `dnf remove` is clean.
- rpmlint reports `dir-or-file-in-opt` and some library naming notes; these are accepted and expected for a vendor bundle.
