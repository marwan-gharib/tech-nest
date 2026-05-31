import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/theme/app_theme.dart';
import 'package:tech_nest/i18n/strings.g.dart';

Widget buildTestApp({
  required Widget child,
  GoRouter? router,
  List<BlocProvider> providers = const [],
}) {
  LocaleSettings.setLocaleSync(AppLocale.en);

  final appRouter =
      router ??
      GoRouter(
        initialLocation: '/',
        routes: [GoRoute(path: '/', builder: (_, _) => child)],
      );

  final app = MaterialApp.router(
    theme: AppTheme.lightTheme.copyWith(splashFactory: NoSplash.splashFactory),
    darkTheme: AppTheme.darkTheme.copyWith(
      splashFactory: NoSplash.splashFactory,
    ),
    routerConfig: appRouter,
  );

  return TranslationProvider(
    child: providers.isEmpty
        ? app
        : MultiBlocProvider(providers: providers, child: app),
  );
}
