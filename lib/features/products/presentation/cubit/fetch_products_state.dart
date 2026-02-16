part of 'fetch_products_cubit.dart';

sealed class FetchProductsState extends Equatable {
  const FetchProductsState();

  @override
  List<Object> get props => [];
}

final class FetchProductsInitial extends FetchProductsState {
  const FetchProductsInitial();
}

final class FetchProductsLoading extends FetchProductsState {
  const FetchProductsLoading();
}

final class FetchProductsSuccess extends FetchProductsState {
  final List<ProductEntity> products;
  const FetchProductsSuccess({required this.products});

  @override
  List<Object> get props => [products];
}

final class FetchProductsFailed extends FetchProductsState {
  final String message;
  const FetchProductsFailed({required this.message});

  @override
  List<Object> get props => [message];
}
