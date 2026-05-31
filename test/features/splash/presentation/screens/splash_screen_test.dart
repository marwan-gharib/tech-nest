import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/features/splash/presentation/screens/splash_screen.dart';
import 'package:tech_nest/features/splash/presentation/widgets/splash_background.dart';
import 'package:tech_nest/features/splash/presentation/widgets/splash_icon_story.dart';
import 'package:tech_nest/features/splash/presentation/widgets/splash_tagline.dart';

import '../../../../helpers/test_app.dart';

void main() {
  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
        GoRoute(
          path: '/home',
          name: RouteNames.home,
          builder: (_, _) => const Scaffold(body: Text('home-screen')),
        ),
      ],
    );
  }

  testWidgets('renders splash visual components', (tester) async {
    await tester.pumpWidget(
      buildTestApp(router: buildRouter(), child: const SizedBox.shrink()),
    );

    expect(find.byType(SplashBackground), findsOneWidget);
    expect(find.byType(SplashIconStory), findsOneWidget);
    expect(find.byType(SplashTagline), findsOneWidget);
  });

  testWidgets('navigates to home after splash animation duration', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(router: buildRouter(), child: const SizedBox.shrink()),
    );

    await tester.pump(const Duration(milliseconds: 3201));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 401));
    await tester.pump();

    expect(find.text('home-screen'), findsOneWidget);
  });
}
