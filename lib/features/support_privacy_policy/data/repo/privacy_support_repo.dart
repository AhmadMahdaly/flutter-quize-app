import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/support_privacy_policy/data/model/privacy_support_model.dart';

class PrivacySupportRepository {
  PrivacySupportRepository(this._dioFactory);
  final DioFactory _dioFactory;

  Future<ApiResult<PrivacySupportModel>> getSupport() async {
    final response = await _dioFactory.get(endPoint: EndPoints.support);
    if (response!.statusCode == 200) {
      final PrivacySupportModel model =
          PrivacySupportModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['error']);
      return ApiResult.failure(ServerFailure.fromResponse(
          response.statusCode, response.data['error']));
    }
  }

  Future<ApiResult<PrivacySupportModel>> getPrivacyPolicy() async {
    final response = await _dioFactory.get(endPoint: EndPoints.privacyPolicy);
    if (response!.statusCode == 200) {
      final PrivacySupportModel model =
          PrivacySupportModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['error']);
      return ApiResult.failure(ServerFailure.fromResponse(
          response.statusCode, response.data['error']));
    }
  }
}
