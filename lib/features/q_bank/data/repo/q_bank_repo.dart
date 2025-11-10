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
  }Future<ApiResult<QBankModel>> startQuiz({
    // --- بارامترات معدلة لتقبل الحالتين ---
    required dynamic year, // يمكن أن يكون 'all' أو int (مثل 2024)
    required dynamic month, // يمكن أن يكون 'all' أو List<int> (مثل [1, 2])
    required int all_months, // 0 أو 1 (يُستخدم فقط إذا لم يكن 'all')
    // ---
    required List<int> subcategoryIds,
    required int unansweredOnly,
    required int limit,
  }) async {
    final Map<String, dynamic> data = {
      'year': year,
      'subcategory_id': subcategoryIds,
      'unanswered_only': unansweredOnly,
      'limit': limit,
    };

    if (year == 'all') {
      // إذا كان "كل السنوات"، نفترض أن الـ API يتوقع 'all' للشهور أيضاً
      data['month'] = 'all';
    } else {
      // إذا كانت سنة محددة
      data['all_months'] = all_months;
      if (all_months == 0) {
        // إذا لم يكن "كل الشهور"، أرسل قائمة الشهور المحددة
        data['month'] = month; // (هذه List<int>)
      }
    }

    final response = await _dioFactory.post(
      endPoint: EndPoints.startQBank,
      data: data,
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
  }Future<ApiResult<QuestionCountModel>?> getQuestionsCount({
    // --- بارامترات معدلة لتقبل الحالتين ---
    required dynamic year, // 'all' or int
    required dynamic month, // 'all' or List<int>
    required int all_months, // 0 or 1
    // ---
    required List<int> subcategoryIds,
    required int unansweredOnly,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'year': year,
        'subcategory_id': subcategoryIds,
        'unanswered_only': unansweredOnly,
      };

      if (year == 'all') {
        data['month'] = 'all';
      } else {
        data['all_months'] = all_months;
        if (all_months == 0) {
          data['month'] = month; // (هذه List<int>)
        }else{ data['month'] = [1,2,3,4,5.6,7,8,9,10,11,12];}
      }

      final response = await _dioFactory.post(
        endPoint: EndPoints.getQBankCount,
        data: data,
      );
      if (response!.statusCode == 200) {
        final QuestionCountModel model = QuestionCountModel.fromJson(
          response.data,
        );
        return ApiResult.success(model);
      } else {
        debugPrintWidget(response.data['message'] ?? 'Unknown error');
        return null;
      }
    } catch (e) {
      debugPrintWidget(e.toString());
      return null;
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
