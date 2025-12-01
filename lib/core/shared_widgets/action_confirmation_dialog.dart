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
    this.cancelText = 'Not now',
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
            6.verticalSpace,
            Text(
              title,
              textAlign: TextAlign.center,
              style: interBold.copyWith(fontSize: 20.sp),
            ),
            12.verticalSpace,
            Row(
              spacing: 12.w,
              mainAxisSize: MainAxisSize.min,
              children: [
                // زر التأكيد (Yes)
                TextButton(
                  onPressed: () {
                    context.pop(); // نغلق الديالوج أولاً
                    onConfirm(); // ثم ننفذ الدالة
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.r,
                      horizontal: 16.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors
                          .successColor, // يمكنك تغيير اللون للأحمر عند الحذف إذا أردت
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      confirmText,
                      style: interBold.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.offwhiteColor,
                      ),
                    ),
                  ),
                ),
                // زر الإلغاء (Not now)
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
                      cancelText,
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
        ),
      ),
    );
  }
}
