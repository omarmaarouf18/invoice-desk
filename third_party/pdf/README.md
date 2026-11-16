# Vendored `pdf` 3.13.1 (patched)

This is an unmodified copy of [`pdf`](https://pub.dev/packages/pdf) **3.13.1**
(`lib/`, `LICENSE`, `pubspec.yaml`; Apache-2.0, © David PHAM-VAN), plus one
patch: [`rtl-advance-width.patch`](rtl-advance-width.patch). The app resolves
it through `dependency_overrides` in the root `pubspec.yaml`. Why: [ADR-0013](../../docs/adr/0013-vendored-pdf-rtl-fix.md).

## What the patch fixes

When `RichText` lays out a right-to-left line, `_Line.realign` mirrors each
word with `delta - (x + span.width)`. `span.width` is the word's ink bounding
box (`right - left`), not its pen advance. Final-form ر/ز have a negative
left bearing (their tail overhangs), so those words are pushed into the next
space and Arabic words visibly run together («وتطويرالتطبيق», «يجوزسداد»).

The patch adds `_Span.advanceWidth` (defaults to `width`; `_Word` returns
`metrics.advanceWidth`) and mirrors with the advance instead. Nothing changes
for left-to-right text or for widget spans.

`test/pdf/rtl_word_gap_test.dart` measures the gaps and fails without the
patch. `test/architecture/vendored_pdf_test.dart` fails if the resolved
`pdf` is not this copy, or if the patch is missing.

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
