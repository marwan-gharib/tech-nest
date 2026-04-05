import 'package:flutter/material.dart';
import 'package:tech_nest/core/shared/presentation/widgets/categories_view.dart';

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
    return CategoriesView(
      initialCategoryId: initialCategoryId,
      onCategorySelected: onSelected,
    );
  }
}
