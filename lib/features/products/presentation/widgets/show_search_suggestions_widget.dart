import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/features/products/presentation/cubit/search_suggestions_cubit.dart';

class ShowSearchSuggestionsWidget extends StatelessWidget {
  final ValueChanged<String> onSelected;

  const ShowSearchSuggestionsWidget({required this.onSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchSuggestionsCubit, SearchSuggestionsState>(
      listener: (context, state) {
        if (state is SearchSuggestionsFailed) {
          customSnackBar(context, message: state.message, isAbove: true);
        }
      },
      builder: (context, state) {
        if (state is SearchSuggestionsLoading) {
          return Container(
            margin: const EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (state is SearchSuggestionsLoaded &&
            state.suggestions.isNotEmpty) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary,
              // borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              child: ListView.builder(
                // padding: const EdgeInsets.symmetric(vertical: 20),
                itemCount: state.suggestions.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(state.suggestions[i]),
                    leading: const Icon(Icons.search),
                    onTap: () => onSelected(state.suggestions[i]),
                  );
                },
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
