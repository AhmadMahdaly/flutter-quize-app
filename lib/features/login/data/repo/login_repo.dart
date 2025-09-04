import 'dart:io';

import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/cache_helper/cache_values.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/login/data/model/login_model.dart';

class LoginRepository {
  LoginRepository(this._dioFactory);
  final DioFactory _dioFactory;

  Future<ApiResult<LoginModel>> login(
    String idToken,
    String? email,
    String? name,
  ) async {
    if (Platform.isAndroid) {
      final response = await _dioFactory.post(
        endPoint: EndPoints.googleLogin,
        data: // email == null && name == null ?
        {
          'google_id': idToken,
        },
        //  : {'google_id': idToken, 'email': email, 'name': name},
      );
      if (response!.statusCode == 200) {
        final LoginModel model = LoginModel.fromJson(response.data);
        await CacheHelper.saveData(
          key: CacheKeys.userToken,
          value: model.data!.token,
        );
        return ApiResult.success(model);
      } else {
        debugPrintWidget(response.data['message']);
        return ApiResult.failure(
          ServerFailure.fromResponse(
            response.statusCode,
            response.data['message'],
          ),
        );
      }
    } else {
      final response = await _dioFactory.post(
        endPoint: EndPoints.appleLogin,
        data: //  email == null && name == null ?
        {
          'apple_id': idToken,
        },
        // : {'apple_id': idToken, 'email': email, 'name': name},
      );
      if (response!.statusCode == 200) {
        final LoginModel model = LoginModel.fromJson(response.data);
        await CacheHelper.saveData(
          key: CacheKeys.userToken,
          value: model.data!.token,
        );
        return ApiResult.success(model);
      } else {
        debugPrintWidget(response.data['message']);
        return ApiResult.failure(
          ServerFailure.fromResponse(
            response.statusCode,
            response.data['message'],
          ),
        );
      }
    }
  }
}
