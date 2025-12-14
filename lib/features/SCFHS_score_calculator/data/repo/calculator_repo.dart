import 'package:dio/dio.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/SCFHS_score_calculator/data/model/calculate_result_model.dart';
import 'package:smle/features/SCFHS_score_calculator/data/model/calculator_info_model.dart';

class CalculatorRepository {
  CalculatorRepository(this._dioFactory);
  final DioFactory _dioFactory;

  Future<ApiResult<CalculatorInfoModel>> getCalculatorInfo() async {
    try {
      final response = await _dioFactory.get(
        endPoint: EndPoints.calculatorInfo,
      );
      if (response!.statusCode == 200) {
        final CalculatorInfoModel model = CalculatorInfoModel.fromJson(
          response.data,
        );
        return ApiResult.success(model);
      } else {
        debugPrintWidget(response.data['error']);
        return ApiResult.failure(
          ServerFailure.fromResponse(
            response.statusCode,
            response.data['error'],
          ),
        );
      }
    } on DioException catch (e) {
      return ApiResult.failure(ServerFailure.fromDioError(e));
    } catch (e) {
      return ApiResult.failure(ServerFailure('Unexpected error occurred'));
    }
  }

  Future<ApiResult<CalculateResultModel>> calculateScfhs(
    String realExamScore,
    String gpa,
    List<int> cvList,
  ) async {
    try {
      final response = await _dioFactory.post(
        endPoint: EndPoints.calculate,
        data: {'r_exam': realExamScore, 'gpa': gpa, 'cv': cvList},
      );
      if (response!.statusCode == 200) {
        final CalculateResultModel model = CalculateResultModel.fromJson(
          response.data,
        );
        return ApiResult.success(model);
      } else {
        debugPrintWidget(response.data['error']);
        return ApiResult.failure(
          ServerFailure.fromResponse(
            response.statusCode,
            response.data['error'],
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
