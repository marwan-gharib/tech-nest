part of 'fetch_categories_cubit.dart';

sealed class FetchCategoriesState extends Equatable {
  const FetchCategoriesState();

  @override
  List<Object> get props => [];
}

final class FetchCategoriesInitial extends FetchCategoriesState {
  const FetchCategoriesInitial();
}

final class FetchCategoriesLoading extends FetchCategoriesState {
  const FetchCategoriesLoading();
}

final class FetchCategoriesLoaded extends FetchCategoriesState {
  final List<Category> categories;

  const FetchCategoriesLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

final class FetchCategoriesFailed extends FetchCategoriesState {
  final String message;

  const FetchCategoriesFailed({required this.message});

  @override
  List<Object> get props => [message];
}
