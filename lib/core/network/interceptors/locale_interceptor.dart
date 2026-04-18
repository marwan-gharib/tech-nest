import 'package:dio/dio.dart';
import 'package:tech_nest/i18n/strings.g.dart';

/// Injects the current app language into every outgoing request as an
/// [Accept-Language] header so the backend returns localised data.
class LocaleInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] = LocaleSettings.currentLocale.languageCode;
    super.onRequest(options, handler);
  }
}
