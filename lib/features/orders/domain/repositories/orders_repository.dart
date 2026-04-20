import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/orders/domain/entities/order_details_entity.dart';
import 'package:tech_nest/features/orders/domain/entities/order_entity.dart';
import 'package:tech_nest/features/orders/domain/params/create_order_params.dart';

abstract class OrdersRepository {
  Future<Either<Failure, int>> createOrder({required CreateOrderParams params});
  Future<Either<Failure, List<OrderEntity>>> getUserOrders();
  Future<Either<Failure, OrderDetailsEntity>> getOrderDetails({
    required int orderId,
  });
  Future<Either<Failure, void>> cancelOrder({required int orderId});
}
