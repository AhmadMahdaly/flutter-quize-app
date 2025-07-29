import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/app_localization.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/subscription/cubit/Subscription_cubit.dart';
import '../../core/theme/colors.dart';

class AddCardScreen extends StatelessWidget {
  const AddCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'new_card'.tr(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.verticalSpace,
              Text(
                'enter_credit_card_info'.tr(context),
                style: interBold.copyWith(
                  fontSize: 16.sp,
                  decoration: TextDecoration.underline,
                ),
              ),
              50.verticalSpace,
              Center(
                child: TextButton(
                  onPressed: () {
                    context.read<SubscriptionCubit>().scanCard();
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.camera,
                        color: AppColors.greyColor,
                        size: 30.sp,
                      ),
                      5.horizontalSpace,
                      Text(
                        'scan_card'.tr(context),
                        style: interBold.copyWith(
                          color: AppColors.greyColor,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              30.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child:
                        Divider(height: 1.sp, color: AppColors.darkGreyColor),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w), // Add spacing around "or"
                    child: Text('or'.tr(context),
                        style: interRegular.copyWith(color: AppColors.darkGreyColor)),
                  ),
                  Expanded(
                    child:
                        Divider(height: 1.sp, color: AppColors.darkGreyColor),
                  ),
                ],
              ),
              30.verticalSpace,
              Text(
                'card_number'.tr(context),
                style: interMedium.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              10.verticalSpace,
              TextFormField(
                textAlign: TextAlign.center,
                style: interRegular.copyWith(color: AppColors.darkGreyColor),
                decoration: InputDecoration(
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
              20.verticalSpace,
              Text(
                'password'.tr(context),
                style: interMedium.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              10.verticalSpace,
              TextFormField(
                textAlign: TextAlign.center,
                style: interRegular.copyWith(color: AppColors.darkGreyColor),
                decoration: InputDecoration(
                    fillColor: AppColors.greyColor, // Background color
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
              20.verticalSpace,
              Text(
                'cvv'.tr(context),
                style: interMedium.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              10.verticalSpace,
              TextFormField(
                textAlign: TextAlign.center,
                style: interRegular.copyWith(color: AppColors.darkGreyColor),
                decoration: InputDecoration(
                    fillColor: AppColors.greyColor, // Background color
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
              20.verticalSpace,
              Text(
                'expiration_date'.tr(context),
                style: interMedium.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              10.verticalSpace,
              TextFormField(
                textAlign: TextAlign.center,
                style: interRegular.copyWith(color: AppColors.darkGreyColor),
                decoration: InputDecoration(
                    fillColor: AppColors.greyColor, // Background color
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
              20.verticalSpace,
              Center(
                child: TextButton(
                  onPressed: () {

                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(AppColors.secondaryColor),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: WidgetStateProperty.all(const Size(150, 52)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'add_card'.tr(context),
                    style: interBold.copyWith(
                      color: AppColors.greyColor,
                      fontSize: 16.sp,
                    ),
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
