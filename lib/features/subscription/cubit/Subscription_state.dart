part of 'Subscription_cubit.dart';

@immutable
abstract class SubscriptionStates {}

class SubscriptionInitialState extends SubscriptionStates {}

/// Get Packages
class GetPackagesLoadingState extends SubscriptionStates {}

class GetPackagesSuccessState extends SubscriptionStates {}

class GetPackagesFailedState extends SubscriptionStates {}

/// Get Your Checkout
class GetYourCheckoutLoadingState extends SubscriptionStates {}

class GetYourCheckoutSuccessState extends SubscriptionStates {}

class GetYourCheckoutFailedState extends SubscriptionStates {}

/// Set Selected Package
class SetSelectedPackageState extends SubscriptionStates {}
