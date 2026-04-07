///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsAr with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsAr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ar,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ar>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsAr _root = this; // ignore: unused_field

	@override 
	TranslationsAr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsAr(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsAuthAr auth = _TranslationsAuthAr._(_root);
	@override late final _TranslationsErrorsAr errors = _TranslationsErrorsAr._(_root);
	@override late final _TranslationsCommonAr common = _TranslationsCommonAr._(_root);
	@override late final _TranslationsSettingsAr settings = _TranslationsSettingsAr._(_root);
	@override late final _TranslationsProductsAr products = _TranslationsProductsAr._(_root);
	@override late final _TranslationsHomeAr home = _TranslationsHomeAr._(_root);
}

// Path: auth
class _TranslationsAuthAr implements TranslationsAuthEn {
	_TranslationsAuthAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsAuthValidationAr validation = _TranslationsAuthValidationAr._(_root);
	@override late final _TranslationsAuthFormsAr forms = _TranslationsAuthFormsAr._(_root);
	@override late final _TranslationsAuthScreensAr screens = _TranslationsAuthScreensAr._(_root);
	@override late final _TranslationsAuthButtonsAr buttons = _TranslationsAuthButtonsAr._(_root);
	@override late final _TranslationsAuthDialogsAr dialogs = _TranslationsAuthDialogsAr._(_root);
	@override late final _TranslationsAuthPrivacyAr privacy = _TranslationsAuthPrivacyAr._(_root);
	@override late final _TranslationsAuthErrorsAr errors = _TranslationsAuthErrorsAr._(_root);
}

// Path: errors
class _TranslationsErrorsAr implements TranslationsErrorsEn {
	_TranslationsErrorsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsErrorsNetworkAr network = _TranslationsErrorsNetworkAr._(_root);
	@override late final _TranslationsErrorsServerAr server = _TranslationsErrorsServerAr._(_root);
	@override late final _TranslationsErrorsAuthAr auth = _TranslationsErrorsAuthAr._(_root);
	@override late final _TranslationsErrorsCacheAr cache = _TranslationsErrorsCacheAr._(_root);
	@override late final _TranslationsErrorsValidationAr validation = _TranslationsErrorsValidationAr._(_root);
	@override late final _TranslationsErrorsUnknownAr unknown = _TranslationsErrorsUnknownAr._(_root);
	@override late final _TranslationsErrorsGeneralAr general = _TranslationsErrorsGeneralAr._(_root);
	@override late final _TranslationsErrorsApiAr api = _TranslationsErrorsApiAr._(_root);
	@override late final _TranslationsErrorsProductsAr products = _TranslationsErrorsProductsAr._(_root);
}

// Path: common
class _TranslationsCommonAr implements TranslationsCommonEn {
	_TranslationsCommonAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsCommonNavigationAr navigation = _TranslationsCommonNavigationAr._(_root);
	@override late final _TranslationsCommonButtonsAr buttons = _TranslationsCommonButtonsAr._(_root);
	@override late final _TranslationsCommonLabelsAr labels = _TranslationsCommonLabelsAr._(_root);
	@override late final _TranslationsCommonEmptyStatesAr empty_states = _TranslationsCommonEmptyStatesAr._(_root);
	@override late final _TranslationsCommonErrorsAr errors = _TranslationsCommonErrorsAr._(_root);
}

// Path: settings
class _TranslationsSettingsAr implements TranslationsSettingsEn {
	_TranslationsSettingsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsSettingsScreensAr screens = _TranslationsSettingsScreensAr._(_root);
	@override late final _TranslationsSettingsSectionsAr sections = _TranslationsSettingsSectionsAr._(_root);
	@override late final _TranslationsSettingsOptionsAr options = _TranslationsSettingsOptionsAr._(_root);
	@override late final _TranslationsSettingsButtonsAr buttons = _TranslationsSettingsButtonsAr._(_root);
	@override late final _TranslationsSettingsDialogsAr dialogs = _TranslationsSettingsDialogsAr._(_root);
}

// Path: products
class _TranslationsProductsAr implements TranslationsProductsEn {
	_TranslationsProductsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsProductsInfoAr info = _TranslationsProductsInfoAr._(_root);
	@override late final _TranslationsProductsActionsAr actions = _TranslationsProductsActionsAr._(_root);
	@override late final _TranslationsProductsCartAr cart = _TranslationsProductsCartAr._(_root);
}

