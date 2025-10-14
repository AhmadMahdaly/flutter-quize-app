import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/real_exam/data/model/finish_analysis_exam.dart';
import 'package:smle/features/real_exam/data/model/get_real_exam_model.dart';
import 'package:smle/features/real_exam/data/model/question_action_model.dart';

class RealExamRepo {
  RealExamRepo(this._dioFactory);
  final DioFactory _dioFactory;
  Future<ApiResult<StartRealExamModel>> startRealExam() async {
    final response = await _dioFactory.get(endPoint: EndPoints.startRealExam);
    if (response!.statusCode == 200) {
      final model = StartRealExamModel.fromJson(response.data);
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

  Future<ApiResult<StartRealExamModel>> getQuestion(
    int examId,
    int qNo,
    int section,
  ) async {
    final response = await _dioFactory.get(
      endPoint: '${EndPoints.getQuestion}$examId/$qNo/$section',
    );
    if (response!.statusCode == 200) {
      final model = StartRealExamModel.fromJson(response.data);
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

  Future<ApiResult<QuestionActionModel>> answerQuestion(
    String questionId,
    String answer,
  ) async {
    final response = await _dioFactory.post(
      endPoint: EndPoints.answerQuestion,
      data: {'question_id': questionId, 'answer': answer},
    );
    if (response!.statusCode == 200) {
      final model = QuestionActionModel.fromJson(response.data);
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

  Future<ApiResult<QuestionActionModel>> makeQuestionFlag(
    String questionId,
  ) async {
    final response = await _dioFactory.post(
      endPoint: EndPoints.makeQuestionFlag,
      data: {'question_id': questionId},
    );
    if (response!.statusCode == 200) {
      final model = QuestionActionModel.fromJson(response.data);
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

  Future<ApiResult<QuestionActionModel>> addQuestionNote(
    String questionId,
    String note,
  ) async {
    final response = await _dioFactory.post(
      endPoint: EndPoints.addQuestionNote,
      data: {'question_id': questionId, 'note': note},
    );
    if (response!.statusCode == 200) {
      final model = QuestionActionModel.fromJson(response.data);
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

  Future<ApiResult<FinishAnalysisExamModel>> finishAnalysisExam() async {
    final response = await _dioFactory.get(
      endPoint: EndPoints.finishAnalysisExam,
    );
    if (response!.statusCode == 200) {
      final model = FinishAnalysisExamModel.fromJson(response.data);
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
}
