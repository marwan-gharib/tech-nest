///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsSplashEn splash = TranslationsSplashEn._(_root);
	late final TranslationsCommonEn common = TranslationsCommonEn._(_root);
	late final TranslationsNavEn nav = TranslationsNavEn._(_root);
	late final TranslationsAuthEn auth = TranslationsAuthEn._(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn._(_root);
	late final TranslationsProductsEn products = TranslationsProductsEn._(_root);
	late final TranslationsCartEn cart = TranslationsCartEn._(_root);
	late final TranslationsSettingsEn settings = TranslationsSettingsEn._(_root);
	late final TranslationsErrorsEn errors = TranslationsErrorsEn._(_root);
	late final TranslationsOnboardingEn onboarding = TranslationsOnboardingEn._(_root);
	late final TranslationsCheckoutEn checkout = TranslationsCheckoutEn._(_root);
	late final TranslationsOrdersEn orders = TranslationsOrdersEn._(_root);
	late final TranslationsNotificationsEn notifications = TranslationsNotificationsEn._(_root);
}

// Path: splash
class TranslationsSplashEn {
	TranslationsSplashEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tech Nest'
	String get appName => 'Tech Nest';

	/// en: 'Your ultimate tech shopping destination'
	String get tagline => 'Your ultimate tech shopping destination';
}

// Path: common
class TranslationsCommonEn {
	TranslationsCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Try Again'
	String get retry => 'Try Again';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'All'
	String get all => 'All';

	/// en: 'OK'
	String get ok => 'OK';

	/// en: 'Something went wrong. Please try again.'
	String get error => 'Something went wrong. Please try again.';

	/// en: 'Yes'
	String get yes => 'Yes';

	/// en: 'No'
	String get no => 'No';
}

// Path: nav
class TranslationsNavEn {
	TranslationsNavEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Cart'
	String get cart => 'Cart';

	/// en: 'Categories'
	String get categories => 'Categories';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Orders'
	String get orders => 'Orders';

	/// en: 'Notifications'
	String get notifications => 'Notifications';
}

// Path: auth
class TranslationsAuthEn {
	TranslationsAuthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Log In'
	String get login => 'Log In';

	/// en: 'Sign Up'
	String get signUp => 'Sign Up';

	/// en: 'Full Name'
	String get fullName => 'Full Name';

	/// en: 'Enter your full name'
	String get enterName => 'Enter your full name';

	/// en: 'Email Address'
	String get email => 'Email Address';

	/// en: 'name@example.com'
	String get emailHint => 'name@example.com';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Confirm Password'
	String get confirmPassword => 'Confirm Password';

	/// en: 'Forgot Password?'
	String get forgotPassword => 'Forgot Password?';

	/// en: 'Don't have an account?'
	String get dontHaveAccount => 'Don\'t have an account?';

	/// en: 'Already have an account?'
	String get alreadyHaveAccount => 'Already have an account?';

	/// en: 'Reset Password'
	String get resetPassword => 'Reset Password';

	/// en: 'Enter your email to reset your password.'
	String get resetPasswordPrompt => 'Enter your email to reset your password.';

	/// en: 'password reseted successfully.'
	String get resetPasswordSuccess => 'password reseted successfully.';

	/// en: 'Please select a profile picture.'
	String get selectProfileImage => 'Please select a profile picture.';

	/// en: 'Verify Your Email'
	String get verifyEmailTitle => 'Verify Your Email';

	/// en: 'Verify Email'
	String get verifyEmail => 'Verify Email';

	/// en: 'Enter verification code'
	String get enterCode => 'Enter verification code';

	/// en: 'The code you entered is invalid. Please check and try again.'
	String get invalidCode => 'The code you entered is invalid. Please check and try again.';

	/// en: 'Log Out'
	String get logout => 'Log Out';

	/// en: 'Your email has been verified successfully.'
	String get verifyEmailSuccess => 'Your email has been verified successfully.';

