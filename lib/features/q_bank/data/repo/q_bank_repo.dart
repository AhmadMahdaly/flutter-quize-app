import 'package:smle/features/q_bank/data/model/q_bank_model.dart';
import 'package:smle/features/subscription/data/model/checkout_model.dart';
import 'package:smle/features/subscription/data/model/packages_model.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/failures.dart';
import '../../../../core/shared_widgets/debug_print_widget.dart';
import '../../../revision/data/model/categories_model.dart';
import '../../../revision/data/model/subcategories_model.dart';

class QBankRepository {
  final DioFactory _dioFactory;

  QBankRepository(this._dioFactory);

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
      QBankModel model = QBankModel.fromJson(response.data);
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
      CategoriesModel model = CategoriesModel.fromJson(response.data);
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
      SubCategoriesModel model = SubCategoriesModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['error']);
      return ApiResult.failure(ServerFailure.fromResponse(
          response.statusCode, response.data['error']));
    }
  }
}
