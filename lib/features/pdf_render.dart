import 'dart:typed_data';

import 'package:invoice_desk/data/repositories/style_repository.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/issue_snapshot.dart';
import 'package:invoice_desk/pdf/contract_pdf.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';
import 'package:invoice_desk/pdf/pdf_style.dart';

// The one place the UI turns a document into PDF bytes, so the live
// previews and the exports always print the same look.

/// [look] as the builders read it.
PdfStyle pdfStyleOf(ResolvedLook look) =>
    PdfStyle.fromDocumentStyle(look.style, logoBytes: look.logo);

/// [data] as it was printed when the invoice was committed: settings and
/// client overlaid with [issueSnapshot] (ADR-0014). Without a snapshot
/// (a draft, or a document committed before v8) [data] is returned as is.
InvoicePdfData frozenInvoiceData(InvoicePdfData data, String? issueSnapshot) {
  final snap = IssueSnapshot.tryParse(issueSnapshot);
  if (snap == null) return data;
  return InvoicePdfData(
    invoice: data.invoice,
    client: snap.applyToClient(data.client, id: data.invoice.clientId),
    settings: snap.applyTo(data.settings),
  );
}

/// [data] as it was printed when the contract was committed.
ContractPdfData frozenContractData(
  ContractPdfData data,
  String? issueSnapshot,
) {
  final snap = IssueSnapshot.tryParse(issueSnapshot);
  if (snap == null) return data;
  return ContractPdfData(
    contract: data.contract,
    client: snap.applyToClient(data.client, id: data.contract.clientId),
    settings: snap.applyTo(data.settings),
    parent: data.parent,
    language: data.language,
  );
}

/// The invoice in [data] with its resolved look (snapshot, document,
/// client, default, Classic).
Future<Uint8List> renderInvoicePdf(
  StyleRepository styles,
  InvoicePdfData data,
  PdfFonts fonts,
) async {
  final look = await styles.lookForInvoice(data.invoice);
  return buildInvoicePdf(
    frozenInvoiceData(data, look.issueSnapshot),
    fonts,
    style: pdfStyleOf(look),
  );
}

/// The contract in [data] with its resolved look.
Future<Uint8List> renderContractPdf(
  StyleRepository styles,
  ContractPdfData data,
  PdfFonts fonts,
) async {
  final look = await styles.lookForContract(data.contract);
  return buildContractPdf(
    frozenContractData(data, look.issueSnapshot),
    fonts,
    style: pdfStyleOf(look),
  );
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
