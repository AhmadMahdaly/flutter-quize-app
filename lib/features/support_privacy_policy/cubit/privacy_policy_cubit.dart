import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/features/support_privacy_policy/data/model/privacy_support_model.dart';
import 'package:smle/features/support_privacy_policy/data/repo/privacy_support_repo.dart';

part 'privacy_policy_state.dart';

class PrivacyPolicySupportCubit extends Cubit<PrivacyPolicySupportStates> {
  PrivacyPolicySupportCubit(this._privacySupportRepository)
      : super(PrivacyPolicySupportInitialState());
  final PrivacySupportRepository _privacySupportRepository;

  /// Get Support
  PrivacySupportModel? supportModel;
  Future getSupport() async {
    showLoading();
    emit(GetSupportLoadingState());
    final result = await _privacySupportRepository.getSupport();
    result.when(success: (success) {
      supportModel = success;
      hideLoading();
      emit(GetSupportSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(GetSupportFailedState());
    });
  }

  /// Get Privacy Policy
  PrivacySupportModel? privacyPolicyModel;
  Future getPrivacyPolicy() async {
    showLoading();
    emit(GetPrivacyPolicyLoadingState());
    final result = await _privacySupportRepository.getPrivacyPolicy();
    result.when(success: (success) {
      privacyPolicyModel = success;
      hideLoading();
      emit(GetPrivacyPolicySuccessState());
    }, failure: (error) {
      hideLoading();
      emit(GetPrivacyPolicyFailedState());
    });
  }
}
