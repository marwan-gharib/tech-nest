import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/widgets/custom_skeleton_list.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/features/products/presentation/cubits/search_suggestions_cubit/search_suggestions_cubit.dart';
import 'package:tech_nest/features/products/presentation/widgets/search_suggestions_overlay_list.dart';

class SearchSuggestionsOverlay extends StatelessWidget {
  final LayerLink layerLink;
  final ValueChanged<String> onSelected;
  final Object groupId;

  const SearchSuggestionsOverlay({
    required this.layerLink,
    required this.onSelected,
    required this.groupId,
    super.key,
  });

  static const double _overlayHeight = 230.0;
  static const double _overlayOffset = 56.0;
  static const double _overlayElevation = 12.0;
  static const double _shadowAlpha = 0.2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    final double overlayWidth =
        size.width -
        (AppSpacing.md * 2) -
        AppSpacing.homeFilterButtonWidth -
        AppSpacing.sm;

    return BlocBuilder<SearchSuggestionsCubit, SearchSuggestionsState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType ||
          (previous is SearchSuggestionsLoaded &&
              current is SearchSuggestionsLoaded &&
              previous.suggestions != current.suggestions),
      builder: (context, state) {
        // Determine if overlay should be visible
        final shouldShowOverlay = switch (state) {
          SearchSuggestionsInitial() => false,
          SearchSuggestionsLoading() => true,
          SearchSuggestionsLoaded(:final suggestions) => suggestions.isNotEmpty,
          SearchSuggestionsEmpty() => true,
          SearchSuggestionsFailed() => true,
        };

        if (!shouldShowOverlay) {
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
                shadowColor: theme.shadowColor.withValues(alpha: _shadowAlpha),
                borderRadius: AppRadius.cardLg,
                color: theme.colorScheme.surface,
                clipBehavior: Clip.antiAlias,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {},
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: _overlayHeight,
                    ),
                    child: switch (state) {
                      SearchSuggestionsInitial() => const SizedBox.shrink(),

                      SearchSuggestionsLoading() => const CustomSkeletonList(),

                      SearchSuggestionsLoaded(:final suggestions)
                          when suggestions.isNotEmpty =>
                        SearchSuggestionsOverlayList(
                          suggestions: suggestions,
                          onSelected: onSelected,
                        ),

                      SearchSuggestionsLoaded() => _buildEmptyState(
                        context,
                        '',
                      ),

                      SearchSuggestionsEmpty(:final query) => _buildEmptyState(
                        context,
                        query,
                      ),

                      SearchSuggestionsFailed(:final failure) =>
                        RemoteDataFailureView(
                          failure: failure,
                          compact: true,
                          onRetry: () => context
                              .read<SearchSuggestionsCubit>()
                              .retryLastQuery(),
                        ),
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No suggestions found',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'for "$query"',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
