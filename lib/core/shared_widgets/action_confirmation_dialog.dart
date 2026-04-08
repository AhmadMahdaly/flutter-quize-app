import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/helpers/extensions.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class ActionConfirmationDialog extends StatelessWidget {
  const ActionConfirmationDialog({
    super.key,
    required this.title,
    required this.onConfirm,
    this.confirmText = 'Yes',
    this.cancelText = 'No',
  });

  final String title;
  final VoidCallback onConfirm;
  final String confirmText;
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // نستخدم Dialog هنا لتغليف المحتوى
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          spacing: 8.h,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            12.verticalSpace,
            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360.r),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: AppColors.errorColor.withAlpha(200),
                size: 56.r,
              ),
            ),
            12.verticalSpace,
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyle.style20Bold,
            ),
            10.verticalSpace,
            Row(
              spacing: 12.w,
              mainAxisSize: MainAxisSize.min,
              children: [
                // زر التأكيد (Yes)
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      context.pop(); // نغلق الديالوج أولاً
                      onConfirm(); // ثم ننفذ الدالة
                    },
                    child: Container(
                      height: 40.h,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        vertical: 8.r,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors
                            .greenColor, // يمكنك تغيير اللون للأحمر عند الحذف إذا أردت
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: FittedBox(
                        child: Text(
                          confirmText,
                          style: AppTextStyle.style16Bold.copyWith(
                            color: AppColors.offwhiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // زر الإلغاء (Not now)
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Container(
                      height: 40.h,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppColors.errorColor.withAlpha(200),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: FittedBox(
                        child: Text(
                          cancelText,
                          style: AppTextStyle.style16Bold.copyWith(
                            color: AppColors.offwhiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
