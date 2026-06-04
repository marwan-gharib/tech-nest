import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/cart/domain/params/update_item_quantity_params.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repository.dart';

class UpdateItemQuantityUsecase {
  final CartRepository _repo;

  UpdateItemQuantityUsecase(this._repo);

  Future<ApiResult<int>> call({
    required UpdateItemQuantityParams params,
  }) async {
    return await _repo.updateItemQuantity(params: params);
  }
}