	late final TranslationsAuthPrivacyPolicyEn privacyPolicy = TranslationsAuthPrivacyPolicyEn._(_root);
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Discover'
	String get discover => 'Discover';

	/// en: 'Search for products...'
	String get search => 'Search for products...';

	/// en: 'Filters'
	String get filters => 'Filters';

	/// en: 'Categories'
	String get categories => 'Categories';

	/// en: 'Price Range'
	String get priceRange => 'Price Range';

	/// en: 'Sort by'
	String get sortBy => 'Sort by';

	/// en: 'Order by'
	String get orderBy => 'Order by';

	late final TranslationsHomeSortTypesEn sortTypes = TranslationsHomeSortTypesEn._(_root);
	late final TranslationsHomeOrderTypesEn orderTypes = TranslationsHomeOrderTypesEn._(_root);

	/// en: '(zero) {Apply Filters} (one) {Apply 1 Filter} (other) {Apply $n Filters}'
	String applyFilters({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		zero: 'Apply Filters',
		one: 'Apply 1 Filter',
		other: 'Apply ${n} Filters',
	);

	/// en: 'Active Filters'
	String get activeFilters => 'Active Filters';

	/// en: 'Clear All'
	String get clearAll => 'Clear All';

	/// en: 'Min Price'
	String get minPrice => 'Min Price';

	/// en: 'Max Price'
	String get maxPrice => 'Max Price';
}

// Path: products
class TranslationsProductsEn {
	TranslationsProductsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '$category Products'
	String category({required Object category}) => '${category} Products';

	/// en: '(one) {Only 1 left in stock!} (other) {$n in stock}'
	String inStock({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'Only 1 left in stock!',
		other: '${n} in stock',
	);

	/// en: 'Out of Stock'
	String get outOfStock => 'Out of Stock';

	/// en: 'Add to Cart'
	String get addToCart => 'Add to Cart';

	/// en: 'Update Quantity'
	String get updateCart => 'Update Quantity';

	/// en: 'Product Description'
	String get description => 'Product Description';

	/// en: 'We couldn't load more products. Tap to retry.'
	String get loadMoreFailed => 'We couldn\'t load more products. Tap to retry.';
}

// Path: cart
class TranslationsCartEn {
	TranslationsCartEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'My Cart'
	String get title => 'My Cart';

	/// en: 'Your cart is empty'
	String get empty => 'Your cart is empty';

	/// en: 'Looks like you haven't added anything yet. Explore our products and find something you love!'
	String get emptyDesc => 'Looks like you haven\'t added anything yet. Explore our products and find something you love!';

	/// en: 'Start Shopping'
	String get startShopping => 'Start Shopping';

	/// en: 'Order Summary'
	String get summary => 'Order Summary';

	/// en: 'Subtotal'
	String get subtotal => 'Subtotal';

	/// en: 'Total'
	String get total => 'Total';

	/// en: 'Items'
	String get items => 'Items';

	/// en: 'Delivery'
	String get delivery => 'Delivery';

	/// en: 'Free'
	String get free => 'Free';

	/// en: 'Proceed to Checkout'
	String get checkout => 'Proceed to Checkout';

	/// en: 'Clear Cart'
	String get clearCartTitle => 'Clear Cart';

	/// en: 'Are you sure you want to remove all items from your cart?'
	String get clearCartConfirm => 'Are you sure you want to remove all items from your cart?';

	/// en: 'Yes, clear it'
	String get clearCartYes => 'Yes, clear it';

	/// en: 'No, keep items'
	String get clearCartNo => 'No, keep items';
}

// Path: settings
class TranslationsSettingsEn {
	TranslationsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'App Preferences'
	String get preferences => 'App Preferences';

	/// en: 'Appearance'
	String get theme => 'Appearance';

	/// en: 'Dark Theme'
	String get darkMode => 'Dark Theme';

	/// en: 'Light Theme'
	String get lightMode => 'Light Theme';

	/// en: 'System Default'
	String get systemMode => 'System Default';

	/// en: 'Notifications'
	String get notifications => 'Notifications';

