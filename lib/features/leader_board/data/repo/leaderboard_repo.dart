import 'package:dio/dio.dart';
import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/features/leader_board/data/models/leaderboard_model.dart';

class LeaderboardRepo {
  LeaderboardRepo(this._dioFactory);
  final DioFactory _dioFactory;

  Future<ApiResult<LeaderboardResponse>> getLeaderboard() async {
    try {
      final response = await _dioFactory.get(endPoint: EndPoints.leaderBoard);

      final leaderboardResponse = LeaderboardResponse.fromJson(response?.data);

      return ApiResult.success(leaderboardResponse);
    } on DioException catch (e) {
      return ApiResult.failure(ServerFailure.fromDioError(e));
    } catch (e) {
      return ApiResult.failure(ServerFailure('Unexpected error occurred'));
    }
  }
}
