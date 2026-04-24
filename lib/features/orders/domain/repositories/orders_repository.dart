import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/orders/domain/entities/order_details_entity.dart';
import 'package:tech_nest/features/orders/domain/entities/order_entity.dart';
import 'package:tech_nest/features/orders/domain/params/create_order_params.dart';

import 'package:tech_nest/core/shared/domain/repositories/orders_shared_repository.dart';

abstract class OrdersRepository extends OrdersSharedRepository {
  Future<Either<Failure, int>> createOrder({required CreateOrderParams params});
  @override
  Future<Either<Failure, List<OrderEntity>>> getUserOrders();
  Future<Either<Failure, OrderDetailsEntity>> getOrderDetails({
    required int orderId,
  });
  Future<Either<Failure, void>> cancelOrder({required int orderId});
}
