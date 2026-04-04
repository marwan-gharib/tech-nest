import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_nest/core/di/service_locator.dart';
import 'package:tech_nest/core/local/secure/secure_storage_client.dart';
import 'package:tech_nest/core/routing/app_router.dart';
import 'package:tech_nest/core/services/auth/auth_notifier.dart';
import 'package:tech_nest/core/theme/app_theme.dart';
import 'package:tech_nest/core/theme/cubit/theme_cubit.dart';
import 'package:tech_nest/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  final secureStorage = sl<SecureStorageClient>();
  final authNotifier = sl<AuthNotifier>();

  if (await secureStorage.hasToken()) {
    authNotifier.login();
  } else {
    authNotifier.logout();
  }

  runApp(
    ProviderScope(
      child: MultiBlocProvider(
        providers: [BlocProvider(create: (context) => sl<ThemeCubit>())],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeAnimationDuration: const Duration(milliseconds: 300),
      themeAnimationCurve: Curves.easeInOut,
      themeMode: context.watch<ThemeCubit>().state.mode,
      routerConfig: AppRouter.routes,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
