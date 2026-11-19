# 0015. GPL-3.0-or-later licence

- Status: accepted
- Date: 2026-11-19

## Context

The repository was public with no licence (ADR-0009 left the choice to the owner), so nobody had permission to reuse or modify the code, and the packages declared `LicenseRef-Proprietary`. Open-source signing services such as SignPath need an OSI-approved licence (`docs/RELEASING.md`).

## Decision

- The owner licenses Invoice Desk under the **GNU General Public License, version 3 or (at the user's option) any later version** (SPDX `GPL-3.0-or-later`). The full text is `LICENSE` at the repository root.
- Packages declare it: RPM `License: GPL-3.0-or-later AND OFL-1.1`, Arch `license=('GPL-3.0-or-later' 'OFL-1.1')`, Debian `copyright` `License: GPL-3+`. The Linux packages ship `LICENSE` and `COPYRIGHT.txt`.
- The bundled fonts stay under OFL-1.1, shipped next to them.

## Consequences

- Anyone may use, modify and redistribute the app; modified versions they distribute must stay GPL and come with their source.
- ADR-0009's business model is unchanged: the desktop app is free, the paid value is the sync service.
- Dependencies must stay GPL-3.0-compatible (MIT, BSD, Apache-2.0, OFL fonts and the like are). `tool/check_licenses.dart` still fails on GPL/AGPL dependencies; that rule was written for a proprietary app and can be relaxed, but nothing needs it today.
- Releases up to 0.5.0 were published without a licence; from the next release the packages carry it.
- Follow-up: the Windows installer/zip and the macOS dmg don't ship `LICENSE` yet; the release page links the source, which includes it.
