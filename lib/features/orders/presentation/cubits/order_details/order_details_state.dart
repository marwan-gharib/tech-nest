import 'package:equatable/equatable.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/orders/domain/entities/order_details_entity.dart';

sealed class OrderDetailsState extends Equatable {
  const OrderDetailsState();

  @override
  List<Object?> get props => [];
}

class OrderDetailsInitial extends OrderDetailsState {
  const OrderDetailsInitial();
}

class OrderDetailsLoading extends OrderDetailsState {
  const OrderDetailsLoading();
}

class OrderDetailsLoaded extends OrderDetailsState {
  final OrderDetailsEntity order;
  final bool isCancelling;
  final Failure? cancelFailure;
  final bool isCancelledSuccessfully;

  const OrderDetailsLoaded({
    required this.order,
    this.isCancelling = false,
    this.cancelFailure,
    this.isCancelledSuccessfully = false,
  });

  OrderDetailsLoaded copyWith({
    OrderDetailsEntity? order,
    bool? isCancelling,
    Failure? cancelFailure,
    bool? isCancelledSuccessfully,
  }) {
    return OrderDetailsLoaded(
      order: order ?? this.order,
      isCancelling: isCancelling ?? this.isCancelling,
      cancelFailure: cancelFailure,
      isCancelledSuccessfully:
          isCancelledSuccessfully ?? this.isCancelledSuccessfully,
    );
  }

  // Helper method to explicitly clear the failure if needed
  OrderDetailsLoaded clearFailure() {
    return OrderDetailsLoaded(
      order: order,
      isCancelling: isCancelling,
      cancelFailure: null,
      isCancelledSuccessfully: isCancelledSuccessfully,
    );
  }

  @override
  List<Object?> get props => [
    order,
    isCancelling,
    cancelFailure,
    isCancelledSuccessfully,
  ];
}

class OrderDetailsFailed extends OrderDetailsState {
  final Failure failure;

  const OrderDetailsFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}
