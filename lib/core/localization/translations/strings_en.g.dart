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
	late final TranslationsAuthEn auth = TranslationsAuthEn._(_root);
	late final TranslationsErrorsEn errors = TranslationsErrorsEn._(_root);
	late final TranslationsCommonEn common = TranslationsCommonEn._(_root);
	late final TranslationsSettingsEn settings = TranslationsSettingsEn._(_root);
	late final TranslationsProductsEn products = TranslationsProductsEn._(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn._(_root);
}

// Path: auth
class TranslationsAuthEn {
	TranslationsAuthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsAuthValidationEn validation = TranslationsAuthValidationEn._(_root);
	late final TranslationsAuthFormsEn forms = TranslationsAuthFormsEn._(_root);
	late final TranslationsAuthScreensEn screens = TranslationsAuthScreensEn._(_root);
	late final TranslationsAuthButtonsEn buttons = TranslationsAuthButtonsEn._(_root);
	late final TranslationsAuthDialogsEn dialogs = TranslationsAuthDialogsEn._(_root);
	late final TranslationsAuthPrivacyEn privacy = TranslationsAuthPrivacyEn._(_root);
	late final TranslationsAuthErrorsEn errors = TranslationsAuthErrorsEn._(_root);
}

// Path: errors
class TranslationsErrorsEn {
	TranslationsErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsErrorsNetworkEn network = TranslationsErrorsNetworkEn._(_root);
	late final TranslationsErrorsServerEn server = TranslationsErrorsServerEn._(_root);
	late final TranslationsErrorsAuthEn auth = TranslationsErrorsAuthEn._(_root);
	late final TranslationsErrorsCacheEn cache = TranslationsErrorsCacheEn._(_root);
	late final TranslationsErrorsValidationEn validation = TranslationsErrorsValidationEn._(_root);
	late final TranslationsErrorsUnknownEn unknown = TranslationsErrorsUnknownEn._(_root);
	late final TranslationsErrorsGeneralEn general = TranslationsErrorsGeneralEn._(_root);
	late final TranslationsErrorsApiEn api = TranslationsErrorsApiEn._(_root);
	late final TranslationsErrorsProductsEn products = TranslationsErrorsProductsEn._(_root);
}

// Path: common
class TranslationsCommonEn {
	TranslationsCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsCommonNavigationEn navigation = TranslationsCommonNavigationEn._(_root);
	late final TranslationsCommonButtonsEn buttons = TranslationsCommonButtonsEn._(_root);
	late final TranslationsCommonLabelsEn labels = TranslationsCommonLabelsEn._(_root);
	late final TranslationsCommonEmptyStatesEn empty_states = TranslationsCommonEmptyStatesEn._(_root);
	late final TranslationsCommonErrorsEn errors = TranslationsCommonErrorsEn._(_root);
}

// Path: settings
class TranslationsSettingsEn {
	TranslationsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsSettingsScreensEn screens = TranslationsSettingsScreensEn._(_root);
	late final TranslationsSettingsSectionsEn sections = TranslationsSettingsSectionsEn._(_root);
	late final TranslationsSettingsOptionsEn options = TranslationsSettingsOptionsEn._(_root);
	late final TranslationsSettingsButtonsEn buttons = TranslationsSettingsButtonsEn._(_root);
	late final TranslationsSettingsDialogsEn dialogs = TranslationsSettingsDialogsEn._(_root);
}

// Path: products
class TranslationsProductsEn {
	TranslationsProductsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsProductsInfoEn info = TranslationsProductsInfoEn._(_root);
	late final TranslationsProductsActionsEn actions = TranslationsProductsActionsEn._(_root);
	late final TranslationsProductsCartEn cart = TranslationsProductsCartEn._(_root);
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsHomeFiltersEn filters = TranslationsHomeFiltersEn._(_root);
}

// Path: auth.validation
class TranslationsAuthValidationEn {
	TranslationsAuthValidationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Please enter your name'
	String get full_name_required => 'Please enter your name';

	/// en: 'Name must be first and last name separation by space'
	String get full_name_invalid => 'Name must be first and last name separation by space';

	/// en: 'Please enter your email address'
	String get email_required => 'Please enter your email address';

	/// en: 'Please enter a valid email address'
	String get email_invalid => 'Please enter a valid email address';

	/// en: 'Please enter your password'
	String get password_required => 'Please enter your password';

	/// en: 'Password must be at least 8 characters'
	String get password_too_short => 'Password must be at least 8 characters';

	/// en: 'Please confirm your password'
	String get confirm_password_required => 'Please confirm your password';

