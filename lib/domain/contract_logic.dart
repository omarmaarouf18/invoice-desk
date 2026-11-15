import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/models.dart';

// ── Variables ─────────────────────────────────────────────────────────────

/// `{{name}}` with optional inner spaces; names are letters, digits, `_`
/// and `.`.
final variablePattern = RegExp(r'\{\{\s*([A-Za-z_][A-Za-z0-9_.]*)\s*\}\}');

/// Names filled from settings, the client, the contract and annex 2.
const builtInVariables = <String>[
  'provider.name',
  'provider.legalName',
  'provider.id',
  'provider.address',
  'provider.email',
  'provider.phone',
  'client.name',
  'client.legalName',
  'client.registryNo',
  'client.address',
  'client.representative',
  'client.representativeTitle',
  'client.email',
  'client.phone',
  'contract.number',
  'contract.date',
  'contract.title',
  'project.name',
  'project.summary',
  'total',
  'currency',
  'jurisdiction',
];

/// True for names filled from settings, the client, the contract or
/// annex 2; everything else is a per-contract variable.
bool isBuiltInVariable(String name) => builtInVariables.contains(name);

/// Variable names in [text], in order of first appearance.
List<String> variablesIn(String text) {
  final seen = <String>{};
  return [
    for (final m in variablePattern.allMatches(text))
      if (seen.add(m.group(1)!)) m.group(1)!,
  ];
}

/// Every text of the document that prints: preamble, enabled clauses
/// (titles and bodies) and the closing line.
Iterable<String> printedTexts(Contract c) sync* {
  yield c.preamble;
  for (final cl in c.clauses) {
    if (!cl.enabled) continue;
    yield cl.title;
    yield cl.body;
  }
  yield c.closing;
}

/// Variables used by what prints, in document order.
List<String> usedVariables(Contract c) {
  final seen = <String>{};
  return [
    for (final t in printedTexts(c))
      for (final v in variablesIn(t))
        if (seen.add(v)) v,
  ];
}

/// The custom (per-contract) variables the panel lists.
List<String> customVariablesUsed(Contract c) =>
    usedVariables(c).where((v) => !isBuiltInVariable(v)).toList();

/// Arabic currency names for `{{currency}}` and `{{total}}`.
String currencyNameAr(Currency c) => switch (c) {
  Currency.egp => 'جنيه مصري',
  Currency.usd => 'دولار أمريكي',
  Currency.sar => 'ريال سعودي',
  Currency.aed => 'درهم إماراتي',
  Currency.eur => 'يورو',
};

/// `180,000 جنيه مصري`.
String formatContractMoney(int minor, Currency c) =>
    '${formatAmount(minor, c)} ${currencyNameAr(c)}';

/// Resolves variable names against one contract. Empty values count as
/// missing. Never stored: the stored text keeps its `{{…}}`.
class VariableResolver {
  /// Resolves against [contract], its [client] (null if missing) and the
  /// provider [settings].
  VariableResolver({
    required this.contract,
    required this.client,
    required this.settings,
  });

  /// Source of `contract.*`, `project.*`, `total`, `currency`,
  /// `jurisdiction` and the custom variables.
  final Contract contract;

  /// Source of `client.*`; null resolves all of them as missing.
  final Client? client;

  /// Source of `provider.*`.
  final Settings settings;

  /// The value, or null when unknown or empty.
  String? resolve(String name) {
    final c = contract;
    final cl = client;
    final s = settings;
    final v = switch (name) {
      'provider.name' => s.name,
      'provider.legalName' => s.legalName.trim().isEmpty ? s.name : s.legalName,
      'provider.id' => s.nationalIdOrRegistry,
      'provider.address' => s.address,
      'provider.email' => s.email,
      'provider.phone' => s.phone,
      'client.name' => cl?.name,
      'client.legalName' =>
        (cl?.legalName.trim().isEmpty ?? true) ? cl?.name : cl!.legalName,
      'client.registryNo' => cl?.registryNo,
      'client.address' => cl?.address,
      'client.representative' => cl?.representative,
      'client.representativeTitle' => cl?.representativeTitle,
      'client.email' => cl?.email,
      'client.phone' => cl?.phone,
      'contract.number' => c.number,
      'contract.date' => formatArabicDate(c.issueDate),
      'contract.title' => c.title,
      'project.name' => c.projectName,
      'project.summary' => c.projectSummary,
      'total' =>
        c.totalMinor == 0 ? '' : formatContractMoney(c.totalMinor, c.currency),
      'currency' => currencyNameAr(c.currency),
      'jurisdiction' => c.jurisdiction,
      _ => c.vars[name],
    };
    final trimmed = v?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  /// Used variables that have no value, in document order.
  List<String> missing() =>
      usedVariables(contract).where((v) => resolve(v) == null).toList();

  /// Splits [text] into literal and variable segments.
  List<TextSegment> segments(String text) {
    final out = <TextSegment>[];
    var at = 0;
    for (final m in variablePattern.allMatches(text)) {
      if (m.start > at) out.add(TextSegment(text.substring(at, m.start)));
      final name = m.group(1)!;
      final value = resolve(name);
      out.add(
        TextSegment(
          value ?? '{{$name}}',
          variable: name,
          missing: value == null,
        ),
      );
      at = m.end;
    }
    if (at < text.length) out.add(TextSegment(text.substring(at)));
    return out;
  }

  /// Plain resolved text (missing variables stay as `{{name}}`).
  String resolveText(String text) => segments(text).map((s) => s.text).join();
}

/// A run of resolved text, for rendering with highlights.
class TextSegment {
  /// [text] is literal text, or a variable's value (its `{{name}}` when
  /// [missing]).
  const TextSegment(this.text, {this.variable, this.missing = false});

