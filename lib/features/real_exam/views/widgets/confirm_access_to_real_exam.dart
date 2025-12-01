import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/custom_primary_button.dart';
import 'package:smle/core/theme/colors.dart';

class ConfirmAccessToRealExam extends StatelessWidget {
  const ConfirmAccessToRealExam({
    super.key,
    required this.remainingAttempts,
    required this.onStart,
  });
  final int remainingAttempts;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Before You Start'),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Attempts Counter
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.successColor.withAlpha(20),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.secondaryColor),
              ),
              child: Row(
                children: [
                  Icon(Icons.timer, color: AppColors.greenColor, size: 24.r),
                  12.horizontalSpace,
                  Expanded(
                    child: Text(
                      'Remaining Attempts: ${'$remainingAttempts' == '1000' ? 'Unlimited' : '$remainingAttempts'}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.greenColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            30.verticalSpace,

            // Warning 1
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.errorColor,
                  size: 28.r,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    'Each attempt will be deducted from your balance once you start the exam.',
                    style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                  ),
                ),
              ],
            ),

            20.verticalSpace,
            // Warning 2
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.errorColor,
                  size: 28.r,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    'Do NOT close the page, exit the app, or interrupt the exam. Doing so will cost you an attempt.',
                    style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Start Button
            CustomPrimaryButton(onPressed: onStart, text: 'Start Exam'),
          ],
        ),
      ),
    );
  }
}
