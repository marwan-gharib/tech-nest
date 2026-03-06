part of 'add_product_to_cart_cubit.dart';

final class AddProductToCartState extends Equatable {
  final String message;
  final bool isLoading;
  final bool isSuccess;

  const AddProductToCartState({
    this.isSuccess = false,
    this.message = '',
    this.isLoading = false,
  });

  AddProductToCartState copyWith({
    String? message,
    bool? isLoading,
    bool? isSuccess,
  }) {
    return AddProductToCartState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [message, isLoading];
}