  /// What to print.
  final String text;

  /// Set when this segment came from `{{variable}}`.
  final String? variable;

  /// The variable had no value; render highlighted.
  final bool missing;
}

// ── Clause bodies ─────────────────────────────────────────────────────────

/// A body block: a paragraph, or a run of numbered sub-items (lines that
/// start with `- `).
sealed class BodyBlock {
  const BodyBlock();
}

/// Consecutive non-bullet lines, joined with spaces.
class ParagraphBlock extends BodyBlock {
  /// A paragraph of [text].
  const ParagraphBlock(this.text);

  /// The paragraph, still with its `{{variables}}`.
  final String text;
}

/// Consecutive `- ` lines, numbered from 1 in the PDF.
class SubItemsBlock extends BodyBlock {
  /// Sub-items without their `- ` markers.
  const SubItemsBlock(this.items);

  /// One entry per sub-item, in order.
  final List<String> items;
}

final _bullet = RegExp(r'^\s*[-–•]\s+');

/// Splits a clause body into paragraphs and sub-item runs; blank lines
/// end either.
List<BodyBlock> parseBody(String body) {
  final out = <BodyBlock>[];
  final para = <String>[];
  final items = <String>[];
  void flushPara() {
    if (para.isNotEmpty) out.add(ParagraphBlock(para.join(' ')));
    para.clear();
  }

  void flushItems() {
    if (items.isNotEmpty) out.add(SubItemsBlock([...items]));
    items.clear();
  }

  for (final raw in body.split('\n')) {
    final line = raw.trim();
    if (line.isEmpty) {
      flushPara();
      flushItems();
    } else if (_bullet.hasMatch(raw)) {
      flushPara();
      items.add(raw.replaceFirst(_bullet, '').trim());
    } else {
      flushItems();
      para.add(line);
    }
  }
  flushPara();
  flushItems();
  return out;
}

// ── Numbers and ordinals ─────────────────────────────────────────────────

const _units = [
  'الأول',
  'الثاني',
  'الثالث',
  'الرابع',
  'الخامس',
  'السادس',
  'السابع',
  'الثامن',
  'التاسع',
];

/// `الأول` … `الثلاثون` for clause headings; digits beyond 30.
String arabicOrdinal(int n) {
  if (n < 1) return '$n';
  if (n <= 9) return _units[n - 1];
  if (n == 10) return 'العاشر';
  if (n == 11) return 'الحادي عشر';
  if (n < 20) return '${_units[n - 11]} عشر';
  if (n == 20) return 'العشرون';
  if (n == 30) return 'الثلاثون';
  if (n < 30) {
    final unit = n - 20 == 1 ? 'الحادي' : _units[n - 21];
    return '$unit والعشرون';
  }
  return '$n';
}

/// `12` → `١٢`.
String arabicIndicDigits(String s) => s.replaceAllMapped(
  RegExp('[0-9]'),
  (m) => String.fromCharCode(0x0660 + int.parse(m.group(0)!)),
);

/// Sub-item label: `١.` or `1.`.
String subItemLabel(int n, {required bool western}) =>
    western ? '$n.' : '${arabicIndicDigits('$n')}.';

/// `CT-2026-0003`, `CT-2026-0003-A1`.
String formatContractNumber(
  String prefix,
  int year,
  int seq, {
  int amendmentNo = 0,
}) {
  final base = '$prefix-$year-${seq.toString().padLeft(4, '0')}';
  return amendmentNo == 0 ? base : '$base-A$amendmentNo';
}

// ── Milestones ────────────────────────────────────────────────────────────

/// Amounts per milestone. Fixed amounts are taken as is; percentage
/// milestones share `total × Σbp / 10000` (rounded half-up) by largest
/// remainder, so 100% always adds up to the total exactly.
List<int> milestoneAmounts(int totalMinor, List<PaymentMilestone> ms) {
  final out = List<int>.filled(ms.length, 0);
  final pct = <int>[];
  var sumBp = 0;
  for (final (i, m) in ms.indexed) {
    if (m.amountMinor != null) {
      out[i] = m.amountMinor!;
    } else if (m.percentBp != null) {
      pct.add(i);
      sumBp += m.percentBp!;
    }
  }
  if (pct.isEmpty) return out;
  final target = applyBasisPoints(totalMinor, sumBp);
  final remainders = <(int, int)>[];
  var allocated = 0;
  for (final i in pct) {
    final exact = totalMinor * ms[i].percentBp!;
    out[i] = exact ~/ 10000;
    allocated += out[i];
    remainders.add((i, exact % 10000));
  }
  // Stable: bigger remainder first, then earlier milestone.
  remainders.sort((a, b) {
    final d = b.$2.compareTo(a.$2);
    return d != 0 ? d : a.$1.compareTo(b.$1);
  });
  for (var k = 0; k < target - allocated; k++) {
    out[remainders[k % remainders.length].$1]++;
  }
  return out;
}

/// What the payments card warns about.
class MilestoneCheck {
  /// Built by [checkMilestones].
  const MilestoneCheck({
    required this.amounts,
    required this.sum,
    required this.total,
    required this.percentSumBp,
  });

