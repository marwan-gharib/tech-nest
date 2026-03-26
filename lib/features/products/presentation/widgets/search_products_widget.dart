import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/products/presentation/cubits/search_suggestions_cubit/search_suggestions_cubit.dart';
import 'package:tech_nest/features/products/presentation/widgets/custom_search_field.dart';
import 'package:tech_nest/features/products/presentation/widgets/search_suggestions_overlay.dart';

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

  static const double _searchFieldHeight = 50.0;
  static const int _minSearchChars = 2;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_textChanged);
    _overlayController = OverlayPortalController();
  }

  void _textChanged() {
    final show = widget.controller.text.length >= _minSearchChars;
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
          height: _searchFieldHeight,
          child: OverlayPortal(
            controller: _overlayController,
            overlayChildBuilder: (context) {
              return SearchSuggestionsOverlay(
                layerLink: _layerLink,
                onSelected: (suggestion) {
                  widget.onSelected(suggestion);
                  widget.controller.text = suggestion;
                  _overlayController.hide();
                },
              );
            },
            child: CustomSearchField(
              controller: widget.controller,
              onSubmit: (value) {
                widget.onSelected(value);
                _overlayController.hide();
              },
              onChange: (value) async {
                if (value != null && value.length >= _minSearchChars) {
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