	/// en: 'Help & Support'
	String get help => 'Help & Support';

	/// en: 'About Tech Nest'
	String get about => 'About Tech Nest';

	/// en: 'Log Out'
	String get logout => 'Log Out';

	/// en: 'Are you sure you want to log out?'
	String get logoutConfirm => 'Are you sure you want to log out?';

	/// en: 'You will need to enter your credentials to access your account again.'
	String get logoutDesc => 'You will need to enter your credentials to access your account again.';

	/// en: 'Version $version'
	String version({required Object version}) => 'Version ${version}';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'English'
	String get english => 'English';

	/// en: 'Arabic'
	String get arabic => 'Arabic';

	/// en: 'More Options'
	String get more => 'More Options';
}

// Path: errors
class TranslationsErrorsEn {
	TranslationsErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Refresh'
	String get refresh => 'Refresh';

	/// en: 'No internet connection. Please check your network.'
	String get noInternet => 'No internet connection. Please check your network.';

	/// en: 'Please try again later.'
	String get requestFailed => 'Please try again later.';

	/// en: 'No results found'
	String get noResults => 'No results found';

	/// en: 'We couldn't find anything matching your search. Try different keywords.'
	String get noResultsSearch => 'We couldn\'t find anything matching your search. Try different keywords.';

	/// en: 'We couldn't find any products matching your filters. Try adjusting them.'
	String get noResultsFilter => 'We couldn\'t find any products matching your filters. Try adjusting them.';

	/// en: 'Could not load more items.'
	String get loadMoreFailed => 'Could not load more items.';

	/// en: 'Unable to load saved data.'
	String get cacheError => 'Unable to load saved data.';

	/// en: 'Oops! Something went wrong. Please try again.'
	String get unknownError => 'Oops! Something went wrong. Please try again.';

	/// en: 'Some notifications could not be marked as read.'
	String get someNotificationsNotMaskedAsRead => 'Some notifications could not be marked as read.';
}

// Path: onboarding
class TranslationsOnboardingEn {
	TranslationsOnboardingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Skip'
	String get skip => 'Skip';

	/// en: 'Get Started'
	String get getStarted => 'Get Started';

	List<dynamic> get pages => [
		TranslationsOnboarding$pages$0i0$En._(_root),
		TranslationsOnboarding$pages$0i1$En._(_root),
		TranslationsOnboarding$pages$0i2$En._(_root),
	];
}

// Path: checkout
class TranslationsCheckoutEn {
	TranslationsCheckoutEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Checkout'
	String get title => 'Checkout';

	/// en: 'Select Delivery Location'
	String get selectLocation => 'Select Delivery Location';

	/// en: 'Confirm Location'
	String get confirmLocation => 'Confirm Location';

	/// en: 'Please select a delivery address to continue.'
	String get selectAddressError => 'Please select a delivery address to continue.';

	/// en: 'Delivering to'
	String get addressLabel => 'Delivering to';

	/// en: 'Detecting your location...'
	String get detectingLocation => 'Detecting your location...';

	/// en: 'We couldn't determine your location. Please select it manually.'
	String get locationError => 'We couldn\'t determine your location. Please select it manually.';
}

// Path: orders
class TranslationsOrdersEn {
	TranslationsOrdersEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'My Orders'
	String get title => 'My Orders';

	/// en: 'Order Details'
	String get details => 'Order Details';

	/// en: 'Cancel Order'
	String get cancelOrder => 'Cancel Order';

	/// en: 'Your order has been cancelled successfully.'
	String get cancelSuccess => 'Your order has been cancelled successfully.';

	/// en: 'Are you sure you want to cancel this order?'
	String get cancelConfirm => 'Are you sure you want to cancel this order?';

	/// en: 'Yes, Cancel Order'
	String get cancelYes => 'Yes, Cancel Order';

	/// en: 'No, Keep It'
	String get cancelNo => 'No, Keep It';

	/// en: 'No Orders Found'
	String get emptyStateTitle => 'No Orders Found';

