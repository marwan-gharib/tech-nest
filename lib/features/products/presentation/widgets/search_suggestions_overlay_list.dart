import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class SearchSuggestionsOverlayList extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  const SearchSuggestionsOverlayList({
    required this.suggestions,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      shadowColor: context.colors.textPrimary.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      color: context.colors.card,
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 250),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          shrinkWrap: true,
          itemCount: suggestions.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: context.colors.divider,
          ),
          itemBuilder: (context, i) {
            final String suggestion = suggestions[i];
            return ListTile(
              title: Text(
                suggestion,
                style: context.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: context.colors.textPrimary,
                ),
              ),
              leading: Icon(
                Icons.search_rounded,
                color: context.colorScheme.primary.withValues(alpha: 0.6),
                size: 20,
              ),
              dense: true,
              onTap: () => onSelected(suggestion),
            );
          },
        ),
      ),
    );
  }
}

