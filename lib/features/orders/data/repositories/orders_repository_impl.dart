import 'package:fpdart/fpdart.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/core/error/failures/unknown_failure.dart';
import 'package:tech_nest/core/error/mappers/error_mapper.dart';
import 'package:tech_nest/features/orders/domain/entities/order_details_entity.dart';
import 'package:tech_nest/features/orders/domain/entities/order_entity.dart';
import 'package:tech_nest/features/orders/domain/params/create_order_params.dart';
import 'package:tech_nest/features/orders/domain/repositories/orders_repository.dart';

import '../datasources/remote/orders_remote_datasource.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDatasource _dataSource;

  OrdersRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, int>> createOrder({
    required CreateOrderParams params,
  }) async {
    try {
      final res = await _dataSource.createOrder(params: params);
      return Right(res);
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getUserOrders() async {
    try {
      final res = await _dataSource.getUserOrders();
      return Right(res.map((e) => e.toEntity()).toList());
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, OrderDetailsEntity>> getOrderDetails({
    required int orderId,
  }) async {
    try {
      final res = await _dataSource.getOrderDetails(orderId: orderId);
      return Right(res.toEntity());
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> cancelOrder({required int orderId}) async {
    try {
      await _dataSource.cancelOrder(orderId: orderId);
      return const Right(null);
    } on AppException catch (e) {
      return Left(ErrorMapper.mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}
