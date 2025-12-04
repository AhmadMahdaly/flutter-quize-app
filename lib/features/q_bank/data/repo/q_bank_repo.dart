import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/q_bank/data/model/q_bank_model.dart';
import 'package:smle/features/q_bank/data/model/question_count_model.dart';
import 'package:smle/features/revision/data/model/categories_model.dart';
import 'package:smle/features/revision/data/model/subcategories_model.dart';

class QBankRepository {
  QBankRepository(this._dioFactory);
  final DioFactory _dioFactory;
  Future<void> init() async {
    try {
      await _dioFactory.get(endPoint: EndPoints.createQBank);
    } catch (_) {}
  }

  Future<ApiResult<QBankModel>> startQuiz({
    required dynamic year,
    required dynamic month,
    required int allMonths,
    required List<int> subcategoryIds,
    required int unansweredOnly,
    required int limit,
  }) async {
    final Map<String, dynamic> data = {
      'year': year,
      'subcategory_id': subcategoryIds,
      'unanswered_only': unansweredOnly,
      'limit': limit,
      'month': month,
      'allMonths': allMonths,
    };

    try {
      final response = await _dioFactory.post(
        endPoint: EndPoints.startQBank,
        data: data,
      );
      if (response!.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return ApiResult.success(QBankModel.fromJson(response.data));
        } else if (response.data is List) {
          return ApiResult.success(
            QBankModel(status: 404, message: 'No data', data: []),
          );
        }
        return ApiResult.failure(ServerFailure('Invalid format'));
      } else {
        return ApiResult.failure(
          ServerFailure.fromResponse(
            response.statusCode,
            response.data.toString(),
          ),
        );
      }
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }

  Future<ApiResult<QuestionCountModel>?> getQuestionsCount({
    required dynamic year,
    required dynamic month,
    required int allMonths,
    required List<int> subcategoryIds,
    required int unansweredOnly,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'year': year,
        'subcategory_id': subcategoryIds,
        'unanswered_only': unansweredOnly,
        'month': month,
        'allMonths': allMonths,
      };

      final response = await _dioFactory.post(
        endPoint: EndPoints.getQBankCount,
        data: data,
      );

      if (response!.statusCode == 200) {
        return ApiResult.success(QuestionCountModel.fromJson(response.data));
      } else {
        return null;
      }
    } catch (e) {
      debugPrintWidget(e.toString());
      return null;
    }
  }

  Future<ApiResult<QBankModel>> getPlaylistQuestions({
    required int playlistId,
    required int limit,
    required int offset,
  }) async {
    final response = await _dioFactory.get(
      endPoint: EndPoints.getPlaylistQuestions,
      data: {'playlist_id': playlistId, 'limit': limit, 'offset': offset},
    );
    if (response!.statusCode == 200) {
      final QBankModel model = QBankModel.fromJson(response.data);
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
  }

  Future<ApiResult<QBankModel>> addQBankNote({
    required int questionId,
    required String note,
  }) async {
    final response = await _dioFactory.post(
      endPoint: EndPoints.addQBankNote,
      data: {'question_id': questionId, 'note': note},
    );
    if (response!.statusCode == 200) {
      final QBankModel model = QBankModel.fromJson(response.data);
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
  }

  Future<ApiResult<bool>> markQuestionAsAnswered(int questionId) async {
    try {
      final response = await _dioFactory.post(
        endPoint: EndPoints.markAsAnswered,
        data: {'questionbank_id': questionId},
      );
      if (response!.statusCode == 200) {
        return const ApiResult.success(true);
      } else {
        debugPrintWidget(response.data['message']);
        return ApiResult.failure(
          ServerFailure.fromResponse(
            response.statusCode,
            response.data['message'],
          ),
        );
      }
    } catch (e) {
      debugPrintWidget(e.toString());
      return ApiResult.failure(ServerFailure.fromResponse(500, e.toString()));
    }
  }

  Future<ApiResult<CategoriesModel>> getCategories() async {
    final response = await _dioFactory.get(endPoint: EndPoints.getCategories);
    if (response!.statusCode == 200) {
      final CategoriesModel model = CategoriesModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['error']);
      return ApiResult.failure(
        ServerFailure.fromResponse(response.statusCode, response.data['error']),
      );
    }
  }

  Future<ApiResult<SubCategoriesModel>> getSubCategories(
    String? categoryId,
  ) async {
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
        ServerFailure.fromResponse(response.statusCode, response.data['error']),
      );
    }
  }
}
