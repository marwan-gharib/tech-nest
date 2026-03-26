import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/cart/domain/params/update_item_quantity_params.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repo.dart';

class UpdateItemQuantityUsecase {
  final CartRepo _repo;

  UpdateItemQuantityUsecase(this._repo);

  Future<Either<Failure, int>> call({
    required UpdateItemQuantityParams params,
  }) async {
    return await _repo.updateItemQuantity(params: params);
  }
}
