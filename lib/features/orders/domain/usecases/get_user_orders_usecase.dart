import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/shared/domain/repositories/orders_shared_repository.dart';
import 'package:tech_nest/features/orders/domain/entities/order_entity.dart';

class GetUserOrdersUseCase {
  final OrdersSharedRepository _repository;

  GetUserOrdersUseCase(this._repository);

  Future<Either<Failure, List<OrderEntity>>> call() {
    return _repository.getUserOrders();
  }
}
