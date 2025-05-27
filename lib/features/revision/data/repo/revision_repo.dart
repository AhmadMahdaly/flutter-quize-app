import 'package:smle/features/revision/data/model/subcategories_model.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/failures.dart';
import '../../../../core/shared_widgets/debug_print_widget.dart';
import '../model/categories_model.dart';

class RevisionRepository {
  final DioFactory _dioFactory;

  RevisionRepository(this._dioFactory);

  Future<ApiResult<CategoriesModel>> getCategories() async {
    final response = await _dioFactory.get(endPoint: EndPoints.getCategories);
    if (response!.statusCode == 200 ) {
      CategoriesModel model = CategoriesModel.fromJson(response.data);
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
      SubCategoriesModel model = SubCategoriesModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['error']);
      return ApiResult.failure(
          ServerFailure.fromResponse(response.statusCode, response.data['error']));
    }
  }
}