import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/local/cache/cache_service.dart';
import 'package:tech_nest/i18n/strings.g.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final CacheService _cacheService;
  static const String _localeKey = 'app_locale';

  LocaleCubit(this._cacheService)
    : super(LocaleState(LocaleSettings.currentLocale)) {
    _loadSavedLocale();
  }

  void _loadSavedLocale() {
    final String? savedLocale = _cacheService.get(_localeKey) as String?;
    if (savedLocale != null) {
      final locale = AppLocaleUtils.parse(savedLocale);
      LocaleSettings.setLocale(locale);
      emit(LocaleState(locale));
    }
  }

  Future<void> setLocale(AppLocale locale) async {
    if (state.locale == locale) return;

    LocaleSettings.setLocale(locale);
    await _cacheService.setData(key: _localeKey, value: locale.languageCode);
    emit(LocaleState(locale));
  }
}
