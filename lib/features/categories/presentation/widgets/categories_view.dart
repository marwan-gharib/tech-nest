import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:tech_nest/core/domain/entities/category_entity.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/features/categories/presentation/cubits/fetch_categories_cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/features/categories/presentation/widgets/category_label_widget.dart';

class CategoriesView extends StatefulWidget {
  final int? initialCategoryId;
  final ValueChanged<int?> onCategorySelected;

  const CategoriesView({
    required this.onCategorySelected,
    this.initialCategoryId,
    super.key,
  });

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  late final ValueNotifier<int?> _selectedCategoryNotifier;

  @override
  void initState() {
    _selectedCategoryNotifier = ValueNotifier<int?>(widget.initialCategoryId);
    super.initState();
  }

  @override
  void dispose() {
    _selectedCategoryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchCategoriesCubit, FetchCategoriesState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        switch (state) {
          case FetchCategoriesNoConnection():
          case FetchCategoriesFailed():
            return Align(
              alignment: Alignment.centerLeft,
              child: switch (state) {
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
                _ => const SizedBox.shrink(),
              },
            );
          default:
            return SizedBox(
              height: AppSpacing.homeCategoryRowHeight,
              child: switch (state) {
                FetchCategoriesInitial() ||
                FetchCategoriesLoading() =>
                  ListView.builder(
                    itemCount: 8,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return const Skeletonizer(
                        child: SizedBox(height: 24, width: 80),
                      );
                    },
                  ),
                FetchCategoriesLoaded(:final categories) => ListView.builder(
                  itemCount: categories.length + 1,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  itemBuilder: (context, index) {
                    return ValueListenableBuilder<int?>(
                      valueListenable: _selectedCategoryNotifier,
                      builder: (_, selectedCategory, _) {
                        if (index == 0) {
                          return CategoryLabelWidget<String>(
                            category: "All",
                            isSelected: selectedCategory == null,
                            onTap: (id) {
                              _selectedCategoryNotifier.value = id;
                              widget.onCategorySelected(id);
                            },
                          );
                        }

                        final category = categories[index - 1];
                        return CategoryLabelWidget<CategoryEntity>(
                          category: category,
                          isSelected: selectedCategory == category.id,
                          onTap: (id) {
                            _selectedCategoryNotifier.value = id;
                            widget.onCategorySelected(id);
                          },
                        );
                      },
                    );
                  },
                ),
                _ => const SizedBox.shrink(),
              },
            );
        }
      },
    );
  }
}
