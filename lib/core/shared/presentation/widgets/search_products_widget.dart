import 'package:flutter/material.dart';
import 'package:tech_nest/core/shared/presentation/widgets/custom_search_field.dart';
import 'package:tech_nest/core/shared/presentation/widgets/search_suggestions_overlay.dart';

class SearchProductsWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String?> onSelected;
  final VoidCallback? onClear;
  final String? hintText;
  final void Function(String query) onTextChanged;
  final List<String> suggestions;
  final bool isLoading;
  final VoidCallback onClearSuggestions;

  const SearchProductsWidget({
    required this.controller,
    required this.onSelected,
    required this.onTextChanged,
    required this.suggestions,
    required this.isLoading,
    required this.onClearSuggestions,
    this.onClear,
    this.hintText,
    super.key,
  });

  @override
  State<SearchProductsWidget> createState() => _SearchProductsWidgetState();
}

class _SearchProductsWidgetState extends State<SearchProductsWidget> {
  late final OverlayPortalController _overlayController;
  final LayerLink _layerLink = LayerLink();
  final Object _groupId = Object();

  static const double _searchFieldHeight = 50.0;
  static const int _minSearchChars = 2;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_textChanged);
    _overlayController = OverlayPortalController();
  }

  void _textChanged() {
    final text = widget.controller.text;
    final show = text.length >= _minSearchChars;

    if (_overlayController.isShowing != show) {
      if (show) {
        _overlayController.show();
        widget.onTextChanged(text);
      } else {
        _overlayController.hide();
        widget.onClearSuggestions();
      }
    } else if (show) {
      widget.onTextChanged(text);
    }
  }

  void _onSuggestionSelected(String suggestion) {
    widget.controller.removeListener(_textChanged);
    widget.controller.text = suggestion;
    widget.controller.addListener(_textChanged);
    _overlayController.hide();
    widget.onClearSuggestions();
    widget.onSelected(suggestion);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_textChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      groupId: _groupId,
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
                onSelected: _onSuggestionSelected,
                groupId: _groupId,
                suggestions: widget.suggestions,
                isLoading: widget.isLoading,
              );
            },
            child: CustomSearchField(
              controller: widget.controller,
              hintText: widget.hintText,
              onSubmit: (value) {
                if (value != null && value.isNotEmpty) {
                  _overlayController.hide();
                  widget.onSelected(value);
                }
              },
              onClear: () {
                widget.onClear?.call();
                _overlayController.hide();
                widget.onClearSuggestions();
              },
            ),
          ),
        ),
      ),
    );
  }
}