// Path: home
class _TranslationsHomeAr implements TranslationsHomeEn {
	_TranslationsHomeAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsHomeFiltersAr filters = _TranslationsHomeFiltersAr._(_root);
}

// Path: auth.validation
class _TranslationsAuthValidationAr implements TranslationsAuthValidationEn {
	_TranslationsAuthValidationAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get full_name_required => 'يرجى إدخال اسمك';
	@override String get full_name_invalid => 'يجب أن يكون الاسم الاسم الأول والأخير مفصولين بمسافة';
	@override String get email_required => 'يرجى إدخال عنوان بريدك الإلكتروني';
	@override String get email_invalid => 'يرجى إدخال عنوان بريد إلكتروني صالح';
	@override String get password_required => 'يرجى إدخال كلمة المرور الخاصة بك';
	@override String get password_too_short => 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';
	@override String get confirm_password_required => 'يرجى تأكيد كلمة المرور الخاصة بك';
	@override String get passwords_not_match => 'كلمات المرور غير متطابقة';
}

// Path: auth.forms
class _TranslationsAuthFormsAr implements TranslationsAuthFormsEn {
	_TranslationsAuthFormsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get full_name_label => 'الاسم الكامل';
	@override String get full_name_hint => 'أدخل اسمك';
	@override String get email_label => 'عنوان البريد الإلكتروني';
	@override String get email_hint => 'example@email.com';
	@override String get password_label => 'كلمة المرور';
	@override String get password_hint => '* * * * * * * *';
	@override String get confirm_password_label => 'تأكيد كلمة المرور';
}

// Path: auth.screens
class _TranslationsAuthScreensAr implements TranslationsAuthScreensEn {
	_TranslationsAuthScreensAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get login_title => 'تسجيل الدخول';
	@override String get signup_title => 'إنشاء حساب';
	@override String get forgot_password_link => 'هل نسيت كلمة المرور';
	@override String get have_account_question => 'هل لديك حساب بالفعل؟';
	@override String get dont_have_account_question => 'ليس لديك حساب؟';
	@override String get login_link => 'تسجيل الدخول';
	@override String get signup_link => 'إنشاء حساب';
}

// Path: auth.buttons
class _TranslationsAuthButtonsAr implements TranslationsAuthButtonsEn {
	_TranslationsAuthButtonsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get login => 'تسجيل الدخول';
	@override String get signup => 'إنشاء حساب';
	@override String get verify_email => 'تحقق من البريد الإلكتروني';
	@override String get reset_password => 'إعادة تعيين كلمة المرور';
}

// Path: auth.dialogs
class _TranslationsAuthDialogsAr implements TranslationsAuthDialogsEn {
	_TranslationsAuthDialogsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get verify_email_title => 'تحقق من عنوان بريدك الإلكتروني';
	@override String get enter_code_hint => 'أدخل الرمز';
	@override String get invalid_verification_code => 'رمز التحقق غير صحيح';
	@override String get reset_password_title => 'إعادة تعيين كلمة المرور';
	@override String get profile_image_validation => 'يرجى تحديد صورة الملف الشخصي.';
	@override String get password_reset_validation => 'يرجى إدخال بريد إلكتروني صالح لإعادة تعيين كلمة المرور';
	@override String get password_reset_success => 'تم إرسال بريد إعادة تعيين كلمة المرور بنجاح.';
}

// Path: auth.privacy
class _TranslationsAuthPrivacyAr implements TranslationsAuthPrivacyEn {
	_TranslationsAuthPrivacyAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get accept_text => 'من خلال إنشاء حساب، أوافق على ';
	@override String get terms_of_use => 'شروط الاستخدام';
	@override String get separator => ' و ';
	@override String get privacy_policy => 'سياسة الخصوصية';
}

// Path: auth.errors
class _TranslationsAuthErrorsAr implements TranslationsAuthErrorsEn {
	_TranslationsAuthErrorsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get profile_load_failed => 'فشل تحميل ملف المستخدم الشخصي';
}

