import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/orders/domain/entities/order_entity.dart';
import 'package:tech_nest/features/orders/domain/repositories/orders_repository.dart';

class GetUserOrdersUseCase {
  final OrdersRepository _repository;

  GetUserOrdersUseCase(this._repository);

  Future<ApiResult<List<OrderEntity>>> call() {
    return _repository.getUserOrders();
  }
}
