import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tech_nest/core/shared/domain/entities/category_entity.dart';
import 'package:tech_nest/core/shared/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
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
  void didUpdateWidget(covariant CategoriesView oldWidget) {
    if (oldWidget.initialCategoryId != widget.initialCategoryId) {
      _selectedCategoryNotifier.value = widget.initialCategoryId;
    }
    super.didUpdateWidget(oldWidget);
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
        if (state is FetchCategoriesFailed) {
          return Align(
            alignment: Alignment.centerLeft,
            child: RemoteDataFailureView(
              failure: state.failure,
              compact: true,
              onRetry: () =>
                  context.read<FetchCategoriesCubit>().fetchCategories(),
            ),
          );
        }

        return SizedBox(
          height: AppSpacing.homeCategoryRowHeight,
          child: switch (state) {
            FetchCategoriesInitial() ||
            FetchCategoriesLoading() => ListView.builder(
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
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
      },
    );
  }
}
