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
	late final TranslationsCommonEn common = TranslationsCommonEn._(_root);
	late final TranslationsNavEn nav = TranslationsNavEn._(_root);
	late final TranslationsAuthEn auth = TranslationsAuthEn._(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn._(_root);
	late final TranslationsProductsEn products = TranslationsProductsEn._(_root);
	late final TranslationsCartEn cart = TranslationsCartEn._(_root);
	late final TranslationsSettingsEn settings = TranslationsSettingsEn._(_root);
	late final TranslationsErrorsEn errors = TranslationsErrorsEn._(_root);
	late final TranslationsOrdersEn orders = TranslationsOrdersEn._(_root);
}

// Path: common
class TranslationsCommonEn {
	TranslationsCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'All'
	String get all => 'All';

	/// en: 'OK'
	String get ok => 'OK';

	/// en: 'Something went wrong'
	String get error => 'Something went wrong';

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
}

// Path: auth
class TranslationsAuthEn {
	TranslationsAuthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Login'
	String get login => 'Login';

	/// en: 'Sign Up'
	String get signUp => 'Sign Up';

	/// en: 'Full Name'
	String get fullName => 'Full Name';

	/// en: 'Enter your name'
	String get enterName => 'Enter your name';

	/// en: 'E-mail Address'
	String get email => 'E-mail Address';

	/// en: 'example@email.com'
	String get emailHint => 'example@email.com';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Confirm Password'
	String get confirmPassword => 'Confirm Password';

	/// en: 'Forget password'
	String get forgotPassword => 'Forget password';

	/// en: 'Don't have an account?'
	String get dontHaveAccount => 'Don\'t have an account?';

	/// en: 'Already have an account?'
	String get alreadyHaveAccount => 'Already have an account?';

	/// en: 'Have an account?'
	String get haveAccount => 'Have an account?';

	/// en: 'Reset Password'
	String get resetPassword => 'Reset Password';

	/// en: 'Please enter a valid email to reset password'
	String get resetPasswordPrompt => 'Please enter a valid email to reset password';

	/// en: 'Password reset email sent successfully.'
	String get resetPasswordSuccess => 'Password reset email sent successfully.';

	/// en: 'Please select a profile image.'
	String get selectProfileImage => 'Please select a profile image.';

	/// en: 'Verify your E-mail address'
	String get verifyEmailTitle => 'Verify your E-mail address';

	/// en: 'Verify Email'
	String get verifyEmail => 'Verify Email';

	/// en: 'Enter code'
	String get enterCode => 'Enter code';

	/// en: 'Invalid verification code'
	String get invalidCode => 'Invalid verification code';

	/// en: 'Logout'
	String get logout => 'Logout';

	late final TranslationsAuthPrivacyPolicyEn privacyPolicy = TranslationsAuthPrivacyPolicyEn._(_root);
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Discover'
	String get discover => 'Discover';

	/// en: 'Search products...'
	String get search => 'Search products...';

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

	/// en: 'Category: $category'
	String category({required Object category}) => 'Category: ${category}';

	/// en: '(one) {In Stock (1)} (other) {In Stock ($n)}'
	String inStock({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'In Stock (1)',
		other: 'In Stock (${n})',
	);

	/// en: 'Out of Stock'
	String get outOfStock => 'Out of Stock';

	/// en: 'Add to Cart'
	String get addToCart => 'Add to Cart';

	/// en: 'Update Cart Quantity'
	String get updateCart => 'Update Cart Quantity';

	/// en: 'Description'
	String get description => 'Description';
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

	/// en: 'Looks like you haven't added anything to your cart yet. Explore our products and find something you love!'
	String get emptyDesc => 'Looks like you haven\'t added anything to your cart yet. Explore our products and find something you love!';

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

	/// en: 'Delivery Charges'
	String get delivery => 'Delivery Charges';

	/// en: 'Free'
	String get free => 'Free';

	/// en: 'Checkout'
	String get checkout => 'Checkout';
}

// Path: settings
class TranslationsSettingsEn {
	TranslationsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Preferences'
	String get preferences => 'Preferences';

	/// en: 'Dark Mode'
	String get darkMode => 'Dark Mode';

	/// en: 'Notifications'
	String get notifications => 'Notifications';

