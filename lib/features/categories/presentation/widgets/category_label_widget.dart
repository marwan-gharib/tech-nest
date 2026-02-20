import 'package:flutter/material.dart';
import 'package:tech_nest/features/categories/domain/entities/category_entity.dart';

class CategoryLabelWidget extends StatelessWidget {
  final CategoryEntity category;
  final bool isSelected;
  final ValueChanged<int> onTap;
  const CategoryLabelWidget({
    required this.category,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(category.id),
      child: Container(
        height: 24,
        width: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            category.name,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: isSelected
                  ? Theme.of(context).shadowColor
                  : Theme.of(context).hintColor,
            ),
          ),
        ),
      ),
    );
  }
}
