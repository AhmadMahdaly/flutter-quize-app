import 'package:smle/features/play_list/data/model/play_list_model.dart';

import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';

class PlayListRepository {

  PlayListRepository(this._dioFactory);
  final DioFactory _dioFactory;

  Future<ApiResult<PlayListModel>> getPlayList() async {
    final response = await _dioFactory.get(endPoint: EndPoints.getPlayList);
    if (response!.statusCode == 200 ) {
      final PlayListModel model = PlayListModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['message']);
      return ApiResult.failure(
          ServerFailure.fromResponse(response.statusCode, response.data['message']));
    }
  }

  Future<ApiResult<PlayListModel>> getPlayListDetails() async {
    final response = await _dioFactory.get(endPoint: EndPoints.getPlayListDetails);
    if (response!.statusCode == 200 ) {
      final PlayListModel model = PlayListModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget(response.data['message']);
      return ApiResult.failure(
          ServerFailure.fromResponse(response.statusCode, response.data['message']));
    }
  }

  Future<ApiResult> createPlayList(String name,int? questionId) async {
    final response = await _dioFactory.post(endPoint: EndPoints.createPlayList,data:
    questionId!=null?
    {
      'name':name,
      'question_id':[questionId],
    }:{
      'name':name,
    });
    if (response!.statusCode == 200 ) {
      return ApiResult.success(response);
    } else {
      debugPrintWidget(response.data['message']);
      return ApiResult.failure(
          ServerFailure.fromResponse(response.statusCode, response.data['message']));
    }
  }

  Future<ApiResult> deletePlayList(String playListID) async {
    final response = await _dioFactory.post(endPoint: EndPoints.deletePlayList,data: {
      'playlist_id':playListID,
    });
    if (response!.statusCode == 200 ) {
      return ApiResult.success(response);
    } else {
      debugPrintWidget(response.data['message']);
      return ApiResult.failure(
          ServerFailure.fromResponse(response.statusCode, response.data['message']));
    }
  }

  Future<ApiResult> editPlayList(String playListID,String name) async {
    final response = await _dioFactory.post(endPoint: EndPoints.editPlayList,data: {
      'playlist_id':playListID,
      'name':name
    });
    if (response!.statusCode == 200 ) {
      return ApiResult.success(response);
    } else {
      debugPrintWidget(response.data['message']);
      return ApiResult.failure(
          ServerFailure.fromResponse(response.statusCode, response.data['message']));
    }
  }
}