// lib/core/localization/app_locale_provider.dart
import 'package:flutter/material.dart';
import 'package:tech_nest/core/localization/translations/strings.g.dart';

class AppLocaleProvider extends ChangeNotifier {
  AppLocale _locale = AppLocale.ar;

  AppLocale get locale => _locale;
  Locale get flutterLocale => _locale.flutterLocale;

  void setLocale(AppLocale locale) {
    if (_locale == locale) return;
    _locale = locale;
    LocaleSettings.setLocale(locale);
    notifyListeners();
  }

  void toggleLocale() {
    setLocale(_locale == AppLocale.ar ? AppLocale.en : AppLocale.ar);
  }
}
