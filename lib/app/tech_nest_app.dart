import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tech_nest/app/app_router.dart';
import 'package:tech_nest/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:tech_nest/core/theme/app_theme.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class TechNestApp extends StatelessWidget {
  const TechNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeAnimationDuration: const Duration(milliseconds: 300),
      themeAnimationCurve: Curves.easeInOut,
      themeMode: context.select<ThemeCubit, ThemeMode>(
        (cubit) => cubit.state.mode,
      ),
      routerConfig: AppRouter.routes,
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}
