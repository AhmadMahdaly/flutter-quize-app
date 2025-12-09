import 'package:smle/core/cache_helper/cache_helper.dart';
import 'package:smle/core/cache_helper/cache_values.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/main%20layout/data/model/gifts_model.dart';
import 'package:smle/features/main%20layout/data/model/profile_model.dart';

class MainLayoutRepository {
  MainLayoutRepository(this._dioFactory);
  final DioFactory _dioFactory;

  Future<ApiResult<ProfileModel>> getProfile() async {
    final response = await _dioFactory.get(endPoint: EndPoints.profile);
    if (response!.statusCode == 200) {
      final ProfileModel model = ProfileModel.fromJson(response.data);
      await CacheHelper.saveData(key: CacheKeys.userId, value: model.data!.id!);

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

  Future<ApiResult<GiftsModel>> getGifts() async {
    final response = await _dioFactory.get(endPoint: EndPoints.gifts);
    if (response!.statusCode == 200) {
      final GiftsModel model = GiftsModel.fromJson(response.data);
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

  /// Delete Account
  Future<ApiResult> deleteAccount() async {
    final response = await _dioFactory.get(endPoint: EndPoints.deleteAccount);
    if (response!.statusCode == 200) {
      return ApiResult.success(response.data);
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
