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
  Future<void> loadSubscription() async {
    if (!isClosed) emit(SubscriptionLoading());

    final result = await repository.fetchSubscription();

    result.when(
      success: (data) {
        checkSubscriptionModel = data;
        if (!isClosed) emit(SubscriptionLoaded(data));
      },
      failure: (error) {
        if (!isClosed) emit(SubscriptionError(error.errMessage));
      },
    );
  }
}
