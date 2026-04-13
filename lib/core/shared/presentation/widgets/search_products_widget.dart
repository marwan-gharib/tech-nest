import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/shared/presentation/cubits/search_suggestions_cubit/search_suggestions_cubit.dart';
import 'package:tech_nest/core/shared/presentation/widgets/custom_search_field.dart';
import 'package:tech_nest/core/shared/presentation/widgets/search_suggestions_overlay.dart';

class SearchProductsWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String?> onSelected;
  final VoidCallback? onClear;

  final String? hintText;

  const SearchProductsWidget({
    required this.controller,
    required this.onSelected,
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
  SearchSuggestionsCubit? _searchSuggestionsCubit;

  static const double _searchFieldHeight = 50.0;
  static const int _minSearchChars = 2;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_textChanged);
    _overlayController = OverlayPortalController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchSuggestionsCubit ??= context.read<SearchSuggestionsCubit>();
  }

  void _textChanged() {
    final text = widget.controller.text;
    final show = text.length >= _minSearchChars;

    if (_overlayController.isShowing != show) {
      if (show) {
        _overlayController.show();
        context.read<SearchSuggestionsCubit>().getSuggestions(
          searchLabel: text,
        );
      } else {
        _overlayController.hide();
        context.read<SearchSuggestionsCubit>().clearCache();
      }
    } else if (show) {
      context.read<SearchSuggestionsCubit>().getSuggestions(searchLabel: text);
    }
  }

  void _onSuggestionSelected(String suggestion) {
    widget.controller.removeListener(_textChanged);

    widget.controller.text = suggestion;

    widget.controller.addListener(_textChanged);

    _overlayController.hide();

    context.read<SearchSuggestionsCubit>().clearCache();

    widget.onSelected(suggestion);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_textChanged);
    // Cancel ongoing requests when widget is disposed
    _searchSuggestionsCubit?.cancelRequest();
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
                context.read<SearchSuggestionsCubit>().clearCache();
              },
            ),
          ),
        ),
      ),
    );
  }
}
