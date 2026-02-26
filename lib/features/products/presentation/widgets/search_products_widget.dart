import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/products/presentation/cubit/search_suggestions_cubit.dart';
import 'package:tech_nest/features/products/presentation/widgets/custom_search_field.dart';
import 'package:tech_nest/features/products/presentation/widgets/show_search_suggestions_widget.dart';

class SearchProductsWidget extends StatelessWidget {
  final ValueChanged<String?> onSelected;

  const SearchProductsWidget({required this.onSelected, super.key});

  @override
  Widget build(BuildContext context) {
    // return Autocomplete<String>(
    //   optionsBuilder: (textEditingValue) async {
    //     return await sl<SearchSuggestionsUsecase>().call(
    //       searchQuery: textEditingValue.text,
    //     );
    //   },
    //   fieldViewBuilder:
    //       (context, textEditingController, focusNode, onFieldSubmitted) {},
    // );

    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: ShowSearchSuggestionsWidget(
              onSelected: (value) => onSelected(value),
            ),
          ),
          CustomSearchField(
            onSubmit: (value) => onSelected(value),
            onChange: (value) {
              if (value != null && value.length >= 2) {
                context.read<SearchSuggestionsCubit>().getSuggestions(
                  searchLabel: value,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
