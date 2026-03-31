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

  bool get isEmpty => suggestions.isEmpty;

  @override
  List<Object> get props => [suggestions];
}

final class SearchSuggestionsEmpty extends SearchSuggestionsState {
  final String query;

  const SearchSuggestionsEmpty({required this.query});

  @override
  List<Object> get props => [query];
}

final class SearchSuggestionsFailed extends SearchSuggestionsState {
  final Failure failure;

  const SearchSuggestionsFailed({required this.failure});

  @override
  List<Object> get props => [failure];
}