	/// en: 'You have no orders yet. Start shopping now!'
	String get emptyStateMessage => 'You have no orders yet. Start shopping now!';

	/// en: 'Start Shopping'
	String get startShopping => 'Start Shopping';

	/// en: 'Ordered on $date'
	String date({required Object date}) => 'Ordered on ${date}';

	/// en: 'Shipping Address'
	String get shippingAddress => 'Shipping Address';

	/// en: 'Billing Address'
	String get billingAddress => 'Billing Address';

	/// en: 'Order Items'
	String get orderItems => 'Order Items';

	/// en: 'Pick the Delivery Location'
	String get pickLocation => 'Pick the Delivery Location';

	/// en: 'Confirm Order'
	String get confirmOrder => 'Confirm Order';

	late final TranslationsOrdersStatusEn status = TranslationsOrdersStatusEn._(_root);
}

// Path: notifications
class TranslationsNotificationsEn {
	TranslationsNotificationsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notifications'
	String get title => 'Notifications';

	/// en: 'You don't have any notifications yet.'
	String get empty => 'You don\'t have any notifications yet.';

	/// en: 'Mark as read'
	String get markAsRead => 'Mark as read';

	/// en: 'Failed to load notifications. Please try again.'
	String get loadFailed => 'Failed to load notifications. Please try again.';
}

// Path: auth.privacyPolicy
class TranslationsAuthPrivacyPolicyEn {
	TranslationsAuthPrivacyPolicyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'By creating an account, you agree to Tech Nest's '
	String get accept => 'By creating an account, you agree to Tech Nest\'s ';

	/// en: 'Terms of Use'
	String get terms => 'Terms of Use';

	/// en: ' and '
	String get and => ' and ';

	/// en: 'Privacy Policy'
	String get policy => 'Privacy Policy';
}

// Path: home.sortTypes
class TranslationsHomeSortTypesEn {
	TranslationsHomeSortTypesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Price'
	String get price => 'Price';
}

// Path: home.orderTypes
class TranslationsHomeOrderTypesEn {
	TranslationsHomeOrderTypesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Low to High'
	String get asc => 'Low to High';

	/// en: 'High to Low'
	String get desc => 'High to Low';
}

// Path: onboarding.pages.0
class TranslationsOnboarding$pages$0i0$En {
	TranslationsOnboarding$pages$0i0$En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Discover Tech'
	String get title => 'Discover Tech';

	/// en: 'Find the latest and greatest in consumer electronics and smart gadgets.'
	String get description => 'Find the latest and greatest in consumer electronics and smart gadgets.';
}

// Path: onboarding.pages.1
class TranslationsOnboarding$pages$0i1$En {
	TranslationsOnboarding$pages$0i1$En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Secure Payments'
	String get title => 'Secure Payments';

	/// en: 'Shop with confidence using our secure payment gateways.'
	String get description => 'Shop with confidence using our secure payment gateways.';
}

// Path: onboarding.pages.2
class TranslationsOnboarding$pages$0i2$En {
	TranslationsOnboarding$pages$0i2$En._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Fast Delivery'
	String get title => 'Fast Delivery';

	/// en: 'Get your orders delivered to your doorstep in record time.'
	String get description => 'Get your orders delivered to your doorstep in record time.';
}

// Path: orders.status
class TranslationsOrdersStatusEn {
	TranslationsOrdersStatusEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Pending'
	String get pending => 'Pending';

	/// en: 'Confirmed'
	String get confirmed => 'Confirmed';

	/// en: 'Shipped'
	String get shipped => 'Shipped';

	/// en: 'Delivered'
	String get delivered => 'Delivered';

