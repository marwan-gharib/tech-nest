import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/orders/domain/entities/order_details_entity.dart';
import 'package:tech_nest/features/orders/domain/entities/order_entity.dart';
import 'package:tech_nest/features/orders/domain/params/create_order_params.dart';

abstract class OrdersRepository {
  Future<ApiResult<int>> createOrder({required CreateOrderParams params});
  Future<ApiResult<List<OrderEntity>>> getUserOrders();
  Future<ApiResult<OrderDetailsEntity>> getOrderDetails({
    required int orderId,
  });
  Future<ApiResult<void>> cancelOrder({required int orderId});
}
