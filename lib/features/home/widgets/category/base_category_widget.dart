import 'package:flutter/cupertino.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          // border: Border.all(color: AppColors.greyColor),
          borderRadius: BorderRadius.all(
            Radius.circular(
              SizeConfig.responsiveValue(phone: 24.r, tablet: 25.r),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage(imagePath),
              color: AppColors.secondaryColor,
              size: SizeConfig.responsiveValue(phone: 35.sp, tablet: 60.sp),
            ),
            FittedBox(
              child: Text(
                categoryName,
                style: AppTextStyle.style16W500.copyWith(
                  fontSize: SizeConfig.responsiveValue(
                    phone: 15.sp,
                    tablet: 22.sp,
                  ),
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryWidgetWithBorder extends StatelessWidget {
  const CategoryWidgetWithBorder({
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
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor),

          borderRadius: BorderRadius.all(
            Radius.circular(
              SizeConfig.responsiveValue(phone: 24.r, tablet: 25.r),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage(imagePath),
              color: AppColors.greyColor,
              size: SizeConfig.responsiveValue(phone: 50.sp, tablet: 60.sp),
            ),
            8.verticalSpace,
            FittedBox(
              child: Text(
                categoryName,
                style: AppTextStyle.style16W500.copyWith(
                  fontSize: SizeConfig.responsiveValue(
                    phone: 15.sp,
                    tablet: 22.sp,
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

class CategoryPaymentWidget extends StatelessWidget {
  const CategoryPaymentWidget({super.key, this.imagePath, this.onTap});
  final String? imagePath;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.h,
        // padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.all(
            Radius.circular(
              SizeConfig.responsiveValue(phone: 24.r, tablet: 25.r),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //
            if (imagePath != null)
              Image.asset(
                imagePath!,
                // color: AppColors.greyColor,
                fit: BoxFit.fitWidth,
                width: SizeConfig.responsiveValue(phone: 100.w, tablet: 60.sp),
                height: 60.h,
              )
            else ...[
              Icon(
                CupertinoIcons.creditcard_fill,
                size: 30.r,
                color: AppColors.greyColor,
              ),
              8.horizontalSpace,
              FittedBox(
                child: Text(
                  'Card payment',
                  style: AppTextStyle.style16Bold.copyWith(
                    fontSize: SizeConfig.responsiveValue(
                      phone: 20.sp,
                      tablet: 22.sp,
                    ),
                    color: AppColors.greyColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
