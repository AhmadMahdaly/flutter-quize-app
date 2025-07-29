import 'package:smle/features/q_bank/data/model/q_bank_model.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/revision/data/model/categories_model.dart';
import 'package:smle/features/revision/data/model/subcategories_model.dart';

class QBankRepository {

  QBankRepository(this._dioFactory);
  final DioFactory _dioFactory;

  Future<ApiResult<QBankModel>> getQBank(
      int month, int year, List<int> subcategoryIds) async {
    final response =
        await _dioFactory.post(endPoint: EndPoints.getQBank, data: {
      // 'offset': offset,
      // 'limit': '1',
      'month': month,
      'year': year,
      'subcategory_id': subcategoryIds,
    });
    if (response!.statusCode == 200) {
      final QBankModel model = QBankModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['message']);
      return ApiResult.failure(ServerFailure.fromResponse(
          response.statusCode, response.data['message']));
    }
  }

  Future<ApiResult<CategoriesModel>> getCategories() async {
    final response = await _dioFactory.get(endPoint: EndPoints.getCategories);
    if (response!.statusCode == 200) {
      final CategoriesModel model = CategoriesModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['error']);
      return ApiResult.failure(ServerFailure.fromResponse(
          response.statusCode, response.data['error']));
    }
  }

  Future<ApiResult<SubCategoriesModel>> getSubCategories(
      String? categoryId) async {
    final response = await _dioFactory.get(
        endPoint: '${EndPoints.getSubCategories}$categoryId');
    if (response!.statusCode == 200) {
      final SubCategoriesModel model = SubCategoriesModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['error']);
      return ApiResult.failure(ServerFailure.fromResponse(
          response.statusCode, response.data['error']));
    }
  }
}
