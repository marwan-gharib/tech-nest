import 'package:dio/dio.dart';
import 'package:tech_nest/core/errors/exceptions/server_exception.dart';
import 'package:tech_nest/core/errors/models/error_model.dart';

class DioExceptions {
  const DioExceptions._();

  static void handlingDioExceptions(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
      case DioExceptionType.badResponse:
        throw ServerException(errModel: ErrorModel.fromJson(e.response!.data));
    }
  }
}