  /// Per milestone, in minor units, same order as the contract's.
  final List<int> amounts;

  /// Sum of [amounts].
  final int sum;

  /// The contract total, in minor units.
  final int total;

  /// Σ percentages of the percentage milestones only.
  final int percentSumBp;

  /// What the milestones are short of the total (negative when over).
  int get difference => total - sum;

  /// Milestones add up to the total exactly.
  bool get balanced => sum == total;
}

/// Amounts and sums for the payment annex's live check.
MilestoneCheck checkMilestones(Contract c) {
  final amounts = milestoneAmounts(c.totalMinor, c.milestones);
  return MilestoneCheck(
    amounts: amounts,
    sum: amounts.fold(0, (a, b) => a + b),
    total: c.totalMinor,
    percentSumBp: c.milestones
        .where((m) => m.amountMinor == null)
        .fold(0, (a, m) => a + (m.percentBp ?? 0)),
  );
}

// ── Validation ────────────────────────────────────────────────────────────

/// Why a contract can't be saved yet.
enum ContractIssue {
  /// No client picked.
  missingClient,

  /// The number is blank.
  emptyNumber,

  /// Another contract (deleted included) has this number.
  duplicateNumber,
}

/// Problems that block saving: no client, no number, or a number another
/// contract already uses ([numberTaken], looked up by the caller).
Set<ContractIssue> validateContract(
  Contract c, {
  required bool numberTaken,
}) => {
  if (c.clientId.isEmpty) ContractIssue.missingClient,
  if (c.number.trim().isEmpty)
    ContractIssue.emptyNumber
  else if (numberTaken)
    ContractIssue.duplicateNumber,
};

// ── Diff (restore from library) ──────────────────────────────────────────

/// A line's fate in [lineDiff].
enum DiffOp {
  /// In both texts.
  same,

  /// Only in the old text.
  removed,

  /// Only in the new text.
  added,
}

/// Line-level diff (LCS), for the "restore from library" dialog.
List<(DiffOp, String)> lineDiff(String before, String after) {
  final a = before.split('\n');
  final b = after.split('\n');
  final n = a.length;
  final m = b.length;
  final lcs = List.generate(n + 1, (_) => List<int>.filled(m + 1, 0));
  for (var i = n - 1; i >= 0; i--) {
    for (var j = m - 1; j >= 0; j--) {
      lcs[i][j] = a[i] == b[j]
          ? lcs[i + 1][j + 1] + 1
          : (lcs[i + 1][j] > lcs[i][j + 1] ? lcs[i + 1][j] : lcs[i][j + 1]);
    }
  }
  final out = <(DiffOp, String)>[];
  var i = 0;
  var j = 0;
  while (i < n && j < m) {
    if (a[i] == b[j]) {
      out.add((DiffOp.same, a[i]));
      i++;
      j++;
    } else if (lcs[i + 1][j] >= lcs[i][j + 1]) {
      out.add((DiffOp.removed, a[i++]));
    } else {
      out.add((DiffOp.added, b[j++]));
    }
  }
  while (i < n) {
    out.add((DiffOp.removed, a[i++]));
  }
  while (j < m) {
    out.add((DiffOp.added, b[j++]));
  }
  return out;
}

/// Snapshot of a library template into new contract clauses.
List<ContractClause> clausesFromTemplate(
  ClauseTemplate t,
  String Function() newId,
) => [
  for (final lc in t.clauses)
    ContractClause(
      id: newId(),
      title: lc.title,
      body: lc.body,
      enabled: lc.enabledByDefault,
      optional: lc.optional,
      fromLibraryClauseId: lc.id,
    ),
];

/// Deep copy with fresh ids (duplicate, amendment).
Contract cloneContractParts(Contract c, String Function() newId) => c.copyWith(
  clauses: [for (final x in c.clauses) x.copyWith(id: newId())],
  scope: [for (final x in c.scope) x.copyWith(id: newId())],
  milestones: [
    for (final x in c.milestones)
      x.copyWith(id: newId(), invoiceId: () => null),
  ],
);
