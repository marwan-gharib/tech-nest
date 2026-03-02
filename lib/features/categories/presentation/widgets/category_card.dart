import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/entities/category_entity.dart';
import 'package:tech_nest/core/theme/app_colors.dart';

class CategoryCard extends StatelessWidget {
  final VoidCallback? onTap;
  final Category category;
  final bool isSelected;
  const CategoryCard({
    required this.isSelected,
    required this.category,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : AppColors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
        child: Row(
          spacing: 5,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: Endpoints.baseUrl + category.imgUrl,
                width: 30,
                height: 30,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: Text(
                category.name,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
