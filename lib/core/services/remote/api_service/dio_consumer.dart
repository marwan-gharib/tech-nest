import 'package:dio/dio.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/di/injection_container.dart';
import 'package:tech_nest/core/errors/exceptions/exceptions.dart';
import 'package:tech_nest/core/errors/handling_errors/dio_exceptions.dart';
import 'package:tech_nest/core/services/remote/api_service/api_consumer.dart';
import 'package:tech_nest/core/services/remote/api_service/dio_interceptor.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer(this.dio) {
    dio.options.baseUrl = "${Endpoints.baseUrl}api/user/";
    dio.interceptors.add(sl<DioInterceptor>());
    dio.interceptors.add(sl<LogInterceptor>());
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
