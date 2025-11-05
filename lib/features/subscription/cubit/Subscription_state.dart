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
