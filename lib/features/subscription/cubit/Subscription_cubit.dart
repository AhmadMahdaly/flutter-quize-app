import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/features/subscription/data/model/packages_model.dart';
import 'package:smle/features/subscription/data/repo/subscription_repo.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

part 'Subscription_state.dart';
class SubscriptionCubit extends Cubit<SubscriptionStates> {
  SubscriptionCubit(this._subscriptionRepository)
      : super(SubscriptionInitialState()) {
    _initializeInAppPurchase();
  }

  final SubscriptionRepository _subscriptionRepository;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // قائمة المنتجات التي تم جلبها من App Store
  List<ProductDetails> storeProducts = [];
  // قائمة الباقات من السيرفر الخاص بك
  PackagesModel? packagesModel;
  PackagesModel? extraPackagesModel;

  // تهيئة والاستماع لتحديثات عمليات الشراء
  void _initializeInAppPurchase() {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  // 1. جلب الباقات من سيرفرك
  Future<void> getPackages() async {
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
        if (!isClosed)    emit(GetPackagesSuccessState());
      },
      failure: (error) {
        hideLoading();
        if (!isClosed)    emit(GetPackagesFailedState());
      },
    );
    // بعد النجاح، قم بجلب المنتجات المقابلة من متجر Apple
    if (state is GetPackagesSuccessState) {
      final allPackages = (packagesModel?.data ?? []) + (extraPackagesModel?.data ?? []);
      // افترض أن الموديل Data يحتوي على product_id من Apple Store
      // مثال: data.appleProductId
      // يجب أن تضيف حقل `apple_product_id` أو ما شابه في الـ API Response
      final productIds = allPackages.map((pkg) => pkg.appleProductId).whereType<String>().toSet();
      await getStoreProducts(productIds);
    }
  }

  // 2. جلب تفاصيل المنتجات من App Store
  Future<void> getStoreProducts(Set<String> productIds) async {
    if (!isClosed) emit(GetStoreProductsLoadingState());
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      if (!isClosed)   emit(GetStoreProductsFailedState('Store not available'));
      return;
    }
    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds);
    if (response.error != null) {
      if (!isClosed)  emit(GetStoreProductsFailedState(response.error!.message));
      return;
    }
    storeProducts = response.productDetails;
    if (!isClosed)  emit(GetStoreProductsSuccessState());
  }

  // 3. بدء عملية الشراء
  Future<void> buyPackage(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    // أو buyConsumable إذا كان المنتج استهلاكياً
  }

  // 4. الاستماع لنتائج عملية الشراء
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        if (!isClosed)    emit(PurchaseLoadingState());
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        if (!isClosed)    emit(PurchaseFailedState(purchaseDetails.error?.message ?? "An error occurred"));
      } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
        _handleSuccessfulPurchase(purchaseDetails);
      }
    }
  }

  // 5. معالجة الشراء الناجح والتحقق منه
  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) async {
    if (!isClosed) emit(PurchaseVerificationLoadingState());

    final String receipt = purchaseDetails.verificationData.serverVerificationData;
    final String source = Platform.isIOS ? 'apple' : 'google';

    final result = await _subscriptionRepository.verifyPurchaseWithBackend(
        source, receipt, purchaseDetails.productID);

    result.when(
      success: (isVerified) {
        if (isVerified) {
          // تم التحقق بنجاح من جهة السيرفر
          if (!isClosed)     emit(PurchaseSuccessState());
          // **مهم جداً**: إعلام Apple بأنك قد قمت بمعالجة الشراء
          _inAppPurchase.completePurchase(purchaseDetails);
        } else {
          if (!isClosed)   emit(PurchaseFailedState('Verification failed'));
        }
      },
      failure: (error) {
        if (!isClosed)   emit(PurchaseFailedState(error.errMessage ));
      },
    );
  }
}