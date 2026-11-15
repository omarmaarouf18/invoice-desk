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
    return '$count فاتورة';
  }

  @override
  String unpaidCount(int count) {
    return '$count غير مدفوعة';
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
    return 'نسخة بتاريخ $date تحتوي على $count فاتورة و$clients عميل.\nستُستبدل كل البيانات الحالية بها، وتُحفظ نسخة من بياناتك الحالية أولًا.';
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
}
