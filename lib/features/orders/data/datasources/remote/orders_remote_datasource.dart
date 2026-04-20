import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/network/api_client.dart';
import 'package:tech_nest/features/orders/data/models/order_details_model.dart';
import 'package:tech_nest/features/orders/data/models/order_model.dart';
import 'package:tech_nest/features/orders/domain/params/create_order_params.dart';

class OrdersRemoteDatasource {
  final ApiClient _apiClient;

  OrdersRemoteDatasource(this._apiClient);

  Future<int> createOrder({required CreateOrderParams params}) async {
    try {
      final response = await _apiClient.post(
        Endpoints.createOrder,
        data: params.toJson(),
      );

      if (response != null && response[ApiKeys.data] != null) {
        final orderId = response[ApiKeys.data][ApiKeys.orderId];
        if (orderId != null) {
          return int.parse(orderId.toString());
        }
      }
      throw UnKnownException();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnKnownException();
    }
  }

  Future<List<OrderModel>> getUserOrders() async {
    try {
      final response = await _apiClient.get(Endpoints.listOrders);
      if (response != null && response[ApiKeys.data] != null) {
        final ordersData = response[ApiKeys.data][ApiKeys.orders];
        if (ordersData is List) {
          return ordersData
              .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      throw UnKnownException();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnKnownException();
    }
  }

  Future<OrderDetailsModel> getOrderDetails({required int orderId}) async {
    try {
      final response = await _apiClient.get(
        Endpoints.orderDetails,
        queryParameters: {"id": orderId},
      );
      if (response != null && response[ApiKeys.data] != null) {
        final orderData = response[ApiKeys.data][ApiKeys.order];
        if (orderData != null) {
          return OrderDetailsModel.fromJson(orderData as Map<String, dynamic>);
        }
      }
      throw UnKnownException();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnKnownException();
    }
  }

  Future<void> cancelOrder({required int orderId}) async {
    try {
      await _apiClient.delete(
        Endpoints.cancelOrder,
        queryParameters: {"id": orderId},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnKnownException();
    }
  }
}
