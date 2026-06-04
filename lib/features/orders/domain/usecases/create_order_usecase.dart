import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/orders/domain/params/create_order_params.dart';
import 'package:tech_nest/features/orders/domain/repositories/orders_repository.dart';

class CreateOrderUseCase {
  final OrdersRepository repository;

  CreateOrderUseCase(this.repository);

  Future<ApiResult<int>> call({required CreateOrderParams params}) {
    return repository.createOrder(params: params);
  }
}
