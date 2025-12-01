import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class ConfirmAccessToRealExamDialogWidget extends StatelessWidget {
  const ConfirmAccessToRealExamDialogWidget({super.key});

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
          'Are You Ready To Start The Real Exam?',
          style: interBold.copyWith(fontSize: 20.sp),
        ),

        Row(
          spacing: 12.w,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () async {
                context.pop();
                context.pushNamed(Routes.realExamScreen);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.successColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'Yes',
                  style: interBold.copyWith(
                    fontSize: 16.sp,
                    color: AppColors.offwhiteColor,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.errorColor.withAlpha(200),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'Not now',
                  style: interBold.copyWith(
                    fontSize: 16.sp,
                    color: AppColors.offwhiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
