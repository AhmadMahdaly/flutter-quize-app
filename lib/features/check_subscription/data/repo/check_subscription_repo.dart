import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/features/check_subscription/data/models/check_subscription_model.dart';

class CheckSubscriptionRepository {
  CheckSubscriptionRepository(this._dioFactory);
  final DioFactory _dioFactory;

  Future<ApiResult<CheckSubscriptionModel>> fetchSubscription() async {try{
    final response = await _dioFactory.get(endPoint: EndPoints.checkSubscribe);
    final data = response?.data;

    if (data['status'] == 200) {
      if (data['data'] == null) {
        return ApiResult.success(CheckSubscriptionModel());
      }
      log(data['data'].toString());
      return ApiResult.success(CheckSubscriptionModel.fromJson(data['data']));
    } else {
      throw Exception('Error fetching subscription');
    }} on DioException catch (e) {
    return ApiResult.failure(ServerFailure.fromDioError(e));
  } catch (e) {
    return ApiResult.failure(
      ServerFailure('Unexpected error occurred'),
    );
  }
  }  
}
