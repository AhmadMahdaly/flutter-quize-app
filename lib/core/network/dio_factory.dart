import 'dart:async';
import 'dart:io';

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

  // تم تعديل المسميات لتكون أوضح (queryParameters للـ GET)
  Future<Response?> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.get(endPoint, queryParameters: queryParameters);
  }

  Future<Response?> post({required String endPoint, dynamic data}) async {
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
          final token = await CacheHelper.getData(key: CacheKeys.userToken);
          // final token = '158|hTfRe3Opk0SFpeOrgUONy6xAOyMXwz98XUY8sx3rd5d5fa1a';
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
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
    this.retries =
        3, // تم توحيد عدد المحاولات مع ما يتم تمريره من الـ DioFactory
    this.retryDelay = const Duration(seconds: 2),
  });

  final Dio dio;
  final int retries;
  final Duration retryDelay;

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final requestOptions = err.requestOptions;

      // تهيئة العداد إذا لم يكن موجوداً
      int retryCount = requestOptions.extra['retryCount'] ?? 0;

      if (retryCount < retries) {
        retryCount++;
        requestOptions.extra['retryCount'] = retryCount;

        // الانتظار قبل المحاولة الجديدة
        await Future.delayed(retryDelay);

        try {
          // إعادة إرسال الطلب
          final response = await dio.fetch(requestOptions);
          return handler.resolve(response);
        } on DioException catch (e) {
          // إذا فشلت المحاولة الجديدة، نمرر الخطأ الجديد للمحاولة التالية
          return handler.next(e);
        } catch (e) {
          return handler.next(err);
        }
      }
    }

    // إذا استنفدنا عدد المحاولات أو كان الخطأ لا يستدعي الإعادة، نمرر الخطأ الأصلي
    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        // إضافة هذا السطر لالتقاط أخطاء الـ Unknown الناتجة عن انقطاع النت (SocketException)
        err.type == DioExceptionType.unknown ||
        (err.error is SocketException);
  }
}
