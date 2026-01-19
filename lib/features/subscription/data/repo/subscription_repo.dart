import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/cache_helper/cache_values.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/features/subscription/data/model/checkout_model.dart';
import 'package:smle/features/subscription/data/model/packages_model.dart';
import 'package:smle/features/subscription/data/model/payment_callback_model.dart';

class SubscriptionRepository {
  SubscriptionRepository(this._dioFactory);
  final DioFactory _dioFactory;

  Future<ApiResult<PackagesModel>> getPackages() async {
    try {
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
    } on DioException catch (e) {
      return ApiResult.failure(ServerFailure.fromDioError(e));
    } catch (e) {
      return ApiResult.failure(ServerFailure('Unexpected error occurred'));
    }
  }

  Future<ApiResult<CheckoutModel>> checkout({
    required int offerId,
    String? code,
  }) async {
    try {
      final response = await _dioFactory.post(
        endPoint: 'GetYour/Checkout', // تأكد من المسار الصحيح في EndPoints
        data: {'offer_id': offerId, 'code': code},
      );
      if (response!.statusCode == 200) {
        return ApiResult.success(CheckoutModel.fromJson(response.data));
      } else {
        return ApiResult.failure(
          ServerFailure.fromResponse(
            response.statusCode,
            response.data['message'],
          ),
        );
      }
    } catch (e) {
      return ApiResult.failure(ServerFailure('Error checking code'));
    }
  }

  Future<ApiResult<String>> processPayment({
    required int offerId,
    required int amountCents,
    required Map<String, dynamic> billingData,
    String? code,
  }) async {
    try {
      final response = await _dioFactory.post(
        endPoint: EndPoints.paymentProcess,
        data: {
          'offer_id': offerId,
          'amount_cents': amountCents,
          'billing_data': billingData,
          'code': code,
        },
      );

      if (response!.statusCode == 200) {
        if (response.data['success'] == true) {
          final String iframeUrl = response.data['url'];
          return ApiResult.success(iframeUrl);
        } else {
          return ApiResult.failure(
            ServerFailure(
              response.data['message'] ?? 'Payment initialization failed',
            ),
          );
        }
      } else {
        return ApiResult.failure(
          ServerFailure.fromResponse(
            response.statusCode,
            response.data['message'],
          ),
        );
      }
    } on DioException catch (e) {
      return ApiResult.failure(ServerFailure.fromDioError(e));
    } catch (e) {
      return ApiResult.failure(ServerFailure('Unexpected error occurred'));
    }
  }

  Future<ApiResult<String>> processPaymentCallback({
    required Map<String, dynamic> billingData,
  }) async {
    try {
      final userId = CacheHelper.getData(key: CacheKeys.userId);
      log(userId.toString());
      final model = PaymentCallbackModel.fromJson(billingData);
      log(model.toString());
      final response = await _dioFactory.get(
        endPoint: EndPoints.paymentCallback,
        data: {
          'success': model.success,
          'merchant_order_id': model.merchantOrderId,
          'id': model.id,
          'user_id': userId,
        },
      );

      if (response!.statusCode == 200) {
        final data = response.data['success'];
        return ApiResult.success(data);
      } else {
        return ApiResult.failure(
          ServerFailure(
            response.data['message'] ?? 'Payment initialization failed',
          ),
        );
      }
    } on DioException catch (e) {
      return ApiResult.failure(ServerFailure.fromDioError(e));
    } catch (e) {
      return ApiResult.failure(ServerFailure('Unexpected error occurred'));
    }
  }

  Future<ApiResult<String>> processPaymentCallbackGift({
    required Map<String, dynamic> billingData,
    required int currentReceiverId,
  }) async {
    try {
      final userId = CacheHelper.getData(key: CacheKeys.userId);
      log(userId.toString());
      final model = PaymentCallbackModel.fromJson(billingData);
      log(model.toString());
      final response = await _dioFactory.post(
        endPoint: EndPoints.paymentCallbackGift,
        data: {
          'success': model.success,
          'merchant_order_id': model.merchantOrderId,
          'id': model.id,
          'user_id': currentReceiverId,
        },
      );

      if (response!.statusCode == 200) {
        final data = response.data['success'];
        return ApiResult.success(data);
      } else {
        return ApiResult.failure(
          ServerFailure(
            response.data['message'] ?? 'Payment initialization failed',
          ),
        );
      }
    } on DioException catch (e) {
      return ApiResult.failure(ServerFailure.fromDioError(e));
    } catch (e) {
      return ApiResult.failure(ServerFailure('Unexpected error occurred'));
    }
  }
  // داخل SubscriptionRepository

  // 1. تشيك على الإيميل وجلب الـ receiver_id
  Future<ApiResult<int>> checkGiftCheckout({
    required int offerId,
    required String email,
  }) async {
    try {
      final response = await _dioFactory.post(
        endPoint: 'gift/checkout',
        data: {'offer_id': offerId, 'email': email},
      );
      if (response!.statusCode == 200 && response.data['success'] == true) {
        return ApiResult.success(
          response.data['receiver_id'],
        ); // إرجاع الـ ID فقط
      } else {
        return ApiResult.failure(
          ServerFailure(response.data['message'] ?? 'Error'),
        );
      }
    } catch (e) {
      return ApiResult.failure(ServerFailure('Email not found or invalid'));
    }
  }

  // 2. معالجة دفع الهدية بالبيانات الجديدة
  Future<ApiResult<String>> processGiftPayment({
    required int offerId,
    required int receiverId,
    required int amountCents,
    required String payerName,
    required String payerEmail,
    required String payerPhone,
  }) async {
    try {
      final response = await _dioFactory.post(
        endPoint: 'gift/payment/process',
        data: {
          'offer_id': offerId,
          'receiver_id': receiverId,
          'amount_cents': amountCents,
          'payer_name': payerName,
          'payer_email': payerEmail,
          'payer_phone': payerPhone,
        },
      );

      if (response!.statusCode == 200 && response.data['success'] == true) {
        return ApiResult.success(response.data['url']);
      } else {
        return ApiResult.failure(
          ServerFailure(response.data['message'] ?? 'Payment failed'),
        );
      }
    } catch (e) {
      return ApiResult.failure(ServerFailure('Unexpected error occurred'));
    }
  }
}
