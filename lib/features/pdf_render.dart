import 'dart:typed_data';

import 'package:invoice_desk/data/repositories/style_repository.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/pdf/contract_pdf.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';
import 'package:invoice_desk/pdf/pdf_style.dart';

// The one place the UI turns a document into PDF bytes, so the live
// previews and the exports always print the same look.

/// [look] as the builders read it.
PdfStyle pdfStyleOf(ResolvedLook look) =>
    PdfStyle.fromDocumentStyle(look.style, logoBytes: look.logo);

/// The invoice in [data] with its resolved look (snapshot, document,
/// client, default, Classic).
Future<Uint8List> renderInvoicePdf(
  StyleRepository styles,
  InvoicePdfData data,
  PdfFonts fonts,
) async {
  final look = await styles.lookForInvoice(data.invoice);
  return buildInvoicePdf(data, fonts, style: pdfStyleOf(look));
}

/// The contract in [data] with its resolved look.
Future<Uint8List> renderContractPdf(
  StyleRepository styles,
  ContractPdfData data,
  PdfFonts fonts,
) async {
  final look = await styles.lookForContract(data.contract);
  return buildContractPdf(data, fonts, style: pdfStyleOf(look));
}

/// [data] drawn in [style], whatever the document's own style is (the
/// style editor's preview).
Future<Uint8List> renderInvoiceInStyle(
  StyleRepository styles,
  InvoicePdfData data,
  PdfFonts fonts,
  DocumentStyle style,
) async => buildInvoicePdf(
  data,
  fonts,
  style: pdfStyleOf(await styles.lookForStyle(style)),
);

/// [data] drawn in [style] (the style editor's contract preview).
Future<Uint8List> renderContractInStyle(
  StyleRepository styles,
  ContractPdfData data,
  PdfFonts fonts,
  DocumentStyle style,
) async => buildContractPdf(
  data,
  fonts,
  style: pdfStyleOf(await styles.lookForStyle(style)),
);
