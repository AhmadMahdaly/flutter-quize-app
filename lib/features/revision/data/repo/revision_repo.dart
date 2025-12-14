import 'package:dio/dio.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/revision/data/model/categories_model.dart';
import 'package:smle/features/revision/data/model/subcategories_model.dart';

class RevisionRepository {
  RevisionRepository(this._dioFactory);
  final DioFactory _dioFactory;

  Future<ApiResult<CategoriesModel>> getCategories() async {
    try {
      final response = await _dioFactory.get(endPoint: EndPoints.getCategories);
      if (response!.statusCode == 200) {
        final CategoriesModel model = CategoriesModel.fromJson(response.data);
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

  Future<ApiResult<SubCategoriesModel>> getSubCategories(
    String? categoryId,
  ) async {
    try {
      final response = await _dioFactory.get(
        endPoint: '${EndPoints.getSubCategories}$categoryId',
      );
      if (response!.statusCode == 200) {
        final SubCategoriesModel model = SubCategoriesModel.fromJson(
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
