import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_entity.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repository.dart';

class ClearCartUseCase {
  final CartRepository _repository;

  ClearCartUseCase(this._repository);

  Future<ApiResult<Cart>> call() {
    return _repository.clearCart();
  }
}
