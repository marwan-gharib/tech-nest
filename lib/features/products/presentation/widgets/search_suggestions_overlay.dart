import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    // Calc width based on screen width - AppSpacing.md*2 - FilterButtonWidth(50) - spacing(AppSpacing.sm)
    final double overlayWidth =
        size.width - (AppSpacing.md * 2) - 50.0 - AppSpacing.sm;

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
              builder: (context, state) {
                if (state is SearchSuggestionsLoaded &&
                    state.suggestions.isNotEmpty) {
                  return SearchSuggestionsOverlayList(
                    suggestions: state.suggestions,
                    onSelected: onSelected,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
