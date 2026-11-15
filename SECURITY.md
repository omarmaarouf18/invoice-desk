# Security

## Reporting a vulnerability

Please report security problems privately, through GitHub's private vulnerability reporting ("Report a vulnerability" on the repository's Security tab), not in a public issue. Include steps to reproduce and the version (Settings → حول البرنامج). You'll get an acknowledgement within a week.

## What the app stores

Everything is in the data folder: on Linux, `~/.local/share/me.omarmaarouf.invoice_desk/`, or `INVOICE_DESK_DATA_DIR` if set.

- **`invoice_desk.sqlite`:**
  - your profile: name, legal name, ID or registry number, address, email, phone, payment details (InstaPay, wallet, IBAN);
  - clients, with their legal details;
  - invoices, contracts and the clause library;
  - a random device id, used later for sync conflict resolution.
- **`ui_state.json`:** window size, theme, last opened document, last export folder.
- **`backups/`:** full copies of the database: daily, plus before risky deletes and restores.

The files are not encrypted at rest. Protect them like any other business records, with disk encryption and file permissions. Exported PDFs and CSVs go wherever you save them.

## What leaves the machine

**Nothing, today.** The app has no network code: no telemetry, no update checks, no accounts. Links you click (for example "open folder") are handed to your desktop.

## Future sync

A future, optional subscription will sync data across devices. It is designed to be **end-to-end encrypted** ([ADR 0010](docs/adr/0010-end-to-end-encrypted-sync.md), proposed):

- data is encrypted on the device with keys derived from your passphrase;
- the server stores only ciphertext and opaque ids, never client names, amounts or text;
- if you lose both your passphrase and your recovery key, nobody can recover the cloud copy. Your local data is unaffected.

The desktop app never requires an account, and sync never gates local features.

## Supply chain

- Dependencies are pinned in `pubspec.lock`. Dependabot proposes grouped weekly updates.
- CI runs `gitleaks` (secrets), `osv-scanner` (known vulnerabilities in `pubspec.lock`), and a licence report that fails on GPL/AGPL in shipped dependencies.
- GitHub Actions are pinned to full commit SHAs.
