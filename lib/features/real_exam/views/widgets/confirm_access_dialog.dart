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
    final theme = Theme.of(context);

    return Column(
      spacing: 8.h,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        12.verticalSpace,
        Text(
          textAlign: TextAlign.center,
          'Are You Ready To Start The Realistic Exam Simulation?',
          style: AppTextStyle.style20Bold.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
        12.verticalSpace,
        Row(
          spacing: 12.w,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  if (context.mounted) {
                    context.pop();
                  }
                  if (context.mounted) {
                    context.pushReplacementNamed(AppRoutes.realExamScreen);
                  }
                },
                child: Container(
                  height: 50.h,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    vertical: 8.r,
                    horizontal: 16.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'Yes',
                    style: AppTextStyle.style16Bold.copyWith(
                      color: AppColors.offwhiteColor,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  if (context.mounted) {
                    context.pop();
                  }
                },
                child: Container(
                  height: 50.h,

                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.errorColor.withAlpha(200),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'Not now',
                    style: AppTextStyle.style16Bold.copyWith(
                      color: AppColors.offwhiteColor,
                    ),
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
