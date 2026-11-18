// dart format off
// coverage:ignore-file

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Invoice Desk';

  @override
  String get sidebarTitle => 'Invoices';

  @override
  String get myProfile => 'My details';

  @override
  String get searchHint => 'Search by client or invoice number';

  @override
  String get newInvoice => 'New invoice';

  @override
  String get newClient => 'New client';

  @override
  String get filterAll => 'All';

  @override
  String get filterUnpaid => 'Unpaid';

  @override
  String get filterOverdue => 'Overdue';

  @override
  String get filterPaid => 'Paid';

  @override
  String get filterDrafts => 'Drafts';

  @override
  String get summaryUnpaid => 'Unpaid';

  @override
  String get summaryOverdue => 'Overdue';

  @override
  String get summaryNothingDue => 'Nothing outstanding';

  @override
  String invoiceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count invoices',
      few: '$count invoices',
      two: '2 invoices',
      one: '1 invoice',
    );
    return '$_temp0';
  }

  @override
  String unpaidCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unpaid',
      few: '$count unpaid',
      two: '2 unpaid',
      one: '1 unpaid',
    );
    return '$_temp0';
  }

  @override
  String noResults(String query) {
    return 'No results for “$query”';
  }

  @override
  String get clearSearch => 'Clear search';

  @override
  String get noInvoicesForClient => 'No matching invoices';

  @override
  String get noClientsYet => 'No clients yet';

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusSent => 'Sent';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusVoid => 'Void';

  @override
  String get menuOpen => 'Open';

  @override
  String get menuDuplicate => 'Duplicate';

  @override
  String get menuRenew => 'Renewal invoice';

  @override
  String get menuMarkPaid => 'Mark as paid';

  @override
  String get menuDelete => 'Delete';

  @override
  String get menuEdit => 'Edit';

  @override
  String get menuArchive => 'Archive';

  @override
  String get menuUnarchive => 'Unarchive';

  @override
  String get archived => 'Archived';

  @override
  String get tabEdit => 'Edit';

  @override
  String get tabPreview => 'Preview';

  @override
  String get save => 'Save';

  @override
  String get exportPdf => 'PDF';

  @override
  String get exportPdfLong => 'Export PDF';

  @override
  String get more => 'More';

  @override
  String get saved => 'Saved';

  @override
  String get saving => 'Saving…';

  @override
  String get unsaved => 'Unsaved changes';

  @override
  String get notSavedFix => 'Not saved — check the fields';

  @override
  String get saveFailed => 'Could not save';

  @override
  String get cardDetails => 'Invoice details';

  @override
  String get client => 'Client';

  @override
  String get chooseClient => 'Choose a client';

  @override
  String get invoiceNumber => 'Invoice number';

  @override
  String get issueDate => 'Issue date';

  @override
  String get dueDate => 'Due date';

  @override
  String get contractRef => 'Contract reference';

  @override
  String get status => 'Status';

  @override
  String get paidDate => 'Payment date';

  @override
  String get cardSections => 'Sections and items';

  @override
  String get sectionTitleEn => 'Section title (EN)';

  @override
  String get sectionTitleAr => 'Section title (AR)';

  @override
  String get currency => 'Currency';

  @override
  String get deleteSection => 'Delete section';

  @override
  String get addSection => 'Add section';

  @override
  String get addItem => 'Add item';

  @override
  String get deleteItem => 'Delete item';

  @override
  String get dragToReorder => 'Drag to reorder';

  @override
  String get colService => 'Service';

  @override
  String get colDescription => 'Description';

  @override
  String get colCycle => 'Cycle';

  @override
  String get colQty => 'Qty';

  @override
  String get colUnitPrice => 'Unit price';

  @override
  String get colLineTotal => 'Total';

  @override
  String get cycleOneTime => 'One-time';

  @override
  String get cycleMonthly => 'Monthly';

  @override
  String get cycleAnnual => 'Annual';

  @override
  String get subtotal => 'Subtotal';

  @override
  String sectionN(int n) {
    return 'Section $n';
  }

  @override
  String get cardTotals => 'Totals and tax';

  @override
  String get vat => 'VAT';

  @override
  String get vatRate => 'Rate %';

  @override
  String get vatLine => 'VAT';

  @override
  String get totalDue => 'Total due';

  @override
  String dueBy(String date) {
    return 'Due by $date';
  }

  @override
  String get cardNotes => 'Notes';

  @override
  String get notesEn => 'Notes in English — one per line';

  @override
  String get notesAr => 'Notes in Arabic — one per line';

  @override
  String get cardScope => 'Project scope page';

  @override
  String get scopeToggle => 'Add a project scope page to the invoice';

  @override
  String get scopeTitle => 'Project title';

  @override
  String get scopeOverview => 'Overview';

  @override
  String get scopeDone => 'What was done — one per line';

  @override
  String get scopeDelivered => 'What the client receives — one per line';

  @override
  String get scopeWarranty => 'Warranty and support';

  @override
  String get errMissingClient => 'Choose a client';

  @override
  String get errEmptyNumber => 'Enter an invoice number';

  @override
  String get errDuplicateNumber => 'This number is used by another invoice';

  @override
  String get errAmount => 'Invalid amount';

  @override
  String get errQty => 'Invalid quantity';

  @override
  String get errRate => 'Invalid rate';

  @override
  String exportedPdf(String name) {
    return 'Saved $name';
  }

  @override
  String get openFile => 'Open file';

  @override
  String get openFolder => 'Open folder';

  @override
  String get exportFailed => 'Could not save the file';

  @override
  String deleted(String number) {
    return 'Deleted $number';
  }

  @override
  String get undo => 'Undo';

  @override
  String renewNone(String number) {
    return '$number has no monthly or annual items to renew';
  }

  @override
  String renewCreated(String number) {
    return 'New renewal invoice: $number';
  }

  @override
  String duplicated(String number) {
    return 'New copy: $number';
  }

  @override
  String markedPaid(String number) {
    return '$number marked as paid';
  }

  @override
  String get nothingOpen => 'Open an invoice first';

  @override
  String get clientDialogNew => 'New client';

  @override
  String get clientDialogEdit => 'Edit client';

  @override
  String get clientName => 'Client name';

  @override
  String get clientContact => 'Contact person';

  @override
  String get clientCity => 'City';

  @override
  String get clientPhone => 'Phone';

  @override
  String get clientEmail => 'Email';

  @override
  String get cancel => 'Cancel';

  @override
  String get errClientName => 'Enter a client name';

  @override
  String get settingsTitle => 'My details';

  @override
  String get settingsSubtitle => 'These details appear on every invoice. They save automatically.';

  @override
  String get back => 'Back';

  @override
  String get profile => 'Profile';

  @override
  String get name => 'Name';

  @override
  String get role => 'Role';

  @override
  String get city => 'City';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get website => 'Website';

  @override
  String get invoicing => 'Numbering and due dates';

  @override
  String get invoicePrefix => 'Number prefix';

  @override
  String get prefixHint => 'Applies to new invoices only';

  @override
  String get defaultDueDays => 'Default due days';

  @override
  String get payment => 'Payment details';

  @override
  String get instapay => 'InstaPay';

  @override
  String get wallet => 'Mobile wallet';

  @override
  String get bankIban => 'Bank / IBAN';

  @override
  String get defaultNotes => 'Default notes';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get backup => 'Backups and export';

  @override
  String get backupDir => 'Backup folder';

  @override
  String get chooseFolder => 'Choose folder…';

  @override
  String get backupNow => 'Back up now';

  @override
  String get restore => 'Restore from a backup';

  @override
  String get exportCsv => 'Export CSV for your accountant';

  @override
  String lastBackup(String date) {
    return 'Last backup: $date';
  }

  @override
  String get never => 'No backup yet';

  @override
  String get backupAuto => 'A backup is taken when you open the app if the last one is over a day old. The last 30 are kept.';

  @override
  String get backupDone => 'Backup saved';

  @override
  String get backupFailed => 'Could not take the backup';

  @override
  String get restoreConfirmTitle => 'Restore this backup?';

  @override
  String restoreConfirmBody(String date, int count, int clients) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count invoices',
      few: '$count invoices',
      two: '2 invoices',
      one: '1 invoice',
    );
    String _temp1 = intl.Intl.pluralLogic(
      clients,
      locale: localeName,
      other: '$count clients',
      few: '$count clients',
      two: '2 clients',
      one: '1 client',
    );
    return 'The backup from $date holds $_temp0 and $_temp1.\nAll current data is replaced by it, and a copy of your current data is saved first.';
  }

  @override
  String get restoreAction => 'Restore';

  @override
  String get restoreDone => 'Restored';

  @override
  String get restoreBad => 'This file is not a valid Invoice Desk backup';

  @override
  String csvDone(String name) {
    return 'Exported $name';
  }

  @override
  String get emptyTitle => 'Welcome to Invoice Desk';

  @override
  String get emptyBody => 'Two steps and your first invoice is ready.';

  @override
  String get stepProfile => 'Add your details';

  @override
  String get stepProfileBody => 'The name and payment details shown on your invoice.';

  @override
  String get stepClient => 'Add your first client';

  @override
  String get stepClientBody => 'A client name and a contact number.';

  @override
  String get stepInvoice => 'Create your first invoice';

  @override
  String get done => 'Done';

  @override
  String get pickInvoice => 'Pick an invoice from the list';

  @override
  String get pickInvoiceBody => 'Or create a new invoice to get started.';

  @override
  String get dbErrorTitle => 'Could not open the database';

  @override
  String get dbErrorBody => 'The file may be damaged or open in another copy of the app. You can restore it from the latest backup.';

  @override
  String get retry => 'Try again';

  @override
  String get previewLoading => 'Preparing the preview…';

  @override
  String get shortcutsHint => 'Shortcuts: Ctrl+N invoice · Ctrl+K search · Ctrl+S save · Ctrl+E PDF';

  @override
  String get about => 'About';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutBody => 'An invoicing app that works offline. Your data stays on this machine.';

  @override
  String get aboutDataDir => 'Data folder';

  @override
  String get notTaxInvoice => 'Not an official electronic tax invoice.';

  @override
  String get menuDeleteClient => 'Delete client';

  @override
  String clientDeleted(String name) {
    return 'Deleted $name';
  }

  @override
  String clientArchivedSnack(String name) {
    return 'Archived $name and its invoices';
  }

  @override
  String clientHasInvoicesTitle(String name) {
    return '$name has invoices';
  }

  @override
  String clientHasInvoicesBody(String invoices, String unpaid) {
    return '$invoices are linked to it, unpaid total: $unpaid.\nArchiving hides the client and its invoices from the list and search without deleting anything, and you can bring them back from the “Archived” filter.';
  }

  @override
  String get archiveRecommended => 'Archive (recommended)';

  @override
  String get deleteClientAndInvoices => 'Delete the client and all its invoices';

  @override
  String confirmDeleteAllTitle(String name) {
    return 'Delete $name and all its invoices?';
  }

  @override
  String confirmDeleteAllBody(String invoices) {
    return '$invoices will be deleted, paid and sent ones included. We take a backup first, and you can undo this for 8 seconds.\nType the client name to confirm:';
  }

  @override
  String clientDeletedWithInvoices(String name, String invoices) {
    return 'Deleted $name and $invoices';
  }

  @override
  String get deleteBackupFailed => 'The backup failed, so nothing was deleted';

  @override
  String get clientDeleteFailed => 'The client could not be deleted';

  @override
  String get newContract => 'New contract';

  @override
  String groupContracts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count',
      one: '1',
    );
    return 'Contracts ($_temp0)';
  }

  @override
  String groupInvoices(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count',
      one: '1',
    );
    return 'Invoices ($_temp0)';
  }

  @override
  String get filterContractsInForce => 'Contracts in force';

  @override
  String contractCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contracts',
      few: '$count contracts',
      two: '2 contracts',
      one: '1 contract',
    );
    return '$_temp0';
  }

  @override
  String get cStatusDraft => 'Draft';

  @override
  String get cStatusSent => 'Sent';

  @override
  String get cStatusSigned => 'Signed';

  @override
  String get cStatusActive => 'Active';

  @override
  String get cStatusCompleted => 'Completed';

  @override
  String get cStatusCancelled => 'Cancelled';

  @override
  String get kindContract => 'Contract';

  @override
  String get kindQuote => 'Quotation';

  @override
  String get kindAmendment => 'Amendment';

  @override
  String get newContractTitle => 'New contract';

  @override
  String get chooseTemplate => 'Choose a template';

  @override
  String clauseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clauses',
      few: '$count clauses',
      two: '2 clauses',
      one: '1 clause',
    );
    return '$_temp0';
  }

  @override
  String get contractTitle => 'Contract title';

  @override
  String get contractTitleHint => 'Example: Building and running a learning platform';

  @override
  String get projectName => 'Project name';

  @override
  String get projectSummary => 'Project summary';

  @override
  String get create => 'Create';

  @override
  String get noTemplates => 'No templates in the library. Add one in Settings → Clause library.';

  @override
  String get cardContractDetails => 'Contract details';

  @override
  String get cardVariables => 'Variables';

  @override
  String get cardClauses => 'Clauses';

  @override
  String get cardScopeAnnex => 'Annex (1): Scope of work';

  @override
  String get cardPaymentAnnex => 'Annex (2): Fees and payments';

  @override
  String get cardLinkedInvoices => 'Linked invoices';

  @override
  String get contractNumber => 'Contract number';

  @override
  String get startDate => 'Start date';

  @override
  String get endDate => 'End date';

  @override
  String get signedDate => 'Signature date';

  @override
  String get jurisdiction => 'Jurisdiction';

  @override
  String get clearDate => 'Clear date';

  @override
  String get preamble => 'Preamble';

  @override
  String get closingLine => 'Closing line';

  @override
  String missingVariables(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count variables are missing',
      few: '$count variables are missing',
      two: 'two variables are missing',
      one: 'one variable is missing',
    );
    return '$_temp0';
  }

  @override
  String get allVariablesFilled => 'All variables are filled in';

  @override
  String get noCustomVariables => 'The enabled clauses use no custom variables.';

  @override
  String builtInMissing(String source) {
    return 'Missing from $source';
  }

  @override
  String get sourceClient => 'the client';

  @override
  String get sourceSettings => 'your details';

  @override
  String get sourceContract => 'the contract';

  @override
  String get editClientData => 'Edit client details';

  @override
  String get openSettings => 'Open settings';

  @override
  String get variablesHelp => 'Type double curly braces inside any clause to insert a variable. The values here apply to this contract only.';

  @override
  String get optionalTag => 'Optional';

  @override
  String get clauseEnabled => 'Enabled';

  @override
  String get clauseTitle => 'Clause title';

  @override
  String get clauseBody => 'Clause text';

  @override
  String get clauseBodyHelp => 'Lines starting with “- ” become numbered sub-items.';

  @override
  String get addClause => 'Clause';

  @override
  String get addBlankClause => 'Blank clause';

  @override
  String get addFromLibrary => 'From the library…';

  @override
  String get restoreFromLibrary => 'Restore the text from the library';

  @override
  String get saveToLibrary => 'Save to the library';

  @override
  String get duplicateClause => 'Duplicate';

  @override
  String get deleteClause => 'Delete clause';

  @override
  String get restoreTitle => 'Restore the library text?';

  @override
  String get restoreBody => 'This clause\'s text in the contract is replaced by the current library copy:';

  @override
  String get restoreConfirm => 'Restore';

  @override
  String get restoreSame => 'The clause text matches the library.';

  @override
  String get restoreMissing => 'The original clause is no longer in the library.';

  @override
  String get saveToLibraryTitle => 'Save this text in the library?';

  @override
  String saveToLibraryBody(String title) {
    return 'The text of clause “$title” in the library template is replaced. Existing contracts are not changed.';
  }

  @override
  String get savedToLibrary => 'Text saved in the library';

  @override
  String get pickLibraryClause => 'Add a clause from the library';

  @override
  String get searchClauses => 'Search the clauses';

  @override
  String get scopePhase => 'Phase';

  @override
  String get scopeItem => 'Item';

  @override
  String get scopeDescription => 'Description';

  @override
  String get scopeAcceptance => 'Acceptance criteria';

  @override
  String get addScopeRow => 'Row';

  @override
  String get outOfScope => 'Out of scope';

  @override
  String get outOfScopeHint => 'One per line';

  @override
  String get contractTotal => 'Total fee';

  @override
  String get milestoneLabel => 'Milestone';

  @override
  String get milestoneShare => 'Share or amount';

  @override
  String get milestoneShareHint => '30% or 25000';

  @override
  String get milestoneTrigger => 'Due on';

  @override
  String get milestoneTriggerHint => 'On signature';

  @override
  String get milestoneDue => 'Due date';

  @override
  String get milestoneAmount => 'Amount';

  @override
  String get addMilestone => 'Milestone';

  @override
  String get milestonesBalanced => 'Milestones = total';

  @override
  String milestonesOff(String sum, String total, String diff) {
    return 'Milestones $sum do not add up to the total $total (difference $diff)';
  }

  @override
  String milestonesPercentOff(String pct) {
    return 'The shares add up to $pct%, not 100%';
  }

  @override
  String get createInvoice => 'Create invoice';

  @override
  String invoiceCreatedFromMilestone(String number, String label) {
    return 'New invoice $number from “$label”';
  }

  @override
  String get milestoneNeedsAmount => 'Set the milestone amount first';

  @override
  String get noLinkedInvoices => 'No linked invoices yet. Create an invoice from a milestone, or type the contract number in the invoice\'s “Contract reference”.';

  @override
  String get lockedBanner => 'This contract is signed, so it is read-only. Create an amendment for any change.';

  @override
  String unlockedBanner(String date) {
    return 'The signed contract was unlocked on $date. Your edits now change the signed document.';
  }

  @override
  String get createAmendment => 'Amendment';

  @override
  String get unlock => 'Unlock';

  @override
  String get relock => 'Lock again';

  @override
  String get unlockTitle => 'Unlock a signed contract?';

  @override
  String get unlockBody => 'Editing after the signature makes your copy differ from the signed one. The usual way is an amendment. The unlock date is recorded in the contract history.';

  @override
  String statusBlocked(String status, String missing) {
    return 'The status cannot be set to “$status”: $missing';
  }

  @override
  String amendmentCreated(String number) {
    return 'New amendment: $number';
  }

  @override
  String amendmentOf(String number) {
    return 'Amendment to contract $number';
  }

  @override
  String amendmentPreamble(String number, String date) {
    return 'An amendment to contract No. $number dated $date, between the same parties, is agreed as follows. All other clauses and annexes of the contract remain in force and unchanged.';
  }

  @override
  String get amendmentClauseTitle => 'Subject of the amendment';

  @override
  String contractDeleted(String number) {
    return 'Deleted $number';
  }

  @override
  String contractHasInvoicesTitle(String number) {
    return '$number is linked to invoices';
  }

  @override
  String contractHasInvoicesBody(String invoices) {
    return '$invoices are linked to it, so it cannot be deleted without leaving the invoices without a reference. Cancel it instead, or archive the client.';
  }

  @override
  String get cancelContract => 'Set the status to “Cancelled”';

  @override
  String get duplicateContract => 'Duplicate as a new contract';

  @override
  String contractDuplicated(String number) {
    return 'New contract: $number';
  }

  @override
  String get changeStatus => 'Change the status';

  @override
  String get history => 'Contract history';

  @override
  String get historyUnlock => 'Unlock';

  @override
  String get historyRelock => 'Lock again';

  @override
  String historyStatus(String status) {
    return 'Status: $status';
  }

  @override
  String get libraryTitle => 'Clause library';

  @override
  String get librarySubtitle => 'The templates and clauses copied into every new contract. Editing them does not change existing contracts.';

  @override
  String get openLibrary => 'Open the clause library';

  @override
  String get newTemplate => 'New template';

  @override
  String get templateName => 'Template name';

  @override
  String get templateKind => 'Kind';

  @override
  String get templateDefaults => 'Default variable values';

  @override
  String get templateDefaultsHint => 'One variable per line: name=value';

  @override
  String get deleteTemplate => 'Delete the template';

  @override
  String deleteTemplateBody(String name) {
    return 'The template “$name” and its clauses are deleted from the library. Contracts made from it are not changed.';
  }

  @override
  String get enabledByDefault => 'Enabled by default';

  @override
  String get pickTemplateToEdit => 'Pick a template to edit';

  @override
  String get draftNotLegalAdvice => 'The wording is a draft, not legal advice. Have a lawyer review it.';

  @override
  String get contractsSettings => 'Contracts';

  @override
  String get legalName => 'Legal name';

  @override
  String get nationalIdOrRegistry => 'National ID / commercial registry';

  @override
  String get address => 'Address';

  @override
  String get contractPrefix => 'Contract number prefix';

  @override
  String get quotePrefix => 'Quotation number prefix';

  @override
  String get defaultJurisdiction => 'Default jurisdiction';

  @override
  String get westernDigits => 'Western digits for sub-items (1. instead of ١.)';

  @override
  String get clientLegal => 'Legal details (for contracts)';

  @override
  String get clientRegistry => 'Commercial registry / national ID';

  @override
  String get clientRepresentative => 'Legal representative';

  @override
  String get clientRepresentativeTitle => 'Their title';

  @override
  String clientHasDocumentsBody(String invoices, String contracts, String unpaid) {
    return '$invoices and $contracts are linked to it, unpaid total: $unpaid.\nArchiving hides the client, its invoices and its contracts from the list and search without deleting anything, and you can bring them back from the “Archived” filter.';
  }

  @override
  String clientDeletedWithDocuments(String name, String documents) {
    return 'Deleted $name and $documents';
  }

  @override
  String confirmDeleteDocumentsBody(String documents) {
    return '$documents will be deleted, paid, sent and signed ones included. We take a backup first, and you can undo this for 8 seconds.\nType the client name to confirm:';
  }

  @override
  String andJoin(String a, String b) {
    return '$a and $b';
  }

  @override
  String get trash => 'Trash';

  @override
  String get trashEmptyState => 'The trash is empty.';

  @override
  String trashDeletedOn(String date) {
    return 'Deleted on $date';
  }

  @override
  String trashPurgeIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'purged in $days days',
      few: 'purged in $days days',
      two: 'purged in two days',
      one: 'purged tomorrow',
      zero: 'purged today',
    );
    return '$_temp0';
  }

  @override
  String get trashRestore => 'Restore';

  @override
  String get trashPurge => 'Delete permanently';

  @override
  String get trashEmpty => 'Empty the trash';

  @override
  String trashOfClient(String name) {
    return 'of $name';
  }

  @override
  String get trashClientDeleted => 'Client deleted';

  @override
  String trashRestored(String label) {
    return 'Restored $label';
  }

  @override
  String trashRestoredCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items restored',
      few: '$count items restored',
      two: 'two items restored',
      one: 'one item restored',
    );
    return '$_temp0';
  }

  @override
  String trashNeedsClientTitle(String name) {
    return 'The client $name is in the trash';
  }

  @override
  String trashNeedsClientBody(String label) {
    return '$label cannot be restored while its client is deleted. Restore the client with it? (the client only, without its other deleted documents)';
  }

  @override
  String get trashRestoreBoth => 'Restore both';

  @override
  String trashPurgeTitle(String label) {
    return 'Delete $label permanently?';
  }

  @override
  String trashPurgeBody(String label) {
    return 'A permanent deletion cannot be undone from the app. We write a backup before deleting.\nType “$label” to confirm:';
  }

  @override
  String trashPurgeClientBody(String label) {
    return 'The client $label is deleted permanently with all its deleted invoices and contracts. We write a backup before deleting.\nType the client name to confirm:';
  }

  @override
  String get trashEmptyTitle => 'Empty the trash?';

  @override
  String trashEmptyBody(String count) {
    return '$count are deleted permanently. We write a backup before deleting.\nType “Empty” to confirm:';
  }

  @override
  String get trashEmptyWord => 'Empty';

  @override
  String trashItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      few: '$count items',
      two: 'two items',
      one: 'one item',
    );
    return '$_temp0';
  }

  @override
  String trashPurged(String file) {
    return 'Deleted permanently. Backup: $file';
  }

  @override
  String get trashPurgeFailed => 'Could not delete permanently';

  @override
  String undoOrTrash(String message) {
    return '$message — undo, or find it in the trash';
  }

  @override
  String get kindClientLabel => 'client';

  @override
  String get kindInvoiceLabel => 'invoice';

  @override
  String get cloudSync => 'Cloud sync';

  @override
  String get cloudSyncOff => 'Not available — coming soon';

  @override
  String get cloudSyncOn => 'Enabled';

  @override
  String get cloudSyncBody => 'An optional subscription later: end-to-end encrypted sync between your devices. The desktop app stays free and complete without it, and your data does not leave this machine today.';

  @override
  String get calendar => 'Calendar';

  @override
  String get invoicesAndContracts => 'Invoices and contracts';

  @override
  String get viewMonth => 'Month';

  @override
  String get viewWeek => 'Week';

  @override
  String get viewAgenda => 'Agenda';

  @override
  String get today => 'Today';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get summaryExpected => 'Expected';

  @override
  String get summaryCollected => 'Collected';

  @override
  String get summaryLate => 'Overdue';

  @override
  String get evDue => 'Due';

  @override
  String get evOverdue => 'Overdue';

  @override
  String get evOverdueRollup => 'Overdue';

  @override
  String get evPaid => 'Paid';

  @override
  String get evPostponed => 'Postponed';

  @override
  String get evMilestone => 'Contract milestone due';

  @override
  String get evRenewal => 'Renewal';

  @override
  String get evContractStart => 'Contract starts';

  @override
  String get evContractEnd => 'Contract ends';

  @override
  String get evWarrantyEnd => 'Warranty ends';

  @override
  String get evReminder => 'Reminder';

  @override
  String daysOverdue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days overdue',
      few: '$days days overdue',
      two: '2 days overdue',
      one: '1 day overdue',
    );
    return '$_temp0';
  }

  @override
  String overdueRollup(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count overdue',
      few: '$count overdue',
      two: '2 overdue',
      one: '1 overdue',
    );
    return '$_temp0';
  }

  @override
  String moreEvents(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count',
      one: '1',
    );
    return '+$_temp0';
  }

  @override
  String get filterClient => 'Client';

  @override
  String get filterType => 'Event type';

  @override
  String get filterCurrency => 'Currency';

  @override
  String get allClients => 'All clients';

  @override
  String get allTypes => 'All types';

  @override
  String get allCurrencies => 'All currencies';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get showPast => 'Show the past';

  @override
  String get agendaEmpty => 'No matching events coming up';

  @override
  String get dayEmpty => 'Nothing on this day';

  @override
  String get searchCalendar => 'Search the calendar';

  @override
  String get actOpen => 'Open';

  @override
  String get actMarkPaid => 'Mark as paid';

  @override
  String get actPostpone => 'Postpone';

  @override
  String get actCopyReminder => 'Copy a reminder message';

  @override
  String get actCreateInvoice => 'Create invoice';

  @override
  String get actOpenContract => 'Open contract';

  @override
  String get actRenewInvoice => 'Create renewal invoice';

  @override
  String get actEdit => 'Edit';

  @override
  String get actMarkDone => 'Done';

  @override
  String get actReopen => 'Reopen';

  @override
  String get actDelete => 'Delete';

  @override
  String get addReminder => '+ Reminder';

  @override
  String get postponeTitle => 'Postpone the due date';

  @override
  String get postponeNewDate => 'New date';

  @override
  String get postponeReason => 'Reason';

  @override
  String get postponeReasonHint => 'Example: the client asked for more time';

  @override
  String postponed(String date) {
    return 'Postponed to $date';
  }

  @override
  String postponedFromTo(String from, String to) {
    return 'Postponed from $from to $to';
  }

  @override
  String get postponeHistory => 'Postponement history';

  @override
  String get reminderNew => 'New reminder';

  @override
  String get reminderEdit => 'Edit the reminder';

  @override
  String get reminderText => 'Text';

  @override
  String get reminderTime => 'Time (optional, 24-hour)';

  @override
  String get reminderTimeHint => '10:30';

  @override
  String get errReminderText => 'Write the reminder text';

  @override
  String get errTime => 'Invalid time';

  @override
  String get reminderDeleted => 'Reminder deleted';

  @override
  String get reminderCopied => 'Reminder copied — paste it into WhatsApp or email';

  @override
  String get exportIcs => 'Export to the calendar (.ics)';

  @override
  String get exportIcsVisible => 'The visible range';

  @override
  String get exportIcsFuture => 'All upcoming events';

  @override
  String icsExported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count events exported',
      few: '$count events exported',
      two: '2 events exported',
      one: '1 event exported',
    );
    return '$_temp0';
  }

  @override
  String todayBanner(int due, int overdue) {
    String _temp0 = intl.Intl.pluralLogic(
      due,
      locale: localeName,
      other: '$due due',
      few: '$due due',
      two: '2 due',
      one: '1 due',
    );
    String _temp1 = intl.Intl.pluralLogic(
      overdue,
      locale: localeName,
      other: '$overdue overdue',
      few: '$overdue overdue',
      two: '2 overdue',
      one: '1 overdue',
    );
    return 'Today: $_temp0 · $_temp1';
  }

  @override
  String get showInCalendar => 'Show in the calendar';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get profileBanner => 'Complete your details';

  @override
  String get profileBannerBody => 'Add your name and payment details so they appear on your invoices and contracts.';

  @override
  String get inCalendar => 'In the calendar';

  @override
  String get demoData => 'Demo data';

  @override
  String get demoBody => 'Fake clients, invoices and contracts to try things out. Any row you edit becomes yours and is not removed with them.';

  @override
  String get demoAdd => 'Add demo data';

  @override
  String get demoRemove => 'Remove the demo data';

  @override
  String get demoRemoveTitle => 'Remove the demo data?';

  @override
  String get demoRemoveBody => 'Only the demo rows are deleted permanently, after a backup. Your data is not touched.';

  @override
  String get demoAdded => 'Demo data added';

  @override
  String demoRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rows',
      few: '$count rows',
      two: '2 rows',
      one: '1 row',
    );
    return 'Demo data removed ($_temp0)';
  }

  @override
  String get weekStart => 'First day of the week';

  @override
  String get weekdaySaturday => 'Saturday';

  @override
  String get weekdaySunday => 'Sunday';

  @override
  String get weekdayMonday => 'Monday';

  @override
  String get notifyOnStart => 'Notification at start-up';

  @override
  String get notifyOnStartBody => 'A desktop notification with what is due and overdue today (when available).';

  @override
  String get calendarShortcuts => 'Arrows: move · PageUp/PageDown: month · T: today · M/W/A: view · Enter: the selected day';

  @override
  String get dayTotal => 'Due today';

  @override
  String get wdMon => 'Mon';

  @override
  String get wdTue => 'Tue';

  @override
  String get wdWed => 'Wed';

  @override
  String get wdThu => 'Thu';

  @override
  String get wdFri => 'Fri';

  @override
  String get wdSat => 'Sat';

  @override
  String get wdSun => 'Sun';

  @override
  String get general => 'General';

  @override
  String get uiLanguage => 'Language';

  @override
  String get uiLanguageSystem => 'System language';

  @override
  String get uiLanguageAr => 'العربية';

  @override
  String get uiLanguageEn => 'English';

  @override
  String get uiLanguageHint => 'The whole app follows this choice, including the reading direction.';

  @override
  String get docLanguage => 'Document language';

  @override
  String get docLanguageAr => 'Arabic';

  @override
  String get docLanguageEn => 'English';

  @override
  String get docLanguageBilingual => 'Bilingual (Arabic / English)';

  @override
  String get clientPreferredLanguage => 'Preferred document language';

  @override
  String get clientPreferredLanguageDefault => 'Follow global default';

  @override
  String get defaultDocLanguage => 'Default document language';

  @override
  String get defaultDocLanguageHint => 'The language new documents start in';

  @override
  String get docDigitStyle => 'Digits in Arabic documents';

  @override
  String get docDigitStyleHint => 'How digits appear inside Arabic text in exported PDFs';

  @override
  String get digitStyleWestern => 'Western (123)';

  @override
  String get digitStyleArabicIndic => 'Arabic-Indic (١٢٣)';

  @override
  String get warnNoPaymentMethod => 'Add a payment method in Settings';

  @override
  String get warnNoPaymentMethodHint => 'The payment details card will not appear on the invoice until at least one payment method is added.';

  @override
  String get stylesTitle => 'Document styles';

  @override
  String get stylesSubtitle => 'Choose how invoices and contracts look, or design your own.';

  @override
  String get stylesPresets => 'Ready-made';

  @override
  String get stylesMine => 'My styles';

  @override
  String get stylesNoneYet => 'You have no styles of your own yet.';

  @override
  String get styleNewFromBlank => 'New from Blank';

  @override
  String get styleImport => 'Import style file…';

  @override
  String get styleDuplicate => 'Duplicate';

  @override
  String get styleDuplicateToCustomize => 'Duplicate to customise';

  @override
  String get styleRename => 'Rename';

  @override
  String get styleResetToPreset => 'Reset to preset';

  @override
  String styleResetConfirm(String name) {
    return '“$name” goes back to its preset’s colours, fonts and settings. Its name and logo stay.';
  }

  @override
  String get styleReset => 'Reset';

  @override
  String get styleExport => 'Export style file…';

  @override
  String get styleDelete => 'Delete';

  @override
  String styleDeleted(String name) {
    return '“$name” moved to the trash';
  }

  @override
  String styleCopyName(String name) {
    return '$name (copy)';
  }

  @override
  String get styleNameLabel => 'Style name';

  @override
  String get styleNewName => 'New style';

  @override
  String styleImported(String name) {
    return 'Imported “$name”';
  }

  @override
  String get styleImportFailed => 'This file isn’t a valid style file.';

  @override
  String styleExported(String file) {
    return 'Style saved to $file';
  }

  @override
  String get styleExportFailed => 'Couldn’t save the style file.';

  @override
  String get styleFileType => 'Style file';

  @override
  String get stylePresetReadOnly => 'Ready-made styles are read-only. Duplicate one to change it.';

  @override
  String get stylePreviewInvoice => 'Invoice';

  @override
  String get stylePreviewContract => 'Contract';

  @override
  String get stylePreviewSample => 'Previewing on a sample invoice';

  @override
  String get stylePreviewOpenDoc => 'Previewing on the open document';

  @override
  String get styleGroupColours => 'Colours';

  @override
  String get styleGroupFont => 'Font & page';

  @override
  String get styleGroupHeader => 'Header & logo';

  @override
  String get styleGroupTable => 'Table';

  @override
  String get styleGroupTotals => 'Totals';

  @override
  String get styleGroupBlocks => 'Visible blocks';

  @override
  String get styleGroupFooter => 'Footer';

  @override
  String get colourPrimary => 'Primary';

  @override
  String get colourAccent => 'Accent';

  @override
  String get colourInk => 'Text';

  @override
  String get colourMuted => 'Secondary text';

  @override
  String get colourSurface => 'Card background';

  @override
  String get colourTableHeader => 'Table header background';

  @override
  String get colourBorder => 'Rules & borders';

  @override
  String get colourPick => 'Pick a colour';

  @override
  String get colourHexInvalid => 'Enter 6 hex digits, like 0F766E';

  @override
  String contrastWarning(String pair, String ratio) {
    return '$pair: contrast $ratio:1 is below 4.5:1, so the text may be hard to read.';
  }

  @override
  String get contrastInkOnPage => 'Text on the page';

  @override
  String get contrastMutedOnPage => 'Secondary text on the page';

  @override
  String get contrastPrimaryOnPage => 'Headings on the page';

  @override
  String get contrastInkOnSurface => 'Text on cards';

  @override
  String get contrastMutedOnSurface => 'Secondary text on cards';

  @override
  String get contrastMutedOnTableHeader => 'Table header labels';

  @override
  String get contrastWhiteOnInk => 'Total on its dark band';

  @override
  String get contrastWhiteOnPrimary => 'Total on its coloured band';

  @override
  String get fontFamily => 'Typeface';

  @override
  String get fontPlex => 'IBM Plex Sans Arabic';

  @override
  String get fontNaskh => 'Noto Naskh Arabic';

  @override
  String get fontBaseSize => 'Base size';

  @override
  String get fontScale => 'Text scale';

  @override
  String get paperSize => 'Paper size';

  @override
  String get paperA4 => 'A4';

  @override
  String get paperLetter => 'Letter';

  @override
  String get marginSide => 'Side margin';

  @override
  String get marginTop => 'Top margin';

  @override
  String get marginBottom => 'Bottom margin';

  @override
  String pointsValue(String value) {
    return '$value pt';
  }

  @override
  String get headerStyleLabel => 'Header style';

  @override
  String get headerBand => 'Band';

  @override
  String get headerRule => 'Rule';

  @override
  String get headerNone => 'None';

  @override
  String get logoLabel => 'Logo';

  @override
  String get logoChoose => 'Choose image…';

  @override
  String get logoRemove => 'Remove logo';

  @override
  String get logoHint => 'PNG or JPG, up to 1 MB';

  @override
  String get logoRejected => 'That image wasn’t accepted: it must be a PNG or JPG of 1 MB or less.';

  @override
  String get logoImageType => 'Image';

  @override
  String get logoSize => 'Logo size';

  @override
  String get logoPosition => 'Logo position';

  @override
  String get positionStart => 'Start';

  @override
  String get positionCenter => 'Centre';

  @override
  String get positionEnd => 'End';

  @override
  String get showRole => 'Your role';

  @override
  String get showCity => 'City';

  @override
  String get showContacts => 'Contact details';

  @override
  String get tableStyleLabel => 'Table style';

  @override
  String get tablePlain => 'Plain';

  @override
  String get tableStriped => 'Striped';

  @override
  String get tableBordered => 'Bordered';

  @override
  String get totalsStyleLabel => 'Totals style';

  @override
  String get totalsOutlined => 'Outlined';

  @override
  String get totalsSolid => 'Solid';

  @override
  String get totalsPlain => 'Plain';

  @override
  String get showVatRow => 'VAT row';

  @override
  String get showPaidStamp => '“Paid” stamp';

  @override
  String get blockHeader => 'Header';

  @override
  String get blockParties => 'Parties';

  @override
  String get blockItems => 'Items';

  @override
  String get blockTotals => 'Totals';

  @override
  String get blockNotes => 'Notes';

  @override
  String get blockFooter => 'Footer';

  @override
  String get blockRequired => 'Required';

  @override
  String get blocksHint => 'Drag the blocks to change their order in the document.';

  @override
  String get showPaymentCard => 'Payment details card';

  @override
  String get showPleaseQuote => '“Please quote the invoice number”';

  @override
  String get showPageNumbers => 'Page numbers';

  @override
  String get showSignatureBoxes => 'Signature boxes in contracts';

  @override
  String get footerAr => 'Footer text (Arabic)';

  @override
  String get footerEn => 'Footer text (English)';

  @override
  String get docStyle => 'Document style';

  @override
  String get docStyleFollows => 'Client or default';

  @override
  String get docStyleEdit => 'Edit styles…';

  @override
  String get styleLockedInvoice => 'The style is fixed because the invoice was sent';

  @override
  String get styleLockedContract => 'The style is fixed because the contract was signed';

  @override
  String get stylesSettings => 'Document styles';

  @override
  String get defaultInvoiceStyle => 'Default invoice style';

  @override
  String get defaultContractStyle => 'Default contract style';

  @override
  String get openStyleEditor => 'Open style editor';

  @override
  String get presetClassic => 'Classic';

  @override
  String get presetModern => 'Modern';

  @override
  String get presetMinimal => 'Minimal';

  @override
  String get presetBold => 'Bold';

  @override
  String get presetFormal => 'Formal';

  @override
  String get presetBlank => 'Blank';

  @override
  String get styleMoreActions => 'Style actions';

  @override
  String get previewFailed => 'The preview couldn’t be shown. You can still export the file.';

  @override
  String styleUsageDrafts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count drafts',
      few: '$count drafts',
      two: '2 drafts',
      one: '1 draft',
    );
    return '$_temp0';
  }

  @override
  String styleUsageClients(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clients',
      few: '$count clients',
      two: '2 clients',
      one: '1 client',
    );
    return '$_temp0';
  }

  @override
  String styleUsageAnd(String a, String b) {
    return '$a and $b';
  }

  @override
  String styleDeleteTitle(String name) {
    return 'Delete “$name”?';
  }

  @override
  String styleDeleteInUse(String usage) {
    return 'This style is used by $usage. Once it’s deleted they fall back to the client’s style, then the default style, then Classic.';
  }

  @override
  String styleDeletedInUse(String name, String usage) {
    return '“$name” moved to the trash; it was used by $usage.';
  }

  @override
  String get settingsData => 'Data & backups';

  @override
  String get settingsSearchHint => 'Search settings';

  @override
  String get settingsNoMatch => 'No settings match.';

  @override
  String get settingsInvoices => 'Invoices';

  @override
  String get numberingTitle => 'Invoice numbering';

  @override
  String get numberPattern => 'Number pattern';

  @override
  String numberPatternHint(String prefix, String year, String yy, String seq) {
    return '$prefix prefix · $year or $yy year · $seq sequence';
  }

  @override
  String get numberYearlyReset => 'Restart the sequence each year';

  @override
  String numberPatternNoSeq(String seq) {
    return 'Add $seq to the pattern.';
  }

  @override
  String numberPatternNoYear(String year, String yy) {
    return 'When the sequence restarts each year, add $year or $yy so numbers never repeat.';
  }

  @override
  String numberNextPreview(String number) {
    return 'Next number: $number';
  }

  @override
  String get numberExistingKept => 'Existing numbers don’t change.';

  @override
  String get taxVatTitle => 'Tax';

  @override
  String get defaultVatOn => 'VAT on for new invoices';

  @override
  String get defaultVatRate => 'VAT rate (%)';

  @override
  String get taxRegistrationNo => 'Tax registration number';

  @override
  String get taxRegistrationNoHint => 'Printed with your details when set.';

  @override
  String get docFormatsTitle => 'Document formats';

  @override
  String get dateFormatLabel => 'Date format';

  @override
  String get defaultCurrencyLabel => 'Default currency for new invoices';

  @override
  String get currencyDisplayLabel => 'Currency display';

  @override
  String get currencyDisplayCode => 'Code';

  @override
  String get currencyDisplayLocal => 'Arabic symbols';

  @override
  String get currencyDisplaySymbol => 'Symbol';

  @override
  String get currencyDisplayHint => '“Arabic symbols” apply to Arabic documents only; English and bilingual documents use the code.';

  @override
  String get docFormatsFrozenHint => 'Documents already sent, paid or signed keep the formats they were issued with.';

  @override
  String get clientPreferredStyle => 'Preferred document style';

  @override
  String get styleFollowDefault => 'Follow the default';

  @override
  String get thisMachineTitle => 'This computer';

  @override
  String get thisMachineHint => 'These settings are kept on this computer only.';

  @override
  String get densityLabel => 'Density';

  @override
  String get densityCompact => 'Compact';

  @override
  String get densityComfortable => 'Comfortable';

  @override
  String get accentLabel => 'Accent colour';

  @override
  String get accentTeal => 'Teal';

  @override
  String get accentBlue => 'Blue';

  @override
  String get accentIndigo => 'Indigo';

  @override
  String get accentPurple => 'Purple';

  @override
  String get accentRose => 'Rose';

  @override
  String get accentAmber => 'Amber';

  @override
  String get startupViewLabel => 'At start-up';

  @override
  String get startupLast => 'Where I left off';

  @override
  String get startupCalendar => 'The calendar';

  @override
  String get pdfExportTitle => 'PDF export';

  @override
  String get pdfNamePattern => 'Suggested file name';

  @override
  String pdfNamePatternHint(String number, String client, String date) {
    return '$number document number · $client client · $date issue date';
  }

  @override
  String pdfNamePreview(String name) {
    return 'Example: $name';
  }

  @override
  String get exportFolder => 'Export folder';

  @override
  String get exportFolderLast => 'The last folder used';

  @override
  String get exportFolderClear => 'Use the last folder';

  @override
  String get openAfterExport => 'Open the file after exporting';

  @override
  String get shortcutsTitle => 'Keyboard shortcuts';

  @override
  String get scNewInvoice => 'New invoice';

  @override
  String get scNewClient => 'New client';

  @override
  String get scNewContract => 'New contract';

  @override
  String get scToggleCalendar => 'Switch to the calendar and back';

  @override
  String get scSearch => 'Search';

  @override
  String get scFind => 'Search (alternative)';

  @override
  String get scSave => 'Save';

  @override
  String get scExportPdf => 'Export PDF';

  @override
  String get scDuplicate => 'Duplicate the document';

  @override
  String get scRenew => 'Renew the invoice';

  @override
  String get scEditTab => 'Edit tab';

  @override
  String get scPreviewTab => 'Preview tab';
}
