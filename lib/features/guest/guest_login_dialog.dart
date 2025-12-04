import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
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
          style: AppTextStyle.style20Bold,
        ),
        Text(
          textAlign: TextAlign.center,
          'Sign in to explore our exclusive offers and enjoy the full experience.',
          style: AppTextStyle.style16Bold,
        ),
        8.verticalSpace,
        InkWell(
          onTap: () async {
            context.pop();
            context.pushReplacementNamed(AppRoutes.loginScreen);
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
              style: AppTextStyle.style16Bold.copyWith(
                color: AppColors.offwhiteColor,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            context.pop();
            context.pushReplacementNamed(AppRoutes.subscriptionScreen);
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
              style: AppTextStyle.style16Bold.copyWith(
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
