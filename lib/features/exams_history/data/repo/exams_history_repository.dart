import 'package:dio/dio.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/features/exams_history/data/models/exams_history_model.dart';

class ExamsHistoryRepository {
  ExamsHistoryRepository(this._dioFactory);
  final DioFactory _dioFactory;

  Future<ApiResult<ExamsHistoryModel>> getExamsHistory() async {
    try {
      final response = await _dioFactory.post(
        endPoint: EndPoints.getExamHistory,
      );
      if (response!.statusCode == 200) {
        final examsHistoryModel = ExamsHistoryModel.fromJson(response.data);
        return ApiResult.success(examsHistoryModel);
      } else {
        return ApiResult.failure(
          ServerFailure.fromResponse(
            response.statusCode,
            response.data['message'],
          ),
        );
      }
    } on DioException catch (e) {
      return ApiResult.failure(ServerFailure.fromDioError(e));
    } catch (e) {
      return ApiResult.failure(ServerFailure('Unexpected error occurred'));
    }
  }
}
