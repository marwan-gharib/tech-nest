import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/orders/domain/entities/order_entity.dart';
import 'package:tech_nest/features/orders/domain/repositories/orders_repository.dart';

class GetUserOrdersUseCase {
  final OrdersRepository _repository;

  GetUserOrdersUseCase(this._repository);

  Future<Either<Failure, List<OrderEntity>>> call() {
    return _repository.getUserOrders();
  }
}
