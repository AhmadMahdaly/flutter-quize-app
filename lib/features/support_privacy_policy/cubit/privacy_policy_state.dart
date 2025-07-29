part of 'privacy_policy_cubit.dart';

@immutable
abstract class PrivacyPolicySupportStates {}

class PrivacyPolicySupportInitialState extends PrivacyPolicySupportStates {}

/// Get Support
class GetSupportLoadingState extends PrivacyPolicySupportStates {}

class GetSupportSuccessState extends PrivacyPolicySupportStates {}

class GetSupportFailedState extends PrivacyPolicySupportStates {}

/// Get Privacy Policy
class GetPrivacyPolicyLoadingState extends PrivacyPolicySupportStates {}

class GetPrivacyPolicySuccessState extends PrivacyPolicySupportStates {}

class GetPrivacyPolicyFailedState extends PrivacyPolicySupportStates {}
