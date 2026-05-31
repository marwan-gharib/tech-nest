import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/features/app_shell/presentation/app_shell_entry.dart';
import 'package:tech_nest/features/app_shell/presentation/widgets/bottom_nav_bar.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';

import '../../../helpers/test_app.dart';

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

void main() {
  late MockCartCubit mockCartCubit;

  setUp(() {
    mockCartCubit = MockCartCubit();
    when(() => mockCartCubit.state).thenReturn(const CartInitial());
  });

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/home',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return AppShellEntry(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (_, _) => const Scaffold(body: Text('home-branch')),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/cart',
                  builder: (_, _) => const Scaffold(body: Text('cart-branch')),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/categories',
                  builder: (_, _) =>
                      const Scaffold(body: Text('categories-branch')),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/orders',
                  builder: (_, _) =>
                      const Scaffold(body: Text('orders-branch')),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/notifications',
                  builder: (_, _) =>
                      const Scaffold(body: Text('notifications-branch')),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/settings',
                  builder: (_, _) =>
                      const Scaffold(body: Text('settings-branch')),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  testWidgets('renders current branch and bottom navigation bar', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        router: buildRouter(),
        providers: [BlocProvider<CartCubit>.value(value: mockCartCubit)],
        child: const SizedBox.shrink(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('home-branch'), findsOneWidget);
    expect(find.byType(BottomNavBar), findsOneWidget);
  });

  testWidgets('switches branches when tapping bottom navigation items', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestApp(
        router: buildRouter(),
        providers: [BlocProvider<CartCubit>.value(value: mockCartCubit)],
        child: const SizedBox.shrink(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
    await tester.pumpAndSettle();
    expect(find.text('cart-branch'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('settings-branch'), findsOneWidget);
  });
}
