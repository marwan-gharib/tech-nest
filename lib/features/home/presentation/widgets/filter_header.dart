import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/home/presentation/widgets/active_filter_badge.dart';

class FilterHeader extends StatelessWidget {
  final int activeFilterCount;
  final VoidCallback onReset;

  const FilterHeader({
    required this.activeFilterCount,
    required this.onReset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        children: [
          Text(
            'Filters',
            style: theme.textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
              letterSpacing: -0.3,
            ),
          ),
          if (activeFilterCount > 0) ...[
            const SizedBox(width: AppSpacing.sm),
            ActiveFilterBadge(count: activeFilterCount),
          ],
          const Spacer(),
          AnimatedOpacity(
            opacity: activeFilterCount > 0 ? 1.0 : 0.35,
            duration: const Duration(milliseconds: 250),
            child: TextButton.icon(
              onPressed: activeFilterCount > 0 ? onReset : null,
              icon: Icon(
                Icons.close_rounded,
                size: 15,
                color: theme.colorScheme.primary,
              ),
              label: Text(
                'Clear all',
                style: theme.textTheme.labelMedium!.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  side: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.25),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
