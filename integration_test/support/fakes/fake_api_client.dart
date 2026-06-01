import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/error/exceptions/server_exception.dart';
import 'package:tech_nest/core/network/api_client.dart';

import '../fixtures/e2e_fixtures.dart';

class FakeApiClient implements ApiClient {
  static const user = {
    ApiKeys.id: 7,
    ApiKeys.name: 'E2E Customer',
    ApiKeys.email: 'customer@technest.test',
    ApiKeys.image: null,
  };

  final List<Map<String, dynamic>> cartItems = [];
  int loginCalls = 0;
  int logoutCalls = 0;
  int createOrderCalls = 0;
  int _nextCartId = 100;

  void reset() {
    cartItems.clear();
    loginCalls = 0;
    logoutCalls = 0;
    createOrderCalls = 0;
    _nextCartId = 100;
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
  }) async {
    if (path == Endpoints.productsList) {
      return {
        ApiKeys.data: {ApiKeys.products: products},
      };
    }
    if (path == Endpoints.getProductById) {
      final id = int.parse(queryParameters?[ApiKeys.id].toString() ?? '1');
      return {
        ApiKeys.data: {
          ApiKeys.product: products.firstWhere((p) => p[ApiKeys.id] == id),
        },
      };
    }
    if (path == Endpoints.searchingSuggestions) {
      return {
        ApiKeys.data: ['Aurora Laptop', 'Pulse Headphones'],
      };
    }
    if (path == Endpoints.cartList) {
      return {ApiKeys.data: _cartData()};
    }
    if (path == Endpoints.categoriesList) {
      return {ApiKeys.data: categories};
    }
    if (path == Endpoints.listOrders) {
      return {
        ApiKeys.data: {ApiKeys.orders: orders},
      };
    }
    if (path == Endpoints.orderDetails) {
      final id = int.parse(queryParameters?['id'].toString() ?? '9001');
      return {
        ApiKeys.data: {ApiKeys.order: orderDetails(id)},
      };
    }
    if (path == Endpoints.listNotifications) {
      return {
        ApiKeys.data: {ApiKeys.notifications: notifications},
      };
    }
    throw ServerException('Unhandled GET $path');
  }

  @override
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
    bool isFormData = false,
  }) async {
    if (path == Endpoints.login) {
      loginCalls++;
      return {
        ApiKeys.status: 200,
        ApiKeys.data: {ApiKeys.token: 'e2e-token', ApiKeys.user: user},
      };
    }
    if (path == Endpoints.logout) {
      logoutCalls++;
      return {ApiKeys.status: 200};
    }
    if (path == Endpoints.addToCart) {
      final productId = int.parse(data?[ApiKeys.productId].toString() ?? '1');
      final quantity = int.parse(data?[ApiKeys.quantity].toString() ?? '1');
      final product = products.firstWhere((p) => p[ApiKeys.id] == productId);
      Map<String, dynamic>? existing;
      for (final item in cartItems) {
        if (item[ApiKeys.product][ApiKeys.id] == productId) {
          existing = item;
          break;
        }
      }
      if (existing != null) {
        existing[ApiKeys.quantity] = quantity;
        return {ApiKeys.data: existing};
      }
      final item = {
        ApiKeys.id: _nextCartId++,
        ApiKeys.quantity: quantity,
        ApiKeys.product: product,
      };
      cartItems.add(item);
      return {ApiKeys.data: item};
    }
    if (path == Endpoints.createOrder) {
      createOrderCalls++;
      return {
        ApiKeys.data: {ApiKeys.orderId: 9002},
      };
    }
    if (path == Endpoints.markNotificationAsRead ||
        path == Endpoints.saveFCMToken ||
        path == Endpoints.forgetPassword ||
        path == Endpoints.resetPassword) {
      return {ApiKeys.status: 200};
    }
    throw ServerException('Unhandled POST $path');
  }

  @override
  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
    bool isFormData = false,
  }) async {
    if (path == Endpoints.updateItemQuantityFromCart) {
      final id = int.parse(data?[ApiKeys.id].toString() ?? '-1');
      final quantity = int.parse(data?[ApiKeys.quantity].toString() ?? '1');
      final item = cartItems.firstWhere((item) => item[ApiKeys.id] == id);
      item[ApiKeys.quantity] = quantity;
      return {
        ApiKeys.data: {ApiKeys.quantity: quantity},
      };
    }
    throw ServerException('Unhandled PATCH $path');
  }

  @override
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extra,
  }) async {
    if (path == Endpoints.removeFromCart) {
      final id = int.parse(data?[ApiKeys.id].toString() ?? '-1');
      cartItems.removeWhere((item) => item[ApiKeys.id] == id);
      return {
        ApiKeys.data: {ApiKeys.id: id},
      };
    }
    if (path == Endpoints.cancelOrder) {
      return {ApiKeys.status: 200};
    }
    throw ServerException('Unhandled DELETE $path');
  }

  Map<String, dynamic> _cartData() {
    final totalQuantity = cartItems.fold<int>(
      0,
      (sum, item) => sum + (item[ApiKeys.quantity] as int),
    );
    final totalPrice = cartItems.fold<int>(
      0,
      (sum, item) =>
          sum +
          ((item[ApiKeys.product][ApiKeys.price] as num).toInt() *
              (item[ApiKeys.quantity] as int)),
    );
    final deliveryCharges = totalPrice == 0 || totalPrice >= 2000 ? 0 : 50;
    return {
      ApiKeys.items: cartItems,
      ApiKeys.totalQuantity: totalQuantity,
      ApiKeys.totalPrice: totalPrice,
      ApiKeys.deliveryCharges: deliveryCharges,
      ApiKeys.grandTotal: totalPrice + deliveryCharges,
    };
  }
}
