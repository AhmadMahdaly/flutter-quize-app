import 'package:dio/dio.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';

abstract class NotificationRepo {
  Future<void> sendFcmToken(String token);
}

class NotificationRepoImpl implements NotificationRepo {
  NotificationRepoImpl(this._dioFactory);
  final DioFactory _dioFactory;
  @override
  Future<ApiResult<void>> sendFcmToken(String token) async {
    try {
      await _dioFactory.post(
        endPoint: EndPoints.fcmToken,
        data: {'fcm_token': token},
      );
      return const ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.failure(ServerFailure.fromDioError(e));
    } catch (e) {
      return ApiResult.failure(ServerFailure('Unexpected error occurred'));
    }
  }
}
