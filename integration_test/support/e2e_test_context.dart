import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_nest/app/app_router.dart';
import 'package:tech_nest/app/service_locator.dart';
import 'package:tech_nest/app/tech_nest_app.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/constants/app_constants.dart';
import 'package:tech_nest/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:tech_nest/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:tech_nest/core/local/cache/cache_service.dart';
import 'package:tech_nest/core/local/secure/secure_storage_client.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:tech_nest/i18n/strings.g.dart';

import 'fakes/fake_api_client.dart';
import 'fakes/fake_secure_storage.dart';

class E2ETestContext {
  late final FakeApiClient api;
  late final FakeSecureStorage secureStorage;

  Future<void> setUpAll() async {
    SharedPreferences.setMockInitialValues({});
    await sl.reset();
    await initDependencies();

    api = FakeApiClient();
    secureStorage = FakeSecureStorage();

    await sl.unregister<ApiClient>();
    await sl.unregister<SecureStorageClient>();
    sl.registerLazySingleton<ApiClient>(() => api);
    sl.registerLazySingleton<SecureStorageClient>(() => secureStorage);
  }

  Future<void> reset() async {
    api.reset();
    secureStorage.reset();
    await LocaleSettings.setLocale(AppLocale.en);

    final cache = sl<CacheService>();
    await cache.remove(AppConstants.onboardingKey);
    await cache.remove(ApiKeys.user);
    await cache.remove(AppConstants.themeKey);

    sl<ThemeCubit>().updateThemeMode(ThemeMode.system);
    sl<AuthNotifier>().logout();
    AppRouter.router.go(RoutePaths.splash);
  }

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      TranslationProvider(
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl<ThemeCubit>()),
            BlocProvider.value(value: sl<LocaleCubit>()),
          ],
          child: const TechNestApp(),
        ),
      ),
    );
    await tester.pump();
  }

  Future<void> startAuthenticatedSession(WidgetTester tester) async {
    final cache = sl<CacheService>();
    await cache.setData(key: AppConstants.onboardingKey, value: true);
    await cache.setData(
      key: ApiKeys.user,
      value: jsonEncode(FakeApiClient.user),
    );
    await sl<SecureStorageClient>().saveToken('e2e-token');
    sl<AuthNotifier>().login();

    await pumpApp(tester);
    await waitFor(tester, find.text('Discover'));
  }

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await ensureVisible(tester, finder);
    await tap(tester, finder);
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await waitForTappable(tester, finder);
    await tester.tap(finder);
    await tester.pump();
  }

  Future<void> ensureVisible(WidgetTester tester, Finder finder) async {
    await waitFor(tester, finder);
    final element = finder.evaluate().single;
    await Scrollable.ensureVisible(element, duration: Duration.zero);
    await tester.pump();
  }

  Future<void> waitFor(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 8),
  }) async {
    await waitUntil(
      tester,
      () => finder.evaluate().isNotEmpty,
      timeout: timeout,
    );
  }

  Future<void> waitForTappable(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 8),
  }) async {
    await waitUntil(tester, () {
      if (finder.evaluate().isEmpty) return false;

      final rect = tester.getRect(finder);
      final view = tester.view;
      final size = view.physicalSize / view.devicePixelRatio;
      return Rect.fromLTWH(0, 0, size.width, size.height).contains(rect.center);
    }, timeout: timeout);
  }

  Future<void> waitUntil(
    WidgetTester tester,
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 8),
  }) async {
    final binding = tester.binding;
    final end = binding.clock.fromNowBy(timeout);

    while (!condition()) {
      if (binding.clock.now().isAfter(end)) {
        fail('Timed out waiting for UI condition after $timeout.');
      }
      await tester.pump(const Duration(milliseconds: 16));
    }
  }
}
