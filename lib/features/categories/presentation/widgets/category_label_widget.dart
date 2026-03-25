import 'package:flutter/material.dart';
import 'package:tech_nest/core/domain/entities/category_entity.dart';

class CategoryLabelWidget<T> extends StatelessWidget {
  final dynamic category;
  final bool isSelected;
  final ValueChanged<int?> onTap;
  const CategoryLabelWidget({
    required this.category,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: GestureDetector(
        onTap: () {
          if (category is Category) {
            onTap((category as Category).id);
          } else {
            onTap(null);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: RepaintBoundary(
              child: Text(
                category is Category
                    ? (category as Category).name
                    : category is String
                    ? category as String
                    : category.toString(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: isSelected
                      ? Theme.of(context).shadowColor
                      : Theme.of(context).hintColor,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
