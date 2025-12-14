import 'package:dio/dio.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/play_list/data/model/play_list_model.dart';
import 'package:smle/features/q_bank/data/model/q_bank_model.dart';

class PlayListRepository {
  PlayListRepository(this._dioFactory);
  final DioFactory _dioFactory;

  Future<ApiResult<PlayListModel>> getPlayList() async {
    try {
      final response = await _dioFactory.get(endPoint: EndPoints.getPlayList);
      if (response!.statusCode == 200) {
        final PlayListModel model = PlayListModel.fromJson(response.data);
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

  Future<ApiResult<QBankModel>> getPlayListDetails({
    required String playlistId,
    int limit = 1, // افتراضي 1 لسؤال واحد
    int offset = 0,
  }) async {
    try {
      final response = await _dioFactory.post(
        endPoint: EndPoints.getPlayListDetails, // /playlist/questions
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

  Future<ApiResult> createPlayList(String name, int? questionId) async {
    try {
      final response = await _dioFactory.post(
        endPoint: EndPoints.createPlayList,
        data: questionId != null
            ? {'name': name, 'question_id[0]': questionId}
            : {'name': name},
      );
      if (response!.statusCode == 200) {
        return ApiResult.success(response);
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

  Future<ApiResult> deletePlayList(String playListID) async {
    try {
      final response = await _dioFactory.post(
        endPoint: EndPoints.deletePlayList,
        data: {'playlist_id': playListID},
      );
      if (response!.statusCode == 200) {
        return ApiResult.success(response);
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

  Future<ApiResult> addToPlayList(String playListID, String questionID) async {
    try {
      final response = await _dioFactory.post(
        endPoint: EndPoints.addToPlayList,
        data: {'playlist_id': playListID, 'question_id': questionID},
      );
      if (response!.statusCode == 200) {
        return ApiResult.success(response);
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

  Future<ApiResult> removeFromPlayList(
    String playListID,
    String questionID,
  ) async {
    try {
      final response = await _dioFactory.post(
        endPoint: EndPoints.removeQuestionFromPlaylist,
        data: {'playlist_id': playListID, 'question_id': questionID},
      );
      if (response!.statusCode == 200) {
        return ApiResult.success(response);
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

  Future<ApiResult> editPlayList(String playListID, String name) async {
    try {
      final response = await _dioFactory.post(
        endPoint: EndPoints.editPlayList,
        data: {'playlist_id': playListID, 'name': name},
      );
      if (response!.statusCode == 200) {
        return ApiResult.success(response);
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
}
