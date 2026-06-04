import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCartUsecase {
  final CartRepository _repo;

  RemoveFromCartUsecase(this._repo);

  Future<ApiResult<int>> call({required int cartId}) async {
    return await _repo.removeFromCart(cartId: cartId);
  }
}
