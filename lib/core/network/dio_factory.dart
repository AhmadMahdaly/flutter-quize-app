import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:smle/core/network/end_points.dart';

class DioFactory {
  static Dio dio = Dio();

  static Future<void> init() {
    final BaseOptions baseOptions = BaseOptions(
      baseUrl: EndPoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
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
  }
}
