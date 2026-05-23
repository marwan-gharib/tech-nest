import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:tech_nest/features/categories/presentation/cubits/category_products_cubit/category_products_cubit.dart';
import 'package:tech_nest/features/categories/presentation/cubits/fetch_categories_cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/features/categories/presentation/screens/categories_screen.dart';
import 'package:tech_nest/core/theme/app_theme.dart';
import 'package:tech_nest/features/categories/presentation/widgets/left_category_sidebar.dart';
import 'package:tech_nest/features/categories/presentation/widgets/right_product_list.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class MockFetchCategoriesCubit extends MockCubit<FetchCategoriesState>
    implements FetchCategoriesCubit {}

class MockCategoryProductsCubit extends MockCubit<CategoryProductsState>
    implements CategoryProductsCubit {}

class MockLocaleCubit extends MockCubit<LocaleState> implements LocaleCubit {}

void main() {
  late MockFetchCategoriesCubit mockFetchCategoriesCubit;
  late MockCategoryProductsCubit mockCategoryProductsCubit;
  late MockLocaleCubit mockLocaleCubit;

  setUp(() {
    mockFetchCategoriesCubit = MockFetchCategoriesCubit();
    mockCategoryProductsCubit = MockCategoryProductsCubit();
    mockLocaleCubit = MockLocaleCubit();

    when(
      () => mockFetchCategoriesCubit.state,
    ).thenReturn(const FetchCategoriesLoaded(categories: []));
    when(
      () => mockCategoryProductsCubit.state,
    ).thenReturn(const CategoryProductsLoaded(products: [], hasReachedMax: true));
    when(
      () => mockLocaleCubit.state,
    ).thenReturn(const LocaleState(AppLocale.en));

    when(
      () => mockFetchCategoriesCubit.fetchCategories(),
    ).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FetchCategoriesCubit>.value(
          value: mockFetchCategoriesCubit,
        ),
        BlocProvider<CategoryProductsCubit>.value(
          value: mockCategoryProductsCubit,
        ),
        BlocProvider<LocaleCubit>.value(value: mockLocaleCubit),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(body: CategoriesScreen()),
      ),
    );
  }

  group('CategoriesScreen', () {
    testWidgets('should render LeftCategorySidebar and RightProductList', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(LeftCategorySidebar), findsOneWidget);
      expect(find.byType(RightProductList), findsOneWidget);
    });

    testWidgets(
      'should call fetchCategories on FetchCategoriesCubit when locale changes',
      (tester) async {
        whenListen(
          mockLocaleCubit,
          Stream.fromIterable([
            const LocaleState(AppLocale.ar),
          ]),
          initialState: const LocaleState(AppLocale.en),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Pump to process the stream events
        await tester.pump();

        verify(() => mockFetchCategoriesCubit.fetchCategories()).called(1);
      },
    );
  });
}
