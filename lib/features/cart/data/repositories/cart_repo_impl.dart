import 'package:tech_nest/core/params/add_to_cart_params.dart';
import 'package:tech_nest/features/cart/data/data_source/remote/cart_remote_data_source.dart';
import 'package:tech_nest/features/cart/domain/entities/cart.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item.dart';
import 'package:tech_nest/features/cart/domain/params/update_item_quantity_params.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repo.dart';

class CartRepoImpl extends CartRepo {
  final CartRemoteDataSource _dataSource;

  CartRepoImpl(this._dataSource);

  @override
  Future<CartItem> addToCart({required AddToCartParams params}) async {
    final model = await _dataSource.addToCart(params: params);

    return model.toEntity();
  }

  @override
  Future<Cart> getCartItems() async {
    final model = await _dataSource.getCartItems();

    return model.toEntity();
  }

  @override
  Future<int> removeFromCart({required int cartId}) async {
    return await _dataSource.removeFromCart(cartId: cartId);
  }

  @override
  Future<int> updateItemQuantity({
    required UpdateItemQuantityParams params,
  }) async {
    return await _dataSource.updateItemQuantity(params: params);
  }
}