	/// en: 'Passwords do not match'
	String get passwords_not_match => 'Passwords do not match';
}

// Path: auth.forms
class TranslationsAuthFormsEn {
	TranslationsAuthFormsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Full Name'
	String get full_name_label => 'Full Name';

	/// en: 'Enter your name'
	String get full_name_hint => 'Enter your name';

	/// en: 'E-mail Address'
	String get email_label => 'E-mail Address';

	/// en: 'example@email.com'
	String get email_hint => 'example@email.com';

	/// en: 'Password'
	String get password_label => 'Password';

	/// en: '* * * * * * * *'
	String get password_hint => '* * * * * * * *';

	/// en: 'Confirm Password'
	String get confirm_password_label => 'Confirm Password';
}

// Path: auth.screens
class TranslationsAuthScreensEn {
	TranslationsAuthScreensEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Login'
	String get login_title => 'Login';

	/// en: 'Sign Up'
	String get signup_title => 'Sign Up';

	/// en: 'Forget password'
	String get forgot_password_link => 'Forget password';

	/// en: 'Have an account?'
	String get have_account_question => 'Have an account?';

	/// en: 'Don't have an account?'
	String get dont_have_account_question => 'Don\'t have an account?';

	/// en: 'Login'
	String get login_link => 'Login';

	/// en: 'Sign Up'
	String get signup_link => 'Sign Up';
}

// Path: auth.buttons
class TranslationsAuthButtonsEn {
	TranslationsAuthButtonsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Login'
	String get login => 'Login';

	/// en: 'Sign Up'
	String get signup => 'Sign Up';

	/// en: 'Verify Email'
	String get verify_email => 'Verify Email';

	/// en: 'Reset Password'
	String get reset_password => 'Reset Password';
}

// Path: auth.dialogs
class TranslationsAuthDialogsEn {
	TranslationsAuthDialogsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Verify your E-mail address'
	String get verify_email_title => 'Verify your E-mail address';

	/// en: 'Enter code'
	String get enter_code_hint => 'Enter code';

	/// en: 'Invalid verification code'
	String get invalid_verification_code => 'Invalid verification code';

	/// en: 'Reset Password'
	String get reset_password_title => 'Reset Password';

	/// en: 'Please select a profile image.'
	String get profile_image_validation => 'Please select a profile image.';

	/// en: 'Please enter a valid email to reset password'
	String get password_reset_validation => 'Please enter a valid email to reset password';

	/// en: 'Password reset email sent successfully.'
	String get password_reset_success => 'Password reset email sent successfully.';
}

// Path: auth.privacy
class TranslationsAuthPrivacyEn {
	TranslationsAuthPrivacyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'By Creating an Account, i accept Tech Nest '
	String get accept_text => 'By Creating an Account, i accept Tech Nest ';

	/// en: 'Terms of Use'
	String get terms_of_use => 'Terms of Use';

	/// en: ' and '
	String get separator => ' and ';

	/// en: 'Privacy Policy'
	String get privacy_policy => 'Privacy Policy';
}

// Path: auth.errors
class TranslationsAuthErrorsEn {
	TranslationsAuthErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Failed to load user profile'
	String get profile_load_failed => 'Failed to load user profile';
}

// Path: errors.network
class TranslationsErrorsNetworkEn {
	TranslationsErrorsNetworkEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No Internet Connection.'
	String get no_connection => 'No Internet Connection.';

	/// en: 'Request timeout'
	String get timeout => 'Request timeout';

	/// en: 'Request cancelled'
	String get cancelled => 'Request cancelled';
}

// Path: errors.server
class TranslationsErrorsServerEn {
	TranslationsErrorsServerEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Bad SSL certificate'
	String get bad_certificate => 'Bad SSL certificate';

	/// en: 'Server error'
	String get error => 'Server error';

	/// en: 'Something went wrong on our side. Please try again later.'
	String get something_wrong => 'Something went wrong on our side. Please try again later.';

	/// en: 'Unhandled http error: {statusCode}'
	String get unhandled => 'Unhandled http error: {statusCode}';
}

// Path: errors.auth
class TranslationsErrorsAuthEn {
	TranslationsErrorsAuthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'UnAuthorized request.'
	String get unauthorized => 'UnAuthorized request.';

	/// en: 'Your session has expired. Please login again.'
	String get session_expired => 'Your session has expired. Please login again.';
}

// Path: errors.cache
class TranslationsErrorsCacheEn {
	TranslationsErrorsCacheEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cache operation failed.'
	String get operation_failed => 'Cache operation failed.';

