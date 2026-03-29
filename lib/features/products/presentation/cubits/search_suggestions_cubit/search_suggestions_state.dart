part of 'search_suggestions_cubit.dart';

sealed class SearchSuggestionsState extends Equatable {
  const SearchSuggestionsState();

  @override
  List<Object> get props => [];
}

final class SearchSuggestionsInitial extends SearchSuggestionsState {
  const SearchSuggestionsInitial();
}

final class SearchSuggestionsLoading extends SearchSuggestionsState {
  const SearchSuggestionsLoading();
}

final class SearchSuggestionsLoaded extends SearchSuggestionsState {
  final List<String> suggestions;

  const SearchSuggestionsLoaded({required this.suggestions});

  @override
  List<Object> get props => [suggestions];
}

final class SearchSuggestionsNoConnection extends SearchSuggestionsState {
  const SearchSuggestionsNoConnection();
}

final class SearchSuggestionsFailed extends SearchSuggestionsState {
  final String message;

  const SearchSuggestionsFailed({required this.message});

  @override
  List<Object> get props => [message];
}
