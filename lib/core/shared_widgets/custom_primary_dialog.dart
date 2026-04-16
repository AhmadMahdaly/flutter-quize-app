import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/text_styles.dart';

void showCustomPrimaryDialog(
  BuildContext context, {
  required Widget widget,
  bool canPop = true,
}) {
  if (context.mounted) {
    final theme = Theme.of(context);

    showDialog<void>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: canPop,
      builder: (context) {
        return PopScope(
          canPop: canPop,
          child: Dialog(
            backgroundColor: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(padding: EdgeInsets.all(16.r), child: widget),
          ),
        );
      },
    );
  }
}

class CustomPrimaryDialog extends StatelessWidget {
  const CustomPrimaryDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmText,
    required this.onConfirm,
    this.cancelText,
    this.onCancel,
    this.icon,
    this.iconColor,
  });
  final String title;
  final String description;
  final String confirmText;
  final VoidCallback onConfirm;
  final String? cancelText;
  final VoidCallback? onCancel;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 48.sp,
              color: iconColor ?? theme.colorScheme.primary,
            ),
            12.verticalSpace,
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyle.style16Bold.copyWith(
              fontSize: SizeConfig.responsiveValue(phone: 18.sp, tablet: 22.sp),
              color: theme.colorScheme.primary,
            ),
          ),
          12.verticalSpace,
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyle.style14W500.copyWith(
              fontSize: SizeConfig.responsiveValue(phone: 14.sp, tablet: 16.sp),
              color: theme.colorScheme.onSurface,
            ),
          ),
          24.verticalSpace,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (cancelText != null)
                Expanded(
                  child: TextButton(
                    onPressed: onCancel ?? () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurface,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(cancelText!, style: AppTextStyle.style14W600),
                  ),
                ),
              if (cancelText != null) 12.horizontalSpace,
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    confirmText,
                    style: AppTextStyle.style14Bold.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
