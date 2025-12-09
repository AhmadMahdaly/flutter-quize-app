import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/analysis/data/model/analysis_model.dart';

class AnalysisRepository {
  AnalysisRepository(this._dioFactory);
  final DioFactory _dioFactory;

  Future<ApiResult<AnalysisModel>> getAnalysis() async {
    final response = await _dioFactory.get(
      endPoint: EndPoints.finishAnalysisExam,
    );

    if (response!.statusCode == 200) {
      final AnalysisModel model = AnalysisModel.fromJson(response.data);
      return ApiResult.success(model);
    }
    // إضافة هذا الشرط لمعالجة خطأ الـ PHP المحدد
    else if (response.statusCode == 500 &&
        response.data['message'].toString().contains(
          'Attempt to read property "id" on null',
        )) {
      return ApiResult.failure(
        ServerFailure(
          'No analysis is available yet because you haven\'t taken any tests.',
        ),
      );
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
