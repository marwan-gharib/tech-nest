import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/features/checkout/presentation/cubits/create_order/create_order_cubit.dart';
import 'package:tech_nest/features/checkout/presentation/cubits/create_order/create_order_state.dart';
import 'package:tech_nest/features/checkout/presentation/widgets/confirm_order_button.dart';
import 'package:tech_nest/i18n/strings.g.dart';

import '../../../../helpers/test_app.dart';

class MockCreateOrderCubit extends MockCubit<CreateOrderState>
    implements CreateOrderCubit {}

void main() {
  late MockCreateOrderCubit mockCreateOrderCubit;

  setUp(() {
    mockCreateOrderCubit = MockCreateOrderCubit();
    when(
      () => mockCreateOrderCubit.state,
    ).thenReturn(const CreateOrderInitial());
  });

  testWidgets('shows confirm label and triggers callback when not loading', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<CreateOrderCubit>.value(
          value: mockCreateOrderCubit,
          child: Scaffold(
            bottomNavigationBar: ConfirmOrderButton(
              onPressed: () => tapped = true,
            ),
          ),
        ),
      ),
    );

    expect(find.text(t.orders.confirmOrder), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(tapped, true);
  });

  testWidgets('shows loading indicator and disables button while loading', (
    tester,
  ) async {
    var tapped = false;

    when(
      () => mockCreateOrderCubit.state,
    ).thenReturn(const CreateOrderLoading());

    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<CreateOrderCubit>.value(
          value: mockCreateOrderCubit,
          child: Scaffold(
            bottomNavigationBar: ConfirmOrderButton(
              onPressed: () => tapped = true,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text(t.orders.confirmOrder), findsNothing);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(tapped, false);
  });

  testWidgets('rebuilds correctly across consecutive states', (tester) async {
    whenListen(
      mockCreateOrderCubit,
      Stream<CreateOrderState>.periodic(
        const Duration(milliseconds: 10),
        (index) => [
          const CreateOrderLoading(),
          const CreateOrderSuccess(8),
          const CreateOrderLoading(),
        ][index],
      ).take(3),
      initialState: const CreateOrderInitial(),
    );

    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<CreateOrderCubit>.value(
          value: mockCreateOrderCubit,
          child: const Scaffold(
            bottomNavigationBar: ConfirmOrderButton(onPressed: _noOp),
          ),
        ),
      ),
    );

    expect(find.text(t.orders.confirmOrder), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 10));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 10));
    expect(find.text(t.orders.confirmOrder), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.pump(const Duration(milliseconds: 10));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}

void _noOp() {}