	/// en: 'Unable to load saved data.'
	String get load_failed => 'Unable to load saved data.';
}

// Path: errors.validation
class TranslationsErrorsValidationEn {
	TranslationsErrorsValidationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Invalid request. Please check your input.'
	String get invalid_request => 'Invalid request. Please check your input.';

	/// en: 'You don't have permission to perform this action.'
	String get no_permission => 'You don\'t have permission to perform this action.';

	/// en: 'Requested resource was not found.'
	String get not_found => 'Requested resource was not found.';

	/// en: 'This data already exists.'
	String get already_exists => 'This data already exists.';

	/// en: 'Invalid data provided.'
	String get invalid_data => 'Invalid data provided.';
}

// Path: errors.unknown
class TranslationsErrorsUnknownEn {
	TranslationsErrorsUnknownEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Unexpected exception occurred.'
	String get unexpected => 'Unexpected exception occurred.';

	/// en: 'An unexpected error occurred. Please try again.'
	String get error_occurred => 'An unexpected error occurred. Please try again.';
}

// Path: errors.general
class TranslationsErrorsGeneralEn {
	TranslationsErrorsGeneralEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Something went wrong. Please try again.'
	String get something_wrong => 'Something went wrong. Please try again.';
}

// Path: errors.api
class TranslationsErrorsApiEn {
	TranslationsErrorsApiEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No Internet Connection'
	String get no_internet => 'No Internet Connection';

	/// en: 'Request Failed'
	String get request_failed => 'Request Failed';
}

// Path: errors.products
class TranslationsErrorsProductsEn {
	TranslationsErrorsProductsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Could not load more products'
	String get could_not_load_more => 'Could not load more products';

	/// en: 'Could not load more products'
	String get load_failure => 'Could not load more products';
}

// Path: common.navigation
class TranslationsCommonNavigationEn {
	TranslationsCommonNavigationEn._(this._root);

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

	/// en: 'Discover'
	String get discover => 'Discover';
}

// Path: common.buttons
class TranslationsCommonButtonsEn {
	TranslationsCommonButtonsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Logout'
	String get logout => 'Logout';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Clear all'
	String get clear_all => 'Clear all';
}

// Path: common.labels
class TranslationsCommonLabelsEn {
	TranslationsCommonLabelsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Search products...'
	String get search_products => 'Search products...';

	/// en: 'All'
	String get all_categories => 'All';

	/// en: 'Price: '
	String get price_label => 'Price: ';

	/// en: '$'
	String get currency => '\$';

	/// en: 'Loading profile...'
	String get loading => 'Loading profile...';

	/// en: 'Guest User'
	String get guest_user => 'Guest User';
}

// Path: common.empty_states
class TranslationsCommonEmptyStatesEn {
	TranslationsCommonEmptyStatesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No Results Found'
	String get no_results_found => 'No Results Found';

	/// en: 'We couldn't find any products matching your search. Try adjusting your search keywords.'
	String get search_empty => 'We couldn\'t find any products matching your search. Try adjusting your search keywords.';

	/// en: 'We couldn't find any products matching your filters. Try adjusting your filters.'
	String get filter_empty => 'We couldn\'t find any products matching your filters. Try adjusting your filters.';

	/// en: 'No suggestions found'
	String get no_suggestions => 'No suggestions found';
}

// Path: common.errors
class TranslationsCommonErrorsEn {
	TranslationsCommonErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Error loading profile'
	String get error_loading_profile => 'Error loading profile';

	/// en: 'Please sign in to access full features'
	String get not_authenticated => 'Please sign in to access full features';
}

// Path: settings.screens
class TranslationsSettingsScreensEn {
	TranslationsSettingsScreensEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';
}

// Path: settings.sections
class TranslationsSettingsSectionsEn {
	TranslationsSettingsSectionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Preferences'
	String get preferences => 'Preferences';

	/// en: 'More'
	String get more => 'More';
}

// Path: settings.options
class TranslationsSettingsOptionsEn {
	TranslationsSettingsOptionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Dark Mode'
	String get dark_mode => 'Dark Mode';

	/// en: 'Notifications'
	String get notifications => 'Notifications';

	/// en: 'Help & Support'
	String get help_support => 'Help & Support';

	/// en: 'About App'
	String get about_app => 'About App';

	/// en: 'Version 1.0.0'
	String get version => 'Version 1.0.0';
}

// Path: settings.buttons
class TranslationsSettingsButtonsEn {
	TranslationsSettingsButtonsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Logout'
	String get logout => 'Logout';
}

