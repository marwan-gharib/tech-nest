import 'package:flutter/material.dart';
import 'package:tech_nest/core/widgets/custom_skeleton_list.dart';
import 'package:tech_nest/features/products/presentation/widgets/search_suggestions_overlay_list.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class SearchSuggestionsOverlay extends StatelessWidget {
  final LayerLink layerLink;
  final ValueChanged<String> onSelected;
  final Object groupId;
  final List<String> suggestions;
  final bool isLoading;
  final String? emptyQuery;

  const SearchSuggestionsOverlay({
    required this.layerLink,
    required this.onSelected,
    required this.groupId,
    required this.suggestions,
    required this.isLoading,
    this.emptyQuery,
    super.key,
  });

  static const double _overlayHeight = 230.0;
  static const double _overlayOffset = 56.0;
  static const double _overlayElevation = 12.0;
  static const double _shadowAlpha = 0.2;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final double overlayWidth =
        size.width -
        (AppSpacing.md * 2) -
        AppSpacing.homeFilterButtonWidth -
        AppSpacing.sm;

    if (!isLoading && suggestions.isEmpty && emptyQuery == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      width: overlayWidth,
      child: CompositedTransformFollower(
        link: layerLink,
        showWhenUnlinked: false,
        offset: const Offset(0, _overlayOffset),
        child: TapRegion(
          groupId: groupId,
          child: Material(
            elevation: _overlayElevation,
            shadowColor: context.colors.textPrimary.withValues(alpha: _shadowAlpha),
            borderRadius: AppRadius.cardLg,
            color: context.colors.card,
            clipBehavior: Clip.antiAlias,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {},
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: _overlayHeight,
                ),
                child: isLoading
                    ? const CustomSkeletonList()
                    : suggestions.isNotEmpty
                        ? SearchSuggestionsOverlayList(
                            suggestions: suggestions,
                            onSelected: onSelected,
                          )
                        : _buildEmptyState(context, emptyQuery ?? ''),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: context.colors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No suggestions found',
              style: context.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (query.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'for "$query"',
                style: context.bodySmall.copyWith(
                  color: context.colors.textSecondary.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

