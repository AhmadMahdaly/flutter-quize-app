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
}
