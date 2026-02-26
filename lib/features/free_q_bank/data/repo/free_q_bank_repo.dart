import 'package:dio/dio.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/q_bank/data/model/q_bank_model.dart';
import 'package:smle/features/q_bank/data/model/question_count_model.dart';
import 'package:smle/features/revision/data/model/categories_model.dart'
    hide Data;
import 'package:smle/features/revision/data/model/subcategories_model.dart'
    hide Data;

class FreeQBankRepository {
  FreeQBankRepository(this._dioFactory);
  final DioFactory _dioFactory;
  Future<ApiResult<void>> init() async {
    try {
      await _dioFactory.get(endPoint: EndPoints.createFreeQBank);
      return const ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.failure(ServerFailure.fromDioError(e));
    } catch (e) {
      return ApiResult.failure(ServerFailure('Unexpected error occurred'));
    }
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
      'question_count': limit,
      'month': month,
      'allMonths': allMonths,
    };

    try {
      final response = await _dioFactory.post(
        endPoint: EndPoints.startFreeQBank,
        data: data,
      );

      // داخل ملف Repository
      if (response!.statusCode == 200) {
        if (response.data is List) {
          // 1. استلام القائمة الخام
          final List<dynamic> rawList = response.data;

          // 2. تحويل كل عنصر في القائمة إلى كائن Data (Question)
          final List<Data> questions = rawList
              .map((item) => Data.fromJson(item))
              .toList();

          // 3. تغليف القائمة داخل QBankModel لكي لا ينهار Cubit
          return ApiResult.success(
            QBankModel(
              status: 200,
              message: 'Success',
              questionsCount: questions.length,
              data: questions,
            ),
          );
        } else if (response.data is Map<String, dynamic>) {
          // في حال عاد الـ API مستقبلاً بشكل Object
          return ApiResult.success(QBankModel.fromJson(response.data));
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
    } on DioException catch (e) {
      return ApiResult.failure(ServerFailure.fromDioError(e));
    } catch (e) {
      return ApiResult.failure(ServerFailure('Unexpected error occurred'));
    }
  }

  Future<ApiResult<List<int>>> getAvailableYears() async {
    try {
      final response = await _dioFactory.get(endPoint: EndPoints.freeTrialYears);
      if (response!.statusCode == 200) {
        final List<int> years = List<int>.from(response.data['data']);
        return ApiResult.success(years);
      }
      return ApiResult.failure(ServerFailure('Failed to load years'));
    } on DioException catch (e) {
      return ApiResult.failure(ServerFailure.fromDioError(e));
    }
  }

  Future<ApiResult<List<dynamic>>> getAvailableMonths(int year) async {
    try {
      final response = await _dioFactory.get(
        endPoint: EndPoints.freeTrialMonths,
        data: {'year': year},
      );
      if (response!.statusCode == 200) {
        return ApiResult.success(response.data['data']);
      }
      return ApiResult.failure(ServerFailure('Failed to load months'));
    } on DioException catch (e) {
      return ApiResult.failure(ServerFailure.fromDioError(e));
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
        endPoint: EndPoints.getFreeQBankCount,
        data: data,
      );

      if (response!.statusCode == 200) {
        return ApiResult.success(QuestionCountModel.fromJson(response.data));
      } else {
        return null;
      }
    } on DioException catch (e) {
      return ApiResult.failure(ServerFailure.fromDioError(e));
    } catch (e) {
      return ApiResult.failure(ServerFailure('Unexpected error occurred'));
    }
  }

  Future<ApiResult<QBankModel>> getPlaylistQuestions({
    required int playlistId,
    required int limit,
    required int offset,
  }) async {
    try {
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
    } on DioException catch (e) {
      return ApiResult.failure(ServerFailure.fromDioError(e));
    } catch (e) {
      return ApiResult.failure(ServerFailure('Unexpected error occurred'));
    }
  }

  Future<ApiResult<QBankModel>> addQBankNote({
    required int questionId,
    required String note,
  }) async {
    try {
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
    } on DioException catch (e) {
      return ApiResult.failure(ServerFailure.fromDioError(e));
    } catch (e) {
      return ApiResult.failure(ServerFailure('Unexpected error occurred'));
    }
  }

  Future<ApiResult<bool>> markQuestionAsAnswered(int questionId) async {
    try {
      final response = await _dioFactory.post(
        endPoint: EndPoints.markAsAnswered,
        data: {'question_id': questionId},
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
    } on DioException catch (e) {
      return ApiResult.failure(ServerFailure.fromDioError(e));
    } catch (e) {
      return ApiResult.failure(ServerFailure('Unexpected error occurred'));
    }
  }

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
