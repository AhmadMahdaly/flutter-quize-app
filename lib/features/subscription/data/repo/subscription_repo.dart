import 'package:smle/core/network/api_result.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/core/network/end_points.dart';
import 'package:smle/core/network/failures.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/subscription/data/model/cards_model.dart';
import 'package:smle/features/subscription/data/model/checkout_model.dart';
import 'package:smle/features/subscription/data/model/packages_model.dart';

class SubscriptionRepository {
  SubscriptionRepository(this._dioFactory);
  final DioFactory _dioFactory;

  Future<ApiResult<PackagesModel>> getPackages() async {
    final response = await _dioFactory.get(endPoint: EndPoints.getPackages);
    if (response!.statusCode == 200) {
      final PackagesModel model = PackagesModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      // debugPrintWidget(response.data['message']);
      return ApiResult.failure(
        ServerFailure.fromResponse(
          response.statusCode,
          response.data['message'],
        ),
      );
    }
  }

  Future<ApiResult<CheckoutModel>> getYourCheckout(
    String? offerId,
    String promoCode,
  ) async {
    final response = await _dioFactory.post(
      endPoint: EndPoints.getYourCheckout,
      data: promoCode.isEmpty
          ? {'offer_id': offerId}
          : {'offer_id': offerId, 'code': promoCode},
    );
    if (response!.statusCode == 200 ) {
      final CheckoutModel model = CheckoutModel.fromJson(response.data);
      return ApiResult.success(model);
    } else {
      debugPrintWidget('${response.data['message']}');
      return ApiResult.failure(
        ServerFailure.fromResponse(
          response.statusCode,
          response.data['message'],
        ),
      );
    }
  }

  Future<ApiResult> addCard(
    String cardId,
    String password,
    String cvv,
    String expireDate,
  ) async {
    final response = await _dioFactory.post(
      endPoint: EndPoints.addCard,
      data: {
        'card_id': cardId,
        'password': password,
        'exp_date': expireDate,
        'cvv': cvv,
      },
    );
    if (response!.statusCode == 200) {
      return ApiResult.success(response.data['message']);
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

  Future<ApiResult<CardsModel>> getCards() async {
    final response = await _dioFactory.get(endPoint: EndPoints.getCards);
    if (response!.statusCode == 200) {
      final CardsModel model = CardsModel.fromJson(response.data);
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

  Future<ApiResult> deleteCard(String cardId) async {
    final response = await _dioFactory.get(
      endPoint: '${EndPoints.deleteCard}$cardId',
    );
    if (response!.statusCode == 200) {
      return ApiResult.success(response.data['message']);
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
