import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class CustomPrimaryButton extends StatelessWidget {
  const CustomPrimaryButton({
    super.key,
    this.onPressed,
    required this.text,
    this.width,
  });
  final void Function()? onPressed;
  final String text;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.secondaryColor),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: WidgetStateProperty.all(Size(width ?? 300.w, 52.h)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyle.style16Bold.copyWith(
            color: AppColors.thirdColor,
            fontSize: SizeConfig.responsiveValue(phone: 16.sp, tablet: 20.sp),
          ),
        ),
      ),
    );
  }
}
