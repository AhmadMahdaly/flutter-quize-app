import 'package:dio/dio.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/features/chat_message/data/models/chat_message_model.dart';

class ChatRepo {
  ChatRepo(this._dioFactory);
  final DioFactory _dioFactory;

  Future<ApiResult<ChatMessage>> sendMessage(String text) async {
    try {
      final response = await _dioFactory.post(
        endPoint: EndPoints.chat,
        data: {'message': text},
      );

      final chatResponse = ChatMessage.fromBotJson(response?.data);

      return ApiResult.success(chatResponse);
    } on DioException catch (e) {
      return ApiResult.failure(ServerFailure.fromDioError(e));
    } catch (e) {
      return ApiResult.failure(ServerFailure('Unexpected error occurred'));
    }
  }
}
