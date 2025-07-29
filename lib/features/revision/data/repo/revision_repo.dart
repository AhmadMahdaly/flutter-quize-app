import 'package:smle/features/revision/data/model/subcategories_model.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/revision/data/model/categories_model.dart';

class RevisionRepository {

  RevisionRepository(this._dioFactory);
  final DioFactory _dioFactory;

  Future<ApiResult<CategoriesModel>> getCategories() async {
    final response = await _dioFactory.get(endPoint: EndPoints.getCategories);
    if (response!.statusCode == 200 ) {
      final CategoriesModel model = CategoriesModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['error']);
      return ApiResult.failure(
          ServerFailure.fromResponse(response.statusCode, response.data['error']));
    }
  }

  Future<ApiResult<SubCategoriesModel>> getSubCategories(String? categoryId) async {
    final response = await _dioFactory.get(endPoint: '${EndPoints.getSubCategories}$categoryId');
    if (response!.statusCode == 200 ) {
      final SubCategoriesModel model = SubCategoriesModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['error']);
      return ApiResult.failure(
          ServerFailure.fromResponse(response.statusCode, response.data['error']));
    }
  }
}