import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/di/service_locator.dart';
import 'package:tech_nest/core/routing/app_router.dart';
import 'package:tech_nest/core/services/auth/auth_notifire.dart';
import 'package:tech_nest/core/services/local/cache/cache_service.dart';
import 'package:tech_nest/core/theme/app_theme.dart';
import 'package:tech_nest/core/theme/cubit/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  final cache = sl<CacheService>();
  final authNotifier = sl<AuthNotifire>();

  if (cache.containsKey(ApiKeys.token)) {
    authNotifier.login();
  } else {
    authNotifier.logout();
  }

  runApp(
    ProviderScope(
      child: BlocProvider(
        create: (context) => sl<ThemeCubit>(),
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
      themeMode: context.watch<ThemeCubit>().state,
      routerConfig: AppRouter.routes,
    );
  }
}
