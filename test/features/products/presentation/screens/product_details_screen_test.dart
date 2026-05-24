import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/core/theme/app_theme.dart';
import 'package:tech_nest/core/widgets/loading_indicator.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/features/products/domain/entities/product_entity.dart';
import 'package:tech_nest/features/products/presentation/cubits/get_product_cubit/get_product_cubit.dart';
import 'package:tech_nest/features/products/presentation/screens/product_details_screen.dart';
import 'package:tech_nest/features/products/presentation/widgets/add_to_cart_action.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class MockGetProductCubit extends MockCubit<GetProductState>
    implements GetProductCubit {}

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

void main() {
  late MockGetProductCubit mockGetProductCubit;
  late MockCartCubit mockCartCubit;

  setUp(() {
    mockGetProductCubit = MockGetProductCubit();
    mockCartCubit = MockCartCubit();

    when(() => mockGetProductCubit.state).thenReturn(const GetProductInitial());
    when(() => mockCartCubit.state).thenReturn(const CartInitial());
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetProductCubit>.value(value: mockGetProductCubit),
        BlocProvider<CartCubit>.value(value: mockCartCubit),
      ],
      child: TranslationProvider(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const Scaffold(body: ProductDetailsScreen(productId: 1)),
        ),
      ),
    );
  }

  group('ProductDetailsScreen', () {
    testWidgets(
      'should show LoadingIndicator when state is GetProductLoading',
      (tester) async {
        when(
          () => mockGetProductCubit.state,
        ).thenReturn(const GetProductLoading());

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(LoadingIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'should show RemoteDataFailureView when state is GetProductError',
      (tester) async {
        when(
          () => mockGetProductCubit.state,
        ).thenReturn(GetProductError(ServerFailure()));

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(RemoteDataFailureView), findsOneWidget);
      },
    );

    testWidgets('should react correctly when GetProductCubit state changes', (
      tester,
    ) async {
      whenListen<GetProductState>(
        mockGetProductCubit,
        Stream.fromIterable([
          const GetProductLoading(),
          const GetProductLoaded(ProductEntity.empty()),
        ]),
        initialState: const GetProductInitial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(AddToCartAction), findsOneWidget);
    });
  });
}