	/// en: 'Help & Support'
	String get help => 'Help & Support';

	/// en: 'About App'
	String get about => 'About App';

	/// en: 'Logout'
	String get logout => 'Logout';

	/// en: 'Are you sure you want to log out?'
	String get logoutConfirm => 'Are you sure you want to log out?';

	/// en: 'You will be redirected to the login screen.'
	String get logoutDesc => 'You will be redirected to the login screen.';

	/// en: 'Version $version'
	String version({required Object version}) => 'Version ${version}';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'English'
	String get english => 'English';

	/// en: 'Arabic'
	String get arabic => 'Arabic';

	/// en: 'More'
	String get more => 'More';
}

// Path: errors
class TranslationsErrorsEn {
	TranslationsErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No Internet Connection'
	String get noInternet => 'No Internet Connection';

	/// en: 'Request Failed'
	String get requestFailed => 'Request Failed';

	/// en: 'No results found'
	String get noResults => 'No results found';

	/// en: 'We couldn't find what you're looking for. Try a different search.'
	String get noResultsSearch => 'We couldn\'t find what you\'re looking for. Try a different search.';

	/// en: 'We couldn't find any products matching your filters. Try adjusting your filters.'
	String get noResultsFilter => 'We couldn\'t find any products matching your filters. Try adjusting your filters.';

	/// en: 'Could not load more products'
	String get loadMoreFailed => 'Could not load more products';
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

	/// en: 'Order cancelled successfully'
	String get cancelSuccess => 'Order cancelled successfully';

	/// en: 'Are you sure you want to cancel this order?'
	String get cancelConfirm => 'Are you sure you want to cancel this order?';

	/// en: 'Yes, Cancel'
	String get cancelYes => 'Yes, Cancel';

	/// en: 'No, Keep'
	String get cancelNo => 'No, Keep';

	/// en: 'You don't have any orders yet'
	String get emptyState => 'You don\'t have any orders yet';

	/// en: 'Ordered on: $date'
	String date({required Object date}) => 'Ordered on: ${date}';

	/// en: 'Shipping Address'
	String get shippingAddress => 'Shipping Address';

	/// en: 'Billing Address'
	String get billingAddress => 'Billing Address';

	/// en: 'Order Items'
	String get orderItems => 'Order Items';

	late final TranslationsOrdersStatusEn status = TranslationsOrdersStatusEn._(_root);
}

// Path: auth.privacyPolicy
class TranslationsAuthPrivacyPolicyEn {
	TranslationsAuthPrivacyPolicyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'By Creating an Account, i accept Tech Nest '
	String get accept => 'By Creating an Account, i accept Tech Nest ';

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

	/// en: 'Ascending'
	String get asc => 'Ascending';

