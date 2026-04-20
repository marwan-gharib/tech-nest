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
	@override late final _TranslationsCommonAr common = _TranslationsCommonAr._(_root);
	@override late final _TranslationsNavAr nav = _TranslationsNavAr._(_root);
	@override late final _TranslationsAuthAr auth = _TranslationsAuthAr._(_root);
	@override late final _TranslationsHomeAr home = _TranslationsHomeAr._(_root);
	@override late final _TranslationsProductsAr products = _TranslationsProductsAr._(_root);
	@override late final _TranslationsCartAr cart = _TranslationsCartAr._(_root);
	@override late final _TranslationsSettingsAr settings = _TranslationsSettingsAr._(_root);
	@override late final _TranslationsErrorsAr errors = _TranslationsErrorsAr._(_root);
	@override late final _TranslationsOrdersAr orders = _TranslationsOrdersAr._(_root);
}

// Path: common
class _TranslationsCommonAr implements TranslationsCommonEn {
	_TranslationsCommonAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get retry => 'إعادة المحاولة';
	@override String get cancel => 'إلغاء';
	@override String get all => 'الكل';
	@override String get ok => 'حسناً';
	@override String get error => 'حدث خطأ ما';
	@override String get yes => 'نعم';
	@override String get no => 'لا';
}

// Path: nav
class _TranslationsNavAr implements TranslationsNavEn {
	_TranslationsNavAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get home => 'الرئيسية';
	@override String get cart => 'السله';
	@override String get categories => 'الأقسام';
	@override String get settings => 'الإعدادات';
	@override String get orders => 'طلباتي';
}

// Path: auth
class _TranslationsAuthAr implements TranslationsAuthEn {
	_TranslationsAuthAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get login => 'تسجيل الدخول';
	@override String get signUp => 'إنشاء حساب';
	@override String get fullName => 'الاسم الكامل';
	@override String get enterName => 'أدخل اسمك';
	@override String get email => 'البريد الإلكتروني';
	@override String get emailHint => 'example@email.com';
	@override String get password => 'كلمة المرور';
	@override String get confirmPassword => 'تأكيد كلمة المرور';
	@override String get forgotPassword => 'هل نسيت كلمة المرور؟';
	@override String get dontHaveAccount => 'ليس لديك حساب؟';
	@override String get alreadyHaveAccount => 'لديك حساب بالفعل؟';
	@override String get haveAccount => 'هل لديك حساب؟';
	@override String get resetPassword => 'إعادة تعيين كلمة المرور';
	@override String get resetPasswordPrompt => 'يرجى إدخال بريد إلكتروني صالح لإعادة تعيين كلمة المرور';
	@override String get resetPasswordSuccess => 'تم إرسال بريد إعادة تعيين كلمة المرور بنجاح.';
	@override String get selectProfileImage => 'يرجى اختيار صورة الملف الشخصي.';
	@override String get verifyEmailTitle => 'تحقق من بريدك الإلكتروني';
	@override String get verifyEmail => 'التحقق من البريد';
	@override String get enterCode => 'أدخل الرمز';
	@override String get invalidCode => 'رمز التحقق غير صالح';
	@override String get logout => 'تسجيل الخروج';
	@override late final _TranslationsAuthPrivacyPolicyAr privacyPolicy = _TranslationsAuthPrivacyPolicyAr._(_root);
}

