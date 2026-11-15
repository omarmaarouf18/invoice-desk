# 0001. Flutter for a desktop-first app

- Status: accepted
- Date: 2026-11-15

## Context

The app is used daily on a Linux desktop. Later it should run on Windows and macOS, and the sync subscription will need mobile companions. The UI is Arabic RTL with bilingual PDFs, a dense editor and keyboard shortcuts. One developer maintains it.

## Decision

Build with Flutter (Material 3) for desktop first, using one codebase for Linux, Windows and macOS. Mobile can reuse the domain, data and PDF layers later.

## Consequences

- One language (Dart) for the UI, the business rules, the PDF generation and the tests (unit, widget, golden).
- RTL, Arabic shaping and theming are first class. Golden tests catch visual regressions.
- Native packaging per platform is our job (see ADRs 0006 and 0007). Bundles are larger than a native GTK app's (about 37 MB installed).
- Desktop plugins (window manager, file dialogs, printing) are third-party and pinned.
