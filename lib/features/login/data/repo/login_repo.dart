

import 'package:smle/features/login/data/model/login_model.dart';

import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/cache_helper/cache_values.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';

class LoginRepository {

  LoginRepository(this._dioFactory);
  final DioFactory _dioFactory;

  Future<ApiResult<LoginModel>> login(String idToken,String email,String name) async {
    final response = await _dioFactory.post(endPoint: EndPoints.login,data: {
      'google_id':idToken,
      'email':email,
      'name':name,
    });
    if (response!.statusCode == 200 ) {
      final LoginModel model = LoginModel.fromJson(response.data);
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