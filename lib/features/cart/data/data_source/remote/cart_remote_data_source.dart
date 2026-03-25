import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/domain/params/add_to_cart_params.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/cart/data/models/cart_item_model.dart';
import 'package:tech_nest/features/cart/data/models/cart_model.dart';
import 'package:tech_nest/features/cart/domain/params/update_item_quantity_params.dart';

class CartRemoteDataSource {
  final ApiConsumer _api;

  CartRemoteDataSource(this._api);

  Future<CartItemModel> addToCart({required AddToCartParams params}) async {
    try {
      final response = await _api.post(
        Endpoints.addToCart,
        data: params.toJson(),
      );

      if (response != null) {
        return CartItemModel.fromJson(
          response[ApiKeys.data] as Map<String, dynamic>,
        );
      }

      throw UnKnownException();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnKnownException();
    }
  }

  Future<CartModel> getCartItems() async {
    try {
      final response = await _api.get(Endpoints.cartList);

      if (response[ApiKeys.data] != null) {
        return CartModel.fromJson(
          response[ApiKeys.data] as Map<String, dynamic>,
        );
      }

      throw UnKnownException();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnKnownException();
    }
  }

  Future<int> removeFromCart({required int cartId}) async {
    try {
      final response = await _api.delete(
        Endpoints.removeFromCart,
        data: {ApiKeys.id: cartId},
      );

      if (response[ApiKeys.data] != null) {
        return int.parse(response[ApiKeys.data][ApiKeys.id].toString());
      }

      throw UnKnownException();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnKnownException();
    }
  }

  Future<int> updateItemQuantity({
    required UpdateItemQuantityParams params,
  }) async {
    try {
      final response = await _api.patch(
        Endpoints.updateItemQuantityFromCart,
        data: params.toJson(),
      );

      if (response[ApiKeys.data] != null) {
        return int.parse(response[ApiKeys.data][ApiKeys.quantity].toString());
      }

      throw UnKnownException();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnKnownException();
    }
  }
}
