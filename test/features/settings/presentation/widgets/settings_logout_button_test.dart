import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/app/service_locator.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:tech_nest/features/settings/presentation/cubits/logout_cubit/logout_cubit.dart';
import 'package:tech_nest/features/settings/presentation/widgets/settings_logout_button.dart';
import 'package:tech_nest/i18n/strings.g.dart';

import '../../../../helpers/test_app.dart';

class MockLogoutCubit extends MockCubit<LogoutState> implements LogoutCubit {}

class MockAuthNotifier extends Mock implements AuthNotifier {}

void main() {
  late MockLogoutCubit mockLogoutCubit;
  late MockAuthNotifier mockAuthNotifier;

  setUp(() {
    mockLogoutCubit = MockLogoutCubit();
    mockAuthNotifier = MockAuthNotifier();

    when(() => mockLogoutCubit.state).thenReturn(const LogoutInitial());
    when(() => mockLogoutCubit.logout()).thenAnswer((_) async {});
    when(() => mockAuthNotifier.logout()).thenReturn(null);

    if (sl.isRegistered<AuthNotifier>()) {
      sl.unregister<AuthNotifier>();
    }
    sl.registerLazySingleton<AuthNotifier>(() => mockAuthNotifier);
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/settings',
      routes: [
        GoRoute(
          path: '/settings',
          builder: (_, _) => BlocProvider<LogoutCubit>.value(
            value: mockLogoutCubit,
            child: Scaffold(body: Center(child: SettingsLogoutButton())),
          ),
        ),
        GoRoute(
          path: '/login',
          name: RouteNames.login,
          builder: (_, _) => const Scaffold(body: Text('login-screen')),
        ),
      ],
    );
  }

  testWidgets('shows logout action in initial state', (tester) async {
    await tester.pumpWidget(
      buildTestApp(router: buildRouter(), child: const SizedBox.shrink()),
    );
    await tester.pump();

    expect(find.text(t.auth.logout), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
  });

  testWidgets(
    'opens logout dialog and triggers cubit logout from dialog confirm',
    (tester) async {
      await tester.pumpWidget(
        buildTestApp(router: buildRouter(), child: const SizedBox.shrink()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(t.auth.logout));
      await tester.pump();

      expect(find.text(t.settings.logoutConfirm), findsOneWidget);

      final logoutTextFinder = find.text(t.settings.logout);
      await tester.tap(logoutTextFinder.last);
      await tester.pump();

      verify(() => mockLogoutCubit.logout()).called(1);
    },
  );

  testWidgets('shows loading indicator while logout is in progress', (
    tester,
  ) async {
    when(() => mockLogoutCubit.state).thenReturn(const LogoutLoading());

    await tester.pumpWidget(
      buildTestApp(router: buildRouter(), child: const SizedBox.shrink()),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(OutlinedButton), findsNothing);
  });

  testWidgets(
    'reacts to success by navigating to login and notifying auth state',
    (tester) async {
      whenListen(
        mockLogoutCubit,
        Stream.fromIterable([const LogoutSuccess()]),
        initialState: const LogoutInitial(),
      );

      await tester.pumpWidget(
        buildTestApp(router: buildRouter(), child: const SizedBox.shrink()),
      );
      await tester.pumpAndSettle();

      verify(() => mockAuthNotifier.logout()).called(1);
      expect(find.text('login-screen'), findsOneWidget);
    },
  );

  testWidgets('reacts to failure by showing error message', (tester) async {
    final failure = ServerFailure(message: 'Could not log out');

    whenListen(
      mockLogoutCubit,
      Stream.fromIterable([LogoutFailure(failure)]),
      initialState: const LogoutInitial(),
    );

    await tester.pumpWidget(
      buildTestApp(router: buildRouter(), child: const SizedBox.shrink()),
    );
    await tester.pump();

    expect(find.text('Could not log out'), findsOneWidget);
  });
}
