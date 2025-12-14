import 'package:dio/dio.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/free_trial/data/models/trial_exam_model.dart';

class TrialExamRepository {
  TrialExamRepository(this._dioFactory);
  final DioFactory _dioFactory;
  Future getTrialExam() async {
    try {
      final response = await _dioFactory.post(endPoint: EndPoints.getFreeTrial);
      if (response!.statusCode == 200) {
        final model = TrialExamModel.fromJson(response.data);
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
    } on DioException catch (e) {
      return ApiResult.failure(ServerFailure.fromDioError(e));
    } catch (e) {
      return ApiResult.failure(ServerFailure('Unexpected error occurred'));
    }
  }
}
