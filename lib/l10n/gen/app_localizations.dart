// dart format off
// coverage:ignore-file
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en')
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
  /// **'{count, plural, =1{فاتورة واحدة} =2{فاتورتان} few{{count} فواتير} other{{count} فاتورة}}'**
  String invoiceCount(int count);

  /// No description provided for @unpaidCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{غير مدفوعة واحدة} =2{غير مدفوعتان} few{{count} غير مدفوعة} other{{count} غير مدفوعة}}'**
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
  /// **'نسخة بتاريخ {date} تحتوي على {count, plural, =1{فاتورة واحدة} =2{فاتورتان} few{{count} فواتير} other{{count} فاتورة}} و{clients, plural, =1{عميل واحد} =2{عميلان} few{{count} عملاء} other{{count} عميلًا}}.\nستُستبدل كل البيانات الحالية بها، وتُحفظ نسخة من بياناتك الحالية أولًا.'**
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

  /// No description provided for @newContract.
  ///
  /// In ar, this message translates to:
  /// **'عقد جديد'**
  String get newContract;

  /// No description provided for @groupContracts.
  ///
  /// In ar, this message translates to:
  /// **'العقود ({count, plural, =1{1} other{{count}}})'**
  String groupContracts(int count);

  /// No description provided for @groupInvoices.
  ///
  /// In ar, this message translates to:
  /// **'الفواتير ({count, plural, =1{1} other{{count}}})'**
  String groupInvoices(int count);

  /// No description provided for @filterContractsInForce.
  ///
  /// In ar, this message translates to:
  /// **'عقود سارية'**
  String get filterContractsInForce;

  /// No description provided for @contractCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{عقد واحد} =2{عقدان} few{{count} عقود} other{{count} عقدًا}}'**
  String contractCount(int count);

  /// No description provided for @cStatusDraft.
  ///
  /// In ar, this message translates to:
  /// **'مسودة'**
  String get cStatusDraft;

  /// No description provided for @cStatusSent.
  ///
  /// In ar, this message translates to:
  /// **'مُرسل'**
  String get cStatusSent;

  /// No description provided for @cStatusSigned.
  ///
  /// In ar, this message translates to:
  /// **'موقّع'**
  String get cStatusSigned;

  /// No description provided for @cStatusActive.
  ///
  /// In ar, this message translates to:
  /// **'ساري'**
  String get cStatusActive;

  /// No description provided for @cStatusCompleted.
  ///
  /// In ar, this message translates to:
  /// **'مكتمل'**
  String get cStatusCompleted;

  /// No description provided for @cStatusCancelled.
  ///
  /// In ar, this message translates to:
  /// **'ملغي'**
  String get cStatusCancelled;

  /// No description provided for @kindContract.
  ///
  /// In ar, this message translates to:
  /// **'عقد'**
  String get kindContract;

  /// No description provided for @kindQuote.
  ///
  /// In ar, this message translates to:
  /// **'عرض سعر'**
  String get kindQuote;

  /// No description provided for @kindAmendment.
  ///
  /// In ar, this message translates to:
  /// **'ملحق تعديل'**
  String get kindAmendment;

  /// No description provided for @newContractTitle.
  ///
  /// In ar, this message translates to:
  /// **'عقد جديد'**
  String get newContractTitle;

  /// No description provided for @chooseTemplate.
  ///
  /// In ar, this message translates to:
  /// **'اختر القالب'**
  String get chooseTemplate;

  /// No description provided for @clauseCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{بند واحد} =2{بندان} few{{count} بنود} other{{count} بندًا}}'**
  String clauseCount(int count);

  /// No description provided for @contractTitle.
  ///
  /// In ar, this message translates to:
  /// **'عنوان العقد'**
  String get contractTitle;

  /// No description provided for @contractTitleHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: تطوير وتشغيل منصة تعليمية'**
  String get contractTitleHint;

  /// No description provided for @projectName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المشروع'**
  String get projectName;

  /// No description provided for @projectSummary.
  ///
  /// In ar, this message translates to:
  /// **'ملخص المشروع'**
  String get projectSummary;

  /// No description provided for @create.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء'**
  String get create;

  /// No description provided for @noTemplates.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد قوالب في المكتبة. أضف قالبًا من الإعدادات ← مكتبة البنود.'**
  String get noTemplates;

  /// No description provided for @cardContractDetails.
  ///
  /// In ar, this message translates to:
  /// **'بيانات العقد'**
  String get cardContractDetails;

  /// No description provided for @cardVariables.
  ///
  /// In ar, this message translates to:
  /// **'المتغيرات'**
  String get cardVariables;

  /// No description provided for @cardClauses.
  ///
  /// In ar, this message translates to:
  /// **'البنود'**
  String get cardClauses;

  /// No description provided for @cardScopeAnnex.
  ///
  /// In ar, this message translates to:
  /// **'ملحق (1) نطاق العمل'**
  String get cardScopeAnnex;

  /// No description provided for @cardPaymentAnnex.
  ///
  /// In ar, this message translates to:
  /// **'ملحق (2) المقابل والدفعات'**
  String get cardPaymentAnnex;

  /// No description provided for @cardLinkedInvoices.
  ///
  /// In ar, this message translates to:
  /// **'الفواتير المرتبطة'**
  String get cardLinkedInvoices;

  /// No description provided for @contractNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم العقد'**
  String get contractNumber;

  /// No description provided for @startDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ البدء'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الانتهاء'**
  String get endDate;

  /// No description provided for @signedDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ التوقيع'**
  String get signedDate;

  /// No description provided for @jurisdiction.
  ///
  /// In ar, this message translates to:
  /// **'جهة الفصل في النزاعات'**
  String get jurisdiction;

  /// No description provided for @clearDate.
  ///
  /// In ar, this message translates to:
  /// **'مسح التاريخ'**
  String get clearDate;

  /// No description provided for @preamble.
  ///
  /// In ar, this message translates to:
  /// **'التمهيد'**
  String get preamble;

  /// No description provided for @closingLine.
  ///
  /// In ar, this message translates to:
  /// **'سطر الختام'**
  String get closingLine;

  /// No description provided for @missingVariables.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{متغير واحد ناقص} =2{متغيران ناقصان} few{{count} متغيرات ناقصة} other{{count} متغير ناقص}}'**
  String missingVariables(int count);

  /// No description provided for @allVariablesFilled.
  ///
  /// In ar, this message translates to:
  /// **'كل المتغيرات مكتملة'**
  String get allVariablesFilled;

  /// No description provided for @noCustomVariables.
  ///
  /// In ar, this message translates to:
  /// **'البنود المفعّلة لا تستخدم متغيرات خاصة.'**
  String get noCustomVariables;

  /// No description provided for @builtInMissing.
  ///
  /// In ar, this message translates to:
  /// **'ناقص من بيانات {source}'**
  String builtInMissing(String source);

  /// No description provided for @sourceClient.
  ///
  /// In ar, this message translates to:
  /// **'العميل'**
  String get sourceClient;

  /// No description provided for @sourceSettings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get sourceSettings;

  /// No description provided for @sourceContract.
  ///
  /// In ar, this message translates to:
  /// **'العقد'**
  String get sourceContract;

  /// No description provided for @editClientData.
  ///
  /// In ar, this message translates to:
  /// **'تعديل بيانات العميل'**
  String get editClientData;

  /// No description provided for @openSettings.
  ///
  /// In ar, this message translates to:
  /// **'فتح الإعدادات'**
  String get openSettings;

  /// No description provided for @variablesHelp.
  ///
  /// In ar, this message translates to:
  /// **'اكتب قوسين معقوفين مزدوجين داخل أي بند لإدراج متغير. القيم هنا تخص هذا العقد فقط.'**
  String get variablesHelp;

  /// No description provided for @optionalTag.
  ///
  /// In ar, this message translates to:
  /// **'اختياري'**
  String get optionalTag;

  /// No description provided for @clauseEnabled.
  ///
  /// In ar, this message translates to:
  /// **'مفعّل'**
  String get clauseEnabled;

  /// No description provided for @clauseTitle.
  ///
  /// In ar, this message translates to:
  /// **'عنوان البند'**
  String get clauseTitle;

  /// No description provided for @clauseBody.
  ///
  /// In ar, this message translates to:
  /// **'نص البند'**
  String get clauseBody;

  /// No description provided for @clauseBodyHelp.
  ///
  /// In ar, this message translates to:
  /// **'الأسطر التي تبدأ بـ «- » تصبح بنودًا فرعية مرقمة.'**
  String get clauseBodyHelp;

  /// No description provided for @addClause.
  ///
  /// In ar, this message translates to:
  /// **'بند'**
  String get addClause;

  /// No description provided for @addBlankClause.
  ///
  /// In ar, this message translates to:
  /// **'بند فارغ'**
  String get addBlankClause;

  /// No description provided for @addFromLibrary.
  ///
  /// In ar, this message translates to:
  /// **'من المكتبة…'**
  String get addFromLibrary;

  /// No description provided for @restoreFromLibrary.
  ///
  /// In ar, this message translates to:
  /// **'استرجاع النص من المكتبة'**
  String get restoreFromLibrary;

  /// No description provided for @saveToLibrary.
  ///
  /// In ar, this message translates to:
  /// **'حفظ في المكتبة'**
  String get saveToLibrary;

  /// No description provided for @duplicateClause.
  ///
  /// In ar, this message translates to:
  /// **'تكرار'**
  String get duplicateClause;

  /// No description provided for @deleteClause.
  ///
  /// In ar, this message translates to:
  /// **'حذف البند'**
  String get deleteClause;

  /// No description provided for @restoreTitle.
  ///
  /// In ar, this message translates to:
  /// **'استرجاع نص المكتبة؟'**
  String get restoreTitle;

  /// No description provided for @restoreBody.
  ///
  /// In ar, this message translates to:
  /// **'سيُستبدل نص هذا البند في العقد بنسخة المكتبة الحالية:'**
  String get restoreBody;

  /// No description provided for @restoreConfirm.
  ///
  /// In ar, this message translates to:
  /// **'استرجاع'**
  String get restoreConfirm;

  /// No description provided for @restoreSame.
  ///
  /// In ar, this message translates to:
  /// **'نص البند مطابق للمكتبة.'**
  String get restoreSame;

  /// No description provided for @restoreMissing.
  ///
  /// In ar, this message translates to:
  /// **'البند الأصلي لم يعد موجودًا في المكتبة.'**
  String get restoreMissing;

  /// No description provided for @saveToLibraryTitle.
  ///
  /// In ar, this message translates to:
  /// **'حفظ هذا النص في المكتبة؟'**
  String get saveToLibraryTitle;

  /// No description provided for @saveToLibraryBody.
  ///
  /// In ar, this message translates to:
  /// **'سيُستبدل نص البند «{title}» في قالب المكتبة. العقود الموجودة لن تتغير.'**
  String saveToLibraryBody(String title);

  /// No description provided for @savedToLibrary.
  ///
  /// In ar, this message translates to:
  /// **'اتحفظ النص في المكتبة'**
  String get savedToLibrary;

  /// No description provided for @pickLibraryClause.
  ///
  /// In ar, this message translates to:
  /// **'إضافة بند من المكتبة'**
  String get pickLibraryClause;

  /// No description provided for @searchClauses.
  ///
  /// In ar, this message translates to:
  /// **'ابحث في البنود'**
  String get searchClauses;

  /// No description provided for @scopePhase.
  ///
  /// In ar, this message translates to:
  /// **'المرحلة'**
  String get scopePhase;

  /// No description provided for @scopeItem.
  ///
  /// In ar, this message translates to:
  /// **'البند'**
  String get scopeItem;

  /// No description provided for @scopeDescription.
  ///
  /// In ar, this message translates to:
  /// **'الوصف'**
  String get scopeDescription;

  /// No description provided for @scopeAcceptance.
  ///
  /// In ar, this message translates to:
  /// **'معيار القبول'**
  String get scopeAcceptance;

  /// No description provided for @addScopeRow.
  ///
  /// In ar, this message translates to:
  /// **'صف'**
  String get addScopeRow;

  /// No description provided for @outOfScope.
  ///
  /// In ar, this message translates to:
  /// **'خارج النطاق'**
  String get outOfScope;

  /// No description provided for @outOfScopeHint.
  ///
  /// In ar, this message translates to:
  /// **'سطر لكل بند'**
  String get outOfScopeHint;

  /// No description provided for @contractTotal.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المقابل'**
  String get contractTotal;

  /// No description provided for @milestoneLabel.
  ///
  /// In ar, this message translates to:
  /// **'الدفعة'**
  String get milestoneLabel;

  /// No description provided for @milestoneShare.
  ///
  /// In ar, this message translates to:
  /// **'النسبة أو المبلغ'**
  String get milestoneShare;

  /// No description provided for @milestoneShareHint.
  ///
  /// In ar, this message translates to:
  /// **'30% أو 25000'**
  String get milestoneShareHint;

  /// No description provided for @milestoneTrigger.
  ///
  /// In ar, this message translates to:
  /// **'الاستحقاق'**
  String get milestoneTrigger;

  /// No description provided for @milestoneTriggerHint.
  ///
  /// In ar, this message translates to:
  /// **'عند التوقيع'**
  String get milestoneTriggerHint;

  /// No description provided for @milestoneDue.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الاستحقاق'**
  String get milestoneDue;

  /// No description provided for @milestoneAmount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ'**
  String get milestoneAmount;

  /// No description provided for @addMilestone.
  ///
  /// In ar, this message translates to:
  /// **'دفعة'**
  String get addMilestone;

  /// No description provided for @milestonesBalanced.
  ///
  /// In ar, this message translates to:
  /// **'الدفعات = الإجمالي'**
  String get milestonesBalanced;

  /// No description provided for @milestonesOff.
  ///
  /// In ar, this message translates to:
  /// **'الدفعات {sum} لا تساوي الإجمالي {total} (فرق {diff})'**
  String milestonesOff(String sum, String total, String diff);

  /// No description provided for @milestonesPercentOff.
  ///
  /// In ar, this message translates to:
  /// **'مجموع النسب {pct}% وليس 100%'**
  String milestonesPercentOff(String pct);

  /// No description provided for @createInvoice.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء فاتورة'**
  String get createInvoice;

  /// No description provided for @invoiceCreatedFromMilestone.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة جديدة {number} من «{label}»'**
  String invoiceCreatedFromMilestone(String number, String label);

  /// No description provided for @milestoneNeedsAmount.
  ///
  /// In ar, this message translates to:
  /// **'حدد مبلغ الدفعة أولًا'**
  String get milestoneNeedsAmount;

  /// No description provided for @noLinkedInvoices.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد فواتير مرتبطة بعد. أنشئ فاتورة من أي دفعة، أو اكتب رقم العقد في «رقم العقد» داخل الفاتورة.'**
  String get noLinkedInvoices;

  /// No description provided for @lockedBanner.
  ///
  /// In ar, this message translates to:
  /// **'هذا العقد موقّع، فهو للقراءة فقط. لأي تغيير أنشئ ملحق تعديل.'**
  String get lockedBanner;

  /// No description provided for @unlockedBanner.
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء قفل هذا العقد الموقّع في {date}. التعديلات الآن تغيّر المستند الموقّع.'**
  String unlockedBanner(String date);

  /// No description provided for @createAmendment.
  ///
  /// In ar, this message translates to:
  /// **'ملحق تعديل'**
  String get createAmendment;

  /// No description provided for @unlock.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء القفل'**
  String get unlock;

  /// No description provided for @relock.
  ///
  /// In ar, this message translates to:
  /// **'إعادة القفل'**
  String get relock;

  /// No description provided for @unlockTitle.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء قفل عقد موقّع؟'**
  String get unlockTitle;

  /// No description provided for @unlockBody.
  ///
  /// In ar, this message translates to:
  /// **'التعديل بعد التوقيع يجعل نسختك مختلفة عن النسخة الموقّعة. الطريقة المعتادة هي ملحق تعديل. سيُسجَّل تاريخ إلغاء القفل في سجل العقد.'**
  String get unlockBody;

  /// No description provided for @statusBlocked.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن تغيير الحالة إلى «{status}»: {missing}'**
  String statusBlocked(String status, String missing);

  /// No description provided for @amendmentCreated.
  ///
  /// In ar, this message translates to:
  /// **'ملحق تعديل جديد: {number}'**
  String amendmentCreated(String number);

  /// No description provided for @amendmentOf.
  ///
  /// In ar, this message translates to:
  /// **'ملحق للعقد {number}'**
  String amendmentOf(String number);

  /// No description provided for @amendmentPreamble.
  ///
  /// In ar, this message translates to:
  /// **'إلحاقًا بالعقد رقم {number} المؤرخ في {date} بين الطرفين، اتفق الطرفان على تعديله على النحو التالي، وتظل باقي بنوده وملاحقه سارية دون تغيير.'**
  String amendmentPreamble(String number, String date);

  /// No description provided for @amendmentClauseTitle.
  ///
  /// In ar, this message translates to:
  /// **'موضوع التعديل'**
  String get amendmentClauseTitle;

  /// No description provided for @contractDeleted.
  ///
  /// In ar, this message translates to:
  /// **'اتحذف {number}'**
  String contractDeleted(String number);

  /// No description provided for @contractHasInvoicesTitle.
  ///
  /// In ar, this message translates to:
  /// **'{number} مرتبط بفواتير'**
  String contractHasInvoicesTitle(String number);

  /// No description provided for @contractHasInvoicesBody.
  ///
  /// In ar, this message translates to:
  /// **'مرتبط بـ {invoices}، فلا يمكن حذفه حتى لا تفقد الفواتير مرجعها. يمكنك إلغاؤه بدلًا من ذلك، أو أرشفة العميل.'**
  String contractHasInvoicesBody(String invoices);

  /// No description provided for @cancelContract.
  ///
  /// In ar, this message translates to:
  /// **'تحويل الحالة إلى «ملغي»'**
  String get cancelContract;

  /// No description provided for @duplicateContract.
  ///
  /// In ar, this message translates to:
  /// **'تكرار كعقد جديد'**
  String get duplicateContract;

  /// No description provided for @contractDuplicated.
  ///
  /// In ar, this message translates to:
  /// **'عقد جديد: {number}'**
  String contractDuplicated(String number);

  /// No description provided for @changeStatus.
  ///
  /// In ar, this message translates to:
  /// **'تغيير الحالة'**
  String get changeStatus;

  /// No description provided for @history.
  ///
  /// In ar, this message translates to:
  /// **'سجل العقد'**
  String get history;

  /// No description provided for @historyUnlock.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء القفل'**
  String get historyUnlock;

  /// No description provided for @historyRelock.
  ///
  /// In ar, this message translates to:
  /// **'إعادة القفل'**
  String get historyRelock;

  /// No description provided for @historyStatus.
  ///
  /// In ar, this message translates to:
  /// **'الحالة: {status}'**
  String historyStatus(String status);

  /// No description provided for @libraryTitle.
  ///
  /// In ar, this message translates to:
  /// **'مكتبة البنود'**
  String get libraryTitle;

  /// No description provided for @librarySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'القوالب والبنود التي تُنسخ في كل عقد جديد. تعديلها لا يغيّر العقود الموجودة.'**
  String get librarySubtitle;

  /// No description provided for @openLibrary.
  ///
  /// In ar, this message translates to:
  /// **'فتح مكتبة البنود'**
  String get openLibrary;

  /// No description provided for @newTemplate.
  ///
  /// In ar, this message translates to:
  /// **'قالب جديد'**
  String get newTemplate;

  /// No description provided for @templateName.
  ///
  /// In ar, this message translates to:
  /// **'اسم القالب'**
  String get templateName;

  /// No description provided for @templateKind.
  ///
  /// In ar, this message translates to:
  /// **'النوع'**
  String get templateKind;

  /// No description provided for @templateDefaults.
  ///
  /// In ar, this message translates to:
  /// **'القيم الافتراضية للمتغيرات'**
  String get templateDefaults;

  /// No description provided for @templateDefaultsHint.
  ///
  /// In ar, this message translates to:
  /// **'سطر لكل متغير: الاسم=القيمة'**
  String get templateDefaultsHint;

  /// No description provided for @deleteTemplate.
  ///
  /// In ar, this message translates to:
  /// **'حذف القالب'**
  String get deleteTemplate;

  /// No description provided for @deleteTemplateBody.
  ///
  /// In ar, this message translates to:
  /// **'سيُحذف القالب «{name}» وبنوده من المكتبة. العقود المنشأة منه لن تتغير.'**
  String deleteTemplateBody(String name);

  /// No description provided for @enabledByDefault.
  ///
  /// In ar, this message translates to:
  /// **'مفعّل افتراضيًا'**
  String get enabledByDefault;

  /// No description provided for @pickTemplateToEdit.
  ///
  /// In ar, this message translates to:
  /// **'اختر قالبًا لتعديله'**
  String get pickTemplateToEdit;

  /// No description provided for @draftNotLegalAdvice.
  ///
  /// In ar, this message translates to:
  /// **'النصوص المبدئية مسودة وليست استشارة قانونية؛ راجعها مع محامٍ.'**
  String get draftNotLegalAdvice;

  /// No description provided for @contractsSettings.
  ///
  /// In ar, this message translates to:
  /// **'العقود'**
  String get contractsSettings;

  /// No description provided for @legalName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم القانوني'**
  String get legalName;

  /// No description provided for @nationalIdOrRegistry.
  ///
  /// In ar, this message translates to:
  /// **'الرقم القومي / السجل التجاري'**
  String get nationalIdOrRegistry;

  /// No description provided for @address.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get address;

  /// No description provided for @contractPrefix.
  ///
  /// In ar, this message translates to:
  /// **'بادئة أرقام العقود'**
  String get contractPrefix;

  /// No description provided for @quotePrefix.
  ///
  /// In ar, this message translates to:
  /// **'بادئة أرقام العروض'**
  String get quotePrefix;

  /// No description provided for @defaultJurisdiction.
  ///
  /// In ar, this message translates to:
  /// **'جهة الفصل الافتراضية'**
  String get defaultJurisdiction;

  /// No description provided for @westernDigits.
  ///
  /// In ar, this message translates to:
  /// **'أرقام البنود الفرعية بالأرقام الغربية (1. بدلًا من ١.)'**
  String get westernDigits;

  /// No description provided for @clientLegal.
  ///
  /// In ar, this message translates to:
  /// **'البيانات القانونية (للعقود)'**
  String get clientLegal;

  /// No description provided for @clientRegistry.
  ///
  /// In ar, this message translates to:
  /// **'سجل تجاري / رقم قومي'**
  String get clientRegistry;

  /// No description provided for @clientRepresentative.
  ///
  /// In ar, this message translates to:
  /// **'الممثل القانوني'**
  String get clientRepresentative;

  /// No description provided for @clientRepresentativeTitle.
  ///
  /// In ar, this message translates to:
  /// **'صفته'**
  String get clientRepresentativeTitle;

  /// No description provided for @clientHasDocumentsBody.
  ///
  /// In ar, this message translates to:
  /// **'عنده {invoices} و{contracts}، والمبلغ غير المدفوع: {unpaid}.\nالأرشفة بتخفي العميل وفواتيره وعقوده من القائمة والبحث من غير ما تمسح حاجة، وتقدر ترجّعه من فلتر «مؤرشف».'**
  String clientHasDocumentsBody(String invoices, String contracts, String unpaid);

  /// No description provided for @clientDeletedWithDocuments.
  ///
  /// In ar, this message translates to:
  /// **'اتحذف {name} و{documents}'**
  String clientDeletedWithDocuments(String name, String documents);

  /// No description provided for @confirmDeleteDocumentsBody.
  ///
  /// In ar, this message translates to:
  /// **'هيتحذف {documents}، منها المدفوع والمُرسل والموقّع. هنعمل نسخة احتياطية الأول، وتقدر تتراجع لمدة ٨ ثواني.\nاكتب اسم العميل للتأكيد:'**
  String confirmDeleteDocumentsBody(String documents);

  /// No description provided for @andJoin.
  ///
  /// In ar, this message translates to:
  /// **'{a} و{b}'**
  String andJoin(String a, String b);

  /// No description provided for @trash.
  ///
  /// In ar, this message translates to:
  /// **'المحذوفات'**
  String get trash;

  /// No description provided for @trashEmptyState.
  ///
  /// In ar, this message translates to:
  /// **'المحذوفات فاضية.'**
  String get trashEmptyState;

  /// No description provided for @trashDeletedOn.
  ///
  /// In ar, this message translates to:
  /// **'حُذف في {date}'**
  String trashDeletedOn(String date);

  /// No description provided for @trashPurgeIn.
  ///
  /// In ar, this message translates to:
  /// **'{days, plural, =0{يُحذف نهائيًا اليوم} =1{يُحذف نهائيًا خلال يوم} =2{يُحذف نهائيًا خلال يومين} few{يُحذف نهائيًا خلال {days} أيام} other{يُحذف نهائيًا خلال {days} يوم}}'**
  String trashPurgeIn(int days);

  /// No description provided for @trashRestore.
  ///
  /// In ar, this message translates to:
  /// **'استعادة'**
  String get trashRestore;

  /// No description provided for @trashPurge.
  ///
  /// In ar, this message translates to:
  /// **'حذف نهائي'**
  String get trashPurge;

  /// No description provided for @trashEmpty.
  ///
  /// In ar, this message translates to:
  /// **'إفراغ المحذوفات'**
  String get trashEmpty;

  /// No description provided for @trashOfClient.
  ///
  /// In ar, this message translates to:
  /// **'لـ {name}'**
  String trashOfClient(String name);

  /// No description provided for @trashClientDeleted.
  ///
  /// In ar, this message translates to:
  /// **'العميل محذوف'**
  String get trashClientDeleted;

  /// No description provided for @trashRestored.
  ///
  /// In ar, this message translates to:
  /// **'اتسترجع {label}'**
  String trashRestored(String label);

  /// No description provided for @trashRestoredCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{اتسترجع عنصر واحد} =2{اتسترجع عنصران} few{اتسترجع {count} عناصر} other{اتسترجع {count} عنصر}}'**
  String trashRestoredCount(int count);

  /// No description provided for @trashNeedsClientTitle.
  ///
  /// In ar, this message translates to:
  /// **'العميل {name} في المحذوفات'**
  String trashNeedsClientTitle(String name);

  /// No description provided for @trashNeedsClientBody.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن استعادة {label} وعميله محذوف. استعادة العميل معه؟ (العميل وحده، من غير باقي مستنداته المحذوفة)'**
  String trashNeedsClientBody(String label);

  /// No description provided for @trashRestoreBoth.
  ///
  /// In ar, this message translates to:
  /// **'استعادة الاثنين'**
  String get trashRestoreBoth;

  /// No description provided for @trashPurgeTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف {label} نهائيًا؟'**
  String trashPurgeTitle(String label);

  /// No description provided for @trashPurgeBody.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن التراجع عن الحذف النهائي من داخل البرنامج. سنكتب نسخة احتياطية قبل الحذف.\nاكتب «{label}» للتأكيد:'**
  String trashPurgeBody(String label);

  /// No description provided for @trashPurgeClientBody.
  ///
  /// In ar, this message translates to:
  /// **'سيُحذف العميل {label} نهائيًا مع كل فواتيره وعقوده المحذوفة. سنكتب نسخة احتياطية قبل الحذف.\nاكتب اسم العميل للتأكيد:'**
  String trashPurgeClientBody(String label);

  /// No description provided for @trashEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'إفراغ المحذوفات؟'**
  String get trashEmptyTitle;

  /// No description provided for @trashEmptyBody.
  ///
  /// In ar, this message translates to:
  /// **'سيُحذف {count} نهائيًا. سنكتب نسخة احتياطية قبل الحذف.\nاكتب «إفراغ» للتأكيد:'**
  String trashEmptyBody(String count);

  /// No description provided for @trashEmptyWord.
  ///
  /// In ar, this message translates to:
  /// **'إفراغ'**
  String get trashEmptyWord;

  /// No description provided for @trashItems.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{عنصر واحد} =2{عنصران} few{{count} عناصر} other{{count} عنصر}}'**
  String trashItems(int count);

  /// No description provided for @trashPurged.
  ///
  /// In ar, this message translates to:
  /// **'اتحذف نهائيًا. النسخة الاحتياطية: {file}'**
  String trashPurged(String file);

  /// No description provided for @trashPurgeFailed.
  ///
  /// In ar, this message translates to:
  /// **'ماقدرناش نحذف نهائيًا'**
  String get trashPurgeFailed;

  /// No description provided for @undoOrTrash.
  ///
  /// In ar, this message translates to:
  /// **'{message} — تراجع، أو من المحذوفات'**
  String undoOrTrash(String message);

  /// No description provided for @kindClientLabel.
  ///
  /// In ar, this message translates to:
  /// **'عميل'**
  String get kindClientLabel;

  /// No description provided for @kindInvoiceLabel.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة'**
  String get kindInvoiceLabel;

  /// No description provided for @cloudSync.
  ///
  /// In ar, this message translates to:
  /// **'المزامنة السحابية'**
  String get cloudSync;

  /// No description provided for @cloudSyncOff.
  ///
  /// In ar, this message translates to:
  /// **'غير مفعّلة — قريبًا'**
  String get cloudSyncOff;

  /// No description provided for @cloudSyncOn.
  ///
  /// In ar, this message translates to:
  /// **'مفعّلة'**
  String get cloudSyncOn;

  /// No description provided for @cloudSyncBody.
  ///
  /// In ar, this message translates to:
  /// **'اشتراك اختياري لاحقًا: مزامنة مشفّرة من طرف إلى طرف بين أجهزتك. البرنامج المكتبي يظل مجانيًا وكاملًا بدونها، وبياناتك لا تغادر جهازك اليوم.'**
  String get cloudSyncBody;

  /// No description provided for @calendar.
  ///
  /// In ar, this message translates to:
  /// **'التقويم'**
  String get calendar;

  /// No description provided for @invoicesAndContracts.
  ///
  /// In ar, this message translates to:
  /// **'الفواتير والعقود'**
  String get invoicesAndContracts;

  /// No description provided for @viewMonth.
  ///
  /// In ar, this message translates to:
  /// **'شهر'**
  String get viewMonth;

  /// No description provided for @viewWeek.
  ///
  /// In ar, this message translates to:
  /// **'أسبوع'**
  String get viewWeek;

  /// No description provided for @viewAgenda.
  ///
  /// In ar, this message translates to:
  /// **'جدول'**
  String get viewAgenda;

  /// No description provided for @today.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get today;

  /// No description provided for @previous.
  ///
  /// In ar, this message translates to:
  /// **'السابق'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get next;

  /// No description provided for @summaryExpected.
  ///
  /// In ar, this message translates to:
  /// **'متوقع تحصيله'**
  String get summaryExpected;

  /// No description provided for @summaryCollected.
  ///
  /// In ar, this message translates to:
  /// **'تم تحصيله'**
  String get summaryCollected;

  /// No description provided for @summaryLate.
  ///
  /// In ar, this message translates to:
  /// **'متأخر'**
  String get summaryLate;

  /// No description provided for @evDue.
  ///
  /// In ar, this message translates to:
  /// **'واجب التحصيل'**
  String get evDue;

  /// No description provided for @evOverdue.
  ///
  /// In ar, this message translates to:
  /// **'متأخر'**
  String get evOverdue;

  /// No description provided for @evOverdueRollup.
  ///
  /// In ar, this message translates to:
  /// **'متأخرات'**
  String get evOverdueRollup;

  /// No description provided for @evPaid.
  ///
  /// In ar, this message translates to:
  /// **'تم الدفع'**
  String get evPaid;

  /// No description provided for @evPostponed.
  ///
  /// In ar, this message translates to:
  /// **'مؤجَّل'**
  String get evPostponed;

  /// No description provided for @evMilestone.
  ///
  /// In ar, this message translates to:
  /// **'دفعة عقد مستحقة'**
  String get evMilestone;

  /// No description provided for @evRenewal.
  ///
  /// In ar, this message translates to:
  /// **'تجديد'**
  String get evRenewal;

  /// No description provided for @evContractStart.
  ///
  /// In ar, this message translates to:
  /// **'بداية عقد'**
  String get evContractStart;

  /// No description provided for @evContractEnd.
  ///
  /// In ar, this message translates to:
  /// **'نهاية عقد'**
  String get evContractEnd;

  /// No description provided for @evWarrantyEnd.
  ///
  /// In ar, this message translates to:
  /// **'نهاية الضمان'**
  String get evWarrantyEnd;

  /// No description provided for @evReminder.
  ///
  /// In ar, this message translates to:
  /// **'تذكير'**
  String get evReminder;

  /// No description provided for @daysOverdue.
  ///
  /// In ar, this message translates to:
  /// **'{days, plural, =1{يوم واحد متأخر} =2{يومان متأخران} few{{days} أيام متأخرة} other{{days} يومًا متأخرًا}}'**
  String daysOverdue(int days);

  /// No description provided for @overdueRollup.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{متأخرة واحدة} =2{متأخرتان} few{{count} متأخرة} other{{count} متأخرًا}}'**
  String overdueRollup(int count);

  /// No description provided for @moreEvents.
  ///
  /// In ar, this message translates to:
  /// **'+{count, plural, =1{1} other{{count}}}'**
  String moreEvents(int count);

  /// No description provided for @filterClient.
  ///
  /// In ar, this message translates to:
  /// **'العميل'**
  String get filterClient;

  /// No description provided for @filterType.
  ///
  /// In ar, this message translates to:
  /// **'نوع الحدث'**
  String get filterType;

  /// No description provided for @filterCurrency.
  ///
  /// In ar, this message translates to:
  /// **'العملة'**
  String get filterCurrency;

  /// No description provided for @allClients.
  ///
  /// In ar, this message translates to:
  /// **'كل العملاء'**
  String get allClients;

  /// No description provided for @allTypes.
  ///
  /// In ar, this message translates to:
  /// **'كل الأنواع'**
  String get allTypes;

  /// No description provided for @allCurrencies.
  ///
  /// In ar, this message translates to:
  /// **'كل العملات'**
  String get allCurrencies;

  /// No description provided for @clearFilters.
  ///
  /// In ar, this message translates to:
  /// **'مسح الفلاتر'**
  String get clearFilters;

  /// No description provided for @showPast.
  ///
  /// In ar, this message translates to:
  /// **'عرض السابق'**
  String get showPast;

  /// No description provided for @agendaEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا أحداث قادمة مطابقة'**
  String get agendaEmpty;

  /// No description provided for @dayEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا أحداث في هذا اليوم'**
  String get dayEmpty;

  /// No description provided for @searchCalendar.
  ///
  /// In ar, this message translates to:
  /// **'ابحث في التقويم'**
  String get searchCalendar;

  /// No description provided for @actOpen.
  ///
  /// In ar, this message translates to:
  /// **'فتح'**
  String get actOpen;

  /// No description provided for @actMarkPaid.
  ///
  /// In ar, this message translates to:
  /// **'تحديد كمدفوعة'**
  String get actMarkPaid;

  /// No description provided for @actPostpone.
  ///
  /// In ar, this message translates to:
  /// **'تأجيل'**
  String get actPostpone;

  /// No description provided for @actCopyReminder.
  ///
  /// In ar, this message translates to:
  /// **'نسخ رسالة تذكير'**
  String get actCopyReminder;

  /// No description provided for @actCreateInvoice.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء فاتورة'**
  String get actCreateInvoice;

  /// No description provided for @actOpenContract.
  ///
  /// In ar, this message translates to:
  /// **'فتح العقد'**
  String get actOpenContract;

  /// No description provided for @actRenewInvoice.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء فاتورة تجديد'**
  String get actRenewInvoice;

  /// No description provided for @actEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get actEdit;

  /// No description provided for @actMarkDone.
  ///
  /// In ar, this message translates to:
  /// **'تم'**
  String get actMarkDone;

  /// No description provided for @actReopen.
  ///
  /// In ar, this message translates to:
  /// **'إعادة فتح'**
  String get actReopen;

  /// No description provided for @actDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get actDelete;

  /// No description provided for @addReminder.
  ///
  /// In ar, this message translates to:
  /// **'+ تذكير'**
  String get addReminder;

  /// No description provided for @postponeTitle.
  ///
  /// In ar, this message translates to:
  /// **'تأجيل الاستحقاق'**
  String get postponeTitle;

  /// No description provided for @postponeNewDate.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ الجديد'**
  String get postponeNewDate;

  /// No description provided for @postponeReason.
  ///
  /// In ar, this message translates to:
  /// **'السبب'**
  String get postponeReason;

  /// No description provided for @postponeReasonHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: طلب العميل مهلة'**
  String get postponeReasonHint;

  /// No description provided for @postponed.
  ///
  /// In ar, this message translates to:
  /// **'تم التأجيل إلى {date}'**
  String postponed(String date);

  /// No description provided for @postponedFromTo.
  ///
  /// In ar, this message translates to:
  /// **'مؤجَّلة من {from} إلى {to}'**
  String postponedFromTo(String from, String to);

  /// No description provided for @postponeHistory.
  ///
  /// In ar, this message translates to:
  /// **'سجل التأجيل'**
  String get postponeHistory;

  /// No description provided for @reminderNew.
  ///
  /// In ar, this message translates to:
  /// **'تذكير جديد'**
  String get reminderNew;

  /// No description provided for @reminderEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل التذكير'**
  String get reminderEdit;

  /// No description provided for @reminderText.
  ///
  /// In ar, this message translates to:
  /// **'النص'**
  String get reminderText;

  /// No description provided for @reminderTime.
  ///
  /// In ar, this message translates to:
  /// **'الوقت (اختياري، 24 ساعة)'**
  String get reminderTime;

  /// No description provided for @reminderTimeHint.
  ///
  /// In ar, this message translates to:
  /// **'10:30'**
  String get reminderTimeHint;

  /// No description provided for @errReminderText.
  ///
  /// In ar, this message translates to:
  /// **'اكتب نص التذكير'**
  String get errReminderText;

  /// No description provided for @errTime.
  ///
  /// In ar, this message translates to:
  /// **'وقت غير صالح'**
  String get errTime;

  /// No description provided for @reminderDeleted.
  ///
  /// In ar, this message translates to:
  /// **'حُذف التذكير'**
  String get reminderDeleted;

  /// No description provided for @reminderCopied.
  ///
  /// In ar, this message translates to:
  /// **'نُسخت رسالة التذكير — الصقها في واتساب أو البريد'**
  String get reminderCopied;

  /// No description provided for @exportIcs.
  ///
  /// In ar, this message translates to:
  /// **'تصدير إلى التقويم (.ics)'**
  String get exportIcs;

  /// No description provided for @exportIcsVisible.
  ///
  /// In ar, this message translates to:
  /// **'النطاق الظاهر'**
  String get exportIcsVisible;

  /// No description provided for @exportIcsFuture.
  ///
  /// In ar, this message translates to:
  /// **'كل الأحداث القادمة'**
  String get exportIcsFuture;

  /// No description provided for @icsExported.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{صُدّر حدث واحد} =2{صُدّر حدثان} few{{count} أحداث} other{{count} حدثًا}}'**
  String icsExported(int count);

  /// No description provided for @todayBanner.
  ///
  /// In ar, this message translates to:
  /// **'اليوم: {due, plural, =1{مستحق واحد} =2{مستحقان} few{{due} مستحقة} other{{due} مستحق}} · {overdue, plural, =1{متأخر واحد} =2{متأخران} few{{overdue} متأخرة} other{{overdue} متأخر}}'**
  String todayBanner(int due, int overdue);

  /// No description provided for @showInCalendar.
  ///
  /// In ar, this message translates to:
  /// **'عرض في التقويم'**
  String get showInCalendar;

  /// No description provided for @dismiss.
  ///
  /// In ar, this message translates to:
  /// **'إخفاء'**
  String get dismiss;

  /// No description provided for @profileBanner.
  ///
  /// In ar, this message translates to:
  /// **'أكمل بياناتك'**
  String get profileBanner;

  /// No description provided for @profileBannerBody.
  ///
  /// In ar, this message translates to:
  /// **'أضف اسمك وبيانات الدفع لتظهر على الفواتير والعقود.'**
  String get profileBannerBody;

  /// No description provided for @inCalendar.
  ///
  /// In ar, this message translates to:
  /// **'في التقويم'**
  String get inCalendar;

  /// No description provided for @demoData.
  ///
  /// In ar, this message translates to:
  /// **'البيانات التجريبية'**
  String get demoData;

  /// No description provided for @demoBody.
  ///
  /// In ar, this message translates to:
  /// **'عملاء وفواتير وعقود وهمية للتجربة. أي صف تعدّله يصبح من بياناتك ولا يُحذف معها.'**
  String get demoBody;

  /// No description provided for @demoAdd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة بيانات تجريبية'**
  String get demoAdd;

  /// No description provided for @demoRemove.
  ///
  /// In ar, this message translates to:
  /// **'حذف البيانات التجريبية'**
  String get demoRemove;

  /// No description provided for @demoRemoveTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف البيانات التجريبية؟'**
  String get demoRemoveTitle;

  /// No description provided for @demoRemoveBody.
  ///
  /// In ar, this message translates to:
  /// **'تُحذف نهائيًا الصفوف التجريبية فقط، بعد نسخة احتياطية. بياناتك لا تُمس.'**
  String get demoRemoveBody;

  /// No description provided for @demoAdded.
  ///
  /// In ar, this message translates to:
  /// **'أُضيفت البيانات التجريبية'**
  String get demoAdded;

  /// No description provided for @demoRemoved.
  ///
  /// In ar, this message translates to:
  /// **'حُذفت البيانات التجريبية ({count, plural, =1{صف واحد} =2{صفان} few{{count} صفوف} other{{count} صفًا}})'**
  String demoRemoved(int count);

  /// No description provided for @weekStart.
  ///
  /// In ar, this message translates to:
  /// **'بداية الأسبوع'**
  String get weekStart;

  /// No description provided for @weekdaySaturday.
  ///
  /// In ar, this message translates to:
  /// **'السبت'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In ar, this message translates to:
  /// **'الأحد'**
  String get weekdaySunday;

  /// No description provided for @weekdayMonday.
  ///
  /// In ar, this message translates to:
  /// **'الإثنين'**
  String get weekdayMonday;

  /// No description provided for @notifyOnStart.
  ///
  /// In ar, this message translates to:
  /// **'إشعار عند التشغيل'**
  String get notifyOnStart;

  /// No description provided for @notifyOnStartBody.
  ///
  /// In ar, this message translates to:
  /// **'إشعار سطح المكتب بما يستحق اليوم وما تأخر (إن كان متاحًا).'**
  String get notifyOnStartBody;

  /// No description provided for @calendarShortcuts.
  ///
  /// In ar, this message translates to:
  /// **'الأسهم: تنقّل · PageUp/PageDown: شهر · T: اليوم · M/W/A: العرض · Enter: اليوم المحدد'**
  String get calendarShortcuts;

  /// No description provided for @dayTotal.
  ///
  /// In ar, this message translates to:
  /// **'مستحق اليوم'**
  String get dayTotal;

  /// No description provided for @wdMon.
  ///
  /// In ar, this message translates to:
  /// **'الإثنين'**
  String get wdMon;

  /// No description provided for @wdTue.
  ///
  /// In ar, this message translates to:
  /// **'الثلاثاء'**
  String get wdTue;

  /// No description provided for @wdWed.
  ///
  /// In ar, this message translates to:
  /// **'الأربعاء'**
  String get wdWed;

  /// No description provided for @wdThu.
  ///
  /// In ar, this message translates to:
  /// **'الخميس'**
  String get wdThu;

  /// No description provided for @wdFri.
  ///
  /// In ar, this message translates to:
  /// **'الجمعة'**
  String get wdFri;

  /// No description provided for @wdSat.
  ///
  /// In ar, this message translates to:
  /// **'السبت'**
  String get wdSat;

  /// No description provided for @wdSun.
  ///
  /// In ar, this message translates to:
  /// **'الأحد'**
  String get wdSun;

  /// No description provided for @general.
  ///
  /// In ar, this message translates to:
  /// **'عام'**
  String get general;

  /// No description provided for @uiLanguage.
  ///
  /// In ar, this message translates to:
  /// **'لغة الواجهة'**
  String get uiLanguage;

  /// No description provided for @uiLanguageSystem.
  ///
  /// In ar, this message translates to:
  /// **'لغة النظام'**
  String get uiLanguageSystem;

  /// No description provided for @uiLanguageAr.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get uiLanguageAr;

  /// No description provided for @uiLanguageEn.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get uiLanguageEn;

  /// No description provided for @uiLanguageHint.
  ///
  /// In ar, this message translates to:
  /// **'يتبع البرنامج كل التطبيق هذه اللغة، بما في ذلك اتجاه القراءة.'**
  String get uiLanguageHint;

  /// No description provided for @docLanguage.
  ///
  /// In ar, this message translates to:
  /// **'لغة المستند'**
  String get docLanguage;

  /// No description provided for @docLanguageAr.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get docLanguageAr;

  /// No description provided for @docLanguageEn.
  ///
  /// In ar, this message translates to:
  /// **'الإنجليزية'**
  String get docLanguageEn;

  /// No description provided for @docLanguageBilingual.
  ///
  /// In ar, this message translates to:
  /// **'ثنائي اللغة (عربي / إنجليزي)'**
  String get docLanguageBilingual;

  /// No description provided for @clientPreferredLanguage.
  ///
  /// In ar, this message translates to:
  /// **'لغة المستندات المفضلة'**
  String get clientPreferredLanguage;

  /// No description provided for @clientPreferredLanguageDefault.
  ///
  /// In ar, this message translates to:
  /// **'تتبع الإعدادات العامة'**
  String get clientPreferredLanguageDefault;

  /// No description provided for @defaultDocLanguage.
  ///
  /// In ar, this message translates to:
  /// **'لغة المستندات الافتراضية'**
  String get defaultDocLanguage;

  /// No description provided for @defaultDocLanguageHint.
  ///
  /// In ar, this message translates to:
  /// **'اللغة التي تبدأ بها المستندات الجديدة'**
  String get defaultDocLanguageHint;

  /// No description provided for @docDigitStyle.
  ///
  /// In ar, this message translates to:
  /// **'أرقام المستندات العربية'**
  String get docDigitStyle;

  /// No description provided for @docDigitStyleHint.
  ///
  /// In ar, this message translates to:
  /// **'طريقة كتابة الأرقام داخل النصوص العربية في ملفات الـ PDF'**
  String get docDigitStyleHint;

  /// No description provided for @digitStyleWestern.
  ///
  /// In ar, this message translates to:
  /// **'أرقام غربية (123)'**
  String get digitStyleWestern;

  /// No description provided for @digitStyleArabicIndic.
  ///
  /// In ar, this message translates to:
  /// **'أرقام مشرقية (١٢٣)'**
  String get digitStyleArabicIndic;

  /// No description provided for @warnNoPaymentMethod.
  ///
  /// In ar, this message translates to:
  /// **'أضف وسيلة دفع في الإعدادات'**
  String get warnNoPaymentMethod;

  /// No description provided for @warnNoPaymentMethodHint.
  ///
  /// In ar, this message translates to:
  /// **'لن تظهر بطاقة بيانات الدفع في الفاتورة حتى تضيف وسيلة دفع واحدة على الأقل.'**
  String get warnNoPaymentMethodHint;

  /// No description provided for @stylesTitle.
  ///
  /// In ar, this message translates to:
  /// **'تصميم المستندات'**
  String get stylesTitle;

  /// No description provided for @stylesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر شكل الفواتير والعقود، أو صمّم شكلك الخاص.'**
  String get stylesSubtitle;

  /// No description provided for @stylesPresets.
  ///
  /// In ar, this message translates to:
  /// **'تصاميم جاهزة'**
  String get stylesPresets;

  /// No description provided for @stylesMine.
  ///
  /// In ar, this message translates to:
  /// **'تصاميمي'**
  String get stylesMine;

  /// No description provided for @stylesNoneYet.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تصاميم خاصة بك بعد.'**
  String get stylesNoneYet;

  /// No description provided for @styleNewFromBlank.
  ///
  /// In ar, this message translates to:
  /// **'تصميم جديد من «أساسي»'**
  String get styleNewFromBlank;

  /// No description provided for @styleImport.
  ///
  /// In ar, this message translates to:
  /// **'استيراد ملف تصميم…'**
  String get styleImport;

  /// No description provided for @styleDuplicate.
  ///
  /// In ar, this message translates to:
  /// **'نسخ'**
  String get styleDuplicate;

  /// No description provided for @styleDuplicateToCustomize.
  ///
  /// In ar, this message translates to:
  /// **'انسخه لتعديله'**
  String get styleDuplicateToCustomize;

  /// No description provided for @styleRename.
  ///
  /// In ar, this message translates to:
  /// **'إعادة التسمية'**
  String get styleRename;

  /// No description provided for @styleResetToPreset.
  ///
  /// In ar, this message translates to:
  /// **'إرجاع إلى التصميم الأصلي'**
  String get styleResetToPreset;

  /// No description provided for @styleResetConfirm.
  ///
  /// In ar, this message translates to:
  /// **'ستعود ألوان «{name}» وخطوطه وإعداداته إلى التصميم الأصلي، ويبقى الاسم والشعار.'**
  String styleResetConfirm(String name);

  /// No description provided for @styleReset.
  ///
  /// In ar, this message translates to:
  /// **'إرجاع'**
  String get styleReset;

  /// No description provided for @styleExport.
  ///
  /// In ar, this message translates to:
  /// **'تصدير ملف تصميم…'**
  String get styleExport;

  /// No description provided for @styleDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get styleDelete;

  /// No description provided for @styleDeleted.
  ///
  /// In ar, this message translates to:
  /// **'نُقل «{name}» إلى المحذوفات'**
  String styleDeleted(String name);

  /// No description provided for @styleCopyName.
  ///
  /// In ar, this message translates to:
  /// **'{name} (نسخة)'**
  String styleCopyName(String name);

  /// No description provided for @styleNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم التصميم'**
  String get styleNameLabel;

  /// No description provided for @styleNewName.
  ///
  /// In ar, this message translates to:
  /// **'تصميم جديد'**
  String get styleNewName;

  /// No description provided for @styleImported.
  ///
  /// In ar, this message translates to:
  /// **'استُورد «{name}»'**
  String styleImported(String name);

  /// No description provided for @styleImportFailed.
  ///
  /// In ar, this message translates to:
  /// **'هذا الملف ليس ملف تصميم صالحًا.'**
  String get styleImportFailed;

  /// No description provided for @styleExported.
  ///
  /// In ar, this message translates to:
  /// **'حُفظ التصميم في {file}'**
  String styleExported(String file);

  /// No description provided for @styleExportFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر حفظ ملف التصميم.'**
  String get styleExportFailed;

  /// No description provided for @styleFileType.
  ///
  /// In ar, this message translates to:
  /// **'ملف تصميم'**
  String get styleFileType;

  /// No description provided for @stylePresetReadOnly.
  ///
  /// In ar, this message translates to:
  /// **'التصاميم الجاهزة للقراءة فقط. انسخ واحدًا لتعديله.'**
  String get stylePresetReadOnly;

  /// No description provided for @stylePreviewInvoice.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة'**
  String get stylePreviewInvoice;

  /// No description provided for @stylePreviewContract.
  ///
  /// In ar, this message translates to:
  /// **'عقد'**
  String get stylePreviewContract;

  /// No description provided for @stylePreviewSample.
  ///
  /// In ar, this message translates to:
  /// **'معاينة على فاتورة تجريبية'**
  String get stylePreviewSample;

  /// No description provided for @stylePreviewOpenDoc.
  ///
  /// In ar, this message translates to:
  /// **'معاينة على المستند المفتوح'**
  String get stylePreviewOpenDoc;

  /// No description provided for @styleGroupColours.
  ///
  /// In ar, this message translates to:
  /// **'الألوان'**
  String get styleGroupColours;

  /// No description provided for @styleGroupFont.
  ///
  /// In ar, this message translates to:
  /// **'الخط والصفحة'**
  String get styleGroupFont;

  /// No description provided for @styleGroupHeader.
  ///
  /// In ar, this message translates to:
  /// **'الترويسة والشعار'**
  String get styleGroupHeader;

  /// No description provided for @styleGroupTable.
  ///
  /// In ar, this message translates to:
  /// **'الجدول'**
  String get styleGroupTable;

  /// No description provided for @styleGroupTotals.
  ///
  /// In ar, this message translates to:
  /// **'الإجماليات'**
  String get styleGroupTotals;

  /// No description provided for @styleGroupBlocks.
  ///
  /// In ar, this message translates to:
  /// **'الأجزاء الظاهرة'**
  String get styleGroupBlocks;

  /// No description provided for @styleGroupFooter.
  ///
  /// In ar, this message translates to:
  /// **'التذييل'**
  String get styleGroupFooter;

  /// No description provided for @colourPrimary.
  ///
  /// In ar, this message translates to:
  /// **'اللون الأساسي'**
  String get colourPrimary;

  /// No description provided for @colourAccent.
  ///
  /// In ar, this message translates to:
  /// **'لون التمييز'**
  String get colourAccent;

  /// No description provided for @colourInk.
  ///
  /// In ar, this message translates to:
  /// **'لون النص'**
  String get colourInk;

  /// No description provided for @colourMuted.
  ///
  /// In ar, this message translates to:
  /// **'النص الثانوي'**
  String get colourMuted;

  /// No description provided for @colourSurface.
  ///
  /// In ar, this message translates to:
  /// **'خلفية البطاقات'**
  String get colourSurface;

  /// No description provided for @colourTableHeader.
  ///
  /// In ar, this message translates to:
  /// **'خلفية رأس الجدول'**
  String get colourTableHeader;

  /// No description provided for @colourBorder.
  ///
  /// In ar, this message translates to:
  /// **'الخطوط والحدود'**
  String get colourBorder;

  /// No description provided for @colourPick.
  ///
  /// In ar, this message translates to:
  /// **'اختيار لون'**
  String get colourPick;

  /// No description provided for @colourHexInvalid.
  ///
  /// In ar, this message translates to:
  /// **'اكتب ٦ خانات ست عشرية، مثل 0F766E'**
  String get colourHexInvalid;

  /// No description provided for @contrastWarning.
  ///
  /// In ar, this message translates to:
  /// **'{pair}: التباين {ratio}:1 أقل من 4.5:1، وقد تصعب قراءة النص.'**
  String contrastWarning(String pair, String ratio);

  /// No description provided for @contrastInkOnPage.
  ///
  /// In ar, this message translates to:
  /// **'النص على الصفحة'**
  String get contrastInkOnPage;

  /// No description provided for @contrastMutedOnPage.
  ///
  /// In ar, this message translates to:
  /// **'النص الثانوي على الصفحة'**
  String get contrastMutedOnPage;

  /// No description provided for @contrastPrimaryOnPage.
  ///
  /// In ar, this message translates to:
  /// **'العناوين على الصفحة'**
  String get contrastPrimaryOnPage;

  /// No description provided for @contrastInkOnSurface.
  ///
  /// In ar, this message translates to:
  /// **'النص على خلفية البطاقات'**
  String get contrastInkOnSurface;

  /// No description provided for @contrastMutedOnSurface.
  ///
  /// In ar, this message translates to:
  /// **'النص الثانوي على خلفية البطاقات'**
  String get contrastMutedOnSurface;

  /// No description provided for @contrastMutedOnTableHeader.
  ///
  /// In ar, this message translates to:
  /// **'عناوين الجدول'**
  String get contrastMutedOnTableHeader;

  /// No description provided for @contrastWhiteOnInk.
  ///
  /// In ar, this message translates to:
  /// **'نص الإجمالي على شريطه الداكن'**
  String get contrastWhiteOnInk;

  /// No description provided for @contrastWhiteOnPrimary.
  ///
  /// In ar, this message translates to:
  /// **'نص الإجمالي على شريطه الملوّن'**
  String get contrastWhiteOnPrimary;

  /// No description provided for @fontFamily.
  ///
  /// In ar, this message translates to:
  /// **'نوع الخط'**
  String get fontFamily;

  /// No description provided for @fontPlex.
  ///
  /// In ar, this message translates to:
  /// **'IBM Plex Sans Arabic'**
  String get fontPlex;

  /// No description provided for @fontNaskh.
  ///
  /// In ar, this message translates to:
  /// **'Noto Naskh Arabic'**
  String get fontNaskh;

  /// No description provided for @fontBaseSize.
  ///
  /// In ar, this message translates to:
  /// **'حجم الخط الأساسي'**
  String get fontBaseSize;

  /// No description provided for @fontScale.
  ///
  /// In ar, this message translates to:
  /// **'تكبير النص'**
  String get fontScale;

  /// No description provided for @paperSize.
  ///
  /// In ar, this message translates to:
  /// **'حجم الورق'**
  String get paperSize;

  /// No description provided for @paperA4.
  ///
  /// In ar, this message translates to:
  /// **'A4'**
  String get paperA4;

  /// No description provided for @paperLetter.
  ///
  /// In ar, this message translates to:
  /// **'Letter'**
  String get paperLetter;

  /// No description provided for @marginSide.
  ///
  /// In ar, this message translates to:
  /// **'الهامش الجانبي'**
  String get marginSide;

  /// No description provided for @marginTop.
  ///
  /// In ar, this message translates to:
  /// **'الهامش العلوي'**
  String get marginTop;

  /// No description provided for @marginBottom.
  ///
  /// In ar, this message translates to:
  /// **'الهامش السفلي'**
  String get marginBottom;

  /// No description provided for @pointsValue.
  ///
  /// In ar, this message translates to:
  /// **'{value} نقطة'**
  String pointsValue(String value);

  /// No description provided for @headerStyleLabel.
  ///
  /// In ar, this message translates to:
  /// **'شكل الترويسة'**
  String get headerStyleLabel;

  /// No description provided for @headerBand.
  ///
  /// In ar, this message translates to:
  /// **'شريط'**
  String get headerBand;

  /// No description provided for @headerRule.
  ///
  /// In ar, this message translates to:
  /// **'خط'**
  String get headerRule;

  /// No description provided for @headerNone.
  ///
  /// In ar, this message translates to:
  /// **'بدون'**
  String get headerNone;

  /// No description provided for @logoLabel.
  ///
  /// In ar, this message translates to:
  /// **'الشعار'**
  String get logoLabel;

  /// No description provided for @logoChoose.
  ///
  /// In ar, this message translates to:
  /// **'اختيار صورة…'**
  String get logoChoose;

  /// No description provided for @logoRemove.
  ///
  /// In ar, this message translates to:
  /// **'إزالة الشعار'**
  String get logoRemove;

  /// No description provided for @logoHint.
  ///
  /// In ar, this message translates to:
  /// **'PNG أو JPG، حتى 1 ميجابايت'**
  String get logoHint;

  /// No description provided for @logoRejected.
  ///
  /// In ar, this message translates to:
  /// **'لم تُقبل الصورة: يجب أن تكون PNG أو JPG بحجم 1 ميجابايت أو أقل.'**
  String get logoRejected;

  /// No description provided for @logoImageType.
  ///
  /// In ar, this message translates to:
  /// **'صورة'**
  String get logoImageType;

  /// No description provided for @logoSize.
  ///
  /// In ar, this message translates to:
  /// **'حجم الشعار'**
  String get logoSize;

  /// No description provided for @logoPosition.
  ///
  /// In ar, this message translates to:
  /// **'موضع الشعار'**
  String get logoPosition;

  /// No description provided for @positionStart.
  ///
  /// In ar, this message translates to:
  /// **'البداية'**
  String get positionStart;

  /// No description provided for @positionCenter.
  ///
  /// In ar, this message translates to:
  /// **'الوسط'**
  String get positionCenter;

  /// No description provided for @positionEnd.
  ///
  /// In ar, this message translates to:
  /// **'النهاية'**
  String get positionEnd;

  /// No description provided for @showRole.
  ///
  /// In ar, this message translates to:
  /// **'المسمّى الوظيفي'**
  String get showRole;

  /// No description provided for @showCity.
  ///
  /// In ar, this message translates to:
  /// **'المدينة'**
  String get showCity;

  /// No description provided for @showContacts.
  ///
  /// In ar, this message translates to:
  /// **'بيانات التواصل'**
  String get showContacts;

  /// No description provided for @tableStyleLabel.
  ///
  /// In ar, this message translates to:
  /// **'شكل الجدول'**
  String get tableStyleLabel;

  /// No description provided for @tablePlain.
  ///
  /// In ar, this message translates to:
  /// **'بسيط'**
  String get tablePlain;

  /// No description provided for @tableStriped.
  ///
  /// In ar, this message translates to:
  /// **'صفوف متناوبة'**
  String get tableStriped;

  /// No description provided for @tableBordered.
  ///
  /// In ar, this message translates to:
  /// **'بحدود'**
  String get tableBordered;

  /// No description provided for @totalsStyleLabel.
  ///
  /// In ar, this message translates to:
  /// **'شكل الإجماليات'**
  String get totalsStyleLabel;

  /// No description provided for @totalsOutlined.
  ///
  /// In ar, this message translates to:
  /// **'إطار'**
  String get totalsOutlined;

  /// No description provided for @totalsSolid.
  ///
  /// In ar, this message translates to:
  /// **'ملوّن'**
  String get totalsSolid;

  /// No description provided for @totalsPlain.
  ///
  /// In ar, this message translates to:
  /// **'بسيط'**
  String get totalsPlain;

  /// No description provided for @showVatRow.
  ///
  /// In ar, this message translates to:
  /// **'سطر ضريبة القيمة المضافة'**
  String get showVatRow;

  /// No description provided for @showPaidStamp.
  ///
  /// In ar, this message translates to:
  /// **'ختم «مدفوعة»'**
  String get showPaidStamp;

  /// No description provided for @blockHeader.
  ///
  /// In ar, this message translates to:
  /// **'الترويسة'**
  String get blockHeader;

  /// No description provided for @blockParties.
  ///
  /// In ar, this message translates to:
  /// **'الأطراف'**
  String get blockParties;

  /// No description provided for @blockItems.
  ///
  /// In ar, this message translates to:
  /// **'البنود'**
  String get blockItems;

  /// No description provided for @blockTotals.
  ///
  /// In ar, this message translates to:
  /// **'الإجماليات'**
  String get blockTotals;

  /// No description provided for @blockNotes.
  ///
  /// In ar, this message translates to:
  /// **'الملاحظات'**
  String get blockNotes;

  /// No description provided for @blockFooter.
  ///
  /// In ar, this message translates to:
  /// **'التذييل'**
  String get blockFooter;

  /// No description provided for @blockRequired.
  ///
  /// In ar, this message translates to:
  /// **'أساسي'**
  String get blockRequired;

  /// No description provided for @blocksHint.
  ///
  /// In ar, this message translates to:
  /// **'اسحب الأجزاء لتغيير ترتيبها في المستند.'**
  String get blocksHint;

  /// No description provided for @showPaymentCard.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة بيانات الدفع'**
  String get showPaymentCard;

  /// No description provided for @showPleaseQuote.
  ///
  /// In ar, this message translates to:
  /// **'«يُرجى ذكر رقم الفاتورة عند الدفع»'**
  String get showPleaseQuote;

  /// No description provided for @showPageNumbers.
  ///
  /// In ar, this message translates to:
  /// **'أرقام الصفحات'**
  String get showPageNumbers;

  /// No description provided for @showSignatureBoxes.
  ///
  /// In ar, this message translates to:
  /// **'خانات التوقيع في العقود'**
  String get showSignatureBoxes;

  /// No description provided for @footerAr.
  ///
  /// In ar, this message translates to:
  /// **'نص التذييل بالعربية'**
  String get footerAr;

  /// No description provided for @footerEn.
  ///
  /// In ar, this message translates to:
  /// **'نص التذييل بالإنجليزية'**
  String get footerEn;

  /// No description provided for @docStyle.
  ///
  /// In ar, this message translates to:
  /// **'تصميم المستند'**
  String get docStyle;

  /// No description provided for @docStyleFollows.
  ///
  /// In ar, this message translates to:
  /// **'حسب العميل أو الإعدادات'**
  String get docStyleFollows;

  /// No description provided for @docStyleEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل التصاميم…'**
  String get docStyleEdit;

  /// No description provided for @styleLockedInvoice.
  ///
  /// In ar, this message translates to:
  /// **'التصميم مثبّت لأن الفاتورة أُرسلت'**
  String get styleLockedInvoice;

  /// No description provided for @styleLockedContract.
  ///
  /// In ar, this message translates to:
  /// **'التصميم مثبّت لأن العقد وُقِّع'**
  String get styleLockedContract;

  /// No description provided for @stylesSettings.
  ///
  /// In ar, this message translates to:
  /// **'تصاميم المستندات'**
  String get stylesSettings;

  /// No description provided for @defaultInvoiceStyle.
  ///
  /// In ar, this message translates to:
  /// **'تصميم الفواتير الافتراضي'**
  String get defaultInvoiceStyle;

  /// No description provided for @defaultContractStyle.
  ///
  /// In ar, this message translates to:
  /// **'تصميم العقود الافتراضي'**
  String get defaultContractStyle;

  /// No description provided for @openStyleEditor.
  ///
  /// In ar, this message translates to:
  /// **'فتح محرّر التصاميم'**
  String get openStyleEditor;

  /// No description provided for @presetClassic.
  ///
  /// In ar, this message translates to:
  /// **'كلاسيكي'**
  String get presetClassic;

  /// No description provided for @presetModern.
  ///
  /// In ar, this message translates to:
  /// **'عصري'**
  String get presetModern;

  /// No description provided for @presetMinimal.
  ///
  /// In ar, this message translates to:
  /// **'بسيط'**
  String get presetMinimal;

  /// No description provided for @presetBold.
  ///
  /// In ar, this message translates to:
  /// **'بارز'**
  String get presetBold;

  /// No description provided for @presetFormal.
  ///
  /// In ar, this message translates to:
  /// **'رسمي'**
  String get presetFormal;

  /// No description provided for @presetBlank.
  ///
  /// In ar, this message translates to:
  /// **'أساسي'**
  String get presetBlank;

  /// No description provided for @styleMoreActions.
  ///
  /// In ar, this message translates to:
  /// **'إجراءات التصميم'**
  String get styleMoreActions;

  /// No description provided for @previewFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر عرض المعاينة. يمكنك تصدير الملف كالمعتاد.'**
  String get previewFailed;

  /// No description provided for @styleUsageDrafts.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{مسودة واحدة} =2{مسودتان} few{{count} مسودات} other{{count} مسودة}}'**
  String styleUsageDrafts(int count);

  /// No description provided for @styleUsageClients.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{عميل واحد} =2{عميلان} few{{count} عملاء} other{{count} عميلًا}}'**
  String styleUsageClients(int count);

  /// No description provided for @styleUsageAnd.
  ///
  /// In ar, this message translates to:
  /// **'{a} و{b}'**
  String styleUsageAnd(String a, String b);

  /// No description provided for @styleDeleteTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف «{name}»؟'**
  String styleDeleteTitle(String name);

  /// No description provided for @styleDeleteInUse.
  ///
  /// In ar, this message translates to:
  /// **'يستخدم هذا التصميم {usage}. بعد حذفه تعود إلى تصميم العميل، ثم التصميم الافتراضي، ثم «كلاسيكي».'**
  String styleDeleteInUse(String usage);

  /// No description provided for @styleDeletedInUse.
  ///
  /// In ar, this message translates to:
  /// **'نُقل «{name}» إلى المحذوفات، وكان يستخدمه {usage}.'**
  String styleDeletedInUse(String name, String usage);

  /// No description provided for @settingsData.
  ///
  /// In ar, this message translates to:
  /// **'البيانات والنسخ الاحتياطية'**
  String get settingsData;

  /// No description provided for @settingsSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث في الإعدادات'**
  String get settingsSearchHint;

  /// No description provided for @settingsNoMatch.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إعدادات بهذا الاسم.'**
  String get settingsNoMatch;

  /// No description provided for @settingsInvoices.
  ///
  /// In ar, this message translates to:
  /// **'الفواتير'**
  String get settingsInvoices;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