	/// en: 'Descending'
	String get desc => 'Descending';
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
			'common.retry' => 'Retry',
			'common.cancel' => 'Cancel',
			'common.all' => 'All',
			'common.ok' => 'OK',
			'common.error' => 'Something went wrong',
			'common.yes' => 'Yes',
			'common.no' => 'No',
			'nav.home' => 'Home',
			'nav.cart' => 'Cart',
			'nav.categories' => 'Categories',
			'nav.settings' => 'Settings',
			'nav.orders' => 'Orders',
			'auth.login' => 'Login',
			'auth.signUp' => 'Sign Up',
			'auth.fullName' => 'Full Name',
			'auth.enterName' => 'Enter your name',
			'auth.email' => 'E-mail Address',
			'auth.emailHint' => 'example@email.com',
			'auth.password' => 'Password',
			'auth.confirmPassword' => 'Confirm Password',
			'auth.forgotPassword' => 'Forget password',
			'auth.dontHaveAccount' => 'Don\'t have an account?',
			'auth.alreadyHaveAccount' => 'Already have an account?',
			'auth.haveAccount' => 'Have an account?',
			'auth.resetPassword' => 'Reset Password',
			'auth.resetPasswordPrompt' => 'Please enter a valid email to reset password',
			'auth.resetPasswordSuccess' => 'Password reset email sent successfully.',
			'auth.selectProfileImage' => 'Please select a profile image.',
			'auth.verifyEmailTitle' => 'Verify your E-mail address',
			'auth.verifyEmail' => 'Verify Email',
			'auth.enterCode' => 'Enter code',
			'auth.invalidCode' => 'Invalid verification code',
			'auth.logout' => 'Logout',
			'auth.privacyPolicy.accept' => 'By Creating an Account, i accept Tech Nest ',
			'auth.privacyPolicy.terms' => 'Terms of Use',
			'auth.privacyPolicy.and' => ' and ',
			'auth.privacyPolicy.policy' => 'Privacy Policy',
			'home.discover' => 'Discover',
			'home.search' => 'Search products...',
			'home.filters' => 'Filters',
			'home.categories' => 'Categories',
			'home.priceRange' => 'Price Range',
			'home.sortBy' => 'Sort by',
			'home.orderBy' => 'Order by',
			'home.sortTypes.name' => 'Name',
			'home.sortTypes.price' => 'Price',
			'home.orderTypes.asc' => 'Ascending',
			'home.orderTypes.desc' => 'Descending',
			'home.applyFilters' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, zero: 'Apply Filters', one: 'Apply 1 Filter', other: 'Apply ${n} Filters', ), 
			'home.activeFilters' => 'Active Filters',
			'home.clearAll' => 'Clear All',
			'home.minPrice' => 'Min Price',
			'home.maxPrice' => 'Max Price',
			'products.category' => ({required Object category}) => 'Category: ${category}',
			'products.inStock' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: 'In Stock (1)', other: 'In Stock (${n})', ), 
			'products.outOfStock' => 'Out of Stock',
			'products.addToCart' => 'Add to Cart',
			'products.updateCart' => 'Update Cart Quantity',
			'products.description' => 'Description',
			'cart.title' => 'My Cart',
			'cart.empty' => 'Your cart is empty',
			'cart.emptyDesc' => 'Looks like you haven\'t added anything to your cart yet. Explore our products and find something you love!',
			'cart.startShopping' => 'Start Shopping',
			'cart.summary' => 'Order Summary',
			'cart.subtotal' => 'Subtotal',
			'cart.total' => 'Total',
			'cart.items' => 'Items',
			'cart.delivery' => 'Delivery Charges',
			'cart.free' => 'Free',
			'cart.checkout' => 'Checkout',
			'settings.title' => 'Settings',
			'settings.preferences' => 'Preferences',
			'settings.darkMode' => 'Dark Mode',
			'settings.notifications' => 'Notifications',
			'settings.help' => 'Help & Support',
			'settings.about' => 'About App',
			'settings.logout' => 'Logout',
			'settings.logoutConfirm' => 'Are you sure you want to log out?',
			'settings.logoutDesc' => 'You will be redirected to the login screen.',
			'settings.version' => ({required Object version}) => 'Version ${version}',
			'settings.language' => 'Language',
			'settings.english' => 'English',
			'settings.arabic' => 'Arabic',
			'settings.more' => 'More',
			'errors.noInternet' => 'No Internet Connection',
			'errors.requestFailed' => 'Request Failed',
			'errors.noResults' => 'No results found',
			'errors.noResultsSearch' => 'We couldn\'t find what you\'re looking for. Try a different search.',
			'errors.noResultsFilter' => 'We couldn\'t find any products matching your filters. Try adjusting your filters.',
			'errors.loadMoreFailed' => 'Could not load more products',
			'orders.title' => 'My Orders',
			'orders.details' => 'Order Details',
			'orders.cancelOrder' => 'Cancel Order',
			'orders.cancelSuccess' => 'Order cancelled successfully',
			'orders.cancelConfirm' => 'Are you sure you want to cancel this order?',
			'orders.cancelYes' => 'Yes, Cancel',
			'orders.cancelNo' => 'No, Keep',
			'orders.emptyState' => 'You don\'t have any orders yet',
			'orders.date' => ({required Object date}) => 'Ordered on: ${date}',
			'orders.shippingAddress' => 'Shipping Address',
			'orders.billingAddress' => 'Billing Address',
			'orders.orderItems' => 'Order Items',
			'orders.status.pending' => 'Pending',
			'orders.status.confirmed' => 'Confirmed',
			'orders.status.shipped' => 'Shipped',
			'orders.status.delivered' => 'Delivered',
			'orders.status.cancelled' => 'Cancelled',
			_ => null,
		};
	}
}
