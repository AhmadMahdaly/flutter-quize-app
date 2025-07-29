import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class GuestLoginDialog extends StatelessWidget {
  const GuestLoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        6.verticalSpace,
        Text(
          textAlign: TextAlign.center,
          "Don't Miss Out!",
          style: interBold.copyWith(fontSize: 20.sp),
        ),
        Text(
          textAlign: TextAlign.center,
          'Sign in to explore our exclusive offers and enjoy the full experience.',
          style: interBold.copyWith(fontSize: 16.sp),
        ),
        8.verticalSpace,
        InkWell(
          onTap: () async {
            context.pop();
            context.pushReplacementNamed(Routes.loginScreen);
          },
          child: Container(
            width: 230.w,
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.greenColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              'Sign In / Register',
              textAlign: TextAlign.center,
              style: interBold.copyWith(
                fontSize: 16.sp,
                color: AppColors.offwhiteColor,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            context.pop();
            context.pushReplacementNamed(Routes.subscriptionScreen);
          },
          child: Container(
            width: 230.w,
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              'Preview Offers',
              textAlign: TextAlign.center,
              style: interBold.copyWith(
                fontSize: 16.sp,
                color: AppColors.offwhiteColor,
              ),
            ),
          ),
        ),
        6.verticalSpace,
      ],
    );
  }
}
