import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smle/core/helpers/safe_cubit.dart';
import 'package:smle/features/check_subscription/data/models/check_subscription_model.dart';
import 'package:smle/features/check_subscription/data/repo/check_subscription_repo.dart';

part 'check_subscription_state.dart';

class CheckSubscriptionCubit extends SafeCubit<CheckSubscriptionState> {
  CheckSubscriptionCubit(this.repository) : super(CheckSubscriptionInitial());
  final CheckSubscriptionRepository repository;
  CheckSubscriptionModel? checkSubscriptionModel;
  CheckAiAccessModel? checkAiAccessModel;
  // Future<void> loadSubscription() async {
  //   if (!isClosed) emit(SubscriptionLoading());

  //   final result = await repository.fetchSubscription();

  //   result.when(
  //     success: (data) {
  //       checkSubscriptionModel = data;
  //       if (!isClosed) emit(SubscriptionLoaded(data));
  //     },
  //     failure: (error) {
  //       if (!isClosed) emit(SubscriptionError(error.errMessage));
  //     },
  //   );
  // }

  // Future<void> loadAiSubscription() async {
  //   if (!isClosed) emit(SubscriptionAiLoading());

  //   final result = await repository.fetchAiSubscription();

  //   result.when(
  //     success: (data) {
  //       checkAiAccessModel = data;
  //       if (!isClosed) emit(SubscriptionAiLoaded(data));
  //     },
  //     failure: (error) {
  //       if (!isClosed) emit(SubscriptionAiError(error.errMessage));
  //     },
  //   );
  // }
  bool get isSubscribed => checkSubscriptionModel?.isSubscribed ?? false;

  bool get hasQBank => checkSubscriptionModel?.qBank ?? false;

  String get availableExam => checkSubscriptionModel?.availableRealExam ?? '0';

  bool get hasAiAccess => checkAiAccessModel?.status ?? false;
  Future<void> loadAllSubscriptions() async {
    if (!isClosed) emit(CheckSubscriptionsLoading());

    final subFuture = repository.fetchSubscription();
    final aiFuture = repository.fetchAiSubscription();

    final subResult = await subFuture;
    final aiResult = await aiFuture;

    bool hasError = false;
    String? errorMessage;

    subResult.when(
      success: (data) => checkSubscriptionModel = data,
      failure: (error) {
        hasError = true;
        errorMessage = error.errMessage;
      },
    );

    aiResult.when(
      success: (data) => checkAiAccessModel = data,
      failure: (error) {
        hasError = true;

        errorMessage ??= error.errMessage;
      },
    );

    if (!isClosed) {
      if (hasError) {
        emit(CheckSubscriptionsError(errorMessage ?? 'حدث خطأ غير متوقع'));
      } else {
        emit(CheckSubscriptionsLoaded());
      }
    }
  }
}
