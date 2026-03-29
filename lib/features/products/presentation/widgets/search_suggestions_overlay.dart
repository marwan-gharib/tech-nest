import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/features/products/presentation/cubits/search_suggestions_cubit/search_suggestions_cubit.dart';
import 'package:tech_nest/features/products/presentation/widgets/search_suggestions_overlay_list.dart';

class SearchSuggestionsOverlay extends StatelessWidget {
  final LayerLink layerLink;
  final ValueChanged<String> onSelected;

  const SearchSuggestionsOverlay({
    required this.layerLink,
    required this.onSelected,
    super.key,
  });

  static const double _overlayHeight = 250.0;
  static const double _overlayOffset = 56.0;
  static const double _overlayElevation = 12.0;
  static const double _shadowAlpha = 0.2;
  static const int _loadingPlaceholderCount = 5;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    final double overlayWidth = size.width -
        (AppSpacing.md * 2) -
        AppSpacing.homeFilterButtonWidth -
        AppSpacing.sm;

    return Positioned(
      width: overlayWidth,
      child: CompositedTransformFollower(
        link: layerLink,
        showWhenUnlinked: false,
        offset: const Offset(0, _overlayOffset),
        child: Material(
          elevation: _overlayElevation,
          shadowColor: theme.shadowColor.withValues(alpha: _shadowAlpha),
          borderRadius: AppRadius.cardLg,
          color: theme.colorScheme.surface,
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: _overlayHeight),
            child: BlocBuilder<SearchSuggestionsCubit, SearchSuggestionsState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                return switch (state) {
                  SearchSuggestionsInitial() => const SizedBox.shrink(),
                  SearchSuggestionsLoading() => ListView.builder(
                    itemCount: _loadingPlaceholderCount,
                    itemBuilder: (context, index) {
                      return const Skeletonizer(
                        child: ListTile(
                          title: Text(''),
                        ),
                      );
                    },
                  ),
                  SearchSuggestionsNoConnection() =>
                    RemoteDataFailureView(
                      isNoConnection: true,
                      compact: true,
                      onRetry: () => context
                          .read<SearchSuggestionsCubit>()
                          .retryLastQuery(),
                    ),
                  SearchSuggestionsFailed(:final message) =>
                    RemoteDataFailureView(
                      isNoConnection: false,
                      compact: true,
                      detailMessage: message,
                      onRetry: () => context
                          .read<SearchSuggestionsCubit>()
                          .retryLastQuery(),
                    ),
                  SearchSuggestionsLoaded(:final suggestions)
                      when suggestions.isNotEmpty =>
                    SearchSuggestionsOverlayList(
                      suggestions: suggestions,
                      onSelected: onSelected,
                    ),
                  SearchSuggestionsLoaded() => const SizedBox.shrink(),
                };
              },
            ),
          ),
        ),
      ),
    );
  }
}
