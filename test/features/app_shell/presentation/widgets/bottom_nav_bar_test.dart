import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/features/app_shell/presentation/widgets/bottom_nav_bar.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';

import '../../../../helpers/test_app.dart';

class MockStatefulNavigationShell extends Mock
    implements StatefulNavigationShell {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

void main() {
  late MockStatefulNavigationShell mockNavigationShell;
  late MockCartCubit mockCartCubit;

  setUp(() {
    mockNavigationShell = MockStatefulNavigationShell();
    mockCartCubit = MockCartCubit();
    when(() => mockNavigationShell.currentIndex).thenReturn(0);
    when(() => mockCartCubit.state).thenReturn(const CartInitial());
  });

  Widget buildSubject(Widget child) {
    return buildTestApp(
      child: BlocProvider<CartCubit>.value(value: mockCartCubit, child: child),
    );
  }

  testWidgets('renders all bottom navigation items', (tester) async {
    await tester.pumpWidget(
      buildSubject(
        Scaffold(
          bottomNavigationBar: BottomNavBar(
            navigationShell: mockNavigationShell,
            onTap: (_) {},
          ),
        ),
      ),
    );

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    expect(find.byIcon(Icons.category_outlined), findsOneWidget);
    expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);
    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
  });

  testWidgets('calls onTap with tapped index', (tester) async {
    var tappedIndex = -1;

    await tester.pumpWidget(
      buildSubject(
        Scaffold(
          bottomNavigationBar: BottomNavBar(
            navigationShell: mockNavigationShell,
            onTap: (index) => tappedIndex = index,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.category_outlined));
    await tester.pump();

    expect(tappedIndex, 2);
  });

  testWidgets('updates selected index when navigation shell index changes', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    when(() => mockNavigationShell.currentIndex).thenReturn(4);
                    setState(() {});
                  },
                  child: const Text('update'),
                ),
                Expanded(
                  child: Scaffold(
                    bottomNavigationBar: BottomNavBar(
                      navigationShell: mockNavigationShell,
                      onTap: (_) {},
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    final bottomNavBefore = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(bottomNavBefore.currentIndex, 0);

    await tester.tap(find.text('update'));
    await tester.pump();

    final bottomNavAfter = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(bottomNavAfter.currentIndex, 4);
  });
}
