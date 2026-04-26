import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/categories/domain/entities/category_entity.dart';

class CategoryCard extends StatelessWidget {
  final VoidCallback? onTap;
  final CategoryEntity category;
  final bool isSelected;

  static const double _cardBorderRadius = 12.0;
  static const double _imageSize = 30.0;
  static const double _selectionAlpha = 0.1;

  const CategoryCard({
    required this.isSelected,
    required this.category,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: _selectionAlpha)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(_cardBorderRadius),
          border: Border.all(
            color: isSelected ? colorScheme.primary : context.colors.border,
            width: 1,
          ),
        ),
        child: Row(
          spacing: AppSpacing.xs + 1,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                filterQuality: FilterQuality.high,
                imageUrl: Endpoints.baseUrl + category.imgUrl,
                width: _imageSize,
                height: _imageSize,
                memCacheHeight: 300,
                memCacheWidth: 300,
                fit: BoxFit.fill,
                placeholder: (context, url) => SpinKitWaveSpinner(
                  color: context.colorScheme.primary,
                  size: 40,
                ),
                errorWidget: (context, url, error) => Container(
                  color: context.colors.shimmerBase,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                category.name,
                style: context.bodyMedium,
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

