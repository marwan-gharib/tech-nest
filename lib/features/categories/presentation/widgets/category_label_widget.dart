import 'package:flutter/material.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/categories/domain/entities/category_entity.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: () {
          if (category is CategoryEntity) {
            onTap((category as CategoryEntity).id);
          } else {
            onTap(null);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? context.colorScheme.primary
                : context.colors.background,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: context.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
            border: Border.all(
              color: isSelected
                  ? context.colorScheme.primary
                  : context.colors.border,
              width: 1.5,
            ),
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: context.labelLarge.copyWith(
                color: isSelected
                    ? context.colorScheme.onPrimary
                    : context.colors.textSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              child: Text(
                category is CategoryEntity
                    ? (category as CategoryEntity).name
                    : category is String
                    ? category as String
                    : category.toString(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

