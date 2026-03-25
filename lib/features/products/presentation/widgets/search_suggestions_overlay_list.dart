import 'package:flutter/material.dart';

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
      elevation: 12,
      shadowColor: Theme.of(context).shadowColor.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(20),
      color: Theme.of(context).colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 250),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          shrinkWrap: true,
          itemCount: suggestions.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
          itemBuilder: (context, i) {
            final String suggestion = suggestions[i];
            return ListTile(
              title: Text(
                suggestion,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              leading: Icon(
                Icons.search_rounded,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
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
