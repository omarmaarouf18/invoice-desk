// dart format off
// coverage:ignore-file

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Invoice Desk';

  @override
  String get sidebarTitle => 'سجل الفواتير';

  @override
  String get myProfile => 'بياناتي';

  @override
  String get searchHint => 'ابحث باسم العميل أو رقم الفاتورة';

  @override
  String get newInvoice => 'فاتورة جديدة';

  @override
  String get newClient => 'عميل جديد';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterUnpaid => 'غير مدفوعة';

  @override
  String get filterOverdue => 'متأخرة';

  @override
  String get filterPaid => 'مدفوعة';

  @override
  String get filterDrafts => 'مسودات';

  @override
  String get summaryUnpaid => 'غير مدفوع';

  @override
  String get summaryOverdue => 'متأخرة';

  @override
  String get summaryNothingDue => 'لا مستحقات مفتوحة';

  @override
  String invoiceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فاتورة',
      few: '$count فواتير',
      two: 'فاتورتان',
      one: 'فاتورة واحدة',
    );
    return '$_temp0';
  }

  @override
  String unpaidCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count غير مدفوعة',
      few: '$count غير مدفوعة',
      two: 'غير مدفوعتان',
      one: 'غير مدفوعة واحدة',
    );
    return '$_temp0';
  }

  @override
  String noResults(String query) {
    return 'لا نتائج لـ «$query»';
  }

  @override
  String get clearSearch => 'مسح البحث';

  @override
  String get noInvoicesForClient => 'لا فواتير مطابقة';

  @override
  String get noClientsYet => 'لا عملاء بعد';

  @override
  String get statusDraft => 'مسودة';

  @override
  String get statusSent => 'مُرسلة';

  @override
  String get statusOverdue => 'متأخرة';

  @override
  String get statusPaid => 'مدفوعة';

  @override
  String get statusVoid => 'ملغاة';

  @override
  String get menuOpen => 'فتح';

  @override
  String get menuDuplicate => 'تكرار';

  @override
  String get menuRenew => 'فاتورة تجديد';

  @override
  String get menuMarkPaid => 'تحديد كمدفوعة';

  @override
  String get menuDelete => 'حذف';

  @override
  String get menuEdit => 'تعديل';

  @override
  String get menuArchive => 'أرشفة';

  @override
  String get menuUnarchive => 'إلغاء الأرشفة';

  @override
  String get archived => 'مؤرشف';

  @override
  String get tabEdit => 'تعديل';

  @override
  String get tabPreview => 'معاينة';

  @override
  String get save => 'حفظ';

  @override
  String get exportPdf => 'PDF';

  @override
  String get exportPdfLong => 'تصدير PDF';

  @override
  String get more => 'المزيد';

  @override
  String get saved => 'محفوظ';

  @override
  String get saving => 'جارٍ الحفظ…';

  @override
  String get unsaved => 'تغييرات لم تُحفظ بعد';

  @override
  String get notSavedFix => 'لم تُحفظ — راجع الحقول';

  @override
  String get saveFailed => 'تعذّر الحفظ';

  @override
  String get cardDetails => 'بيانات الفاتورة';

  @override
  String get client => 'العميل';

  @override
  String get chooseClient => 'اختر عميلًا';

  @override
  String get invoiceNumber => 'رقم الفاتورة';

  @override
  String get issueDate => 'تاريخ الإصدار';

  @override
  String get dueDate => 'تاريخ الاستحقاق';

  @override
  String get contractRef => 'مرجع العقد';

  @override
  String get status => 'الحالة';

  @override
  String get paidDate => 'تاريخ السداد';

  @override
  String get cardSections => 'الأقسام والبنود';

  @override
  String get sectionTitleEn => 'عنوان القسم (EN)';

  @override
  String get sectionTitleAr => 'عنوان القسم (AR)';

  @override
  String get currency => 'العملة';

  @override
  String get deleteSection => 'حذف القسم';

  @override
  String get addSection => 'إضافة قسم';

  @override
  String get addItem => 'إضافة بند';

  @override
  String get deleteItem => 'حذف البند';

  @override
  String get dragToReorder => 'اسحب لإعادة الترتيب';

  @override
  String get colService => 'الخدمة';

  @override
  String get colDescription => 'الوصف';

  @override
  String get colCycle => 'الدورة';

  @override
  String get colQty => 'الكمية';

  @override
  String get colUnitPrice => 'سعر الوحدة';

  @override
  String get colLineTotal => 'الإجمالي';

  @override
  String get cycleOneTime => 'مرة واحدة';

  @override
  String get cycleMonthly => 'شهري';

  @override
  String get cycleAnnual => 'سنوي';

  @override
  String get subtotal => 'الإجمالي الفرعي';

  @override
  String sectionN(int n) {
    return 'القسم $n';
  }

  @override
  String get cardTotals => 'الإجماليات والضريبة';

  @override
  String get vat => 'ضريبة القيمة المضافة';

  @override
  String get vatRate => 'النسبة %';

  @override
  String get vatLine => 'الضريبة';

  @override
  String get totalDue => 'الإجمالي المستحق';

  @override
  String dueBy(String date) {
    return 'مستحقة السداد في $date';
  }

  @override
  String get cardNotes => 'ملاحظات';

  @override
  String get notesEn => 'ملاحظات بالإنجليزية — سطر لكل ملاحظة';

  @override
  String get notesAr => 'ملاحظات بالعربية — سطر لكل ملاحظة';

  @override
  String get cardScope => 'صفحة نطاق المشروع';

  @override
  String get scopeToggle => 'إضافة صفحة نطاق المشروع إلى الفاتورة';

  @override
  String get scopeTitle => 'عنوان المشروع';

  @override
  String get scopeOverview => 'نظرة عامة';

  @override
  String get scopeDone => 'ما تم تنفيذه — سطر لكل بند';

  @override
  String get scopeDelivered => 'ما يستلمه العميل — سطر لكل بند';

  @override
  String get scopeWarranty => 'الضمان والدعم';

  @override
  String get errMissingClient => 'اختر العميل';

  @override
  String get errEmptyNumber => 'أدخل رقم الفاتورة';

  @override
  String get errDuplicateNumber => 'هذا الرقم مستخدم في فاتورة أخرى';

  @override
  String get errAmount => 'مبلغ غير صالح';

  @override
  String get errQty => 'كمية غير صالحة';

  @override
  String get errRate => 'نسبة غير صالحة';

  @override
  String exportedPdf(String name) {
    return 'تم حفظ $name';
  }

  @override
  String get openFile => 'فتح الملف';

  @override
  String get openFolder => 'فتح المجلد';

  @override
  String get exportFailed => 'تعذّر حفظ الملف';

  @override
  String deleted(String number) {
    return 'اتحذفت $number';
  }

  @override
  String get undo => 'تراجع';

  @override
  String renewNone(String number) {
    return 'لا توجد بنود شهرية أو سنوية في $number لتجديدها';
  }

  @override
  String renewCreated(String number) {
    return 'فاتورة تجديد جديدة: $number';
  }

  @override
  String duplicated(String number) {
    return 'نسخة جديدة: $number';
  }

  @override
  String markedPaid(String number) {
    return '$number مدفوعة';
  }

  @override
  String get nothingOpen => 'افتح فاتورة أولًا';

  @override
  String get clientDialogNew => 'عميل جديد';

  @override
  String get clientDialogEdit => 'تعديل العميل';

  @override
  String get clientName => 'اسم العميل';

  @override
  String get clientContact => 'الشخص المسؤول';

  @override
  String get clientCity => 'المدينة';

  @override
  String get clientPhone => 'الهاتف';

  @override
  String get clientEmail => 'البريد الإلكتروني';

  @override
  String get cancel => 'إلغاء';

  @override
  String get errClientName => 'أدخل اسم العميل';

  @override
  String get settingsTitle => 'بياناتي';

  @override
  String get settingsSubtitle => 'تظهر هذه البيانات على كل فاتورة. تُحفظ تلقائيًا.';

  @override
  String get back => 'رجوع';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get name => 'الاسم';

  @override
  String get role => 'المسمى الوظيفي';

  @override
  String get city => 'المدينة';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get phone => 'الهاتف';

  @override
  String get website => 'الموقع';

  @override
  String get invoicing => 'الترقيم والاستحقاق';

  @override
  String get invoicePrefix => 'بادئة الترقيم';

  @override
  String get prefixHint => 'تُطبّق على الفواتير الجديدة فقط';

  @override
  String get defaultDueDays => 'أيام الاستحقاق الافتراضية';

  @override
  String get payment => 'بيانات الدفع';

  @override
  String get instapay => 'InstaPay';

  @override
  String get wallet => 'المحفظة الإلكترونية';

  @override
  String get bankIban => 'البنك / IBAN';

  @override
  String get defaultNotes => 'الملاحظات الافتراضية';

  @override
  String get appearance => 'المظهر';

  @override
  String get themeSystem => 'حسب النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get backup => 'النسخ الاحتياطي والتصدير';

  @override
  String get backupDir => 'مجلد النسخ الاحتياطية';

  @override
  String get chooseFolder => 'اختيار مجلد…';

  @override
  String get backupNow => 'نسخ احتياطي الآن';

  @override
  String get restore => 'استعادة من نسخة';

  @override
  String get exportCsv => 'تصدير CSV للمحاسب';

  @override
  String lastBackup(String date) {
    return 'آخر نسخة: $date';
  }

  @override
  String get never => 'لم تُؤخذ أي نسخة بعد';

  @override
  String get backupAuto => 'تُؤخذ نسخة تلقائيًا عند فتح التطبيق إذا مرّ يوم على آخر نسخة، ويُحتفظ بآخر 30 نسخة.';

  @override
  String get backupDone => 'تم حفظ النسخة الاحتياطية';

  @override
  String get backupFailed => 'تعذّر أخذ النسخة الاحتياطية';

  @override
  String get restoreConfirmTitle => 'استعادة هذه النسخة؟';

  @override
  String restoreConfirmBody(String date, int count, int clients) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فاتورة',
      few: '$count فواتير',
      two: 'فاتورتان',
      one: 'فاتورة واحدة',
    );
    String _temp1 = intl.Intl.pluralLogic(
      clients,
      locale: localeName,
      other: '$count عميلًا',
      few: '$count عملاء',
      two: 'عميلان',
      one: 'عميل واحد',
    );
    return 'نسخة بتاريخ $date تحتوي على $_temp0 و$_temp1.\nستُستبدل كل البيانات الحالية بها، وتُحفظ نسخة من بياناتك الحالية أولًا.';
  }

  @override
  String get restoreAction => 'استعادة';

  @override
  String get restoreDone => 'تمت الاستعادة';

  @override
  String get restoreBad => 'الملف ليس نسخة صالحة من Invoice Desk';

  @override
  String csvDone(String name) {
    return 'تم تصدير $name';
  }

  @override
  String get emptyTitle => 'أهلًا بك في Invoice Desk';

  @override
  String get emptyBody => 'خطوتان وتبدأ أول فاتورة.';

  @override
  String get stepProfile => 'أضف بياناتك';

  @override
  String get stepProfileBody => 'الاسم وبيانات الدفع التي تظهر على الفاتورة.';

  @override
  String get stepClient => 'أضف أول عميل';

  @override
  String get stepClientBody => 'اسم العميل ورقم التواصل.';

  @override
  String get stepInvoice => 'أنشئ أول فاتورة';

  @override
  String get done => 'تم';

  @override
  String get pickInvoice => 'اختر فاتورة من السجل';

  @override
  String get pickInvoiceBody => 'أو أنشئ فاتورة جديدة لتبدأ.';

  @override
  String get dbErrorTitle => 'تعذّر فتح قاعدة البيانات';

  @override
  String get dbErrorBody => 'قد يكون الملف تالفًا أو مستخدمًا من نسخة أخرى من التطبيق. يمكنك الاستعادة من آخر نسخة احتياطية.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get previewLoading => 'جارٍ تجهيز المعاينة…';

  @override
  String get shortcutsHint => 'اختصارات: Ctrl+N فاتورة · Ctrl+K بحث · Ctrl+S حفظ · Ctrl+E PDF';

  @override
  String get about => 'حول البرنامج';

  @override
  String aboutVersion(String version) {
    return 'الإصدار $version';
  }

  @override
  String get aboutBody => 'برنامج فواتير يعمل دون اتصال. بياناتك محفوظة على هذا الجهاز فقط.';

  @override
  String get aboutDataDir => 'مجلد البيانات';

  @override
  String get notTaxInvoice => 'ليست فاتورة ضريبية إلكترونية رسمية.';

  @override
  String get menuDeleteClient => 'حذف العميل';

  @override
  String clientDeleted(String name) {
    return 'اتحذف العميل $name';
  }

  @override
  String clientArchivedSnack(String name) {
    return 'اتأرشف $name وفواتيره';
  }

  @override
  String clientHasInvoicesTitle(String name) {
    return '$name عنده فواتير';
  }

  @override
  String clientHasInvoicesBody(String invoices, String unpaid) {
    return 'عنده $invoices، والمبلغ غير المدفوع: $unpaid.\nالأرشفة بتخفي العميل وفواتيره من القائمة والبحث من غير ما تمسح حاجة، وتقدر ترجّعه من فلتر «مؤرشف».';
  }

  @override
  String get archiveRecommended => 'أرشفة (مُستحسن)';

  @override
  String get deleteClientAndInvoices => 'حذف العميل وكل فواتيره';

  @override
  String confirmDeleteAllTitle(String name) {
    return 'حذف $name وكل فواتيره؟';
  }

  @override
  String confirmDeleteAllBody(String invoices) {
    return 'هيتحذف $invoices، منها المدفوع والمُرسل. هنعمل نسخة احتياطية الأول، وتقدر تتراجع لمدة ٨ ثواني.\nاكتب اسم العميل للتأكيد:';
  }

  @override
  String clientDeletedWithInvoices(String name, String invoices) {
    return 'اتحذف $name و$invoices';
  }

  @override
  String get deleteBackupFailed => 'فشلت النسخة الاحتياطية، فما اتحذفش حاجة';

  @override
  String get clientDeleteFailed => 'ماقدرناش نحذف العميل';

  @override
  String get newContract => 'عقد جديد';

  @override
  String groupContracts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count',
      one: '1',
    );
    return 'العقود ($_temp0)';
  }

  @override
  String groupInvoices(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count',
      one: '1',
    );
    return 'الفواتير ($_temp0)';
  }

  @override
  String get filterContractsInForce => 'عقود سارية';

  @override
  String contractCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عقدًا',
      few: '$count عقود',
      two: 'عقدان',
      one: 'عقد واحد',
    );
    return '$_temp0';
  }

  @override
  String get cStatusDraft => 'مسودة';

  @override
  String get cStatusSent => 'مُرسل';

  @override
  String get cStatusSigned => 'موقّع';

  @override
  String get cStatusActive => 'ساري';

  @override
  String get cStatusCompleted => 'مكتمل';

  @override
  String get cStatusCancelled => 'ملغي';

  @override
  String get kindContract => 'عقد';

  @override
  String get kindQuote => 'عرض سعر';

  @override
  String get kindAmendment => 'ملحق تعديل';

  @override
  String get newContractTitle => 'عقد جديد';

  @override
  String get chooseTemplate => 'اختر القالب';

  @override
  String clauseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بندًا',
      few: '$count بنود',
      two: 'بندان',
      one: 'بند واحد',
    );
    return '$_temp0';
  }

  @override
  String get contractTitle => 'عنوان العقد';

  @override
  String get contractTitleHint => 'مثال: تطوير وتشغيل منصة تعليمية';

  @override
  String get projectName => 'اسم المشروع';

  @override
  String get projectSummary => 'ملخص المشروع';

  @override
  String get create => 'إنشاء';

  @override
  String get noTemplates => 'لا توجد قوالب في المكتبة. أضف قالبًا من الإعدادات ← مكتبة البنود.';

  @override
  String get cardContractDetails => 'بيانات العقد';

  @override
  String get cardVariables => 'المتغيرات';

  @override
  String get cardClauses => 'البنود';

  @override
  String get cardScopeAnnex => 'ملحق (1) نطاق العمل';

  @override
  String get cardPaymentAnnex => 'ملحق (2) المقابل والدفعات';

  @override
  String get cardLinkedInvoices => 'الفواتير المرتبطة';

  @override
  String get contractNumber => 'رقم العقد';

  @override
  String get startDate => 'تاريخ البدء';

  @override
  String get endDate => 'تاريخ الانتهاء';

  @override
  String get signedDate => 'تاريخ التوقيع';

  @override
  String get jurisdiction => 'جهة الفصل في النزاعات';

  @override
  String get clearDate => 'مسح التاريخ';

  @override
  String get preamble => 'التمهيد';

  @override
  String get closingLine => 'سطر الختام';

  @override
  String missingVariables(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count متغير ناقص',
      few: '$count متغيرات ناقصة',
      two: 'متغيران ناقصان',
      one: 'متغير واحد ناقص',
    );
    return '$_temp0';
  }

  @override
  String get allVariablesFilled => 'كل المتغيرات مكتملة';

  @override
  String get noCustomVariables => 'البنود المفعّلة لا تستخدم متغيرات خاصة.';

  @override
  String builtInMissing(String source) {
    return 'ناقص من بيانات $source';
  }

  @override
  String get sourceClient => 'العميل';

  @override
  String get sourceSettings => 'الإعدادات';

  @override
  String get sourceContract => 'العقد';

  @override
  String get editClientData => 'تعديل بيانات العميل';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get variablesHelp => 'اكتب قوسين معقوفين مزدوجين داخل أي بند لإدراج متغير. القيم هنا تخص هذا العقد فقط.';

  @override
  String get optionalTag => 'اختياري';

  @override
  String get clauseEnabled => 'مفعّل';

  @override
  String get clauseTitle => 'عنوان البند';

  @override
  String get clauseBody => 'نص البند';

  @override
  String get clauseBodyHelp => 'الأسطر التي تبدأ بـ «- » تصبح بنودًا فرعية مرقمة.';

  @override
  String get addClause => 'بند';

  @override
  String get addBlankClause => 'بند فارغ';

  @override
  String get addFromLibrary => 'من المكتبة…';

  @override
  String get restoreFromLibrary => 'استرجاع النص من المكتبة';

  @override
  String get saveToLibrary => 'حفظ في المكتبة';

  @override
  String get duplicateClause => 'تكرار';

  @override
  String get deleteClause => 'حذف البند';

  @override
  String get restoreTitle => 'استرجاع نص المكتبة؟';

  @override
  String get restoreBody => 'سيُستبدل نص هذا البند في العقد بنسخة المكتبة الحالية:';

  @override
  String get restoreConfirm => 'استرجاع';

  @override
  String get restoreSame => 'نص البند مطابق للمكتبة.';

  @override
  String get restoreMissing => 'البند الأصلي لم يعد موجودًا في المكتبة.';

  @override
  String get saveToLibraryTitle => 'حفظ هذا النص في المكتبة؟';

  @override
  String saveToLibraryBody(String title) {
    return 'سيُستبدل نص البند «$title» في قالب المكتبة. العقود الموجودة لن تتغير.';
  }

  @override
  String get savedToLibrary => 'اتحفظ النص في المكتبة';

  @override
  String get pickLibraryClause => 'إضافة بند من المكتبة';

  @override
  String get searchClauses => 'ابحث في البنود';

  @override
  String get scopePhase => 'المرحلة';

  @override
  String get scopeItem => 'البند';

  @override
  String get scopeDescription => 'الوصف';

  @override
  String get scopeAcceptance => 'معيار القبول';

  @override
  String get addScopeRow => 'صف';

  @override
  String get outOfScope => 'خارج النطاق';

  @override
  String get outOfScopeHint => 'سطر لكل بند';

  @override
  String get contractTotal => 'إجمالي المقابل';

  @override
  String get milestoneLabel => 'الدفعة';

  @override
  String get milestoneShare => 'النسبة أو المبلغ';

  @override
  String get milestoneShareHint => '30% أو 25000';

  @override
  String get milestoneTrigger => 'الاستحقاق';

  @override
  String get milestoneTriggerHint => 'عند التوقيع';

  @override
  String get milestoneDue => 'تاريخ الاستحقاق';

  @override
  String get milestoneAmount => 'المبلغ';

  @override
  String get addMilestone => 'دفعة';

  @override
  String get milestonesBalanced => 'الدفعات = الإجمالي';

  @override
  String milestonesOff(String sum, String total, String diff) {
    return 'الدفعات $sum لا تساوي الإجمالي $total (فرق $diff)';
  }

  @override
  String milestonesPercentOff(String pct) {
    return 'مجموع النسب $pct% وليس 100%';
  }

  @override
  String get createInvoice => 'إنشاء فاتورة';

  @override
  String invoiceCreatedFromMilestone(String number, String label) {
    return 'فاتورة جديدة $number من «$label»';
  }

  @override
  String get milestoneNeedsAmount => 'حدد مبلغ الدفعة أولًا';

  @override
  String get noLinkedInvoices => 'لا توجد فواتير مرتبطة بعد. أنشئ فاتورة من أي دفعة، أو اكتب رقم العقد في «رقم العقد» داخل الفاتورة.';

  @override
  String get lockedBanner => 'هذا العقد موقّع، فهو للقراءة فقط. لأي تغيير أنشئ ملحق تعديل.';

  @override
  String unlockedBanner(String date) {
    return 'تم إلغاء قفل هذا العقد الموقّع في $date. التعديلات الآن تغيّر المستند الموقّع.';
  }

  @override
  String get createAmendment => 'ملحق تعديل';

  @override
  String get unlock => 'إلغاء القفل';

  @override
  String get relock => 'إعادة القفل';

  @override
  String get unlockTitle => 'إلغاء قفل عقد موقّع؟';

  @override
  String get unlockBody => 'التعديل بعد التوقيع يجعل نسختك مختلفة عن النسخة الموقّعة. الطريقة المعتادة هي ملحق تعديل. سيُسجَّل تاريخ إلغاء القفل في سجل العقد.';

  @override
  String statusBlocked(String status, String missing) {
    return 'لا يمكن تغيير الحالة إلى «$status»: $missing';
  }

  @override
  String amendmentCreated(String number) {
    return 'ملحق تعديل جديد: $number';
  }

  @override
  String amendmentOf(String number) {
    return 'ملحق للعقد $number';
  }

  @override
  String amendmentPreamble(String number, String date) {
    return 'إلحاقًا بالعقد رقم $number المؤرخ في $date بين الطرفين، اتفق الطرفان على تعديله على النحو التالي، وتظل باقي بنوده وملاحقه سارية دون تغيير.';
  }

  @override
  String get amendmentClauseTitle => 'موضوع التعديل';

  @override
  String contractDeleted(String number) {
    return 'اتحذف $number';
  }

  @override
  String contractHasInvoicesTitle(String number) {
    return '$number مرتبط بفواتير';
  }

  @override
  String contractHasInvoicesBody(String invoices) {
    return 'مرتبط بـ $invoices، فلا يمكن حذفه حتى لا تفقد الفواتير مرجعها. يمكنك إلغاؤه بدلًا من ذلك، أو أرشفة العميل.';
  }

  @override
  String get cancelContract => 'تحويل الحالة إلى «ملغي»';

  @override
  String get duplicateContract => 'تكرار كعقد جديد';

  @override
  String contractDuplicated(String number) {
    return 'عقد جديد: $number';
  }

  @override
  String get changeStatus => 'تغيير الحالة';

  @override
  String get history => 'سجل العقد';

  @override
  String get historyUnlock => 'إلغاء القفل';

  @override
  String get historyRelock => 'إعادة القفل';

  @override
  String historyStatus(String status) {
    return 'الحالة: $status';
  }

  @override
  String get libraryTitle => 'مكتبة البنود';

  @override
  String get librarySubtitle => 'القوالب والبنود التي تُنسخ في كل عقد جديد. تعديلها لا يغيّر العقود الموجودة.';

  @override
  String get openLibrary => 'فتح مكتبة البنود';

  @override
  String get newTemplate => 'قالب جديد';

  @override
  String get templateName => 'اسم القالب';

  @override
  String get templateKind => 'النوع';

  @override
  String get templateDefaults => 'القيم الافتراضية للمتغيرات';

  @override
  String get templateDefaultsHint => 'سطر لكل متغير: الاسم=القيمة';

  @override
  String get deleteTemplate => 'حذف القالب';

  @override
  String deleteTemplateBody(String name) {
    return 'سيُحذف القالب «$name» وبنوده من المكتبة. العقود المنشأة منه لن تتغير.';
  }

  @override
  String get enabledByDefault => 'مفعّل افتراضيًا';

  @override
  String get pickTemplateToEdit => 'اختر قالبًا لتعديله';

  @override
  String get draftNotLegalAdvice => 'النصوص المبدئية مسودة وليست استشارة قانونية؛ راجعها مع محامٍ.';

  @override
  String get contractsSettings => 'العقود';

  @override
  String get legalName => 'الاسم القانوني';

  @override
  String get nationalIdOrRegistry => 'الرقم القومي / السجل التجاري';

  @override
  String get address => 'العنوان';

  @override
  String get contractPrefix => 'بادئة أرقام العقود';

  @override
  String get quotePrefix => 'بادئة أرقام العروض';

  @override
  String get defaultJurisdiction => 'جهة الفصل الافتراضية';

  @override
  String get westernDigits => 'أرقام البنود الفرعية بالأرقام الغربية (1. بدلًا من ١.)';

  @override
  String get clientLegal => 'البيانات القانونية (للعقود)';

  @override
  String get clientRegistry => 'سجل تجاري / رقم قومي';

  @override
  String get clientRepresentative => 'الممثل القانوني';

  @override
  String get clientRepresentativeTitle => 'صفته';

  @override
  String clientHasDocumentsBody(String invoices, String contracts, String unpaid) {
    return 'عنده $invoices و$contracts، والمبلغ غير المدفوع: $unpaid.\nالأرشفة بتخفي العميل وفواتيره وعقوده من القائمة والبحث من غير ما تمسح حاجة، وتقدر ترجّعه من فلتر «مؤرشف».';
  }

  @override
  String clientDeletedWithDocuments(String name, String documents) {
    return 'اتحذف $name و$documents';
  }

  @override
  String confirmDeleteDocumentsBody(String documents) {
    return 'هيتحذف $documents، منها المدفوع والمُرسل والموقّع. هنعمل نسخة احتياطية الأول، وتقدر تتراجع لمدة ٨ ثواني.\nاكتب اسم العميل للتأكيد:';
  }

  @override
  String andJoin(String a, String b) {
    return '$a و$b';
  }

  @override
  String get trash => 'المحذوفات';

  @override
  String get trashEmptyState => 'المحذوفات فاضية.';

  @override
  String trashDeletedOn(String date) {
    return 'حُذف في $date';
  }

  @override
  String trashPurgeIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'يُحذف نهائيًا خلال $days يوم',
      few: 'يُحذف نهائيًا خلال $days أيام',
      two: 'يُحذف نهائيًا خلال يومين',
      one: 'يُحذف نهائيًا خلال يوم',
      zero: 'يُحذف نهائيًا اليوم',
    );
    return '$_temp0';
  }

  @override
  String get trashRestore => 'استعادة';

  @override
  String get trashPurge => 'حذف نهائي';

  @override
  String get trashEmpty => 'إفراغ المحذوفات';

  @override
  String trashOfClient(String name) {
    return 'لـ $name';
  }

  @override
  String get trashClientDeleted => 'العميل محذوف';

  @override
  String trashRestored(String label) {
    return 'اتسترجع $label';
  }

  @override
  String trashRestoredCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'اتسترجع $count عنصر',
      few: 'اتسترجع $count عناصر',
      two: 'اتسترجع عنصران',
      one: 'اتسترجع عنصر واحد',
    );
    return '$_temp0';
  }

  @override
  String trashNeedsClientTitle(String name) {
    return 'العميل $name في المحذوفات';
  }

  @override
  String trashNeedsClientBody(String label) {
    return 'لا يمكن استعادة $label وعميله محذوف. استعادة العميل معه؟ (العميل وحده، من غير باقي مستنداته المحذوفة)';
  }

  @override
  String get trashRestoreBoth => 'استعادة الاثنين';

  @override
  String trashPurgeTitle(String label) {
    return 'حذف $label نهائيًا؟';
  }

  @override
  String trashPurgeBody(String label) {
    return 'لا يمكن التراجع عن الحذف النهائي من داخل البرنامج. سنكتب نسخة احتياطية قبل الحذف.\nاكتب «$label» للتأكيد:';
  }

  @override
  String trashPurgeClientBody(String label) {
    return 'سيُحذف العميل $label نهائيًا مع كل فواتيره وعقوده المحذوفة. سنكتب نسخة احتياطية قبل الحذف.\nاكتب اسم العميل للتأكيد:';
  }

  @override
  String get trashEmptyTitle => 'إفراغ المحذوفات؟';

  @override
  String trashEmptyBody(String count) {
    return 'سيُحذف $count نهائيًا. سنكتب نسخة احتياطية قبل الحذف.\nاكتب «إفراغ» للتأكيد:';
  }

  @override
  String get trashEmptyWord => 'إفراغ';

  @override
  String trashItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر',
      few: '$count عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
    );
    return '$_temp0';
  }

  @override
  String trashPurged(String file) {
    return 'اتحذف نهائيًا. النسخة الاحتياطية: $file';
  }

  @override
  String get trashPurgeFailed => 'ماقدرناش نحذف نهائيًا';

  @override
  String undoOrTrash(String message) {
    return '$message — تراجع، أو من المحذوفات';
  }

  @override
  String get kindClientLabel => 'عميل';

  @override
  String get kindInvoiceLabel => 'فاتورة';

  @override
  String get cloudSync => 'المزامنة السحابية';

  @override
  String get cloudSyncOff => 'غير مفعّلة — قريبًا';

  @override
  String get cloudSyncOn => 'مفعّلة';

  @override
  String get cloudSyncBody => 'اشتراك اختياري لاحقًا: مزامنة مشفّرة من طرف إلى طرف بين أجهزتك. البرنامج المكتبي يظل مجانيًا وكاملًا بدونها، وبياناتك لا تغادر جهازك اليوم.';

  @override
  String get calendar => 'التقويم';

  @override
  String get invoicesAndContracts => 'الفواتير والعقود';

  @override
  String get viewMonth => 'شهر';

  @override
  String get viewWeek => 'أسبوع';

  @override
  String get viewAgenda => 'جدول';

  @override
  String get today => 'اليوم';

  @override
  String get previous => 'السابق';

  @override
  String get next => 'التالي';

  @override
  String get summaryExpected => 'متوقع تحصيله';

  @override
  String get summaryCollected => 'تم تحصيله';

  @override
  String get summaryLate => 'متأخر';

  @override
  String get evDue => 'واجب التحصيل';

  @override
  String get evOverdue => 'متأخر';

  @override
  String get evOverdueRollup => 'متأخرات';

  @override
  String get evPaid => 'تم الدفع';

  @override
  String get evPostponed => 'مؤجَّل';

  @override
  String get evMilestone => 'دفعة عقد مستحقة';

  @override
  String get evRenewal => 'تجديد';

  @override
  String get evContractStart => 'بداية عقد';

  @override
  String get evContractEnd => 'نهاية عقد';

  @override
  String get evWarrantyEnd => 'نهاية الضمان';

  @override
  String get evReminder => 'تذكير';

  @override
  String daysOverdue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days يومًا متأخرًا',
      few: '$days أيام متأخرة',
      two: 'يومان متأخران',
      one: 'يوم واحد متأخر',
    );
    return '$_temp0';
  }

  @override
  String overdueRollup(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count متأخرًا',
      few: '$count متأخرة',
      two: 'متأخرتان',
      one: 'متأخرة واحدة',
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
  String get filterClient => 'العميل';

  @override
  String get filterType => 'نوع الحدث';

  @override
  String get filterCurrency => 'العملة';

  @override
  String get allClients => 'كل العملاء';

  @override
  String get allTypes => 'كل الأنواع';

  @override
  String get allCurrencies => 'كل العملات';

  @override
  String get clearFilters => 'مسح الفلاتر';

  @override
  String get showPast => 'عرض السابق';

  @override
  String get agendaEmpty => 'لا أحداث قادمة مطابقة';

  @override
  String get dayEmpty => 'لا أحداث في هذا اليوم';

  @override
  String get searchCalendar => 'ابحث في التقويم';

  @override
  String get actOpen => 'فتح';

  @override
  String get actMarkPaid => 'تحديد كمدفوعة';

  @override
  String get actPostpone => 'تأجيل';

  @override
  String get actCopyReminder => 'نسخ رسالة تذكير';

  @override
  String get actCreateInvoice => 'إنشاء فاتورة';

  @override
  String get actOpenContract => 'فتح العقد';

  @override
  String get actRenewInvoice => 'إنشاء فاتورة تجديد';

  @override
  String get actEdit => 'تعديل';

  @override
  String get actMarkDone => 'تم';

  @override
  String get actReopen => 'إعادة فتح';

  @override
  String get actDelete => 'حذف';

  @override
  String get addReminder => '+ تذكير';

  @override
  String get postponeTitle => 'تأجيل الاستحقاق';

  @override
  String get postponeNewDate => 'التاريخ الجديد';

  @override
  String get postponeReason => 'السبب';

  @override
  String get postponeReasonHint => 'مثال: طلب العميل مهلة';

  @override
  String postponed(String date) {
    return 'تم التأجيل إلى $date';
  }

  @override
  String postponedFromTo(String from, String to) {
    return 'مؤجَّلة من $from إلى $to';
  }

  @override
  String get postponeHistory => 'سجل التأجيل';

  @override
  String get reminderNew => 'تذكير جديد';

  @override
  String get reminderEdit => 'تعديل التذكير';

  @override
  String get reminderText => 'النص';

  @override
  String get reminderTime => 'الوقت (اختياري، 24 ساعة)';

  @override
  String get reminderTimeHint => '10:30';

  @override
  String get errReminderText => 'اكتب نص التذكير';

  @override
  String get errTime => 'وقت غير صالح';

  @override
  String get reminderDeleted => 'حُذف التذكير';

  @override
  String get reminderCopied => 'نُسخت رسالة التذكير — الصقها في واتساب أو البريد';

  @override
  String get exportIcs => 'تصدير إلى التقويم (.ics)';

  @override
  String get exportIcsVisible => 'النطاق الظاهر';

  @override
  String get exportIcsFuture => 'كل الأحداث القادمة';

  @override
  String icsExported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حدثًا',
      few: '$count أحداث',
      two: 'صُدّر حدثان',
      one: 'صُدّر حدث واحد',
    );
    return '$_temp0';
  }

  @override
  String todayBanner(int due, int overdue) {
    String _temp0 = intl.Intl.pluralLogic(
      due,
      locale: localeName,
      other: '$due مستحق',
      few: '$due مستحقة',
      two: 'مستحقان',
      one: 'مستحق واحد',
    );
    String _temp1 = intl.Intl.pluralLogic(
      overdue,
      locale: localeName,
      other: '$overdue متأخر',
      few: '$overdue متأخرة',
      two: 'متأخران',
      one: 'متأخر واحد',
    );
    return 'اليوم: $_temp0 · $_temp1';
  }

  @override
  String get showInCalendar => 'عرض في التقويم';

  @override
  String get dismiss => 'إخفاء';

  @override
  String get profileBanner => 'أكمل بياناتك';

  @override
  String get profileBannerBody => 'أضف اسمك وبيانات الدفع لتظهر على الفواتير والعقود.';

  @override
  String get inCalendar => 'في التقويم';

  @override
  String get demoData => 'البيانات التجريبية';

  @override
  String get demoBody => 'عملاء وفواتير وعقود وهمية للتجربة. أي صف تعدّله يصبح من بياناتك ولا يُحذف معها.';

  @override
  String get demoAdd => 'إضافة بيانات تجريبية';

  @override
  String get demoRemove => 'حذف البيانات التجريبية';

  @override
  String get demoRemoveTitle => 'حذف البيانات التجريبية؟';

  @override
  String get demoRemoveBody => 'تُحذف نهائيًا الصفوف التجريبية فقط، بعد نسخة احتياطية. بياناتك لا تُمس.';

  @override
  String get demoAdded => 'أُضيفت البيانات التجريبية';

  @override
  String demoRemoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صفًا',
      few: '$count صفوف',
      two: 'صفان',
      one: 'صف واحد',
    );
    return 'حُذفت البيانات التجريبية ($_temp0)';
  }

  @override
  String get weekStart => 'بداية الأسبوع';

  @override
  String get weekdaySaturday => 'السبت';

  @override
  String get weekdaySunday => 'الأحد';

  @override
  String get weekdayMonday => 'الإثنين';

  @override
  String get notifyOnStart => 'إشعار عند التشغيل';

  @override
  String get notifyOnStartBody => 'إشعار سطح المكتب بما يستحق اليوم وما تأخر (إن كان متاحًا).';

  @override
  String get calendarShortcuts => 'الأسهم: تنقّل · PageUp/PageDown: شهر · T: اليوم · M/W/A: العرض · Enter: اليوم المحدد';

  @override
  String get dayTotal => 'مستحق اليوم';

  @override
  String get wdMon => 'الإثنين';

  @override
  String get wdTue => 'الثلاثاء';

  @override
  String get wdWed => 'الأربعاء';

  @override
  String get wdThu => 'الخميس';

  @override
  String get wdFri => 'الجمعة';

  @override
  String get wdSat => 'السبت';

  @override
  String get wdSun => 'الأحد';

  @override
  String get general => 'عام';

  @override
  String get uiLanguage => 'لغة الواجهة';

  @override
  String get uiLanguageSystem => 'لغة النظام';

  @override
  String get uiLanguageAr => 'العربية';

  @override
  String get uiLanguageEn => 'English';

  @override
  String get uiLanguageHint => 'يتبع البرنامج كل التطبيق هذه اللغة، بما في ذلك اتجاه القراءة.';

  @override
  String get docLanguage => 'لغة المستند';

  @override
  String get docLanguageAr => 'العربية';

  @override
  String get docLanguageEn => 'الإنجليزية';

  @override
  String get docLanguageBilingual => 'ثنائي اللغة (عربي / إنجليزي)';

  @override
  String get clientPreferredLanguage => 'لغة المستندات المفضلة';

  @override
  String get clientPreferredLanguageDefault => 'تتبع الإعدادات العامة';

  @override
  String get defaultDocLanguage => 'لغة المستندات الافتراضية';

  @override
  String get defaultDocLanguageHint => 'اللغة التي تبدأ بها المستندات الجديدة';

  @override
  String get docDigitStyle => 'أرقام المستندات العربية';

  @override
  String get docDigitStyleHint => 'طريقة كتابة الأرقام داخل النصوص العربية في ملفات الـ PDF';

  @override
  String get digitStyleWestern => 'أرقام غربية (123)';

  @override
  String get digitStyleArabicIndic => 'أرقام مشرقية (١٢٣)';

  @override
  String get warnNoPaymentMethod => 'أضف وسيلة دفع في الإعدادات';

  @override
  String get warnNoPaymentMethodHint => 'لن تظهر بطاقة بيانات الدفع في الفاتورة حتى تضيف وسيلة دفع واحدة على الأقل.';

  @override
  String get stylesTitle => 'تصميم المستندات';

  @override
  String get stylesSubtitle => 'اختر شكل الفواتير والعقود، أو صمّم شكلك الخاص.';

  @override
  String get stylesPresets => 'تصاميم جاهزة';

  @override
  String get stylesMine => 'تصاميمي';

  @override
  String get stylesNoneYet => 'لا توجد تصاميم خاصة بك بعد.';

  @override
  String get styleNewFromBlank => 'تصميم جديد من «أساسي»';

  @override
  String get styleImport => 'استيراد ملف تصميم…';

  @override
  String get styleDuplicate => 'نسخ';

  @override
  String get styleDuplicateToCustomize => 'انسخه لتعديله';

  @override
  String get styleRename => 'إعادة التسمية';

  @override
  String get styleResetToPreset => 'إرجاع إلى التصميم الأصلي';

  @override
  String styleResetConfirm(String name) {
    return 'ستعود ألوان «$name» وخطوطه وإعداداته إلى التصميم الأصلي، ويبقى الاسم والشعار.';
  }

  @override
  String get styleReset => 'إرجاع';

  @override
  String get styleExport => 'تصدير ملف تصميم…';

  @override
  String get styleDelete => 'حذف';

  @override
  String styleDeleted(String name) {
    return 'نُقل «$name» إلى المحذوفات';
  }

  @override
  String styleCopyName(String name) {
    return '$name (نسخة)';
  }

  @override
  String get styleNameLabel => 'اسم التصميم';

  @override
  String get styleNewName => 'تصميم جديد';

  @override
  String styleImported(String name) {
    return 'استُورد «$name»';
  }

  @override
  String get styleImportFailed => 'هذا الملف ليس ملف تصميم صالحًا.';

  @override
  String styleExported(String file) {
    return 'حُفظ التصميم في $file';
  }

  @override
  String get styleExportFailed => 'تعذّر حفظ ملف التصميم.';

  @override
  String get styleFileType => 'ملف تصميم';

  @override
  String get stylePresetReadOnly => 'التصاميم الجاهزة للقراءة فقط. انسخ واحدًا لتعديله.';

  @override
  String get stylePreviewInvoice => 'فاتورة';

  @override
  String get stylePreviewContract => 'عقد';

  @override
  String get stylePreviewSample => 'معاينة على فاتورة تجريبية';

  @override
  String get stylePreviewOpenDoc => 'معاينة على المستند المفتوح';

  @override
  String get styleGroupColours => 'الألوان';

  @override
  String get styleGroupFont => 'الخط والصفحة';

  @override
  String get styleGroupHeader => 'الترويسة والشعار';

  @override
  String get styleGroupTable => 'الجدول';

  @override
  String get styleGroupTotals => 'الإجماليات';

  @override
  String get styleGroupBlocks => 'الأجزاء الظاهرة';

  @override
  String get styleGroupFooter => 'التذييل';

  @override
  String get colourPrimary => 'اللون الأساسي';

  @override
  String get colourAccent => 'لون التمييز';

  @override
  String get colourInk => 'لون النص';

  @override
  String get colourMuted => 'النص الثانوي';

  @override
  String get colourSurface => 'خلفية البطاقات';

  @override
  String get colourTableHeader => 'خلفية رأس الجدول';

  @override
  String get colourBorder => 'الخطوط والحدود';

  @override
  String get colourPick => 'اختيار لون';

  @override
  String get colourHexInvalid => 'اكتب ٦ خانات ست عشرية، مثل 0F766E';

  @override
  String contrastWarning(String pair, String ratio) {
    return '$pair: التباين $ratio:1 أقل من 4.5:1، وقد تصعب قراءة النص.';
  }

  @override
  String get contrastInkOnPage => 'النص على الصفحة';

  @override
  String get contrastMutedOnPage => 'النص الثانوي على الصفحة';

  @override
  String get contrastPrimaryOnPage => 'العناوين على الصفحة';

  @override
  String get contrastInkOnSurface => 'النص على خلفية البطاقات';

  @override
  String get contrastMutedOnSurface => 'النص الثانوي على خلفية البطاقات';

  @override
  String get contrastMutedOnTableHeader => 'عناوين الجدول';

  @override
  String get contrastWhiteOnInk => 'نص الإجمالي على شريطه الداكن';

  @override
  String get contrastWhiteOnPrimary => 'نص الإجمالي على شريطه الملوّن';

  @override
  String get fontFamily => 'نوع الخط';

  @override
  String get fontPlex => 'IBM Plex Sans Arabic';

  @override
  String get fontNaskh => 'Noto Naskh Arabic';

  @override
  String get fontBaseSize => 'حجم الخط الأساسي';

  @override
  String get fontScale => 'تكبير النص';

  @override
  String get paperSize => 'حجم الورق';

  @override
  String get paperA4 => 'A4';

  @override
  String get paperLetter => 'Letter';

  @override
  String get marginSide => 'الهامش الجانبي';

  @override
  String get marginTop => 'الهامش العلوي';

  @override
  String get marginBottom => 'الهامش السفلي';

  @override
  String pointsValue(String value) {
    return '$value نقطة';
  }

  @override
  String get headerStyleLabel => 'شكل الترويسة';

  @override
  String get headerBand => 'شريط';

  @override
  String get headerRule => 'خط';

  @override
  String get headerNone => 'بدون';

  @override
  String get logoLabel => 'الشعار';

  @override
  String get logoChoose => 'اختيار صورة…';

  @override
  String get logoRemove => 'إزالة الشعار';

  @override
  String get logoHint => 'PNG أو JPG، حتى 1 ميجابايت';

  @override
  String get logoRejected => 'لم تُقبل الصورة: يجب أن تكون PNG أو JPG بحجم 1 ميجابايت أو أقل.';

  @override
  String get logoImageType => 'صورة';

  @override
  String get logoSize => 'حجم الشعار';

  @override
  String get logoPosition => 'موضع الشعار';

  @override
  String get positionStart => 'البداية';

  @override
  String get positionCenter => 'الوسط';

  @override
  String get positionEnd => 'النهاية';

  @override
  String get showRole => 'المسمّى الوظيفي';

  @override
  String get showCity => 'المدينة';

  @override
  String get showContacts => 'بيانات التواصل';

  @override
  String get tableStyleLabel => 'شكل الجدول';

  @override
  String get tablePlain => 'بسيط';

  @override
  String get tableStriped => 'صفوف متناوبة';

  @override
  String get tableBordered => 'بحدود';

  @override
  String get totalsStyleLabel => 'شكل الإجماليات';

  @override
  String get totalsOutlined => 'إطار';

  @override
  String get totalsSolid => 'ملوّن';

  @override
  String get totalsPlain => 'بسيط';

  @override
  String get showVatRow => 'سطر ضريبة القيمة المضافة';

  @override
  String get showPaidStamp => 'ختم «مدفوعة»';

  @override
  String get blockHeader => 'الترويسة';

  @override
  String get blockParties => 'الأطراف';

  @override
  String get blockItems => 'البنود';

  @override
  String get blockTotals => 'الإجماليات';

  @override
  String get blockNotes => 'الملاحظات';

  @override
  String get blockFooter => 'التذييل';

  @override
  String get blockRequired => 'أساسي';

  @override
  String get blocksHint => 'اسحب الأجزاء لتغيير ترتيبها في المستند.';

  @override
  String get showPaymentCard => 'بطاقة بيانات الدفع';

  @override
  String get showPleaseQuote => '«يُرجى ذكر رقم الفاتورة عند الدفع»';

  @override
  String get showPageNumbers => 'أرقام الصفحات';

  @override
  String get showSignatureBoxes => 'خانات التوقيع في العقود';

  @override
  String get footerAr => 'نص التذييل بالعربية';

  @override
  String get footerEn => 'نص التذييل بالإنجليزية';

  @override
  String get docStyle => 'تصميم المستند';

  @override
  String get docStyleFollows => 'حسب العميل أو الإعدادات';

  @override
  String get docStyleEdit => 'تعديل التصاميم…';

  @override
  String get styleLockedInvoice => 'التصميم مثبّت لأن الفاتورة أُرسلت';

  @override
  String get styleLockedContract => 'التصميم مثبّت لأن العقد وُقِّع';

  @override
  String get stylesSettings => 'تصاميم المستندات';

  @override
  String get defaultInvoiceStyle => 'تصميم الفواتير الافتراضي';

  @override
  String get defaultContractStyle => 'تصميم العقود الافتراضي';

  @override
  String get openStyleEditor => 'فتح محرّر التصاميم';

  @override
  String get presetClassic => 'كلاسيكي';

  @override
  String get presetModern => 'عصري';

  @override
  String get presetMinimal => 'بسيط';

  @override
  String get presetBold => 'بارز';

  @override
  String get presetFormal => 'رسمي';

  @override
  String get presetBlank => 'أساسي';

  @override
  String get styleMoreActions => 'إجراءات التصميم';

  @override
  String get previewFailed => 'تعذّر عرض المعاينة. يمكنك تصدير الملف كالمعتاد.';

  @override
  String styleUsageDrafts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مسودة',
      few: '$count مسودات',
      two: 'مسودتان',
      one: 'مسودة واحدة',
    );
    return '$_temp0';
  }

  @override
  String styleUsageClients(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عميلًا',
      few: '$count عملاء',
      two: 'عميلان',
      one: 'عميل واحد',
    );
    return '$_temp0';
  }

  @override
  String styleUsageAnd(String a, String b) {
    return '$a و$b';
  }

  @override
  String styleDeleteTitle(String name) {
    return 'حذف «$name»؟';
  }

  @override
  String styleDeleteInUse(String usage) {
    return 'يستخدم هذا التصميم $usage. بعد حذفه تعود إلى تصميم العميل، ثم التصميم الافتراضي، ثم «كلاسيكي».';
  }

  @override
  String styleDeletedInUse(String name, String usage) {
    return 'نُقل «$name» إلى المحذوفات، وكان يستخدمه $usage.';
  }
}
