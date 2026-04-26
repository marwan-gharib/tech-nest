import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/constants/app_constants.dart';
import 'package:tech_nest/core/local/cache/cache_service.dart';
import 'package:tech_nest/i18n/strings.g.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final CacheService _cacheService;

  LocaleCubit(this._cacheService)
    : super(LocaleState(LocaleSettings.currentLocale));
  Future<void> setLocale(AppLocale locale) async {
    if (state.locale == locale) return;

    LocaleSettings.setLocale(locale);
    await _cacheService.setData(
      key: AppConstants.localeKey,
      value: locale.languageCode,
    );
    emit(LocaleState(locale));
  }
}
