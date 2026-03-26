import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/di/service_locator.dart';
import 'package:tech_nest/features/categories/presentation/cubits/fetch_categories_cubit/fetch_categories_cubit.dart';
import 'package:tech_nest/features/categories/presentation/widgets/categories_view.dart';

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
    return BlocProvider(
      create: (context) => sl<FetchCategoriesCubit>()..fetchCategories(),
      child: CategoriesView(
        key: ValueKey(initialCategoryId),
        initialCategoryId: initialCategoryId,
        onCategorySelected: onSelected,
      ),
    );
  }
}
