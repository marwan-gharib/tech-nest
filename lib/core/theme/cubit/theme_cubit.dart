import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/constants/app_consts.dart';
import 'package:tech_nest/core/di/injection_container.dart';
import 'package:tech_nest/core/services/local/cache/cache_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final cache = sl<CacheService>();
    final int? themeIndex = cache.get(AppConsts.themeKey) as int?;

    if (themeIndex != null) {
      emit(themeIndex == 1 ? ThemeMode.light : ThemeMode.dark);
    }
  }

  Future<void> _changeTheme(ThemeMode mode) async {
    final cache = sl<CacheService>();
    await cache.setData(key: AppConsts.themeKey, value: mode.index);
    emit(mode);
  }

  void toggleTheme() {
    _changeTheme(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}
