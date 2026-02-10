import 'package:dio/dio.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/errors/handling_errors/dio_exceptions.dart';
import 'package:tech_nest/core/services/remote/api_consumer.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer(this.dio) {
    dio.options.baseUrl = Endpoints.baseUrl;
    dio.interceptors.add(
      LogInterceptor(
        error: true,
        request: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(path, data: data, queryParameters: queryParameters);

      return response.data;
    } on DioException catch (e) {
      DioExceptions.handlingDioExceptions(e);
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? data,
    bool isFormData = false,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: isFormData ? FormData.fromMap(data!) : data,
        queryParameters: queryParameters,
      );

      return response.data;
    } on DioException catch (e) {
      DioExceptions.handlingDioExceptions(e);
    }
  }

  @override
  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? data,
    bool isFormData = false,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: isFormData ? FormData.fromMap(data!) : data,
        queryParameters: queryParameters,
      );

      return response.data;
    } on DioException catch (e) {
      DioExceptions.handlingDioExceptions(e);
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.delete(path, data: data, queryParameters: queryParameters);

      return response.data;
    } on DioException catch (e) {
      DioExceptions.handlingDioExceptions(e);
    }
  }
}
