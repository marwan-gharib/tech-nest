import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/orders/domain/entities/order_details_entity.dart';
import 'package:tech_nest/features/orders/domain/repositories/orders_repository.dart';

class GetOrderDetailsUseCase {
  final OrdersRepository repository;

  GetOrderDetailsUseCase(this.repository);

  Future<ApiResult<OrderDetailsEntity>> call({required int orderId}) {
    return repository.getOrderDetails(orderId: orderId);
  }
}
