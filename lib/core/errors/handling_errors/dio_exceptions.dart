import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tech_nest/core/constants/api_keys.dart';
import 'package:tech_nest/core/di/injection_container.dart';
import 'package:tech_nest/core/errors/exceptions/exceptions.dart';
import 'package:tech_nest/core/services/local/cache/cache_service.dart';

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
    final responseData = e.response?.data;
    String? errorMessage;

    if (responseData != null) {
      if (responseData is Map<String, dynamic>) {
        errorMessage = responseData['message'];
      } else if (responseData is String) {
        try {
          final decoded = json.decode(responseData);
          if (decoded is Map<String, dynamic>) {
            errorMessage = decoded['message'];
          }
        } catch (_) {}
      }
    }

    switch (statusCode) {
      case 401:
        if (sl<CacheService>().containsKey(ApiKeys.token)) {
          throw UnAuthorizedException();
        }
        throw ServerException(
          errorMessage ?? "Your session has expired. Please log in again.",
          activeToUser: true,
        );

      case 400:
        throw ServerException(
          errorMessage ?? "Invalid request. Please check your input.",
          activeToUser: true,
        );

      case 403:
        throw ServerException(
          errorMessage ?? "You don't have permission to perform this action.",
          activeToUser: true,
        );

      case 404:
        throw ServerException(
          errorMessage ?? "Requested resource was not found.",
          activeToUser: true,
        );

      case 409:
        throw ServerException(
          errorMessage ?? "This data already exists.",
          activeToUser: true,
        );

      case 422:
        throw ServerException(
          errorMessage ?? "Invalid data provided.",
          activeToUser: true,
        );

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
