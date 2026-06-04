import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/error/mappers/error_mapper.dart';
import 'package:tech_nest/core/utils/api_result.dart';
import 'package:tech_nest/features/orders/domain/entities/order_details_entity.dart';
import 'package:tech_nest/features/orders/domain/entities/order_entity.dart';
import 'package:tech_nest/features/orders/domain/params/create_order_params.dart';
import 'package:tech_nest/features/orders/domain/repositories/orders_repository.dart';

import '../datasources/remote/orders_remote_datasource.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDatasource _dataSource;

  OrdersRepositoryImpl(this._dataSource);

  @override
  Future<ApiResult<int>> createOrder({
    required CreateOrderParams params,
  }) async {
    try {
      final res = await _dataSource.createOrder(params: params);
      return ApiSuccess(res);
    } on AppException catch (e) {
      return ApiFailure(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return ApiFailure(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<List<OrderEntity>>> getUserOrders() async {
    try {
      final res = await _dataSource.getUserOrders();
      return ApiSuccess(res.map((e) => e.toEntity()).toList());
    } on AppException catch (e) {
      return ApiFailure(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return ApiFailure(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<OrderDetailsEntity>> getOrderDetails({
    required int orderId,
  }) async {
    try {
      final res = await _dataSource.getOrderDetails(orderId: orderId);
      return ApiSuccess(res.toEntity());
    } on AppException catch (e) {
      return ApiFailure(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return ApiFailure(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<void>> cancelOrder({required int orderId}) async {
    try {
      await _dataSource.cancelOrder(orderId: orderId);
      return const ApiSuccess(null);
    } on AppException catch (e) {
      return ApiFailure(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return ApiFailure(UnknownFailure());
    }
  }
}
