import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      elevation: 8,
      shadowColor: theme.shadowColor.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      color: colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 250),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          shrinkWrap: true,
          itemCount: suggestions.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          itemBuilder: (context, i) {
            final String suggestion = suggestions[i];
            return ListTile(
              title: Text(
                suggestion,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
              leading: Icon(
                Icons.search_rounded,
                color: colorScheme.primary.withValues(alpha: 0.6),
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
