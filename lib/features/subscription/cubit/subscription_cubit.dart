// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/functions/debug_print_extension.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/core/shared_widgets/custom_primary_dialog.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
import 'package:smle/features/check_subscription/data/models/check_subscription_model.dart';
import 'package:smle/features/main%20layout/data/model/profile_model.dart'
    hide Data;
import 'package:smle/features/main%20layout/data/repo/main_layout_repo.dart';
import 'package:smle/features/subscription/data/model/checkout_model.dart';
import 'package:smle/features/subscription/data/model/packages_model.dart';
import 'package:smle/features/subscription/data/repo/subscription_repo.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview_flutter;
import 'package:webview_flutter/webview_flutter.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionStates> {
  SubscriptionCubit(this._subscriptionRepository, this._mainLayoutRepository)
    : super(SubscriptionInitialState());

  final SubscriptionRepository _subscriptionRepository;
  final MainLayoutRepository _mainLayoutRepository;
  PackagesModel? packagesModel;
  PackagesModel? extraPackagesModel;

  Future<void> getPackages() async {
    showLoading();
    emit(GetPackagesLoadingState());
    final result = await _subscriptionRepository.getPackages();
    result.when(
      success: (success) {
        final allPackages = success.data ?? [];
        final extraPackages = allPackages
            .where((pkg) => pkg.isExtra == true)
            .toList();
        final normalPackages = allPackages
            .where((pkg) => pkg.isExtra != true)
            .toList();
        extraPackagesModel = PackagesModel(data: extraPackages);
        packagesModel = PackagesModel(data: normalPackages);

        hideLoading();
        if (!isClosed) emit(GetPackagesSuccessState());
      },
      failure: (error) {
        hideLoading();
        if (!isClosed) emit(GetPackagesFailedState());
      },
    );
  }

  CheckoutModel? checkoutData;
  CheckoutModel? giftCheckoutData;
  Future<void> getCheckoutDetails({required int offerId, String? code}) async {
    showLoading();
    emit(CheckoutLoadingState());
    final result = await _subscriptionRepository.checkout(
      offerId: offerId,
      code: code,
    );
    result.when(
      success: (data) {
        hideLoading();
        checkoutData = data;
        emit(CheckoutSuccessState(data));
      },
      failure: (error) {
        hideLoading();
        emit(CheckoutFailedState(error.errMessage));
      },
    );
  }

  Future<void> getGiftCheckoutDetails({
    required int offerId,
    String? code,
  }) async {
    showLoading();
    emit(CheckoutLoadingState());
    final result = await _subscriptionRepository.checkout(
      offerId: offerId,
      code: code,
    );
    result.when(
      success: (data) {
        hideLoading();
        giftCheckoutData = data;
        emit(CheckoutSuccessState(data));
      },
      failure: (error) {
        hideLoading();
        emit(CheckoutFailedState(error.errMessage));
      },
    );
  }

  double get finalPayment {
    final data = checkoutData?.data;
    if (data == null) return 0;

    final total = data.totalAfterCodeDiscount ?? 0;
    final points = (data.deductedPoints ?? 0) / 100;

    return total - points;
  }

  late webview_flutter.WebViewController webViewController;
  Future<void> startPayment(
    BuildContext context,
    int offerId,
    double amount,
    String? code,
    String paymentMethod, // إضافة المتغير هنا
  ) async {
    emit(PurchaseLoadingState());
    showLoading();

    final amountCents = amount * 100;
    await getProfile();

    final billingData = {
      'first_name': profileModel?.data?.name ?? '',
      'last_name': profileModel?.data?.id.toString() ?? '',
      'email': profileModel?.data?.email ?? '',
      'phone_number': '01000000000',
    };

    final result = await _subscriptionRepository.processPayment(
      offerId: offerId,
      amountCents: amountCents,
      billingData: billingData,
      paymentMethod: paymentMethod, // تمرير المتغير للـ Repo
      code: code,
    );

    hideLoading();

    result.when(
      success: (iframeUrl) {
        if (context.mounted) {
          _openPayMobWebView(context, iframeUrl);
        } else {
          log('Context is not mounted, cannot open WebView');
        }
      },
      failure: (error) {
        if (!isClosed) emit(PurchaseFailedState(error.errMessage));
      },
    );
  }

  void _openPayMobWebView(BuildContext context, String iframeUrl) {
    final ValueNotifier<bool> isLoading = ValueNotifier(true);

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            '✅ Page Started: $url'.dPrint();
            isLoading.value = true;
          },
          onPageFinished: (String url) {
            isLoading.value = false;

            if (url.startsWith(
              'https://ksa.paymob.com/unifiedcheckout/payment-status',
            )) {}

            if (url.startsWith('https://smlegate.com/payment/success')) {
              getIt<CheckSubscriptionCubit>().loadAllSubscriptions();

              if (!isClosed) {
                emit(PurchaseSuccessState());
              }

              Navigator.of(context).pop();
            }

            if (url.startsWith('https://smlegate.com/payment/failed')) {
              if (!isClosed) {
                emit(PurchaseFailedState('Payment failed'));
              }

              Navigator.of(context).pop();
            }
            '✅ Page loaded: $url'.dPrint();
          },
          onWebResourceError: (WebResourceError error) {
            '❌ Error: ${error.description}'.dPrint();
            isLoading.value = false;
          },
        ),
      )
      ..loadRequest(Uri.parse(iframeUrl));

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async {
          if (context.mounted) {
            final shouldExit = await showDialog<bool>(
              context: context,
              builder: (dialogContext) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.all(20.r),
                    margin: EdgeInsets.all(50.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: AppColors.thirdColor,
                    ),

                    child: CustomPrimaryDialog(
                      icon: Icons.error_outline_sharp,
                      title: 'Cancel',
                      description: 'Are you sure you want to cancel?',

                      confirmText: 'Yes',
                      onConfirm: () {
                        if (!isClosed) {
                          emit(PurchaseCancelledState());
                        }
                        Navigator.of(dialogContext).pop(true);
                      },

                      cancelText: 'No',
                      onCancel: () {
                        Navigator.of(dialogContext).pop(false);
                      },
                    ),
                  ),
                );
              },
            );
            return shouldExit ?? false;
          }
          return false;
        },
        child: Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () async => await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) {
                    return Center(
                      child: Container(
                        padding: EdgeInsets.all(20.r),
                        margin: EdgeInsets.all(50.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: AppColors.thirdColor,
                        ),

                        child: CustomPrimaryDialog(
                          icon: Icons.error_outline_sharp,
                          title: 'Cancel',
                          description: 'Are you sure you want to cancel?',

                          confirmText: 'Yes',
                          onConfirm: () {
                            if (!isClosed) {
                              emit(PurchaseCancelledState());
                            }
                            Navigator.of(dialogContext).pop(true);
                          },

                          cancelText: 'No',
                          onCancel: () {
                            Navigator.of(dialogContext).pop(false);
                          },
                        ),
                      ),
                    );
                  },
                ),
                icon: const Icon(Icons.close),
              ),
            ),
            body: Stack(
              children: [
                WebViewWidget(controller: controller),

                ValueListenableBuilder<bool>(
                  valueListenable: isLoading,
                  builder: (context, loading, child) {
                    if (loading) {
                      return Container(
                        color: Colors.white,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openPayGiftMobWebView(
    BuildContext context,
    String iframeUrl,
    int currentReceiverId,
  ) {
    final ValueNotifier<bool> isLoading = ValueNotifier(true);

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            '✅ Page Started: $url'.dPrint();
            isLoading.value = true;
          },
          onPageFinished: (String url) {
            isLoading.value = false;

            if (url.startsWith(
              'https://ksa.paymob.com/unifiedcheckout/payment-status',
            )) {}

            if (url.startsWith('https://smlegate.com/payment/success')) {
              getIt<CheckSubscriptionCubit>().loadAllSubscriptions();

              if (!isClosed) {
                emit(PurchaseSuccessState());
              }

              Navigator.of(context).pop();
            }

            if (url.startsWith('https://smlegate.com/payment/failed')) {
              if (!isClosed) {
                emit(PurchaseFailedState('Payment failed'));
              }

              Navigator.of(context).pop();
            }
            '✅ Page loaded: $url'.dPrint();
          },
          onWebResourceError: (WebResourceError error) {
            '❌ Error: ${error.description}'.dPrint();
            isLoading.value = false;
          },
        ),
      )
      ..loadRequest(Uri.parse(iframeUrl));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async {
          if (context.mounted) {
            final shouldExit = await showDialog<bool>(
              context: context,
              builder: (dialogContext) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.all(20.r),
                    margin: EdgeInsets.all(50.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: AppColors.thirdColor,
                    ),

                    child: CustomPrimaryDialog(
                      icon: Icons.error_outline_sharp,
                      title: 'Cancel',
                      description: 'Are you sure you want to cancel?',

                      confirmText: 'Yes',
                      onConfirm: () {
                        if (!isClosed) {
                          emit(PurchaseCancelledState());
                        }
                        Navigator.of(dialogContext).pop(true);
                      },

                      cancelText: 'No',
                      onCancel: () {
                        Navigator.of(dialogContext).pop(false);
                      },
                    ),
                  ),
                );
              },
            );

            return shouldExit ?? false;
          }
          return false;
        },
        child: Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () async => await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) {
                    return Center(
                      child: Container(
                        padding: EdgeInsets.all(20.r),
                        margin: EdgeInsets.all(50.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: AppColors.thirdColor,
                        ),

                        child: CustomPrimaryDialog(
                          icon: Icons.error_outline_sharp,
                          title: 'Cancel',
                          description: 'Are you sure you want to cancel?',

                          confirmText: 'Yes',
                          onConfirm: () {
                            if (!isClosed) {
                              emit(PurchaseCancelledState());
                            }
                            Navigator.of(dialogContext).pop(true);
                          },

                          cancelText: 'No',
                          onCancel: () {
                            Navigator.of(dialogContext).pop(false);
                          },
                        ),
                      ),
                    );
                  },
                ),
                icon: const Icon(Icons.close),
              ),
            ),
            body: Stack(
              children: [
                WebViewWidget(controller: controller),

                ValueListenableBuilder<bool>(
                  valueListenable: isLoading,
                  builder: (context, loading, child) {
                    if (loading) {
                      return Container(
                        color: Colors.white,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ProfileModel? profileModel;
  Future getProfile() async {
    emit(GetProfileLoadingState());
    final result = await _mainLayoutRepository.getProfile();
    result.when(
      success: (success) {
        profileModel = success;
        emit(GetProfileSuccessState());
      },
      failure: (error) {
        hideLoading();
        emit(GetProfileFailedState());
      },
    );
  }

  int? currentReceiverId;
  Future<void> checkGiftEmail(int offerId, String email) async {
    emit(CheckEmailLoadingState());
    final result = await _subscriptionRepository.checkGiftCheckout(
      offerId: offerId,
      email: email,
    );
    result.when(
      success: (receiverId) {
        currentReceiverId = receiverId; // حفظ الـ ID
        emit(CheckEmailSuccessState('User Verified'));
      },
      failure: (error) => emit(CheckEmailFailedState(error.errMessage)),
    );
  }

  Future<void> startGiftPaymentFlow(
    BuildContext context,
    int offerId,
    double amount,
    String? code,
    String paymentMethod, // إضافة المتغير هنا
  ) async {
    if (currentReceiverId == null) {
      emit(PurchaseFailedState('Please verify email first'));
      return;
    }

    emit(PurchaseLoadingState());
    showLoading();

    await getProfile();

    final result = await _subscriptionRepository.processGiftPayment(
      offerId: offerId,
      receiverId: currentReceiverId!,
      amountCents: amount * 100,
      payerName: profileModel?.data?.name ?? 'Guest',
      payerEmail: profileModel?.data?.email ?? '',
      payerPhone: '01000000000',
      code: code,
      paymentMethod: paymentMethod, // إرسال المتغير للـ Repo
    );

    hideLoading();
    result.when(
      success: (url) =>
          _openPayGiftMobWebView(context, url, currentReceiverId!),
      failure: (error) => emit(PurchaseFailedState(error.errMessage)),
    );
  }
}