// Path: settings.dialogs
class TranslationsSettingsDialogsEn {
	TranslationsSettingsDialogsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Logout'
	String get logout_title => 'Logout';

	/// en: 'Are you sure you want to log out of your account?'
	String get logout_confirmation => 'Are you sure you want to log out of your account?';
}

// Path: products.info
class TranslationsProductsInfoEn {
	TranslationsProductsInfoEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Category: {category}'
	String get category => 'Category: {category}';

	/// en: 'In Stock ({stock})'
	String get in_stock => 'In Stock ({stock})';

	/// en: 'Out of Stock'
	String get out_of_stock => 'Out of Stock';

	/// en: 'Description'
	String get description_title => 'Description';
}

// Path: products.actions
class TranslationsProductsActionsEn {
	TranslationsProductsActionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add to Cart'
	String get add_to_cart => 'Add to Cart';

	/// en: 'Update Cart Quantity'
	String get update_cart_quantity => 'Update Cart Quantity';
}

// Path: products.cart
class TranslationsProductsCartEn {
	TranslationsProductsCartEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Displaying cart item: {id}'
	String get display_log => 'Displaying cart item: {id}';

	/// en: '99+'
	String get badge_max => '99+';
}

// Path: home.filters
class TranslationsHomeFiltersEn {
	TranslationsHomeFiltersEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Filters'
	String get title => 'Filters';

	/// en: 'Categories'
	String get categories_label => 'Categories';

	/// en: 'Price Range'
	String get price_range_label => 'Price Range';

	/// en: 'Sort by'
	String get sort_by_label => 'Sort by';

	/// en: 'Order by'
	String get order_by_label => 'Order by';

	/// en: 'Min price'
	String get min_price => 'Min price';

	/// en: 'Max price'
	String get max_price => 'Max price';

	/// en: '—'
	String get separator => '—';

	/// en: 'Apply {count} Filter{plural}'
	String get apply_button => 'Apply {count} Filter{plural}';

	/// en: 'Apply Filters'
	String get apply_button_default => 'Apply Filters';

