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
	@override late final _TranslationsOnboardingAr onboarding = _TranslationsOnboardingAr._(_root);
	@override late final _TranslationsCheckoutAr checkout = _TranslationsCheckoutAr._(_root);
	@override late final _TranslationsOrdersAr orders = _TranslationsOrdersAr._(_root);
}

// Path: common
class _TranslationsCommonAr implements TranslationsCommonEn {
	_TranslationsCommonAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get retry => 'حاول مرة أخرى';
	@override String get cancel => 'إلغاء';
	@override String get all => 'الكل';
	@override String get ok => 'موافق';
	@override String get error => 'حدث خطأ ما. يرجى المحاولة لاحقاً.';
	@override String get yes => 'نعم';
	@override String get no => 'لا';
}

// Path: nav
class _TranslationsNavAr implements TranslationsNavEn {
	_TranslationsNavAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get home => 'الرئيسية';
	@override String get cart => 'السلة';
	@override String get categories => 'التصنيفات';
	@override String get settings => 'الإعدادات';
	@override String get orders => 'الطلبات';
}

// Path: auth
class _TranslationsAuthAr implements TranslationsAuthEn {
	_TranslationsAuthAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get login => 'تسجيل الدخول';
	@override String get signUp => 'إنشاء حساب';
	@override String get fullName => 'الاسم الكامل';
	@override String get enterName => 'أدخل اسمك الكامل';
	@override String get email => 'البريد الإلكتروني';
	@override String get emailHint => 'name@example.com';
	@override String get password => 'كلمة المرور';
	@override String get confirmPassword => 'تأكيد كلمة المرور';
	@override String get forgotPassword => 'هل نسيت كلمة المرور؟';
	@override String get dontHaveAccount => 'مستخدم جديد؟';
	@override String get alreadyHaveAccount => 'لديك حساب بالفعل؟';
	@override String get resetPassword => 'إعادة تعيين كلمة المرور';
	@override String get resetPasswordPrompt => 'أدخل بريدك الإلكتروني لتلقي رابط إعادة تعيين كلمة المرور.';
	@override String get resetPasswordSuccess => 'أرسلنا رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.';
	@override String get selectProfileImage => 'يرجى اختيار صورة شخصية.';
	@override String get verifyEmailTitle => 'تأكيد البريد الإلكتروني';
	@override String get verifyEmail => 'تأكيد';
	@override String get enterCode => 'أدخل رمز التحقق';
	@override String get invalidCode => 'الرمز الذي أدخلته غير صالح. يرجى التحقق والمحاولة مرة أخرى.';
	@override String get logout => 'تسجيل الخروج';
	@override late final _TranslationsAuthPrivacyPolicyAr privacyPolicy = _TranslationsAuthPrivacyPolicyAr._(_root);
}

