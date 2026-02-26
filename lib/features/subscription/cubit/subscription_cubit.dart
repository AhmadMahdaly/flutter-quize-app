// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/functions/debug_print_extension.dart';
import 'package:smle/core/helpers/loading.dart';
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

  late webview_flutter.WebViewController webViewController;
  Future<void> startPayMobPayment(
    BuildContext context,
    int offerId,
    int amount,
    String? code,
  ) async {
    emit(PurchaseLoadingState());
    showLoading();

    final amountCents = amount * 100; // المبلغ القادم هنا هو الإجمالي بعد الخصم
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
      code: code, // إرسال الكود
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
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            '✅ Page Started: $url'.dPrint();
          },
          onPageFinished: (String url) {
            if (url.startsWith(
              'https://ksa.paymob.com/unifiedcheckout/payment-status',
            )) {}

            if (url.startsWith('https://smlegate.com/payment/success')) {
              log('hkjlhnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn');
              getIt<CheckSubscriptionCubit>().loadSubscription();

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
          },
        ),
      )
      ..loadRequest(Uri.parse(iframeUrl));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async {
          if (!isClosed) {
            // emit(PurchaseCancelledState());
            // Navigator.pop(context);
          }

          return true;
        },
        child: Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              leading: TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  emit(PurchaseCancelledState());

                  Navigator.pop(context);
                },
              ),
            ),
            body: WebViewWidget(controller: controller),
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
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            final uri = Uri.parse(request.url);

            if (uri.queryParameters.containsKey('success')) {
              // await _subscriptionRepository.processPaymentCallbackGift(
              //   billingData: uri.queryParameters,
              //   currentReceiverId: currentReceiverId,
              // );
              log(uri.queryParameters.toString());

              // context.pop();
              if (uri.queryParameters['success'] == 'true') {
                if (!isClosed) emit(PurchaseSuccessState());
              } else {
                uri.queryParameters.dPrint();
                final message =
                    uri.queryParameters['message'] ??
                    uri.queryParameters['error'] ??
                    'Payment failed';
                message.dPrint();
                if (!isClosed) emit(PurchaseFailedState(message));
              }
              return NavigationDecision.prevent;
            }
            if (request.url.contains('your-callback-url')) {
              // context.pop();

              if (request.url.contains('success')) {
                if (!isClosed) emit(PurchaseSuccessState());
              } else {
                '${uri.queryParameters}  fail'.dPrint();
                if (!isClosed) emit(PurchaseFailedState('Payment failed'));
              }
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            '🔄 Page started: $url'.dPrint();
          },
          onPageFinished: (String url) {
            '✅ Page loaded: $url'.dPrint();
          },
          onWebResourceError: (WebResourceError error) {
            '❌ Error: ${error.description}'.dPrint();
          },
        ),
      )
      ..loadRequest(Uri.parse(iframeUrl));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async {
          if (!isClosed) emit(PurchaseFailedState('Payment cancelled'));
          return true;
        },
        child: Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close, color: AppColors.secondaryColor),
                onPressed: () {
                  if (!isClosed) emit(PurchaseFailedState('Payment cancelled'));
                  Navigator.pop(context);
                },
              ),
            ),
            body: WebViewWidget(controller: controller),
          ),
        ),
      ),
    );
  }

  /// Get Profile
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
  // داخل SubscriptionCubit

  int? currentReceiverId; // لحفظ الـ ID المستلم بعد الـ checkout

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
    int amount,
  ) async {
    if (currentReceiverId == null) {
      emit(PurchaseFailedState('Please verify email first'));
      return;
    }

    emit(PurchaseLoadingState());
    showLoading();

    // جلب بيانات الدافع (Payer) من البروفايل
    await getProfile();

    final result = await _subscriptionRepository.processGiftPayment(
      offerId: offerId,
      receiverId: currentReceiverId!,
      amountCents: amount * 100,
      payerName: profileModel?.data?.name ?? 'Guest',
      payerEmail: profileModel?.data?.email ?? '',
      payerPhone: '01000000000', // أو من البروفايل إذا متاح
    );

    hideLoading();
    result.when(
      success: (url) =>
          _openPayGiftMobWebView(context, url, currentReceiverId!),
      failure: (error) => emit(PurchaseFailedState(error.errMessage)),
    );
  }
}
