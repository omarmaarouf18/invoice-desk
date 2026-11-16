# 0013. Vendor the pdf package with an RTL word-placement fix

- Status: accepted
- Date: 2026-11-16

## Context

Arabic words in exported PDFs ran together after ر، ز، و and د («وتطويرالتطبيق», «يجوزسداد»). A `wordSpacing: 2` workaround widened every gap. That made Arabic gaps uneven and English gaps twice too wide, and it still left some Arabic words touching.

The cause is in `pdf` 3.13.1, the latest release. When `RichText` lays out a right-to-left line, `_Line.realign` mirrors each word to `delta - (x + span.width)`. `span.width` is the word's ink bounding box (`right - left`), not its pen advance. A final-form ر or ز overhangs to the left (left bearing ≈ −0.06 em in IBM Plex Sans Arabic). Those words are mirrored too far left, and the gap after them shrinks to almost nothing (0.236 em → ≈0.04 em after «تظهر»). Left-to-right text uses the advance and is not affected.

Nothing in our own code can work around it:
- The bundled fonts have no zero-width glyph (ZWJ, ZWNJ, ZWSP, FSI/PDI) to pad words with.
- The package's Arabic shaper is private.

Writing our own RTL paragraph widget would mean porting the shaper and a line breaker (about 600 lines), and the contract body's mixed styles would make it harder.

## Decision

- Vendor `pdf` 3.13.1 unchanged in `third_party/pdf` (`lib/`, `LICENSE`, `pubspec.yaml`; Apache-2.0) and resolve it through `dependency_overrides`. Pin `pdf: 3.13.1` in `dependencies`.
- Apply one patch, kept as `third_party/pdf/rtl-advance-width.patch`: add `_Span.advanceWidth` (the pen advance for words, `width` otherwise) and mirror RTL words with it, for both `TextAlign.justify` and the other alignments.
- Go back to the font's normal word spacing (`wordSpacing` default) in the invoice and contract builders.
- Guard it:
  - `test/pdf/rtl_word_gap_test.dart` reads word positions and glyph widths back out of the PDF. It checks that every gap after ر/ز/و/د is exactly one space, for three weights at 8–26 pt. It fails on the unpatched package.
  - `test/architecture/vendored_pdf_test.dart` fails if `pubspec.lock` resolves `pdf` from anywhere else, if the vendored version, the pin and the override disagree, or if a patch line is missing.
  - PDF content goldens (`test/pdf/goldens/`) lock the full layout.
- `third_party/` is excluded from analysis. Coverage and the size check only look at `lib/`.

No new dependency is added, and nothing changes at runtime except where words are placed.

## Consequences

- Re-exported invoices and contracts get even Arabic word gaps and normal English word gaps. PDFs that were already exported don't change.
- Upgrading `pdf` is a manual step: copy the new release, re-apply the patch, and update the pin and the guard test (see `third_party/pdf/README.md`). Dependabot-style bumps of `pdf` can't happen silently, because the guard test fails.
- `printing` resolves the same patched copy through the override.

### Dropping the fork once upstream merges

1. Bump the pin to the fixed release (`pdf: ^X.Y.Z`).
2. Delete `third_party/pdf`, the `dependency_overrides` entry and `test/architecture/vendored_pdf_test.dart`, then run `flutter pub get`.
3. Keep `rtl_word_gap_test.dart` and the PDF goldens. They must pass unchanged on the upstream release, which proves the upstream fix is the same.
4. Mark this ADR "superseded".

### Upstream report (prepared, not filed)

**Title:** RTL text: words are mirrored by ink width instead of advance width, so Arabic words ending in ر/ز/و/د run into the next word

**Issue body:**

> **Version:** pdf 3.13.1
>
> **What happens:** in a right-to-left `Text`, the space after a word whose last letter is ر، ز، و or د is much narrower than a normal space, often invisible, so words run together. Example with IBM Plex Sans Arabic (any size): `pw.Text('لن تظهر في الفواتير', textDirection: pw.TextDirection.rtl)` renders «تظهرفي».
>
> **Why:** `_Line.realign` (lib/src/widgets/text.dart) mirrors each span with `delta - (span.offset.x + span.width)`. For a `_Word`, `width` is `metrics.width = right - left`, the ink bounding box. Words were advanced with `metrics.advanceWidth` during layout. When a word's leftmost glyph has a negative left side bearing (the tail of a final-form reh/zain), `width > advanceWidth`, so the word is placed too far left and eats the following space. The error is `-(left + rightBearing)` per word, so gaps vary from word to word even when no glyph overhangs.
>
> **Fix:** mirror by the advance. Add `double get advanceWidth => width;` to `_Span`, override it in `_Word` with `metrics.advanceWidth`, and use `span.advanceWidth` in both RTL branches of `realign` (justify and non-justify). LTR layout is unchanged.
>
> **Test:** render an RTL line uncompressed, read each word's `Td` x and its glyph widths from `/W`, and check `x[i] - (x[i+1] + advance[i+1]) == spaceAdvance * fontSize`. It fails before the fix and passes after it.

**PR description:** the same text, with the patch from `third_party/pdf/rtl-advance-width.patch` and the test above added to `pdf/test/`.
