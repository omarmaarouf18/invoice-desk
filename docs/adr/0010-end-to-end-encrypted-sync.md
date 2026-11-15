# 0010. End-to-end encrypted sync (design)

- Status: **proposed**. Nothing here is implemented; only the data seams exist (ADR 0009).
- Date: 2026-11-15

## Context

The paid subscription syncs a user's data across desktop, mobile and later web. The data is business-sensitive: client names, legal IDs, amounts and contract text. The service should be unable to read it, so that a server breach, a subpoena or an insider exposes only ciphertext. The desktop app stays offline-first (ADR 0008); sync is an add-on.

## Decision

**Client-side encryption only. The server stores ciphertext and opaque ids.**

### Keys

1. **Master key.** The user chooses a sync passphrase, separate from any login password. The client derives a 256-bit **key-encryption key** from it with **Argon2id** (libsodium `crypto_pwhash`, moderate limits, tuned per platform; a per-account random salt is stored on the server). It decrypts the **master key**, a random 256-bit key generated once on the first device and stored on the server only wrapped by the KEK.
2. **Recovery key.** A second wrap of the master key, made with a random high-entropy **recovery key** that is shown **once** at setup to print or save. The server stores this wrap too.
3. **New devices.** A new device downloads the wrapped master key and unwraps it with the passphrase (or the recovery key). Changing the passphrase re-wraps the master key; the data is not re-encrypted.
4. **Record keys.** Per-record keys are derived from the master key with a KDF (`crypto_kdf`, by record type and id), so one compromised record key reveals nothing else.

### Records

- Each syncable row is serialised (versioned JSON), then encrypted with **XChaCha20-Poly1305** (libsodium `crypto_aead_xchacha20poly1305_ietf`), with a random 192-bit nonce per write.
- The associated data binds the ciphertext to its envelope: `{entity, rowId, rev, deviceId, schema}`. A server can't move a ciphertext to another record or roll it back silently.
- What the server sees per record:
  - an opaque `rowId` (the row's UUID, which carries no meaning);
  - the entity type, possibly also blinded if needed;
  - `rev` and `updatedAt`;
  - the ciphertext.
- The server **never** sees client names, amounts, numbers, clause text or any field value.
- Attachments (future) use the same scheme, as chunked streams (`crypto_secretstream`).

### Sync and conflicts

- The device pushes outbox entries (entity, rowId, rev) as encrypted records and pulls records newer than its cursor.
- **Conflict rule: last writer wins per record**, by `(updatedAt, deviceId)`. The later `updatedAt` wins, and `deviceId` breaks ties deterministically.
- **Signed contracts are immutable.** Once a record says signed (or later), any incoming change to it that isn't an unlock event in the history is rejected and logged as a conflict. Amendments are separate records, so they sync normally.
- Tombstones (`deletedAt`) sync like any other change. Local purge keeps a tombstone until it has been pushed at least once.

## Consequences

- A server breach exposes metadata only: record counts, sizes, timestamps, opaque ids. Not business data.
- **If the user loses both the passphrase and the recovery key, the cloud copy is unrecoverable.** Nobody can decrypt it, including us. Local data on their devices is unaffected and can seed a fresh sync account. The setup UI must say this plainly and insist on saving the recovery key.
- No server-side search, reporting or web preview of contents. A web client would decrypt in the browser.
- Last-writer-wins can drop a concurrent edit to the same record. That is acceptable for invoice-sized records edited by one person on several devices; signed contracts are protected by immutability.
- Cryptography comes from libsodium (via a maintained Dart binding) and is not written by hand. The design needs an external review before implementation.
