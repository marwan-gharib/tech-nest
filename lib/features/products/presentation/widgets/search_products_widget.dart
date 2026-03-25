import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/products/presentation/cubits/search_suggestions_cubit/search_suggestions_cubit.dart';
import 'package:tech_nest/features/products/presentation/widgets/custom_search_field.dart';
import 'package:tech_nest/features/products/presentation/widgets/search_suggestions_overlay_list.dart';

class SearchProductsWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String?> onSelected;

  const SearchProductsWidget({
    required this.controller,
    required this.onSelected,
    super.key,
  });

  @override
  State<SearchProductsWidget> createState() => _SearchProductsWidgetState();
}

class _SearchProductsWidgetState extends State<SearchProductsWidget> {
  late final OverlayPortalController _overlayController;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    widget.controller.addListener(_textChanged);
    _overlayController = OverlayPortalController();
    super.initState();
  }

  void _textChanged() {
    final show = widget.controller.text.length >= 2;
    if (_overlayController.isShowing != show) {
      if (show) {
        _overlayController.show();
      } else {
        _overlayController.hide();
      }
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_textChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (_) => _overlayController.hide(),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: SizedBox(
          height: 50,
          child: OverlayPortal(
            controller: _overlayController,
            overlayChildBuilder: (BuildContext context) {
              return Positioned(
                width:
                    MediaQuery.of(context).size.width -
                    32 -
                    12 -
                    50, // Screen width minus padding minus filter button
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: const Offset(
                    0,
                    56,
                  ), // Height of custom search field + padding
                  child: Material(
                    elevation: 12,
                    shadowColor: Theme.of(
                      context,
                    ).shadowColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.surface,
                    clipBehavior: Clip.antiAlias,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 250),
                      child: BlocBuilder<SearchSuggestionsCubit, SearchSuggestionsState>(
                        builder: (context, state) {
                          if (state is SearchSuggestionsLoaded && state.suggestions.isNotEmpty) {
                            return SearchSuggestionsOverlayList(
                              suggestions: state.suggestions,
                              onSelected: (suggestion) {
                                widget.onSelected(suggestion);
                                widget.controller.text = suggestion;
                                _overlayController.hide();
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
              child: CustomSearchField(
                controller: widget.controller,
                onSubmit: (value) {
                  widget.onSelected(value);
                  _overlayController.hide();
                },
                onChange: (value) async {
                  if (value != null && value.length >= 2) {
                    await context.read<SearchSuggestionsCubit>().getSuggestions(
                      searchLabel: value,
                    );
                  }
                },
              ),
            ),
          ),
        ),
      );
  }
}
