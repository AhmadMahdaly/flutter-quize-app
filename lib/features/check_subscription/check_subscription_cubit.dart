import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smle/core/helpers/safe_cubit.dart';
import 'package:smle/features/check_subscription/data/models/check_subscription_model.dart';
import 'package:smle/features/check_subscription/data/repo/check_subscription_repo.dart';

part 'check_subscription_state.dart';

class CheckSubscriptionCubit extends SafeCubit<CheckSubscriptionState> {
  CheckSubscriptionCubit(this.repository) : super(CheckSubscriptionInitial());
  final CheckSubscriptionRepository repository;

  Future<void> loadSubscription() async {
    if (!isClosed) emit(SubscriptionLoading());
    try {
      final subscription = await repository.fetchSubscription();
      if (!isClosed) emit(SubscriptionLoaded(subscription));
    } catch (e) {
      if (!isClosed) emit(SubscriptionError(e.toString()));
    }
  }
}
