import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_nest/core/di/service_locator.dart';
import 'package:tech_nest/core/logic/connectivity_cubit/connectivity_cubit.dart';
import 'package:tech_nest/core/routing/app_router.dart';
import 'package:tech_nest/core/services/auth/auth_notifier.dart';
import 'package:tech_nest/core/services/local/secure/secure_storage_service.dart';
import 'package:tech_nest/core/theme/app_theme.dart';
import 'package:tech_nest/core/theme/cubit/theme_cubit.dart';
import 'package:tech_nest/core/widgets/no_internet_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  final secureStorage = sl<SecureStorageService>();
  final authNotifier = sl<AuthNotifier>();

  if (await secureStorage.hasToken()) {
    authNotifier.login();
  } else {
    authNotifier.logout();
  }

  runApp(
    ProviderScope(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<ThemeCubit>()),
          BlocProvider(create: (context) => sl<ConnectivityCubit>()),
        ],
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
      builder: (context, child) {
        return BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
          builder: (context, status) {
            if (status == ConnectivityStatus.offline) {
              return const NoInternetScreen();
            }
            return child!;
          },
        );
      },
    );
  }
}
