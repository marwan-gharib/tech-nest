import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/features/categories/presentation/cubits/category_products_cubit/category_products_cubit.dart';
import 'package:tech_nest/features/categories/presentation/cubits/fetch_categories_cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/features/categories/presentation/widgets/category_card.dart';
import 'package:tech_nest/features/categories/presentation/widgets/category_skeleton_list.dart';

class LeftCategorySidebar extends StatelessWidget {
  final ValueNotifier<int> selectedCategoryIndex;
  final void Function(int index, int categoryId) onCategorySelected;

  const LeftCategorySidebar({
    required this.selectedCategoryIndex,
    required this.onCategorySelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: theme.colorScheme.outline),
        ),
      ),
      child: BlocConsumer<FetchCategoriesCubit, FetchCategoriesState>(
        listenWhen: (previous, current) =>
            current is FetchCategoriesLoaded &&
            (previous is! FetchCategoriesLoaded ||
                previous.categories != current.categories),
        listener: (context, state) {
          if (state is FetchCategoriesLoaded && state.categories.isNotEmpty) {
            final categoryId = state.categories[selectedCategoryIndex.value].id;
            context.read<CategoryProductsCubit>().fetchInitialCategoryProducts(
                  categoryId: categoryId,
                );
          }
        },
        builder: (context, state) {
          return switch (state) {
            FetchCategoriesInitial() ||
            FetchCategoriesLoading() =>
              const CategorySkeletonList(),
            FetchCategoriesNoConnection() => RemoteDataFailureView(
              isNoConnection: true,
              compact: true,
              onRetry: () =>
                  context.read<FetchCategoriesCubit>().fetchCategories(),
            ),
            FetchCategoriesFailed(:final message) => RemoteDataFailureView(
              isNoConnection: false,
              detailMessage: message,
              compact: true,
              onRetry: () =>
                  context.read<FetchCategoriesCubit>().fetchCategories(),
            ),
            FetchCategoriesLoaded(:final categories) => ListView.builder(
              itemCount: categories.length,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.sm,
              ),
              itemBuilder: (context, index) {
                return ValueListenableBuilder<int>(
                  valueListenable: selectedCategoryIndex,
                  builder: (context, selectedIndex, _) {
                    return CategoryCard(
                      isSelected: selectedIndex == index,
                      category: categories[index],
                      onTap: () {
                        if (selectedIndex == index) return;
                        selectedCategoryIndex.value = index;
                        onCategorySelected(index, categories[index].id);
                      },
                    );
                  },
                );
              },
            ),
          };
        },
      ),
    );
  }
}
