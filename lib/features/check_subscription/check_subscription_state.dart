part of 'check_subscription_cubit.dart';

@immutable
abstract class CheckSubscriptionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckSubscriptionInitial extends CheckSubscriptionState {}

class SubscriptionLoading extends CheckSubscriptionState {}

class SubscriptionLoaded extends CheckSubscriptionState {
  SubscriptionLoaded(this.subscription);
  final CheckSubscriptionModel subscription;

  @override
  List<Object?> get props => [subscription];
}

class SubscriptionError extends CheckSubscriptionState {
  SubscriptionError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
