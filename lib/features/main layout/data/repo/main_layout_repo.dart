import '../../../../core/network/api_result.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/failures.dart';
import '../../../../core/shared_widgets/debug_print_widget.dart';
import '../model/profile_model.dart';

class MainLayoutRepository {
  final DioFactory _dioFactory;

  MainLayoutRepository(this._dioFactory);

  Future<ApiResult<ProfileModel>> getProfile() async {
    final response = await _dioFactory.get(endPoint: EndPoints.profile);
    if (response!.statusCode == 200 ) {
      ProfileModel model = ProfileModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['message']);
      return ApiResult.failure(
          ServerFailure.fromResponse(response.statusCode, response.data['message']));
    }
  }

/// Delete Account
  Future<ApiResult> deleteAccount() async {
    final response = await _dioFactory.get(endPoint: EndPoints.deleteAccount);
    if (response!.statusCode == 200 ) {
      return ApiResult.success(response.data);
    } else {
      debugPrintWidget(response.data['message']);
      return ApiResult.failure(
          ServerFailure.fromResponse(response.statusCode, response.data['message']));
    }
  }
}