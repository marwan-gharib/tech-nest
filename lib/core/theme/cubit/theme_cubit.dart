import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/constants/app_consts.dart';
import 'package:tech_nest/core/services/local/cache/cache_service.dart';
import 'package:tech_nest/core/theme/cubit/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final CacheService _cacheService;

  ThemeCubit(this._cacheService)
    : super(const ThemeState(mode: ThemeMode.system)) {
    _loadTheme();
  }

  void toggleTheme() {
    _changeTheme(
      state.mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
  }

  Future<void> _changeTheme(ThemeMode mode) async {
    await _cacheService.setData(key: AppConsts.themeKey, value: mode.index);
    emit(ThemeState(mode: mode));
  }

  void _loadTheme() {
    final int? themeIndex = _cacheService.get(AppConsts.themeKey) as int?;

    if (themeIndex != null &&
        themeIndex >= 0 &&
        themeIndex < ThemeMode.values.length) {
      emit(ThemeState(mode: ThemeMode.values[themeIndex]));
    }
  }
}
