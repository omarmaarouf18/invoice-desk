// The Arabic invoice labels are printed on Arabic documents (Phase 3), so
// their wording is locked here: a typo would only show up in a PDF.

import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/pdf/labels.dart';

void main() {
  group('Arabic invoice labels', () {
    test('attn and pleaseQuote name the invoice number', () {
      expect(DocLabels.ar.attn('Acme Studio'), 'لعناية: Acme Studio');
      expect(
        DocLabels.ar.pleaseQuote('SS-2026-0001'),
        'يُرجى ذكر رقم الفاتورة عند الدفع: SS-2026-0001',
      );
    });

    test('amountsIn spells the currency out', () {
      expect(DocLabels.ar.amountsIn(Currency.egp), 'المبالغ بالجنيه المصري');
      expect(DocLabels.ar.amountsIn(Currency.usd), 'المبالغ بالدولار الأمريكي');
      expect(DocLabels.ar.amountsIn(Currency.eur), 'المبالغ باليورو');
    });

    test('table and totals labels', () {
      expect(DocLabels.ar.billing, 'التكرار');
      expect(DocLabels.ar.subtotal, 'المجموع الفرعي');
      expect(DocLabels.ar.vatNotApplicable, 'غير مطبَّقة');
    });

    test('payment card labels', () {
      expect(DocLabels.ar.wallet, 'محفظة إلكترونية');
      expect(DocLabels.ar.bankIban, 'حساب بنكي (IBAN)');
    });
  });

  group('English invoice labels', () {
    test('amountsIn keeps the ISO code', () {
      expect(DocLabels.en.amountsIn(Currency.egp), 'Amounts in EGP');
      expect(DocLabels.en.amountsIn(Currency.eur), 'Amounts in EUR');
    });
  });
}
