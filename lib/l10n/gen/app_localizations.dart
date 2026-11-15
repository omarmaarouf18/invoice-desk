// dart format off
// coverage:ignore-file
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'Invoice Desk'**
  String get appTitle;

  /// No description provided for @sidebarTitle.
  ///
  /// In ar, this message translates to:
  /// **'سجل الفواتير'**
  String get sidebarTitle;

  /// No description provided for @myProfile.
  ///
  /// In ar, this message translates to:
  /// **'بياناتي'**
  String get myProfile;

  /// No description provided for @searchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث باسم العميل أو رقم الفاتورة'**
  String get searchHint;

  /// No description provided for @newInvoice.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة جديدة'**
  String get newInvoice;

  /// No description provided for @newClient.
  ///
  /// In ar, this message translates to:
  /// **'عميل جديد'**
  String get newClient;

  /// No description provided for @filterAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get filterAll;

  /// No description provided for @filterUnpaid.
  ///
  /// In ar, this message translates to:
  /// **'غير مدفوعة'**
  String get filterUnpaid;

  /// No description provided for @filterOverdue.
  ///
  /// In ar, this message translates to:
  /// **'متأخرة'**
  String get filterOverdue;

  /// No description provided for @filterPaid.
  ///
  /// In ar, this message translates to:
  /// **'مدفوعة'**
  String get filterPaid;

  /// No description provided for @filterDrafts.
  ///
  /// In ar, this message translates to:
  /// **'مسودات'**
  String get filterDrafts;

  /// No description provided for @summaryUnpaid.
  ///
  /// In ar, this message translates to:
  /// **'غير مدفوع'**
  String get summaryUnpaid;

  /// No description provided for @summaryOverdue.
  ///
  /// In ar, this message translates to:
  /// **'متأخرة'**
  String get summaryOverdue;

  /// No description provided for @summaryNothingDue.
  ///
  /// In ar, this message translates to:
  /// **'لا مستحقات مفتوحة'**
  String get summaryNothingDue;

  /// No description provided for @invoiceCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} فاتورة'**
  String invoiceCount(int count);

  /// No description provided for @unpaidCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} غير مدفوعة'**
  String unpaidCount(int count);

  /// No description provided for @noResults.
  ///
  /// In ar, this message translates to:
  /// **'لا نتائج لـ «{query}»'**
  String noResults(String query);

  /// No description provided for @clearSearch.
  ///
  /// In ar, this message translates to:
  /// **'مسح البحث'**
  String get clearSearch;

  /// No description provided for @noInvoicesForClient.
  ///
  /// In ar, this message translates to:
  /// **'لا فواتير مطابقة'**
  String get noInvoicesForClient;

  /// No description provided for @noClientsYet.
  ///
  /// In ar, this message translates to:
  /// **'لا عملاء بعد'**
  String get noClientsYet;

  /// No description provided for @statusDraft.
  ///
  /// In ar, this message translates to:
  /// **'مسودة'**
  String get statusDraft;

  /// No description provided for @statusSent.
  ///
  /// In ar, this message translates to:
  /// **'مُرسلة'**
  String get statusSent;

  /// No description provided for @statusOverdue.
  ///
  /// In ar, this message translates to:
  /// **'متأخرة'**
  String get statusOverdue;

  /// No description provided for @statusPaid.
  ///
  /// In ar, this message translates to:
  /// **'مدفوعة'**
  String get statusPaid;

  /// No description provided for @statusVoid.
  ///
  /// In ar, this message translates to:
  /// **'ملغاة'**
  String get statusVoid;

  /// No description provided for @menuOpen.
  ///
  /// In ar, this message translates to:
  /// **'فتح'**
  String get menuOpen;

  /// No description provided for @menuDuplicate.
  ///
  /// In ar, this message translates to:
  /// **'تكرار'**
  String get menuDuplicate;

  /// No description provided for @menuRenew.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة تجديد'**
  String get menuRenew;

  /// No description provided for @menuMarkPaid.
  ///
  /// In ar, this message translates to:
  /// **'تحديد كمدفوعة'**
  String get menuMarkPaid;

  /// No description provided for @menuDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get menuDelete;

  /// No description provided for @menuEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get menuEdit;

  /// No description provided for @menuArchive.
  ///
  /// In ar, this message translates to:
  /// **'أرشفة'**
  String get menuArchive;

  /// No description provided for @menuUnarchive.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الأرشفة'**
  String get menuUnarchive;

  /// No description provided for @archived.
  ///
  /// In ar, this message translates to:
  /// **'مؤرشف'**
  String get archived;

  /// No description provided for @tabEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get tabEdit;

  /// No description provided for @tabPreview.
  ///
  /// In ar, this message translates to:
  /// **'معاينة'**
  String get tabPreview;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @exportPdf.
  ///
  /// In ar, this message translates to:
  /// **'PDF'**
  String get exportPdf;

  /// No description provided for @exportPdfLong.
  ///
  /// In ar, this message translates to:
  /// **'تصدير PDF'**
  String get exportPdfLong;

  /// No description provided for @more.
  ///
  /// In ar, this message translates to:
  /// **'المزيد'**
  String get more;

  /// No description provided for @saved.
  ///
  /// In ar, this message translates to:
  /// **'محفوظ'**
  String get saved;

  /// No description provided for @saving.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ الحفظ…'**
  String get saving;

  /// No description provided for @unsaved.
  ///
  /// In ar, this message translates to:
  /// **'تغييرات لم تُحفظ بعد'**
  String get unsaved;

  /// No description provided for @notSavedFix.
  ///
  /// In ar, this message translates to:
  /// **'لم تُحفظ — راجع الحقول'**
  String get notSavedFix;

  /// No description provided for @saveFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر الحفظ'**
  String get saveFailed;

  /// No description provided for @cardDetails.
  ///
  /// In ar, this message translates to:
  /// **'بيانات الفاتورة'**
  String get cardDetails;

  /// No description provided for @client.
  ///
  /// In ar, this message translates to:
  /// **'العميل'**
  String get client;

  /// No description provided for @chooseClient.
  ///
  /// In ar, this message translates to:
  /// **'اختر عميلًا'**
  String get chooseClient;

  /// No description provided for @invoiceNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الفاتورة'**
  String get invoiceNumber;

  /// No description provided for @issueDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الإصدار'**
  String get issueDate;

  /// No description provided for @dueDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الاستحقاق'**
  String get dueDate;

  /// No description provided for @contractRef.
  ///
  /// In ar, this message translates to:
  /// **'مرجع العقد'**
  String get contractRef;

  /// No description provided for @status.
  ///
  /// In ar, this message translates to:
  /// **'الحالة'**
  String get status;

  /// No description provided for @paidDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ السداد'**
  String get paidDate;

  /// No description provided for @cardSections.
  ///
  /// In ar, this message translates to:
  /// **'الأقسام والبنود'**
  String get cardSections;

  /// No description provided for @sectionTitleEn.
  ///
  /// In ar, this message translates to:
  /// **'عنوان القسم (EN)'**
  String get sectionTitleEn;

  /// No description provided for @sectionTitleAr.
  ///
  /// In ar, this message translates to:
  /// **'عنوان القسم (AR)'**
  String get sectionTitleAr;

  /// No description provided for @currency.
  ///
  /// In ar, this message translates to:
  /// **'العملة'**
  String get currency;

  /// No description provided for @deleteSection.
  ///
  /// In ar, this message translates to:
  /// **'حذف القسم'**
  String get deleteSection;

  /// No description provided for @addSection.
  ///
  /// In ar, this message translates to:
  /// **'إضافة قسم'**
  String get addSection;

  /// No description provided for @addItem.
  ///
  /// In ar, this message translates to:
  /// **'إضافة بند'**
  String get addItem;

  /// No description provided for @deleteItem.
  ///
  /// In ar, this message translates to:
  /// **'حذف البند'**
  String get deleteItem;

  /// No description provided for @dragToReorder.
  ///
  /// In ar, this message translates to:
  /// **'اسحب لإعادة الترتيب'**
  String get dragToReorder;

  /// No description provided for @colService.
  ///
  /// In ar, this message translates to:
  /// **'الخدمة'**
  String get colService;

  /// No description provided for @colDescription.
  ///
  /// In ar, this message translates to:
  /// **'الوصف'**
  String get colDescription;

  /// No description provided for @colCycle.
  ///
  /// In ar, this message translates to:
  /// **'الدورة'**
  String get colCycle;

  /// No description provided for @colQty.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get colQty;

  /// No description provided for @colUnitPrice.
  ///
  /// In ar, this message translates to:
  /// **'سعر الوحدة'**
  String get colUnitPrice;

  /// No description provided for @colLineTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get colLineTotal;

  /// No description provided for @cycleOneTime.
  ///
  /// In ar, this message translates to:
  /// **'مرة واحدة'**
  String get cycleOneTime;

  /// No description provided for @cycleMonthly.
  ///
  /// In ar, this message translates to:
  /// **'شهري'**
  String get cycleMonthly;

  /// No description provided for @cycleAnnual.
  ///
  /// In ar, this message translates to:
  /// **'سنوي'**
  String get cycleAnnual;

  /// No description provided for @subtotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي الفرعي'**
  String get subtotal;

  /// No description provided for @sectionN.
  ///
  /// In ar, this message translates to:
  /// **'القسم {n}'**
  String sectionN(int n);

  /// No description provided for @cardTotals.
  ///
  /// In ar, this message translates to:
  /// **'الإجماليات والضريبة'**
  String get cardTotals;

  /// No description provided for @vat.
  ///
  /// In ar, this message translates to:
  /// **'ضريبة القيمة المضافة'**
  String get vat;

  /// No description provided for @vatRate.
  ///
  /// In ar, this message translates to:
  /// **'النسبة %'**
  String get vatRate;

  /// No description provided for @vatLine.
  ///
  /// In ar, this message translates to:
  /// **'الضريبة'**
  String get vatLine;

  /// No description provided for @totalDue.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي المستحق'**
  String get totalDue;

  /// No description provided for @dueBy.
  ///
  /// In ar, this message translates to:
  /// **'مستحقة السداد في {date}'**
  String dueBy(String date);

  /// No description provided for @cardNotes.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات'**
  String get cardNotes;

  /// No description provided for @notesEn.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات بالإنجليزية — سطر لكل ملاحظة'**
  String get notesEn;

  /// No description provided for @notesAr.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات بالعربية — سطر لكل ملاحظة'**
  String get notesAr;

  /// No description provided for @cardScope.
  ///
  /// In ar, this message translates to:
  /// **'صفحة نطاق المشروع'**
  String get cardScope;

  /// No description provided for @scopeToggle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صفحة نطاق المشروع إلى الفاتورة'**
  String get scopeToggle;

  /// No description provided for @scopeTitle.
  ///
  /// In ar, this message translates to:
  /// **'عنوان المشروع'**
  String get scopeTitle;

  /// No description provided for @scopeOverview.
  ///
  /// In ar, this message translates to:
  /// **'نظرة عامة'**
  String get scopeOverview;

  /// No description provided for @scopeDone.
  ///
  /// In ar, this message translates to:
  /// **'ما تم تنفيذه — سطر لكل بند'**
  String get scopeDone;

  /// No description provided for @scopeDelivered.
  ///
  /// In ar, this message translates to:
  /// **'ما يستلمه العميل — سطر لكل بند'**
  String get scopeDelivered;

  /// No description provided for @scopeWarranty.
  ///
  /// In ar, this message translates to:
  /// **'الضمان والدعم'**
  String get scopeWarranty;

  /// No description provided for @errMissingClient.
  ///
  /// In ar, this message translates to:
  /// **'اختر العميل'**
  String get errMissingClient;

  /// No description provided for @errEmptyNumber.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم الفاتورة'**
  String get errEmptyNumber;

  /// No description provided for @errDuplicateNumber.
  ///
  /// In ar, this message translates to:
  /// **'هذا الرقم مستخدم في فاتورة أخرى'**
  String get errDuplicateNumber;

  /// No description provided for @errAmount.
  ///
  /// In ar, this message translates to:
  /// **'مبلغ غير صالح'**
  String get errAmount;

  /// No description provided for @errQty.
  ///
  /// In ar, this message translates to:
  /// **'كمية غير صالحة'**
  String get errQty;

  /// No description provided for @errRate.
  ///
  /// In ar, this message translates to:
  /// **'نسبة غير صالحة'**
  String get errRate;

  /// No description provided for @exportedPdf.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ {name}'**
  String exportedPdf(String name);

  /// No description provided for @openFile.
  ///
  /// In ar, this message translates to:
  /// **'فتح الملف'**
  String get openFile;

  /// No description provided for @openFolder.
  ///
  /// In ar, this message translates to:
  /// **'فتح المجلد'**
  String get openFolder;

  /// No description provided for @exportFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر حفظ الملف'**
  String get exportFailed;

  /// No description provided for @deleted.
  ///
  /// In ar, this message translates to:
  /// **'اتحذفت {number}'**
  String deleted(String number);

  /// No description provided for @undo.
  ///
  /// In ar, this message translates to:
  /// **'تراجع'**
  String get undo;

  /// No description provided for @renewNone.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بنود شهرية أو سنوية في {number} لتجديدها'**
  String renewNone(String number);

  /// No description provided for @renewCreated.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة تجديد جديدة: {number}'**
  String renewCreated(String number);

  /// No description provided for @duplicated.
  ///
  /// In ar, this message translates to:
  /// **'نسخة جديدة: {number}'**
  String duplicated(String number);

  /// No description provided for @markedPaid.
  ///
  /// In ar, this message translates to:
  /// **'{number} مدفوعة'**
  String markedPaid(String number);

  /// No description provided for @nothingOpen.
  ///
  /// In ar, this message translates to:
  /// **'افتح فاتورة أولًا'**
  String get nothingOpen;

  /// No description provided for @clientDialogNew.
  ///
  /// In ar, this message translates to:
  /// **'عميل جديد'**
  String get clientDialogNew;

  /// No description provided for @clientDialogEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل العميل'**
  String get clientDialogEdit;

  /// No description provided for @clientName.
  ///
  /// In ar, this message translates to:
  /// **'اسم العميل'**
  String get clientName;

  /// No description provided for @clientContact.
  ///
  /// In ar, this message translates to:
  /// **'الشخص المسؤول'**
  String get clientContact;

  /// No description provided for @clientCity.
  ///
  /// In ar, this message translates to:
  /// **'المدينة'**
  String get clientCity;

  /// No description provided for @clientPhone.
  ///
  /// In ar, this message translates to:
  /// **'الهاتف'**
  String get clientPhone;

  /// No description provided for @clientEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get clientEmail;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @errClientName.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم العميل'**
  String get errClientName;

  /// No description provided for @settingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'بياناتي'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تظهر هذه البيانات على كل فاتورة. تُحفظ تلقائيًا.'**
  String get settingsSubtitle;

  /// No description provided for @back.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get back;

  /// No description provided for @profile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get profile;

  /// No description provided for @name.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get name;

  /// No description provided for @role.
  ///
  /// In ar, this message translates to:
  /// **'المسمى الوظيفي'**
  String get role;

  /// No description provided for @city.
  ///
  /// In ar, this message translates to:
  /// **'المدينة'**
  String get city;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In ar, this message translates to:
  /// **'الهاتف'**
  String get phone;

  /// No description provided for @website.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get website;

  /// No description provided for @invoicing.
  ///
  /// In ar, this message translates to:
  /// **'الترقيم والاستحقاق'**
  String get invoicing;

  /// No description provided for @invoicePrefix.
  ///
  /// In ar, this message translates to:
  /// **'بادئة الترقيم'**
  String get invoicePrefix;

  /// No description provided for @prefixHint.
  ///
  /// In ar, this message translates to:
  /// **'تُطبّق على الفواتير الجديدة فقط'**
  String get prefixHint;

  /// No description provided for @defaultDueDays.
  ///
  /// In ar, this message translates to:
  /// **'أيام الاستحقاق الافتراضية'**
  String get defaultDueDays;

  /// No description provided for @payment.
  ///
  /// In ar, this message translates to:
  /// **'بيانات الدفع'**
  String get payment;

  /// No description provided for @instapay.
  ///
  /// In ar, this message translates to:
  /// **'InstaPay'**
  String get instapay;

  /// No description provided for @wallet.
  ///
  /// In ar, this message translates to:
  /// **'المحفظة الإلكترونية'**
  String get wallet;

  /// No description provided for @bankIban.
  ///
  /// In ar, this message translates to:
  /// **'البنك / IBAN'**
  String get bankIban;

  /// No description provided for @defaultNotes.
  ///
  /// In ar, this message translates to:
  /// **'الملاحظات الافتراضية'**
  String get defaultNotes;

  /// No description provided for @appearance.
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get appearance;

  /// No description provided for @themeSystem.
  ///
  /// In ar, this message translates to:
  /// **'حسب النظام'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In ar, this message translates to:
  /// **'فاتح'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ar, this message translates to:
  /// **'داكن'**
  String get themeDark;

  /// No description provided for @backup.
  ///
  /// In ar, this message translates to:
  /// **'النسخ الاحتياطي والتصدير'**
  String get backup;

  /// No description provided for @backupDir.
  ///
  /// In ar, this message translates to:
  /// **'مجلد النسخ الاحتياطية'**
  String get backupDir;

  /// No description provided for @chooseFolder.
  ///
  /// In ar, this message translates to:
  /// **'اختيار مجلد…'**
  String get chooseFolder;

  /// No description provided for @backupNow.
  ///
  /// In ar, this message translates to:
  /// **'نسخ احتياطي الآن'**
  String get backupNow;

  /// No description provided for @restore.
  ///
  /// In ar, this message translates to:
  /// **'استعادة من نسخة'**
  String get restore;

  /// No description provided for @exportCsv.
  ///
  /// In ar, this message translates to:
  /// **'تصدير CSV للمحاسب'**
  String get exportCsv;

  /// No description provided for @lastBackup.
  ///
  /// In ar, this message translates to:
  /// **'آخر نسخة: {date}'**
  String lastBackup(String date);

  /// No description provided for @never.
  ///
  /// In ar, this message translates to:
  /// **'لم تُؤخذ أي نسخة بعد'**
  String get never;

  /// No description provided for @backupAuto.
  ///
  /// In ar, this message translates to:
  /// **'تُؤخذ نسخة تلقائيًا عند فتح التطبيق إذا مرّ يوم على آخر نسخة، ويُحتفظ بآخر 30 نسخة.'**
  String get backupAuto;

  /// No description provided for @backupDone.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ النسخة الاحتياطية'**
  String get backupDone;

  /// No description provided for @backupFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر أخذ النسخة الاحتياطية'**
  String get backupFailed;

  /// No description provided for @restoreConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'استعادة هذه النسخة؟'**
  String get restoreConfirmTitle;

  /// No description provided for @restoreConfirmBody.
  ///
  /// In ar, this message translates to:
  /// **'نسخة بتاريخ {date} تحتوي على {count} فاتورة و{clients} عميل.\nستُستبدل كل البيانات الحالية بها، وتُحفظ نسخة من بياناتك الحالية أولًا.'**
  String restoreConfirmBody(String date, int count, int clients);

  /// No description provided for @restoreAction.
  ///
  /// In ar, this message translates to:
  /// **'استعادة'**
  String get restoreAction;

  /// No description provided for @restoreDone.
  ///
  /// In ar, this message translates to:
  /// **'تمت الاستعادة'**
  String get restoreDone;

  /// No description provided for @restoreBad.
  ///
  /// In ar, this message translates to:
  /// **'الملف ليس نسخة صالحة من Invoice Desk'**
  String get restoreBad;

  /// No description provided for @csvDone.
  ///
  /// In ar, this message translates to:
  /// **'تم تصدير {name}'**
  String csvDone(String name);

  /// No description provided for @emptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'أهلًا بك في Invoice Desk'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In ar, this message translates to:
  /// **'خطوتان وتبدأ أول فاتورة.'**
  String get emptyBody;

  /// No description provided for @stepProfile.
  ///
  /// In ar, this message translates to:
  /// **'أضف بياناتك'**
  String get stepProfile;

  /// No description provided for @stepProfileBody.
  ///
  /// In ar, this message translates to:
  /// **'الاسم وبيانات الدفع التي تظهر على الفاتورة.'**
  String get stepProfileBody;

  /// No description provided for @stepClient.
  ///
  /// In ar, this message translates to:
  /// **'أضف أول عميل'**
  String get stepClient;

  /// No description provided for @stepClientBody.
  ///
  /// In ar, this message translates to:
  /// **'اسم العميل ورقم التواصل.'**
  String get stepClientBody;

  /// No description provided for @stepInvoice.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ أول فاتورة'**
  String get stepInvoice;

  /// No description provided for @done.
  ///
  /// In ar, this message translates to:
  /// **'تم'**
  String get done;

  /// No description provided for @pickInvoice.
  ///
  /// In ar, this message translates to:
  /// **'اختر فاتورة من السجل'**
  String get pickInvoice;

  /// No description provided for @pickInvoiceBody.
  ///
  /// In ar, this message translates to:
  /// **'أو أنشئ فاتورة جديدة لتبدأ.'**
  String get pickInvoiceBody;

  /// No description provided for @dbErrorTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر فتح قاعدة البيانات'**
  String get dbErrorTitle;

  /// No description provided for @dbErrorBody.
  ///
  /// In ar, this message translates to:
  /// **'قد يكون الملف تالفًا أو مستخدمًا من نسخة أخرى من التطبيق. يمكنك الاستعادة من آخر نسخة احتياطية.'**
  String get dbErrorBody;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @previewLoading.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ تجهيز المعاينة…'**
  String get previewLoading;

  /// No description provided for @shortcutsHint.
  ///
  /// In ar, this message translates to:
  /// **'اختصارات: Ctrl+N فاتورة · Ctrl+K بحث · Ctrl+S حفظ · Ctrl+E PDF'**
  String get shortcutsHint;

  /// No description provided for @about.
  ///
  /// In ar, this message translates to:
  /// **'حول البرنامج'**
  String get about;

  /// No description provided for @aboutVersion.
  ///
  /// In ar, this message translates to:
  /// **'الإصدار {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutBody.
  ///
  /// In ar, this message translates to:
  /// **'برنامج فواتير يعمل دون اتصال. بياناتك محفوظة على هذا الجهاز فقط.'**
  String get aboutBody;

  /// No description provided for @aboutDataDir.
  ///
  /// In ar, this message translates to:
  /// **'مجلد البيانات'**
  String get aboutDataDir;

  /// No description provided for @notTaxInvoice.
  ///
  /// In ar, this message translates to:
  /// **'ليست فاتورة ضريبية إلكترونية رسمية.'**
  String get notTaxInvoice;

  /// No description provided for @menuDeleteClient.
  ///
  /// In ar, this message translates to:
  /// **'حذف العميل'**
  String get menuDeleteClient;

  /// No description provided for @clientDeleted.
  ///
  /// In ar, this message translates to:
  /// **'اتحذف العميل {name}'**
  String clientDeleted(String name);

  /// No description provided for @clientArchivedSnack.
  ///
  /// In ar, this message translates to:
  /// **'اتأرشف {name} وفواتيره'**
  String clientArchivedSnack(String name);

  /// No description provided for @clientHasInvoicesTitle.
  ///
  /// In ar, this message translates to:
  /// **'{name} عنده فواتير'**
  String clientHasInvoicesTitle(String name);

  /// No description provided for @clientHasInvoicesBody.
  ///
  /// In ar, this message translates to:
  /// **'عنده {invoices}، والمبلغ غير المدفوع: {unpaid}.\nالأرشفة بتخفي العميل وفواتيره من القائمة والبحث من غير ما تمسح حاجة، وتقدر ترجّعه من فلتر «مؤرشف».'**
  String clientHasInvoicesBody(String invoices, String unpaid);

  /// No description provided for @archiveRecommended.
  ///
  /// In ar, this message translates to:
  /// **'أرشفة (مُستحسن)'**
  String get archiveRecommended;

  /// No description provided for @deleteClientAndInvoices.
  ///
  /// In ar, this message translates to:
  /// **'حذف العميل وكل فواتيره'**
  String get deleteClientAndInvoices;

  /// No description provided for @confirmDeleteAllTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف {name} وكل فواتيره؟'**
  String confirmDeleteAllTitle(String name);

  /// No description provided for @confirmDeleteAllBody.
  ///
  /// In ar, this message translates to:
  /// **'هيتحذف {invoices}، منها المدفوع والمُرسل. هنعمل نسخة احتياطية الأول، وتقدر تتراجع لمدة ٨ ثواني.\nاكتب اسم العميل للتأكيد:'**
  String confirmDeleteAllBody(String invoices);

  /// No description provided for @clientDeletedWithInvoices.
  ///
  /// In ar, this message translates to:
  /// **'اتحذف {name} و{invoices}'**
  String clientDeletedWithInvoices(String name, String invoices);

  /// No description provided for @deleteBackupFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشلت النسخة الاحتياطية، فما اتحذفش حاجة'**
  String get deleteBackupFailed;

  /// No description provided for @clientDeleteFailed.
  ///
  /// In ar, this message translates to:
  /// **'ماقدرناش نحذف العميل'**
  String get clientDeleteFailed;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
