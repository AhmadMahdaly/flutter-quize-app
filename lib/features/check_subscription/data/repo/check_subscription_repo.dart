import 'dart:developer';

import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/features/check_subscription/data/models/check_subscription_model.dart';

class CheckSubscriptionRepository {
  CheckSubscriptionRepository(this._dioFactory);
  final DioFactory _dioFactory;

  Future<CheckSubscriptionModel> fetchSubscription() async {
    final response = await _dioFactory.get(endPoint: EndPoints.checkSubscribe);
    final data = response?.data;

    if (data['status'] == 200) {
      if (data['data'] == null) {
        return CheckSubscriptionModel();
      }
      log(data['data'].toString());
      return CheckSubscriptionModel.fromJson(data['data']);
    } else {
      throw Exception('Error fetching subscription');
    }
  }
}