// Path: errors.network
class _TranslationsErrorsNetworkAr implements TranslationsErrorsNetworkEn {
	_TranslationsErrorsNetworkAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get no_connection => 'لا يوجد اتصال بالإنترنت.';
	@override String get timeout => 'انتهت مهلة الطلب';
	@override String get cancelled => 'تم إلغاء الطلب';
}

// Path: errors.server
class _TranslationsErrorsServerAr implements TranslationsErrorsServerEn {
	_TranslationsErrorsServerAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get bad_certificate => 'شهادة SSL غير صالحة';
	@override String get error => 'خطأ في الخادم';
	@override String get something_wrong => 'حدث خطأ من جانبنا. يرجى المحاولة مرة أخرى لاحقًا.';
	@override String get unhandled => 'خطأ HTTP غير معالج: {statusCode}';
}

// Path: errors.auth
class _TranslationsErrorsAuthAr implements TranslationsErrorsAuthEn {
	_TranslationsErrorsAuthAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get unauthorized => 'طلب غير مصرح به.';
	@override String get session_expired => 'انتهت صلاحية جلستك. يرجى تسجيل الدخول مرة أخرى.';
}

// Path: errors.cache
class _TranslationsErrorsCacheAr implements TranslationsErrorsCacheEn {
	_TranslationsErrorsCacheAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get operation_failed => 'فشلت عملية التخزين المؤقت.';
	@override String get load_failed => 'غير قادر على تحميل البيانات المحفوظة.';
}

// Path: errors.validation
class _TranslationsErrorsValidationAr implements TranslationsErrorsValidationEn {
	_TranslationsErrorsValidationAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get invalid_request => 'طلب غير صالح. يرجى التحقق من إدخالك.';
	@override String get no_permission => 'ليس لديك إذن لإجراء هذا الإجراء.';
	@override String get not_found => 'لم يتم العثور على المورد المطلوب.';
	@override String get already_exists => 'هذه البيانات موجودة بالفعل.';
	@override String get invalid_data => 'البيانات المقدمة غير صالحة.';
}

// Path: errors.unknown
class _TranslationsErrorsUnknownAr implements TranslationsErrorsUnknownEn {
	_TranslationsErrorsUnknownAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get unexpected => 'حدث استثناء غير متوقع.';
	@override String get error_occurred => 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
}

// Path: errors.general
class _TranslationsErrorsGeneralAr implements TranslationsErrorsGeneralEn {
	_TranslationsErrorsGeneralAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get something_wrong => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';
}

// Path: errors.api
class _TranslationsErrorsApiAr implements TranslationsErrorsApiEn {
	_TranslationsErrorsApiAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get no_internet => 'لا يوجد اتصال بالإنترنت';
	@override String get request_failed => 'فشل الطلب';
}

// Path: errors.products
class _TranslationsErrorsProductsAr implements TranslationsErrorsProductsEn {
	_TranslationsErrorsProductsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get could_not_load_more => 'لم يتمكن من تحميل المزيد من المنتجات';
	@override String get load_failure => 'لم يتمكن من تحميل المزيد من المنتجات';
}

// Path: common.navigation
class _TranslationsCommonNavigationAr implements TranslationsCommonNavigationEn {
	_TranslationsCommonNavigationAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get home => 'الرئيسية';
	@override String get cart => 'السلة';
	@override String get categories => 'الفئات';
	@override String get settings => 'الإعدادات';
	@override String get discover => 'اكتشف';
}

// Path: common.buttons
class _TranslationsCommonButtonsAr implements TranslationsCommonButtonsEn {
	_TranslationsCommonButtonsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'إلغاء';
	@override String get logout => 'تسجيل الخروج';
	@override String get retry => 'أعد المحاولة';
	@override String get clear_all => 'مسح الكل';
}

// Path: common.labels
class _TranslationsCommonLabelsAr implements TranslationsCommonLabelsEn {
	_TranslationsCommonLabelsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get search_products => 'ابحث عن المنتجات...';
	@override String get all_categories => 'الكل';
	@override String get price_label => 'السعر: ';
	@override String get currency => '\$';
	@override String get loading => 'جاري تحميل الملف الشخصي...';
	@override String get guest_user => 'مستخدم ضيف';
}

