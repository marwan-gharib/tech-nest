part of 'get_product_cubit.dart';

sealed class GetProductState extends Equatable {
  const GetProductState();

  @override
  List<Object> get props => [];
}

final class GetProductInitial extends GetProductState {
  const GetProductInitial();
}

final class GetProductLoading extends GetProductState {
  const GetProductLoading();
}

final class GetProductLoaded extends GetProductState {
  final ProductEntity product;

  const GetProductLoaded(this.product);

  @override
  List<Object> get props => [product];
}

final class GetProductError extends GetProductState {
  final Failure failure;

  const GetProductError(this.failure);

  @override
  List<Object> get props => [failure];
}
