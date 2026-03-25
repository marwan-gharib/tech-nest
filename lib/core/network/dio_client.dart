import 'package:dio/dio.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/error/exceptions/exceptions.dart';
import 'package:tech_nest/core/error/handling/dio_error_handler.dart';
import 'package:tech_nest/core/network/api_client.dart';

class DioClient extends ApiClient {
  final Dio dio;

  DioClient({
    required this.dio,
    required Interceptor authInterceptor,
    required Interceptor errorInterceptor,
    required Interceptor loggingInterceptor,
  }) {
    dio.options.baseUrl = "${Endpoints.baseUrl}api/user/";
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);
    dio.interceptors.add(authInterceptor);
    dio.interceptors.add(errorInterceptor);
    dio.interceptors.add(loggingInterceptor);
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return response.data;
    } on DioException catch (e) {
      DioExceptions.handle(e);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw Exception("Something went wrong. Please try again.");
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? data,
    bool isFormData = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: isFormData ? FormData.fromMap(data!) : data,
        queryParameters: queryParameters,
        options: options,
      );

      return response.data;
    } on DioException catch (e) {
      DioExceptions.handle(e);
    } catch (e) {
      throw Exception("Something went wrong. Please try again.");
    }
  }

  @override
  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? data,
    bool isFormData = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: isFormData ? FormData.fromMap(data!) : data,
        queryParameters: queryParameters,
        options: options,
      );

      return response.data;
    } on DioException catch (e) {
      DioExceptions.handle(e);
    } catch (e) {
      throw Exception("Something went wrong. Please try again.");
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return response.data;
    } on DioException catch (e) {
      DioExceptions.handle(e);
    } catch (e) {
      throw Exception("Something went wrong. Please try again.");
    }
  }
}