// Path: common.empty_states
class _TranslationsCommonEmptyStatesAr implements TranslationsCommonEmptyStatesEn {
	_TranslationsCommonEmptyStatesAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get no_results_found => 'لم يتم العثور على نتائج';
	@override String get search_empty => 'لم نتمكن من العثور على أي منتجات تطابق بحثك. حاول تعديل كلمات البحث الخاصة بك.';
	@override String get filter_empty => 'لم نتمكن من العثور على أي منتجات تطابق المرشحات الخاصة بك. حاول تعديل المرشحات الخاصة بك.';
	@override String get no_suggestions => 'لم يتم العثور على اقتراحات';
}

// Path: common.errors
class _TranslationsCommonErrorsAr implements TranslationsCommonErrorsEn {
	_TranslationsCommonErrorsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get error_loading_profile => 'خطأ في تحميل الملف الشخصي';
	@override String get not_authenticated => 'يرجى تسجيل الدخول للوصول إلى الميزات الكاملة';
}

// Path: settings.screens
class _TranslationsSettingsScreensAr implements TranslationsSettingsScreensEn {
	_TranslationsSettingsScreensAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الإعدادات';
}

// Path: settings.sections
class _TranslationsSettingsSectionsAr implements TranslationsSettingsSectionsEn {
	_TranslationsSettingsSectionsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get preferences => 'التفضيلات';
	@override String get more => 'المزيد';
}

// Path: settings.options
class _TranslationsSettingsOptionsAr implements TranslationsSettingsOptionsEn {
	_TranslationsSettingsOptionsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get dark_mode => 'الوضع الليلي';
	@override String get notifications => 'الإخطارات';
	@override String get help_support => 'المساعدة والدعم';
	@override String get about_app => 'حول التطبيق';
	@override String get version => 'الإصدار 1.0.0';
}

// Path: settings.buttons
class _TranslationsSettingsButtonsAr implements TranslationsSettingsButtonsEn {
	_TranslationsSettingsButtonsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get logout => 'تسجيل الخروج';
}

// Path: settings.dialogs
class _TranslationsSettingsDialogsAr implements TranslationsSettingsDialogsEn {
	_TranslationsSettingsDialogsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get logout_title => 'تسجيل الخروج';
	@override String get logout_confirmation => 'هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟';
}

// Path: products.info
class _TranslationsProductsInfoAr implements TranslationsProductsInfoEn {
	_TranslationsProductsInfoAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get category => 'الفئة: {category}';
	@override String get in_stock => 'متوفر ({stock})';
	@override String get out_of_stock => 'غير متوفر';
	@override String get description_title => 'الوصف';
}

// Path: products.actions
class _TranslationsProductsActionsAr implements TranslationsProductsActionsEn {
	_TranslationsProductsActionsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get add_to_cart => 'أضف إلى السلة';
	@override String get update_cart_quantity => 'تحديث كمية الإضافة إلى السلة';
}

// Path: products.cart
class _TranslationsProductsCartAr implements TranslationsProductsCartEn {
	_TranslationsProductsCartAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get display_log => 'عرض عنصر السلة: {id}';
	@override String get badge_max => '99+';
}

// Path: home.filters
class _TranslationsHomeFiltersAr implements TranslationsHomeFiltersEn {
	_TranslationsHomeFiltersAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'المرشحات';
	@override String get categories_label => 'الفئات';
	@override String get price_range_label => 'نطاق السعر';
	@override String get sort_by_label => 'ترتيب حسب';
	@override String get order_by_label => 'طلبية بواسطة';
	@override String get min_price => 'السعر الأدنى';
	@override String get max_price => 'السعر الأقصى';
	@override String get separator => '—';
	@override String get apply_button => 'تطبيق {count} مرشح{plural}';
	@override String get apply_button_default => 'تطبيق المرشحات';
	@override String get max_price_validation => 'يجب أن يكون السعر الأقصى أكبر من السعر الأدنى';
}

