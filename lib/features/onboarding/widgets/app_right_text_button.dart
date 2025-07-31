import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class AppRightIconTextButton extends StatelessWidget {
  const AppRightIconTextButton({
    super.key,
    this.width = double.infinity,
    this.height,
    this.buttonColor,
    required this.title,
    this.onTap,
    this.titleColor,
    this.icon,
    this.fontSize,
    required this.isBorder,
  });
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? buttonColor;
  final String title;
  final IconData? icon;
  final Color? titleColor;
  final bool isBorder;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 25.h,
        width: width ?? 60.w,
        decoration: BoxDecoration(
          color: buttonColor ?? Theme.of(context).cardColor,
          border: Border.all(
            color: isBorder
                ? Theme.of(context).disabledColor
                : Colors.transparent,
          ),
        ),
        child: FittedBox(
          child: Text(
            title,
            style: interRegular.copyWith(
              color: titleColor ?? AppColors.forthColor,
              fontSize:
                  fontSize ??
                  SizeConfig.responsiveValue(phone: 15.sp, tablet: 19.sp),
            ),
          ),
        ),
      ),
    );
  }
}