// Path: home
class _TranslationsHomeAr implements TranslationsHomeEn {
	_TranslationsHomeAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get discover => 'اكتشف';
	@override String get search => 'بحث عن المنتجات...';
	@override String get filters => 'الفلاتر';
	@override String get categories => 'الأقسام';
	@override String get priceRange => 'نطاق السعر';
	@override String get sortBy => 'فرز حسب';
	@override String get orderBy => 'ترتيب حسب';
	@override late final _TranslationsHomeSortTypesAr sortTypes = _TranslationsHomeSortTypesAr._(_root);
	@override late final _TranslationsHomeOrderTypesAr orderTypes = _TranslationsHomeOrderTypesAr._(_root);
	@override String applyFilters({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n,
		zero: 'تطبيق الفلاتر',
		one: 'تطبيق فلتر 1',
		other: 'تطبيق ${n} فلاتر',
	);
	@override String get activeFilters => 'الفلاتر النشطة';
	@override String get clearAll => 'مسح الكل';
	@override String get minPrice => 'أقل سعر';
	@override String get maxPrice => 'أعلى سعر';
}

// Path: products
class _TranslationsProductsAr implements TranslationsProductsEn {
	_TranslationsProductsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String category({required Object category}) => 'القسم: ${category}';
	@override String inStock({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n,
		one: 'متوفر (1)',
		other: 'متوفر (${n})',
	);
	@override String get outOfStock => 'غير متوفر';
	@override String get addToCart => 'أضف إلى السلة';
	@override String get updateCart => 'تحديث كمية السلة';
	@override String get description => 'الوصف';
}

// Path: cart
class _TranslationsCartAr implements TranslationsCartEn {
	_TranslationsCartAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'سلتي';
	@override String get empty => 'سلة التسوق فارغة';
	@override String get emptyDesc => 'يبدو أنك لم تضف أي شيء إلى سلتك بعد. استكشف منتجاتنا واعثر على شيء تحبه!';
	@override String get startShopping => 'ابدأ التسوق';
	@override String get summary => 'ملخص الطلب';
	@override String get subtotal => 'المجموع الفرعي';
	@override String get total => 'المجموع';
	@override String get items => 'المنتجات';
	@override String get delivery => 'رسوم التوصيل';
	@override String get free => 'مجاني';
	@override String get checkout => 'إتمام الشراء';
}

// Path: settings
class _TranslationsSettingsAr implements TranslationsSettingsEn {
	_TranslationsSettingsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الإعدادات';
	@override String get preferences => 'التفضيلات';
	@override String get darkMode => 'الوضع الليلي';
	@override String get notifications => 'الإشعارات';
	@override String get help => 'المساعدة والدعم';
	@override String get about => 'عن التطبيق';
	@override String get logout => 'تسجيل الخروج';
	@override String get logoutConfirm => 'أنت متأكد أنك تريد تسجيل الخروج؟';
	@override String get logoutDesc => 'سوف يتم توجيهك إلى شاشة تسجيل الدخول.';
	@override String version({required Object version}) => 'الإصدار ${version}';
	@override String get language => 'اللغة';
	@override String get english => 'الإنجليزية';
	@override String get arabic => 'العربية';
	@override String get more => 'المزيد';
}

// Path: errors
class _TranslationsErrorsAr implements TranslationsErrorsEn {
	_TranslationsErrorsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get noInternet => 'لا يوجد اتصال بالإنترنت';
	@override String get requestFailed => 'فشل الطلب';
	@override String get noResults => 'لم يتم العثور على نتائج';
	@override String get noResultsSearch => 'لم نتمكن من العثور على أي منتجات مطابقة لبحثك. حاول تعديل كلمات البحث.';
	@override String get noResultsFilter => 'لم نتمكن من العثور على أي منتجات مطابقة للفلاتر الخاصة بك. حاول تعديل الفلاتر.';
	@override String get loadMoreFailed => 'تعذر تحميل المزيد من المنتجات';
}

// Path: orders
class _TranslationsOrdersAr implements TranslationsOrdersEn {
	_TranslationsOrdersAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'طلباتي';
	@override String get details => 'تفاصيل الطلب';
	@override String get cancelOrder => 'إلغاء الطلب';
	@override String get cancelSuccess => 'تم إلغاء الطلب بنجاح';
	@override String get cancelConfirm => 'هل أنت متأكد أنك تريد إلغاء هذا الطلب؟';
	@override String get cancelYes => 'نعم، إلغاء';
	@override String get cancelNo => 'لا، احتفاظ';
	@override String get emptyState => 'ليس لديك أي طلبات بعد';
	@override String date({required Object date}) => 'تم الطلب في: ${date}';
	@override String get shippingAddress => 'عنوان الشحن';
	@override String get billingAddress => 'عنوان الدفع';
	@override String get orderItems => 'عناصر الطلب';
	@override late final _TranslationsOrdersStatusAr status = _TranslationsOrdersStatusAr._(_root);
}

// Path: auth.privacyPolicy
class _TranslationsAuthPrivacyPolicyAr implements TranslationsAuthPrivacyPolicyEn {
	_TranslationsAuthPrivacyPolicyAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get accept => 'بإنشاء حساب، أوافق على Tech Nest ';
	@override String get terms => 'شروط الاستخدام';
	@override String get and => ' و ';
	@override String get policy => 'سياسة الخصوصية';
}

// Path: home.sortTypes
class _TranslationsHomeSortTypesAr implements TranslationsHomeSortTypesEn {
	_TranslationsHomeSortTypesAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get name => 'الاسم';
	@override String get price => 'السعر';
}

// Path: home.orderTypes
class _TranslationsHomeOrderTypesAr implements TranslationsHomeOrderTypesEn {
	_TranslationsHomeOrderTypesAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get asc => 'تصاعدي';
	@override String get desc => 'تنازلي';
}

// Path: orders.status
class _TranslationsOrdersStatusAr implements TranslationsOrdersStatusEn {
	_TranslationsOrdersStatusAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get pending => 'قيد الانتظار';
	@override String get confirmed => 'مؤكد';
	@override String get shipped => 'تم الشحن';
	@override String get delivered => 'تم التوصيل';
	@override String get cancelled => 'ملغى';
}

/// The flat map containing all translations for locale <ar>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsAr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.retry' => 'إعادة المحاولة',
			'common.cancel' => 'إلغاء',
			'common.all' => 'الكل',
			'common.ok' => 'حسناً',
			'common.error' => 'حدث خطأ ما',
			'common.yes' => 'نعم',
			'common.no' => 'لا',
			'nav.home' => 'الرئيسية',
			'nav.cart' => 'السله',
			'nav.categories' => 'الأقسام',
			'nav.settings' => 'الإعدادات',
			'nav.orders' => 'طلباتي',
			'auth.login' => 'تسجيل الدخول',
			'auth.signUp' => 'إنشاء حساب',
			'auth.fullName' => 'الاسم الكامل',
			'auth.enterName' => 'أدخل اسمك',
			'auth.email' => 'البريد الإلكتروني',
			'auth.emailHint' => 'example@email.com',
			'auth.password' => 'كلمة المرور',
			'auth.confirmPassword' => 'تأكيد كلمة المرور',
			'auth.forgotPassword' => 'هل نسيت كلمة المرور؟',
			'auth.dontHaveAccount' => 'ليس لديك حساب؟',
			'auth.alreadyHaveAccount' => 'لديك حساب بالفعل؟',
			'auth.haveAccount' => 'هل لديك حساب؟',
			'auth.resetPassword' => 'إعادة تعيين كلمة المرور',
			'auth.resetPasswordPrompt' => 'يرجى إدخال بريد إلكتروني صالح لإعادة تعيين كلمة المرور',
			'auth.resetPasswordSuccess' => 'تم إرسال بريد إعادة تعيين كلمة المرور بنجاح.',
			'auth.selectProfileImage' => 'يرجى اختيار صورة الملف الشخصي.',
			'auth.verifyEmailTitle' => 'تحقق من بريدك الإلكتروني',
			'auth.verifyEmail' => 'التحقق من البريد',
			'auth.enterCode' => 'أدخل الرمز',
			'auth.invalidCode' => 'رمز التحقق غير صالح',
			'auth.logout' => 'تسجيل الخروج',
			'auth.privacyPolicy.accept' => 'بإنشاء حساب، أوافق على Tech Nest ',
			'auth.privacyPolicy.terms' => 'شروط الاستخدام',
			'auth.privacyPolicy.and' => ' و ',
			'auth.privacyPolicy.policy' => 'سياسة الخصوصية',
			'home.discover' => 'اكتشف',
			'home.search' => 'بحث عن المنتجات...',
			'home.filters' => 'الفلاتر',
			'home.categories' => 'الأقسام',
			'home.priceRange' => 'نطاق السعر',
			'home.sortBy' => 'فرز حسب',
			'home.orderBy' => 'ترتيب حسب',
			'home.sortTypes.name' => 'الاسم',
			'home.sortTypes.price' => 'السعر',
			'home.orderTypes.asc' => 'تصاعدي',
			'home.orderTypes.desc' => 'تنازلي',
			'home.applyFilters' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n, zero: 'تطبيق الفلاتر', one: 'تطبيق فلتر 1', other: 'تطبيق ${n} فلاتر', ), 
			'home.activeFilters' => 'الفلاتر النشطة',
			'home.clearAll' => 'مسح الكل',
			'home.minPrice' => 'أقل سعر',
			'home.maxPrice' => 'أعلى سعر',
			'products.category' => ({required Object category}) => 'القسم: ${category}',
			'products.inStock' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n, one: 'متوفر (1)', other: 'متوفر (${n})', ), 
			'products.outOfStock' => 'غير متوفر',
			'products.addToCart' => 'أضف إلى السلة',
			'products.updateCart' => 'تحديث كمية السلة',
			'products.description' => 'الوصف',
			'cart.title' => 'سلتي',
			'cart.empty' => 'سلة التسوق فارغة',
			'cart.emptyDesc' => 'يبدو أنك لم تضف أي شيء إلى سلتك بعد. استكشف منتجاتنا واعثر على شيء تحبه!',
			'cart.startShopping' => 'ابدأ التسوق',
			'cart.summary' => 'ملخص الطلب',
			'cart.subtotal' => 'المجموع الفرعي',
			'cart.total' => 'المجموع',
			'cart.items' => 'المنتجات',
			'cart.delivery' => 'رسوم التوصيل',
			'cart.free' => 'مجاني',
			'cart.checkout' => 'إتمام الشراء',
			'settings.title' => 'الإعدادات',
			'settings.preferences' => 'التفضيلات',
			'settings.darkMode' => 'الوضع الليلي',
			'settings.notifications' => 'الإشعارات',
			'settings.help' => 'المساعدة والدعم',
			'settings.about' => 'عن التطبيق',
			'settings.logout' => 'تسجيل الخروج',
			'settings.logoutConfirm' => 'أنت متأكد أنك تريد تسجيل الخروج؟',
			'settings.logoutDesc' => 'سوف يتم توجيهك إلى شاشة تسجيل الدخول.',
			'settings.version' => ({required Object version}) => 'الإصدار ${version}',
			'settings.language' => 'اللغة',
			'settings.english' => 'الإنجليزية',
			'settings.arabic' => 'العربية',
			'settings.more' => 'المزيد',
			'errors.noInternet' => 'لا يوجد اتصال بالإنترنت',
			'errors.requestFailed' => 'فشل الطلب',
			'errors.noResults' => 'لم يتم العثور على نتائج',
			'errors.noResultsSearch' => 'لم نتمكن من العثور على أي منتجات مطابقة لبحثك. حاول تعديل كلمات البحث.',
			'errors.noResultsFilter' => 'لم نتمكن من العثور على أي منتجات مطابقة للفلاتر الخاصة بك. حاول تعديل الفلاتر.',
			'errors.loadMoreFailed' => 'تعذر تحميل المزيد من المنتجات',
			'orders.title' => 'طلباتي',
			'orders.details' => 'تفاصيل الطلب',
			'orders.cancelOrder' => 'إلغاء الطلب',
			'orders.cancelSuccess' => 'تم إلغاء الطلب بنجاح',
			'orders.cancelConfirm' => 'هل أنت متأكد أنك تريد إلغاء هذا الطلب؟',
			'orders.cancelYes' => 'نعم، إلغاء',
			'orders.cancelNo' => 'لا، احتفاظ',
			'orders.emptyState' => 'ليس لديك أي طلبات بعد',
			'orders.date' => ({required Object date}) => 'تم الطلب في: ${date}',
			'orders.shippingAddress' => 'عنوان الشحن',
			'orders.billingAddress' => 'عنوان الدفع',
			'orders.orderItems' => 'عناصر الطلب',
			'orders.status.pending' => 'قيد الانتظار',
			'orders.status.confirmed' => 'مؤكد',
			'orders.status.shipped' => 'تم الشحن',
			'orders.status.delivered' => 'تم التوصيل',
			'orders.status.cancelled' => 'ملغى',
			_ => null,
		};
	}
}
