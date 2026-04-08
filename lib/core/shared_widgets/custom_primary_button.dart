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
          backgroundColor: WidgetStateProperty.all(
            AppColors.forthColor.withAlpha(150),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: WidgetStateProperty.all(Size(width ?? 300.w, 52.h)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyle.style16Bold.copyWith(
            color: AppColors.thirdColor.withAlpha(200),
            fontSize: SizeConfig.responsiveValue(phone: 16.sp, tablet: 20.sp),
          ),
        ),
      ),
    );
  }
}

class CustomPrimaryVButton extends StatelessWidget {
  const CustomPrimaryVButton({
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
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.primaryColor),
          // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // minimumSize: WidgetStateProperty.all(Size(width ?? 300.w, 52.h)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            12.horizontalSpace,
            Text(
              textAlign: TextAlign.center,
              text,
              style: AppTextStyle.style16Bold.copyWith(
                color: AppColors.secondaryColor,
                fontSize: SizeConfig.responsiveValue(
                  phone: 16.sp,
                  tablet: 20.sp,
                ),
              ),
            ),
            8.horizontalSpace,
            Icon(
              Icons.arrow_forward_rounded,
              size: 24.r,
              color: AppColors.secondaryColor,
            ),
            12.horizontalSpace,
          ],
        ),
      ),
    );
  }
}

class CustomPrimaryHButton extends StatelessWidget {
  const CustomPrimaryHButton({
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
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.primaryColor),
          // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // minimumSize: WidgetStateProperty.all(Size(width ?? 300.w, 52.h)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            6.horizontalSpace,
            Text(
              textAlign: TextAlign.center,
              text,
              style: AppTextStyle.style16Bold.copyWith(
                color: AppColors.thirdColor.withAlpha(200),
                fontSize: SizeConfig.responsiveValue(
                  phone: 16.sp,
                  tablet: 20.sp,
                ),
              ),
            ),

            6.horizontalSpace,
          ],
        ),
      ),
    );
  }
}
