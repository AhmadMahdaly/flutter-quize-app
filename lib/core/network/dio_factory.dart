import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/cache_helper/cache_values.dart';
import 'package:smle/core/network/end_points.dart';

class DioFactory {
  static Dio dio = Dio();

  static Future<void> init() {
    final BaseOptions baseOptions = BaseOptions(
      baseUrl: EndPoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      receiveDataWhenStatusError: true,
      validateStatus: (status) => true,
    );

    dio = Dio(baseOptions);
    addDioInterceptor();
    return Future.value();
  }

  Future<Response?> get({required String endPoint, data}) async {
    return await dio.get(endPoint, queryParameters: data);
  }

  Future<Response?> post({required String endPoint, data}) async {
    return await dio.post(endPoint, data: data);
  }

  static void addDioInterceptor() {
    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // final token = await CacheHelper.getData(key: CacheKeys.userToken);
          final token = '158|hTfRe3Opk0SFpeOrgUONy6xAOyMXwz98XUY8sx3rd5d5fa1a';
          options.headers['Authorization'] = 'Bearer $token';
          options.headers['Accept'] = 'application/json';
          return handler.next(options);
        },
      ),
    );
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        retries: 3,
        retryDelay: const Duration(seconds: 2),
      ),
    );
  }
}

class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.retries = 4,
    this.retryDelay = const Duration(seconds: 2),
  });

  final Dio dio;
  final int retries;
  final Duration retryDelay;

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final requestOptions = err.requestOptions;

      if (requestOptions.extra['retryCount'] == null) {
        requestOptions.extra['retryCount'] = 0;
      }

      final retryCount = requestOptions.extra['retryCount'] as int;

      if (retryCount < retries) {
        requestOptions.extra['retryCount'] = retryCount + 1;

        await Future.delayed(retryDelay);

        try {
          final response = await dio.fetch(requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}
