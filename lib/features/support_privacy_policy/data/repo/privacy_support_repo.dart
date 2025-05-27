import '../../../../core/network/api_result.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/failures.dart';
import '../../../../core/shared_widgets/debug_print_widget.dart';
import '../model/privacy_support_model.dart';

class PrivacySupportRepository {
  final DioFactory _dioFactory;

  PrivacySupportRepository(this._dioFactory);

  Future<ApiResult<PrivacySupportModel>> getSupport() async {
    final response = await _dioFactory.get(endPoint: EndPoints.support);
    if (response!.statusCode == 200 ) {
      PrivacySupportModel model = PrivacySupportModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['error']);
      return ApiResult.failure(
          ServerFailure.fromResponse(response.statusCode, response.data['error']));
    }
  }

  Future<ApiResult<PrivacySupportModel>> getPrivacyPolicy() async {
    final response = await _dioFactory.get(endPoint: EndPoints.privacyPolicy);
    if (response!.statusCode == 200 ) {
      PrivacySupportModel model = PrivacySupportModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['error']);
      return ApiResult.failure(
          ServerFailure.fromResponse(response.statusCode, response.data['error']));
    }
  }
}