// Path: home
class _TranslationsHomeAr implements TranslationsHomeEn {
	_TranslationsHomeAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get discover => 'اكتشف';
	@override String get search => 'ابحث عن المنتجات...';
	@override String get filters => 'تصفية';
	@override String get categories => 'التصنيفات';
	@override String get priceRange => 'نطاق السعر';
	@override String get sortBy => 'ترتيب حسب';
	@override String get orderBy => 'الترتيب';
	@override late final _TranslationsHomeSortTypesAr sortTypes = _TranslationsHomeSortTypesAr._(_root);
	@override late final _TranslationsHomeOrderTypesAr orderTypes = _TranslationsHomeOrderTypesAr._(_root);
	@override String applyFilters({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n,
		zero: 'تطبيق التصفية',
		one: 'تطبيق تصفية واحدة',
		two: 'تطبيق تصفيتين',
		few: 'تطبيق ${n} تصفيات',
		many: 'تطبيق ${n} تصفية',
		other: 'تطبيق ${n} تصفية',
	);
	@override String get activeFilters => 'التصفيات النشطة';
	@override String get clearAll => 'مسح الكل';
	@override String get minPrice => 'الحد الأدنى للسعر';
	@override String get maxPrice => 'الحد الأقصى للسعر';
}

// Path: products
class _TranslationsProductsAr implements TranslationsProductsEn {
	_TranslationsProductsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String category({required Object category}) => 'منتجات ${category}';
	@override String inStock({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n,
		zero: 'نفذت الكمية',
		one: 'تبقى قطعة واحدة فقط!',
		two: 'تبقى قطعتان',
		few: 'متوفر ${n} قطع',
		many: 'متوفر ${n} قطعة',
		other: 'متوفر ${n}',
	);
	@override String get outOfStock => 'نفذت الكمية';
	@override String get addToCart => 'أضف إلى السلة';
	@override String get updateCart => 'تحديث الكمية';
	@override String get description => 'وصف المنتج';
	@override String get loadMoreFailed => 'لم نتمكن من تحميل المزيد من المنتجات. اضغط للمحاولة مرة أخرى.';
}

// Path: cart
class _TranslationsCartAr implements TranslationsCartEn {
	_TranslationsCartAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'سلتي';
	@override String get empty => 'سلتك فارغة';
	@override String get emptyDesc => 'يبدو أنك لم تضف أي شيء إلى سلتك بعد. استكشف منتجاتنا وابحث عن شيء يعجبك!';
	@override String get startShopping => 'ابدأ التسوق';
	@override String get summary => 'ملخص الطلب';
	@override String get subtotal => 'المجموع الفرعي';
	@override String get total => 'الإجمالي';
	@override String get items => 'العناصر';
	@override String get delivery => 'التوصيل';
	@override String get free => 'مجاني';
	@override String get checkout => 'متابعة الدفع';
	@override String get clearCartTitle => 'إفراغ السلة';
	@override String get clearCartConfirm => 'هل أنت متأكد أنك تريد إزالة جميع العناصر من سلتك؟';
	@override String get clearCartYes => 'نعم، أفرغها';
	@override String get clearCartNo => 'لا، أبقِ العناصر';
}

// Path: settings
class _TranslationsSettingsAr implements TranslationsSettingsEn {
	_TranslationsSettingsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الإعدادات';
	@override String get preferences => 'تفضيلات التطبيق';
	@override String get theme => 'المظهر';
	@override String get darkMode => 'الوضع الداكن';
	@override String get lightMode => 'الوضع الفاتح';
	@override String get systemMode => 'الوضع الافتراضي للنظام';
	@override String get notifications => 'الإشعارات';
	@override String get help => 'المساعدة والدعم';
	@override String get about => 'حول التطبيق';
	@override String get logout => 'تسجيل الخروج';
	@override String get logoutConfirm => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';
	@override String get logoutDesc => 'ستحتاج إلى إدخال بياناتك مرة أخرى للوصول إلى حسابك.';
	@override String version({required Object version}) => 'الإصدار ${version}';
	@override String get language => 'اللغة';
	@override String get english => 'English';
	@override String get arabic => 'العربية';
	@override String get more => 'خيارات إضافية';
}

// Path: errors
class _TranslationsErrorsAr implements TranslationsErrorsEn {
	_TranslationsErrorsAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get noInternet => 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.';
	@override String get requestFailed => 'فشل الطلب. يرجى المحاولة لاحقاً.';
	@override String get noResults => 'لم يتم العثور على نتائج';
	@override String get noResultsSearch => 'لم نتمكن من العثور على ما يطابق بحثك. جرب كلمات مختلفة.';
	@override String get noResultsFilter => 'لم نتمكن من العثور على منتجات تطابق التصفية التي قمت بها. حاول تعديلها.';
	@override String get loadMoreFailed => 'تعذر تحميل المزيد من العناصر.';
	@override String get cacheError => 'تعذر تحميل البيانات المحفوظة.';
	@override String get unknownError => 'عفواً! حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
}

// Path: onboarding
class _TranslationsOnboardingAr implements TranslationsOnboardingEn {
	_TranslationsOnboardingAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get skip => 'تخطي';
	@override String get getStarted => 'ابدأ الآن';
	@override List<dynamic> get pages => [
		_TranslationsOnboarding$pages$0i0$Ar._(_root),
		_TranslationsOnboarding$pages$0i1$Ar._(_root),
		_TranslationsOnboarding$pages$0i2$Ar._(_root),
	];
}

// Path: checkout
class _TranslationsCheckoutAr implements TranslationsCheckoutEn {
	_TranslationsCheckoutAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الدفع';
	@override String get selectLocation => 'اختر موقع التوصيل';
	@override String get confirmLocation => 'تأكيد الموقع';
	@override String get selectAddressError => 'يرجى اختيار عنوان التوصيل للمتابعة.';
	@override String get addressLabel => 'التوصيل إلى';
	@override String get detectingLocation => 'جاري تحديد موقعك...';
	@override String get locationError => 'لم نتمكن من تحديد موقعك. يرجى اختياره يدوياً.';
}

// Path: orders
class _TranslationsOrdersAr implements TranslationsOrdersEn {
	_TranslationsOrdersAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'طلباتي';
	@override String get details => 'تفاصيل الطلب';
	@override String get cancelOrder => 'إلغاء الطلب';
	@override String get cancelSuccess => 'تم إلغاء طلبك بنجاح.';
	@override String get cancelConfirm => 'هل أنت متأكد أنك تريد إلغاء هذا الطلب؟';
	@override String get cancelYes => 'نعم، ألغِ الطلب';
	@override String get cancelNo => 'لا، أبقِ الطلب';
	@override String get emptyState => 'لم تقم بأي طلبات بعد.';
	@override String date({required Object date}) => 'تاريخ الطلب: ${date}';
	@override String get shippingAddress => 'عنوان الشحن';
	@override String get billingAddress => 'عنوان الفواتير';
	@override String get orderItems => 'عناصر الطلب';
	@override String get pickLocation => 'اختر موقع التوصيل';
	@override String get confirmOrder => 'تأكيد الطلب';
	@override late final _TranslationsOrdersStatusAr status = _TranslationsOrdersStatusAr._(_root);
}

// Path: auth.privacyPolicy
class _TranslationsAuthPrivacyPolicyAr implements TranslationsAuthPrivacyPolicyEn {
	_TranslationsAuthPrivacyPolicyAr._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get accept => 'بإنشاء حساب، أنت توافق على ';
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
	@override String get asc => 'من الأقل للأعلى';
	@override String get desc => 'من الأعلى للأقل';
}

// Path: onboarding.pages.0
class _TranslationsOnboarding$pages$0i0$Ar implements TranslationsOnboarding$pages$0i0$En {
	_TranslationsOnboarding$pages$0i0$Ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'اكتشف أحدث التقنيات';
	@override String get description => 'ابحث عن أحدث وأفضل الإلكترونيات والأجهزة الذكية.';
}

// Path: onboarding.pages.1
class _TranslationsOnboarding$pages$0i1$Ar implements TranslationsOnboarding$pages$0i1$En {
	_TranslationsOnboarding$pages$0i1$Ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'دفع آمن';
	@override String get description => 'تسوق بثقة باستخدام بوابات الدفع الآمنة الخاصة بنا.';
}

// Path: onboarding.pages.2
class _TranslationsOnboarding$pages$0i2$Ar implements TranslationsOnboarding$pages$0i2$En {
	_TranslationsOnboarding$pages$0i2$Ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'توصيل سريع';
	@override String get description => 'احصل على طلباتك حتى باب منزلك في وقت قياسي.';
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
			'common.retry' => 'حاول مرة أخرى',
			'common.cancel' => 'إلغاء',
			'common.all' => 'الكل',
			'common.ok' => 'موافق',
			'common.error' => 'حدث خطأ ما. يرجى المحاولة لاحقاً.',
			'common.yes' => 'نعم',
			'common.no' => 'لا',
			'nav.home' => 'الرئيسية',
			'nav.cart' => 'السلة',
			'nav.categories' => 'التصنيفات',
			'nav.settings' => 'الإعدادات',
			'nav.orders' => 'الطلبات',
			'auth.login' => 'تسجيل الدخول',
			'auth.signUp' => 'إنشاء حساب',
			'auth.fullName' => 'الاسم الكامل',
			'auth.enterName' => 'أدخل اسمك الكامل',
			'auth.email' => 'البريد الإلكتروني',
			'auth.emailHint' => 'name@example.com',
			'auth.password' => 'كلمة المرور',
			'auth.confirmPassword' => 'تأكيد كلمة المرور',
			'auth.forgotPassword' => 'هل نسيت كلمة المرور؟',
			'auth.dontHaveAccount' => 'مستخدم جديد؟',
			'auth.alreadyHaveAccount' => 'لديك حساب بالفعل؟',
			'auth.resetPassword' => 'إعادة تعيين كلمة المرور',
			'auth.resetPasswordPrompt' => 'أدخل بريدك الإلكتروني لتلقي رابط إعادة تعيين كلمة المرور.',
			'auth.resetPasswordSuccess' => 'أرسلنا رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.',
			'auth.selectProfileImage' => 'يرجى اختيار صورة شخصية.',
			'auth.verifyEmailTitle' => 'تأكيد البريد الإلكتروني',
			'auth.verifyEmail' => 'تأكيد',
			'auth.enterCode' => 'أدخل رمز التحقق',
			'auth.invalidCode' => 'الرمز الذي أدخلته غير صالح. يرجى التحقق والمحاولة مرة أخرى.',
			'auth.logout' => 'تسجيل الخروج',
			'auth.privacyPolicy.accept' => 'بإنشاء حساب، أنت توافق على ',
			'auth.privacyPolicy.terms' => 'شروط الاستخدام',
			'auth.privacyPolicy.and' => ' و ',
			'auth.privacyPolicy.policy' => 'سياسة الخصوصية',
			'home.discover' => 'اكتشف',
			'home.search' => 'ابحث عن المنتجات...',
			'home.filters' => 'تصفية',
			'home.categories' => 'التصنيفات',
			'home.priceRange' => 'نطاق السعر',
			'home.sortBy' => 'ترتيب حسب',
			'home.orderBy' => 'الترتيب',
			'home.sortTypes.name' => 'الاسم',
			'home.sortTypes.price' => 'السعر',
			'home.orderTypes.asc' => 'من الأقل للأعلى',
			'home.orderTypes.desc' => 'من الأعلى للأقل',
			'home.applyFilters' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n, zero: 'تطبيق التصفية', one: 'تطبيق تصفية واحدة', two: 'تطبيق تصفيتين', few: 'تطبيق ${n} تصفيات', many: 'تطبيق ${n} تصفية', other: 'تطبيق ${n} تصفية', ), 
			'home.activeFilters' => 'التصفيات النشطة',
			'home.clearAll' => 'مسح الكل',
			'home.minPrice' => 'الحد الأدنى للسعر',
			'home.maxPrice' => 'الحد الأقصى للسعر',
			'products.category' => ({required Object category}) => 'منتجات ${category}',
			'products.inStock' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n, zero: 'نفذت الكمية', one: 'تبقى قطعة واحدة فقط!', two: 'تبقى قطعتان', few: 'متوفر ${n} قطع', many: 'متوفر ${n} قطعة', other: 'متوفر ${n}', ), 
			'products.outOfStock' => 'نفذت الكمية',
			'products.addToCart' => 'أضف إلى السلة',
			'products.updateCart' => 'تحديث الكمية',
			'products.description' => 'وصف المنتج',
			'products.loadMoreFailed' => 'لم نتمكن من تحميل المزيد من المنتجات. اضغط للمحاولة مرة أخرى.',
			'cart.title' => 'سلتي',
			'cart.empty' => 'سلتك فارغة',
			'cart.emptyDesc' => 'يبدو أنك لم تضف أي شيء إلى سلتك بعد. استكشف منتجاتنا وابحث عن شيء يعجبك!',
			'cart.startShopping' => 'ابدأ التسوق',
			'cart.summary' => 'ملخص الطلب',
			'cart.subtotal' => 'المجموع الفرعي',
			'cart.total' => 'الإجمالي',
			'cart.items' => 'العناصر',
			'cart.delivery' => 'التوصيل',
			'cart.free' => 'مجاني',
			'cart.checkout' => 'متابعة الدفع',
			'cart.clearCartTitle' => 'إفراغ السلة',
			'cart.clearCartConfirm' => 'هل أنت متأكد أنك تريد إزالة جميع العناصر من سلتك؟',
			'cart.clearCartYes' => 'نعم، أفرغها',
			'cart.clearCartNo' => 'لا، أبقِ العناصر',
			'settings.title' => 'الإعدادات',
			'settings.preferences' => 'تفضيلات التطبيق',
			'settings.theme' => 'المظهر',
			'settings.darkMode' => 'الوضع الداكن',
			'settings.lightMode' => 'الوضع الفاتح',
			'settings.systemMode' => 'الوضع الافتراضي للنظام',
			'settings.notifications' => 'الإشعارات',
			'settings.help' => 'المساعدة والدعم',
			'settings.about' => 'حول التطبيق',
			'settings.logout' => 'تسجيل الخروج',
			'settings.logoutConfirm' => 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
			'settings.logoutDesc' => 'ستحتاج إلى إدخال بياناتك مرة أخرى للوصول إلى حسابك.',
			'settings.version' => ({required Object version}) => 'الإصدار ${version}',
			'settings.language' => 'اللغة',
			'settings.english' => 'English',
			'settings.arabic' => 'العربية',
			'settings.more' => 'خيارات إضافية',
			'errors.noInternet' => 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.',
			'errors.requestFailed' => 'فشل الطلب. يرجى المحاولة لاحقاً.',
			'errors.noResults' => 'لم يتم العثور على نتائج',
			'errors.noResultsSearch' => 'لم نتمكن من العثور على ما يطابق بحثك. جرب كلمات مختلفة.',
			'errors.noResultsFilter' => 'لم نتمكن من العثور على منتجات تطابق التصفية التي قمت بها. حاول تعديلها.',
			'errors.loadMoreFailed' => 'تعذر تحميل المزيد من العناصر.',
			'errors.cacheError' => 'تعذر تحميل البيانات المحفوظة.',
			'errors.unknownError' => 'عفواً! حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.',
			'onboarding.skip' => 'تخطي',
			'onboarding.getStarted' => 'ابدأ الآن',
			'onboarding.pages.0.title' => 'اكتشف أحدث التقنيات',
			'onboarding.pages.0.description' => 'ابحث عن أحدث وأفضل الإلكترونيات والأجهزة الذكية.',
			'onboarding.pages.1.title' => 'دفع آمن',
			'onboarding.pages.1.description' => 'تسوق بثقة باستخدام بوابات الدفع الآمنة الخاصة بنا.',
			'onboarding.pages.2.title' => 'توصيل سريع',
			'onboarding.pages.2.description' => 'احصل على طلباتك حتى باب منزلك في وقت قياسي.',
			'checkout.title' => 'الدفع',
			'checkout.selectLocation' => 'اختر موقع التوصيل',
			'checkout.confirmLocation' => 'تأكيد الموقع',
			'checkout.selectAddressError' => 'يرجى اختيار عنوان التوصيل للمتابعة.',
			'checkout.addressLabel' => 'التوصيل إلى',
			'checkout.detectingLocation' => 'جاري تحديد موقعك...',
			'checkout.locationError' => 'لم نتمكن من تحديد موقعك. يرجى اختياره يدوياً.',
			'orders.title' => 'طلباتي',
			'orders.details' => 'تفاصيل الطلب',
			'orders.cancelOrder' => 'إلغاء الطلب',
			'orders.cancelSuccess' => 'تم إلغاء طلبك بنجاح.',
			'orders.cancelConfirm' => 'هل أنت متأكد أنك تريد إلغاء هذا الطلب؟',
			'orders.cancelYes' => 'نعم، ألغِ الطلب',
			'orders.cancelNo' => 'لا، أبقِ الطلب',
			'orders.emptyState' => 'لم تقم بأي طلبات بعد.',
			'orders.date' => ({required Object date}) => 'تاريخ الطلب: ${date}',
			'orders.shippingAddress' => 'عنوان الشحن',
			'orders.billingAddress' => 'عنوان الفواتير',
			'orders.orderItems' => 'عناصر الطلب',
			'orders.pickLocation' => 'اختر موقع التوصيل',
			'orders.confirmOrder' => 'تأكيد الطلب',
			'orders.status.pending' => 'قيد الانتظار',
			'orders.status.confirmed' => 'مؤكد',
			'orders.status.shipped' => 'تم الشحن',
			'orders.status.delivered' => 'تم التوصيل',
			'orders.status.cancelled' => 'ملغى',
			_ => null,
		};
	}
}
