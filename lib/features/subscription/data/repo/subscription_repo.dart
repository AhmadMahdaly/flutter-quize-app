import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/features/subscription/data/model/packages_model.dart';

class SubscriptionRepository {
  SubscriptionRepository(this._dioFactory) {
    _paymobDio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    addDioInterceptor();
  }
  final DioFactory _dioFactory;

  Future<ApiResult<PackagesModel>> getPackages() async {
    final response = await _dioFactory.get(endPoint: EndPoints.getPackages);
    if (response!.statusCode == 200) {
      final PackagesModel model = PackagesModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      return ApiResult.failure(
        ServerFailure.fromResponse(
          response.statusCode,
          response.data['message'],
        ),
      );
    }
  }

  final String apiKey =
      'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRJNE9UVXNJbTVoYldVaU9pSXhOell5TXpNNU1Ea3hMakEwTkRjM05DSjkudDd0X2swWW11d3ZBWjdCWlNQeEItZDBiQ1F2QlBCbHU0Y1ZLMUFNZUN4eXZ4WTBCOVN4ZlVzZkNFdjh3TmJVNEdNQWJwUHVqZG83U1N5ZjN0OTk0YUE=';

  final int cardIntegrationId = 17875;
  final iframeId = 11205;

  // ✅ الـ URLs الصحيحة لـ PayMob السعودية
  final String _authUrl = 'https://ksa.paymob.com/api/auth/tokens';
  final String _orderUrl = 'https://ksa.paymob.com/api/ecommerce/orders';
  final String _paymentKeyUrl =
      'https://ksa.paymob.com/api/acceptance/payment_keys';
  String get _iframeUrl =>
      'https://ksa.paymob.com/api/acceptance/iframes/$iframeId?payment_token=';

  late final Dio _paymobDio;

  void addDioInterceptor() {
    _paymobDio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
  }

  Future<ApiResult<String>> getPaymentKeyFromApp(int amountCents) async {
    try {
      // Step 1: Get Auth Token
      final authRes = await _paymobDio.post(
        _authUrl,
        data: {'api_key': apiKey},
      );

      if (authRes.statusCode != 201) {
        return ApiResult.failure(ServerFailure('فشل في الحصول على Auth Token'));
      }

      final String authToken = authRes.data['token'];

      // Step 2: Create Order
      final orderRes = await _paymobDio.post(
        _orderUrl,
        data: {
          'auth_token': authToken,
          'delivery_needed': 'false',
          'amount_cents': amountCents.toString(),
          'currency': 'SAR',
          'items': [],
        },
      );

      if (orderRes.statusCode != 201) {
        return ApiResult.failure(ServerFailure('فشل في إنشاء الطلب'));
      }

      final int orderId = orderRes.data['id'];

      // Step 3: Get Payment Key
      final keyRes = await _paymobDio.post(
        _paymentKeyUrl,
        data: {
          'auth_token': authToken,
          'amount_cents': amountCents.toString(),
          'expiration': 3600,
          'order_id': orderId.toString(),
          'billing_data': {
            'apartment': 'NA',
            'email': 'customer@example.com',
            'floor': 'NA',
            'first_name': 'Test',
            'street': 'NA',
            'building': 'NA',
            'phone_number': '+966500000000',
            'shipping_method': 'NA',
            'postal_code': 'NA',
            'city': 'Riyadh',
            'country': 'SA',
            'last_name': 'User',
            'state': 'NA',
          },
          'currency': 'SAR',
          'integration_id': cardIntegrationId,
          'lock_order_when_paid': 'false',
        },
      );

      if (keyRes.statusCode != 201) {
        return ApiResult.failure(
          ServerFailure('فشل في الحصول على Payment Key'),
        );
      }

      final String paymentToken = keyRes.data['token'];

      // Return the full iframe URL with payment token
      return ApiResult.success('$_iframeUrl$paymentToken');
    } on DioException catch (e) {
      String errorMessage = 'حدث خطأ في الدفع';

      if (e.response != null) {
        errorMessage =
            e.response?.data['message'] ??
            e.response?.data['detail'] ??
            'خطأ في الاتصال بخدمة الدفع';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'انتهت مهلة الاتصال';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'انتهت مهلة استقبال البيانات';
      }

      return ApiResult.failure(ServerFailure(errorMessage));
    } catch (e) {
      return ApiResult.failure(ServerFailure('خطأ غير متوقع: ${e.toString()}'));
    }
  }
}
