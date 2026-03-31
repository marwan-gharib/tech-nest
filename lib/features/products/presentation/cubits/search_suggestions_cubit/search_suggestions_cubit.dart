import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/products/domain/use_cases/search_suggestions_usecase.dart';

part 'search_suggestions_state.dart';

class SearchSuggestionsCubit extends Cubit<SearchSuggestionsState> {
  SearchSuggestionsCubit(this._searchSuggestionsUsecase)
    : super(const SearchSuggestionsInitial());

  final SearchSuggestionsUsecase _searchSuggestionsUsecase;

  String _lastQuery = '';
  Timer? _debounceTimer;
  String? _lastRequestToken;

  static const int _maxCacheSize = 20;
  final Map<String, List<String>> _suggestionsCache = {};

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  void getSuggestions({required String searchLabel}) {
    _debounceTimer?.cancel();
    _lastQuery = searchLabel;

    if (searchLabel.isEmpty) {
      emit(const SearchSuggestionsInitial());
      return;
    }

    // Check if query is in cache - return instantly
    if (_suggestionsCache.containsKey(searchLabel)) {
      final cached = _suggestionsCache[searchLabel];
      if (cached!.isEmpty) {
        emit(SearchSuggestionsEmpty(query: searchLabel));
      } else {
        emit(SearchSuggestionsLoaded(suggestions: cached));
      }
      return;
    }

    if (state is! SearchSuggestionsLoading) {
      emit(const SearchSuggestionsLoading());
    }

    // Debounce: wait 400ms after user stops typing before making request
    _debounceTimer = Timer(const Duration(milliseconds: 400), () async {
      // Generate a token for this request to handle race conditions
      final requestToken = DateTime.now().millisecondsSinceEpoch.toString();
      _lastRequestToken = requestToken;

      final res = await _searchSuggestionsUsecase.call(
        searchQuery: searchLabel,
      );

      res.fold(
        (failure) {
          if (_lastRequestToken == requestToken) {
            emit(SearchSuggestionsFailed(failure: failure));
          }
        },
        (suggestions) {
          if (_lastRequestToken == requestToken) {
            _addToCache(searchLabel, suggestions);

            if (suggestions.isEmpty) {
              emit(SearchSuggestionsEmpty(query: searchLabel));
            } else {
              emit(SearchSuggestionsLoaded(suggestions: suggestions));
            }
          }
        },
      );
    });
  }

  void _addToCache(String query, List<String> suggestions) {
    if (_suggestionsCache.length >= _maxCacheSize) {
      // Simple FIFO removal (first entry added)
      _suggestionsCache.remove(_suggestionsCache.keys.first);
    }
    _suggestionsCache[query] = suggestions;
  }

  void clearCache() {
    _suggestionsCache.clear();
    _debounceTimer?.cancel();
    emit(const SearchSuggestionsInitial());
  }

  Future<void> retryLastQuery() async {
    if (_lastQuery.isNotEmpty) {
      // Remove from cache to force a fresh request
      _suggestionsCache.remove(_lastQuery);
      getSuggestions(searchLabel: _lastQuery);
    }
  }

  /// Cancel ongoing requests
  void cancelRequest() {
    _debounceTimer?.cancel();
    _lastRequestToken = null;
  }
}
