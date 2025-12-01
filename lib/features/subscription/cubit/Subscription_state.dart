part of 'Subscription_cubit.dart';

@immutable
abstract class SubscriptionStates {}

class SubscriptionInitialState extends SubscriptionStates {}

class GetPackagesLoadingState extends SubscriptionStates {}

class GetPackagesSuccessState extends SubscriptionStates {}

class GetPackagesFailedState extends SubscriptionStates {}

class PurchaseLoadingState extends SubscriptionStates {}

class PurchaseSuccessState extends SubscriptionStates {}

class PurchaseFailedState extends SubscriptionStates {
  PurchaseFailedState(this.message);
  final String message;
}

/// Get Profile
class GetProfileLoadingState extends SubscriptionStates {}

class GetProfileSuccessState extends SubscriptionStates {}

class GetProfileFailedState extends SubscriptionStates {}

///  Subscription States for CheckSubscriptionCubit
class SubscriptionLoading extends SubscriptionStates {}

class SubscriptionLoaded extends SubscriptionStates {
  SubscriptionLoaded(this.subscription);
  final CheckSubscriptionModel subscription;

  List<Object?> get props => [subscription];
}

class SubscriptionError extends SubscriptionStates {
  SubscriptionError(this.message);
  final String message;

  List<Object?> get props => [message];
}
