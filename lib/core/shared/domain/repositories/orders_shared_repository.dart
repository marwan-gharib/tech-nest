import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/orders/domain/entities/order_entity.dart';

abstract class OrdersSharedRepository {
  Future<Either<Failure, List<OrderEntity>>> getUserOrders();
}
