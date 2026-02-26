import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/features/products/domain/use_cases/search_suggestions_usecase.dart';

part 'search_suggestions_state.dart';

class SearchSuggestionsCubit extends Cubit<SearchSuggestionsState> {
  final SearchSuggestionsUsecase _searchSuggestionsUsecase;

  SearchSuggestionsCubit(this._searchSuggestionsUsecase)
    : super(const SearchSuggestionsInitial());

  Future<void> getSuggestions({required String searchLabel}) async {
    emit(const SearchSuggestionsLoading());

    final res = await _searchSuggestionsUsecase.call(searchQuery: searchLabel);

    res.fold(
      (failure) => emit(SearchSuggestionsFailed(message: failure.message)),
      (suggestions) => emit(SearchSuggestionsLoaded(suggestions: suggestions)),
    );
  }
}
