import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:smle/core/functions/debug_print_extension.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/features/subscription/data/model/packages_model.dart';

class SubscriptionRepository {
  SubscriptionRepository(this._dioFactory) {
    _paymobDio = Dio(
      BaseOptions(
        baseUrl: 'https://ksa.paymob.com/api/',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    )..interceptors.add(PrettyDioLogger());
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

  final int cardIntegrationId = 17816;
  final iframeId = 11205;

  final String _authUrl = 'auth/tokens';
  final String _orderUrl = 'ecommerce/orders';
  final String _paymentKeyUrl = 'acceptance/payment_keys';
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
      '🚀 Starting payment process...'.dPrint();
      '💰 Amount: $amountCents cents (${amountCents / 100} SAR)'.dPrint();

      // Step 1: Get Auth Token
      '\n📝 Step 1: Getting Auth Token...'.dPrint();
      final authRes = await _paymobDio.post(
        _authUrl,
        data: {'api_key': apiKey},
      );

      if (authRes.statusCode != 201) {
        '❌ Auth failed with status: ${authRes.statusCode}'.dPrint();

        return ApiResult.failure(ServerFailure('فشل في الحصول على Auth Token'));
      }

      final String authToken = authRes.data['token'];
      '✅ Auth Token received'.dPrint();

      // Step 2: Create Order
      '\n📝 Step 2: Creating Order...'.dPrint();

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
        '❌ Order creation failed with status: ${orderRes.statusCode}'.dPrint();

        return ApiResult.failure(ServerFailure('فشل في إنشاء الطلب'));
      }

      final int orderId = orderRes.data['id'];
      '✅ Order created with ID: $orderId'.dPrint();

      // Step 3: Get Payment Key
      '\n📝 Step 3: Getting Payment Key...'.dPrint();

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
        '❌ Payment Key failed with status: ${keyRes.statusCode}'.dPrint();

        return ApiResult.failure(
          ServerFailure('فشل في الحصول على Payment Key'),
        );
      }

      final String paymentToken = keyRes.data['token'];
      '✅ Payment Token received'.dPrint();

      // Return the full iframe URL with payment token
      return ApiResult.success('$_iframeUrl$paymentToken');
    } on DioException catch (e) {
      '❌ Dio Exception: ${e.type}'.dPrint();
      'Response: ${e.response?.data}'.dPrint();

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
      '❌ Unexpected Error: $e'.dPrint();
      return ApiResult.failure(ServerFailure('خطأ غير متوقع: ${e.toString()}'));
    }
  }

  // ✅ التحقق من حالة Transaction
  Future<ApiResult<Map<String, dynamic>>> verifyTransaction(
    String transactionId,
  ) async {
    try {
      '🔍 Verifying transaction: $transactionId'.dPrint();

      // Get auth token first
      final authRes = await _paymobDio.post(
        _authUrl,
        data: {'api_key': apiKey},
      );

      if (authRes.statusCode != 201) {
        return ApiResult.failure(ServerFailure('فشل في المصادقة'));
      }

      final String authToken = authRes.data['token'];

      // Get transaction details
      final txnRes = await _paymobDio.get(
        'acceptance/transactions/$transactionId',
        queryParameters: {'token': authToken},
      );

      if (txnRes.statusCode == 200) {
        final data = txnRes.data;

        '📊 Transaction Data: $data'.dPrint();

        // تحليل النتيجة
        final bool isSuccess = data['success'] == true;
        final bool hasError = data['error_occured'] == true;
        final String message =
            data['data']?['message'] ??
            data['rejection_reason'] ??
            (isSuccess ? 'تم الدفع بنجاح' : 'فشل الدفع');

        return ApiResult.success({
          'success': isSuccess && !hasError,
          'message': message,
          'transaction_id': transactionId,
          'amount': data['amount_cents'],
          'currency': data['currency'],
          'error_occured': hasError,
        });
      }

      return ApiResult.failure(ServerFailure('فشل التحقق من الدفع'));
    } catch (e) {
      '❌ Verification Error: $e'.dPrint();
      return ApiResult.failure(ServerFailure('خطأ في التحقق: ${e.toString()}'));
    }
  }
}
