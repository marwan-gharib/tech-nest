import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_nest/core/error/failures/server_failure.dart';
import 'package:tech_nest/core/widgets/loading_indicator.dart';
import 'package:tech_nest/features/categories/domain/entities/category_entity.dart';
import 'package:tech_nest/features/categories/presentation/cubits/fetch_categories_cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/features/home/presentation/widgets/filter_category_section.dart';

import '../../../../helpers/test_app.dart';

class MockFetchCategoriesCubit extends MockCubit<FetchCategoriesState>
    implements FetchCategoriesCubit {}

void main() {
  late MockFetchCategoriesCubit mockFetchCategoriesCubit;

  const categories = [
    CategoryEntity(id: 1, name: 'Phones', imgUrl: ''),
    CategoryEntity(id: 2, name: 'Laptops', imgUrl: ''),
  ];

  setUp(() {
    mockFetchCategoriesCubit = MockFetchCategoriesCubit();
    when(
      () => mockFetchCategoriesCubit.state,
    ).thenReturn(const FetchCategoriesInitial());
    when(
      () => mockFetchCategoriesCubit.fetchCategories(),
    ).thenAnswer((_) async {});
  });

  testWidgets('shows loading indicator in loading states', (tester) async {
    when(
      () => mockFetchCategoriesCubit.state,
    ).thenReturn(const FetchCategoriesLoading());

    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<FetchCategoriesCubit>.value(
          value: mockFetchCategoriesCubit,
          child: Scaffold(
            body: FilterCategorySection(
              initialCategoryId: null,
              onSelected: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(find.byType(LoadingIndicator), findsOneWidget);
  });

  testWidgets('shows categories and emits selected id on tap', (tester) async {
    int? selectedId;
    when(
      () => mockFetchCategoriesCubit.state,
    ).thenReturn(const FetchCategoriesLoaded(categories: categories));

    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<FetchCategoriesCubit>.value(
          value: mockFetchCategoriesCubit,
          child: Scaffold(
            body: FilterCategorySection(
              initialCategoryId: null,
              onSelected: (id) => selectedId = id,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Phones'), findsOneWidget);
    expect(find.text('Laptops'), findsOneWidget);

    await tester.tap(find.text('Phones'));
    await tester.pump();

    expect(selectedId, 1);
  });

  testWidgets('shows error state and retries on button tap', (tester) async {
    final failure = ServerFailure(message: 'failed to load');
    when(
      () => mockFetchCategoriesCubit.state,
    ).thenReturn(FetchCategoriesFailed(failure: failure));

    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<FetchCategoriesCubit>.value(
          value: mockFetchCategoriesCubit,
          child: Scaffold(
            body: FilterCategorySection(
              initialCategoryId: null,
              onSelected: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('failed to load'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.refresh_rounded));
    await tester.pump();

    verify(() => mockFetchCategoriesCubit.fetchCategories()).called(1);
  });

  testWidgets('rebuilds correctly across loading loaded and error states', (
    tester,
  ) async {
    whenListen(
      mockFetchCategoriesCubit,
      Stream<FetchCategoriesState>.periodic(
        const Duration(milliseconds: 10),
        (index) => [
          const FetchCategoriesLoading(),
          const FetchCategoriesLoaded(categories: categories),
          FetchCategoriesFailed(failure: ServerFailure(message: 'boom')),
        ][index],
      ).take(3),
      initialState: const FetchCategoriesInitial(),
    );

    await tester.pumpWidget(
      buildTestApp(
        child: BlocProvider<FetchCategoriesCubit>.value(
          value: mockFetchCategoriesCubit,
          child: Scaffold(
            body: FilterCategorySection(
              initialCategoryId: null,
              onSelected: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(find.byType(LoadingIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 20));
    expect(find.text('Phones'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 10));
    expect(find.text('boom'), findsOneWidget);
  });
}
