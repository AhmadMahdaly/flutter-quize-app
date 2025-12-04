import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/subscription/cubit/subscription_cubit.dart';
import 'package:smle/features/subscription/widgets/pay_done_dialog.dart';

class ApplePayScreen extends StatelessWidget {
  const ApplePayScreen({super.key, required this.total});
  final String total;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'pay_via_apple_pay'.tr(context)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.verticalSpace,
              Text(
                'apple_pay'.tr(context),
                style: AppTextStyle.style16Bold.copyWith(
                  fontSize: 16.sp,
                  decoration: TextDecoration.underline,
                ),
              ),
              15.verticalSpace,
              if (total != '')
                BlocBuilder<SubscriptionCubit, SubscriptionStates>(
                  builder: (context, state) {
                    return Text(
                      "${'payment_summary'.tr(context)} $total ${"sar".tr(context)}",
                      style: AppTextStyle.style16Bold.copyWith(fontSize: 16.sp),
                    );
                  },
                ),
              15.verticalSpace,
              Text(
                'subscribe_now'.tr(context),
                style: AppTextStyle.style14W500.copyWith(fontSize: 14.sp),
              ),
              160.verticalSpace,
              Center(
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const PayDoneDialog();
                      },
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      AppColors.secondaryColor,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: WidgetStateProperty.all(
                      const Size(double.infinity, 52),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.apple,
                        color: AppColors.greyColor,
                        size: 30.sp,
                      ),
                      5.horizontalSpace,
                      Text(
                        'pay'.tr(context),
                        style: AppTextStyle.style16Bold.copyWith(
                          color: AppColors.greyColor,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
