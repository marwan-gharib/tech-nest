// This file contains NO real values.
// All values are injected at build time via --dart-define.
// Never commit real API keys, URLs, or secrets to source control.

class BuildConfig {
  BuildConfig._();

  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'dev',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.1.13/tech-nest-backend/',
  );

  static bool get isDev => environment == 'dev';
  static bool get isStaging => environment == 'staging';
  static bool get isProd => environment == 'prod';
}
