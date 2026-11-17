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

- Apply two targeted fixes in `third_party/pdf/rtl-advance-width.patch`:
  1. Add `_Span.advanceWidth` (the pen advance for words, `width` otherwise) and mirror RTL words with it, for both `TextAlign.justify` and the other alignments.
  2. Preserve `TextSpan` trees during pre-processing so bidi processing has full paragraph context (fixing unmirrored parentheses `(` and `)`), and handle font fallback at the word level via `_WordRun` so LTR tokens inside RTL lines are not reversed by `_Line.realign`.
- Go back to the font's normal word spacing (`wordSpacing` default) in the invoice and contract builders.
- Guard it:
  - `test/pdf/rtl_word_gap_test.dart` reads word positions and glyph widths back out of the PDF. It checks that every gap after ر/ز/و/د is exactly one space, for three weights at 8–26 pt. It fails on the unpatched package.
  - `test/pdf/text_bidi_guard_test.dart` asserts that known LTR tokens ("EGP", "SS-2026-0001", "studio.example.com", "acme-booking.example.com") maintain LTR glyph order and that Arabic parentheses are properly mirrored.
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

The owner decides whether and when to file. The patch fixes two separate bugs, so they go upstream as **two issues**. Only the first one is ready as a PR.

**Issue 1 — title:** RTL text: words are mirrored by ink width instead of advance width, so Arabic words ending in ر/ز/و/د run into the next word

> **Version:** pdf 3.13.1
>
> **What happens:** in a right-to-left `Text`, the space after a word whose last letter is ر، ز، و or د is much narrower than a normal space, often invisible, so words run together. Example with IBM Plex Sans Arabic (any size): `pw.Text('لن تظهر في الفواتير', textDirection: pw.TextDirection.rtl)` renders «تظهرفي».
>
> **Why:** `_Line.realign` (lib/src/widgets/text.dart) mirrors each span with `delta - (span.offset.x + span.width)`. For a `_Word`, `width` is `metrics.width = right - left`, the ink bounding box. Words were advanced with `metrics.advanceWidth` during layout. When a word's leftmost glyph has a negative left side bearing (the tail of a final-form reh/zain), `width > advanceWidth`, so the word is placed too far left and eats the following space. The error is `-(left + rightBearing)` per word, so gaps vary from word to word even when no glyph overhangs.
>
> **Fix:** mirror by the advance. Add `double get advanceWidth => width;` to `_Span`, override it in `_Word` with `metrics.advanceWidth`, and use `span.advanceWidth` in both RTL branches of `realign` (justify and non-justify). LTR layout is unchanged.
>
> **Test:** render an RTL line uncompressed, read each word's `Td` x and its glyph widths from `/W`, and check `x[i] - (x[i+1] + advance[i+1]) == spaceAdvance * fontSize`. It fails before the fix and passes after it.

**PR 1:** the text above, with only the `advanceWidth` hunks of `rtl-advance-width.patch` (the `_Span.advanceWidth` getter and the two `realign` branches) and the gap test added to `pdf/test/`.

**Issue 2 — title:** RTL text with `fontFallback`: per-character fallback spans reverse LTR tokens and stop parentheses from mirroring

> **Version:** pdf 3.13.1
>
> **What happens:** in a right-to-left `Text` whose primary font lacks some glyphs (e.g. Noto Naskh Arabic, which has no Latin letters) and which sets `fontFallback`:
> - a Latin token inside the Arabic line is drawn reversed: "EGP" renders as "PGE", "SS-2026-0001" as "0001-2026-SS";
> - paired parentheses around Arabic text are not mirrored: «(العميل)» renders as «)العميل(».
>
> **Why:** `_preProcessSpans` splits a `TextSpan` into one span per character (`text: [rune]`) at every rune the primary font lacks. Two things go wrong after that:
> - The bidi pass (`logicalToVisual`) then runs on isolated characters. It loses the paragraph context it needs to resolve the run's direction and to mirror paired brackets.
> - `_Line.realign` mirrors every span on an RTL line. A Latin word split across several fallback spans has its spans reversed, so its letters come out in reverse order.
>
> **Fix we use (not upstream-ready as-is):** keep each `TextSpan` whole during pre-processing, and resolve fallback inside the word. `_Word` gets a list of `_WordRun`s (one per font change), laid out left to right within the word, so `realign` moves the word as a unit and never reorders its runs.

**Before a PR 2, the vendored version must be generalised.** It is fitted to this app's two bundled fonts and drops upstream behaviour:
1. It no longer draws emoji bitmaps (`_addEmoji` is unused).
2. It no longer draws the placeholder box for a rune that no font supports (`_addPlaceholder` is unused). The rune falls back to the primary font instead.
3. It routes every ASCII rune (0x20–0x7E) of a word to the first Latin-capable fallback font when the word holds a Latin letter and the primary font has no "A". That rule is a heuristic for Naskh + Plex, not a general one.

A PR 2 would restore 1 and 2 inside `_WordRun` and replace 3 with a per-rune `isRuneSupported` lookup. It would come with a test like `test/pdf/text_bidi_guard_test.dart`: render the line, map glyphs back through `/ToUnicode`, and assert that LTR tokens keep left-to-right order and that brackets are mirrored.
