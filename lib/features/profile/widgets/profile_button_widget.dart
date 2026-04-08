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
    this.color = AppColors.primaryColor,
  });
  final dynamic imagePath;
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  @override
  Widget build(BuildContext context) {
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
            gradient: appGradientHelper,
            border: Border.all(color: AppColors.primaryColor),
          ),
          child: Row(
            children: [
              imagePath.runtimeType != IconData
                  ? ImageIcon(
                      AssetImage(imagePath),
                      color: AppColors.greyColor,
                      size: SizeConfig.responsiveValue(
                        phone: 26.r,
                        tablet: 20.r,
                      ),
                    )
                  : Icon(
                      imagePath,
                      color: AppColors.greyColor,
                      size: SizeConfig.responsiveValue(
                        phone: 26.r,
                        tablet: 20.r,
                      ),
                    ),
              10.horizontalSpace,
              Text(
                text,
                style: AppTextStyle.style14W600.copyWith(
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
