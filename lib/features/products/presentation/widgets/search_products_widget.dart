import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:tech_nest/features/products/presentation/cubits/search_suggestions_cubit/search_suggestions_cubit.dart';
import 'package:tech_nest/features/products/presentation/widgets/custom_search_field.dart';

class SearchProductsWidget extends StatefulWidget {
  final ValueChanged<String?> onSelected;

  const SearchProductsWidget({required this.onSelected, super.key});

  @override
  State<SearchProductsWidget> createState() => _SearchProductsWidgetState();
}

class _SearchProductsWidgetState extends State<SearchProductsWidget> {
  late final TextEditingController _controller;
  late final ValueNotifier<bool> _showSuggestionsNotifire;

  @override
  void initState() {
    _controller = TextEditingController()..addListener(_textChanged);

    _showSuggestionsNotifire = ValueNotifier(false);

    super.initState();
  }

  void _textChanged() {
    final show = _controller.text.length >= 2;
    if (_showSuggestionsNotifire.value != show) {
      _showSuggestionsNotifire.value = show;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_textChanged);
    _controller.dispose();
    _showSuggestionsNotifire.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 250, minHeight: 40),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
            child: CustomSearchField(
              controller: _controller,
              onSubmit: (value) => widget.onSelected(value),
              onChange: (value) async {
                if (value != null && value.length >= 2) {
                  await context.read<SearchSuggestionsCubit>().getSuggestions(
                    searchLabel: value,
                  );
                }
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _showSuggestionsNotifire,
            builder: (_, value, child) {
              return value ? child! : const SizedBox.shrink();
            },
            child:
                BlocSelector<
                  SearchSuggestionsCubit,
                  SearchSuggestionsState,
                  List<String>
                >(
                  selector: (state) {
                    if (state is SearchSuggestionsLoaded) {
                      return state.suggestions;
                    }
                    return [];
                  },
                  builder: (context, suggestions) {
                    if (suggestions.isNotEmpty) {
                      return _suggestionsView(suggestions: suggestions);
                    }
                    return const SizedBox.shrink();
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _suggestionsView({required List<String> suggestions}) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, i) {
            final String suggestion = suggestions[i];
            return ListTile(
              title: Text(
                suggestion,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              leading: const Icon(Icons.search),
              dense: true,
              onTap: () {
                widget.onSelected(suggestion);
                _controller.setText(suggestion);
                _showSuggestionsNotifire.value = false;
              },
            );
          },
        ),
      ),
    );
  }
}
