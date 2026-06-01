import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_nest/app/service_locator.dart';
import 'package:tech_nest/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/auth_notifier.dart';

import '../support/e2e_test_context.dart';

void settingsLogoutFlow(E2ETestContext e2e) {
  testWidgets('settings preferences and logout return to auth gate', (
    tester,
  ) async {
    await e2e.startAuthenticatedSession(tester);

    await e2e.tap(tester, find.byKey(const ValueKey('nav.settings')));
    await e2e.waitFor(tester, find.text('Settings'));

    await e2e.tap(tester, find.text('Dark Theme'));
    await e2e.waitUntil(
      tester,
      () => sl<ThemeCubit>().state.mode == ThemeMode.dark,
    );
    expect(sl<ThemeCubit>().state.mode, ThemeMode.dark);

    await e2e.tapVisible(tester, find.byKey(const ValueKey('settings.logout')));
    await e2e.waitFor(
      tester,
      find.byKey(const ValueKey('logoutDialog.confirm')),
    );
    await e2e.tap(tester, find.byKey(const ValueKey('logoutDialog.confirm')));

    await e2e.waitFor(tester, find.text('Log In'));
    expect(sl<AuthNotifier>().isAuth, isFalse);
    expect(await e2e.secureStorage.hasToken(), isFalse);
    expect(e2e.api.logoutCalls, 1);
  });
}
