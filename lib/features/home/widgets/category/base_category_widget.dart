import 'package:flutter/material.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.categoryName,
    required this.imagePath,
    this.onTap,
  });
  final String categoryName, imagePath;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150.w,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.all(
            Radius.circular(
              SizeConfig.responsiveValue(phone: 50.r, tablet: 25.r),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage(imagePath),
              color: AppColors.greyColor,
              size: SizeConfig.responsiveValue(phone: 35.sp, tablet: 60.sp),
            ),
            FittedBox(
              child: Text(
                categoryName,
                style: AppTextStyle.style16W500.copyWith(
                  fontSize: SizeConfig.responsiveValue(
                    phone: 15.sp,
                    tablet: 21.sp,
                  ),
                  color: AppColors.greyColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
