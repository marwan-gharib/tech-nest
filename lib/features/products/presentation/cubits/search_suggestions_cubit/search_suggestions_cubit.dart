import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tech_nest/core/error/failures/failure_extensions.dart';
import 'package:tech_nest/features/products/domain/use_cases/search_suggestions_usecase.dart';

part 'search_suggestions_state.dart';

class SearchSuggestionsCubit extends Cubit<SearchSuggestionsState> {
  SearchSuggestionsCubit(this._searchSuggestionsUsecase)
    : super(const SearchSuggestionsInitial());

  final SearchSuggestionsUsecase _searchSuggestionsUsecase;

  String _lastQuery = '';

  Future<void> getSuggestions({required String searchLabel}) async {
    _lastQuery = searchLabel;
    if (searchLabel.isEmpty) {
      emit(const SearchSuggestionsInitial());
      return;
    }

    emit(const SearchSuggestionsLoading());

    final res = await _searchSuggestionsUsecase.call(searchQuery: searchLabel);

    res.fold(
      (failure) {
        if (failure.isNetworkFailure) {
          emit(const SearchSuggestionsNoConnection());
        } else {
          emit(SearchSuggestionsFailed(message: failure.message));
        }
      },
      (suggestions) =>
          emit(SearchSuggestionsLoaded(suggestions: suggestions)),
    );
  }

  void retryLastQuery() {
    if (_lastQuery.isNotEmpty) {
      getSuggestions(searchLabel: _lastQuery);
    }
  }
}
