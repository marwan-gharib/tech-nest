import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/error/mappers/error_mapper.dart';
import 'package:tech_nest/features/cart/data/datasources/remote/cart_remote_data_source.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_entity.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item_entity.dart';
import 'package:tech_nest/features/cart/domain/params/add_to_cart_params.dart';
import 'package:tech_nest/features/cart/domain/params/update_item_quantity_params.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDatasource _dataSource;

  CartRepositoryImpl(this._dataSource);

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

  @override
  Future<Either<Failure, Cart>> clearCart() async {
    try {
      return Right(
        Cart(
          items: [],
          totalQuantity: 0,
          totalPrice: 0,
          deliveryCharges: 0,
          grandTotal: 0,
        ),
      );
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}
