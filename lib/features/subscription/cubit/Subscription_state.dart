part of 'Subscription_cubit.dart';

@immutable
abstract class SubscriptionStates {}

class SubscriptionInitialState extends SubscriptionStates {}

/// Get Packages
class GetPackagesLoadingState extends SubscriptionStates {}

class GetPackagesSuccessState extends SubscriptionStates {}

class GetPackagesFailedState extends SubscriptionStates {}

/// Set Selected Package
class SetSelectedPackageState extends SubscriptionStates {}
class GetStoreProductsLoadingState extends SubscriptionStates {}
class GetStoreProductsSuccessState extends SubscriptionStates {}
class GetStoreProductsFailedState extends SubscriptionStates {
  GetStoreProductsFailedState(this.message);
  final String message;
}

// Purchase States
class PurchaseLoadingState extends SubscriptionStates {}
class PurchaseVerificationLoadingState extends SubscriptionStates {}
class PurchaseSuccessState extends SubscriptionStates {}
class PurchaseFailedState extends SubscriptionStates {
  PurchaseFailedState( this.message);
  final String message;
}