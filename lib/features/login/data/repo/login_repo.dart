import 'dart:io';

import 'package:dio/dio.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/cache_helper/cache_values.dart';
import 'package:smle/core/functions/debug_print_extension.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/features/login/data/model/login_model.dart';

class LoginRepository {
  LoginRepository(this._dioFactory);
  final DioFactory _dioFactory;

  Future<ApiResult<LoginModel>> login({
    required String id,
    String? email,
    String? name,
    String? fcmToken,
  }) async {
    final bool isAndroid = Platform.isAndroid;
    final String endpoint = isAndroid
        ? EndPoints.googleLogin
        : EndPoints.appleLogin;
    final String idKey = isAndroid ? 'google_id' : 'apple_id';

    // --- Attempt 1: Send full details for registration ---
    final Map<String, dynamic> data = {
      idKey: id,
      if (fcmToken != null) 'fcm_token': fcmToken,
      if (email != null) 'email': email,
      if (name != null) 'name': name,
    };

    try {
      final response = await _dioFactory.post(endPoint: endpoint, data: data);
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        return _handleSuccess(response);
      }
      // Re-throw as a DioError to be caught below
      throw DioException(
        requestOptions: response!.requestOptions,
        response: response,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 422 &&
          (e.response?.data['message'] as String?)?.contains(
                'The email has already been taken',
              ) ==
              true) {
        'Email already taken. Retrying as a login attempt...'.dPrint();
        final Map<String, dynamic> loginData = {
          idKey: id,
          if (fcmToken != null) 'fcm_token': fcmToken,
        };
        try {
          final loginResponse = await _dioFactory.post(
            endPoint: endpoint,
            data: loginData,
          );
          if (loginResponse != null &&
              (loginResponse.statusCode == 200 ||
                  loginResponse.statusCode == 201)) {
            return _handleSuccess(loginResponse);
          } else {
            final errorMessage =
                loginResponse?.data['message'] ??
                'Login failed after registration attempt.';
            return ApiResult.failure(ServerFailure(errorMessage));
          }
        } catch (loginError) {
          return ApiResult.failure(
            ServerFailure('Login attempt failed: $loginError'),
          );
        }
      }

      // For all other errors, return failure
      final errorMessage =
          e.response?.data['message'] ??
          e.message ??
          'An unknown error occurred';
      return ApiResult.failure(ServerFailure(errorMessage));
    }
  }

  Future<ApiResult<LoginModel>> _handleSuccess(Response response) async {
    final LoginModel model = LoginModel.fromJson(response.data);
    if (model.data?.token != null) {
      await CacheHelper.saveData(
        key: CacheKeys.userToken,
        value: model.data!.token!,
      );
      await CacheHelper.saveData(key: CacheKeys.userId, value: model.data!.id!);
    }
    return ApiResult.success(model);
  }
}
