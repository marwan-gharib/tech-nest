import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/core/widgets/active_filter_badge.dart';
import 'package:tech_nest/i18n/strings.g.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: AppSpacing.sm,
          children: [
            Text(
              context.t.home.filters,
              style: context.headlineSmall.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            ActiveFilterBadge(count: activeFilterCount),
          ],
        ),
        TextButton(
          onPressed: onReset,
          style: TextButton.styleFrom(
            foregroundColor: context.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
          child: Text(
            context.t.home.clearAll,
            style: context.labelLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