	/// en: 'Cancelled'
	String get cancelled => 'Cancelled';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'splash.appName' => 'Tech Nest',
			'splash.tagline' => 'Your ultimate tech shopping destination',
			'common.retry' => 'Try Again',
			'common.cancel' => 'Cancel',
			'common.all' => 'All',
			'common.ok' => 'OK',
			'common.error' => 'Something went wrong. Please try again.',
			'common.yes' => 'Yes',
			'common.no' => 'No',
			'nav.home' => 'Home',
			'nav.cart' => 'Cart',
			'nav.categories' => 'Categories',
			'nav.settings' => 'Settings',
			'nav.orders' => 'Orders',
			'nav.notifications' => 'Notifications',
			'auth.login' => 'Log In',
			'auth.signUp' => 'Sign Up',
			'auth.fullName' => 'Full Name',
			'auth.enterName' => 'Enter your full name',
			'auth.email' => 'Email Address',
			'auth.emailHint' => 'name@example.com',
			'auth.password' => 'Password',
			'auth.confirmPassword' => 'Confirm Password',
			'auth.forgotPassword' => 'Forgot Password?',
			'auth.dontHaveAccount' => 'Don\'t have an account?',
			'auth.alreadyHaveAccount' => 'Already have an account?',
			'auth.resetPassword' => 'Reset Password',
			'auth.resetPasswordPrompt' => 'Enter your email to reset your password.',
			'auth.resetPasswordSuccess' => 'password reseted successfully.',
			'auth.selectProfileImage' => 'Please select a profile picture.',
			'auth.verifyEmailTitle' => 'Verify Your Email',
			'auth.verifyEmail' => 'Verify Email',
			'auth.enterCode' => 'Enter verification code',
			'auth.invalidCode' => 'The code you entered is invalid. Please check and try again.',
			'auth.logout' => 'Log Out',
			'auth.verifyEmailSuccess' => 'Your email has been verified successfully.',
			'auth.privacyPolicy.accept' => 'By creating an account, you agree to Tech Nest\'s ',
			'auth.privacyPolicy.terms' => 'Terms of Use',
			'auth.privacyPolicy.and' => ' and ',
			'auth.privacyPolicy.policy' => 'Privacy Policy',
			'home.discover' => 'Discover',
			'home.search' => 'Search for products...',
			'home.filters' => 'Filters',
			'home.categories' => 'Categories',
			'home.priceRange' => 'Price Range',
			'home.sortBy' => 'Sort by',
			'home.orderBy' => 'Order by',
			'home.sortTypes.name' => 'Name',
			'home.sortTypes.price' => 'Price',
			'home.orderTypes.asc' => 'Low to High',
			'home.orderTypes.desc' => 'High to Low',
			'home.applyFilters' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, zero: 'Apply Filters', one: 'Apply 1 Filter', other: 'Apply ${n} Filters', ), 
			'home.activeFilters' => 'Active Filters',
			'home.clearAll' => 'Clear All',
			'home.minPrice' => 'Min Price',
			'home.maxPrice' => 'Max Price',
			'products.category' => ({required Object category}) => '${category} Products',
			'products.inStock' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: 'Only 1 left in stock!', other: '${n} in stock', ), 
			'products.outOfStock' => 'Out of Stock',
			'products.addToCart' => 'Add to Cart',
			'products.updateCart' => 'Update Quantity',
			'products.description' => 'Product Description',
			'products.loadMoreFailed' => 'We couldn\'t load more products. Tap to retry.',
			'cart.title' => 'My Cart',
			'cart.empty' => 'Your cart is empty',
			'cart.emptyDesc' => 'Looks like you haven\'t added anything yet. Explore our products and find something you love!',
			'cart.startShopping' => 'Start Shopping',
			'cart.summary' => 'Order Summary',
			'cart.subtotal' => 'Subtotal',
			'cart.total' => 'Total',
			'cart.items' => 'Items',
			'cart.delivery' => 'Delivery',
			'cart.free' => 'Free',
			'cart.checkout' => 'Proceed to Checkout',
			'cart.clearCartTitle' => 'Clear Cart',
			'cart.clearCartConfirm' => 'Are you sure you want to remove all items from your cart?',
			'cart.clearCartYes' => 'Yes, clear it',
			'cart.clearCartNo' => 'No, keep items',
			'settings.title' => 'Settings',
			'settings.preferences' => 'App Preferences',
			'settings.theme' => 'Appearance',
			'settings.darkMode' => 'Dark Theme',
			'settings.lightMode' => 'Light Theme',
			'settings.systemMode' => 'System Default',
			'settings.notifications' => 'Notifications',
			'settings.help' => 'Help & Support',
			'settings.about' => 'About Tech Nest',
			'settings.logout' => 'Log Out',
			'settings.logoutConfirm' => 'Are you sure you want to log out?',
			'settings.logoutDesc' => 'You will need to enter your credentials to access your account again.',
			'settings.version' => ({required Object version}) => 'Version ${version}',
			'settings.language' => 'Language',
			'settings.english' => 'English',
			'settings.arabic' => 'Arabic',
			'settings.more' => 'More Options',
			'errors.refresh' => 'Refresh',
			'errors.noInternet' => 'No internet connection. Please check your network.',
			'errors.requestFailed' => 'Please try again later.',
			'errors.noResults' => 'No results found',
			'errors.noResultsSearch' => 'We couldn\'t find anything matching your search. Try different keywords.',
			'errors.noResultsFilter' => 'We couldn\'t find any products matching your filters. Try adjusting them.',
			'errors.loadMoreFailed' => 'Could not load more items.',
			'errors.cacheError' => 'Unable to load saved data.',
			'errors.unknownError' => 'Oops! Something went wrong. Please try again.',
			'errors.someNotificationsNotMaskedAsRead' => 'Some notifications could not be marked as read.',
			'onboarding.skip' => 'Skip',
			'onboarding.getStarted' => 'Get Started',
			'onboarding.pages.0.title' => 'Discover Tech',
			'onboarding.pages.0.description' => 'Find the latest and greatest in consumer electronics and smart gadgets.',
			'onboarding.pages.1.title' => 'Secure Payments',
			'onboarding.pages.1.description' => 'Shop with confidence using our secure payment gateways.',
			'onboarding.pages.2.title' => 'Fast Delivery',
			'onboarding.pages.2.description' => 'Get your orders delivered to your doorstep in record time.',
			'checkout.title' => 'Checkout',
			'checkout.selectLocation' => 'Select Delivery Location',
			'checkout.confirmLocation' => 'Confirm Location',
			'checkout.selectAddressError' => 'Please select a delivery address to continue.',
			'checkout.addressLabel' => 'Delivering to',
			'checkout.detectingLocation' => 'Detecting your location...',
			'checkout.locationError' => 'We couldn\'t determine your location. Please select it manually.',
			'orders.title' => 'My Orders',
			'orders.details' => 'Order Details',
			'orders.cancelOrder' => 'Cancel Order',
			'orders.cancelSuccess' => 'Your order has been cancelled successfully.',
			'orders.cancelConfirm' => 'Are you sure you want to cancel this order?',
			'orders.cancelYes' => 'Yes, Cancel Order',
			'orders.cancelNo' => 'No, Keep It',
			'orders.emptyStateTitle' => 'No Orders Found',
			'orders.emptyStateMessage' => 'You have no orders yet. Start shopping now!',
			'orders.startShopping' => 'Start Shopping',
			'orders.date' => ({required Object date}) => 'Ordered on ${date}',
			'orders.shippingAddress' => 'Shipping Address',
			'orders.billingAddress' => 'Billing Address',
			'orders.orderItems' => 'Order Items',
			'orders.pickLocation' => 'Pick the Delivery Location',
			'orders.confirmOrder' => 'Confirm Order',
			'orders.status.pending' => 'Pending',
			'orders.status.confirmed' => 'Confirmed',
			'orders.status.shipped' => 'Shipped',
			'orders.status.delivered' => 'Delivered',
			'orders.status.cancelled' => 'Cancelled',
			'notifications.title' => 'Notifications',
			'notifications.empty' => 'You don\'t have any notifications yet.',
			'notifications.markAsRead' => 'Mark as read',
			'notifications.loadFailed' => 'Failed to load notifications. Please try again.',
			_ => null,
		};
	}
}