/// The flat map containing all translations for locale <ar>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsAr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.validation.full_name_required' => 'يرجى إدخال اسمك',
			'auth.validation.full_name_invalid' => 'يجب أن يكون الاسم الاسم الأول والأخير مفصولين بمسافة',
			'auth.validation.email_required' => 'يرجى إدخال عنوان بريدك الإلكتروني',
			'auth.validation.email_invalid' => 'يرجى إدخال عنوان بريد إلكتروني صالح',
			'auth.validation.password_required' => 'يرجى إدخال كلمة المرور الخاصة بك',
			'auth.validation.password_too_short' => 'يجب أن تكون كلمة المرور 8 أحرف على الأقل',
			'auth.validation.confirm_password_required' => 'يرجى تأكيد كلمة المرور الخاصة بك',
			'auth.validation.passwords_not_match' => 'كلمات المرور غير متطابقة',
			'auth.forms.full_name_label' => 'الاسم الكامل',
			'auth.forms.full_name_hint' => 'أدخل اسمك',
			'auth.forms.email_label' => 'عنوان البريد الإلكتروني',
			'auth.forms.email_hint' => 'example@email.com',
			'auth.forms.password_label' => 'كلمة المرور',
			'auth.forms.password_hint' => '* * * * * * * *',
			'auth.forms.confirm_password_label' => 'تأكيد كلمة المرور',
			'auth.screens.login_title' => 'تسجيل الدخول',
			'auth.screens.signup_title' => 'إنشاء حساب',
			'auth.screens.forgot_password_link' => 'هل نسيت كلمة المرور',
			'auth.screens.have_account_question' => 'هل لديك حساب بالفعل؟',
			'auth.screens.dont_have_account_question' => 'ليس لديك حساب؟',
			'auth.screens.login_link' => 'تسجيل الدخول',
			'auth.screens.signup_link' => 'إنشاء حساب',
			'auth.buttons.login' => 'تسجيل الدخول',
			'auth.buttons.signup' => 'إنشاء حساب',
			'auth.buttons.verify_email' => 'تحقق من البريد الإلكتروني',
			'auth.buttons.reset_password' => 'إعادة تعيين كلمة المرور',
			'auth.dialogs.verify_email_title' => 'تحقق من عنوان بريدك الإلكتروني',
			'auth.dialogs.enter_code_hint' => 'أدخل الرمز',
			'auth.dialogs.invalid_verification_code' => 'رمز التحقق غير صحيح',
			'auth.dialogs.reset_password_title' => 'إعادة تعيين كلمة المرور',
			'auth.dialogs.profile_image_validation' => 'يرجى تحديد صورة الملف الشخصي.',
			'auth.dialogs.password_reset_validation' => 'يرجى إدخال بريد إلكتروني صالح لإعادة تعيين كلمة المرور',
			'auth.dialogs.password_reset_success' => 'تم إرسال بريد إعادة تعيين كلمة المرور بنجاح.',
			'auth.privacy.accept_text' => 'من خلال إنشاء حساب، أوافق على ',
			'auth.privacy.terms_of_use' => 'شروط الاستخدام',
			'auth.privacy.separator' => ' و ',
			'auth.privacy.privacy_policy' => 'سياسة الخصوصية',
			'auth.errors.profile_load_failed' => 'فشل تحميل ملف المستخدم الشخصي',
			'errors.network.no_connection' => 'لا يوجد اتصال بالإنترنت.',
			'errors.network.timeout' => 'انتهت مهلة الطلب',
			'errors.network.cancelled' => 'تم إلغاء الطلب',
			'errors.server.bad_certificate' => 'شهادة SSL غير صالحة',
			'errors.server.error' => 'خطأ في الخادم',
			'errors.server.something_wrong' => 'حدث خطأ من جانبنا. يرجى المحاولة مرة أخرى لاحقًا.',
			'errors.server.unhandled' => 'خطأ HTTP غير معالج: {statusCode}',
			'errors.auth.unauthorized' => 'طلب غير مصرح به.',
			'errors.auth.session_expired' => 'انتهت صلاحية جلستك. يرجى تسجيل الدخول مرة أخرى.',
			'errors.cache.operation_failed' => 'فشلت عملية التخزين المؤقت.',
			'errors.cache.load_failed' => 'غير قادر على تحميل البيانات المحفوظة.',
			'errors.validation.invalid_request' => 'طلب غير صالح. يرجى التحقق من إدخالك.',
			'errors.validation.no_permission' => 'ليس لديك إذن لإجراء هذا الإجراء.',
			'errors.validation.not_found' => 'لم يتم العثور على المورد المطلوب.',
			'errors.validation.already_exists' => 'هذه البيانات موجودة بالفعل.',
			'errors.validation.invalid_data' => 'البيانات المقدمة غير صالحة.',
			'errors.unknown.unexpected' => 'حدث استثناء غير متوقع.',
			'errors.unknown.error_occurred' => 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
			'errors.general.something_wrong' => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
			'errors.api.no_internet' => 'لا يوجد اتصال بالإنترنت',
			'errors.api.request_failed' => 'فشل الطلب',
			'errors.products.could_not_load_more' => 'لم يتمكن من تحميل المزيد من المنتجات',
			'errors.products.load_failure' => 'لم يتمكن من تحميل المزيد من المنتجات',
			'common.navigation.home' => 'الرئيسية',
			'common.navigation.cart' => 'السلة',
			'common.navigation.categories' => 'الفئات',
			'common.navigation.settings' => 'الإعدادات',
			'common.navigation.discover' => 'اكتشف',
			'common.buttons.cancel' => 'إلغاء',
			'common.buttons.logout' => 'تسجيل الخروج',
			'common.buttons.retry' => 'أعد المحاولة',
			'common.buttons.clear_all' => 'مسح الكل',
			'common.labels.search_products' => 'ابحث عن المنتجات...',
			'common.labels.all_categories' => 'الكل',
			'common.labels.price_label' => 'السعر: ',
			'common.labels.currency' => '\$',
			'common.labels.loading' => 'جاري تحميل الملف الشخصي...',
			'common.labels.guest_user' => 'مستخدم ضيف',
			'common.empty_states.no_results_found' => 'لم يتم العثور على نتائج',
			'common.empty_states.search_empty' => 'لم نتمكن من العثور على أي منتجات تطابق بحثك. حاول تعديل كلمات البحث الخاصة بك.',
			'common.empty_states.filter_empty' => 'لم نتمكن من العثور على أي منتجات تطابق المرشحات الخاصة بك. حاول تعديل المرشحات الخاصة بك.',
			'common.empty_states.no_suggestions' => 'لم يتم العثور على اقتراحات',
			'common.errors.error_loading_profile' => 'خطأ في تحميل الملف الشخصي',
			'common.errors.not_authenticated' => 'يرجى تسجيل الدخول للوصول إلى الميزات الكاملة',
			'settings.screens.title' => 'الإعدادات',
			'settings.sections.preferences' => 'التفضيلات',
			'settings.sections.more' => 'المزيد',
			'settings.options.dark_mode' => 'الوضع الليلي',
			'settings.options.notifications' => 'الإخطارات',
			'settings.options.help_support' => 'المساعدة والدعم',
			'settings.options.about_app' => 'حول التطبيق',
			'settings.options.version' => 'الإصدار 1.0.0',
			'settings.buttons.logout' => 'تسجيل الخروج',
			'settings.dialogs.logout_title' => 'تسجيل الخروج',
			'settings.dialogs.logout_confirmation' => 'هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟',
			'products.info.category' => 'الفئة: {category}',
			'products.info.in_stock' => 'متوفر ({stock})',
			'products.info.out_of_stock' => 'غير متوفر',
			'products.info.description_title' => 'الوصف',
			'products.actions.add_to_cart' => 'أضف إلى السلة',
			'products.actions.update_cart_quantity' => 'تحديث كمية الإضافة إلى السلة',
			'products.cart.display_log' => 'عرض عنصر السلة: {id}',
			'products.cart.badge_max' => '99+',
			'home.filters.title' => 'المرشحات',
			'home.filters.categories_label' => 'الفئات',
			'home.filters.price_range_label' => 'نطاق السعر',
			'home.filters.sort_by_label' => 'ترتيب حسب',
			'home.filters.order_by_label' => 'طلبية بواسطة',
			'home.filters.min_price' => 'السعر الأدنى',
			'home.filters.max_price' => 'السعر الأقصى',
			'home.filters.separator' => '—',
			'home.filters.apply_button' => 'تطبيق {count} مرشح{plural}',
			'home.filters.apply_button_default' => 'تطبيق المرشحات',
			'home.filters.max_price_validation' => 'يجب أن يكون السعر الأقصى أكبر من السعر الأدنى',
			_ => null,
		};
	}
}
