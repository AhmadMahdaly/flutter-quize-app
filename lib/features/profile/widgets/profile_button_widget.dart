import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/text_styles.dart';

class ProfileButtonWidget extends StatelessWidget {
  const ProfileButtonWidget({
    super.key,
    required this.imagePath,
    required this.text,
    this.onPressed,
    this.color,
    this.trailing,
  });

  final dynamic imagePath;
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.colorScheme.primary;

    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          height: SizeConfig.responsiveValue(phone: 45.h, tablet: 48.h),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: buttonColor.withAlpha(40),
            border: Border.all(color: buttonColor),
          ),
          child: Row(
            children: [
              imagePath.runtimeType != IconData
                  ? ImageIcon(
                      AssetImage(imagePath),
                      color: theme.colorScheme.onSurface,
                      size: SizeConfig.responsiveValue(
                        phone: 26.r,
                        tablet: 20.r,
                      ),
                    )
                  : Icon(
                      imagePath,
                      color: theme.colorScheme.onSurface,
                      size: SizeConfig.responsiveValue(
                        phone: 26.r,
                        tablet: 20.r,
                      ),
                    ),
              10.horizontalSpace,
              Text(
                text,
                style: AppTextStyle.style14W600.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),

              if (trailing != null) ...[const Spacer(), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}
