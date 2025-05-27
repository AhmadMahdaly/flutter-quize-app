import 'package:smle/features/SCFHS_score_calculator/data/model/calculate_result_model.dart';
import 'package:smle/features/subscription/data/model/packages_model.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/failures.dart';
import '../../../../core/shared_widgets/debug_print_widget.dart';
import '../model/calculator_info_model.dart';

class CalculatorRepository {
  final DioFactory _dioFactory;

  CalculatorRepository(this._dioFactory);

  Future<ApiResult<CalculatorInfoModel>> getCalculatorInfo() async {
    final response = await _dioFactory.get(endPoint: EndPoints.calculatorInfo);
    if (response!.statusCode == 200 ) {
      CalculatorInfoModel model = CalculatorInfoModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['error']);
      return ApiResult.failure(
          ServerFailure.fromResponse(response.statusCode, response.data['error']));
    }
  }

  Future<ApiResult<CalculateResultModel>> calculateScfhs(
      String realExamScore,String gpa,List<int> cvList
      ) async {
    final response = await _dioFactory.post(endPoint: EndPoints.calculate,
    data: {
      'r_exam': realExamScore,
      'gpa': gpa,
      'cv': cvList,
    }
    );
    if (response!.statusCode == 200 ) {
      CalculateResultModel model = CalculateResultModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['error']);
      return ApiResult.failure(
          ServerFailure.fromResponse(response.statusCode, response.data['error']));
    }
  }

}