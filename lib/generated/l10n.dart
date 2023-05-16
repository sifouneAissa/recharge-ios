// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Recharge App`
  String get app_name {
    return Intl.message(
      'Recharge App',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `لنبدأ`
  String get lets_begin {
    return Intl.message(
      'لنبدأ',
      name: 'lets_begin',
      desc: '',
      args: [],
    );
  }

  /// `مستعد !`
  String get ready {
    return Intl.message(
      'مستعد !',
      name: 'ready',
      desc: '',
      args: [],
    );
  }

  /// `ارتاح`
  String get relax {
    return Intl.message(
      'ارتاح',
      name: 'relax',
      desc: '',
      args: [],
    );
  }

  /// `تخطى`
  String get skip {
    return Intl.message(
      'تخطى',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `اهتم`
  String get care {
    return Intl.message(
      'اهتم',
      name: 'care',
      desc: '',
      args: [],
    );
  }

  /// `غير مزاجك`
  String get mood {
    return Intl.message(
      'غير مزاجك',
      name: 'mood',
      desc: '',
      args: [],
    );
  }

  /// `مرحبا`
  String get welcome {
    return Intl.message(
      'مرحبا',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `ابق منظمًا وعش خاليًا من الإجهاد باستخدام تطبيق Rechare App`
  String get welcome_text {
    return Intl.message(
      'ابق منظمًا وعش خاليًا من الإجهاد باستخدام تطبيق Rechare App',
      name: 'welcome_text',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل`
  String get sign_up {
    return Intl.message(
      'تسجيل',
      name: 'sign_up',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل الدخول`
  String get login {
    return Intl.message(
      'تسجيل الدخول',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `هل لديك حساب؟`
  String get have_account {
    return Intl.message(
      'هل لديك حساب؟',
      name: 'have_account',
      desc: '',
      args: [],
    );
  }

  /// `الاسم`
  String get your_name {
    return Intl.message(
      'الاسم',
      name: 'your_name',
      desc: '',
      args: [],
    );
  }

  /// `الهاتف`
  String get your_phone {
    return Intl.message(
      'الهاتف',
      name: 'your_phone',
      desc: '',
      args: [],
    );
  }

  /// `البريد الالكتروني`
  String get your_email {
    return Intl.message(
      'البريد الالكتروني',
      name: 'your_email',
      desc: '',
      args: [],
    );
  }

  /// `كلمة السر`
  String get your_password {
    return Intl.message(
      'كلمة السر',
      name: 'your_password',
      desc: '',
      args: [],
    );
  }

  /// `ليس لديك حساب !`
  String get dont_have_account {
    return Intl.message(
      'ليس لديك حساب !',
      name: 'dont_have_account',
      desc: '',
      args: [],
    );
  }

  /// `الرصيد`
  String get balance {
    return Intl.message(
      'الرصيد',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `اليوم 8:26`
  String get today {
    return Intl.message(
      'اليوم 8:26',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `الرئيسية`
  String get home {
    return Intl.message(
      'الرئيسية',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `مساعدة`
  String get help {
    return Intl.message(
      'مساعدة',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `تعليق`
  String get feedback {
    return Intl.message(
      'تعليق',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `دعوة صديق`
  String get invite_friend {
    return Intl.message(
      'دعوة صديق',
      name: 'invite_friend',
      desc: '',
      args: [],
    );
  }

  /// `قيم التطبيق`
  String get rate_the_app {
    return Intl.message(
      'قيم التطبيق',
      name: 'rate_the_app',
      desc: '',
      args: [],
    );
  }

  /// `معلومات عنا`
  String get about_us {
    return Intl.message(
      'معلومات عنا',
      name: 'about_us',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل الخروج`
  String get sign_out {
    return Intl.message(
      'تسجيل الخروج',
      name: 'sign_out',
      desc: '',
      args: [],
    );
  }

  /// `شحن توكنز جواكر`
  String get token_shipping {
    return Intl.message(
      'شحن توكنز جواكر',
      name: 'token_shipping',
      desc: '',
      args: [],
    );
  }

  /// `شحن مسرعات جواكر`
  String get jawaker_accelerator_shipping {
    return Intl.message(
      'شحن مسرعات جواكر',
      name: 'jawaker_accelerator_shipping',
      desc: '',
      args: [],
    );
  }

  /// `تسوق`
  String get shop {
    return Intl.message(
      'تسوق',
      name: 'shop',
      desc: '',
      args: [],
    );
  }

  /// `اشعارات`
  String get notifications {
    return Intl.message(
      'اشعارات',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `تفاصيل`
  String get details {
    return Intl.message(
      'تفاصيل',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `معاملات`
  String get transactions {
    return Intl.message(
      'معاملات',
      name: 'transactions',
      desc: '',
      args: [],
    );
  }

  /// `معاملات سابقة`
  String get history {
    return Intl.message(
      'معاملات سابقة',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `مسرع النقاط`
  String get point_accelerator {
    return Intl.message(
      'مسرع النقاط',
      name: 'point_accelerator',
      desc: '',
      args: [],
    );
  }

  /// `موصى به لك`
  String get recommended {
    return Intl.message(
      'موصى به لك',
      name: 'recommended',
      desc: '',
      args: [],
    );
  }

  /// `افضل العروض`
  String get best_offer {
    return Intl.message(
      'افضل العروض',
      name: 'best_offer',
      desc: '',
      args: [],
    );
  }

  /// `الرئيسية`
  String get my_dashboard {
    return Intl.message(
      'الرئيسية',
      name: 'my_dashboard',
      desc: '',
      args: [],
    );
  }

  /// `اشعاراتي`
  String get my_notifications {
    return Intl.message(
      'اشعاراتي',
      name: 'my_notifications',
      desc: '',
      args: [],
    );
  }

  /// `معاملاتي`
  String get my_transactions {
    return Intl.message(
      'معاملاتي',
      name: 'my_transactions',
      desc: '',
      args: [],
    );
  }

  /// `تاريخ معاملاتي`
  String get my_history {
    return Intl.message(
      'تاريخ معاملاتي',
      name: 'my_history',
      desc: '',
      args: [],
    );
  }

  /// `شحن مسرعات جواكر`
  String get add_jawaker_accelaration {
    return Intl.message(
      'شحن مسرعات جواكر',
      name: 'add_jawaker_accelaration',
      desc: '',
      args: [],
    );
  }

  /// `الكمية`
  String get your_quantity {
    return Intl.message(
      'الكمية',
      name: 'your_quantity',
      desc: '',
      args: [],
    );
  }

  /// `المعرف (ID)`
  String get your_id {
    return Intl.message(
      'المعرف (ID)',
      name: 'your_id',
      desc: '',
      args: [],
    );
  }

  /// `ارسال`
  String get confirm {
    return Intl.message(
      'ارسال',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `الكلفة : `
  String get cost {
    return Intl.message(
      'الكلفة : ',
      name: 'cost',
      desc: '',
      args: [],
    );
  }

  /// `تحميل صورة عن طريق`
  String get choose_image {
    return Intl.message(
      'تحميل صورة عن طريق',
      name: 'choose_image',
      desc: '',
      args: [],
    );
  }

  /// `معرض الصور`
  String get gallery {
    return Intl.message(
      'معرض الصور',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `كاميرا`
  String get camera {
    return Intl.message(
      'كاميرا',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `البريد الالكتروني او كلمة السر خاطئة`
  String get invalid_email_password {
    return Intl.message(
      'البريد الالكتروني او كلمة السر خاطئة',
      name: 'invalid_email_password',
      desc: '',
      args: [],
    );
  }

  /// `كلمة السر خاطئة`
  String get invalid_password {
    return Intl.message(
      'كلمة السر خاطئة',
      name: 'invalid_password',
      desc: '',
      args: [],
    );
  }

  /// `بريد الكتروني خاطئ`
  String get invalid_email {
    return Intl.message(
      'بريد الكتروني خاطئ',
      name: 'invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `رقم الهاتف خاطىء`
  String get invalid_phone {
    return Intl.message(
      'رقم الهاتف خاطىء',
      name: 'invalid_phone',
      desc: '',
      args: [],
    );
  }

  /// `البريد الالكتروني مأخود`
  String get email_taken {
    return Intl.message(
      'البريد الالكتروني مأخود',
      name: 'email_taken',
      desc: '',
      args: [],
    );
  }

  /// `الاسم خاطىء`
  String get invalid_name {
    return Intl.message(
      'الاسم خاطىء',
      name: 'invalid_name',
      desc: '',
      args: [],
    );
  }

  /// `الرصيد غير كافي`
  String get invalid_cash {
    return Intl.message(
      'الرصيد غير كافي',
      name: 'invalid_cash',
      desc: '',
      args: [],
    );
  }

  /// `الكمية خاطئة`
  String get invalid_quantity {
    return Intl.message(
      'الكمية خاطئة',
      name: 'invalid_quantity',
      desc: '',
      args: [],
    );
  }

  /// `المعرف خاطئ`
  String get invalid_id {
    return Intl.message(
      'المعرف خاطئ',
      name: 'invalid_id',
      desc: '',
      args: [],
    );
  }

  /// `الكمية`
  String get count {
    return Intl.message(
      'الكمية',
      name: 'count',
      desc: '',
      args: [],
    );
  }

  /// `الكلفة`
  String get cost_d {
    return Intl.message(
      'الكلفة',
      name: 'cost_d',
      desc: '',
      args: [],
    );
  }

  /// `التاريخ`
  String get date {
    return Intl.message(
      'التاريخ',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `معاملاتك الجديدة`
  String get new_transactions {
    return Intl.message(
      'معاملاتك الجديدة',
      name: 'new_transactions',
      desc: '',
      args: [],
    );
  }

  /// `معاملاتك القديمة`
  String get old_transactions {
    return Intl.message(
      'معاملاتك القديمة',
      name: 'old_transactions',
      desc: '',
      args: [],
    );
  }

  /// `توكنز`
  String get token {
    return Intl.message(
      'توكنز',
      name: 'token',
      desc: '',
      args: [],
    );
  }

  /// `نقاط تسريع`
  String get point {
    return Intl.message(
      'نقاط تسريع',
      name: 'point',
      desc: '',
      args: [],
    );
  }

  /// `اخر تسوق : `
  String get last_shop {
    return Intl.message(
      'اخر تسوق : ',
      name: 'last_shop',
      desc: '',
      args: [],
    );
  }

  /// `اخر اشعار : `
  String get last_notification {
    return Intl.message(
      'اخر اشعار : ',
      name: 'last_notification',
      desc: '',
      args: [],
    );
  }

  /// `اخر معاملة : `
  String get last_trasanction {
    return Intl.message(
      'اخر معاملة : ',
      name: 'last_trasanction',
      desc: '',
      args: [],
    );
  }

  /// `اخر معاملة : `
  String get last_o_trasaction {
    return Intl.message(
      'اخر معاملة : ',
      name: 'last_o_trasaction',
      desc: '',
      args: [],
    );
  }

  /// `لقد قمت بطلب `
  String get transaction_request {
    return Intl.message(
      'لقد قمت بطلب ',
      name: 'transaction_request',
      desc: '',
      args: [],
    );
  }

  /// `بقيمة : `
  String get transaction_value {
    return Intl.message(
      'بقيمة : ',
      name: 'transaction_value',
      desc: '',
      args: [],
    );
  }

  /// `يوم `
  String get day {
    return Intl.message(
      'يوم ',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `آخر الاشعارات `
  String get last_notifications {
    return Intl.message(
      'آخر الاشعارات ',
      name: 'last_notifications',
      desc: '',
      args: [],
    );
  }

  /// `نوع المعاملة`
  String get transaction_type {
    return Intl.message(
      'نوع المعاملة',
      name: 'transaction_type',
      desc: '',
      args: [],
    );
  }

  /// `جاري معاجلة الطلب ...`
  String get sending_add_jawker {
    return Intl.message(
      'جاري معاجلة الطلب ...',
      name: 'sending_add_jawker',
      desc: '',
      args: [],
    );
  }

  /// `جاري معالجة الطلب ...`
  String get sending_add_tokens {
    return Intl.message(
      'جاري معالجة الطلب ...',
      name: 'sending_add_tokens',
      desc: '',
      args: [],
    );
  }

  /// `المعرف خاطئ`
  String get failed_add_tokens {
    return Intl.message(
      'المعرف خاطئ',
      name: 'failed_add_tokens',
      desc: '',
      args: [],
    );
  }

  /// `حدث خطأ في العملية`
  String get failed_add_jawaker {
    return Intl.message(
      'حدث خطأ في العملية',
      name: 'failed_add_jawaker',
      desc: '',
      args: [],
    );
  }

  /// `سيتم مراجعة طلبك وستتلقى اشعارا لاحقا`
  String get request_success {
    return Intl.message(
      'سيتم مراجعة طلبك وستتلقى اشعارا لاحقا',
      name: 'request_success',
      desc: '',
      args: [],
    );
  }

  /// `الحالة : `
  String get transaction_status {
    return Intl.message(
      'الحالة : ',
      name: 'transaction_status',
      desc: '',
      args: [],
    );
  }

  /// `الكمية : `
  String get transaction_count {
    return Intl.message(
      'الكمية : ',
      name: 'transaction_count',
      desc: '',
      args: [],
    );
  }

  /// `السعر : `
  String get transaction_price {
    return Intl.message(
      'السعر : ',
      name: 'transaction_price',
      desc: '',
      args: [],
    );
  }

  /// `يوم : `
  String get transaction_date {
    return Intl.message(
      'يوم : ',
      name: 'transaction_date',
      desc: '',
      args: [],
    );
  }

  /// `معرف الحساب : `
  String get transaction_player_id {
    return Intl.message(
      'معرف الحساب : ',
      name: 'transaction_player_id',
      desc: '',
      args: [],
    );
  }

  /// `الحزم التي تم اختيارها : `
  String get transaction_package_selected {
    return Intl.message(
      'الحزم التي تم اختيارها : ',
      name: 'transaction_package_selected',
      desc: '',
      args: [],
    );
  }

  /// `الحزمة `
  String get transaction_package {
    return Intl.message(
      'الحزمة ',
      name: 'transaction_package',
      desc: '',
      args: [],
    );
  }

  /// `الكمية `
  String get transaction_package_count {
    return Intl.message(
      'الكمية ',
      name: 'transaction_package_count',
      desc: '',
      args: [],
    );
  }

  /// `توكنز`
  String get tokens {
    return Intl.message(
      'توكنز',
      name: 'tokens',
      desc: '',
      args: [],
    );
  }

  /// `معلومات عامة`
  String get bottom_sheet_transaction_token {
    return Intl.message(
      'معلومات عامة',
      name: 'bottom_sheet_transaction_token',
      desc: '',
      args: [],
    );
  }

  /// `اسم اللاعب : `
  String get player_name {
    return Intl.message(
      'اسم اللاعب : ',
      name: 'player_name',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
