import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/app/service_locator.dart';
import 'package:tech_nest/core/constants/app_constants.dart';
import 'package:tech_nest/core/local/cache/cache_service.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:tech_nest/i18n/strings.g.dart';

import '../../../../helpers/test_app.dart';

class MockCacheService extends Mock implements CacheService {}

void main() {
  late MockCacheService mockCacheService;

  setUp(() {
    mockCacheService = MockCacheService();
    when(
      () => mockCacheService.setData(
        key: AppConstants.onboardingKey,
        value: true,
      ),
    ).thenAnswer((_) async => true);

    if (sl.isRegistered<CacheService>()) {
      sl.unregister<CacheService>();
    }
    sl.registerLazySingleton<CacheService>(() => mockCacheService);
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/onboarding',
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (_, _) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/login',
          name: RouteNames.login,
          builder: (_, _) => const Scaffold(body: Text('login-screen')),
        ),
      ],
    );
  }

  testWidgets('shows skip button on first page', (tester) async {
    await tester.pumpWidget(
      buildTestApp(router: buildRouter(), child: const SizedBox.shrink()),
    );
    await tester.pumpAndSettle();

    expect(find.text(t.onboarding.skip), findsOneWidget);
  });

  testWidgets('skip completes onboarding and navigates to login', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(router: buildRouter(), child: const SizedBox.shrink()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(t.onboarding.skip));
    await tester.pumpAndSettle();

    verify(
      () => mockCacheService.setData(
        key: AppConstants.onboardingKey,
        value: true,
      ),
    ).called(1);
    expect(find.text('login-screen'), findsOneWidget);
  });

  testWidgets('last page hides skip and shows get started flow', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(router: buildRouter(), child: const SizedBox.shrink()),
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(find.text(t.onboarding.skip), findsNothing);
    expect(find.text(t.onboarding.getStarted), findsOneWidget);

    await tester.tap(find.text(t.onboarding.getStarted));
    await tester.pumpAndSettle();

    verify(
      () => mockCacheService.setData(
        key: AppConstants.onboardingKey,
        value: true,
      ),
    ).called(1);
    expect(find.text('login-screen'), findsOneWidget);
  });
}
