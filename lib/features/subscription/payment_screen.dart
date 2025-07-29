import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/assets.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/subscription/cubit/Subscription_cubit.dart';
import 'package:smle/features/subscription/widgets/payment_details_widget.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'payment'.tr(context),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.verticalSpace,
              Text(
                'promotions'.tr(context),
                style: interBold.copyWith(
                  fontSize: 16.sp,
                  decoration: TextDecoration.underline,
                ),
              ),
              20.verticalSpace,
              Text(
                'redeem_promo_code'.tr(context),
                style: interMedium.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              10.verticalSpace,
              TextFormField(
                textAlign: TextAlign.center,
                style: interRegular.copyWith(color: AppColors.darkGreyColor),
                controller:
                    context.read<SubscriptionCubit>().promoCodeController,
                decoration: InputDecoration(
                    hintText: 'optional'.tr(context),
                    fillColor: AppColors.greyColor
                        .withOpacity(0.3), // Background color
                    filled: true, // Enables the background color
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40.r)),
                        borderSide:
                            const BorderSide(color: AppColors.greyColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40.r)),
                        borderSide:
                            const BorderSide(color: AppColors.greyColor)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40.r)),
                        borderSide:
                            const BorderSide(color: AppColors.greyColor))),
              ),
              30.verticalSpace,
              Center(
                child: TextButton(
                  onPressed: () {
                    context.read<SubscriptionCubit>().getYourCheckout(
                        '${context.read<SubscriptionCubit>().yourCheckoutModel!.data!.offerId}');
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(AppColors.secondaryColor),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: WidgetStateProperty.all(
                        const Size(double.infinity, 52)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'apply'.tr(context),
                    style: interBold.copyWith(
                      color: AppColors.thirdColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
              30.verticalSpace,
              BlocBuilder<SubscriptionCubit, SubscriptionStates>(
                builder: (context, state) {
                  return context.read<SubscriptionCubit>().yourCheckoutModel !=
                          null
                      ? context
                                  .read<SubscriptionCubit>()
                                  .yourCheckoutModel!
                                  .data !=
                              null
                          ? const PaymentDetailsWidget()
                          : const SizedBox.shrink()
                      : const SizedBox.shrink();
                },
              ),
              50.verticalSpace,
              Text(
                'add_your_payment_method'.tr(context),
                style: interBold.copyWith(
                  fontSize: 16.sp,
                  decoration: TextDecoration.underline,
                ),
              ),
              if(!Platform.isAndroid)
              50.verticalSpace,
              if(!Platform.isAndroid)
              Center(
                child: TextButton(
                  onPressed: () {
                    context.pushNamed(Routes.applePayScreen,
                        arguments:
                            '${context.read<SubscriptionCubit>().yourCheckoutModel!.data!.payments}');
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(AppColors.secondaryColor),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: WidgetStateProperty.all(
                        const Size(double.infinity, 52)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'pay_via_apple_pay'.tr(context),
                    style: interBold.copyWith(
                      color: AppColors.thirdColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
              25.verticalSpace,
              Center(
                child: TextButton(
                  onPressed: () {
                    context.pushNamed(Routes.addCardScreen);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(AppColors.secondaryColor),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: WidgetStateProperty.all(
                        const Size(double.infinity, 52)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'add_new_card'.tr(context),
                    style: interBold.copyWith(
                      color: AppColors.thirdColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
              50.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Assets.visa),
                  Image.asset(Assets.masterCard)
                ],
              )
            ],
          ),
        )));
  }
}
