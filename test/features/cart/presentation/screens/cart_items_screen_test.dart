import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/app/service_locator.dart';
import 'package:tech_nest/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/core/theme/app_theme.dart';
import 'package:tech_nest/core/widgets/no_results_found_view.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_entity.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/features/cart/presentation/cubits/delete_cart_item_cubit/delete_cart_item_cubit.dart';
import 'package:tech_nest/features/cart/presentation/cubits/update_item_quantity_cubit/update_item_quantity_cubit.dart';
import 'package:tech_nest/features/cart/presentation/screens/cart_items_screen.dart';
import 'package:tech_nest/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:tech_nest/features/cart/presentation/widgets/cart_items_skeleton_list.dart';
import 'package:tech_nest/features/cart/presentation/widgets/checkout_button.dart';
import 'package:tech_nest/features/categories/domain/entities/category_entity.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class MockCartCubit extends Mock implements CartCubit {}

class MockLocaleCubit extends Mock implements LocaleCubit {}

class MockDeleteCartItemCubit extends Mock implements DeleteCartItemCubit {}

class MockUpdateItemQuantityCubit extends Mock
    implements UpdateItemQuantityCubit {}

void main() {
  late MockCartCubit mockCartCubit;
  late MockLocaleCubit mockLocaleCubit;
  late MockDeleteCartItemCubit mockDeleteCartItemCubit;
  late MockUpdateItemQuantityCubit mockUpdateItemQuantityCubit;

  setUpAll(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  setUp(() {
    mockCartCubit = MockCartCubit();
    mockLocaleCubit = MockLocaleCubit();
    mockDeleteCartItemCubit = MockDeleteCartItemCubit();
    mockUpdateItemQuantityCubit = MockUpdateItemQuantityCubit();

    // Register mocks in GetIt for widget access
    sl.registerSingleton<DeleteCartItemCubit>(mockDeleteCartItemCubit);
    sl.registerSingleton<UpdateItemQuantityCubit>(mockUpdateItemQuantityCubit);

    // Mock close() method for all cubits
    when(() => mockCartCubit.close()).thenAnswer((_) async {});
    when(() => mockLocaleCubit.close()).thenAnswer((_) async {});
    when(() => mockDeleteCartItemCubit.close()).thenAnswer((_) async {});
    when(() => mockUpdateItemQuantityCubit.close()).thenAnswer((_) async {});

    when(
      () => mockLocaleCubit.state,
    ).thenReturn(const LocaleState(AppLocale.en));
    when(() => mockLocaleCubit.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockCartCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockCartCubit.fetchCart()).thenAnswer((_) async {});
    when(() => mockCartCubit.clearMutationError()).thenReturn(null);

    when(
      () => mockDeleteCartItemCubit.state,
    ).thenReturn(const DeleteCartItemInitial());
    when(
      () => mockDeleteCartItemCubit.stream,
    ).thenAnswer((_) => const Stream.empty());

    when(
      () => mockUpdateItemQuantityCubit.state,
    ).thenReturn(const UpdateItemQuantityInitial());
    when(
      () => mockUpdateItemQuantityCubit.stream,
    ).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    sl.reset();
  });

  // ────────────────────────────────────────────────────────────────────────────
  // Helper: build the widget under test.
  //
  // • MultiBlocProvider is the outermost widget so that BlocProviders are
  //   visible to CartItemsScreen via InheritedWidget lookup.
  // • TranslationProvider wraps MaterialApp so context.t works inside the screen.
  // • Plain MaterialApp (no GoRouter) is intentional: routing calls
  //   (context.goNamed / context.pushNamed) are only reachable via button taps,
  //   and none of the tests below tap navigation buttons.
  // ────────────────────────────────────────────────────────────────────────────
  Widget buildTestSubject({required CartState cartState}) {
    when(() => mockCartCubit.state).thenReturn(cartState);

    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>.value(value: mockCartCubit),
        BlocProvider<LocaleCubit>.value(value: mockLocaleCubit),
      ],
      child: TranslationProvider(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const CartItemsScreen(),
        ),
      ),
    );
  }

  final tFailure = ServerFailure(message: 'Failed to load');

  const tProduct = ProductEntity(
    id: 1,
    name: 'Product 1',
    description: 'Desc',
    price: 100.0,
    stock: 10,
    category: CategoryEntity.empty(),
    imgUrl: 'img.jpg',
  );

  final tCart = Cart(
    items: [CartItem(id: 1, quantity: 2, product: tProduct)],
    totalQuantity: 2,
    totalPrice: 200,
    deliveryCharges: 50,
    grandTotal: 250,
  );

  group('CartItemsScreen UI States', () {
    testWidgets('shows CartItemsSkeletonList on CartInitial', (tester) async {
      await tester.pumpWidget(buildTestSubject(cartState: const CartInitial()));
      await tester.pump();

      expect(find.byType(CartItemsSkeletonList), findsOneWidget);
    });

    testWidgets('shows CartItemsSkeletonList on CartLoading', (tester) async {
      await tester.pumpWidget(buildTestSubject(cartState: const CartLoading()));
      await tester.pump();

      expect(find.byType(CartItemsSkeletonList), findsOneWidget);
    });

    testWidgets('shows RemoteDataFailureView on CartFailed', (tester) async {
      await tester.pumpWidget(
        buildTestSubject(cartState: CartFailed(failure: tFailure)),
      );
      await tester.pump();

      expect(find.byType(RemoteDataFailureView), findsOneWidget);
    });

    testWidgets(
      'shows NoResultsFoundView and shopping button when CartLoaded has no items',
      (tester) async {
        final emptyCart = Cart(
          items: [],
          totalQuantity: 0,
          totalPrice: 0,
          deliveryCharges: 0,
          grandTotal: 0,
        );

        await tester.pumpWidget(
          buildTestSubject(cartState: CartLoaded(cart: emptyCart)),
        );
        await tester.pump();

        expect(find.byType(NoResultsFoundView), findsOneWidget);
        // ElevatedButton = "Start Shopping" button below NoResultsFoundView
        expect(find.byType(ElevatedButton), findsOneWidget);
      },
    );

    testWidgets(
      'shows CartItemCard and CheckoutButton when CartLoaded has items',
      (tester) async {
        await tester.pumpWidget(
          buildTestSubject(cartState: CartLoaded(cart: tCart)),
        );
        await tester.pump();

        expect(find.byType(CartItemCard), findsOneWidget);
        expect(find.byType(CheckoutButton), findsOneWidget);
      },
    );
  });

  group('CartItemsScreen Actions', () {
    testWidgets('calls fetchCart when retry button is tapped on failure view', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestSubject(cartState: CartFailed(failure: tFailure)),
      );
      await tester.pump();

      // fetchCart() is already called once in initState (state is not CartLoaded).
      // Tap the retry FilledButton inside RemoteDataFailureView.
      await tester.tap(find.byType(FilledButton).first);
      await tester.pump();

      // Called at least twice: once in initState, once on retry tap.
      verify(() => mockCartCubit.fetchCart()).called(greaterThan(1));
    });

    testWidgets('calls fetchCart on pull-to-refresh', (tester) async {
      await tester.pumpWidget(
        buildTestSubject(cartState: CartLoaded(cart: tCart)),
      );
      await tester.pump();

      // initState skips fetchCart when state is already CartLoaded.
      // Drag the ListView down to trigger the RefreshIndicator.
      final listView = find.byType(ListView);
      expect(
        listView,
        findsOneWidget,
        reason: 'ListView must exist for pull-to-refresh',
      );

      await tester.drag(listView, const Offset(0, 300));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      verify(() => mockCartCubit.fetchCart()).called(1);
    });
  });
}