	/// en: 'Max price must be greater than Min'
	String get max_price_validation => 'Max price must be greater than Min';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'auth.validation.full_name_required' => 'Please enter your name',
			'auth.validation.full_name_invalid' => 'Name must be first and last name separation by space',
			'auth.validation.email_required' => 'Please enter your email address',
			'auth.validation.email_invalid' => 'Please enter a valid email address',
			'auth.validation.password_required' => 'Please enter your password',
			'auth.validation.password_too_short' => 'Password must be at least 8 characters',
			'auth.validation.confirm_password_required' => 'Please confirm your password',
			'auth.validation.passwords_not_match' => 'Passwords do not match',
			'auth.forms.full_name_label' => 'Full Name',
			'auth.forms.full_name_hint' => 'Enter your name',
			'auth.forms.email_label' => 'E-mail Address',
			'auth.forms.email_hint' => 'example@email.com',
			'auth.forms.password_label' => 'Password',
			'auth.forms.password_hint' => '* * * * * * * *',
			'auth.forms.confirm_password_label' => 'Confirm Password',
			'auth.screens.login_title' => 'Login',
			'auth.screens.signup_title' => 'Sign Up',
			'auth.screens.forgot_password_link' => 'Forget password',
			'auth.screens.have_account_question' => 'Have an account?',
			'auth.screens.dont_have_account_question' => 'Don\'t have an account?',
			'auth.screens.login_link' => 'Login',
			'auth.screens.signup_link' => 'Sign Up',
			'auth.buttons.login' => 'Login',
			'auth.buttons.signup' => 'Sign Up',
			'auth.buttons.verify_email' => 'Verify Email',
			'auth.buttons.reset_password' => 'Reset Password',
			'auth.dialogs.verify_email_title' => 'Verify your E-mail address',
			'auth.dialogs.enter_code_hint' => 'Enter code',
			'auth.dialogs.invalid_verification_code' => 'Invalid verification code',
			'auth.dialogs.reset_password_title' => 'Reset Password',
			'auth.dialogs.profile_image_validation' => 'Please select a profile image.',
			'auth.dialogs.password_reset_validation' => 'Please enter a valid email to reset password',
			'auth.dialogs.password_reset_success' => 'Password reset email sent successfully.',
			'auth.privacy.accept_text' => 'By Creating an Account, i accept Tech Nest ',
			'auth.privacy.terms_of_use' => 'Terms of Use',
			'auth.privacy.separator' => ' and ',
			'auth.privacy.privacy_policy' => 'Privacy Policy',
			'auth.errors.profile_load_failed' => 'Failed to load user profile',
			'errors.network.no_connection' => 'No Internet Connection.',
			'errors.network.timeout' => 'Request timeout',
			'errors.network.cancelled' => 'Request cancelled',
			'errors.server.bad_certificate' => 'Bad SSL certificate',
			'errors.server.error' => 'Server error',
			'errors.server.something_wrong' => 'Something went wrong on our side. Please try again later.',
			'errors.server.unhandled' => 'Unhandled http error: {statusCode}',
			'errors.auth.unauthorized' => 'UnAuthorized request.',
			'errors.auth.session_expired' => 'Your session has expired. Please login again.',
			'errors.cache.operation_failed' => 'Cache operation failed.',
			'errors.cache.load_failed' => 'Unable to load saved data.',
			'errors.validation.invalid_request' => 'Invalid request. Please check your input.',
			'errors.validation.no_permission' => 'You don\'t have permission to perform this action.',
			'errors.validation.not_found' => 'Requested resource was not found.',
			'errors.validation.already_exists' => 'This data already exists.',
			'errors.validation.invalid_data' => 'Invalid data provided.',
			'errors.unknown.unexpected' => 'Unexpected exception occurred.',
			'errors.unknown.error_occurred' => 'An unexpected error occurred. Please try again.',
			'errors.general.something_wrong' => 'Something went wrong. Please try again.',
			'errors.api.no_internet' => 'No Internet Connection',
			'errors.api.request_failed' => 'Request Failed',
			'errors.products.could_not_load_more' => 'Could not load more products',
			'errors.products.load_failure' => 'Could not load more products',
			'common.navigation.home' => 'Home',
			'common.navigation.cart' => 'Cart',
			'common.navigation.categories' => 'Categories',
			'common.navigation.settings' => 'Settings',
			'common.navigation.discover' => 'Discover',
			'common.buttons.cancel' => 'Cancel',
			'common.buttons.logout' => 'Logout',
			'common.buttons.retry' => 'Retry',
			'common.buttons.clear_all' => 'Clear all',
			'common.labels.search_products' => 'Search products...',
			'common.labels.all_categories' => 'All',
			'common.labels.price_label' => 'Price: ',
			'common.labels.currency' => '\$',
			'common.labels.loading' => 'Loading profile...',
			'common.labels.guest_user' => 'Guest User',
			'common.empty_states.no_results_found' => 'No Results Found',
			'common.empty_states.search_empty' => 'We couldn\'t find any products matching your search. Try adjusting your search keywords.',
			'common.empty_states.filter_empty' => 'We couldn\'t find any products matching your filters. Try adjusting your filters.',
			'common.empty_states.no_suggestions' => 'No suggestions found',
			'common.errors.error_loading_profile' => 'Error loading profile',
			'common.errors.not_authenticated' => 'Please sign in to access full features',
			'settings.screens.title' => 'Settings',
			'settings.sections.preferences' => 'Preferences',
			'settings.sections.more' => 'More',
			'settings.options.dark_mode' => 'Dark Mode',
			'settings.options.notifications' => 'Notifications',
			'settings.options.help_support' => 'Help & Support',
			'settings.options.about_app' => 'About App',
			'settings.options.version' => 'Version 1.0.0',
			'settings.buttons.logout' => 'Logout',
			'settings.dialogs.logout_title' => 'Logout',
			'settings.dialogs.logout_confirmation' => 'Are you sure you want to log out of your account?',
			'products.info.category' => 'Category: {category}',
			'products.info.in_stock' => 'In Stock ({stock})',
			'products.info.out_of_stock' => 'Out of Stock',
			'products.info.description_title' => 'Description',
			'products.actions.add_to_cart' => 'Add to Cart',
			'products.actions.update_cart_quantity' => 'Update Cart Quantity',
			'products.cart.display_log' => 'Displaying cart item: {id}',
			'products.cart.badge_max' => '99+',
			'home.filters.title' => 'Filters',
			'home.filters.categories_label' => 'Categories',
			'home.filters.price_range_label' => 'Price Range',
			'home.filters.sort_by_label' => 'Sort by',
			'home.filters.order_by_label' => 'Order by',
			'home.filters.min_price' => 'Min price',
			'home.filters.max_price' => 'Max price',
			'home.filters.separator' => '—',
			'home.filters.apply_button' => 'Apply {count} Filter{plural}',
			'home.filters.apply_button_default' => 'Apply Filters',
			'home.filters.max_price_validation' => 'Max price must be greater than Min',
			_ => null,
		};
	}
}
