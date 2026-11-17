# Vendored `pdf` 3.13.1 (patched)

This is an unmodified copy of [`pdf`](https://pub.dev/packages/pdf) **3.13.1**
(`lib/`, `LICENSE`, `pubspec.yaml`; Apache-2.0, © David PHAM-VAN), plus one
patch: [`rtl-advance-width.patch`](rtl-advance-width.patch). The app resolves
it through `dependency_overrides` in the root `pubspec.yaml`. Why: [ADR-0013](../../docs/adr/0013-vendored-pdf-rtl-fix.md).

## What the patch fixes

1. **RTL word spacing (advance width):**
   When `RichText` lays out a right-to-left line, `_Line.realign` mirrors each
   word with `delta - (x + span.width)`. `span.width` is the word's ink bounding
   box (`right - left`), not its pen advance. Final-form ر/ز have a negative
   left bearing (their tail overhangs), so those words are pushed into the next
   space and Arabic words visibly run together («وتطويرالتطبيق», «يجوزسداد»).
   The patch adds `_Span.advanceWidth` (defaults to `width`; `_Word` returns
   `metrics.advanceWidth`) and mirrors with the advance instead. Nothing changes
   for left-to-right text or for widget spans.

2. **RTL bidi and font fallback word preservation:**
   Upstream `_preProcessSpans` split text character-by-character (`text: [rune]`)
   into individual 1-character spans whenever a rune required a fallback font.
   In RTL context, this broke text rendering in two ways:
   - Isolating characters before `logicalToVisual` stripped paragraph context,
     preventing Unicode Bidi mirroring of paired parentheses `(` and `)`.
   - `_Line.realign` mirrors all spans on an RTL line; when an LTR token (e.g.
     "EGP", "studio.example.com", "SS-2026-0001") was split across font spans,
     `realign` reversed the spans, rendering reversed tokens (e.g. "PGE").
   The patch keeps `TextSpan` trees intact during pre-processing so bidi
   layout processes entire strings, and handles font fallback within `_Word`
   via composite `_WordRun`s. Each word's internal glyph runs advance
   strictly left-to-right without being reversed by line-level span realign.

   **Trade-off:** this part is fitted to the two bundled fonts. It drops
   upstream's emoji bitmaps (`_addEmoji` is unused) and the placeholder box
   for a rune no font supports (`_addPlaceholder` is unused). It also sends
   every ASCII rune of a Latin-bearing word to the first Latin-capable
   fallback when the primary font has no "A". None of this matters for
   Invoice Desk's documents. ADR-0013 lists what an upstream PR would need.

`test/pdf/rtl_word_gap_test.dart` measures the gaps and fails without the
patch. `test/pdf/text_bidi_guard_test.dart` verifies LTR token order and
Arabic parenthesis mirroring. `test/architecture/vendored_pdf_test.dart`
fails if the resolved `pdf` is not this copy, or if the patch is missing.

## Re-applying on an upgrade

Only upgrade if upstream has not fixed the bug (then drop this folder, see
ADR-0013).

```bash
flutter pub cache add pdf --version <NEW>
```

```bash
rm -rf third_party/pdf/lib && cp -r ~/.pub-cache/hosted/pub.dev/pdf-<NEW>/{lib,LICENSE,pubspec.yaml} third_party/pdf/
```

```bash
cd third_party/pdf && patch -p1 < rtl-advance-width.patch
```

Then update the pinned `pdf:` version in the root `pubspec.yaml` and the
expected version in `test/architecture/vendored_pdf_test.dart`, run
`flutter pub get`, and run `./scripts/ci_local.sh`.
