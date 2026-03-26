import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/domain/params/add_to_cart_params.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/error/mappers/error_mapper.dart';
import 'package:tech_nest/features/cart/data/data_source/remote/cart_remote_data_source.dart';
import 'package:tech_nest/features/cart/domain/entities/cart.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item.dart';
import 'package:tech_nest/features/cart/domain/params/update_item_quantity_params.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repo.dart';

class CartRepoImpl extends CartRepo {
  final CartRemoteDataSource _dataSource;

  CartRepoImpl(this._dataSource);

  @override
  Future<Either<Failure, CartItem>> addToCart({
    required AddToCartParams params,
  }) async {
    try {
      final model = await _dataSource.addToCart(params: params);
      return Right(model.toEntity());
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Cart>> getCartItems() async {
    try {
      final model = await _dataSource.getCartItems();
      return Right(model.toEntity());
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, int>> removeFromCart({required int cartId}) async {
    try {
      final res = await _dataSource.removeFromCart(cartId: cartId);
      return Right(res);
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, int>> updateItemQuantity({
    required UpdateItemQuantityParams params,
  }) async {
    try {
      final res = await _dataSource.updateItemQuantity(params: params);
      return Right(res);
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}
