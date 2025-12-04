import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class ProfileButtonWidget extends StatelessWidget {
  const ProfileButtonWidget({
    super.key,
    required this.imagePath,
    required this.text,
    this.onPressed,
    this.color = AppColors.secondaryColor,
  });
  final dynamic imagePath;
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          height: 40.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: color,
          ),
          child: Row(
            children: [
              imagePath.runtimeType != IconData
                  ? ImageIcon(
                      AssetImage(imagePath),
                      color: AppColors.greyColor,
                      size: 30.r,
                    )
                  : Icon(imagePath, color: AppColors.greyColor, size: 24.r),
              10.horizontalSpace,
              Text(
                text,
                style: AppTextStyle.style16Bold.copyWith(
                  color: AppColors.thirdColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
