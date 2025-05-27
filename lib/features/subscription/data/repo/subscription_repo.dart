import 'package:smle/features/subscription/data/model/checkout_model.dart';
import 'package:smle/features/subscription/data/model/packages_model.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/failures.dart';
import '../../../../core/shared_widgets/debug_print_widget.dart';

class SubscriptionRepository {
  final DioFactory _dioFactory;

  SubscriptionRepository(this._dioFactory);

  Future<ApiResult<PackagesModel>> getPackages() async {
    final response = await _dioFactory.get(endPoint: EndPoints.getPackages);
    if (response!.statusCode == 200) {
      PackagesModel model = PackagesModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['error']);
      return ApiResult.failure(ServerFailure.fromResponse(
          response.statusCode, response.data['error']));
    }
  }

  Future<ApiResult<CheckoutModel>> getYourCheckout(
      String? offerId, String promoCode) async {
    final response = await _dioFactory.post(
        endPoint: EndPoints.getYourCheckout,
        data: promoCode.isEmpty
            ? {
                'offer_id': offerId,
              }
            : {'offer_id': offerId, 'code': promoCode});
    if (response!.statusCode == 200 || response.statusCode == 400) {
      CheckoutModel model = CheckoutModel.fromJson(response.data);
      return ApiResult.success(model);
    }
    // else if (response.statusCode == 400 ) {
    //   debugPrintWidget(response.data['message']);
    //   return ApiResult.failure(
    //       ServerFailure.fromResponse(response.statusCode, response.data['message']));
    // }
    else {
      debugPrintWidget(response.data['message']);
      return ApiResult.failure(ServerFailure.fromResponse(
          response.statusCode, response.data['message']));
    }
  }
}
