import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/orders/domain/repositories/orders_repository.dart';

class CancelOrderUseCase {
  final OrdersRepository repository;

  CancelOrderUseCase(this.repository);

  Future<ApiResult<void>> call({required int orderId}) {
    return repository.cancelOrder(orderId: orderId);
  }
}
