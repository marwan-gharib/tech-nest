import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/errors/exceptions/exceptions.dart';
import 'package:tech_nest/core/services/remote/api_service/api_consumer.dart';
import 'package:tech_nest/features/cart/data/models/cart_model.dart';
import 'package:tech_nest/features/cart/domain/params/add_to_cart_params.dart';

class CartRemoteDataSource {
  final ApiConsumer _api;

  CartRemoteDataSource(this._api);

  Future<void> addToCart({required AddToCartParams params}) async {
    try {
      await _api.post(Endpoints.addToCart, data: params.toJson());
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnKnownException();
    }
  }

  Future<List<CartModel>> getCartItems() async {
    try {
      final response = await _api.get(Endpoints.cartList);

      if (response != null) {
        final list = response[ApiKeys.data] as List?;
        if (list == null || list.isEmpty) {
          return [];
        }
        return list.map((e) => CartModel.fromJson(e)).toList();
      }

      throw UnKnownException();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnKnownException();
    }
  }

  Future<void> removeFromCart({required int cartId}) async {
    try {
      await _api.post(Endpoints.removeFromCart, data: {ApiKeys.id: cartId});
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnKnownException();
    }
  }
}
