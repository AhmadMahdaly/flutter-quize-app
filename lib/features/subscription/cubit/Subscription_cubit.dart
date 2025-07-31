import 'package:card_scanner/card_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/core/shared_widgets/debug_print_widget.dart';
import 'package:smle/features/subscription/data/model/cards_model.dart';
import 'package:smle/features/subscription/data/model/checkout_model.dart';
import 'package:smle/features/subscription/data/model/packages_model.dart';
import 'package:smle/features/subscription/data/repo/subscription_repo.dart';

part 'Subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionStates> {
  SubscriptionCubit(this._subscriptionRepository)
    : super(SubscriptionInitialState());
  final SubscriptionRepository _subscriptionRepository;

  /// Get Packages
  PackagesModel? packagesModel;
  PackagesModel? extraPackagesModel;

  Future getPackages() async {
    showLoading();
    emit(GetPackagesLoadingState());
    final result = await _subscriptionRepository.getPackages();
    result.when(
      success: (success) {
        // Assuming success is a list of package items
        final allPackages = success.data ?? [];
        // adjust according to your model
        // Separate based on isExtra
        final extraPackages = allPackages
            .where((pkg) => pkg.isExtra == true)
            .toList();
        final normalPackages = allPackages
            .where((pkg) => pkg.isExtra != true)
            .toList();
        // Create separate models if needed
        extraPackagesModel = PackagesModel(data: extraPackages);
        packagesModel = PackagesModel(data: normalPackages);

        hideLoading();
        emit(GetPackagesSuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(GetPackagesFailedState());
      },
    );
  }

  /// Get Your Checkout
  CheckoutModel? yourCheckoutModel;
  TextEditingController promoCodeController = TextEditingController();
  Future getYourCheckout(String? packageId) async {
    showLoading();
    emit(GetYourCheckoutLoadingState());
    final result = await _subscriptionRepository.getYourCheckout(
      packageId,
      promoCodeController.text,
    );
    result.when(
      success: (success) {
        if (success.data != null) {
          yourCheckoutModel = success;
        }
        hideLoading();
        emit(GetYourCheckoutSuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(GetYourCheckoutFailedState());
      },
    );
  }

  /// Set Selected Package
  String? selectedPackage;
  setSelectedPackage(String packageId) {
    selectedPackage = packageId;
    emit(SetSelectedPackageState());
  }

  /// Scan Card To Pay
  Future<void> scanCard() async {
    final cardDetails = await CardScanner.scanCard(
      scanOptions: const CardScanOptions(
        scanCardHolderName: true, // Optional, to get the cardholder's name
        scanExpiryDate: true, // Optional, to get the card's expiration date
        enableLuhnCheck: true, // Optional, to validate card numbers
      ),
    );

    if (cardDetails != null) {
      debugPrintWidget('Card Number: ${cardDetails.cardNumber}');
      debugPrintWidget('Card Holder: ${cardDetails.cardHolderName}');
      debugPrintWidget('Expiry Date: ${cardDetails.expiryDate}');

      cardIdController.text=cardDetails.cardNumber;
      expiryDateController.text=cardDetails.expiryDate;
    } else {
      debugPrintWidget('Card scan cancelled');
    }
  }

  /// Add Card
  TextEditingController cardIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  Future addCard() async {
    showLoading();
    emit(AddCardLoadingState());
    final result = await _subscriptionRepository.addCard(
      cardIdController.text,
      passwordController.text,
      cvvController.text,
      expiryDateController.text,
    );
    result.when(
      success: (success) {
        hideLoading();
        emit(AddCardSuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(AddCardFailedState());
      },
    );
  }

  /// Get Cards
  CardsModel? cardsModel;
  Future getCards() async {
    showLoading();
    emit(GetCardsLoadingState());
    final result = await _subscriptionRepository.getCards();
    result.when(
      success: (success) {
        cardsModel = success;
        hideLoading();
        emit(GetCardsSuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(GetCardsFailedState());
      },
    );
  }

  /// Delete Card
  Future deleteCard() async {
    showLoading();
    emit(DeleteCardLoadingState());
    final result = await _subscriptionRepository.deleteCard('');
    result.when(
      success: (success) {
        hideLoading();
        emit(DeleteCardSuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(DeleteCardFailedState());
      },
    );
  }
}
