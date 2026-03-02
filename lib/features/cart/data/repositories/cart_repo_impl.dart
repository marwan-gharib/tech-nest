import 'package:tech_nest/features/cart/data/data_source/remote/cart_remote_data_source.dart';
import 'package:tech_nest/features/cart/domain/entities/cart_item.dart';
import 'package:tech_nest/features/cart/domain/params/add_to_cart_params.dart';
import 'package:tech_nest/features/cart/domain/repositories/cart_repo.dart';

class CartRepoImpl extends CartRepo {
  final CartRemoteDataSource _dataSource;

  CartRepoImpl(this._dataSource);

  @override
  Future<void> addToCart({required AddToCartParams params}) async {
    await _dataSource.addToCart(params: params);
  }

  @override
  Future<List<CartItem>> getCartItems() async {
    final models = await _dataSource.getCartItems();

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> removeFromCart({required int cartId}) async {
    await _dataSource.removeFromCart(cartId: cartId);
  }
}
