// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get errorNoInternetConnection => 'No internet connection';

  @override
  String get errorRequestFailed => 'Something went wrong';

  @override
  String get actionRetry => 'Retry';

  @override
  String get errorCouldNotLoadMore => 'Could not load more items';

  @override
  String get authScreenLoginTitle => 'Login';

  @override
  String get authScreenRegistrationTitle => 'Registration';

  @override
  String get authLoginButton => 'Login';

  @override
  String get authSignUpButton => 'Sign Up';

  @override
  String get authNavigateNoAccount => 'Don\'t have an account?';

  @override
  String get authNavigateHasAccount => 'Have an account?';

  @override
  String get authNavigateRegistration => 'registration';

  @override
  String get authNavigateLogin => 'Login';

  @override
  String get authForgetPassword => 'Forget password';

  @override
  String get authEnterValidEmailFirst => 'Please enter a valid email first';

  @override
  String get authPasswordChangedSuccess => 'Password changed successfully';

  @override
  String get authProfilePictureRequired => 'Profile picture is required.';

  @override
  String get authResetPasswordButton => 'Reset password';

  @override
  String get authVerifyCreateAccountButton => 'Create Account';
}
