import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/shared/presentation/widgets/categories_view.dart';
import 'package:tech_nest/features/categories/presentation/cubits/fetch_categories_cubit/fetch_categories_cubit.dart';

class FilterCategorySection extends StatelessWidget {
  final int? initialCategoryId;
  final ValueChanged<int?> onSelected;

  const FilterCategorySection({
    required this.initialCategoryId,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchCategoriesCubit, FetchCategoriesState>(
      builder: (context, state) {
        return CategoriesView(
          initialCategoryId: initialCategoryId,
          onCategorySelected: onSelected,
          categories: state is FetchCategoriesLoaded ? state.categories : [],
          isLoading: state is FetchCategoriesLoading || state is FetchCategoriesInitial,
          error: state is FetchCategoriesFailed ? state.failure : null,
          onRetry: () => context.read<FetchCategoriesCubit>().fetchCategories(),
        );
      },
    );
  }
}
