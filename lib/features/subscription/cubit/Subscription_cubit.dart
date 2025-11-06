// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/debug_print_extension.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/features/subscription/data/model/packages_model.dart';
import 'package:smle/features/subscription/data/repo/subscription_repo.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview_flutter;
import 'package:webview_flutter/webview_flutter.dart';

part 'Subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionStates> {
  SubscriptionCubit(this._subscriptionRepository)
    : super(SubscriptionInitialState());

  final SubscriptionRepository _subscriptionRepository;

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

  late webview_flutter.WebViewController webViewController;

  Future<void> startPayMobPayment(
    BuildContext context,
    Data packageData,
  ) async {
    if (state is PurchaseLoadingState) return;
    emit(PurchaseLoadingState());
    showLoading();

    final amountCents = (packageData.price ?? 0) * 100;
    final result = await _subscriptionRepository.getPaymentKeyFromApp(
      amountCents,
    );

    hideLoading();

    result.when(
      success: (iframeUrl) {
        _openPayMobWebView(context, iframeUrl);
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
            final uri = Uri.parse(request.url);

            // ✅ الكشف الصحيح عن نجاح/فشل الدفع من PayMob السعودية
            if (uri.queryParameters.containsKey('success')) {
              Navigator.of(context).pop();

              if (uri.queryParameters['success'] == 'true') {
                if (!isClosed) emit(PurchaseSuccessState());
              } else {
                uri.queryParameters.dPrint();
                final message =
                    uri.queryParameters['message'] ??
                    uri.queryParameters['error'] ??
                    'فشل الدفع';
                if (!isClosed) emit(PurchaseFailedState(message));
              }
              return NavigationDecision.prevent;
            }

            // ✅ للتأكد من Callback URLs
            if (request.url.contains('your-callback-url')) {
              Navigator.of(context).pop();

              if (request.url.contains('success')) {
                if (!isClosed) emit(PurchaseSuccessState());
              } else {
                '${uri.queryParameters}  fail'.dPrint();
                if (!isClosed) emit(PurchaseFailedState('فشل الدفع'));
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
          // عند الضغط على زر الرجوع
          if (!isClosed) emit(PurchaseFailedState('تم إلغاء الدفع'));
          return true;
        },
        child: Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  if (!isClosed) emit(PurchaseFailedState('تم إلغاء الدفع'));
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
}
