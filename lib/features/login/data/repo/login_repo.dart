

import 'package:smle/features/login/data/model/login_model.dart';

import '../../../../core/cache_helper/cache_helper.dart';
import '../../../../core/cache_helper/cache_values.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/failures.dart';
import '../../../../core/shared_widgets/debug_print_widget.dart';

class LoginRepository {
  final DioFactory _dioFactory;

  LoginRepository(this._dioFactory);

  Future<ApiResult<LoginModel>> login(String idToken,String email,String name) async {
    final response = await _dioFactory.post(endPoint: EndPoints.login,data: {
      'google_id':idToken,
      'email':email,
      'name':name,
    });
    if (response!.statusCode == 200 ) {
      LoginModel model = LoginModel.fromJson(response.data);
      await CacheHelper.saveSecuredString(
          key: CacheKeys.userToken, value: model.data!.token);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['message']);
      return ApiResult.failure(
          ServerFailure.fromResponse(response.statusCode, response.data['message']));
    }
  }

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