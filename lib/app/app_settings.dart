import 'package:tech_nest/core/constants/app_constants.dart';
import 'package:tech_nest/core/local/cache/cache_service.dart';
import 'package:tech_nest/core/local/secure/secure_storage_client.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class AppSettings {
  final CacheService _cacheService;
  final SecureStorageClient _secureStorage;
  final AuthNotifier _authNotifier;

  AppSettings(this._cacheService, this._secureStorage, this._authNotifier);

  Future<void> initLocale() async {
    final String? savedLocale =
        _cacheService.get(AppConstants.localeKey) as String?;

    if (savedLocale != null) {
      LocaleSettings.setLocale(AppLocaleUtils.parse(savedLocale));
    } else {
      await LocaleSettings.useDeviceLocale();
    }
  }

  Future<void> initAuth() async {
    if (await _secureStorage.hasToken()) {
      _authNotifier.login();
    } else {
      _authNotifier.logout();
    }
  }
}
