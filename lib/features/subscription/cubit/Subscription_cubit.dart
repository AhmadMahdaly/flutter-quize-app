import 'package:card_scanner/card_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/features/subscription/data/model/packages_model.dart';
import 'package:smle/features/subscription/data/repo/subscription_repo.dart';

import '../../../core/helpers/loading.dart';
import '../data/model/checkout_model.dart';
part 'Subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionStates> {
  SubscriptionCubit(this._subscriptionRepository)
      : super(SubscriptionInitialState());
  final SubscriptionRepository _subscriptionRepository;

  /// Get Packages
  PackagesModel? packagesModel;
  Future getPackages() async {
    showLoading();
    emit(GetPackagesLoadingState());
    final result = await _subscriptionRepository.getPackages();
    result.when(success: (success) {
      packagesModel = success;
      hideLoading();
      emit(GetPackagesSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(GetPackagesFailedState());
    });
  }

  /// Get Your Checkout
  CheckoutModel? yourCheckoutModel;
  TextEditingController promoCodeController=TextEditingController();
  Future getYourCheckout(String? packageId) async {
    showLoading();
    emit(GetYourCheckoutLoadingState());
    final result = await _subscriptionRepository.getYourCheckout(packageId,promoCodeController.text);
    result.when(success: (success) {
      yourCheckoutModel = success;
      hideLoading();
      emit(GetYourCheckoutSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(GetYourCheckoutFailedState());
    });
  }

  /// Set Selected Package
  String? selectedPackage;
  setSelectedPackage(String packageId){
    selectedPackage=packageId;
    emit(SetSelectedPackageState());
  }

  /// Scan Card To Pay
  Future<void> scanCard() async {
    final cardDetails = await CardScanner.scanCard(
      scanOptions: const CardScanOptions(
        scanCardHolderName: true, // Optional, to get the cardholder's name
        scanExpiryDate: true,    // Optional, to get the card's expiration date
        enableLuhnCheck: true,   // Optional, to validate card numbers

      ),
    );

    if (cardDetails != null) {
      print('Card Number: ${cardDetails.cardNumber}');
      print('Card Holder: ${cardDetails.cardHolderName}');
      print('Expiry Date: ${cardDetails.expiryDate}');
    } else {
      print('Card scan cancelled');
    }
  }

}
