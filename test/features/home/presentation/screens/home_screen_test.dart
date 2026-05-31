import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/app/service_locator.dart';
import 'package:tech_nest/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:tech_nest/features/cart/presentation/cubits/cart/cart_cubit.dart';
import 'package:tech_nest/features/categories/presentation/cubits/fetch_categories_cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/features/home/presentation/screens/home_screen.dart';
import 'package:tech_nest/features/home/presentation/widgets/filter_components.dart';
import 'package:tech_nest/features/products/presentation/models/filter_data.dart';
import 'package:tech_nest/features/products/presentation/cubits/fetch_products_cubit/fetch_products_cubit.dart';
import 'package:tech_nest/features/products/presentation/cubits/search_suggestions_cubit/search_suggestions_cubit.dart';
import 'package:tech_nest/features/products/presentation/widgets/shared/products_grid.dart';
import 'package:tech_nest/i18n/strings.g.dart';

import '../../../../helpers/test_app.dart';

class MockFetchProductsCubit extends MockCubit<FetchProductsState>
    implements FetchProductsCubit {}

class MockLocaleCubit extends MockCubit<LocaleState> implements LocaleCubit {}

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

class MockSearchSuggestionsCubit extends MockCubit<SearchSuggestionsState>
    implements SearchSuggestionsCubit {}

class MockFetchCategoriesCubit extends MockCubit<FetchCategoriesState>
    implements FetchCategoriesCubit {}

void main() {
  late MockFetchProductsCubit mockFetchProductsCubit;
  late MockLocaleCubit mockLocaleCubit;
  late MockCartCubit mockCartCubit;
  late MockSearchSuggestionsCubit mockSearchSuggestionsCubit;
  late MockFetchCategoriesCubit mockFetchCategoriesCubit;

  setUpAll(() {
    registerFallbackValue(const FilterData());
  });

  setUp(() {
    mockFetchProductsCubit = MockFetchProductsCubit();
    mockLocaleCubit = MockLocaleCubit();
    mockCartCubit = MockCartCubit();
    mockSearchSuggestionsCubit = MockSearchSuggestionsCubit();
    mockFetchCategoriesCubit = MockFetchCategoriesCubit();

    when(
      () => mockFetchProductsCubit.state,
    ).thenReturn(const FetchProductsLoaded(products: []));
    when(
      () => mockFetchProductsCubit.initialFetching(),
    ).thenAnswer((_) async {});
    when(() => mockFetchProductsCubit.fetchMore()).thenAnswer((_) async {});
    when(() => mockFetchProductsCubit.refresh()).thenAnswer((_) async {});
    when(
      () => mockFetchProductsCubit.applyFilters(any()),
    ).thenAnswer((_) async {});

    when(
      () => mockLocaleCubit.state,
    ).thenReturn(const LocaleState(AppLocale.en));
    when(() => mockCartCubit.state).thenReturn(const CartInitial());

    when(
      () => mockSearchSuggestionsCubit.state,
    ).thenReturn(const SearchSuggestionsInitial());
    when(
      () => mockSearchSuggestionsCubit.getSuggestions(
        searchLabel: any(named: 'searchLabel'),
      ),
    ).thenReturn(null);
    when(() => mockSearchSuggestionsCubit.clearCache()).thenReturn(null);

    when(
      () => mockFetchCategoriesCubit.state,
    ).thenReturn(const FetchCategoriesInitial());
    when(
      () => mockFetchCategoriesCubit.fetchCategories(),
    ).thenAnswer((_) async {});

    if (sl.isRegistered<SearchSuggestionsCubit>()) {
      sl.unregister<SearchSuggestionsCubit>();
    }
    if (sl.isRegistered<FetchCategoriesCubit>()) {
      sl.unregister<FetchCategoriesCubit>();
    }
    sl.registerFactory<SearchSuggestionsCubit>(
      () => mockSearchSuggestionsCubit,
    );
    sl.registerFactory<FetchCategoriesCubit>(() => mockFetchCategoriesCubit);
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  Widget buildScreen() {
    return buildTestApp(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<FetchProductsCubit>.value(value: mockFetchProductsCubit),
          BlocProvider<LocaleCubit>.value(value: mockLocaleCubit),
          BlocProvider<CartCubit>.value(value: mockCartCubit),
        ],
        child: const HomeScreen(),
      ),
    );
  }

  testWidgets('calls initialFetching on first build', (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pump();

    verify(() => mockFetchProductsCubit.initialFetching()).called(1);
    expect(find.byType(ProductsGrid), findsOneWidget);
  });

  testWidgets('refreshes products when locale changes', (tester) async {
    whenListen(
      mockLocaleCubit,
      Stream.fromIterable([const LocaleState(AppLocale.ar)]),
      initialState: const LocaleState(AppLocale.en),
    );

    await tester.pumpWidget(buildScreen());
    await tester.pump();

    verify(() => mockFetchProductsCubit.refresh()).called(1);
  });

  testWidgets('opens filter bottom sheet when filter button is tapped', (
    tester,
  ) async {
    await tester.pumpWidget(buildScreen());
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(FilterComponents), findsOneWidget);
    verify(() => mockFetchCategoriesCubit.fetchCategories()).called(1);
  });
}
