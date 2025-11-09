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
    required String month,
    required String year,
    required List<int> subcategoryIds,
    required int unansweredOnly,
    required int limit,
  }) async {
    final response = await _dioFactory.post(
      endPoint: EndPoints.startQBank,
      data: {
        'month': month,
        'year': year,
        'subcategory_id': subcategoryIds,
        'unanswered_only': unansweredOnly,
        'limit': limit,
      },
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

  // دالة جديدة لجلب أسئلة الـ playlist مع pagination
  Future<ApiResult<QBankModel>> getPlaylistQuestions({
    required int playlistId,
    required int limit,
    required int offset,
  }) async {
    final response = await _dioFactory.get(
      endPoint: EndPoints
          .getPlaylistQuestions, // افتراض: EndPoints.getPlaylistQuestions = '/playlists/{id}/questions'
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
  /// TODO
  Future<ApiResult<QBankModel>> addQBankNote({
    required int questionId,
    required String note,
  }) async {
    final response = await _dioFactory.get(
      endPoint: EndPoints
          .addQBankNote,
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
  Future<ApiResult<QuestionCountModel>?> getQuestionsCount({
    required String month,
    required String year,
    required List<int> subcategoryIds,
    required int unansweredOnly,
  }) async {
    try {
      final response = await _dioFactory.post(
        endPoint: EndPoints.getQBankCount,
        data: {
          'month': month,
          'year': year,
          'subcategory_id': subcategoryIds,
          'unanswered_only': unansweredOnly,
        },
      );
      if (response!.statusCode == 200) {
        final QuestionCountModel model = QuestionCountModel.fromJson(
          response.data,
        );
        return ApiResult.success(model);
      } else {
        debugPrintWidget(response.data['message'] ?? 'Unknown error');
        return null;
        //  ApiResult.failure(
        //   ServerFailure.fromResponse(
        //     response.statusCode,
        //     response.data['message'],
        //   ),
        // );
      }
    } catch (e) {
      debugPrintWidget(e.toString());
      return null;

      // return ApiResult.failure(ServerFailure.fromResponse(500, e.toString()));
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
