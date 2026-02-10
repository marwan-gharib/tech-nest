import 'package:dio/dio.dart';
import 'package:tech_nest/core/errors/exceptions/exceptions.dart';

class DioExceptions {
  const DioExceptions._();

  static Never handle(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
        throw NetworkException();

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw ServerException("Request timeout");

      case DioExceptionType.cancel:
        throw ServerException("Request cancelled");

      case DioExceptionType.badCertificate:
        throw ServerException("Bad SSL certificate");

      case DioExceptionType.badResponse:
        _handleHttpError(e);

      case DioExceptionType.unknown:
        throw UnKnownException();
    }
  }

  static Never _handleHttpError(DioException e) {
    final statusCode = e.response?.statusCode;

    switch (statusCode) {
      case 401:
        throw UnAuthorizedException();

      case 403:
        throw ServerException("Forbidden");

      case 404:
        throw ServerException("Not found");

      case 400:
      case 422:
        throw ServerException("Bad request");

      case 500:
      case 502:
      case 503:
      case 504:
        throw ServerException("Server error");

      default:
        throw ServerException("Unhandled http error: $statusCode");
    }
  }
}
