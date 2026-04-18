// This file contains NO real values.
// All values are injected at build time via --dart-define.
// Never commit real API keys, URLs, or secrets to source control.

class BuildConfig {
  BuildConfig._();

  static const String _environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'dev',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static bool get isDev => _environment == 'dev';
  static bool get isStaging => _environment == 'staging';
  static bool get isProd => _environment == 'prod';
}
