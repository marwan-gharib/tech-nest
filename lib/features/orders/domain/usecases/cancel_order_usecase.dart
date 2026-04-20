import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/orders/domain/repositories/orders_repository.dart';

class CancelOrderUseCase {
  final OrdersRepository repository;

  CancelOrderUseCase(this.repository);

  Future<Either<Failure, void>> call({required int orderId}) {
    return repository.cancelOrder(orderId: orderId);
  }
}
